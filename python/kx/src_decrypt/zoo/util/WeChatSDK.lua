-------------------------------------------------------------------------
--  Class include: WeChatAndroid, WeChatiOS, WeChatSDK
-------------------------------------------------------------------------

require "hecore.class"

--share callback 
local function buildError(errorCode,extra)
  return { errorCode = errorCode, msg = extra }
end

local function buildCallbackAndroid(callback, resultParser)
    if type(callback) == "table" then
        return convertToInvokeCallback(callback)
    end
  
    local function onError(errorCode, extra)
        if callback then
            callback(SnsCallbackEvent.onError, buildError(errorCode, extra) )
        end
    end

    local function onCancel()
        if callback then
            callback(SnsCallbackEvent.onCancel)
        end
    end
      
    local function onSuccess(result)
        local tResult = nil
        if resultParser ~= nil then
            tResult = resultParser(result)
        end

        if callback then
            callback(SnsCallbackEvent.onSuccess, tResult)
        end
    end
      
    return luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = onSuccess,
        onError = onError,
        onCancel = onCancel
    })
end

local function buildCallbackIos(callback)
	waxClass{"IosCallback",NSObject,protocols={"SimpleCallbackDelegate"}}
	function IosCallback:onSuccess(result)
		if callback.onSuccess then 
			callback.onSuccess();
		end
	end
	function IosCallback:onFailed(result)
		if callback.onError then 
			callback.onError();
		end
	end
	function IosCallback:onCancel()
		if callback.onCancel then 
			callback.onCancel();
		end
	end

	local iosCallback = IosCallback:init()
	return iosCallback;
end

local defaultShareCallback = {
		onSuccess=function(result)
			CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
		end,
		onError=function(errCode, msg) 
			local scene = Director:sharedDirector():getRunningScene()
			if scene then
				local item = RequireNetworkAlert.new(CCNode:create())
				item:buildUI(Localization:getInstance():getText("share.feed.invite.code.faild.tips"))
				scene:addChild(item)  
			end
		end,
		onCancel=function()
			CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
		end
	}
--
-- WeChatAndroid ---------------------------------------------------------
--
-- initialize
local instanceAndroid = nil
WeChatAndroid = {sdk=nil}

local shareProxy
if __ANDROID then
	shareProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSShareProxy"):getInstance()
end

function WeChatAndroid.getInstance()
	if not instanceAndroid then
		instanceAndroid = WeChatAndroid;
		print("=========================Startup WeChatAndroid============================");
		instanceAndroid.sdk = luajava.bindClass("com.happyelements.hellolua.share.WeChatUtil").INSTANCE
	end
	return instanceAndroid;
end

function WeChatAndroid:openWechat()
	return self.sdk:openWechat()
end

function WeChatAndroid:sendTextMessage( message, isSendToFeeds, shareCallback)
	shareProxy:setShareType(PlatformShareEnum.kWechat)
	local finalCallBack = shareCallback;	
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	return self.sdk:sendAnimalTextMessage(message, buildCallbackAndroid(finalCallBack, nil))
end

--防止微信两次回调特殊处理
local emptyCallback = {
	onSuccess=function(result)
	end,
	onError=function(errCode, msg) 
	end,
	onCancel=function()
	end
}

function WeChatAndroid:sendImageMessage( message, thumb, image, shareCallback)
	shareProxy:setShareType(PlatformShareEnum.kWechat)
	local finalCallBack = shareCallback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	local shareResult = self.sdk:sendImageMessage(message, thumb, image, buildCallbackAndroid(emptyCallback, nil))
	--微信新版（6.0.X）导致分享到朋友圈的图片 或者分享后没回调 或者直接无法分享
	finalCallBack.onSuccess()
	--玩家分享就算成功
	return shareResult
end
function WeChatAndroid:sendImageLinkMessage( message, thumb, imageURL, shareCallback )
	shareProxy:setShareType(PlatformShareEnum.kWechat)
	local finalCallBack = shareCallback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	local shareResult = self.sdk:sendImageLinkMessage(message, thumb, imageURL, buildCallbackAndroid(emptyCallback, nil))
	--微信新版（6.0.X）导致分享到朋友圈的图片 或者分享后没回调 或者直接无法分享
	finalCallBack.onSuccess()
	--玩家分享就算成功
	return shareResult
