#!/usr/bin/python
# _*_ coding: utf-8 _*_

import os
import struct

def main():
    for root, dirs, files in os.walk('./TqRes2'):
        for f in files:
            if f.endswith('.png'):
                decrypt(root, os.path.join(root, f))

def decrypt(root, path):
    print "decrypt " + path

    f = open(path, "rb")
    encrypted_content = f.read()
    f.close()
    content = ""
    i = 0
    for b in encrypted_content:
        if i < 10:
            content += struct.pack("B", struct.unpack("B", b)[0] ^ 0x17)
        else:
            content += b
        i += 1

    fout = open(path, "wb")
    fout.write(content)
    fout.close()

if __name__ == '__main__':
    main()

