text
lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC

auth --useshadow --passalgo=sha512
selinux --enforcing

{% if OSTREE_ROOT_LOCK|default("false") == "true" %}
rootpw --lock --iscrypted locked
{% else %}
rootpw --plaintext {{ OSTREE_DEFAULT_PASSWORD }}
{% endif %}

{% if OSTREE_ENABLE_DEFAULT_USER|default("false") == "true" %}
# set default user
user --name=es --password={{ OSTREE_DEFAULT_PASSWORD }} --groups=wheel
{% endif %}

firewall --disabled

bootloader --timeout=1 --append="no_timer_check console=tty1 console=ttyS0,115200n8"

network --bootproto=dhcp --onboot=on --device=eth0 --activate
services --enabled=sshd,rsyslog,cloud-init,cloud-init-local,cloud-config,cloud-final
# We use NetworkManager, and Avahi doesn't make much sense in the cloud
services --disabled=network,avahi-daemon

zerombr
clearpart --initlabel --all

part /boot --size=300 --fstype="xfs"
#part pv.01 --size=1500 --grow

part pv.01 --size=8000
part pv.02 --size=4000 --grow

volgroup atomicos pv.01
volgroup docker pv.02

logvol / --percent=100 --fstype="xfs" --name=root --vgname=atomicos
logvol /var/lib/docker --percent=5 --fstype="xfs" --name=docker --vgname=docker


# Equivalent of %include fedora-repo.ks
ostreesetup --osname="{{ OSTREE_REPO_NAME }}" --remote="{{ OSTREE_REPO_NAME }}" --ref="{{ OSTREE_REPO_REF }}" --url="http://{{ OSTREE_SERV_HOST }}:{{OSTREE_SERV_PORT }}" --nogpg

reboot

%post --erroronfail

# Due to an anaconda bug (https://github.com/projectatomic/rpm-ostree/issues/42)
# we need to install the repo here.
# We install our escnl public repo

ostree remote delete es-atomic-host
ostree remote add --set=gpg-verify=false es-atomic-host http://mirror.easystack.cn/ESCL/7.4.1708/atomic/x86_64/repo/ es-atomic-host/7/x86_64/standard

# For RHEL, it doesn't make sense to have a default remote configuration,
# because you need to use subscription manager.
# rm /etc/ostree/remotes.d/*.conf

# echo 'unconfigured-state=This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.' >> $(ostree admin --print-current-dir).origin

# Configure docker-storage-setup to resize the partition table on boot
# https://github.com/projectatomic/docker-storage-setup/pull/25
# We move the entire /etc/sysconfig/docker-storage-setup file to
# add-files/docker-storage-setup.cfg

# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1193590
cp /etc/skel/.bash* /var/roothome

# Anaconda is writing a /etc/resolv.conf from the generating environment.
# The system should start out with an empty file.
truncate -s 0 /etc/resolv.conf

{% if OSTREE_SSH_PASSWD == "true" %}
sed -i '/^ssh_pwauth/s/0/1/ ; /^ssh_pwauth/s/false/true/' /etc/cloud/cloud.cfg
{% endif %}

{% if OSTREE_ROOT_LOCK|default("false") == "false" %}
sed -i '/^disable_root/s/1/0/ ; /^disable_root/s/true/false/' /etc/cloud/cloud.cfg
sed -i '/lock_passwd/s/true/false/' /etc/cloud/cloud.cfg
{% endif %}

# older versions of livecd-tools do not follow "rootpw --lock" line above
# https://bugzilla.redhat.com/show_bug.cgi?id=964299

{% if OSTREE_ROOT_LOCK|default("false") == "true" %}
passwd -l root
{% endif %}

# remove the user anaconda forces us to make
#userdel -r none

# If you want to remove rsyslog and just use journald, remove this!
echo -n "Disabling persistent journal"
rmdir /var/log/journal/ 
echo . 

echo -n "Getty fixes"
# although we want console output going to the serial console, we don't
# actually have the opportunity to login there. FIX.
# we don't really need to auto-spawn _any_ gettys.
sed -i '/^#NAutoVTs=.*/ a\
NAutoVTs=0' /etc/systemd/logind.conf

echo -n "Network fixes"
# initscripts don't like this file to be missing.
cat > /etc/sysconfig/network << EOF
NETWORKING=yes
NOZEROCONF=yes
EOF

# For cloud images, 'eth0' _is_ the predictable device name, since
# we don't want to be tied to specific virtual (!) hardware
rm -f /etc/udev/rules.d/70*
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

# simple eth0 config, again not hard-coded to the build hardware
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

# generic localhost names
cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

EOF
echo .


# Because memory is scarce resource in most cloud/virt environments,
# and because this impedes forensics, we are differing from the Fedora
# default of having /tmp on tmpfs.
echo "Disabling tmpfs for /tmp."
systemctl mask tmp.mount

# make sure firstboot doesn't start
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

echo "Removing random-seed so it's not the same in every image."
rm -f /var/lib/random-seed

# Additional  virt drivers vmware and hyperv
pushd /etc/dracut.conf.d
# Enable VMWare PVSCSI support for VMWare Fusion guests
echo 'add_drivers+="mptspi vmw_pvscsi "' > vmware-fusion-drivers.conf
# Enable HyperV PVSCSI drivers
echo 'add_drivers+="hv_storvsc hv_netvsc "' > hyperv-drivers.conf
popd
# Rerun dracut for the installed kernel (not the running kernel):
KERNEL_VERSION=$(rpm -q kernel --qf '%{version}-%{release}.%{arch}\n')
dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION

echo "Packages within this cloud image:"
echo "-----------------------------------------------------------------------"
rpm -qa
echo "-----------------------------------------------------------------------"
# Note that running rpm recreates the rpm db files which aren't needed/wanted
rm -f /var/lib/rpm/__db*

# Anaconda is writing a /etc/resolv.conf from the generating environment.
# The system should start out with an empty file.
truncate -s 0 /etc/resolv.conf

# clean-up
echo "Removing random-seed so it's not the same in every image."
rm -f /var/lib/random-seed

echo "Removing /root/anaconda-ks.cfg"
rm -f /root/anaconda-ks.cfg

# rootpw should generate /etc/.pwd.lock
# otherwise, the security context generated by cloud-init(systemd) would be
#
# Workaround to fix .pwd.lock issue EAS-12853
# the /etc/.pwd.lock might be created out of built env,
# that cause the security context is wrong.
# -rw-------. root root system_u:object_r:etc_t:s0       /etc/.pwd.lock
# ls -Z /etc/.pwd.lock
# -rw-r--r--. root root unconfined_u:object_r:passwd_file_t:s0 /etc/.pwd.lock
# -rwxr-xr-x. root root system_u:object_r:passwd_exec_t:s0 /usr/sbin/chpasswd

echo STORAGE_DRIVER=overlay2 >> /etc/sysconfig/docker-storage-setup

touch /etc/.pwd.lock
touch /etc/.docker.dd.log

systemctl stop docker
umount /dev/mapper/docker-docker
mkfs.xfs -f /dev/mapper/docker-docker

curl http://{{ OSTREE_SERV_HOST }}:8800/docker.dd.gz | gzip -dc | dd of=/dev/mapper/docker-docker bs=64K
%end
