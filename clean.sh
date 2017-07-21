#!/bin/bash

# Scrub mock cache.
echo "Scrubing mock cache stuff..."
if [ -e common.sh ]; then
  # Run the common jobs first.
  source ./common.sh

  # Scrub all mock cache stuff.
  # Note that this operation needs to be done
  # before escl-7-x86_64.cfg has been deleted.
  /usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --scrub=all
fi

# Clean up configuration settings.
echo "Cleaning up configuration settings..."
[ -e escl-7-x86_64.cfg ] && rm escl-7-x86_64.cfg
[ -e common.sh ] && rm common.sh
[ -e escore-packages-list ] && rm escore-packages-list
[ -e escore-comps.xml ] && rm escore-comps.xml

# Clean up the directories we made.
echo "Removing easystack repo..."
rm -rf ./easystack/

# Clean up the iso image.
echo "Removing escore.iso image..."
[ -e escore.iso ] && rm escore.iso

# It requires root privilege to remove mock environment.
echo ""
echo "Removing chroot directory requires root privilege."
echo "Try 'sudo rm -rf ./chroot/' command to remove it manually."
