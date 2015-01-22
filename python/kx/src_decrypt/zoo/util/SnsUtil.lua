require "hecore.sns.SnsProxy"
require "zoo.util.WeChatSDK"

SnsUtil = {}

function SnsUtil.sendInviteMessage( shareType, shareCallback )
	local shareTitle = Localization:getInstance():getText("invite.friend.panel.share.title")
	local invitecode = tostring(AddFriendPanelModel:getUserInviteCode())
	-- 分享的文案
	local txtToShare = Localization:getInstance():getText("invite.friend.panel.share.desc", {yaoqingma = invitecode})
	
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
	local plarformName = StartupConfig:getInstance():getPlatformName()
	-- 分享的链接地址
	local link = NetworkConfig.redirectURL.."?invitecode="..invitecode.."&uid="..tostring(UserManager:getInstance().uid).."&pid="..tostring(plarformName)
	if __WP8 then 
		link = Wp8Utils:GetMarketDownloadUrl() 
	elseif PlatformConfig:isPlatform(PlatformNameEnum.k360) then -- 微信分享用
		link = link.."&package=android_360" 
	end
	-- 分享回调
	local inviteCallback = {
		onSuccess = function(result)
			print("share onSuccess")
			if shareType == PlatformShareEnum.kWechat or 
					shareType == PlatformShareEnum.kMiTalk then
				CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
			end

			if shareCallback and type(shareCallback.onSuccess) == "function" then
				shareCallback.onSuccess(result)
			end
		end,
		onError = function(errCode, errMsg)
			print("share onError")
			if shareType == PlatformShareEnum.kMiTalk then
--				SnsUtil.addTipsItem(Localization:getInstance():getText("share.feed.invite.code.faild.tips.mitalk"))
			elseif shareType == PlatformShareEnum.kWechat then
				SnsUtil.addTipsItem(Localization:getInstance():getText("share.feed.invite.code.faild.tips"))
			end

			if shareCallback and type(shareCallback.onError) == "function" then
				shareCallback.onError(errCode, errMsg)
			end
		end,
		onCancel = function()
			print("share onCancel")
			if shareType == PlatformShareEnum.kWechat then
				SnsUtil.addTipsItem(Localization:getInstance():getText("share.feed.cancel.tips"))
				-- CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
			end

			if shareCallback and type(shareCallback.onCancel) == "function" then
				shareCallback.onCancel()
			end
		end
	}
	
	if shareType == PlatformShareEnum.kWechat then -- 微信分享
		WeChatSDK.new():sendLinkMessage(shareTitle, txtToShare, thumb, link, false, inviteCallback)
	elseif shareType == PlatformShareEnum.k360 then -- 360分享
		if SnsProxy:isLogin() then 
			txtToShare	= "没网也能玩儿，现在来就送168元大礼包！"
			SnsProxy:shareLink(PlatformShareEnum.k360, shareTitle, txtToShare, link, thumb, inviteCallback)
		else
			SnsUtil.addTipsItem("该功能需要360账号联网登陆")
		end
	else
		SnsProxy:sendInviteMessage(shareType, nil, shareTitle, txtToShare, link, thumb, inviteCallback)
	end
end

function SnsUtil.sendTextMessage( shareType, title, message, isSendToFeeds, shareCallback )
	title = title or ""
	message = message or ""

	if shareType == PlatformShareEnum.kWechat then
		if WeChatSDK.new():sendTextMessage( message, isSendToFeeds ) then
			if shareCallback and shareCallback.onSuccess then shareCallback.onSuccess({}) end
		else
			if shareCallback and shareCallback.onError then shareCallback.onError() end
		end
	else
		SnsProxy:shareText( shareType, title, message, shareCallback )
	end
end

function SnsUtil.sendImageMessage( shareType, title, message, thumb, imageURL, shareCallback )
	title = title or ""
	message = message or ""

	if shareType == PlatformShareEnum.kWechat then
		if WeChatSDK.new():sendImageMessage(message, thumb, imageURL) then
			if shareCallback and shareCallback.onSuccess then shareCallback.onSuccess({}) end
		else
			if shareCallback and shareCallback.onError then shareCallback.onError() end
		end
	else
		SnsProxy:shareImage( shareType, title, message, imageURL, thumb, shareCallback )
	end
end

