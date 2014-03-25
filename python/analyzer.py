#!/usr/bin/env python
# coding: utf-8

import glob

class Analyzer(object):
    """ 日志分析基类 """

    def parse_file(self, pattern):
        """解析所有文件, pattern 文件名正则表达式"""
        file_list = glob.glob(pattern)
        for log_file in file_list:
            fp = open(log_file, 'r')
            lines = fp.readlines()
            for line in lines:
                self._handle_one_line(line)

    def analyze(self):
        pass

    def _handle_one_line(self, line):
        pass
