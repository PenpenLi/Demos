
AdVideoPanel = class(BasePanel)

function AdVideoPanel:create(wPos,reward)
	local s = AdVideoPanel.new()
	s:loadRequiredResource(PanelConfigFiles.panel_ad_video)
	s:init(wPos,reward)
	return s
end

function AdVideoPanel:init(wPos, reward)

	----------------------
	-- Get UI Componenet
	-- -----------------
	self.ui	= self:buildInterfaceGroup("AdVideoPanel")
	self.reward = reward
	--------------------
	-- Init Base Class
	-- --------------
	BasePanel.init(self, self.ui)
	self.ui:setTouchEnabled(true, 0, true)
	self.showHideAnim	= IconPanelShowHideAnim:create(self, wPos)
	self:initTexts()
	self:initBtns()

	self:initRewardIcon()
end

function AdVideoPanel:initRewardIcon( ... )
	-- body
	self.rewardIcon =ResourceManager:sharedInstance():buildItemSprite(self.reward.itemId)
	local replaceHold = self.ui:getChildByName("reward_icon")
	local pos = replaceHold:getPosition()
	local resize = replaceHold:getGroupBounds().size
	local iconSize = self.rewardIcon:getGroupBounds().size
	-- self.rewardIcon:setPosition(ccp(pos.x + (resize.width - iconSize.width)/2, pos.y - (resize.height - iconSize.height)/2))
	self.rewardIcon:setScale(resize.width/iconSize.width)
	self.rewardIcon:setPosition(ccp(pos.x, pos.y))
	replaceHold:getParent():addChild(self.rewardIcon)
	replaceHold:removeFromParentAndCleanup(true)

end 

function AdVideoPanel:initTexts( ... )
	-- body
	-- self.titleTxt = self.ui:getChildByName('title')
	-- self.titleTxt:setText(Localization:getInstance():getText('watch_ad_title'))
	-- local size = self.titleTxt:getContentSize()
	-- local scale = 65 / size.height
	-- self.titleTxt:setScale(scale)
	-- self.bg = self.ui:getChildByName("bg")
	-- self.titleTxt:setPositionX((self.bg:getGroupBounds().size.width - size.width * scale) / 2)

	self.wifi_tip = self.ui:getChildByName("wifi_tip")
	local wifi_text = self.wifi_tip:getChildByName("bg_text")
	wifi_text:setString(Localization:getInstance():getText("watch_ad_wifi"))

	self.reward_tip = self.ui:getChildByName("reward_tip")
	self.reward_tip:setString(Localization:getInstance():getText("watch_ad_text1"))
end

function AdVideoPanel:initBtns( ... )
	-- body
	-- close button
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap,  function(event) self:onCloseBtnTapped() end)

	--getRewardBtn 
	self.getRewardBtn = GroupButtonBase:create(self.ui:getChildByName("btn"))
	self.getRewardBtn:setString(Localization:getInstance():getText("watch_ad_button1"))
	self.getRewardBtn:addEventListener(DisplayEvents.kTouchTap, function( event )
		-- body
		self:onPlayBtnTap()
	end)

	--playBtn
	self.playBtn = self.ui:getChildByName("playBtn")
	self.playBtn:setTouchEnabled(true, 0, false)
	self.playBtn:setButtonMode(true)
	self.playBtn:addEventListener(DisplayEvents.kTouchTap, function( evt )
		-- body
		self:onPlayBtnTap()
	end)
end

function AdVideoPanel:successPlayUpdate( ... )
	-- body

	self.reward_tip:setString(Localization:getInstance():getText("watch_ad_text2"))
	self.getRewardBtn:setString(Localization:getInstance():getText("watch_ad_button2"))
	self.closeBtn:setVisible(false)
	self.playBtn:setVisible(false)
	self.wifi_tip:setVisible(false)
	self.getRewardBtn:removeAllEventListeners()
	self.getRewardBtn:addEventListener(DisplayEvents.kTouchTap, function( evt )
		-- body
		self:onGetRewardBtnTapped()
	end)
