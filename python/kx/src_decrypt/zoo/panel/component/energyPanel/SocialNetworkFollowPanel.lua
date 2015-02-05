require "zoo.util.WeChatSDK"

SocialNetworkFollowPanel = class(BasePanel)

-- social network logo
kSocialType = {
	kWeChat = 1,
	kWeibo = 2,
	kMitalk = 3,
}
-- reward shown on panel
local reward = {
	itemId = 10013,
	num = 2
}

function SocialNetworkFollowPanel:create(energyPanel, socialType, maxTopPosYInWorldSpace)
	local panel = SocialNetworkFollowPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_energy_bubble)
	if panel:_init(energyPanel, socialType, maxTopPosYInWorldSpace) then return panel
	else
		panel = nil
		return nil
	end
end

function SocialNetworkFollowPanel:_init(energyPanel, socialType, maxTopPosYInWorldSpace)
	-- data
	self.maxTopPosYInWorldSpace = maxTopPosYInWorldSpace
	self.energyPanel = energyPanel

	-- init panel
	self.ui	= self:buildInterfaceGroup("SocialNetworkFollowPanel")
	BasePanel.init(self, self.ui)

	-- get & create controls
	self.background = self.ui:getChildByName("bg")
	self.gotoButton = self.ui:getChildByName("gotoSocialBtn")
	self.descLabel = self.ui:getChildByName("desLabel")
	self.rewardItem = self.ui:getChildByName("rewardIcon")
	local fontSize = self.ui:getChildByName("rewardNum_fontSize")
	local font = self.ui:getChildByName("rewardNum")
	local wechatLogo = self.ui:getChildByName("wechatLogo")
	wechatLogo:removeFromParentAndCleanup(false)
	local weiboLogo = self.ui:getChildByName("weiboLogo")
	weiboLogo:removeFromParentAndCleanup(false)
	local mitalkLogo = self.ui:getChildByName("mitalkLogo")
	mitalkLogo:removeFromParentAndCleanup(false)
	self.animalPic	= Sprite:createWithSpriteFrameName("npc_small_10000")

	-- set controls
	self.gotoButton = ButtonIconsetBase:create(self.gotoButton)
	self.gotoButton:setColorMode(kGroupButtonColorMode.blue)
	self.gotoButton:setString(Localization:getInstance():getText("social.network.follow.panel.btn"))
	wechatLogo:setScale(0.8)
	weiboLogo:setScale(0.8)
	mitalkLogo:setScale(0.8)
	if socialType == kSocialType.kWeChat then
		self.gotoButton:setIcon(wechatLogo, true)
		weiboLogo:dispose()
		mitalkLogo:dispose()
	elseif socialType == kSocialType.kWeibo then
		self.gotoButton:setIcon(weiboLogo, true)
		wechatLogo:dispose()
		mitalkLogo:dispose()
	elseif socialType == kSocialType.kMitalk then
		self.gotoButton:setIcon(mitalkLogo, true)
		wechatLogo:dispose()
		weiboLogo:dispose()
	end
	if socialType == kSocialType.kWeChat then
		self.descLabel:setString(Localization:getInstance():getText("social.network.follow.panel.desc.wechat", {n = '\n'}))
	elseif socialType == kSocialType.kWeibo then
		self.descLabel:setString(Localization:getInstance():getText("social.network.follow.panel.desc.weibo", {n = '\n'}))
	elseif socialType == kSocialType.kMitalk then
		self.descLabel:setString(Localization:getInstance():getText("social.network.follow.panel.mitalk", {n = '\n'}))
	end
	local sprite = ResourceManager:sharedInstance():buildItemSprite(reward.itemId)
	local position = self.rewardItem:getPosition()
	sprite:setPosition(ccp(position.x, position.y))
	self.rewardItem:getParent():addChildAt(sprite, 3)
	self.rewardItem:removeFromParentAndCleanup(true)
	self.rewardItem = sprite
	self.rewardNum = TextField:createWithUIAdjustment(fontSize, font)
	self.ui:addChild(self.rewardNum)
	self.rewardNum:setString("x"..reward.num)
	if self.animalPic then
		self.animalPic:setAnchorPoint(ccp(0,1))
		self:addChild(self.animalPic)
	end

	-- add event listener
	local function onButtonTapped()
		-- TODO: goto specific social network
		self:_gotoSocialNetwork(socialType)
	end
	self.gotoButton:addEventListener(DisplayEvents.kTouchTap, onButtonTapped)

	return true
end

function SocialNetworkFollowPanel:popout()
	PopoutManager:sharedInstance():add(self, false, true)
	if self.animalPic then
		print("self position", self:getPositionX(), self:getPositionY())
		print("animal position", self.animalPic:getPositionX(), self.animalPic:getPositionY())
	end
	self:_playFadeInAnim()
	self:_calcPosition()
end

function SocialNetworkFollowPanel:remove()
	local function onAnimFinished()
		if self and not self.isDisposed then
			PopoutManager:sharedInstance():remove(self)
		end
	end

	self:_playFadeOutAnim(onAnimFinished)
