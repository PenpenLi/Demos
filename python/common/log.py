#!/usr/bin/env python
#coding: utf-8

import logging
import logging.handlers

DEBUG = logging.DEBUG
INFO = logging.INFO
WARN = logging.WARNING
ERROR = logging.ERROR
CRITICAL = logging.CRITICAL

# create logger
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


d = logger.debug
i = logger.info
w = logger.warning
e = logger.error
c = logger.critical

def initLogger(log_file = None):
    logging.addLevelName(logging.DEBUG, 'D')
    logging.addLevelName(logging.INFO, 'I')
    logging.addLevelName(logging.WARNING, 'W')
    logging.addLevelName(logging.ERROR, 'E')
    logging.addLevelName(logging.CRITICAL, 'C')
    # create formatter
    formatter = logging.Formatter('%(asctime)s %(levelname)s/%(filename)s(%(lineno)d) -- %(message)s')

    # create console handler
    ch = logging.StreamHandler()
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    if log_file:
        # create file handler
        fh = logging.handlers.RotatingFileHandler(log_file, maxBytes=10*1024*1024, backupCount=5)
        fh.setFormatter(formatter)
        logger.addHandler(fh)


if __name__ == '__main__':
    initLogger()
    d("debug message: Hello %s", "World!")
    i("info message: %d", 100)
    w("warning message!")
    e('error')
    c('critical message!')
