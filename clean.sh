#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Scrub all mock cache stuff.
# Note that this operation needs to be done
# before escl-7-x86_64.cfg has been deleted.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --scrub=all

# Clean up configuration settings.
rm escl-7-x86_64.cfg
rm common.sh
rm escore-packages-list
rm escore-comps.xml

# Clean up the directories we made.
rm -rf ./easystack/

# Clean up the iso image.
rm escore.iso

# It requires root privilege to remove mock environment.
echo "Removing chroot directory requires root privilege."
echo "Try to sudo and remove it manually."
