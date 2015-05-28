
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

	---------------------
	-- Create Show/Hide Anim
	-- ------------------
	self.showHideAnim	= IconPanelShowHideAnim:create(self, cdkeyBtnPosInWorldSpace)

	
	local function onGetRewardBtnTapped(event)
		local enteredCodeStr = self.input:getText()
		local function onSuccess(data)
			print("GetExchangeCodeRewardHttp::onSuccess")
			-- HomeScene.sharedInstance().coinButton:updateView()
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

			DcUtil:getCDKeyReward(string.upper(enteredCodeStr))
		end

		local function onFail(err)
			print("GetExchangeCodeRewardHttp::onFail")
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err.data)), "negative")
		end
		
		if string.len(enteredCodeStr) > 0 then
			local function onUserHasLogin()
				local index = string.find(enteredCodeStr, "%W")
				if index ~= nil then
					onFail({data = 730743})
				else
					local http = GetExchangeCodeRewardHttp.new(true)
					http:ad(Events.kComplete, onSuccess)
					http:ad(Events.kError, onFail)
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

	self:initInput()
end

function CDKeyPanel:popout(...)
	assert(#{...} == 0)

	local function onAnimOver()
		self.allowBackKeyTap = true
	end
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, onAnimOver)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
end

function CDKeyPanel:initInput()
	local inputSelect = self.nameLabel:getChildByName("inputBegin")
	local inputSize = inputSelect:getContentSize()
	local inputPos = inputSelect:getPosition()
	inputSelect:setVisible(true)
	inputSelect:removeFromParentAndCleanup(false)
	
	local function onTextBegin()
		if self.input then
			self.input:setText("")
			self.nameLabel:getChildByName("label"):setString("")
		end
	end

	local function onTextEnd()
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
	local input = TextInput:create(inputSize, Scale9Sprite:createWithSpriteFrameName("img/beginnerpanel_ui_empty0000"), inputSelect.refCocosObj)
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
	local rewardIds = {}
	local rewardAmounts = {}

	for k,v in pairs(data.data.rewardItems) do
		local itemId 		= v.itemId
		local itemNumber	= v.num
		table.insert(rewardIds, itemId)
		table.insert(rewardAmounts, itemNumber)
	end

	-- rewardIds = {10010,2,4}
	-- rewardAmounts = {1,1000,2}
	local anims = HomeScene:sharedInstance():createFlyingRewardAnim(rewardIds, rewardAmounts)
	print("number of anims : " .. #anims)


	local function onAnimFinished()
		if self.isDisposed then
			return
		end

		local delay = CCDelayTime:create(1.5)

		local function removeSelf() self:remove() end
		local callAction = CCCallFunc:create(removeSelf)

		local seq = CCSequence:createWithTwoActions(delay, callAction)
		self:runAction(seq)
	end

	local itemResPosInWorld = ccp(360,640)
	for i,v in ipairs(anims) do
		v:setPosition(itemResPosInWorld)
		v:playFlyToAnim(onAnimFinished)
	end

	-- local itemResPosInWorld = ccp(360,640)
	-- anims[1]:setPosition(ccp(itemResPosInWorld.x, itemResPosInWorld.y))

	-- local function onAnimFinished()
	-- 	if self.isDisposed then
	-- 		return
	-- 	end

	-- 	local delay = CCDelayTime:create(0.3)

	-- 	local function removeSelf()
	-- 		self:remove()
	-- 	end
	-- 	local callAction = CCCallFunc:create(removeSelf)

	-- 	local seq = CCSequence:createWithTwoActions(delay, callAction)
	-- 	self:runAction(seq)
	-- end

	-- --------------------------------------------------------
	-- -- number-decreasing animation
	-- --------------------------------------------------------
	-- -- local item = self.rewardItem
	-- -- local label = item.numberLabel
	-- -- local num = item.itemNumber
	-- -- local interval = 0.2 -- the same value from function HomeScene:createFlyToBagAnimation
	-- -- local function __decreaseNumber()
	-- -- 	if num >= 1 then
	-- -- 		num = num - 1
	-- -- 		-- trible reference checks
	-- -- 		if label and not label.isDisposed and label.refCocosObj then 
	-- -- 			label:setString('x'..num)
	-- -- 			setTimeOut(__decreaseNumber, interval)
	-- -- 		end
	-- -- 	end
	-- -- end
	-- setTimeOut(__decreaseNumber, interval)

	-- anims[1]:playFlyToAnim(onAnimFinished)
end

function CDKeyPanel:remove(...)
	local function onHideAnimFinished()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)

		if self.closeCallback then
			self.closeCallback()
		end
	end
	
	self.showHideAnim:playHideAnim(onHideAnimFinished)
end

function CDKeyPanel:onEnterHandler(event, ...)
	if event == "enter" then

		local function onShowAnimFinished()
			self.allowBackKeyTap = true
		end

		self.showHideAnim:playShowAnim(onShowAnimFinished)
	end
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