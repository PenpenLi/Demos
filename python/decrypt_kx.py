#!/usr/local/bin/python
# _*_ coding: utf-8 _*_

import os
from Crypto.Cipher import AES
import zlib


key = '\xe9\x74\x7d\x92\xcc\x32\x2e\x7d\x11\x2e\x7c\x34\x51\xd7\xb3\x6a'

pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]

def main():
    for root, dirs, files in os.walk('./kx/src_encrypt/'):
        for f in files:
            if f.endswith('.lua'):
                decrypt(root, os.path.join(root, f))

def decrypt(root, path):
    fileName = os.path.basename(path).split('.')[0] + '.lua'
    outDir = os.path.dirname(path).replace('src_encrypt', 'src_decrypt')
    if not os.path.exists(outDir):
        os.makedirs(outDir)

    decryptFile = outDir + '/' + fileName
    print "decrypt " + path + " to " + decryptFile

    # 1. aes decrypt
    f = open(path, "rb")
    content = f.read()
    f.close()
    iv = content[:16]
    enc = content[16:]
    aes = AES.new(key, AES.MODE_CBC, iv)
    dec = unpad(aes.decrypt(enc))

    # 2. gun unzip
    #dec = '\x78\x9c' + dec
    #dec = zlib.decompress(dec, -zlib.MAX_WBITS)
    dec = zlib.decompress(dec, zlib.MAX_WBITS)
    fout = open(os.path.abspath(decryptFile), "wb")
    fout.write(dec)
    fout.close()

if __name__ == '__main__':
    main()

