#!/usr/bin/env python
# coding: utf-8


import httplib
import sys
import urllib


nl_url = "http://www.nongli.com/item3/searchNL.asp"
gl_url = "http://www.nongli.com/item3/searchGL.asp"
gl_tag = "<b>公历：</b>"
nl_tag = "<b>农历：</b>"
sizhu_tag = "<b>四柱：</b>"
sizhu_demo = "甲午 己巳 辛丑"


def usage():
    print sys.argv[0] + ' year month day'


def main():
    """"""
    if len(sys.argv) < 4:
        usage()
        sys.exit()

    params = {'year': sys.argv[1], 'month': sys.argv[2], 'day': sys.argv[3]}
    headers = {"Content-type": "application/x-www-form-urlencoded"}
    data = urllib.urlencode(params)
    con = httplib.HTTPConnection('www.nongli.com')
    con.request('POST', '/item3/searchNL.asp', data, headers)
    page = con.getresponse().read().decode('gb2312').encode('utf-8')
    index = page.rfind(sizhu_tag)
    print page[index+len(sizhu_tag):index+len(sizhu_tag)+len(sizhu_demo)]

if __name__ == '__main__':
    main()
