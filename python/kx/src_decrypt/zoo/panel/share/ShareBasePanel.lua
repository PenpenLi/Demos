require "zoo.panel.basePanel.BasePanel"
require "zoo.net.OnlineGetterHttp"

ShareBasePanel = class(BasePanel)

local ShareType = {
	LINK = 1,
	IMAGE = 2,
	NOTIFY = 3
}

function ShareBasePanel:ctor()
	self.rewardConfig = nil
end

function ShareBasePanel:init(shareType, titleName)
	BasePanel.init(self,self.ui)
	self.sharePriority = ShareManager:getShareConfig(self.shareId).priority

	self:initBg()
	self:initShareTitle(titleName)
	self:initShareBtn(shareType)

	self:runTitleAction()

	self.shareImagePath = HeResPathUtils:getResCachePath() .. "/share_image.jpg"
end

function ShareBasePanel:runTitleAction()
	self.shareTitle:setScale(0.5)
	local sequenceArr = CCArray:create()
	--CCEaseElasticOut
	sequenceArr:addObject(CCEaseBackOut:create(CCScaleTo:create(0.15, 1)))
	self.shareTitle:stopAllActions();
	self.shareTitle:runAction(CCSequence:create(sequenceArr));
end

function ShareBasePanel:initBg()
	local bg = self.ui:getChildByName('bg')
	local gradient = LayerGradient:create()
	gradient:setStartColor(ccc3(0, 0, 0))
	gradient:setEndColor(ccc3(0, 0, 0))
	gradient:setStartOpacity(200)
	gradient:setEndOpacity(200)

	gradient:setContentSize(CCSizeMake(720, 1280))
	gradient:setPosition(ccp(0, -1280))
	bg:getParent():addChildAt(gradient, bg:getZOrder())
	bg:removeFromParentAndCleanup(true) 

	self.closeBtnRes = self.ui:getChildByName("closeBtn")
	size = Director:sharedDirector():getVisibleSize()
	local pos = self.closeBtnRes:getPosition()
	self.closeBtnRes:setPosition(ccp(pos.x+(size.width-720)/2,pos.y+(size.height-1280)/2))
	local function onCloseBtnTapped()
		self:removePopout()
	end
	self.closeBtnRes:setTouchEnabled(true)
	self.closeBtnRes:setButtonMode(true)
	self.closeBtnRes:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
end

function ShareBasePanel:initShareTitle(titleName)
	assert(titleName)
	local shareTitleUI = self.ui:getChildByName("shareTitle")
	self.shareTitle = self:addToLayerColor(shareTitleUI,ccp(0.5,0)) 

	self.shareTitleString = TextField:createWithUIAdjustment(shareTitleUI:getChildByName("shareTitleSize"), shareTitleUI:getChildByName("shareTitle"))
	shareTitleUI:addChild(self.shareTitleString)
	self.shareTitleString:setString(titleName)
end

function ShareBasePanel:initShareBtn(shareType)
	self.btnTag = self.ui:getChildByName("btnTag")
	self.btnTagNum = self.btnTag:getChildByName("number")
	self.rewardConfig = ShareManager:getShareReward()
	if self.rewardConfig then 
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
		if sprite then
			sprite:setScale(0.3)
			local iconPos = self.btnTag:getChildByName("icon")
			iconPos:setVisible(false)
			sprite:setPositionXY(iconPos:getPositionX(), iconPos:getPositionY())
			local index = self.btnTag:getChildIndex(iconPos)
			self.btnTag:addChildAt(sprite, index)
		end
		self.btnTagNum:setText(self.rewardConfig.rewardNum)
	else
		self.btnTag:setVisible(false)
	end

	self.shareBtn = GroupButtonBase:create(self.ui:getChildByName('shareBtn'))
	if shareType == ShareType.NOTIFY then 
		self.shareBtn:setString(Localization:getInstance():getText('通知好友'))
	else
		self.shareBtn:setString(Localization:getInstance():getText('share.feed.button.achive'))
	end
	local function onShareBtnTapped()
		self:onShareBtnTapped()
	end
	self.shareBtn:addEventListener(DisplayEvents.kTouchTap, onShareBtnTapped)
