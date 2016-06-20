#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import os
import xml.etree.ElementTree as ET

def compareSD(x, y):
    if int(x.zzSD)>int(y.zzSD):
        return 1
    elif int(x.zzSD)<int(y.zzSD):
        return -1
    else:
        return 0

def compareTotal(x, y):
    if int(x.total)>int(y.total):
        return 1
    elif int(x.total)<int(y.total):
        return -1
    else:
        return 0
def compareF(x, y):
    if int(x.zzWF)+int(x.zzTF)>int(y.zzWF)+int(y.zzTF):
        return 1
    elif int(x.zzWF)+int(x.zzTF)<int(y.zzWF)+int(y.zzTF):
        return -1
    else:
        return 0

def compareWG(x, y):
    if int(x.zzWG)>int(y.zzWG):
        return 1
    elif int(x.zzWG)<int(y.zzWG):
        return -1
    else:
        return 0

def compareTG(x, y):
    if int(x.zzTG)>int(y.zzTG):
        return 1
    elif int(x.zzTG)<int(y.zzTG):
        return -1
    else:
        return 0

def compareHP(x, y):
    if int(x.zzHP)>int(y.zzHP):
        return 1
    elif int(x.zzHP)<int(y.zzHP):
        return -1
    else:
        return 0

class Elf(object):
    def __init__(self, xml):
        self.id=xml.attrib['id']
        self.name=xml.attrib['chineseName']
        self.rank=xml.attrib['rank']
        self.total=xml.attrib['zzTotal']
        self.zzSD=xml.attrib['zzSD']
        self.zzHP=xml.attrib['zzHP']
        self.zzTG=xml.attrib['zzTG']
        self.zzTF=xml.attrib['zzTF']
        self.zzWG=xml.attrib['zzWG']
        self.zzWF=xml.attrib['zzWF']
        self.val=xml.attrib['hardVal']
        self.attr=xml.attrib['attr']
        vs = self.val.split(',')
        self.zzHP=str(int(self.zzHP)+int(vs[0]))
        self.zzWG=str(int(self.zzWG)+int(vs[1]))
        self.zzWF=str(int(self.zzWF)+int(vs[2]))
        self.zzTG=str(int(self.zzTG)+int(vs[3]))
        self.zzTF=str(int(self.zzTF)+int(vs[4]))
        self.zzSD=str(int(self.zzSD)+int(vs[5]))
        self.total=str(int(self.total)+int(vs[0])+int(vs[1])+int(vs[2])+int(vs[3])+int(vs[4])+int(vs[5]))
        self.T=0
        self.F=0
        self.TG=0
        self.WG=0
        self.SD=0
        self.HP=0

def main():
    tree = ET.parse('./abc_assets/otherAssets/xml/sta_poke.xml')
    root = tree.getroot()
    # print root.findall('sta_poke')
    elfs = []
    for elf in root.findall('sta_poke'):
        # print elf.attrib['id']+' -- '+elf.attrib['chineseName']+' -- '+elf.attrib['zzTotal']
        elfs.append(Elf(elf))
    print len(elfs)

    elfs.sort(compareSD, reverse=True)
    i=0
    print '速度前20'
    for elf in elfs:
        elf.SD = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print 'HP前20'
    elfs.sort(compareHP, reverse=True)
    i=0
    for elf in elfs:
        elf.HP = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print '双防前20'
    elfs.sort(compareF, reverse=True)
    i=0
    for elf in elfs:
        elf.F = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print '物攻前20'
    elfs.sort(compareWG, reverse=True)
    i=0
    for elf in elfs:
        elf.WG = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print '特攻前20'
    elfs.sort(compareTG, reverse=True)
    i=0
    for elf in elfs:
        elf.TG = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print '总值前20'
    elfs.sort(compareTotal, reverse=True)
    i=0
    for elf in elfs:
        elf.T = i
        if i<20:
            print '%-8s'%(elf.id)+'%-10s'%(elf.name)
        i = i+1

    print '所有排行'
    print '%-8s'%('id')+'%-10s'%('name')+'\ttotal\tHP\tF\tTG\tWG\tSD\trank'
    for elf in elfs:
        print '%-8s'%(elf.id)+'%-10s'%(elf.name)+'\t'+str(elf.T)+'\t'+str(elf.HP)+'\t'+str(elf.F)+'\t'+str(elf.TG)+'\t'+str(elf.WG)+'\t'+str(elf.SD)+'\t'+elf.rank


if __name__ == '__main__':
    main()
