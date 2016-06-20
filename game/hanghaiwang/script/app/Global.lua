---
-- @module Global
Global = {}

Global.gDesignWidth = 640
Global.gDesignHeight = 960
Global.gSplashTimeout = 3
CCDirector:sharedDirector():getOpenGLView():setDesignResolutionSize(Global.gDesignWidth,Global.gDesignHeight, kResolutionShowAll)
Global.gVisibleHeight = CCDirector:sharedDirector():getVisibleSize().height
Global.gVisibleWidth = CCDirector:sharedDirector():getVisibleSize().width
Global.gVisibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
Global.gVersionCheckUrl = "http://192.168.1.200:8080/version.json"