end

function ShareBasePanel:addToLayerColor(ui,anchorPoint)
	local size = ui:getGroupBounds().size
	local pos = ui:getPosition()
	local layer = LayerColor:create()
    layer:setColor(ccc3(0,0,0))
    layer:setOpacity(0)
    layer:setContentSize(CCSizeMake(size.width, size.height))
    layer:setAnchorPoint(anchorPoint)
    layer:setPosition(ccp(pos.x, pos.y-size.height))
    
    local uiParent = ui:getParent()
    local index = uiParent:getChildIndex(ui)
    ui:removeFromParentAndCleanup(false)
    ui:setPosition(ccp(0,size.height))
    layer:addChild(ui)
    uiParent:addChild(layer)

    return layer
end

function ShareBasePanel:screenshotShareImage( ... )
	if self.share_background ~= nil then
		return
	end

	self.share_background = Sprite:create("share/share_background.png")
	local y = self.shareTitle:getPositionY()
	self.share_background:setAnchorPoint(ccp(0,0))

	local size = self.share_background:getContentSize()

	if _G.__use_small_res == true then
		self.share_background:setScale(0.625)
		size.width = size.width * 0.625
		size.height = size.height * 0.625
	end

	local children = self.ui:getChildrenList()

	for k,child in pairs(children) do
		local pos = child:getPosition()
		child:setPosition(ccp(pos.x, pos.y - y))
	end

	local btn = self.ui:getChildByName("closeBtn")
	btn:setVisible(false)

	self.ui:addChildAt(self.share_background, 1)

	local bg_2d = "share/share_background_2d.png"

	if _G.__use_small_res == true then
		bg_2d = "share/share_background_2d_small.png"
	end

	self.share_background_2d = Sprite:create(bg_2d)

	self.ui:addChild(self.share_background_2d)

	local size_2d = self.share_background_2d:getContentSize()
	self.share_background_2d:setPosition(ccp(size.width - size_2d.width / 2 - 5, size.height - size_2d.height / 2 - 5))

    local renderTexture = CCRenderTexture:create(size.width, size.height)
    renderTexture:begin()
    self.ui:visit()
    renderTexture:endToLua()
   	renderTexture:saveToFile(self.shareImagePath)

   	for k,child in pairs(children) do
		local pos = child:getPosition()
		child:setPosition(ccp(pos.x, pos.y + y))
	end

	self.share_background:setVisible(false)
	self.share_background_2d:setVisible(false)
	btn:setVisible(true)
end

