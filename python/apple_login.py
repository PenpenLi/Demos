#!/usr/bin/env python
# _*_ coding: utf-8 _*_

import httplib

if __name__ == '__main__':
    headers = {
        'X-Apple-Client-Versions': 'iBooks/4.1.1; GameCenter/2.0; Podcasts/2.2',
        'X-Apple-Store-Front': '143465-19,26 ab:WJ6jMoo0',
        'X-Apple-ActionSignature': 'AhJcmca/FBqfvz9nwvaygW12liwoPIwUjj84g2L/Qz7LAAABUAMAAABrAAAAgH96uHUS66QjuBNJ2i7Aakcd6ufJuI9gSo/awwDJZ6gHCqbW1vsPeEVbXCAlnzD21JX+Kp8j2+BXKXF0bSuudET4SjNTeQUwRWDIjU0fCNCBfvP+y1PJsVoJBYRPhJoEbpWZHLWROPiP9JVoUJS00dOSKbwfcDe9XWZqtD4i7nRRAAAAGjoHdEJz1fTLonZ+gzfffaRgJRUOXxi1FtyjAAAAnwGVbTS+ILv9aEIggQK0CVhMpWVskwAAAIYDBfFpLalAg0JzDijVWhL4mS1YB3wpBflc2Pe0A8h6XS8+GjyQZHWClxpWxDKebZhy7b5Wo5vqQ0V0paFJuyZMyoJITckraHGl8daPqUbtXQgoJ2SC78wajKBelaXzyYCwpjSfkc4NDE6j7b6SCpMsyhAMMkzcoGPzd/u/KV6lDO/cgw4R+gAAAAAAAAEEOEQ0AA==',
        'Accept-Language': 'zh-Hans',
        'Content-Type': 'application/x-apple-plist',
        'User-Agent': 'com.apple.Preferences/1 iOS/8.1.2 model/iPhone7,1 build/12B440 (6; dt:107)',
        'X-Apple-Connection-Type': 'WiFi',
    }
    params = {}
    body = '<?xml version="1.0" encoding="UTF-8"?>\n\
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n\
<plist version="1.0">\n\
<dict>\n\
	<key>appleId</key>\n\
	<string></string>\n\
	<key>attempt</key>\n\
	<string>0</string>\n\
	<key>createSession</key>\n\
	<string>true</string>\n\
	<key>guid</key>\n\
	<string></string>\n\
	<key>kbsync</key>\n\
	<data>\n\
	</data>\n\
	<key>password</key>\n\
	<string></string>\n\
	<key>rmp</key>\n\
	<string>0</string>\n\
	<key>why</key>\n\
	<string>signIn</string>\n\
</dict>\n\
</plist>\n'
    con = httplib.HTTPSConnection('p24-buy.itunes.apple.com')
    con.request('POST', '/WebObjects/MZFinance.woa/wa/authenticate', body, headers)
    res = con.getresponse()
    print res.status, res.reason
    print res.read()
    print res.getheaders()
    print res.getheader('location')
    print res.getheader('itpod')

