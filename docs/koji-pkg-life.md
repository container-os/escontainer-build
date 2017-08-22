# ES koji package build cycle

quick example:

rpm from git repo:
```
 $ koji add-pkg es7-os libreport --owner=admin
 $ koji build es7-os git+ssh://git@10.60.0.129/rpms/libreport.git#origin/c7
```

rpm from srpm:
```
 $ koji add-pkg es7-os libreport --owner=admin
 $ curl -O http://mirror.easystack.io/ESCL/7.3.1611/os/Source/SPackages/yum-3.4.3-150.el7.centos.es.1.src.rpm
 $ koji build es7-os yum-3.4.3-150.el7.centos.es.1.src.rpm
```

directly import srpm/rpm:
```
 $ koji add-pkg es7-os libreport --owner=admin
 $ koji import junit-4.11-8.el7.noarch.rpm junit-4.11-8.el7.src.rpm
 $ koji tag-build es7-build-import junit-4.11-8.el7
```
Importing an rpm without srpm 
```
 $ koji add-pkg es7-os libreport --owner=admin
 $ koji import --create-build [package]
 $ koji tag-build es7-build-import junit-4.11-8.el7
```

## rpm spec 管理
我们用gitea repo 来维护 rpm spec
 - Centos: http://git.centos.org/ branch c7
 - Fedora: http://pkgs.fedoraproject.org/ master and tag (like fc27)
 - 自行修改 branch name: es7-xxx

CentOS与Fedora在维护rpm spec上的管理也有些许不同
 1. branch (CentOS) vs tag (Fedora)
 2. centos-git-common vs fedpkg or fedpkg-minimal
 3. SPECS/SOURCES vs spec and source files
 4. tar ball SOURCES 管理机制

目前我们会先判断spec型态是否為 CentOS 或是 Fefora在另外处理 http://10.60.0.129:3000/rpms/common (以 centos-git-common 為基础新增spectool.sh, 考虑并入escore-build管理)

Example:
```
 $ git clone --mirror https://git.centos.org/r/rpms/git.git 
 $ cd git.git
 $ git remote add es git@10.60.0.129:rpms/git.git
 $ git fetch --all
 $ git push es --all
```
而我们在使用 koji build时必须指定branch或tag

branch
```
koji build es7-os git+ssh://git@10.60.0.129/rpms/java-1.6.0-openjdk.git#origin/c7
```

tag
```
koji build es7-os git+ssh://git@10.60.0.129/rpms/java-1.6.0-openjdk.git#tag_abc
```

## koji build 环境

```
```
## 
