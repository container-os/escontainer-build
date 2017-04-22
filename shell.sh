#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Physically enter the mock shell environment.
/usr/bin/mock -r centos-7-x86_64.cfg --shell --rootdir `pwd`/chroot/