end

function SocialNetworkFollowPanel:_calcPosition()
	local selfSize = self:getGroupBounds().size
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local deltaWidth = vSize.width - selfSize.width
	local selfParent = self:getParent()

	print("selfParent", selfParent)
	if selfParent and self.maxTopPosYInWorldSpace then
		local pos = selfParent:convertToNodeSpace(ccp(vOrigin.x + deltaWidth / 2, self.maxTopPosYInWorldSpace))
		local manualAdjustPosY = 95
		self:setPosition(ccp(pos.x, pos.y + manualAdjustPosY))
	end

	if self.animalPic then
		local animalParent 	= self.animalPic:getParent()
		local animalPicSize	= self.animalPic:getGroupBounds().size
		local pos = animalParent:convertToNodeSpace(ccp(vOrigin.x, vOrigin.y + animalPicSize.height))

		self.animalPic:setPosition(ccp(pos.x, pos.y))
	end
end

function SocialNetworkFollowPanel:_playFadeInAnim()
	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	-- Fade In Time
	local fadeInTime	= 0.3

	for k,v in pairs(visibleChildren) do
		local fadeInAction = CCFadeIn:create(fadeInTime)
		v:runAction(fadeInAction)
	end
	local function onFinish() self.allowBackKeyTap = true end
	self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(fadeInTime), CCCallFunc:create(onFinish)))
end

function SocialNetworkFollowPanel:_playFadeOutAnim(animFinishCallback, ...)
	assert(false == animFinishCallback or type(animFinishCallback) == "function")
	assert(#{...} == 0)

	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	-- Fade Out Time
	local fadeOutTime	= 0.3

	-- ------------------
	-- Individual Fade out
	-- --------------------
	self.allowBackKeyTap = false
	local spawnActionArray = CCArray:create()
	for k,v in pairs(visibleChildren) do
		local fadeOutAction 	= CCFadeOut:create(fadeOutTime)
		local targetAction	= CCTargetedAction:create(v.refCocosObj, fadeOutAction)
		--actionArray:addObject(targetAction)
		spawnActionArray:addObject(targetAction)
	end
	local spawn = CCSpawn:create(spawnActionArray)


	-- -------------------
	-- Anim Finish Callback
	-- -------------------
	local function animFinishedFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction = CCCallFunc:create(animFinishedFunc)

	----------
	-- Seq
	-- --------
	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(spawn)
	actionArray:addObject(animFinishedAction)

	local seq = CCSequence:create(actionArray)

	self:runAction(seq)
end

function SocialNetworkFollowPanel:_gotoSocialNetwork(social)
	-- local dest = "about:blank"
	-- if social == kSocialType.kWeChat then
	-- 	dest = "http://weixin.com/qr/tHXFyjHEJg9ZhyCpnyCQ"
	-- elseif social == kSocialType.kWeibo then
	-- 	dest = "http://weibo.com/kaixinxiaoxiaole"
	-- end
	-- if __IOS then
	-- 	local nsURL = NSURL:URLWithString(dest)
	-- 	UIApplication:sharedApplication():openURL(nsURL)
	-- elseif __ANDROID then
	-- 	luajava.bindClass("com.happyelements.android.utils.HttpUtil"):openUri(dest)
	-- else
	-- 	CommonTip:showTip("on PC open your browser by yourself!")
	-- end

	if social == kSocialType.kWeChat then
		if __IOS or __ANDROID or __WP8 then
			local sdk = WeChatSDK.new()
			if not sdk:openWechat() then
				CommonTip:showTip(Localization:getInstance():getText("social.network.follow.panel.wechat.no.install"))
			end
		else
			CommonTip:showTip("on PC open your browser by yourself!")
		end
	elseif social == kSocialType.kWeibo then
		if __IOS then
			UIApplication:sharedApplication():openURL(NSURL:URLWithString("http://weibo.com/kaixinxiaoxiaole"))
		elseif __ANDROID then
			luajava.bindClass("com.happyelements.android.utils.HttpUtil"):openUri("http://weibo.com/kaixinxiaoxiaole")
		elseif __WP8 then
			Wp8Utils:OpenUrl("http://weibo.com/kaixinxiaoxiaole")
		else
			CommonTip:showTip("on PC open your browser by yourself!")
		end
	elseif social == kSocialType.kMitalk then
		if __ANDROID then
			local openMitalkSuccess = luajava.bindClass("com.happyelements.android.platform.xiaomi.MiGameShareDelegate"):openMitalkApp()
			if not openMitalkSuccess then
				CommonTip:showTip(Localization:getInstance():getText("social.network.follow.panel.mitalk.no.install"))
			end
		else
			CommonTip:showTip("on PC open your browser by yourself!")
		end
	end
end

function SocialNetworkFollowPanel:onCloseBtnTapped()
	if self.energyPanel then self.energyPanel:onCloseBtnTapped() end
end