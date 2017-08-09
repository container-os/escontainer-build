# Esaystack ContainerOS build scripts (escontos-buildscripts) (obsolete)

----
We're merging escontos-buildscripts into escore-build.
----

## How to use escontos-buildscripts.

We use Makefile to help us maintain ostree repo.
```
# If you don't have escontos-buildscripts, please install escontos-buildscripts by yum.
# install atomic related packages, we are planing to maintain those packages.
yum-config-manager --add-repo http://buildlogs.centos.org/centos/7/atomic/x86_64/Packages
# rpm-ostree buildscripts are stored at /opt/escontos-buildscripts
yum install escontos-buildscripts

# To run ostree commands
cd /opt/escontos-buildscripts

# cp envrc.examle to envrc and edit it

make help # list common commands and usage
```

## Common commands

### compose repo
```
# export OSTREE_REPO=/home/ostree
# export OSTREE_REPO_NAME=escontos
# export OSTREE_BUILD_SCRIPTS_DIR=/opt/escontos-buildscripts

make compose
```

### create guest image
```
make image

IMGDIR=/tmp/disc make image # change default result image dir
```

## Maintain escontos-buildscripts 

```
# install rpmbuild
sudo yum install rpm-build

git clone git@github.com:easystack/containeros-buildscripts.git
cd containeros-buildscripts

# if you want to create new version, use git tag to define new version
git tag v<new-version>
git push origin v<new-version>

# build results: .build/
make rpm
```

# sig-atomic-buildscripts

This contains metadata and build scripts for the CentOS Atomic Host
Images.  For more information, see
http://wiki.centos.org/SpecialInterestGroup/Atomic

For information on the build and release process, see
https://wiki.centos.org/SpecialInterestGroup/Atomic/ReleaseSOP

### Contributing

Discuss on http://lists.centos.org/pipermail/centos-devel/



