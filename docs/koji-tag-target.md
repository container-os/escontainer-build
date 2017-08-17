
```
$ koji list-tags
es7
es7-atomic
es7-build
es7-extras
es7-koji
es7-os
```


```
$ koji list-targets
Name                           Buildroot                      Destination
---------------------------------------------------------------------------------------------
es7                            es7-build                      es7
es7-atomic                     es7-build                      es7-atomic
es7-extras                     es7-build                      es7-extras
es7-koji                       es7-build                      es7-koji
es7-os                         es7-build                      es7-os
```

```
$ koji list-groups es7-build
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

$ koji add-group-pkg es7-build srpm-build git curl which fedpkg-minimal
