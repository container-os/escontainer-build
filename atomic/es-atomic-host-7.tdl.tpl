<template>
    <name>rawhide</name>
    <os>
        <name>CentOS-7</name>
        <version>4</version>
        <arch>x86_64</arch>
        <install type='url'>
            <url>{{ ANACONDA_LIVECD }}</url>
        </install>
        <rootpw>rootroot</rootpw>
    </os>
    <disk>
      <size>{{ OSTREE_DISK_SIZE }}</size>
    </disk>
</template>

