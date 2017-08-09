#!/bin/bash

# Run the common jobs first.
source ./common.sh

# === Step 1: Preparation of escore_repo content ===

# In order to create iso image, we create /buildiso directory relative to chroot.
# We also create /buildiso/escore_repo and /buildiso/escore_repo/Packages for the preparation of escore_repo construction.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --chroot "rm -rf /buildiso; mkdir /buildiso"
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --chroot "mkdir /buildiso/escore_repo; mkdir /buildiso/escore_repo/Packages"

# Under mock environment, we need to copy escore-packages-list and escore-comps.xml into it.
# The list contains all the packages we would like to use yumdownloader to download it.
# The xml file is the group file which will be used for creating repodata.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyin escore-packages-list /buildiso/packages-list
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyin escore-comps.xml /buildiso/escore_repo/comps.xml

# Use yumdownloader to download all the rpm files under mock environment.
# It takes yum repo settings specified in escl-7-x86_64.cfg so that
# we can make sure we will get the up-to-date packages.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --cwd="/buildiso/escore_repo/Packages" \
--chroot 'cat /buildiso/packages-list | while read os_package; do echo Downloading ${os_package} ...; yumdownloader ${os_package}; done'

# Create repodata with corresponding group file.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --cwd="/buildiso/escore_repo" \
--chroot 'createrepo -g comps.xml ./ -o ./'

# === Step 2: Use lorax to create ESCore iso image ===

# We need install our EasyStack lorax which is modified to build ESCore installation iso.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --install ${SERVER_OS_REPO}/Packages/lorax-19.6.78-1.el7.centos.es.1.x86_64.rpm

# Issue the lorax command to create iso image.
# Instead of using --shell, we use --chroot because it can be logged
# under /var/lib/mock/ and the --cwd is able to take effect.
# Also, our lorax support --customfield option and we can use it to specify the escore rpm files
# which will be included in the iso image so that we have local media repository at installation stage.
# Note that we use vault repository because it contains complete development and GUI rpm files
# for lorax to create installation environment.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --cwd="/buildiso" \
--chroot "lorax -p 'EasyStack Cloud Linux' -v 7.3 -r 7.3 -s ${VAULT_OS_REPO} -s ${VAULT_EASYSTACK_REPO} -s ${VAULT_ATOMIC_REPO} --isfinal --customfield /buildiso/escore_repo /buildiso/result"

# Finally we copy the result iso out of mock environment.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --copyout /buildiso/result/images/boot.iso escore.iso
