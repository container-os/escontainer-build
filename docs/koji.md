# Koji [draft]

Koji 运用tag的观念让我们可以管理package与repo之间的关联性

- Package 产出流程
  * Package (tag) > Build (tag)> RPM (repo)
- Package 可以订定 tag
- 每版Build 需指定 产出之 tag


## koji repos
目前我们维护的repos每五分钟, 会被rsync至mirror.easystack.io
```
[koji@se129 ~]$ crontab -l
*/5 * * * * rsync -avz -e ssh --progress  /srv/koji/ mirror.easystack.io:/var/www/html/koji-escl/
```
koji-escl 目前设定 /etc/httpd/conf/httpd.conf IndexIgnore

```
http://mirror.easystack.io/ESCL/el7.alpha/

es7
 ├─ es7-build: include external repos (not export)
 ├─ es7-os: es cloud os
 ├─ es7-extras
 ├─ es7-atomic: atomic k8s
 └─ es7-koji: koji related packages


$ koji list-tag-inheritance es7-build
es7-build (6)
  └─es7-koji (12)
     └─es7 (3)

```

## tag and target

- Tag 可以代表一個repo
 * tag 保存在数据库中而不是磁盘文件系统中
 * tag 支持多重继承
 * 每个 tag 有它自己有效的软件包列表（软件包列表可以被其他的 tag 继承）
   - 透過 regen-repo 可以建制tag repo
 * 我们可以根据 tag 为软件包设置不同的所有者（所有者关系也可以被其他 tag 继承）
 * tag 继承过程是可以配置的
 * 当您编译软件包时，您应该指定一个 target 而不是一个 tag
- Target 定義 destination tag 所需要的 buildroot (or build tag)
 * 定義 Build tag 與 Target get.
   - Build tag 可能含有 external repo 與 build group
 * 一个 target 表明了软件包的编译过程应该在哪里进行()，编译生成的软件包应该放入哪个 tag 中。当 tag 的名称随着所发布系统的版本变化后， target 的名称仍然可以保持不变。



## build and tag

koji block-pkg
koji untag-build

## build rpm

https://docs.pagure.org/koji/server_bootstrap/#bootstrapping-a-new-koji-build-environment

### build from scm
```
koji build es7-os git+ssh://git@10.60.0.129/rpms/zip.git#origin/c7
```
### build from srpm

```
koji build es7-os $srpm
```

### import rpm
koji import --create-build [package]

## koji env
### 

$ koji regen-repo xxx

### koji list-groups
```
koji list-groups es7-build
build  [es7-build]
  bash: None, mandatory  [es7-build]
  bzip2: None, mandatory  [es7-build]
  coreutils: None, mandatory  [es7-build]
  cpio: None, mandatory  [es7-build]
  diffutils: None, mandatory  [es7-build]
  findutils: None, mandatory  [es7-build]
  gawk: None, mandatory  [es7-build]
  gcc: None, mandatory  [es7-build]
  gcc-c++: None, mandatory  [es7-build]
  grep: None, mandatory  [es7-build]
  gzip: None, mandatory  [es7-build]
  info: None, mandatory  [es7-build]
  make: None, mandatory  [es7-build]
  patch: None, mandatory  [es7-build]
  redhat-rpm-config: None, mandatory  [es7-build]
  rpm-build: None, mandatory  [es7-build]
  sed: None, mandatory  [es7-build]
  shadow-utils: None, mandatory  [es7-build]
  tar: None, mandatory  [es7-build]
  unzip: None, mandatory  [es7-build]
  util-linux-ng: None, mandatory  [es7-build]
  which: None, mandatory  [es7-build]
srpm-build  [es7-build]
  bash: None, mandatory  [es7-build]
  cvs: None, mandatory  [es7-build]
  gnupg: None, mandatory  [es7-build]
  make: None, mandatory  [es7-build]
  redhat-rpm-config: None, mandatory  [es7-build]
  rpm-build: None, mandatory  [es7-build]
  rpmdevtools: None, mandatory  [es7-build]
  shadow-utils: None, mandatory  [es7-build]
  wget: None, mandatory  [es7-build]
```

```
[shawn@se129 escore-build]$ koji regen-repo --help
Usage: koji regen-repo [options] <tag>
(Specify the --help global option for a list of other help options)

Options:
  -h, --help       show this help message and exit
  --target         Interpret the argument as a build target name
  --nowait         Don't wait on for regen to finish
  --debuginfo      Include debuginfo rpms in repo
  --source, --src  Include source rpms in the repo
```


https://fedoraproject.org/wiki/Taskotron
https://pagure.io/mash tool to create repos from koji tags
repoclosure  -  display  a  list of unresolved dependencies for a yum repository
