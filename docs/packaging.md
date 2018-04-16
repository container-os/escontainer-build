## How to use escontainer-build.

We use Makefile to help us maintain ostree repo.
```
# If you don't have escontainer-build, please install escontainer-build scripts by yum.
# install atomic related packages, we can found those packages in below repo.
yum-config-manager --add-repo http://buildlogs.centos.org/centos/7/atomic/x86_64/Packages
# escontainer-build scripts are stored at /opt/escontainer-build
yum install escontainer-build

# To run ostree commands
cd /opt/escontainer-build

# cp envrc.example to envrc and edit it

make help # list common commands and usage
```

## Maintain escontainer-build

```
# install rpmbuild
sudo yum install rpm-build

## build scripts by source code
git clone git@github.com:container-os/escontainer-build.git
cd escontainer-build/

# if you want to create new version, use git tag to define new version
git tag v<new-version>
git push origin v<new-version>

# build results: .build/
make rpm
```