function SnsUtil.sendImageLinkMessage( shareType, title, message, thumb, imageURL, shareCallback)
	title = title or ""
	message = message or ""

	if shareType == PlatformShareEnum.kWechat then
		print("WeChatSDK sendImageLinkMessage")
		WeChatSDK.new():sendImageLinkMessage(txtToShare, thumb, imageURL, shareCallback)
	else
		SnsProxy:shareImage( shareType, title, message, imageURL, thumb, shareCallback )
	end
end

function SnsUtil.sendLinkMessage( shareType, title, message, thumb, webpageUrl, isSendToFeeds, shareCallback)
	title = title or ""
	message = message or ""
	if shareType == PlatformShareEnum.kWechat then
		WeChatSDK.new():sendLinkMessage(title, message, thumb, webpageUrl, isSendToFeeds, shareCallback)
	else
		SnsProxy:shareLink( shareType, title, message, webpageUrl, thumb, shareCallback )
	end
end

function SnsUtil.addTipsItem( msg )
	local item = RequireNetworkAlert.new(CCNode:create())
	item:buildUI(msg)
	local scene = Director:sharedDirector():getRunningScene()
	if scene then 
		scene:addChild(item) 
	end
end

function SnsUtil.sendLevelMessage( shareType, levelType, levelId, shareCallback )
	local timer = os.time() or 0
	local datetime = tostring(os.date("%y%m%d", timer))
	local levelId = levelId or 1
	local txtToShare = ""
	local shareTitle = Localization:getInstance():getText("share.feed.title")
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = nil
	if levelType == GameLevelType.kMainLevel then
		txtToShare = Localization:getInstance():getText("share.feed.text", {level=levelId})
		imageURL = string.format("http://static.manimal.happyelements.cn/level/jt0001%04d.jpg?v="..datetime, levelId)
	elseif levelType == GameLevelType.kHiddenLevel then
		local hidenLevelId = levelId - LevelConstans.HIDE_LEVEL_ID_START
		txtToShare = Localization:getInstance():getText("share.feed.text", {level="+"..hidenLevelId})
		imageURL = string.format("http://static.manimal.happyelements.cn/level/hide%04d.jpg?v="..datetime, levelId - LevelConstans.HIDE_LEVEL_ID_START)
	end

	local passLevelShareCallBack = {
		onSuccess = function(result)
			SnsUtil.showShareSuccessTip(shareType)

			if shareCallback and type(shareCallback.onSuccess) == "function" then
				shareCallback.onSuccess(result)
			end
		end,
		onError = function(errCode, errMsg)
			SnsUtil.showShareFailTip(shareType)

			if shareCallback and type(shareCallback.onError) == "function" then
				shareCallback.onError(errCode, errMsg)
			end
		end,
		onCancel = function()
			if shareCallback and type(shareCallback.onCancel) == "function" then
				shareCallback.onCancel()
			end
		end
	}

	if shareType == PlatformShareEnum.kWechat then
		WeChatSDK.new():sendImageLinkMessage(txtToShare, thumb, imageURL, passLevelShareCallBack)
	else
		SnsProxy:shareImage( shareType, shareTitle, txtToShare, imageURL, thumb, passLevelShareCallBack )
	end
end

function SnsUtil.shareAchivment( shareType, achivmentId, onSnapShootFinish, shareCallback )
	local sdk = WeChatSDK.new()
	local saveFilePath = HeResPathUtils:getUserDataPath() .. "/screen_shoot_"..achivmentId..".png"
	local thumFilePath = HeResPathUtils:getUserDataPath() .. "/screen_shoot_thumb_"..achivmentId..".png"

	if shareType ~= PlatformShareEnum.kWechat then -- 非微信分享，将截图存储到外部存储中，以防第三方app无法直接读取图片
		local exStorageDir = luajava.bindClass("com.happyelements.android.utils.ScreenShotUtil"):getGamePictureExternalStorageDirectory()
		if exStorageDir then
			saveFilePath = exStorageDir .. "/screen_shoot_"..achivmentId..".png"
			thumFilePath = exStorageDir .. "/screen_shoot_thumb_"..achivmentId..".png"
		end
	end

	local function onSnapShoot( status )
		if onSnapShootFinish then onSnapShootFinish() end
		
		local succeed = false
		if status == 1 then
			if shareType == PlatformShareEnum.kWechat then
				sdk:sendImageMessage(message, thumFilePath, saveFilePath)
			else
				local shareTitle = Localization:getInstance():getText("share.feed.title"..achivmentId)
				local shareText = Localization:getInstance():getText("share.feed.text"..achivmentId)
				SnsProxy:shareImage( shareType, shareTitle, shareText, saveFilePath, thumFilePath, shareCallback )
			end
		else
			if shareCallback and type(shareCallback.onError) == "function" then
				shareCallback.onError(0, "snap shoot faild!")
			end
		end
	end
	sdk:screenShots(saveFilePath, thumFilePath, onSnapShoot)	
