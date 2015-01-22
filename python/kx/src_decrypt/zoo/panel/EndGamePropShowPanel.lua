
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê10ÔÂ22ÈÕ 21:56:19
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.common.CountdownTimer"
require "zoo.panel.component.common.BubbleItem"
require "zoo.common.ItemType"
require "zoo.panel.component.addStepPanel.UseAddStepBtn"
require "zoo.panelBusLogic.BuyLogic"
require "zoo.panel.RequireNetworkAlert"
require 'hecore.sns.SnsProxy'
require 'zoo.panel.FreeFCashPanel'

require "zoo.panel.TimeLimitPanel"


local function setButtonIcon( button, propId )
	-- body
	local icon =  ResourceManager:sharedInstance():buildItemSprite(propId)
	button.propIcon = button.groupNode:getChildByName("_fg")
	button.propIcon:getParent():addChild(icon)
	local pos = button.propIcon:getPosition()
	icon:setPosition(ccp(pos.x, pos.y))
	button.propIcon:removeFromParentAndCleanup(true)
end

local UseButton = class(GroupButtonBase)
function UseButton:create(groupNode, propId)
	local button = UseButton.new(groupNode)
	button:buildUI()
	setButtonIcon(button, propId)
	button.redCircle = groupNode:getChildByName("redCircle")
	button.numberLabel = groupNode:getChildByName("numberLabel")
	button.fontSize = button.numberLabel:getFontSize()
	button.labelPos = button.numberLabel:getPositionY()
	return button
end
function UseButton:setNumber(number)
	if number <= 0 then
		self.redCircle:setVisible(false)
		self.numberLabel:setVisible(false)
	else
		if number > 99 then
			self.numberLabel:setPositionY(self.labelPos - 4)
			self.numberLabel:setFontSize(self.fontSize - 8)
			self.numberLabel:setString("99+")
		else
			self.numberLabel:setPositionY(self.labelPos)
			self.numberLabel:setFontSize(self.fontSize)
			self.numberLabel:setString(number)
		end
	end
end

local BuyButton = class(ButtonIconNumberBase)
function BuyButton:create(groupNode, propId)
	local button = BuyButton.new(groupNode)
	button:buildUI()
	setButtonIcon(button, propId)
	button.discount = groupNode:getChildByName("discount")
	button.dcNumber = button.discount:getChildByName("num")
	button.dcText = button.discount:getChildByName("text")

	return button
end
function BuyButton:setDiscount(number, text)
	if number <= 0 or number == 10 then
		self.dcNumber:setVisible(false)
		self.dcText:setVisible(false)
		self.discount:setVisible(false)
	else
		self.dcNumber:setVisible(true)
		self.dcText:setVisible(true)
		self.discount:setVisible(true)
		self.dcNumber:setString(number)
		self.dcText:setString(text)
	end
end



EndGamePropShowPanel = class(BasePanel)

local PropList = table.const{
	kAddMove = {itemid = 10004, goodId = 24, discountGoodsId = 33},
	kRivive = {itemid = 10040, goodId = 46, discountGoodsId = 47},
	kAddTime = {itemid = 16, goodId = 155, discountGoodsId = 155},
} 

local function getGoodId( itemid )
	-- body
	for k, v in pairs(PropList) do 
		if itemid == v.itemid then return v.goodId end
	end
end

local function getDiscountId( itemid )
	-- body
	for k, v in pairs(PropList) do 
		if itemid == v.itemid then return v.discountGoodsId end
	end
end

local function getOneFenGoodsId(itemid)
	return 102
end

function EndGamePropShowPanel:create(levelId, levelType, propId)
	local panel = EndGamePropShowPanel.new()
	panel.levelType = levelType
	panel:loadRequiredResource(PanelConfigFiles.panel_add_step)

	print(propId)
	if propId == PropList.kAddMove.itemid then
		panel:initForAddStep(levelId, propId)
		return panel
	else
		if panel:init(levelId, propId) then return panel
		else
			panel = nil
			return nil
		end
	end
end

