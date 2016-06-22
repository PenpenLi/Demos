#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import array

key = [0x62, 0x6f, 0x79, 0x61, 0x61]
SIG='BYLUA'

def main():
    src_out_dir = './byc/scripts_dec/'
    if not os.path.exists(src_out_dir):
        os.makedirs(src_out_dir)

    for root, dirs, files in os.walk('./byc/scripts_enc/'):
        out_dir=root.replace('scripts_enc', 'scripts_dec')
        if not os.path.exists(out_dir):
            os.makedirs(out_dir)
        for f in files:
            if f.endswith('.lua'):
                fileName = os.path.basename(f).split('.')[0] + '.lua'
                decryptFile = out_dir + '/' + fileName
                decrypt(os.path.join(root, f), decryptFile)

def decrypt(path, out):
    f = open(path, "rb")
    es = f.read()
    f.close()
    if not es.startswith(SIG):
        print f+" not BYLUA"
        return
    print "decrypt " + path + " to " + out
    es = es[len(SIG):]
    ea = array.array('B')
    ea.fromstring(es)
    i = 0
    kl = len(key)
    for i in range(0, len(ea)):
        ea[i] ^= key[i%kl]

    fout = open(out, "wb")
    fout.write(ea)
    fout.close()

if __name__ == '__main__':
    main()

