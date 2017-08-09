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

# Set the git repo location and a list of required packages.
REPO_LOCATION=git@github.com:easystack
REPO_ARRAY=(lorax anaconda escore-release escore-logos yum qemu-kvm libvirt escore_kernel openvswitch)