end

function AdVideoPanel:playingUpdate()
	self.playBtn:setVisible(false)
	self.wifi_tip:setVisible(false)
	self.getRewardBtn:removeAllEventListeners()
	self.closeBtn:setTouchEnabled(false)
end

function AdVideoPanel:failedPlayUpdate()
	self.reward_tip:setString(Localization:getInstance():getText("watch_ad_text1"))
	self.getRewardBtn:setString(Localization:getInstance():getText("watch_ad_button1"))
	self.getRewardBtn:removeAllEventListeners()
	self.getRewardBtn:addEventListener(DisplayEvents.kTouchTap, function( event )
		-- body
		self:onPlayBtnTap()
	end)
	self.closeBtn:setVisible(true)
	self.closeBtn:setTouchEnabled(true)

	self.playBtn:setVisible(true)
	self.wifi_tip:setVisible(true)

end



function AdVideoPanel:onPlayBtnTap( ... )

	if __IOS then
		if not ReachabilityUtil.getInstance():isNetworkAvailable() then 
			CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
			return 
		end
	end
	-- body
	DcUtil:playAdVideoIcon()
	
	self:playingUpdate()

	local function play_success()
		if self.isDisposed then return end
		self:successPlayUpdate()
	end

	local function play_failed()
		self:failedPlayUpdate()
	end

	local function no_video_play()
		self:onCloseBtnTapped()
		CommonTip:showTip(Localization:getInstance():getText("watch_ad_no_content"))
	end

	AdVideoManager:getInstance():playVideoAd(play_success, play_failed, no_video_play)

end

function AdVideoPanel:playGetRewardAnimation( ... )
	-- body
	local rewardIds = {self.reward.itemId}
	local rewardAmounts = {self.reward.num}
	self.rewardIcon:setVisible(false)
	local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)

	local function onAnimFinished()
		if self.isDisposed then
			return
		end

		local delay = CCDelayTime:create(1)

		local function removeSelf() self:onCloseBtnTapped() end
		local callAction = CCCallFunc:create(removeSelf)

		local seq = CCSequence:createWithTwoActions(delay, callAction)
		self:runAction(seq)
	end

	local itemResPosInWorld = self.rewardIcon:getPositionInWorldSpace()
	for i,v in ipairs(anims) do
		v:setPosition(itemResPosInWorld)
		v:playFlyToAnim(onAnimFinished)
	end

end

function AdVideoPanel:onGetRewardBtnTapped( ... )
	-- body
	if __IOS then
		if not ReachabilityUtil.getInstance():isNetworkAvailable() then 
			CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
			return 
		end
	end

	DcUtil:getAdVideoReward()
	local function failCallback( isNetError )
		-- body
		self:onCloseBtnTapped()
		if isNetError then
			CommonTip:showTip(Localization:getInstance():getText("watch_ad_error_2"))
		else
			CommonTip:showTip(Localization:getInstance():getText("watch_ad_error"))
		end
	end

	local function successCallback( data )
		-- body
		if data[2] and data[3] then
			self:playGetRewardAnimation()
		else
			failCallback()
		end
	end
	self.getRewardBtn:removeAllEventListeners()
	AdVideoManager:getInstance():getReward(successCallback, failCallback)

end

function AdVideoPanel:popout(...)
	-- assert(#{...} == 0)
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	local function onFinish() self.allowBackKeyTap = true end
	self.showHideAnim:playShowAnim(onFinish)
end

function AdVideoPanel:onCloseBtnTapped()
	local function hidePanelCompleted()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	end
	self.allowBackKeyTap = false
	self.showHideAnim:playHideAnim(hidePanelCompleted)
	GamePlayMusicPlayer:getInstance():onceResumeBackgroundMusic()
end

function AdVideoPanel:getHCenterInScreenX( ... )
	-- body
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= self.ui:getChildByName("bg"):getGroupBounds().size.width

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	return visibleOrigin.x + halfDeltaWidth
end
