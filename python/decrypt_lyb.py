#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
from Crypto.Cipher import AES
import zlib
import shutil


key = '\xe9\x74\x7d\x92\xcc\x32\x2e\x7d\x11\x2e\x7c\x34\x51\xd7\xb3\x6a'

pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]

def main():
    src_out_dir = './lyb/src_decrypt/'
    shutil.rmtree(src_out_dir, ignore_errors=True)
    os.makedirs(src_out_dir)

    for root, dirs, files in os.walk('./lyb/src_encrypt/'):
        out_dir=root.replace('src_encrypt', 'src_decrypt')
        for f in files:
            decryptFile = os.path.join(out_dir, f + '.lua')
            print "decrypt " + os.path.join(root, f) + " to " + decryptFile
            decrypt(os.path.join(root, f), decryptFile)

    #rename
    for root, dirs, files in os.walk('./lyb/src_decrypt'):
        for f in files:
            rename_file(root, f)

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

def rename_file(path, name):
    old_path = os.path.join(path, name)
    new_name = ''
    for line in file(old_path).readlines():
        if line.startswith('--') or line.find('=') == -1:
            continue
        ls = line.split('=', 1)
        if len(ls) == 0:
            continue
        l = ls[0].strip()
        if l.find(' ') == -1:
            new_name = l
        else:
            ls = l.rsplit(' ', 1)
            if len(ls) > 0:
                new_name = ls[-1]
        break
    if len(new_name) > 0:
        new_path = os.path.join(path, new_name+'.lua')
        if (os.path.exists(new_path)):
            new_path = os.path.join(path, new_name+'_'+name)
        print 'move '+old_path+' to '+new_path
        shutil.move(old_path, new_path)

if __name__ == '__main__':
    main()