function EndGamePropShowPanel:initForAddStep(levelId, propId)
	if __ANDROID then
		local shouldShowOneFenAddStep = false
		local defaultSmsPayType = AndroidPayment.getInstance():getDefaultSmsPayment()
		local hasAlreadyUsedOneFen = UserManager:getInstance().userExtend:isFlagBitSet(5)

		-- check 3 conditions
		if 	defaultSmsPayType == Payments.CHINA_MOBILE -- cmcc payment only
		and not hasAlreadyUsedOneFen then	-- first time..
			shouldShowOneFenAddStep = true
		end

		if shouldShowOneFenAddStep then
			return self:initForOneFenAddStep(levelId, propId)
		end
	end

	if __ANDROID or __WIN32 then
		local shouldShowTimeLimitAddStep = false
		local prop = UserManager:getInstance():getUserProp(propId)
		if prop == nil or prop.num <= 0 then 

			shouldShowTimeLimitAddStep = TimeLimitData:getInstance():hasIngameBuyItem()			
			if shouldShowTimeLimitAddStep then 
				local leftTime = TimeLimitData:getInstance():getLeftTime()
				local isStart = TimeLimitData:getInstance():isStart()
				if isStart and leftTime.hour == 0 and leftTime.min == 0 and leftTime.sec == 0 then 
					shouldShowTimeLimitAddStep = false
				end
			end
		end

		if shouldShowTimeLimitAddStep then
			TimeLimitData:getInstance():writeLimitTime()
			return self:initForTimeLimitAddStep(levelId,propId)
		end
	end
	
	return self:init(levelId, propId)
end

function EndGamePropShowPanel:initForOneFenAddStep(levelId, propId)
	self:init(levelId, propId)


	if not self.buyButton or self.buyButton.groupNode.isDisposed then return end
	self.isOneFenAddStep = true -- set a flag
	local shiningLocator = self.buyButton.groupNode:getChildByName('shiningLocator')
	if not shiningLocator then return end

	self.buyButton.groupNode:getChildByName('shiningLocator'):setVisible(true)

	if self.buyButton.icon then
		self.buyButton.icon:setVisible(false)
	end
	self.buyButton:setNumber(Localization:getInstance():getText("add.step.panel.button.1fen"))
	self.buyButton:setDiscount(0.1, Localization:getInstance():getText("buy.gold.panel.discount"))
	self.buyButton.label:setPositionX(self.buyButton.label:getPositionX() - 8)
	self.buyButton.numberLabel:setPositionX(self.buyButton.numberLabel:getPositionX() - 25)
	shiningLocator:setScale(1)
	local pos = shiningLocator:getPosition()
	local zorder = shiningLocator:getZOrder()
	local shiningEffect = self:buildInterfaceGroup("add_step_shining_effect")
	shiningEffect:setAnchorPoint(ccp(0.5, 0.5))
	shiningLocator:addChild(shiningEffect)
	local rotateAction = CCRepeatForever:create(CCRotateBy:create(4, 360))
	shiningEffect:runAction(rotateAction)

	self.msgLabel:setString(Localization:getInstance():getText("add.step.panel.msg.1fen.continue", {n='\n'}))
	self.msgLabel:setFontSize(30)
	self.msgLabel:setPositionY(self.msgLabel:getPositionY() + 15)

end

