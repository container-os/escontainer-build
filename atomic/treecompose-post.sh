#!/usr/bin/env bash

set -e
set -x
# suid
chmod 4755 /usr/sbin/busybox

# delete the same name *bin* binary file

busybox rm -f /usr/bin/[
busybox rm -f /usr/bin/[[
busybox rm -f /usr/bin/ar
busybox rm -f /usr/bin/ash
busybox rm -f /usr/bin/awk
busybox rm -f /usr/bin/base64
busybox rm -f /usr/bin/basename
busybox rm -f /usr/bin/bbconfig
busybox rm -f /usr/bin/beep
busybox rm -f /usr/bin/bunzip2
busybox rm -f /usr/bin/bzcat
busybox rm -f /usr/bin/bzip2
busybox rm -f /usr/bin/cal
busybox rm -f /usr/bin/cat
busybox rm -f /usr/bin/catv
busybox rm -f /usr/bin/chattr
# busybox rm -f /usr/bin/chgrp
busybox rm -f /usr/bin/chmod
# busybox rm -f /usr/bin/chown
busybox rm -f /usr/bin/chpst
busybox rm -f /usr/bin/chrt
busybox rm -f /usr/bin/chvt
busybox rm -f /usr/bin/cksum
busybox rm -f /usr/bin/clear
busybox rm -f /usr/bin/cmp
busybox rm -f /usr/bin/comm
busybox rm -f /usr/bin/conspy
# busybox rm -f /usr/bin/cp
# busybox rm -f /usr/bin/cpio
# busybox rm -f /usr/bin/crontab
busybox rm -f /usr/bin/cryptpw
busybox rm -f /usr/bin/cttyhack
busybox rm -f /usr/bin/cut
busybox rm -f /usr/bin/date
busybox rm -f /usr/bin/dc
busybox rm -f /usr/bin/dd
busybox rm -f /usr/bin/deallocvt
# busybox rm -f /usr/bin/df
busybox rm -f /usr/bin/diff
busybox rm -f /usr/bin/dirname
busybox rm -f /usr/bin/dmesg
busybox rm -f /usr/bin/dnsdomainname
busybox rm -f /usr/bin/dos2unix
busybox rm -f /usr/bin/du
busybox rm -f /usr/bin/dumpkmap
busybox rm -f /usr/bin/dumpleases
busybox rm -f /usr/bin/echo
busybox rm -f /usr/bin/ed
busybox rm -f /usr/bin/egrep
busybox rm -f /usr/bin/eject
busybox rm -f /usr/bin/env
busybox rm -f /usr/bin/envdir
busybox rm -f /usr/bin/envuidgid
busybox rm -f /usr/bin/expand
busybox rm -f /usr/bin/expr
busybox rm -f /usr/bin/false
busybox rm -f /usr/bin/fdflush
busybox rm -f /usr/bin/fgconsole
busybox rm -f /usr/bin/fgrep
# busybox rm -f /usr/bin/find
busybox rm -f /usr/bin/flock
busybox rm -f /usr/bin/fold
busybox rm -f /usr/bin/free
busybox rm -f /usr/bin/fsync
busybox rm -f /usr/bin/ftpget
busybox rm -f /usr/bin/ftpput
busybox rm -f /usr/bin/fuser
busybox rm -f /usr/bin/getopt
busybox rm -f /usr/bin/grep
busybox rm -f /usr/bin/groups
busybox rm -f /usr/bin/gunzip
# busybox rm -f /usr/bin/gzip
busybox rm -f /usr/bin/hd
busybox rm -f /usr/bin/head
busybox rm -f /usr/bin/hexdump
busybox rm -f /usr/bin/hostid
busybox rm -f /usr/bin/hostname
busybox rm -f /usr/bin/hush
# busybox rm -f /usr/bin/id
busybox rm -f /usr/bin/install
busybox rm -f /usr/bin/ionice
busybox rm -f /usr/bin/iostat
busybox rm -f /usr/bin/ipcalc
busybox rm -f /usr/bin/ipcrm
busybox rm -f /usr/bin/ipcs
busybox rm -f /usr/bin/kbd_mode
busybox rm -f /usr/bin/kill
busybox rm -f /usr/bin/killall
busybox rm -f /usr/bin/last
busybox rm -f /usr/bin/less
busybox rm -f /usr/bin/linux32
busybox rm -f /usr/bin/linux64
busybox rm -f /usr/bin/linuxrc
# busybox rm -f /usr/bin/ln
busybox rm -f /usr/bin/logger
# busybox rm -f /usr/bin/login
busybox rm -f /usr/bin/logname
busybox rm -f /usr/bin/lpq
busybox rm -f /usr/bin/lpr
# busybox rm -f /usr/bin/ls
busybox rm -f /usr/bin/lsattr
busybox rm -f /usr/bin/lsof
busybox rm -f /usr/bin/lspci
busybox rm -f /usr/bin/lsusb
busybox rm -f /usr/bin/lzcat
busybox rm -f /usr/bin/lzma
busybox rm -f /usr/bin/lzop
busybox rm -f /usr/bin/lzopcat
busybox rm -f /usr/bin/makemime
busybox rm -f /usr/bin/man
busybox rm -f /usr/bin/md5sum
busybox rm -f /usr/bin/mesg
busybox rm -f /usr/bin/microcom
busybox rm -f /usr/bin/mkdir
busybox rm -f /usr/bin/mkfifo
busybox rm -f /usr/bin/mknod
busybox rm -f /usr/bin/mkpasswd
# busybox rm -f /usr/bin/mktemp
busybox rm -f /usr/bin/more
# busybox rm -f /usr/bin/mount
# busybox rm -f /usr/bin/mountpoint
busybox rm -f /usr/bin/mpstat
busybox rm -f /usr/bin/msh
busybox rm -f /usr/bin/mt
# busybox rm -f /usr/bin/mv
busybox rm -f /usr/bin/nc
busybox rm -f /usr/bin/netstat
busybox rm -f /usr/bin/nice
busybox rm -f /usr/bin/nmeter
busybox rm -f /usr/bin/nohup
busybox rm -f /usr/bin/nslookup
busybox rm -f /usr/bin/od
busybox rm -f /usr/bin/openvt
# busybox rm -f /usr/bin/passwd
busybox rm -f /usr/bin/patch
busybox rm -f /usr/bin/pgrep
busybox rm -f /usr/bin/pidof
busybox rm -f /usr/bin/ping
busybox rm -f /usr/bin/ping6
busybox rm -f /usr/bin/pipe_progress
busybox rm -f /usr/bin/pkill
busybox rm -f /usr/bin/pmap
busybox rm -f /usr/bin/printenv
busybox rm -f /usr/bin/printf
# busybox rm -f /usr/bin/ps
busybox rm -f /usr/bin/pscan
busybox rm -f /usr/bin/pstree
busybox rm -f /usr/bin/pwd
busybox rm -f /usr/bin/pwdx
busybox rm -f /usr/bin/readlink
busybox rm -f /usr/bin/realpath
busybox rm -f /usr/bin/reformime
busybox rm -f /usr/bin/renice
busybox rm -f /usr/bin/reset
busybox rm -f /usr/bin/resize
busybox rm -f /usr/bin/rev
busybox rm -f /usr/bin/rm
busybox rm -f /usr/bin/rmdir
# busybox rm -f /usr/bin/rpm
busybox rm -f /usr/bin/rpm2cpio
busybox rm -f /usr/bin/run-parts
busybox rm -f /usr/bin/runsv
busybox rm -f /usr/bin/runsvdir
busybox rm -f /usr/bin/rx
busybox rm -f /usr/bin/script
busybox rm -f /usr/bin/scriptreplay
busybox rm -f /usr/bin/sed
busybox rm -f /usr/bin/seq
busybox rm -f /usr/bin/setarch
busybox rm -f /usr/bin/setkeycodes
busybox rm -f /usr/bin/setserial
busybox rm -f /usr/bin/setsid
busybox rm -f /usr/bin/setuidgid
# busybox rm -f /usr/bin/sh
busybox rm -f /usr/bin/sha1sum
busybox rm -f /usr/bin/sha256sum
busybox rm -f /usr/bin/sha3sum
busybox rm -f /usr/bin/sha512sum
busybox rm -f /usr/bin/showkey
busybox rm -f /usr/bin/sleep
busybox rm -f /usr/bin/smemcap
busybox rm -f /usr/bin/softlimit
# busybox rm -f /usr/bin/sort
busybox rm -f /usr/bin/split
busybox rm -f /usr/bin/stat
busybox rm -f /usr/bin/strings
busybox rm -f /usr/bin/stty
# busybox rm -f /usr/bin/su
busybox rm -f /usr/bin/tcpsvd
busybox rm -f /usr/bin/tee
busybox rm -f /usr/bin/telnet
busybox rm -f /usr/bin/test
busybox rm -f /usr/bin/tftp
busybox rm -f /usr/bin/time
busybox rm -f /usr/bin/timeout
busybox rm -f /usr/bin/top
busybox rm -f /usr/bin/touch
busybox rm -f /usr/bin/tr
busybox rm -f /usr/bin/traceroute
busybox rm -f /usr/bin/traceroute6
busybox rm -f /usr/bin/true
busybox rm -f /usr/bin/tty
busybox rm -f /usr/bin/ttysize
busybox rm -f /usr/bin/udpsvd
# busybox rm -f /usr/bin/umount
busybox rm -f /usr/bin/uname
busybox rm -f /usr/bin/uncompress
busybox rm -f /usr/bin/unexpand
busybox rm -f /usr/bin/uniq
busybox rm -f /usr/bin/unix2dos
busybox rm -f /usr/bin/unlzma
busybox rm -f /usr/bin/unlzop
busybox rm -f /usr/bin/unxz
busybox rm -f /usr/bin/unzip
busybox rm -f /usr/bin/uptime
busybox rm -f /usr/bin/users
busybox rm -f /usr/bin/usleep
busybox rm -f /usr/bin/uudecode
busybox rm -f /usr/bin/uuencode
busybox rm -f /usr/bin/vi
busybox rm -f /usr/bin/vlock
busybox rm -f /usr/bin/volname
busybox rm -f /usr/bin/wall
busybox rm -f /usr/bin/watch
busybox rm -f /usr/bin/wc
busybox rm -f /usr/bin/wget
busybox rm -f /usr/bin/which
busybox rm -f /usr/bin/who
busybox rm -f /usr/bin/whoami
busybox rm -f /usr/bin/whois
busybox rm -f /usr/bin/xargs
busybox rm -f /usr/bin/xz
busybox rm -f /usr/bin/xzcat
busybox rm -f /usr/bin/yes
busybox rm -f /usr/bin/zcat

# delete the same name *sbin* binary file

busybox rm -f /usr/sbin/acpid
busybox rm -f /usr/sbin/addgroup
busybox rm -f /usr/sbin/add-shell
busybox rm -f /usr/sbin/adduser
busybox rm -f /usr/sbin/adjtimex
busybox rm -f /usr/sbin/arp
busybox rm -f /usr/sbin/arping
# busybox rm -f /usr/sbin/blkid
busybox rm -f /usr/sbin/blockdev
busybox rm -f /usr/sbin/bootchartd
busybox rm -f /usr/sbin/brctl
busybox rm -f /usr/sbin/chat
# busybox rm -f /usr/sbin/chpasswd
busybox rm -f /usr/sbin/chroot
# busybox rm -f /usr/sbin/crond
busybox rm -f /usr/sbin/delgroup
busybox rm -f /usr/sbin/deluser
# busybox rm -f /usr/sbin/depmod
busybox rm -f /usr/sbin/devmem
busybox rm -f /usr/sbin/dhcprelay
busybox rm -f /usr/sbin/dnsd
busybox rm -f /usr/sbin/ether-wake
busybox rm -f /usr/sbin/fakeidentd
busybox rm -f /usr/sbin/fbset
busybox rm -f /usr/sbin/fbsplash
busybox rm -f /usr/sbin/fdformat
busybox rm -f /usr/sbin/fdisk
busybox rm -f /usr/sbin/findfs
busybox rm -f /usr/sbin/freeramdisk
busybox rm -f /usr/sbin/fsck
busybox rm -f /usr/sbin/fsck.minix
busybox rm -f /usr/sbin/fstrim
busybox rm -f /usr/sbin/ftpd
busybox rm -f /usr/sbin/getty
busybox rm -f /usr/sbin/halt
busybox rm -f /usr/sbin/hdparm
busybox rm -f /usr/sbin/httpd
busybox rm -f /usr/sbin/hwclock
busybox rm -f /usr/sbin/ifconfig
# busybox rm -f /usr/sbin/ifdown
busybox rm -f /usr/sbin/ifenslave
busybox rm -f /usr/sbin/ifplugd
# busybox rm -f /usr/sbin/ifup
busybox rm -f /usr/sbin/inetd
# use systemd init directly
# busybox rm -f /usr/sbin/init
# busybox rm -f /usr/sbin/insmod
# busybox rm -f /usr/sbin/ip
busybox rm -f /usr/sbin/ipaddr
busybox rm -f /usr/sbin/iplink
busybox rm -f /usr/sbin/iproute
busybox rm -f /usr/sbin/iprule
busybox rm -f /usr/sbin/iptunnel
busybox rm -f /usr/sbin/killall5
busybox rm -f /usr/sbin/klogd
busybox rm -f /usr/sbin/loadfont
busybox rm -f /usr/sbin/loadkmap
busybox rm -f /usr/sbin/logread
busybox rm -f /usr/sbin/losetup
busybox rm -f /usr/sbin/lpd
# busybox rm -f /usr/sbin/lsmod
busybox rm -f /usr/sbin/makedevs
busybox rm -f /usr/sbin/mdev
busybox rm -f /usr/sbin/mkdosfs
busybox rm -f /usr/sbin/mke2fs
busybox rm -f /usr/sbin/mkfs.ext2
busybox rm -f /usr/sbin/mkfs.minix
busybox rm -f /usr/sbin/mkfs.vfat
busybox rm -f /usr/sbin/mkswap
# busybox rm -f /usr/sbin/modinfo
# busybox rm -f /usr/sbin/modprobe
busybox rm -f /usr/sbin/nameif
busybox rm -f /usr/sbin/nanddump
busybox rm -f /usr/sbin/nandwrite
busybox rm -f /usr/sbin/nbd-client
busybox rm -f /usr/sbin/ntpd
busybox rm -f /usr/sbin/pivot_root
busybox rm -f /usr/sbin/popmaildir
busybox rm -f /usr/sbin/poweroff
busybox rm -f /usr/sbin/powertop
busybox rm -f /usr/sbin/raidautorun
busybox rm -f /usr/sbin/rdate
busybox rm -f /usr/sbin/rdev
busybox rm -f /usr/sbin/readahead
busybox rm -f /usr/sbin/readprofile
busybox rm -f /usr/sbin/reboot
busybox rm -f /usr/sbin/remove-shell
# busybox rm -f /usr/sbin/rmmod
busybox rm -f /usr/sbin/route
busybox rm -f /usr/sbin/rtcwake
busybox rm -f /usr/sbin/runlevel
# busybox rm -f /usr/sbin/sendmail
busybox rm -f /usr/sbin/setconsole
busybox rm -f /usr/sbin/setfont
busybox rm -f /usr/sbin/setlogcons
busybox rm -f /usr/sbin/slattach
busybox rm -f /usr/sbin/start-stop-daemon
# busybox rm -f /usr/sbin/sulogin
busybox rm -f /usr/sbin/telnetd
busybox rm -f /usr/sbin/tftpd
busybox rm -f /usr/sbin/tunctl
busybox rm -f /usr/sbin/ubiattach
busybox rm -f /usr/sbin/ubidetach
busybox rm -f /usr/sbin/ubimkvol
busybox rm -f /usr/sbin/ubirmvol
busybox rm -f /usr/sbin/ubirsvol
busybox rm -f /usr/sbin/ubiupdatevol
busybox rm -f /usr/sbin/udhcpc
busybox rm -f /usr/sbin/udhcpd
busybox rm -f /usr/sbin/vconfig
busybox rm -f /usr/sbin/watchdog
busybox rm -f /usr/sbin/zcip

busybox --install -s



# Persistent journal by default, because Atomic doesn't have syslog
echo 'Storage=persistent' >> /etc/systemd/journald.conf

# See: https://bugzilla.redhat.com/show_bug.cgi?id=1051816
# and: https://bugzilla.redhat.com/show_bug.cgi?id=1186757
# Keep this in sync with the `install-langs` in the treefile JSON
KEEPLANGS="
pt_BR
fr_FR
de_DE
it_IT
ru_RU
es_ES
en_US
zh_CN
ja_JP
ko_KR
zh_TW
as_IN
bn_IN
gu_IN
hi_IN
kn_IN
ml_IN
mr_IN
or_IN
pa_IN
ta_IN
te_IN
"

# Filter out locales from glibc which aren't UTF-8 and in the above set.
# TODO: https://github.com/projectatomic/rpm-ostree/issues/526
localedef --list-archive | while read locale; do
    lang=${locale%%.*}
    lang=${lang%%@*}
    if [[ $locale != *.utf8 ]] || ! grep -q "$lang" <<< "$KEEPLANGS"; then
        localedef --delete-from-archive "$locale"
    fi
done

cp -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
build-locale-archive
