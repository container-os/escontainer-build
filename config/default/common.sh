#!/bin/bash

# After mock 1.3.4, its implementation does not consider encoding well.
# So we may have UnicodeEncodeError problem if our locale is UTF-8 or something else.
# Our solution here is to force locale to be en_US and this is able to
# make our escore-build process more general on any other machines.
export LANG=en_US

# Assign the server that is supposed to have http and rsync services.
# In additon, several repo locations are also provided based on SERVER.
# Those fields will be used in setup.sh and build_iso.sh for accessing
# all the rpm packages.
SERVER=localhost
SERVER_OS_REPO=http://${SERVER}/ESCore/CentOS/7.3.1611/os/x86_64/
SERVER_UPDATES_REPO=http://${SERVER}/ESCore/CentOS/7.3.1611/updates/x86_64/
SERVER_EASYSTACK_REPO=http://${SERVER}/ESCore/CentOS/7.3.1611/easystack/x86_64/

# Set the git repo location and a list of required packages.
REPO_LOCATION=git@github.com:easystack
REPO_ARRAY=(lorax anaconda escore-release escore-logos yum qemu-kvm libvirt escore_kernel)
