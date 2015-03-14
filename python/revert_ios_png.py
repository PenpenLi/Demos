#!/usr/bin/env python
# coding: utf-8


import os
import sys


PNGCRUSH='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush'

if __name__ == '__main__':
    if len(sys.argv) != 2 or not os.path.exists(sys.argv[1]):
        print 'Usage: {0} dir'.format(sys.argv[0])
        exit(0)
    full = os.path.abspath(sys.argv[1])
    print full
    pathName = os.path.basename(full)
    outPathName = pathName + '_out'
    for root, dirs, files in os.walk(full):
        for f in files:
            if f.endswith('.png'):
                outDir = root.replace(pathName, outPathName)
                if not os.path.exists(outDir):
                    os.makedirs(outDir)
                png = os.path.join(root, os.path.basename(f))
                out = os.path.join(outDir, os.path.basename(f))
                print out
                os.system(PNGCRUSH + ' -revert-iphone-optimizations ' + png + ' ' + out)
