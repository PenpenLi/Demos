#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import sys
from Crypto.Cipher import AES
import zlib


pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]

key = '\xe9\x74\x7d\x92\xcc\x32\x2e\x7d\x11\x2e\x7c\x34\x51\xd7\xb3\x6a'
def decrypt(path, out):
    # 1. aes decrypt
    f = open(path, "rb")
    content = f.read()
    f.close()
    iv = content[:16]
    enc = content[16:]
    aes = AES.new(key, AES.MODE_CBC, iv)
    dec = unpad(aes.decrypt(enc))

    # 2. gun unzip
    dec = zlib.decompress(dec, zlib.MAX_WBITS)
    fout = open(os.path.abspath(out), "wb")
    fout.write(dec)
    fout.close()

if __name__ == '__main__':
    if len(sys.argv) != 3 or not os.path.exists(sys.argv[1]):
        print 'Usage: {0} input output key'.format(sys.argv[0])
        exit(0)
    decrypt(sys.argv[1], sys.argv[2])

