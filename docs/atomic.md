# Esaystack ContainerOS build scripts

## Common commands

### get started
```
# cp envrc.example to envrc and edit it
please see the detail comment for each entry in example file
```

### compose repo
```
# export OSTREE_REPO=/home/ostree
# export OSTREE_REPO_NAME=escontos
# export OSTREE_BUILD_SCRIPTS_DIR=/opt/escontos-buildscripts

make atomic_compose >> for testing
make atomic_prod_compose >> for production

```

### create guest image
```
make atomic_image
```

## build atomic releated targets need packages from remote http repo server, so please make sure
the below web server can be accessed.

```
http://[server]/ESCL/vault.es/os
http://[server]/ESCL/vault.es/updates
http://[server]/ESCL/7.3.1611/atomic/atomic-anaconda/ (used for make atmoic_image)
``

# sig-atomic-buildscripts

This contains metadata and build scripts for the CentOS Atomic Host
Images.  For more information, see
http://wiki.centos.org/SpecialInterestGroup/Atomic

For information on the build and release process, see
https://wiki.centos.org/SpecialInterestGroup/Atomic/ReleaseSOP

### Contributing

Discuss on https://github.com/container-os/escontainer-build
