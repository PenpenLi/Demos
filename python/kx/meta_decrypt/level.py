#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import json

if __name__ == '__main__':
    decodejson = json.load(file('customize.inf'))
    four_levels = []
    for level in decodejson:
        if len(level['gameData']['scoreTargets']) == 4:
            four_levels.append(level['totalLevel'])

    print(four_levels)
