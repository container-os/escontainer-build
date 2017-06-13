#! /bin/bash

if test $# -ne 4; then
  echo "Parameter not right"
  echo "Usage: $0 <file .xml> <local os repo> <local updates repo> <local easystack repo> e.g. $0  c7-x86_64-comps.xml /os /updates /easystack"
  exit 1
fi

if [ `rpm -qa | grep xmlstarlet |wc -l` -eq 0 ] ; then 
  echo "Please install xmlstarlet before executing the script"
  exit 1
fi 

CENTOS_XML=$1
OS_REPO=$2
UPDATE_REPO=$3
EASYSTACK_REPO=$4

RESULT_XML=comps.xml
TMP_XML=tmp.xml
GUI_XML=gui.xml
WORKDIR=`mktemp -d`
CURRENT_DIR=`pwd`

#Delete categorys, we not use them in our iso. 
del_categorys()
{
  SRC_XML="$1"
  xmlstarlet ed -d   /comps/category  $SRC_XML > $WORKDIR/$TMP_XML
  mv -f  $WORKDIR/$TMP_XML $SRC_XML
}

#Get the gui.xml of GUI installing options 
get_gui_envs()
{
  SRC_XML="$1"
  DST_XML="$2"
  rm $DST_XML -f

  python parser-xml.py get_env graphical-server-environment $SRC_XML >> $DST_XML
  python parser-xml.py get_env gnome-desktop-environment $SRC_XML >> $DST_XML
  python parser-xml.py get_env kde-desktop-environment $SRC_XML >> $DST_XML
  python parser-xml.py get_env developer-workstation-environment $SRC_XML >> $DST_XML
}

#Delete install option according to id of <environment>
del_env()
{
  ENV_NAME="$1"
  SRC_XML="$2"
  ENV_NUM=`python parser-xml.py get_env_num $ENV_NAME $SRC_XML`
  xmlstarlet ed -d   /comps/environment[$ENV_NUM]  $SRC_XML > $WORKDIR/$TMP_XML
  mv -f $WORKDIR/$TMP_XML  $SRC_XML
}

#Delete install options with GUI.
del_gui_envs()
{
  SRC_XML="$1"
  del_env graphical-server-environment $SRC_XML
  del_env gnome-desktop-environment $SRC_XML
  del_env kde-desktop-environment $SRC_XML
  del_env developer-workstation-environment $SRC_XML
}

#Delete group according to group id in comps.xml.
del_group()
{
  GROUP_NAME="$1"
  SRC_XML="$2"
  GROUP_NUM=`python parser-xml.py get_group_num $GROUP_NAME $SRC_XML`
  xmlstarlet ed -d   /comps/group[$GROUP_NUM]  $SRC_XML > $WORKDIR/$TMP_XML
  mv -f $WORKDIR/$TMP_XML  $SRC_XML
}

