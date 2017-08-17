#!/usr/bin/env python
import argparse
import re
import socket
import subprocess

def get_local_ips():
    ipstr = '([0-9]{1,3}\.){3}[0-9]{1,3}'
    ipconfig_process = subprocess.Popen("ifconfig", stdout=subprocess.PIPE)
    output = ipconfig_process.stdout.read()
    ip_pattern = re.compile('(inet %s)' % ipstr)
    pattern = re.compile(ipstr)
    iplist = []
    for ipaddr in re.finditer(ip_pattern, str(output)):
        ip = pattern.search(ipaddr.group())
        iplist.append(ip.group())
    return iplist 

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='check the input ip whether is local ip')
    parser.add_argument('--host', required=True)
    args = parser.parse_args()
    ip = args.host
    ips = get_local_ips()
    if ip in ips:
        print('yes')
    else:
        print('no')
