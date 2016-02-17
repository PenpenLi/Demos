#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import zlib

def decrypt(path):
    f = open(path, "rb")
    content = f.read()
    f.close()
    try:
        dec = zlib.decompress(content, zlib.MAX_WBITS)
        fout = open(path, "wb")
        fout.write(dec)
        fout.close()
    except:
        print "error"
        pass

def main():
    for root, dirs, files in os.walk('./abc_assets/'):
        for f in files:
            if f.endswith('.mp3') or f.endswith('.jpg') or f.endswith('.png') or f.endswith('.xml') or f.endswith('.bytes') or f.endswith('.atf'):
                print "decrypt " + os.path.join(root, f)
                decrypt(os.path.join(root, f))

if __name__ == '__main__':
    main()
