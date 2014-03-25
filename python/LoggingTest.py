#!/usr/bin/env python
#coding: utf-8

import sys

sys.path.append('./common')
import log
log.logger.setLevel(log.ERROR)

if __name__ == '__main__':
    log.initLogger('./logs/log.txt')
    log.d('this is a debug message')
    log.i("info 1+1=%d", 1+1)
    log.w('warning: %s', 'xxxxxx')
    log.e('error message')
    log.c("critical message, exit!")