end

function SnsUtil.weeklyRaceShareNo1( shareType, levelId, shareCallback)
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_first.jpg?v="..datetime)

	if not shareCallback then -- default callback
		shareCallback = {
			onSuccess = function(result)
				SnsUtil.showShareSuccessTip(shareType)
			end,
			onError = function(errCode, errMsg)
				SnsUtil.showShareFailTip(shareType)
			end,
			onCancel = function()
			end
		}
	end
	SnsUtil.sendImageLinkMessage( shareType, nil, nil, thumb, imageURL, shareCallback)
end

function SnsUtil.weeklyRaceShareSurpass( shareType, levelId, shareCallback)
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/week_pass.jpg?v="..datetime)

	if not shareCallback then -- default callback
		shareCallback = {
			onSuccess = function(result)
				SnsUtil.showShareSuccessTip(shareType)
			end,
			onError = function(errCode, errMsg)
				SnsUtil.showShareFailTip(shareType)
			end,
			onCancel = function()
			end
		}
	end
	SnsUtil.sendImageLinkMessage( shareType, nil, nil, thumb, imageURL, shareCallback)
end

function SnsUtil.shareRabbitWeeklyMatchFeed( shareType, shareCallback)
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/rabbit_weekly_match_feed.jpg?v="..datetime)
	
	if not shareCallback then -- default callback
		shareCallback = {
			onSuccess = function(result)
				SnsUtil.showShareSuccessTip(shareType)
			end,
			onError = function(errCode, errMsg)
				SnsUtil.showShareFailTip(shareType)
			end,
			onCancel = function()
			end
		}
	end
	SnsUtil.sendImageLinkMessage( shareType, nil, nil, thumb, imageURL, shareCallback)
end

function SnsUtil.qixiShare( shareType, levelId, shareCallback)
	local datetime = tostring(os.date("%y%m%d", timer))
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/thumb_main.png")
	local imageURL = string.format("http://static.manimal.happyelements.cn/feed/qixi_success.jpg?v="..datetime)
	
	if not shareCallback then -- default callback
		shareCallback = {
			onSuccess = function(result)
				SnsUtil.showShareSuccessTip(shareType)
			end,
			onError = function(errCode, errMsg)
				SnsUtil.showShareFailTip(shareType)
			end,
			onCancel = function()
			end
		}
	end
	SnsUtil.sendImageLinkMessage( shareType, nil, nil, thumb, imageURL, shareCallback)
end

function SnsUtil.showShareSuccessTip(shareType, text)
	if not text then
		if shareType == PlatformShareEnum.kMiTalk then
			text = Localization:getInstance():getText("share.feed.success.tips.mitalk")
		elseif shareType == PlatformShareEnum.kWechat then
			text = Localization:getInstance():getText("share.feed.success.tips")
		end
	end
	if text then CommonTip:showTip(text, "positive") end
end

function SnsUtil.showShareFailTip(shareType, text)
	if not text then
		if shareType == PlatformShareEnum.kMiTalk then
			text = Localization:getInstance():getText("share.feed.faild.tips.mitalk")
		elseif shareType == PlatformShareEnum.kWechat then
			text = Localization:getInstance():getText("share.feed.faild.tips")
		end
	end
	if text then SnsUtil.addTipsItem(text) end
end

function SnsUtil.showShareCancelTip(shareType, text)
	if not text then
		if shareType == PlatformShareEnum.kMiTalk then
			text = Localization:getInstance():getText("share.feed.cancel.tips.mitalk")
		elseif shareType == PlatformShareEnum.kWechat then
			text = Localization:getInstance():getText("share.feed.cancel.tips")
		end
	end
	if text then SnsUtil.addTipsItem(text) end
end
