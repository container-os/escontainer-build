#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Physically enter the mock shell environment.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --shell
