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

# Now we are supposed to have centos-7-x86_64.cfg and common.sh files.
# We can start to initialize mock environment.

# Run the common jobs first.
source ./common.sh

# Initialize mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --init

# We need install our EasyStack lorax which is modified
# to build ESCore installation iso.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --install ${SERVER_EASYSTACK_REPO}/Packages/lorax-19.6.78-1.el7.1.x86_64.rpm
