
require "zoo.panel.component.common.SoftwareKeyboardInput"

CDKeyPanel = class(BasePanel)

function CDKeyPanel:create(cdkeyBtnPosInWorldSpace)
	local newCDKeyPanel = CDKeyPanel.new()
	newCDKeyPanel:loadRequiredResource(PanelConfigFiles.BeginnerPanel)
	newCDKeyPanel:init(cdkeyBtnPosInWorldSpace)
	return newCDKeyPanel
end

function CDKeyPanel:init(cdkeyBtnPosInWorldSpace)

	----------------------
	-- Get UI Componenet
	-- -----------------
	self.ui	= self:buildInterfaceGroup("cdkey")--ResourceManager:sharedInstance():buildGroup("cdkey")

	--------------------
	-- Init Base Class
	-- --------------
	BasePanel.init(self, self.ui)
	self.ui:setTouchEnabled(true, 0, true)

	-------------------
	-- Get UI Componenet
	-- -----------------
	--self.panelTitle			= self.ui:getChildByName("titleLabel")
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.getRewardBtnRes	= self.ui:getChildByName("getRewardBtn")
	self.text1 				= self.ui:getChildByName("text1")
	self.text2 				= self.ui:getChildByName("text2")
	self.text3 				= self.ui:getChildByName("text3")

	--------------------
	-- Create UI Componenet
	-- ----------------------
	self.getRewardBtn		= GroupButtonBase:create(self.getRewardBtnRes)

	--------------
	-- Init UI
	-- ----------
	self.ui:setTouchEnabled(true, 0, true)

	----------------
	-- Update View
	-- --------------
	self.panelTitle:setString(Localization:getInstance():getText("exchange.code.panel.exchange.center"))
	self.getRewardBtn:setString(Localization:getInstance():getText("enter.invite.code.panel.receive.reward.btn"))
	self.text1:setString(Localization:getInstance():getText("exchange.code.panel.enter.text1"))
	self.text2:setString(Localization:getInstance():getText("exchange.code.panel.enter.text2"))

	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		self.text3:setString(Localization:getInstance():getText("exchange.code.panel.enter.text4"))
	else
		self.text3:setString(Localization:getInstance():getText("exchange.code.panel.enter.text3"))
	end

	
	local function onGetRewardBtnTapped(event)
		if self.isDisposed then return end
		local enteredCodeStr = self.input:getText()
		local function onSuccess(data)
			if self.isDisposed then return end
			print("GetExchangeCodeRewardHttp::onSuccess")
			-- HomeScene.sharedInstance().coinButton:updateView()
			local exchangeCodeInfo = data.data.exchangeCodeInfo
			if exchangeCodeInfo then 
				local function closeCallback( ... )
					-- body
					self:updateEchangeCodeInfo()
				end
				CDKeyManager:getInstance():showCollectInfoPanel(exchangeCodeInfo, closeCallback)
			else
				local user = UserManager:getInstance().user
				local button = HomeScene:sharedInstance().coinButton
				HomeScene.sharedInstance():checkDataChange()
				button:updateView()
				self:playRewardAnim(data)
				if string.upper(enteredCodeStr) == "X30ASEHY33" then
					UserManager:getInstance().userExtend:setFlagBit(2, true)
				end
				if string.upper(enteredCodeStr) == "VVZHT9QS3R" then
					UserManager:getInstance().userExtend:setFlagBit(3, true)
				end
			end

			DcUtil:getCDKeyReward(string.upper(enteredCodeStr))
		end

		local function onFail(err)
			if self.isDisposed then return end
			print("GetExchangeCodeRewardHttp::onFail")
			self.getRewardBtn:setEnabled(true)
			self.inputBlock:setTouchEnabled(false)
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err.data)), "negative")
		end

		local function onCancel()
			if self.isDisposed then return end
			self.getRewardBtn:setEnabled(true)
			self.inputBlock:setTouchEnabled(false)
		end
		
		if string.len(enteredCodeStr) > 0 then
			local function onUserHasLogin()
				local index = string.find(enteredCodeStr, "%W")
				if index ~= nil then
					onFail({data = 730743})
				else
					self.getRewardBtn:setEnabled(false)
					self.inputBlock:setTouchEnabled(true, 0, true)
					local http = GetExchangeCodeRewardHttp.new(true)
					http:ad(Events.kComplete, onSuccess)
					http:ad(Events.kError, onFail)
					http:ad(Events.kCancel, onCancel)
					http:load(string.upper(enteredCodeStr))
				end
			end
			RequireNetworkAlert:callFuncWithLogged(onUserHasLogin)
		end
	end
	self.getRewardBtn:addEventListener(DisplayEvents.kTouchTap, onGetRewardBtnTapped)
	self.getRewardBtn:useBubbleAnimation()
	
	-- close button
	self.closeBtn = self.ui:getChildByName("closebtn")
	self.closeBtn:setTouchEnabled(true, 0, false)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap,  function(event) self:onCloseBtnTapped(event) end)

	self.nameLabel = self.ui:getChildByName("touch")
	self.nameLabel:getChildByName("touch"):removeFromParentAndCleanup(true)	
	self.nameLabel:getChildByName("label"):setString(Localization:getInstance():getText("exchange.code.panel.enter.text"))
	self.nameLabel:getChildByName("inputBegin"):setVisible(false)

	-- if not __IOS then
		-- self.nameLabel:getChildByName("label"):setVisible(false)
	-- end
	self:updateEchangeCodeInfo()
	self:initInput()
