#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Initialize mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --init

# We need install our EasyStack lorax which is modified
# to build ESCore installation iso.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --install ${SERVER_EASYSTACK_REPO}/Packages/lorax-19.6.78-1.el7.1.x86_64.rpm
