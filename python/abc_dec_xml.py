#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import zlib
import array
import struct

k = 'lk18ojgeieonf'


def decrypt(path):
    f = open(path, "rb")
    content = f.read()
    f.close()
    bk = array.array('B')
    bk.fromstring(k)
    bk_len = len(bk)
    bc = array.array('B')
    bc.fromstring(content)
    bc_len = len(bc)
    k_pos = 0
    for i in range(0, bc_len):
        c = bc[i] - bk[k_pos]
        if c < 0:
            c += 256
        struct.pack_into('B', bc, i, c)
        k_pos += 1
        if k_pos >= bk_len:
            k_pos = 0
    try:
        dec = zlib.decompress(bc, zlib.MAX_WBITS)
        fout = open(path, "wb")
        fout.write(dec)
        fout.close()
    except:
        print "error"
        pass


def main():
    for root, _dirs, files in os.walk('./abc_assets/otherAssets/xml/'):
        for f in files:
            if f.endswith('.xml') or f.endswith('.json'):
                print "decrypt " + os.path.join(root, f)
                decrypt(os.path.join(root, f))


if __name__ == '__main__':
    main()