end

function CDKeyPanel:updateEchangeCodeInfo( )
	-- body
	if self.isDisposed then return end
	local rewardInfo = self.ui:getChildByName("text_info")
	rewardInfo:setVisible(false)

	local function closeCallback( ... )
					-- body
		self:updateEchangeCodeInfo()
	end

	local function onRewardInfoTapped( ... )
		-- body
		if CDKeyManager:getInstance():isInfoFull() then
			CDKeyManager:getInstance():showRewardInfoPanel()
		else
			CDKeyManager:getInstance():showCollectInfoPanel(nil, closeCallback)
		end
	end

	if CDKeyManager:getInstance():hasReward() then
		rewardInfo:setVisible(true)
		rewardInfo:setTouchEnabled(true, 0, false)
		rewardInfo:setButtonMode(true)
		if CDKeyManager:getInstance():isInfoFull() then
			rewardInfo:getChildByName("bg2"):setVisible(false)
			rewardInfo:getChildByName("bg"):setVisible(true)
		else
			rewardInfo:getChildByName("bg2"):setVisible(true)
			rewardInfo:getChildByName("bg"):setVisible(false)
		end
		rewardInfo:removeAllEventListeners()
		rewardInfo:addEventListener(DisplayEvents.kTouchTap, onRewardInfoTapped)
	end
end

function CDKeyPanel:initInput()
	local inputSelect = self.nameLabel:getChildByName("inputBegin")
	local inputSize = inputSelect:getContentSize()
	local inputPos = inputSelect:getPosition()
	inputSelect:setVisible(true)
	inputSelect:removeFromParentAndCleanup(false)
	
	local function onTextBegin()
		if self.isDisposed then return end
		if self.input then
			self.input:setText("")
			self.nameLabel:getChildByName("label"):setString("")
		end
	end

	local function onTextEnd()
		if self.isDisposed then return end
		if self.input then
			
			local text = self.input:getText() or ""
	
			if text ~= "" then
				local codeMatch = string.find(text,"^[0-9a-zA-Z]+$");
				if not codeMatch or codeMatch~=1 then 
					CommonTip:showTip(Localization:getInstance():getText("error.tip.cdkey.content"), "negative",nil,2);
					self.input:setText("");
				end
			end
			self.nameLabel:getChildByName("label"):setString("")
		end
	end

	local position = ccp(inputPos.x + inputSize.width/2, inputPos.y - inputSize.height/2)
	local input = TextInputIm.new()
    input:init(inputSize, Scale9Sprite:createWithSpriteFrameName("img/beginnerpanel_ui_empty0000"))
	input.originalX_ = position.x
	input.originalY_ = position.y
	input:setText("")
	input:setPosition(position)
	input:setFontColor(ccc3(217,194,101))
	input:setMaxLength(15)
	input:ad(kTextInputEvents.kBegan, onTextBegin)
	input:ad(kTextInputEvents.kEnded, onTextEnd)
	self.nameLabel:addChild(input)
	self.input = input
	local inputBlock = LayerColor:create()
	local rectSize = input:getGroupBounds().size
	inputBlock:setContentSize(CCSizeMake(rectSize.width, rectSize.height))
	inputBlock:ignoreAnchorPointForPosition(false)
	inputBlock:setAnchorPoint(ccp(0.5, 0.5))
	inputBlock:setOpacity(0)
	inputBlock:setPosition(position)
	self.nameLabel:addChild(inputBlock)
	self.inputBlock = inputBlock
	inputSelect:dispose()
