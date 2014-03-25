#!/usr/bin/env python
# coding: utf-8

import sys
sys.path.append('./common')
import log
import analyzer

log.logger.setLevel(log.INFO)

CV_UID,CV_APPID,CV_CID,CV_UA,CV_AREA,CV_RID,CV_AUID,CV_TIME,CV_USERID,CV_CPT,CV_PRICE,CV_REALPRICE,CV_RATE=range(13)

class Conversion(object):
    """conversion model"""

    def __init__(self):
        self.uid = ''
        self.cid = 0
        self.auid = ''
        self.userid = 0
        self.price = 0.0
        self.realprice = 0.0
        self.rate = 0

    def from_string(self, str):
        """parse from string"""
        v = str.split('|')
        self.uid = v[CV_UID]
        self.cid = int(v[CV_CID])
        self.auid = v[CV_AUID]
        self.userid = int(v[CV_USERID])
        self.ap = float(v[CV_PRICE])
        self.mp = float(v[CV_REALPRICE])
        self.rate = int(v[CV_RATE])

    def description(self):
        """description, for debug"""
        return "conversion: auid=" + self.auid + ", userid=" + str(self.userid) + ", cid=" + str(self.cid) + ", ap=" + str(self.ap) + ", mp=" + str(self.mp) + ", rate=" + str(self.rate)

class ConversionAnalyzer(analyzer.Analyzer):
    """conversion analyzer"""

    def __init__(self):
        #log.initLogger()
        self.conversions = []

    def analyze(self):
        log.i("analize: conversion count=%d", len(self.conversions))
        total_ap = 0.0
        total_mp = 0.0
        for conv in self.conversions:
            total_ap += conv.ap
            total_mp += conv.mp*conv.rate/10.0
        log.i("a: %.1f", total_ap)
        log.i("m: %.1f", total_mp)

    def _handle_one_line(self, line):
        conv = Conversion()
        conv.from_string(line)
        log.d(conv.description())
        self.conversions.append(conv)