function EndGamePropShowPanel:initForTimeLimitAddStep(levelId, propId)
	self:init(levelId, propId)

	-- local payGiftInfo = UserManager:getInstance().payGiftInfo
	self.isTimeLimitAddStep = true
	self.timeLimitGoodsId = TimeLimitData:getInstance():getIngameGoodsId()


	local bounds = self.ui:getGroupBounds()

	self.timeLimitPanel = self:buildInterfaceGroup("add_step_tip")

	local timeLimitBounds = self.timeLimitPanel:getGroupBounds()

	self.timeLimitPanel:setPositionX(bounds:getMidX() - timeLimitBounds.size.width/2 + 40)
	self.timeLimitPanel:setPositionY(bounds:getMinY() + 10)

	self.ui:addChild(self.timeLimitPanel)

	local time = self.timeLimitPanel:getChildByName("time")
	local function setTimeString( ... )
		local t = TimeLimitData:getInstance():getLeftTime()
		time:setString(string.format("%02d:%02d:%02d",t.hour,t.min,t.sec))	
	end
	time:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(
		CCDelayTime:create(1.0),
		CCCallFunc:create(setTimeString)
	)))

	local markText = self.timeLimitPanel:getChildByName("markText")
	markText:setDimensions(CCSizeMake(0,0))
	markText:setAnchorPoint(ccp(0.5,0))	
	markText:setString(Localization:getInstance():getText(
		"timeLimit.panel.sendValue",{ n=TimeLimitData:getInstance():getIngameSendValue() } 
	))
	markText:setPositionX(markText:getPositionX() + 40)
	markText:setPositionY(markText:getPositionY() - 28)

	local function buildReward(itemId,num)
	 	local reward = ResourceManager:sharedInstance():buildItemSprite(itemId)

	 	local rewardBounds = reward:getGroupBounds()

	 	local numberLabel = BitmapText:create("x" .. tostring(num),"fnt/target_amount.fnt")
	 	numberLabel:setAnchorPoint(ccp(1,0))
	 	numberLabel:setPositionX(rewardBounds:getMaxX())
	 	numberLabel:setPositionY(0)

	 	reward:addChild(numberLabel)

	 	return reward
	end

	local items = TimeLimitData:getInstance():getIngameSendItems()
	for i=1,#items do

		local reward = buildReward(items[i].itemId,items[i].num)
		reward:setPositionX(180 + (i-1)*110)
		reward:setPositionY(-65)
		self.timeLimitPanel:addChild(reward)

	end

	-- 原有的UI
	local blackBg = self.ui:getChildByName("blackBg")
	local scaleheight = blackBg:boundingBox().size.height + timeLimitBounds.size.height + 30
	blackBg:setScaleY(scaleheight / blackBg:getContentSize().height )

	-- self.originalScaleY = blackBg:getScaleY()
	-- blackBg:setScaleY((bounds.size.height + timeLimitBounds.size.height) / blackBg:getContentSize().height)

	local originalPriceRect = {
		x=self.buyButton.numberRect.x,y=self.buyButton.numberRect.y,
		width=self.buyButton.numberRect.width,height=self.buyButton.numberRect.height
	}
	originalPriceRect.y = originalPriceRect.y + self.buyButton.numberRect.height/2 - 10

	local scaleWith = originalPriceRect.width * 0.8
	local scaleHeight = originalPriceRect.height * 0.8
	originalPriceRect.x = originalPriceRect.x + (originalPriceRect.width - scaleWith)/2
	originalPriceRect.y = originalPriceRect.y - (originalPriceRect.height - scaleHeight)/2
	originalPriceRect.width = scaleWith
	originalPriceRect.height = scaleHeight

	local originalPriceLabel = BitmapText:create(
		Localization:getInstance():getText("buy.gold.panel.money.mark")..TimeLimitData:getInstance():getIngameBuyActualValue(),
		"fnt/green_button.fnt"
	)
	originalPriceLabel:setAnchorPoint(ccp(0,1))
	self.buyButton.groupNode:addChild(originalPriceLabel)
	InterfaceBuilder:centerInterfaceInbox( originalPriceLabel, originalPriceRect)

	self.buyButton.numberRect.y = self.buyButton.numberRect.y - self.buyButton.numberRect.height/2 + 5
 	self.buyButton:setNumber(self.buyButton:getNumber())

 	local line = self:buildInterfaceGroup("add_step_money_line")
 	local lineBounds = line:getGroupBounds()
 	local originalPriceLabelBounds = originalPriceLabel:boundingBox()
 	line:setPositionX(originalPriceLabelBounds:getMidX() - lineBounds.size.width/2)
 	line:setPositionY(originalPriceLabelBounds:getMidY() + lineBounds.size.height/2 + 5)
 	self.buyButton.groupNode:addChild(line)

	self.buyButton:setNumber(
		Localization:getInstance():getText("buy.gold.panel.money.mark")..TimeLimitData:getInstance():getIngameBuyDiscountValue()
	)

	self.buyButton:setDiscount(
		math.ceil(TimeLimitData:getInstance():getIngameBuyDicount() * 100) / 10, 
		Localization:getInstance():getText("buy.gold.panel.discount")
	)

	return true
end

