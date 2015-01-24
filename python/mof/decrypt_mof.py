#!/usr/local/bin/python
# _*_ coding: utf-8 _*_

import os
import string
from Crypto.Cipher import AES


key = 'anni_are_you_ok_are_you_ok_anni?'

pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]

def main():
    print "main``"
    for root, dirs, files in os.walk('/Users/xiaobin/Desktop/MOF_tongbu.app/'):
        for f in files:
            if f.endswith('.ini'):
                decrypt(root, os.path.join(root, f))

def decrypt(root, path):
    fileName = os.path.basename(path)
    decryptFile = './ini/' + fileName
    print "decrypt " + path + " to " + decryptFile

    # 1. aes decrypt
    f = open(path, "rb")
    content = f.read()
    f.close()
    aes = AES.new(key, AES.MODE_ECB)
    dec = aes.decrypt(content)
    dec = string.replace(dec, '\x0d', '\x0a')
    dec = string.replace(dec, '\x00', '')

    fout = open(os.path.abspath(decryptFile), "wb")
    fout.write(dec)
    fout.close()

if __name__ == '__main__':
    main()

