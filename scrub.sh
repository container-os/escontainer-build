#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Scrub all mock cache stuff.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --scrub=all