function EndGamePropShowPanel:init(levelId, propId)
	if not levelId then return false end

	-- data
	self.levelId = levelId
	self.propId = propId
	
	-- init panel
	self.ui = self:buildInterfaceGroup("newAddStepPanel")
	BasePanel.init(self, self.ui)

	-- get & create controls
	self.closeBtnRes = self.ui:getChildByName("closeBtn")
	self.msgLabel = self.ui:getChildByName("msgLabel")
	self.countdownLabelPh = self.ui:getChildByName("countdownLabel")
	local useBtnRes = self.ui:getChildByName("useBtn")
	local buyBtnRes = self.ui:getChildByName("buyBtn")
	self.closeBtn	= BubbleCloseBtn:create(self.closeBtnRes)
	self.buyButton = BuyButton:create(buyBtnRes, self.propId)
	self.buyButton.groupNode:getChildByName('shiningLocator'):setVisible(false)
	self.useButton = UseButton:create(useBtnRes, self.propId)
	local cryingAnimation
	if self.levelType == GameLevelType.kDigWeekly
	then
		cryingAnimation = WeeklyRaceAddEnergyAnimation:create()
	else
		cryingAnimation = AddEnergyAnimation:create()
	end
	self.ui:addChild(cryingAnimation)

	-- set control state
	local prop = UserManager:getInstance():getUserProp(self.propId)
	local propNum
	if not prop then propNum = 0
	else propNum = prop.num end
	if propNum > 0 then -- use
		self.useButton:setNumber(propNum)
		self.useButton:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
		self.buyButton:removeFromParentAndCleanup(true)
	else -- buy
		local goods = MetaManager:getInstance():getGoodMeta(getDiscountId(self.propId))
		local normGood, discountGood
		if __ANDROID then -- ANDROID
			normGood, discountGood = goods.rmb / 100, goods.discountRmb / 100
		else -- else, on IOS and PC we use gold!
			normGood, discountGood = goods.qCash, goods.discountQCash
			self.buyButton:setIconByFrameName("ui_images/ui_image_coin_icon_small0000")
		end
		local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(getDiscountId(self.propId))
		if buyed >= goods.limit then

			self.buyButton:setDiscount(10)
			if __ANDROID then self.buyButton:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark")..normGood)
			else self.buyButton:setNumber(normGood) end
			self.discount = false
		else
			self.buyButton:setDiscount(math.ceil(discountGood / normGood * 100) / 10, Localization:getInstance():getText("buy.gold.panel.discount"))
			if __ANDROID then self.buyButton:setNumber(Localization:getInstance():getText("buy.gold.panel.money.mark")..discountGood)
			else self.buyButton:setNumber(discountGood) end
			self.discount = true
		end
		self.buyButton:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
		self.useButton:removeFromParentAndCleanup(true)
	end

	-- 周赛用新的文案
	if self.levelType == GameLevelType.kDigWeekly then
		self.msgLabel:setString(Localization:getInstance():getText('add.step.panel.msg.weekly.race'))
		if _isQixiLevel then
			self.msgLabel:setString(Localization:getInstance():getText('activity.qixi.fail.add.five'))
		end
		cryingAnimation:setPosition(ccp(108, -826))
	elseif self.levelType == GameLevelType.kMayDay then
		self.msgLabel:setString(Localization:getInstance():getText('activity.christmas.fail.add.five'))
		self.msgLabel:setDimensions(CCSizeMake(0,0))
		cryingAnimation:setPosition(ccp(108, -856))
	elseif self.levelType == GameLevelType.kRabbitWeekly then
		self.msgLabel:setString(Localization:getInstance():getText('add.step.panel.msg.txt.10040.rabbit'))
		cryingAnimation:setPosition(ccp(108, -826))
	else
		self.msgLabel:setString(Localization:getInstance():getText("add.step.panel.msg.txt."..self.propId))
		cryingAnimation:setPosition(ccp(108, -856))
	end

	-- countdown animation
	local charWidth = 153
	local charHeight = 153
	local charInterval = 80
	local fntFile = "fnt/steps_cd.fnt"
	self.countdownLabel	= LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.ui:addChild(self.countdownLabel)
	self.countdownLabel:setAnchorPoint(ccp(0,1))
	self.countdownLabelPhSize = self.countdownLabelPh:getGroupBounds().size
	self.countdownLabelPhPos = self.countdownLabelPh:getPosition()
	local countdownLabelPhPos = self.countdownLabelPhPos
	self:setCountdownSceond(10)

	-- set position
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local size = self:getGroupBounds().size
	self.panelPopRemoveAnim		= PanelPopRemoveAnim:create(self)
	local initX = self:getHCenterInScreenX()
	local selfHeight = self.ui:getGroupBounds().size.height
	self.panelPopRemoveAnim:setPopHidePos(initX, selfHeight)
	self.panelPopRemoveAnim:setPopShowPos(0, (vSize.height - size.height) / 2 + vOrigin.y)

	-- add event listeners
	local function onUseBtnTapped(evt)
		self:onUseBtnTapped()
	end
	self.useButton:addEventListener(DisplayEvents.kTouchTap, onUseBtnTapped)

	local function onBuyBtnTapped(evt)
		self:onBuyBtnTapped()
	end
	self.buyButton:addEventListener(DisplayEvents.kTouchTap, onBuyBtnTapped)

	local function onCloseTapped(evt)
		self:onCloseBtnTapped()
	end
	self.closeBtn.ui:ad(DisplayEvents.kTouchTap, onCloseTapped)

	return true
