#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import ConfigParser


class CocosClass(object):
    """Cocos class info"""

    def fromDic(self, dic):
        self.className = dic["classname"]
        self.nodeName = dic["name"]
        self.nodeTag = dic["tag"]

    def __init__(self):
        self.className = ""
        self.nodeName = ""
        self.nodeTag = -1
        self.children = []

    def description(self):
        return json.dumps({"className":self.className,
                           "nodeName":self.nodeName,
                           "nodeTag":self.nodeTag,
                           "children":self.children}, cls=CocosClassEncoder)

    def addChild(self, child):
        self.children.append(child)


class CocosClassEncoder(json.JSONEncoder):
    def default(self, obj):
        if not isinstance(obj, CocosClass):
            return super(CocosClassEncoder, self).default(obj)
        return obj.__dict__


def readFromDic(cocos, dic):
    """读取cocos node, 保持树型结构"""
    children = dic["children"]
    options = dic["options"]
    cocos.fromDic(options)
    for child in children:
        c = CocosClass()
        readFromDic(c, child)
        cocos.addChild(c)


def parseFromDic(cocosDic, dic):
    """读取所有cocosnode, 以name为key保存为字典"""
    children = dic["children"]
    options = dic["options"]
    cocos = CocosClass()
    cocos.fromDic(options)
    cocosDic[cocos.nodeName] = cocos
    for child in children:
        parseFromDic(cocosDic, child)


def main():
    config = ConfigParser.ConfigParser()
    config.read("config.ini")
    for section in config.sections():
        for k, v in config.items(section):
            print "%s=%s" %(k, v)

    f = file(config.get('ui', 'file'))
    decodejson = json.load(f)
    dic = decodejson["widgetTree"]
    widgets = {}

    parseFromDic(widgets, dic)

    #print cocos.description()

    members = config.get('member', 'nodeName').split(',')
    projectName = config.get('project', 'name')
    subClassName = config.get('class', 'sub')
    baseClassName = config.get('class', 'base')

    print "Gen class %s:%s for project %s" %(subClassName, baseClassName, projectName)

    #print json.dumps(CPP, cls=CocosClassEncoder)

    for member in members:
        print json.dumps(widgets[member], cls=CocosClassEncoder)

    fHeaderTemplete = file('tp/___FILEBASENAME___.h')
    headerTp = fHeaderTemplete.readlines()
    print headerTp
    fCppTemplete = file('tp/___FILEBASENAME___.cpp')
    cppTp = fCppTemplete.readlines()
    print cppTp
    fHeaderOut = file(subClassName + '.h', 'w')
    for line in headerTp:
        l = line.replace('___PROJECTNAME___', projectName)
        l = l.replace('___FILEBASENAME___', subClassName)
        fHeaderOut.write(l)
    fHeaderOut.close()

    fCppOut = file(subClassName + '.cpp', 'w')
    for line in cppTp:
        fCppOut.write(line.replace('___FILEBASENAME___', subClassName))
    fCppOut.close()


if __name__ == '__main__':
    main()