end
function WeChatAndroid:sendLinkMessage( title, message, thumb, webpageUrl, isSendToFeeds, shareCallback )
	shareProxy:setShareType(PlatformShareEnum.kWechat)
	local weChatScene = 1
	if isSendToFeeds == false then weChatScene = 0 end 
	local finalCallBack = shareCallback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	local shareResult = nil
	if weChatScene==1 then 
		shareResult = self.sdk:sendLinkMessage(message, title, weChatScene, thumb, webpageUrl, buildCallbackAndroid(emptyCallback, nil))
		--weChatScene == 1 是发送到朋友圈 
		--微信新版（6.0.X）导致分享到朋友圈的链接分享后没回调 
		finalCallBack.onSuccess()
		--玩家分享就算成功
	else
		shareResult = self.sdk:sendLinkMessage(message, title, weChatScene, thumb, webpageUrl, buildCallbackAndroid(finalCallBack, nil))
	end
	return shareResult
end

function WeChatAndroid:screenShots( saveFile, thumbFile, onFileSaved )
	local snapCallback = luajava.createProxy("org.cocos2dx.lib.Cocos2dxSnapCallback", {
    	onSnapshot = function(status)
        	if onFileSaved ~= nil then onFileSaved(status) end
      	end
    })
    self.sdk:screenShots(saveFile, thumbFile, snapCallback)
	return true
end

--
-- WeChatiOS ---------------------------------------------------------
--
-- initialize
local instanceiOS = nil
WeChatiOS = {}

function WeChatiOS.getInstance()
	if not instanceiOS then
		instanceiOS = WeChatiOS;
		print("=========================Startup WeChatiOS============================");
	end
	return instanceiOS;
end

function WeChatiOS:openWechat()
	return WeChatProxy:openWechat()
end

function WeChatiOS:sendTextMessage( message, isSendToFeeds, callback )
	local weChatScene = 1
	if isSendToFeeds == false then weChatScene = 0 end
	local finalCallBack = callback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	return WeChatProxy:sendTextMessage_scene_callback(message, weChatScene, buildCallbackIos(finalCallBack))
end

function WeChatiOS:sendImageMessage( message, thumb, image, callback )
	local finalCallBack = callback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	return WeChatProxy:sendImageMessage_thumb_media_callback(message, thumb, image, buildCallbackIos(finalCallBack))
end

function WeChatiOS:sendImageLinkMessage( message, thumb, imageURL, callback )
	local finalCallBack = callback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	return WeChatProxy:sendImagelinkMessage_thumb_media_callback(message, thumb, imageURL, buildCallbackIos(finalCallBack)) 
end

function WeChatiOS:sendLinkMessage( title, message, thumb, webpageUrl, isSendToFeeds, callback )
	local weChatScene = 1
	if isSendToFeeds == false then weChatScene = 0 end
	local finalCallBack = callback;
	if not finalCallBack then finalCallBack=defaultShareCallback end;
	return WeChatProxy:sendLinkMessage_title_scene_thumb_webpageUrl_callback(message, title, weChatScene, thumb, webpageUrl, buildCallbackIos(finalCallBack)) 
end

function WeChatiOS:screenShots( saveFile, thumbFile, onFileSaved )
	local frame = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	if WeChatProxy:screenShots_thumb_width_height(saveFile, thumbFile, frame.width, frame.height) then
		if onFileSaved ~= nil then onFileSaved(1) end
	else
		if onFileSaved ~= nil then onFileSaved(0) end
	end
	return true 
end


--
-- WeChatWP8 ---------------------------------------------------------
--
-- initialize
local instanceWP8 = nil
WeChatWP8 = {}

function WeChatWP8.getInstance()
	if not instanceWP8 then
		instanceWP8 = WeChatWP8;
		-- init wp8 wechat sdk with appid and appsecret
		WeChatProxy:GetInstance():Init("wxbce98abdc911e371", "366b5a38d313a64e6afbc4b78e29e4a0")
		print("=========================Startup WeChatWP8============================");
	end
	return instanceWP8;
end

function WeChatWP8:openWechat()
	return WeChatProxy:GetInstance():OpenWXApp()
end

function WeChatWP8:sendTextMessage( message, isSendToFeeds, callback )
	if WeChatProxy:GetInstance():SendTextMsg(message, isSendToFeeds) then
		if callback and type(callback.onSuccess) == "function" then callback.onSuccess() end
		return true
	else
		if callback and type(callback.onError) == "function" then callback.onError() end
		return false
	end
end

