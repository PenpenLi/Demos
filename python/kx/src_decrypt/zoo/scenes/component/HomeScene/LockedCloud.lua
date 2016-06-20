
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月 9日 13:47:28
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.baseUI.BaseUI"
require "zoo.panelBusLogic.UnlockLevelAreaLogic"
require "zoo.panelBusLogic.IsLockedCloudCanWaitToOpenLogic"

require "zoo.panel.UnlockCloudPanel"
require "zoo.panel.RequireNetworkAlert"
require "zoo.panel.recall.RecallFriendUnlockPanel"
require "zoo.panel.recall.RecallLevelUnlockPanel"
require "zoo.panel.recall.RecallItemPanel"
require "zoo.panel.UnlockCloudPanelWithTask"

require 'zoo.account.AccountBindingLogic'

local UnlockGuidePanel = class(BasePanel)
function UnlockGuidePanel:create()
	local instance = UnlockGuidePanel.new()
	instance:loadRequiredResource(PanelConfigFiles.unlock_guide_panel)
	instance:init()
	return instance
end

function UnlockGuidePanel:init()
	local ui = self.builder:buildGroup('unlock_guide_panel')
	BasePanel.init(self, ui)

	self.title = TextField:createWithUIAdjustment(self.ui:getChildByName("rect"), self.ui:getChildByName("title"))
	self.ui:addChild(self.title)
	-- self.rect = ui:getChildByName('rect')
	-- self.rect:setVisible(false)
	self.title:setString(localize('unlock.cloud.alert.title'))

	self.text = ui:getChildByName('text')

	self.btn = GroupButtonBase:create(ui:getChildByName('btn'))

	local qrcodeBtnUI = ui:getChildByName('qrcodeBtn')
	self.qrcodeBtn = GroupButtonBase:create(qrcodeBtnUI)
	self.qrcodeBtn.iconWechat = qrcodeBtnUI:getChildByName("iconSize")
	self.qrcodeBtn.iconMi = qrcodeBtnUI:getChildByName("iconSizeMi")
	self.qrcodeBtn.iconMi:setVisible(false)

	self.closeBtn = ui:getChildByName('closeBtn')
	self.closeBtn:setTouchEnabled(true, 0, true)
	self.closeBtn:ad(DisplayEvents.kTouchTap, function() self:onCloseBtnTapped() end)

	if FriendManager:getInstance():getAppFriendsCount() >= FriendManager:getInstance():getMaxFriendCount() then
		self.btn:setString(localize('unlock.cloud.alert.btn'))
		self.text:setString(localize('unlock.cloud.alert.text1'))
		self.btn:ad(DisplayEvents.kTouchTap, function () self:sendWechatMessage() end)

		self.qrcodeBtn:setVisible(false)
	elseif PlatformConfig:hasAuthConfig(PlatformAuthEnum.kQQ) and not UserManager:getInstance().profile:getSnsUsername(PlatformAuthEnum.kQQ) then
		self.btn:setString(localize('login.panel.button.5'))
		self.btn:setColorMode(kGroupButtonColorMode.orange)
		self.btn:ad(DisplayEvents.kTouchTap, function () self:doQQLogin() end)
		self.text:setString(localize('unlock.cloud.alert.text2'))

		self.qrcodeBtn:setVisible(false)
	else
		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then 
			self.qrcodeBtn.iconWechat:setVisible(false)
			self.qrcodeBtn.iconMi:setVisible(true)
			self.qrcodeBtn:setColorMode(kGroupButtonColorMode.blue)
			self.qrcodeBtn:setString(localize('invite.friend.panel.button.text.mitalk'))
		else
			self.qrcodeBtn.iconWechat:setVisible(true)
			self.qrcodeBtn.iconMi:setVisible(false)
			self.qrcodeBtn:setString(localize('my.card.btn2'))
		end
		self.text:setString(localize('unlock.cloud.alert.text3'))
		self.qrcodeBtn:ad(DisplayEvents.kTouchTap, function () self:sendQRCode() end)

		self.btn:setVisible(false)
	end
end

function UnlockGuidePanel:setFriendIds(friendIds)
	self.friendIds = friendIds
end

function UnlockGuidePanel:setCloudId(cloudId)
	self.cloudId = cloudId
end

