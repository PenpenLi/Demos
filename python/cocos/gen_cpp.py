#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import ConfigParser


COCOS_CLASSES = {
    "Node"          : "Node",
    "SubGraph"      : "Node",
    "Sprite"        : "Sprite",
    "Particle"      : "ParticleSystemQuad",

    "Panel"         : "Layout",
    "Button"        : "Button",
    "CheckBox"      : "CheckBox",
    "ImageView"     : "ImageView",
    "TextAtlas"     : "TextAtlas",
    "TextBMFont"    : "TextBMFont",
    "Text"          : "Text",
    "LoadingBar"    : "LoadingBar",
    "TextField"     : "TextField",
    "Slider"        : "Slider",
    "Layout"        : "Layout",
    "ScrollView"    : "ScrollView",
    "ListView"      : "ListView",
    "PageView"      : "PageView",
    "Widget"        : "Widget",
    "Label"         : "Text",

    "TextArea"      : "Text",
    "LabelAtlas"    : "TextAtlas",
    "LabelBMFont"   : "TextBMFont",
    "TextButton"    : "Button",
    "DragPanel"     : "ScrollView",
}

UI = "\tauto content = GUIReader::getInstance()->widgetFromJsonFile(\"{0}\");\n"
ASSERT_UI = "\tCCASSERT(content, \"read widget from {0} failed!\");\n\n"
WIDGET = "\t{0} = ({1})Helper::seekWidgetByName(content, \"{0}\");\n"
WIDGET_TAG = "\t{0} = ({1})Helper::seekWidgetByTag(content, {2});\n"
ASSERT_WIDGET = "\tCCASSERT({0}, \"{0} is null!\");\n\n"
MEMBER = "\t{0}* {1};\t\t//tag {2}\n"

class CocosClass(object):
    """Cocos class info"""

    def fromDic(self, dic):
        self.className = dic["classname"]
        self.nodeName = dic["name"]
        self.nodeTag = dic["tag"]
        self.name = self.nodeName

    def __init__(self):
        self.className = ""
        self.nodeName = ""
        self.nodeTag = -1
        self.name = ""
        self.children = []

    def description(self):
        return json.dumps({"className":self.className,
                           "nodeName":self.nodeName,
                           "nodeTag":self.nodeTag,
                           "children":self.children}, cls=CocosClassEncoder)


    def addChild(self, child):
        self.children.append(child)

    def realClass(self):
        return COCOS_CLASSES[self.className]


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
    #for section in config.sections():
        #for k, v in config.items(section):
            #print "%s=%s" %(k, v)

    uiFile = config.get('ui', 'file')
    f = file(uiFile)
    decodejson = json.load(f)
    dic = decodejson["widgetTree"]

    widgets = {}
    parseFromDic(widgets, dic)

    tag_names = {}
    for k,v in config.items('member'):
        tag_names[v] = k
    print tag_names

    members = []
    for k,v in widgets.items():
        if (k.startswith('_')):
            members.append(v)

        if str(v.nodeTag) in tag_names.keys():
            v.name = tag_names[str(v.nodeTag)]
            members.append(v)
            pass


    projectName = config.get('project', 'name')
    subClassName = config.get('class', 'sub')
    baseClassName = config.get('class', 'base')

    print "Gen class %s:%s from %s" %(subClassName, baseClassName, uiFile)

    for member in members:
        print json.dumps(member, cls=CocosClassEncoder)

    # .h
    fHeaderTemplete = file('tp/___FILEBASENAME___.h')
    headerTp = fHeaderTemplete.readlines()
    fHeaderOut = file(subClassName + '.h', 'w')
    for line in headerTp:
        l = line.replace('___PROJECTNAME___', projectName)
        l = l.replace('___FILEBASENAME___', subClassName)
        fHeaderOut.write(l)

        # using
        if (l.startswith('using ')):
            classes = set()
            for member in members:
                classes.add(member.realClass())
            for c in classes:
                fHeaderOut.write('using cocos2d::ui::' + c + ';\n')

        # member
        if (l.startswith('private:')):
            for member in members:
                fHeaderOut.write(MEMBER.format(member.realClass(), member.name, member.nodeTag))

            fHeaderOut.write('\n')

    fHeaderOut.write('\n')
    fHeaderOut.close()

    # .cpp
    fCppTemplete = file('tp/___FILEBASENAME___.cpp')
    cppTp = fCppTemplete.readlines()

    fCppOut = file(subClassName + '.cpp', 'w')
    for line in cppTp:
        if (line.endswith('::setupUI(){}\n')):
            fCppOut.write('void ' + subClassName + '::setupUI()\n{\n')
            fCppOut.write(UI.format(uiFile))
            fCppOut.write(ASSERT_UI.format(uiFile))
            for member in members:
                if (member.nodeName == member.name):
                    fCppOut.write(WIDGET.format(member.name, member.realClass()))
                else:
                    fCppOut.write(WIDGET_TAG.format(member.name, member.realClass(), member.nodeTag))
                fCppOut.write(ASSERT_WIDGET.format(member.name))

            fCppOut.write('}\n')
            continue
        fCppOut.write(line.replace('___FILEBASENAME___', subClassName))

    fCppOut.write('\n')
    fCppOut.close()


if __name__ == '__main__':
    main()

