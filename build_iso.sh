#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Use rsync to sync ESCore packages for iso image.
rsync -avrtHu --delete rsync://localhost/escore_repo ./escore_repo

# In order to create iso image, we create buildiso directory relative to chroot.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --chroot "rm -rf /buildiso; mkdir /buildiso"

# Copy the packages into mock environment and we will use them to create installation iso image.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyin escore_repo/ /buildiso/repo

# Issue the lorax command to create iso image.
# Instead of using --shell, we use --chroot because it can be logged
# under /var/lib/mock/ and the --cwd is able to take effect.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --cwd="buildiso" \
--chroot "lorax -p ESCore -v 7.3 -r 7.3 -s http://localhost/ESCore/CentOS/7.3.1611/os/x86_64 -s http://localhost/ESCore/CentOS/7.3.1611/easystack/x86_64 --isfinal /buildiso/result"

# Finally we copy the result iso out of mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyout /buildiso/result/images/boot.iso escore.iso
