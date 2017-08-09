#!/usr/bin/env python
import argparse
import socket


def bool_to_str(value):
    valid = {True: 'yes', False: 'no'}
    return valid[value]


def is_open(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((ip, int(port)))
        s.shutdown(2)
        return True
    except:
        return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--host', default='127.0.0.1')
    parser.add_argument('--port', type=int, required=True)
    args = parser.parse_args()
    result = is_open(args.host, args.port)
    print(bool_to_str(result))
