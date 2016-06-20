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
<<<<<<< HEAD
    decrypt('./abc_assets/Pocketmon.swf')
=======
    decrypt('Pocketmon.swf')
>>>>>>> ed5817c2f7d1c12285260bf08dc3a50d16c79b68

if __name__ == '__main__':
    main()
