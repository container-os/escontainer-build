#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Initialize mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --init
