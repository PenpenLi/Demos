#!/usr/bin/python
# _*_ coding: utf-8 _*_

CLK_UID, CLK_AUID, CLK_CID, CLK_UA, CLK_AREA, CLK_RID, CLK_TIME, CLK_USERID, CLK_CPT, CLK_AP, CLK_MP, CLK_RATE = range(12)
UID_MAC, UID_IMEI, UID_UDID, UID_IDFA, UID_IDFV, UID_GAMEID = range(6)


class Click(object):
    """ click model """
    def __init__(self):
        self.uid = ''
        self.auid = ''
        self.cid = 0
        self.ua = ''
        self.area = ''
        self.rid = ''
        self.time = ''
        self.userid = 0
        self.cpt = 0
        self.ap = 0.0
        self.mp = 0.0
        self.rate = 0
        self.hour = ''
        self.device = ''

    def __str__(self):
        return "Click: auid={0}, area={1}, cid={2}, userid={3}, uid={4}".format(\
        self.auid, self.area, self.cid, self.userid, self.uid)

    def from_string(self, s):
        """ parse form string """
        v = s.split('|')
        self.uid = v[CLK_UID]
        self.auid = v[CLK_AUID]
        self.cid = int(v[CLK_CID])
        self.ua = v[CLK_UA]
        self.area = v[CLK_AREA]
        self.rid = v[CLK_RID]
        self.time = v[CLK_TIME]
        self.userid = int(v[CLK_USERID])
        self.cpt = int(v[CLK_CPT])
        self.ap = 0.0 if v[CLK_AP] == '' else float(v[CLK_AP])
        self.mp = 0.0 if v[CLK_MP] == '' else float(v[CLK_MP])
        self.rate = v[CLK_RATE]
        # time 2014-03-24 00:00:05
        self.hour = self.time[11:2]
        uids = self.uid.split('_&')
        self.device = uids[UID_IDFA]
