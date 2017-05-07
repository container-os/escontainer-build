#!/bin/bash

# After mock 1.3.4, its implementation does not consider encoding well.
# So we may have UnicodeEncodeError problem if our locale is UTF-8 or something else.
# Our solution here is to force locale to be en_US and this is able to
# make our escore-build process more general on any other machines.
export LANG=en_US

# Assign the server that is supposed to have http and rsync services.
# This field will be used in setup.sh and build_iso.sh for accessing
# all the rpm packages.
SERVER=10.60.0.129

# Make an array that includes all the EasyStack packages.
REPO_ARRAY=(lorax anaconda centos-release centos-logos yum)
