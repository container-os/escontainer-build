#!/bin/bash

# After mock 1.3.4, its implementation does not consider encoding well.
# So we may have UnicodeEncodeError problem if our locale is UTF-8 or something else.
# Our solution here is to force locale to be en_US and this is able to
# make our escore-build process more general on any other machines.
export LANG=en_US

# Assign the server that is supposed to have httpd service.
# In additon, several repo locations are also provided based on SERVER.
# Those fields will be used in setup.sh and build_iso.sh for accessing
# all the rpm packages.
SERVER=mirror.easystack.io
USERNAME=escore
PASSWORD=escore

# A Cloud Linux repository that contains cloud-related rpm files.
# We use it to initialize mock environment and create escore_repo
# for making the ISO image.
SERVER_OS_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/7.3.1611/os/x86_64/
SERVER_UPDATES_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/7.3.1611/updates/x86_64/

# A vault repository that contains complete rpm files is required.
# At least it includes development and GUI stuff that supports
# lorax to construct installation environment.
VAULT_OS_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/vault.es/os/x86_64/
VAULT_UPDATES_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/vault.es/updates/x86_64/
VAULT_EASYSTACK_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/vault.es/easystack/x86_64/
VAULT_ATOMIC_REPO=http://${USERNAME}:${PASSWORD}@${SERVER}/ESCL/vault.es/atomic/x86_64/

# We prepare an array that contains all the possible repo locations.
#   REPO_LOCATION_ARRAY[0] ==> git@github.com:easystack
#   REPO_LOCATION_ARRAY[1] ==> git@10.60.0.129:ESCL_LinuxDistroRelated
# This array is to provide a index <--> location mapping.
REPO_LOCATION_ARRAY=\
(
  git@github.com:easystack
  git@10.60.0.129:ESCL_LinuxDistroRelated
)

# We also use an array to descirbe required packages.
# Each element is in the syntax: INDEX:PACKAGE[/BRANCH]
#   INDEX is the index to REPO_LOCATION_ARRAY
#   PACKAGE is the package name
#   BRANCH is the package's branch name
#
# Example 1: "0:qemu-kvm"
#            --> git clone git@github.com:easystack/qemu-kvm.git

# Example 2: "1:lorax/test-dev
#            --> git clone git@10.60.0.129:ESCL_LinuxDistroRelated/lorax.git -b test-dev
REPO_PACKAGE_ARRAY=\
(
  1:escore-release
  1:escore-logos
  1:escore-indexhtml
  1:escore-lib32
  1:lorax
  1:anaconda
  1:yum
  1:yum-utils
  1:cloud-init
  1:initial-setup
  1:dhcp
  1:httpd
  1:ipa
  1:kabi-yum-plugins
  1:openssl098e
  1:redhat-lsb
  1:redhat-rpm-config
  1:sos
  1:libreport
  1:xulrunner
  0:escore_kernel
  0:qemu-kvm
  0:libvirt
  0:openvswitch
)
