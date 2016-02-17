#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import zlib

def decrypt(path):
    f = open(path, "rb")
    content = f.read()
    f.close()
    try:
        dec = zlib.decompress(content[12:], zlib.MAX_WBITS)
        fout = open(path, "wb")
        fout.write(dec)
        fout.close()
    except:
        print "error"
        pass

def main():
    decrypt('Pocketmon.swf')

if __name__ == '__main__':
    main()