function ShareBasePanel:onShareBtnTapped()
	self:screenshotShareImage()
	
	if __IOS_FB then
		--炫耀功能重新做  但这里没有改
		--这里shareId有新增 
		if SnsProxy:isShareAvailable() then
			local replaceObj = {}
			if shareId == 10 then replaceObj.num = kMaxLevels * 3 end
			local message = Localization:getInstance():getText("share.feed.text"..shareId, replaceObj)

			local callback = {
				onSuccess = function(result)
					--button:setVisible(true)
					--self.gamelogo:setVisible(false)
					self:removePopout()
					--self:onShareSucceed()
					CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
				end,
				onError = function(err)
					--button:setVisible(true)
					--self.gamelogo:setVisible(false)
					--self:removePopout()
					self:onShareFailed()
				end
			}
			local shareTitle = Localization:getInstance():getText("share.feed.title"..shareId)
			local shareImage = string.format("http://statictw.animal.he-games.com/mobanimal/fb/achievement/ach%04d.png", self.rewardID) 
			-- HeResPathUtils:getAppAssetsPath() .. "/resource/share/fb/share_" .. self.rewardID .. ".png"
			-- SnsProxy:sendNewFeedsWithLocalImage(FBOGActionType.REACH, FBOGObjectType.ACHIEVEMENT, shareTitle, message, shareImage, link, callback)
			SnsProxy:sendNewFeedsWithParams(FBOGActionType.REACH, FBOGObjectType.ACHIEVEMENT, shareTitle, message, shareImage, link, callback)
		end
	else 
		if self.shareId ==  ShareManager.SCORE_OVER_FRIEND or self.shareId == ShareManager.LEVEL_OVER_FRIEND then 
			--通知好友的处理不同 在SharePassFriendPanel中单独处理
			return 
		end
		DcUtil:UserTrack({category = "show", sub_category = "push_show_off_button_"..self.sharePriority})

		local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
		local shareCallback = {
			onSuccess = function(result)
				self:onShareSucceed()
			end,
			onError = function(errCode, errMsg)
				self:onShareFailed()
			end,
			onCancel = function()
				self:onShareFailed()
			end,
		}

		if ShareManager:checkIsLinkShare(self.shareId) then 
			SnsUtil.sendLinkMessage(PlatformShareEnum.kWechat, self.shareMessage, self.shareTitleName, thumb, self.shareLink, true, shareCallback)
		else
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				SnsUtil.sendImageMessage( PlatformShareEnum.kMiTalk, self.shareTitleName, self.shareTitleName, thumb, self.shareImagePath, shareCallback )
			else
				SnsUtil.sendImageMessage( PlatformShareEnum.kWechat, self.shareTitleName, self.shareTitleName, thumb, self.shareImagePath, shareCallback )
			end
		end
	end
end

function ShareBasePanel:onShareSucceed()
	--向后端同步
	local function onSuccess(event)
		if ShareManager:checkIsLinkShare(self.shareId) then 
		 	SnsUtil.showShareSuccessTip(PlatformShareEnum.kWechat)
		else
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		 		SnsUtil.showShareSuccessTip(PlatformShareEnum.kMiTalk) 
		 	else
		 		SnsUtil.showShareSuccessTip(PlatformShareEnum.kWechat)
		 	end
		end
        --打点
        DcUtil:UserTrack({category = "show", sub_category = "push_show_off_button_success_"..self.sharePriority})
        --发银币奖励
        if self.rewardConfig then 
	      	UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + self.rewardConfig.rewardNum)
			UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + self.rewardConfig.rewardNum)
		end
        --关闭
        self:removePopout()

        --记录炫耀次数
        ShareManager:increaseShareAllTime()
    end

    local function onFail(event)
       	--关闭
        self:removePopout()
    end
    
    local http = OpNotifyHttp.new()
    http:ad(Events.kComplete, onSuccess)
    http:ad(Events.kError, onFail)
    local param = nil
    if ShareManager:checkIsLinkShare(self.shareId) then 
    	param = "link"
    end
    http:load(OpNotifyType.kXuanYao, param)
end

function ShareBasePanel:onShareFailed()
	local scene = Director:sharedDirector():getRunningScene()
	if scene then
		local item = RequireNetworkAlert.new(CCNode:create())
		local shareFailedLocalKey = "share.feed.faild.tips"
		if not ShareManager:checkIsLinkShare(self.shareId) then 
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		 		shareFailedLocalKey = "share.feed.faild.tips.mitalk" 
		 	end
		end
		item:buildUI(Localization:getInstance():getText(shareFailedLocalKey))
		scene:addChild(item)  
	end
end

function ShareBasePanel:removePopout()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
end

function ShareBasePanel:popoutShowTransition()
	self:setToScreenCenterVertical()
	self:setToScreenCenterHorizontal()
end

function ShareBasePanel:popout()
	-- local scene = Director:sharedDirector():getRunningScene()
	-- if scene then 
	-- 	local origin = Director:sharedDirector():getVisibleOrigin()
	-- 	local winSize = CCDirector:sharedDirector():getVisibleSize()
	-- 	local size = self:getGroupBounds().size
	-- 	self:setPosition(ccp(origin.x, size.height+origin.y))

	-- 	scene:addChild(self) 
	-- end
	PopoutQueue.sharedInstance():push(self, false)
end