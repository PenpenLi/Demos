
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ31ÈÕ 17:01:08
-- Author:	ZhangWan(diff) Email:	wanwan.zhang@happyelements.com
-- Modify:	Xiaoguang Nan  Email:	xiaoguang.nan@happyelements.com

require "zoo.panel.component.enterInviteCodePanel.InviteFriendRewardPanel"
require "zoo.panel.component.common.SoftwareKeyboardInput"
require "zoo.panel.RequireNetworkAlert"

---------------------------------------------------
-------------- EnterInviteCodePanel
---------------------------------------------------

assert(not EnterInviteCodePanel)
assert(BasePanel)
EnterInviteCodePanel = class(BasePanel)

function EnterInviteCodePanel:create(...)
	assert(#{...} == 0)

	local newEnterInviteCodePanel = EnterInviteCodePanel.new()
	newEnterInviteCodePanel:loadRequiredResource(PanelConfigFiles.panel_with_keypad)
	newEnterInviteCodePanel:init()
	return newEnterInviteCodePanel
end

function EnterInviteCodePanel:dispose()
	self.softKeyboard:cancel(false, true)
	if not self.softKeyboard.isDisposed then
		self.softKeyboard:dispose()
	end
	BasePanel.dispose(self)
end

function EnterInviteCodePanel:init(...)
	assert(#{...} == 0)

	-- --------
	-- Get Meta
	-- -------
	self.meta = MetaManager:getInstance():getEnterInviteCodeReward()
	print(table.tostring(self.meta))
	if #self.meta < 2 then
		self.meta = {
			{itemId = 10013, num = 2},
			{itemId = 2, num = 5000},
		}
	end

	-- --------
	-- Get UI
	-- -------
	self.ui	= self:buildInterfaceGroup("enterInviteCodePanel") --ResourceManager:sharedInstance():buildGroup("enterInviteCodePanel")
	BasePanel.init(self, self.ui)

	----------------------
	-- Get UI Resource
	-- -----------------
	self.desLabel			= self.ui:getChildByName("desLabel")
	self.enterLabelWithBg		= self.ui:getChildByName("enterLabelWithBg")
	self.receiveRewardBtnRes	= self.ui:getChildByName("receiveRewardBtn")
	self.continueBtnRes		= self.ui:getChildByName("continueBtn")
	self.enterLabel			= self.enterLabelWithBg:getChildByName("label")
	self.title = 			self.ui:getChildByName('title')
	self.title:setText(Localization:getInstance():getText('enter.invite.code.panel.title'))

	assert(self.desLabel)
	assert(self.enterLabelWithBg)
	assert(self.receiveRewardBtnRes)
	assert(self.continueBtnRes)
	assert(self.enterLabel)

	self.items = {}
	self.items[1] = self.ui:getChildByName("reward1")
	self.items[2] = self.ui:getChildByName("reward2")

	self.receiveRewardBtn	= GroupButtonBase:create(self.receiveRewardBtnRes)
	self.continueBtn	= GroupButtonBase:create(self.continueBtnRes)

	----------------
	-- Update View
	-- ------------
	self.desLabel:setString(Localization:getInstance():getText("enter.invite.code.panel.des"))
	self.receiveRewardBtn:setString(Localization:getInstance():getText("invite.friend.panel.get.button"))
	--self.receiveRewardBtn:changeToColor("green")
	self.continueBtn:setString(Localization:getInstance():getText("invite.friend.panel.cont.button"))
	--self.continueBtn:changeToColor("blue")
	self.continueBtn:setColorMode(kGroupButtonColorMode.blue)
	self.icons = {}
	for i = 1, 2 do
		local sprite
		if self.meta[i].itemId == 2 then
			sprite = Sprite:createWithSpriteFrameName("iconHeap_4uy30000")
			sprite:setAnchorPoint(ccp(0, 1))
		else
			sprite = ResourceManager:sharedInstance():buildItemGroup(self.meta[i].itemId)
		end
		local icon = self.items[i]:getChildByName("icon")
		local num = self.items[i]:getChildByName("num")

		local numFS = self.items[i]:getChildByName("num_fontSize")
		local label = TextField:createWithUIAdjustment(numFS, num)
		self.items[i]:addChild(label)
		self.items[i].label = label
		local pos = icon:getPosition()
		local size = sprite:getGroupBounds().size
		sprite:setScale(1.2)
		sprite:setPosition(ccp(pos.x - size.width / 2, pos.y + size.height / 2))
		sprite.name = "icon"
		icon:getParent():addChildAt(sprite, 1)
		icon:removeFromParentAndCleanup(true)
		table.insert(self.icons, sprite)
		label:setString("x"..self.meta[i].num)
	end

	---------------
	-- Add Event Listener
	-- ---------------
	local function onReceiveRewardBtnTapped(event)
		-- self:onReceiveRewardBtnTapped(event)
		self.softKeyboard:start(self, ccp(0, -560))
	end
	self.receiveRewardBtn:addEventListener(DisplayEvents.kTouchTap, onReceiveRewardBtnTapped)

	local function onContinueBtnTapped(event)
		self:onCloseBtnTapped(event)
	end
	self.continueBtn:addEventListener(DisplayEvents.kTouchTap, onContinueBtnTapped)

	self:createSoftkeyboard()
	local function onEnterLabelTapepd(event)
		self.softKeyboard:start(self, ccp(0, -560))
	end
	self.enterLabelWithBg:setTouchEnabled(true)
	self.enterLabelWithBg:addEventListener(DisplayEvents.kTouchTap, onEnterLabelTapepd)
end

function EnterInviteCodePanel:createSoftkeyboard(...)
	assert(#{...} == 0)

	local function onInputLabelEntered()
		self:onReceiveRewardBtnTapped()
		self.softKeyboard:cancel(false)
	end
	local function onInputLabelOutside()
		self.softKeyboard:cancel(false)
	end
	local softKeyBoardConfig = 
	{
		enterCallback = onInputLabelEntered,
		outsideCallback = onInputLabelOutside,
		max		= 10,
	}

	----------------------
	-- Create Soft Keyboard
	-- ---------------------
	self.softKeyboard = SoftwareKeyboardInput:create(self.enterLabel, softKeyBoardConfig)
end

function EnterInviteCodePanel:onReceiveRewardBtnTapped(event, ...)
	assert(#{...} == 0)

	-- Get Entered Code
	local enteredCodeStr 	= self.enterLabel:getString()
	local enteredCode	= false

	if string.len(enteredCodeStr) > 0 then
		enteredCode = tonumber(enteredCodeStr)
		-- Send The Message To Receive Add Friend Message

		-- On Success
		local function onConfirmInviteSuccess(event)
			-- assert(event)
			-- assert(event.name == Events.kComplete)
			--assert(event.data)

			-- --------------
			-- Set The Flag
			-- -------------
			self.receiveRewardBtn:setEnabled(false)
			self.enterLabelWithBg:setTouchEnabled(false)
			local flag = UserManager:getInstance().userExtend.flag or 0
			if flag % 2 == 0  then
				UserManager:getInstance().userExtend.flag = flag + 1
			end

			print("onConfirmInviteSuccess !!!")
			local successMsgTxtKey		= "success.msg.invite.code"
			local successMsgTxtValue	= Localization:getInstance():getText(successMsgTxtKey, {})
			-- local successMsgTxtValue	= "invite success !"

			local function onTipClosed()
				print("onTipClosed !")
				self:onCloseBtnTapped()
				if self.finishCallback then
					self.finishCallback()
				end
			end

			-- --------------
			-- Get Reward
			-- -------------
			self:getInviteReward()

			CommonTip:showTip(successMsgTxtValue, "positive", onTipClosed)

			-------------------
			-- Refresh The Friend Infos
			-- -------------------------
			HomeScene:sharedInstance():updateFriends()
		end

		-- On Failed
		local function onConfirmInviteFailled(event)
			assert(event)
			assert(event.name == Events.kError)
			assert(event.data)

			local errorCode = event.data
			print("EnterInviteCodePanel:onReceiveRewardBtnTapped Called onConfirmInviteFailled: error: " .. errorCode)

			if errorCode == 731012 then
				-- Invite Code Error
				print("error: 731012, invite code error !")
				local errorTxtKey	= "error.msg.for.invite.code.error.731012"
				local errorTxtValue	= Localization:getInstance():getText(errorTxtKey, {})

				--local errorTxtValue = "invite code error !"
				CommonTip:showTip(errorTxtValue)

			elseif errorCode == 731013 then
				-- Invite Confirm Again
				print("error: 731013, invite confirm again !")

				local errorTxtKey	= "error.msg.for.invite.code.confirm.again.731013"
				local errorTxtValue	= Localization:getInstance():getText(errorTxtKey, {})

				--errorTxtValue = "invite confirm again !"
				CommonTip:showTip(errorTxtValue)

			--elseif errorCode == 731011 then
			--	-- Invite Friend Again
			--	print("error: 731011, invite friend again !")
			--	local errorTxtkey	= "error.msg.for.invite.code.invite.friend.again.731011"
			--	local errorTxtValue	= Localization:getInstance():getText(errorTxtKey, {})
			--	CommonTip:showTip(errorTxtValue)

			elseif errorCode == 731010 then
				-- Add SElf
				print("error: 731010, enter self invite code !")

				local errorTxtKey	= "error.msg.for.invite.code.invite.self.731010"
				local errorTxtValue	= Localization:getInstance():getText(errorTxtKey, {})

				--errorTxtValue = "self invite code !"
				CommonTip:showTip(errorTxtValue)
			else 
				-- Unknown Error
				print("unknown error !")
				CommonTip:showTip(Localization:getInstance():getText("error.msg.for.invite.code.unknown"), "negative")
			end
		end

		print("entered code: " .. enteredCode)
		--debug.debug()

		local function onCompleteFunc()
			local http = ConfirmInvite.new(true)
			http:addEventListener(Events.kComplete, onConfirmInviteSuccess)
			http:addEventListener(Events.kError, onConfirmInviteFailled)
			http:load(enteredCode)
		end

		if __WIN32 then
			onConfirmInviteSuccess()
			return
		end

		if UserManager:getInstance():isSameInviteCodePlatform(enteredCode) then 
			RequireNetworkAlert:callFuncWithLogged(onCompleteFunc)
		else
			CommonTip:showTip(Localization:getInstance():getText("error.tip.add.friends"), "negative")
		end
	end
end

function EnterInviteCodePanel:getInviteReward()
	local manager = UserManager:getInstance()
	local user = manager.user
	local home = HomeScene:sharedInstance()

	local function addCoin(num)
		local money = user:getCoin()
		money = money + num
		user:setCoin(money)
	end
	for i = 1, 2 do
		if self.meta[i].itemId == 2 then addCoin(self.meta[i].num)
		else
			manager:addUserPropNumber(self.meta[i].itemId, self.meta[i].num)
		end
	end

	local function decreaseToZero(label, total, duration)
		local interval = 1/60
		local times = duration / interval
		local diff = total / times
		local last = total 
		local schedId = nil
		local function __perFrame()
			local new = last - diff
			if new > 0 then 
				local ceilNew = math.ceil(new)
				if ceilNew ~= math.ceil(last) then
					if not label.isDisposed then
						label:setString('x'..ceilNew)
					end
				end
				last = new
			else 
				if not label.isDisposed then
					label:setString('x0')
				end
				if not schedId then
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedId)
				end
			end
		end
		schedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(__perFrame,interval,false)
	end

	home:checkDataChange()
	for i = 1, 2 do
		local anim = FlyItemsAnimation:create({self.meta[i]})
		local icon = self.items[i]:getChildByName("icon")
		local bounds = icon:getGroupBounds() 
		anim:setWorldPosition(ccp(bounds:getMidX(),bounds:getMidY()))
		anim:play()

		--- decreasing number animation
		local label = self.items[i].label
		local num = self.meta[i].num
		local duration = 0.4
		decreaseToZero(label, num, duration)

		-- local sprite
		-- if self.meta[i].itemId == 2 then 
		-- 	sprite = home:createFlyingCoinAnim()
		-- else 
		-- 	-- sprite = home:createFloatingItemAnim(self.meta[i].itemId) 
		-- 	sprite = home:createFlyToBagAnimation(self.meta[i].itemId, self.meta[i].num)
		-- end

		-- local position = self.items[i]:getChildByName("icon"):getPosition()
		-- position = self.items[i]:convertToWorldSpace(ccp(position.x, position.y))
		-- sprite:setPosition(ccp(position.x, position.y))

		-- --home:addChild(sprite) --创建的时候已经添加过了

		-- --- decreasing number animation
		-- local label = self.items[i].label
		-- local num = self.meta[i].num
		-- local duration = 0.4
		-- decreaseToZero(label, num, duration)

		-- sprite:playFlyToAnim(false, false)
	end
	for __, v in ipairs(self.icons) do
		v:removeFromParentAndCleanup(true)
	end
end

function EnterInviteCodePanel:onContinueBtnTapped(event, ...)
	assert(#{...} == 0)

	print("EnterInviteCodePanel:onContinueBtnTapped Called !")

	-- Change To Invite Reward Panel
	PopoutManager:sharedInstance():removeWhileKeepBackground(self, true)
end

function EnterInviteCodePanel:popout(callback)

	print("EnterInviteCodePanel:popout")
	local function onAnimOver()
		print("onAnimOver")
		self.allowBackKeyTap = true
	end
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, onAnimOver)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
	self.finishCallback = callback

end

function EnterInviteCodePanel:onCloseBtnTapped()
	if self.isDisposed then return end
	self.allowBackKeyTap = false
	print("********EnterInviteCodePanel:onCloseBtnTapped")
	self:onContinueBtnTapped()
end