function WeChatWP8:sendImageMessage( message, thumb, image, callback )
	if WeChatProxy:GetInstance():SendImageMsg(message, thumb, image, true) then
		if callback and type(callback.onSuccess) == "function" then callback.onSuccess() end
		return true
	else
		if callback and type(callback.onError) == "function" then callback.onError() end
		return false
	end
end

function WeChatWP8:sendImageLinkMessage( message, thumb, imageURL, callback )
	if WeChatProxy:GetInstance():SendImageLinkMsg(message, thumb, imageURL, true) then
		if callback and type(callback.onSuccess) == "function" then callback.onSuccess() end
		return true
	else
		if callback and type(callback.onError) == "function" then callback.onError() end
		return false
	end
end

function WeChatWP8:sendLinkMessage( title, message, thumb, webpageUrl, isSendToFeeds, callback )
	if WeChatProxy:GetInstance():SendLinkMsg(message, title, thumb, webpageUrl, isSendToFeeds) then
		if callback and type(callback.onSuccess) == "function" then callback.onSuccess() end
		return true
	else
		if callback and type(callback.onError) == "function" then callback.onError() end
		return false
	end
end

function WeChatWP8:screenShots( saveFile, thumbFile, onFileSaved )
	Wp8Utils:screenShots(saveFile, thumbFile, onFileSaved)
	return true 
end


--
-- WeChatSDK ---------------------------------------------------------
--
WeChatSDK = class()
function WeChatSDK:ctor()
	if __IOS then
		self.sdk = WeChatiOS:getInstance()
	end
	if __ANDROID then
		self.sdk = WeChatAndroid:getInstance()
	end
	if __WP8 then
		self.sdk = WeChatWP8:getInstance()
	end
end

function WeChatSDK:openWechat()
	if self.sdk then return self.sdk:openWechat() end
end

function WeChatSDK:sendTextMessage( message, isSendToFeeds, shareCallback )
	if self.sdk then return self.sdk:sendTextMessage(message, isSendToFeeds, shareCallback) end
end

function WeChatSDK:sendImageMessage( message, thumb, image, shareCallback )
	if self.sdk then return self.sdk:sendImageMessage(message, thumb, image, shareCallback) end
end

function WeChatSDK:sendImageLinkMessage( message, thumb, image, shareCallback)
	if self.sdk then return self.sdk:sendImageLinkMessage(message, thumb, image, shareCallback) end
end

function WeChatSDK:sendLinkMessage( title, message, thumb, webpageUrl, isSendToFeeds, shareCallback)
	if self.sdk then return self.sdk:sendLinkMessage(title, message, thumb, webpageUrl, isSendToFeeds, shareCallback) end
end

function WeChatSDK:sendLevelMessage( level, message )
	level = level or 1
	message = message or ""
	local timer = os.time() or 0
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = nil
	if LevelType:isMainLevel(level) then
		imageURL = string.format("http://static.manimal.happyelements.cn/level/jt0001%04d.jpg?v="..datetime, level)
	elseif LevelType:isHideLevel(level) then
		imageURL = string.format("http://static.manimal.happyelements.cn/level/hide%04d.jpg?v="..datetime, level - LevelConstans.HIDE_LEVEL_ID_START)
	end
	--local imageURL = "http://118.85.203.45/upload/matter/news/jpg/2012/10/12/16/13500308532577532.jpg"
	--CCFileUtils:sharedFileUtils():fullPathForFilename(string.format("level/weixin%04d.png", level)) 
	-- "http://img.178.com/jx3/201108/108354575516/108354683041.png" 
	return self:sendImageLinkMessage(message, thumb, imageURL)
end

function WeChatSDK:screenShots( saveFile, thumbFile, onFileSaved )
	if self.sdk then return self.sdk:screenShots(saveFile, thumbFile, onFileSaved) end
end

function WeChatSDK:weeklyRaceShareNo1(level, message)
	message = message or ''
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime, level)
	return self:sendImageLinkMessage(message, thumb, imageURL)
end

function WeChatSDK:weeklyRaceShareSurpass(level, message)
	message = message or ''
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_pass.jpg?v="..datetime, level)
	return self:sendImageLinkMessage(message, thumb, imageURL)
end

function WeChatSDK:qixiShare(level, message)
	message = message or ''
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/qixi_success.jpg?v="..datetime, level)
	return self:sendImageLinkMessage(message, thumb, imageURL)
end