end

function CDKeyPanel:onCloseBtnTapped(event, ...)
	assert(event)
	assert(#{...} == 0)

	if not self.isOnCloseBtnTappedCalled then
		self.isOnCloseBtnTappedCalled = true
		self:remove()
	end
end

function CDKeyPanel:registerCloseCallback(closeCallback, ...)
	assert(type(closeCallback) == "function")
	assert(#{...} == 0)

	self.closeCallback = closeCallback
end

function CDKeyPanel:playRewardAnim(data) 
	-- if not data then return end
	-- local rewardIds = {}
	-- local rewardAmounts = {}

	-- for k,v in pairs(data.data.rewardItems) do
	-- 	local itemId 		= v.itemId
	-- 	local itemNumber	= v.num
	-- 	table.insert(rewardIds, itemId)
	-- 	table.insert(rewardAmounts, itemNumber)
	-- end

	-- -- rewardIds = {10010,2,4}
	-- -- rewardAmounts = {1,1000,2}
	-- local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
	-- print("number of anims : " .. #anims)


	-- local function onAnimFinished()
	-- 	if self.isDisposed then
	-- 		return
	-- 	end

	-- 	local delay = CCDelayTime:create(1.5)

	-- 	local function removeSelf() self:remove() end
	-- 	local callAction = CCCallFunc:create(removeSelf)

	-- 	local seq = CCSequence:createWithTwoActions(delay, callAction)
	-- 	self:runAction(seq)
	-- end

	local itemResPosInWorld = ccp(360,640)
	-- for i,v in ipairs(anims) do
	-- 	v:setPosition(itemResPosInWorld)
	-- 	v:playFlyToAnim(onAnimFinished)
	-- end

	local anim = FlyItemsAnimation:create(data.data.rewardItems)
	anim:setWorldPosition(itemResPosInWorld)
	anim:setFinishCallback(function( ... )
		if not self.isDisposed then
			self:remove()
		end
	end)
	anim:play()

end

function CDKeyPanel:popout()
	local function onAnimOver()
		self.allowBackKeyTap = true
	end
	PopoutManager:sharedInstance():add(self, true, false)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
end

function CDKeyPanel:remove(...)
	PopoutManager:sharedInstance():remove(self, true)

	if self.closeCallback then
		self.closeCallback()
	end
end

function CDKeyPanel:onEnterHandler(event, ...)
	if event == "enter" then
		self.allowBackKeyTap = true
        self:runAction(self:createShowAnim())
	end
end

function CDKeyPanel:onEnterAnimationFinished()

end

function CDKeyPanel:createShowAnim()
    local centerPosX    = self:getHCenterInParentX()
    local centerPosY    = self:getVCenterInParentY()

    local function initActionFunc()
        local initPosX  = centerPosX
        local initPosY  = centerPosY + 100
        self:setPosition(ccp(initPosX, initPosY))
    end
    local initAction = CCCallFunc:create(initActionFunc)
    local moveToCenter      = CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
    local backOut           = CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
    local targetedMoveToCenter  = CCTargetedAction:create(self.refCocosObj, backOut)

    local function onEnterAnimationFinished() self:onEnterAnimationFinished() end
    local actionArray = CCArray:create()
    actionArray:addObject(initAction)
    actionArray:addObject(targetedMoveToCenter)
    actionArray:addObject(CCCallFunc:create(onEnterAnimationFinished))
    return CCSequence:create(actionArray)
end

function CDKeyPanel:getHCenterInScreenX(...)
	assert(#{...} == 0)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 694

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	return visibleOrigin.x + halfDeltaWidth
end