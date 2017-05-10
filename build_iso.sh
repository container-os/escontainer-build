#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Use rsync to sync ESCore packages for iso image.
rsync -avrtHu --delete rsync://${SERVER}/escore_repo ./escore_repo

# In order to create iso image, we create buildiso directory relative to chroot.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --chroot "rm -rf /buildiso; mkdir /buildiso"

# Copy the packages into mock environment and those rpm files will be included in the iso image.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyin escore_repo/ /buildiso/escore_repo

# We need install our EasyStack lorax which is modified to build ESCore installation iso.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --install ${SERVER_EASYSTACK_REPO}/Packages/lorax-19.6.78-1.el7.1.x86_64.rpm

# Issue the lorax command to create iso image.
# Instead of using --shell, we use --chroot because it can be logged
# under /var/lib/mock/ and the --cwd is able to take effect.
# Also, our lorax support --customfield option and we can use it to specify the escore rpm files
# which will be included in the iso image so that we have local media repository at installation stage.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --cwd="buildiso" \
--chroot "lorax -p ESCore -v 7.3 -r 7.3 -s ${SERVER_OS_REPO} -s ${SERVER_EASYSTACK_REPO} --isfinal --customfield /buildiso/escore_repo /buildiso/result"

# Finally we copy the result iso out of mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyout /buildiso/result/images/boot.iso escore.iso