end

function EndGamePropShowPanel:onUseBtnTapped()
	local function onSuccess()
		local function onCallback()
			if self.onUseTappedCallback then
				self.onUseTappedCallback()
			end
		end
		
		-- animation
		local pos = self.useButton:getPosition()
		pos = self.useButton:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
		if self.propId == PropList.kAddTime.itemid then
			self:addPropUseAnimation(pos, onCallback)
		else
			onCallback()
			self:addPropUseAnimation(pos)
		end

		self:remove(false)
	end
	local function onFail(evt)
		local function resumeTimer()
			if self.isDisposed then return end
			local function onCountDown() self:countdownCallback() end
			self:startCountdown(onCountDown)
			self.useButton:setEnabled(true)
		end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative", resumeTimer)
	end
	self.useButton:setEnabled(false)
	self:stopCountdown()
	local logic = UsePropsLogic:create(false, self.levelId, 0, {self.propId})
	logic:setSuccessCallback(onSuccess)
	logic:setFailedCallback(onFail)
	logic:start(true)
end

function EndGamePropShowPanel:onBuyBtnTapped()
	local function useAddStepSuccess()
		local function onCallback()
			if self.onUseTappedCallback then
				self.onUseTappedCallback()
			end
		end
		-- animation
		if self.isDisposed then return end
		local pos = self.buyButton:getPosition()
		pos = self.buyButton:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
		if self.propId == PropList.kAddTime.itemid then
			self:addPropUseAnimation(pos, onCallback)
		else
			onCallback()
			self:addPropUseAnimation(pos)
		end

		self:remove(false)
	end
	local function resumeTimer()
		if self.isDisposed then return end
		local function onCountDown() self:countdownCallback() end
		self:startCountdown(onCountDown)
		self.buyButton:setEnabled(true)
	end
	local function onCreateGoldPanel()
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			local panel = createMarketPanel(index)
			panel:popout()
			panel:addEventListener(kPanelEvents.kClose, resumeTimer)
		else resumeTimer() end
	end
	local function onBuySuccess()
		local button = HomeScene:sharedInstance().goldButton
		if button then button:updateView() end
		useAddStepSuccess()
		if self.isOneFenAddStep == true then  -- set 1 fen as 'used'
			UserManager:getInstance().userExtend:setFlagBit(5, true)
			UserService:getInstance().userExtend:setFlagBit(5, true)
		elseif self.isTimeLimitAddStep then

			local scene = Director.sharedDirector():getRunningScene()
			if scene and scene.propList then
				for k,v in pairs(TimeLimitData:getInstance():getIngameSendItems()) do
					scene.propList:addItemNumber(v.itemId, v.num)
				end
			end

			TimeLimitData:getInstance():setBought()
			DcUtil:UserTrack({ category = 'activity', sub_category = 'buy_failure_panel'})

		end
	end
	local function onBuyFail(evt)
		if evt.data == 730330 then -- not enough gold
			local text = {
				tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
				yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
				no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
			}
			CommonTipWithBtn:setShowFreeFCash(true)
			CommonTipWithBtn:showTip(text, "negative", onCreateGoldPanel, resumeTimer)
		else
			if __ANDROID then -- ANDROID
				CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.fail.android"), "negative", resumeTimer)
			else -- else, onIOS and PC we use gold!
				CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative", resumeTimer)
			end
		end
	end
	local function onCancel(isExceedLimit)
		if isExceedLimit or PrepackageUtil:isPreNoNetWork() then
			resumeTimer()
		else
			CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.cancel.android"), "negative", resumeTimer)
		end
	end
	self.buyButton:setEnabled(false)
	self:stopCountdown()
	local goodsId

	if self.isOneFenAddStep then 
		goodsId = getOneFenGoodsId(propId)
	elseif self.isTimeLimitAddStep then
		goodsId = self.timeLimitGoodsId
	elseif self.discount then 
		goodsId = getDiscountId(self.propId)
	else 
		goodsId = getGoodId(self.propId) 
	end

	if __ANDROID then -- ANDROID
		local logic = IngamePaymentLogic:create(goodsId)
		logic:buy(onBuySuccess, onBuyFail, onCancel)
	else -- else, on IOS and PC we use gold!
		if RequireNetworkAlert:popout() then
			local logic = BuyLogic:create(goodsId, 2)
			logic:getPrice()
			logic:setCancelCallback(onCancel)
			logic:start(1, onBuySuccess, onBuyFail)
		else resumeTimer() end
	end
