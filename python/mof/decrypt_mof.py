#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import string
import shutil
from Crypto.Cipher import AES


key = 'anni_are_you_ok_are_you_ok_anni?'
pad = lambda s: s + (16 - len(s) % 16) * chr(16 - len(s) % 16)
unpad = lambda s : s[0:-ord(s[-1])]
pngcrush = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush'

def main():
    for root, dirs, files in os.walk('/Users/xiaobin/Desktop/MOF_le8/'):
        for f in files:
            if f.endswith('.ini'):
                decrypt(root, os.path.join(root, f))

            # if f.endswith('.png'):
                # plist = os.path.join(root, os.path.basename(f).split('.')[0] + ".plist")
                # if os.path.exists(plist):
                    # handelFrame(os.path.join(root, f), plist)


def handelFrame(png, plist):
    outPng = './res_le8/' + os.path.basename(png)
    outPlist = './res_le8/' + os.path.basename(plist)
    print "handle " + png + " to " + outPng
    os.system(pngcrush + " -revert-iphone-optimizations " + png + " " + outPng)
    os.system("plutil -convert xml1 " + plist)
    shutil.copy2(plist, outPlist)


def decrypt(root, path):
    fileName = os.path.basename(path)
    decryptFile = './ini_le8/' + fileName
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