function UnlockGuidePanel:sendWechatMessage()
	local function restoreBtn()
        if self.btn.isDisposed then return end
        self.btn:setEnabled(true)
    end
	local shareCallback = {
        onSuccess=function(result)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
            restoreBtn()
        end,
        onError=function(errCode, msg)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.code.faild.tips"), "positive")
            restoreBtn()
        end,
        onCancel=function()
            CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
            restoreBtn()
        end
    }
	local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
	local title = '帮我解锁吧~'
	local message = '我想玩新关卡，请你帮忙哦~'
	local link = NetworkConfig.dynamicHost.."unlock_area.html"
	link = link.."?pf="..StartupConfig:getInstance():getPlatformName()
	link = link.."&sender="..UserManager:getInstance().user.uid or "12345"
	if self.friendIds then
		link = link..'&receivers='
		for i = 1, #self.friendIds do
			link = link..self.friendIds[i]
			if i ~= #self.friendIds then
				link = link..'a'
			end
		end
	end
	if self.cloudId then
		link = link..'&cloudId='..tostring(self.cloudId)
	end
	self.btn:setEnabled(false)
	setTimeOut(restoreBtn, 2)
	SnsUtil.sendLinkMessage(PlatformShareEnum.kWechat, title, message, thumb, link, false, shareCallback)
end

function UnlockGuidePanel:doQQLogin()
	self.btn:setEnabled(false)
    local authorizeType = PlatformAuthEnum.kQQ
    local function finishCallback(mustExit)
    	if not self.isDisposed then
    		self:onCloseBtnTapped()
    	end
    end
    local function errorCallback()
    	if not self.isDisposed then
    		self.btn:setEnabled(true)
    	end
        -- CommonTip:showTip('testing 登陆失败')
    end
    local function cancelCallback()
    	if not self.isDisposed then
    		self.btn:setEnabled(true)
    	end
        -- CommonTip:showTip('testing 登陆取消')
    end
    if __WIN32 then
        finishCallback(false)
    else
        AccountBindingLogic:bindNewSns(authorizeType, finishCallback, errorCallback, cancelCallback)
    end
end

function UnlockGuidePanel:sendQRCode()
    local function restoreBtn()
        if self.qrcodeBtn.isDisposed then return end
        self.qrcodeBtn:setEnabled(true)
    end

    local function onSuccess()
        restoreBtn()
        DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = 4}, true)
    end
    local function onError(errCode, msg)
        restoreBtn()
    end
    local function onCancel()
        restoreBtn()
    end

    --just for mitalk
    local shareCallback = {
        onSuccess=function(result)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
            restoreBtn()
            DcUtil:UserTrack({category = 'message', sub_category = 'message_center_send_qrcode', where = 4}, true)
        end,
        onError=function(errCode, msg)
            CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.code.faild.tips"), "positive")
            restoreBtn()
        end,
        onCancel=function()
            CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
            restoreBtn()
        end
    }
    self.qrcodeBtn:setEnabled(false)
    setTimeOut(restoreBtn, 2)

    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then        
        SnsUtil.sendInviteMessage(PlatformShareEnum.kMiTalk, shareCallback)
    else
        PersonalCenterManager:sendBusinessCard(onSuccess, onError, onCancel)
    end 
end

function UnlockGuidePanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, true)
end

function UnlockGuidePanel:popout()
	self.allowBackKeyTap = true

	PopoutManager:sharedInstance():add(self, true, false)
	self:setPositionForPopoutManager()
end


---------------------------------------------------
-------------- LockedCloud
---------------------------------------------------

LockedCloud = class(Sprite)

assert(not LockedCloudState)
LockedCloudState = {

	STATIC		= 1,
	WAIT_TO_OPEN	= 2,
	OPENING		= 3
}

