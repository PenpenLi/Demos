#!/usr/bin/python
# _*_ coding: utf-8 _*_

import os
import struct

def main():
    for root, dirs, files in os.walk('./TqRes/'):
        for f in files:
            if f.endswith('.data'):
                decrypt(root, os.path.join(root, f))

def decrypt(root, path):
    print "decrypt " + path

    # 1.file name len
    f = open(path, "rb")
    filename_len = f.read(1)
    filename_len = struct.unpack("B", filename_len)[0] ^ 0x17
    print "filename len=%d" %(filename_len)

    # 2.decrypt file name
    encrypted_filename = f.read(filename_len)
    filename=""
    for b in encrypted_filename:
        filename += struct.pack("B", struct.unpack("B", b)[0] ^ 0x17)
    fullname = os.path.join(root, os.path.basename(filename))
    print "filename: %s" %(fullname)

    # 3.decrypt file content
    fout = open(fullname, "w+b")
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

    fout.write(content)
    fout.close()

if __name__ == '__main__':
    main()

