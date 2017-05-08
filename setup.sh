#!/bin/bash

# User must specify one configuration.
# The available confiurations can be found under ./config/ directory.
# Then we will copy the settings to current location so that
# other shell scripts are able to use them.
if [ -z ${1} ]; then
  echo "Please specify a configuration! Such as 'localhost' or '10.60.0.129'."
  echo "Check ./config/ for the available configurations."
  exit 1
fi

cp `pwd`/config/${1}/centos-7-x86_64.cfg .
cp `pwd`/config/${1}/common.sh .
echo "Copying settings ...... DONE."

# Run the common jobs first.
source ./common.sh

# Initialize mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --init