end

function EndGamePropShowPanel:onCloseBtnTapped(...)
	assert(#{...} == 0)

	self:stopCountdown()
	local function hideFinishCallback()
		if self.onCancelTappedCallback then
			self.onCancelTappedCallback()
		end

	end

	self.allowBackKeyTap = false
	self:remove(hideFinishCallback)

end

function EndGamePropShowPanel:countdownCallback(...)
	assert(#{...} == 0)

	if self.second == 0 then
		self.countdownLabel:stopAllActions()
		self:onCloseBtnTapped()
	else
		self:setCountdownSceond(self.second)
	end
end

function EndGamePropShowPanel:startCountdown(callback, ...)
	print(callback)
	print("type(callback)", type(callback))
	assert(type(callback) == "function")
	assert(#{...} == 0)

	print(debug.traceback())

	local function callbackFunc()
		self.second = self.second - 1
		callback(self.second)
	end
	callback(self.second)
	self.countdownLabel:stopAllActions()
	self.countdownLabel:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(callbackFunc))))
end

function EndGamePropShowPanel:stopCountdown(...)
	assert(#{...} == 0)

	self.countdownLabel:stopAllActions()
end

function EndGamePropShowPanel:setCountdownSceond(second, ...)
	assert(type(second) == "number")
	assert(#{...} == 0)

	self.secondToCountdown = second
	self.countdownLabel:setString(tostring(second))
	self:positionCountdownLabel()
end

function EndGamePropShowPanel:positionCountdownLabel(...)
	assert(#{...} == 0)

	local countdownLabelSize = self.countdownLabel:getContentSize()
	local deltaWidth 	= self.countdownLabelPhSize.width - countdownLabelSize.width
	local deltaHeight	= self.countdownLabelPhSize.height - countdownLabelSize.height
	local newPosX	= self.countdownLabelPhPos.x + deltaWidth/2
	local newPosY	= self.countdownLabelPhPos.y - deltaHeight/2
	self.countdownLabel:setPosition(ccp(newPosX, newPosY))
end

function EndGamePropShowPanel:popout(...)
	assert(#{...} == 0)
	print('EndGamePropShowPanel:popout(...)')
	-- debug.debug()

	local function popoutFinishCallback()
		self.allowBackKeyTap = true
		local function countdownCallback() self:countdownCallback() end
		self.second = 10
		self:startCountdown(countdownCallback)

		if self.propId == 10004 then
			local propNum = UserManager:getInstance():getUserProp(self.propId) 
			if not propNum or propNum.num <= 0 then
				FreeFCashPanel:showWithOwnerCheck(self)
			end
		end
	end
	self.panelPopRemoveAnim:popout(popoutFinishCallback)
end

function EndGamePropShowPanel:remove(animFinishCallback, ...)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	assert(#{...} == 0)
	-- test
	FreeFCashPanel:hideWithOwnerCheck(self)

	if self.timeLimitPanel then 
		self.timeLimitPanel:setVisible(false)
	end

	self.panelPopRemoveAnim:remove(animFinishCallback)
end

function EndGamePropShowPanel:setOnUseTappedCallback(onUseCallback, ...)
	assert(type(onUseCallback) == "function")
	assert(#{...} == 0)

	self.onUseTappedCallback = onUseCallback
end

function EndGamePropShowPanel:setOnCancelTappedCallback(onCancelCallback, ...)
	assert(type(onCancelCallback) == "function")
	assert(#{...} == 0)

	self.onCancelTappedCallback = onCancelCallback
end

function EndGamePropShowPanel:addPropUseAnimation( pos, onAnimFinishedCallback )
	-- body
	if self.propId == PropList.kAddMove.itemid then 
		local icon = ResourceManager:sharedInstance():buildItemSprite(self.propId)
		local scene = Director:sharedDirector():getRunningScene()
		local animation = PrefixPropAnimation:createAddMoveAnimation(icon, 0, nil, nil, ccp(pos.x, pos.y + 90))
		scene:addChild(animation)
	elseif self.propId == PropList.kAddTime.itemid then 
		local icon = ResourceManager:sharedInstance():buildItemSprite(self.propId)
		local scene = Director:sharedDirector():getRunningScene()
		local animation = PrefixPropAnimation:createAddTimeAnimation(icon, 0, onAnimFinishedCallback, nil, ccp(pos.x, pos.y + 90))
		scene:addChild(animation)
	end
end