#Add local yum source
add_yum_repo()
{  
  echo 'Add local yum source'

  echo '[escore1]'>> /etc/yum.repos.d/escore.repo
  echo 'name=escore1'>> /etc/yum.repos.d/escore.repo
  echo 'baseurl=file://'$1>> /etc/yum.repos.d/escore.repo
  echo 'enabled=1'>> /etc/yum.repos.d/escore.repo

  if [ $# -gt 1 ] ; then 
    echo ' '>> /etc/yum.repos.d/escore.repo
    echo '[escore2]'>> /etc/yum.repos.d/escore.repo
    echo 'name=escore2'>> /etc/yum.repos.d/escore.repo
    echo 'baseurl=file://'$2>> /etc/yum.repos.d/escore.repo
    echo 'enabled=1'>> /etc/yum.repos.d/escore.repo
  fi 

  if [ $# -gt 2 ] ; then 
    echo ' '>> /etc/yum.repos.d/escore.repo
    echo '[escore3]'>> /etc/yum.repos.d/escore.repo
    echo 'name=escore3'>> /etc/yum.repos.d/escore.repo
    echo 'baseurl=file://'$3>> /etc/yum.repos.d/escore.repo
    echo 'enabled=1'>> /etc/yum.repos.d/escore.repo
  fi 

  yum clean all &>/dev/null
  yum makecache  &>/dev/null
}


########################################################
### Paser c7-x86_64-comps.xml and generate comps.xml ###
########################################################
echo "Paser $CENTOS_XML and generate comps.xml"

cp $CENTOS_XML $WORKDIR/$RESULT_XML

get_gui_envs $WORKDIR/$RESULT_XML  $WORKDIR/$GUI_XML

del_categorys $WORKDIR/$RESULT_XML
del_gui_envs $WORKDIR/$RESULT_XML

cat $WORKDIR/$RESULT_XML | grep '<groupid>'| awk -F '>' '{print $2}'|awk -F '<' '{print $1}' | sort -n| uniq > $WORKDIR/group-list
cat $WORKDIR/$GUI_XML | grep '<groupid>'| awk -F '>' '{print $2}'|awk -F '<' '{print $1}' | sort -n| uniq > $WORKDIR/gui-group-list 

echo 'Delete groups that only belong to gui <environment> option'
cat $WORKDIR/group-list  | while read GROUP_LINE
do
  sed -i /^$GROUP_LINE$/d $WORKDIR/gui-group-list
done

#<group> development/compat-libraries/smart-card be default in all install option. we do not del them
sed -i /^development$/d $WORKDIR/gui-group-list
sed -i /^compat-libraries$/d $WORKDIR/gui-group-list
sed -i /^smart-card$/d $WORKDIR/gui-group-list

cat $WORKDIR/gui-group-list | while read GUI_GROUP_LINE
do
  del_group $GUI_GROUP_LINE $WORKDIR/$RESULT_XML
done

#<group> graphical-admin-tools be delete before used in a category.
del_group graphical-admin-tools $WORKDIR/$RESULT_XML


########################################################
#########         Update os packages         ###########
########################################################
echo "Update os packages with update repo and easystack repo"

#get everything_packages_list from os_repo.
ls -lvt --format=single-column $OS_REPO/Packages/ | grep rpm$ > $WORKDIR/os-packages
while read line
do
  tmp=${line%-*}
  filename=${tmp%-*}

  echo $filename >> $WORKDIR/os-packages-tmp
done < $WORKDIR/os-packages

cat $WORKDIR/os-packages-tmp | sort -n | uniq >  $WORKDIR/os-packages-list
rm  -f $WORKDIR/os-packages-tmp

mv -f /etc/yum.repos.d /etc/yum.repos.d-bak
mkdir -p /etc/yum.repos.d

#add local yum repo (os/update/easystack)
add_yum_repo $OS_REPO $UPDATE_REPO $EASYSTACK_REPO

#create everything_repo
rm -fr $CURRENT_DIR/everything_repo
mkdir -p $CURRENT_DIR/everything_repo/Packages
cd $CURRENT_DIR/everything_repo/Packages/

cat $WORKDIR/os-packages-list | while read os_package
do
  echo 'Download package of everything_repo: '$os_package
  yumdownloader $os_package &>/dev/null
done

#Delete useless packages, we do not use them in our escore.iso.
rm -f \
centos-release-7-3.1611.el7.centos.x86_64.rpm \
\
grub2-2.02-0.44.el7.centos.x86_64.rpm \
grub2-efi-2.02-0.44.el7.centos.x86_64.rpm \
grub2-efi-modules-2.02-0.44.el7.centos.x86_64.rpm \
grub2-tools-2.02-0.44.el7.centos.x86_64.rpm \
\
hyperv-daemons-0-0.29.20160216git.el7.x86_64.rpm \
hyperv-daemons-license-0-0.29.20160216git.el7.noarch.rpm \
hypervfcopyd-0-0.29.20160216git.el7.x86_64.rpm \
hypervkvpd-0-0.29.20160216git.el7.x86_64.rpm \
hypervvssd-0-0.29.20160216git.el7.x86_64.rpm \
\
kernel-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-abi-whitelists-3.10.0-514.6.1.el7.noarch.rpm \
kernel-debug-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-debug-devel-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-devel-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-doc-3.10.0-514.6.1.el7.noarch.rpm \
kernel-headers-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-tools-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-tools-libs-3.10.0-514.6.1.el7.x86_64.rpm \
kernel-tools-libs-devel-3.10.0-514.6.1.el7.x86_64.rpm \
perf-3.10.0-514.6.1.el7.x86_64.rpm \
python-perf-3.10.0-514.6.1.el7.x86_64.rpm \
\
libvirt-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-client-2.0.0-10.el7_3.4.i686.rpm \
libvirt-client-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-config-network-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-config-nwfilter-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-interface-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-lxc-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-network-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-nodedev-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-nwfilter-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-qemu-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-secret-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-driver-storage-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-kvm-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-daemon-lxc-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-devel-2.0.0-10.el7_3.4.i686.rpm \
libvirt-devel-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-docs-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-lock-sanlock-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-login-shell-2.0.0-10.el7_3.4.x86_64.rpm \
libvirt-nss-2.0.0-10.el7_3.4.i686.rpm 

cp -f $EASYSTACK_REPO/Packages/* .
rm -f *debuginfo*.rpm

cd $CURRENT_DIR/everything_repo/
cp  $WORKDIR/$RESULT_XML   $CURRENT_DIR/everything_repo/comps.xml 
createrepo  -g comps.xml ./ -o .

#configure everything_repo as yum source,them we use it to generate escore_repo.
rm -fr /etc/yum.repos.d
mkdir -p /etc/yum.repos.d
add_yum_repo $CURRENT_DIR/everything_repo/

cd $CURRENT_DIR


########################################################
######### Get packages list from  comps.xml  ###########
########################################################

echo "Get packages_list from comps.xml with cmd 'repoquery'"

#get package list of comps.xml, and query their deps with 'repoquery'.
cat  $WORKDIR/$RESULT_XML | grep '<packagereq'| awk -F '>' '{print $2}'| awk -F '<' '{print $1}' | sort -n | uniq > $WORKDIR/tree_root_list
cat $WORKDIR/tree_root_list | while read ROOT_NODE
do
  echo 'Query dependency packages: '$ROOT_NODE
  repoquery --requires --resolve --recursive $ROOT_NODE >> $WORKDIR/packages_deps
done 

while read line
do
  tmp=${line%-*}
  filename=${tmp%-*}

  echo $filename >> $WORKDIR/packages_deps_tmp
done < $WORKDIR/packages_deps

cat $WORKDIR/tree_root_list>>$WORKDIR/packages_deps_tmp
cat $WORKDIR/packages_deps_tmp | sort -n | uniq > $WORKDIR/packages_list

rm -fr $CURRENT_DIR/escore_repo
mkdir -p $CURRENT_DIR/escore_repo/Packages
cd $CURRENT_DIR/escore_repo/Packages/

echo 'Download packages of escore_repo and createrepo'
cat $WORKDIR/packages_list | while read escore_package
do
  echo 'Download package of escore_repo:' $escore_package
  yumdownloader $escore_package &>/dev/null
done
rm -f *i686*.rpm

cd $EASYSTACK_REPO/Packages/
cp -f  \
openvswitch-2.6.1-1.el7.x86_64.rpm \
openvswitch-kmod-2.6.1-1.el7.x86_64.rpm \
python-openvswitch-2.6.1-1.el7.noarch.rpm \
$CURRENT_DIR/escore_repo/Packages/

cd $CURRENT_DIR/escore_repo/
cp  $WORKDIR/$RESULT_XML   $CURRENT_DIR/escore_repo/comps.xml 
createrepo -g comps.xml ./ -o .

cd $CURRENT_DIR

echo 'Restore configuration of yum in /etc/yum.repos.d'
rm -rf /etc/yum.repos.d
mv /etc/yum.repos.d-bak/ /etc/yum.repos.d
rm -rf $WORKDIR
