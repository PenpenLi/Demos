#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import zlib

head = '\x01\x01\x01\x01\x01\x01\x01\x01\x01'
def encrypt(path):
    f = open(path, "rb")
    content = f.read()
    f.close()
    compressed = zlib.compress(content)
    print len(compressed)
    enc = head+compressed
    print len(enc)
    fout = open(path, "wb")
    fout.write(enc)
    fout.close()

def main():
    for root, dirs, files in os.walk('./abc_assets/otherAssets/xml/'):
        for f in files:
            if f.endswith('.xml'):
                print "encrypt " + os.path.join(root, f)
                encrypt(os.path.join(root, f))

if __name__ == '__main__':
    main()