local function checkLockedCloudState(state, ...)
	assert(state)
	assert(#{...} == 0)

	assert(state == LockedCloudState.STATIC or
		state == LockedCloudState.WAIT_TO_OPEN or
		state == LockedCloudState.OPENING)
end

--function LockedCloud:init(lockedCloudId, ...)
function LockedCloud:init(lockedCloudId, animLayer, texture, ...)
	assert(type(lockedCloudId) == "number")
	assert(animLayer)
	assert(texture)
	assert(#{...} == 0)

	-- ----------------
	-- Init Base Class
	-- ---------------
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)
	self.refCocosObj:setTexture(texture)

	-- -----
	-- Data
	-- ------
	self.id 		= lockedCloudId
	self.cloudLock 		= false
	self.animLayer		= animLayer		-- Used For Play Animation, Because Static Clould Can Batch, Other Anim Has Problem In Batch
	self.selfAnimated	= Layer:create()	-- Represetn Self In self.animLayer

	-----------------
	-- Data About UI
	-- ------------
	self.staticCloudWidth	= false
	self.staticCloudHeight	= false

	-- ------------
	-- Update View
	-- -----------
	-- Initial State
	-- Check Current State 
	-- If User's Top Level Is One Level Before Cur Lock Area's Start Level
	-- And User's TOp Level Has Star ( Means User Complete That Level )
	-- Then Is The Time To Show Lock 
	
	-- Data For Center Self Sprite
	self.staticSpriteWidth 		= false
	self.waitToOpenSpriteWidth	= false
	self.openingSpriteWidth		= false

	if self:ifCanWaitToOpen() then
		self:changeToStateWaitToOpen()
	else
		self:changeToStateStatic()
	end

	-------------
	--- Init Position 
	---------------
	-- Get Position Y Based On Node Position
	-- Get Start Node Id In Cur Level Area
	local curLevelAreaData = MetaModel:sharedInstance():getLevelAreaDataById(self.id)
	local curStartNodeId = tonumber(curLevelAreaData.minLevel)
	assert(curStartNodeId)
	self.startNodeId = curStartNodeId

	function self:hitTestPoint( worldPosition, useGroupTest )
		local bounds = self:getGroupBounds()

		bounds = CCRectMake(
			360 - 250,
			bounds:getMidY() - 120,
			500,
			240
		)

		return bounds:containsPoint(worldPosition)
 	end

end

function LockedCloud:updateState( ... )
	-- body
	if self:ifCanWaitToOpen() then
		self:changeState(LockedCloudState.WAIT_TO_OPEN, false)
	end
end

function LockedCloud:getStartNodeId(...)
	assert(#{...} == 0)

	return self.startNodeId
end

-------------------------
---- Change State
------------------------

function LockedCloud:changeState(newState, animFinishCallback, ...)
	assert(newState)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	checkLockedCloudState(newState)

	-- ---------------------
	-- End Previous State
	-- ----------------------
	if self.state == LockedCloudState.STATIC then
		self:endStateStatic()
	elseif self.state == LockedCloudState.WAIT_TO_OPEN then
		self:endStateWaitToOpen()
	else
		assert(false)
	end

	-- --------------
	-- Enter New State
	-- ----------------
	if newState == LockedCloudState.STATIC then
		self:changeToStateStatic()
	elseif newState == LockedCloudState.WAIT_TO_OPEN then
		self:changeToStateWaitToOpen()
	elseif newState == LockedCloudState.OPENING then
		self:changeToStateOpening(animFinishCallback)
	end
end

------------------------
--------- State Static
-----------------------

function LockedCloud:changeToStateStatic(...)
	assert(#{...} == 0)

	self.state = LockedCloudState.STATIC
	
	self.lockedCloud = Clouds:buildStatic()

	-- Set Self Texture
	local texture = self.lockedCloud:getTexture()
	self:setTexture(texture)

	local size = self.lockedCloud:getGroupBounds().size
	self.lockedCloud:setPosition(ccp(size.width/2, -size.height/2))

	--self.ui:addChild(self.lockedCloud)
	self:addChild(self.lockedCloud)
end

function LockedCloud:endStateStatic(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.STATIC)

	self.lockedCloud:removeFromParentAndCleanup(true)
	self.lockedCloud = nil
end

----------------------------------------------
----- State: Wait_To_Open
-------------------------------------------

function LockedCloud:changeToStateWaitToOpen(...)
	assert(#{...} == 0)
	-- -------------------
	-- Add Event Listener
	-- ----------------------

	if self.state == LockedCloudState.WAIT_TO_OPEN then
		return 
	end

	local function onLockedCloudTapped(event, ...)
		assert(event)
		assert(#{...} == 0)

		self:onLockedCloudTapped(event)
	end
	self:addEventListener(DisplayEvents.kTouchTap, onLockedCloudTapped)

	self.state = LockedCloudState.WAIT_TO_OPEN

	if not self.lock then

		self.lock		= Clouds:buildLock()
	end 
	if not self.waitedCloud then 
		self.waitedCloud	= Clouds:buildWait()
	end

	-- Set Self Texture
	local texture = self.waitedCloud:getTexture()
	self:setTexture(texture)

	self.waitedCloud:addChild(self.lock)
	self:addChild(self.waitedCloud)

	local size	= self:getGroupBounds().size
	self.waitedCloud:setPosition(ccp(size.width/2 -16, -size.height/2 -12))

	self.lock:wait()
	self.waitedCloud:wait()

	-- Below Code Is Same AS Code In HomeScene, When Initially Create The LockedCloud And
	-- Center It . For Adjust THe Wait To Open Anim Stay The Same Center Position As The Static Cloud
	
	-- Center It Horizontal
	local visibleSize 	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local deltaWidth	= visibleSize.width - size.width 
	local halfDeltaWidth	= deltaWidth / 2
	self:setPositionX(visibleOrigin.x + halfDeltaWidth)

	local manualAdjustPosY	= - 10 - 5 - 5 -5 + 2
	self:setPositionY(self:getPositionY() + manualAdjustPosY)
end

-- Over Ride The setPositionX Function In CocosObject, 
-- For Update The self.selfAnimated Position 
function LockedCloud:setPositionX(x, ...)
	assert(type(x) == "number")
	assert(#{...} == 0)

	CocosObject.setPositionX(self, x)
	self.selfAnimated:setPositionX(x)
end

-- Same As LockedCloud:setPositionX
function LockedCloud:setPositionY(y, ...)
	assert(type(y) == "number")
	assert(#{...} == 0)

	CocosObject.setPositionY(self, y)
	self.selfAnimated:setPositionY(y)
end

function LockedCloud:endStateWaitToOpen(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.WAIT_TO_OPEN)

	-- Do Nothing
end

-- 在同步出错回退关卡进度的时候有可能导致从 WAIT_TO_OPEN 状态回到 STATIC 状态
-- 鉴于 OPENING 状态对 WAIT_TO_OPEN 状态的依赖只好加这样一个接口手动删除显示对象
function LockedCloud:manualDisposeWaitToOpenSprites()
	if self.lock then
		self.lock:removeFromParentAndCleanup(true)
		self.lock = nil
	end 
	if self.waitedCloud then 
		self.waitedCloud:removeFromParentAndCleanup(true)
		self.waitedCloud = nil
	end
end

------------------------------------------------
--------- State: Opening
--------------------------------------------

function LockedCloud:changeToStateOpening(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local animWaitToFinish = 2

	local function cloudAnimFinished()

		animWaitToFinish = animWaitToFinish - 1

		if animWaitToFinish == 0 then
			self:removeChildren(true)

			-- Callback
			if animFinishCallback then
				animFinishCallback()
			end
		end
	end

	local function lockAnimFinished()

		animWaitToFinish = animWaitToFinish - 1

		if animWaitToFinish == 0 then
			self:removeChildren(true)

			-- Callback
			if animFinishCallback then
				animFinishCallback()
			end
		end
	end

	self.lock:addEventListener(Events.kComplete, lockAnimFinished)

	-- Fade Out
	self.waitedCloud:fadeOut(cloudAnimFinished)
	self.lock:fadeOut(lockAnimFinished)
end

function LockedCloud:endStateOpening(...)
	assert(#{...} == 0)
	assert(self.state == LockedCloudState.OPENING)
end

function LockedCloud:unlockCloud(  )
	-- body
	if self.state == LockedCloudState.WAIT_TO_OPEN then
		local function onOpeningAnimFinished()
			local runningScene = HomeScene:sharedInstance()
			runningScene:checkDataChange()
			runningScene.starButton:updateView()
			runningScene.goldButton:updateView()
			runningScene.worldScene:onAreaUnlocked(self.id)
		end
		self:removeAllEventListeners()
		self:changeState(LockedCloudState.OPENING, onOpeningAnimFinished)
	end
end
---------------------------------------------------
---------- Event handler
-----------------------------------------------

function LockedCloud:handleWaitToOpen(finishCallback)
	local function onSuccessCallback()

		print("LockedCloud:onLockedCloudTapped Called ! onSuccessCallback !")

		local function onOpeningAnimFinished()
			local runningScene = HomeScene:sharedInstance()
			runningScene:checkDataChange()
			runningScene.starButton:updateView()
			runningScene.goldButton:updateView()
			runningScene.worldScene:onAreaUnlocked(self.id)
		end
		self:removeAllEventListeners()
		self:changeState(LockedCloudState.OPENING, onOpeningAnimFinished)
		if finishCallback then finishCallback() end
	end

	local function onHasNotEnoughStarCallback(userTotalStar, neededStar, ...)
		assert(type(userTotalStar)	== "number")
		assert(type(neededStar)		== "number")

		local function closeBtnCallback(isUnlockSuccess, friendIdsSent)
			if isUnlockSuccess ~= true 
			and ((friendIdsSent and #friendIdsSent > 0) or (FriendManager:getInstance():getFriendCount() == 0)) then
				self:showUnlockGuide(friendIdsSent)
			end
		end

		local unlockCloudPanel = nil
		if RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_SHORT or
		   RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_MIDDLE then 
			unlockCloudPanel = RecallLevelUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
		elseif RecallManager.getInstance():getFinalRewardState() == RecallRewardType.AREA_LONG then 
			unlockCloudPanel = RecallFriendUnlockPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
		elseif MetaManager.getInstance():isTaskCanUnlockLevalArea(self.id) then
			local taskLevelId = MetaManager.getInstance():getTaskLevelId(self.id)
			unlockCloudPanel = UnlockCloudPanelWithTask:create(self.id, userTotalStar, neededStar, onSuccessCallback, taskLevelId)
		else 
			unlockCloudPanel = UnlockCloudPanel:create(self.id, userTotalStar, neededStar, onSuccessCallback)
		end
		unlockCloudPanel.closeBtnCallback = closeBtnCallback -- 点关闭按钮
		unlockCloudPanel.closeCallback = finishCallback -- 面板关闭（不区分哪种关闭）
		if unlockCloudPanel then unlockCloudPanel:popout(false) end

		-- Update Frinds Info
		HomeScene:sharedInstance():updateFriends()
	end

	local function onFailCallback(errorCode)
		-- CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative", finishCallback)
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative", finishCallback)
	end

	local user = UserManager:getInstance().user

	-- if user:getTopLevelId() == 15 or RequireNetworkAlert:popout() then
	local unlockLevelAreaLogic = UnlockLevelAreaLogic:create(self.id)
	unlockLevelAreaLogic:setOnSuccessCallback(onSuccessCallback)
	unlockLevelAreaLogic:setOnFailCallback(onFailCallback)
	unlockLevelAreaLogic:setOnHasNotEnoughStarCallback(onHasNotEnoughStarCallback)
	unlockLevelAreaLogic:start(UnlockLevelAreaLogicUnlockType.USE_STAR, {})	-- Dafult Show COmmunicating Tip And Block The Input
	-- end
end


function LockedCloud:onLockedCloudTapped(event, ...)
	assert(event)
	assert(event.name == DisplayEvents.kTouchTap)
	assert(#{...} == 0)

	if self.state == LockedCloudState.STATIC then
		-- DO Nothing
	elseif self.state == LockedCloudState.WAIT_TO_OPEN then

		self:handleWaitToOpen()

	elseif self.state == LockedCloudState.OPENING then
		-- Do Nothing
	end
end

function LockedCloud:ifCanWaitToOpen(...)
	assert(#{...} == 0)
	
	local logic = IsLockedCloudCanWaitToOpenLogic:create(self.id)
	return logic:start()
end

function LockedCloud:create(lockedCloudId, animLayer, texture, ...)
	assert(type(lockedCloudId) == "number")
	assert(animLayer)
	assert(texture)
	assert(#{...} == 0)

	local newLockedCloud = LockedCloud.new()
	newLockedCloud:init(lockedCloudId, animLayer, texture)
	return newLockedCloud
end
local function now()
    return os.time() + __g_utcDiffSeconds or 0
end
function LockedCloud:showUnlockGuide(friendIdsSent)
	local today = os.date('*t', now())
	local key = string.format('unlock.guide.%d.%d.%d', today.year, today.month, today.day)
	if not CCUserDefault:sharedUserDefault():getBoolForKey(key, false) then
		CCUserDefault:sharedUserDefault():setBoolForKey(key, true)
		local panel = UnlockGuidePanel:create()
		panel:setFriendIds(friendIdsSent)
		panel:setCloudId(self.id)
		panel:popout()
	end
end
