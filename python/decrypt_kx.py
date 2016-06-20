#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
from Crypto.Cipher import AES
import zlib


# ''
key = '\xe9\x74\x7d\x92\xcc\x32\x2e\x7d\x11\x2e\x7c\x34\x51\xd7\xb3\x6a'

pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]

def main():
    src_out_dir = './kx/src_decrypt/'
    meta_out_dir = './kx/meta_decrypt/'
    if not os.path.exists(src_out_dir):
        os.makedirs(src_out_dir)
    if not os.path.exists(meta_out_dir):
        os.makedirs(meta_out_dir)

    for root, dirs, files in os.walk('./kx/src_encrypt/'):
        out_dir=root.replace('src_encrypt', 'src_decrypt')
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)
        for f in files:
            if f.endswith('.lua'):
                fileName = os.path.basename(f).split('.')[0] + '.lua'
                decryptFile = out_dir + '/' + fileName
                print "decrypt " + os.path.join(root, f) + " to " + decryptFile
                decrypt(os.path.join(root, f), decryptFile)

    for root, dirs, files in os.walk('./kx/meta_encrypt/'):
        out_dir=root.replace('meta_encrypt', 'meta_decrypt')
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)
        for f in files:
            if f.endswith('.inf'):
                fileName = os.path.basename(f).split('.')[0] + '.inf'
                decryptFile = meta_out_dir + '/' + fileName
                print "decrypt " + os.path.join(root, f) + " to " + decryptFile
                decrypt(os.path.join(root, f), decryptFile)

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
    #dec = '\x78\x9c' + dec
    #dec = zlib.decompress(dec, -zlib.MAX_WBITS)
    dec = zlib.decompress(dec, zlib.MAX_WBITS)
    fout = open(os.path.abspath(out), "wb")
    fout.write(dec)
    fout.close()

if __name__ == '__main__':
    main()

