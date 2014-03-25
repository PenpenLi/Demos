#!/usr/bin/env python
#coding: utf-8

import sys
from conversion_analyzer import ConversionAnalyzer

sys.path.append('./common')
import log

def main():
    log.initLogger('./logs/analyzer.log')
    conv_analyzer = ConversionAnalyzer()
    conv_analyzer.parse_file('./20140324/conversion.log-20140324*')
    conv_analyzer.analyze()

if __name__ == '__main__':
    main()
