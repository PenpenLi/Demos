require "zoo.common.CountdownTimer"
require "zoo.panel.component.common.BubbleItem"
require "zoo.common.ItemType"
require "zoo.panel.component.addStepPanel.UseAddStepBtn"
require "zoo.panelBusLogic.BuyLogic"
require "zoo.panel.RequireNetworkAlert"
require 'hecore.sns.SnsProxy'
require 'zoo.panel.FreeFCashPanel'

require "zoo.panel.TimeLimitPanel"
require "zoo.panelBusLogic.IapBuyPropLogic"
require "zoo.panelBusLogic.AddFiveStepABCTestLogic"
require "zoo.util.FUUUManager"
require 'zoo.payment.WechatQuickPayLogic'


local UseButton = class(GroupButtonBase)
function UseButton:create(groupNode, propId)
	local button = UseButton.new(groupNode)
	button:buildUI()
	button.redCircle = groupNode:getChildByName("redCircle")
	button.numberLabel = groupNode:getChildByName("numberLabel")
	button.numberLabel:setPositionX(button.numberLabel:getPositionX() + 8)
	button.numberLabel:setPositionY(button.numberLabel:getPositionY() - 2)
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
	button.discount = groupNode:getChildByName("discount")
	button.dcNumber = button.discount:getChildByName("num")
	button.dcText = button.discount:getChildByName("text")

	button:initOriNumber(groupNode)
	return button
end

function BuyButton:initOriNumber(groupNode)
	self.oriNumber = groupNode:getChildByName("oriNumber")
	self.redLine = groupNode:getChildByName("redLine")
	if not self.oriNumber or not self.redLine then return end
	self.oriNumber:setVisible(false)
	self.redLine:setVisible(false)

	self.oriNumberLabel = self.oriNumber:getChildByName("number")
	local numberSize = self.oriNumber:getChildByName("numberSize")
	local size = numberSize:getContentSize()
	local position = numberSize:getPosition()
	local scaleX = numberSize:getScaleX()
	local scaleY = numberSize:getScaleY()
	self.oriNumberRect = {x=position.x, y=position.y, width=size.width*scaleX, height=size.height*scaleY}
	numberSize:removeFromParentAndCleanup(true)
end

function BuyButton:setOriNumber(str)
	if not self.oriNumber or not self.redLine then return end
	self.oriNumber:setVisible(true)
	self.redLine:setVisible(true)
	local oriNumberLabel = self.oriNumberLabel
	if oriNumberLabel and oriNumberLabel.refCocosObj then
		if self.isStaticNumberLabel then oriNumberLabel:setString(str)
		else
			oriNumberLabel:setText(str)
			InterfaceBuilder:centerInterfaceInbox( oriNumberLabel, self.oriNumberRect )
		end
	end
end

function BuyButton:setOriNumberAlignment(alignment)
	if not self.oriNumber then return end
	self:setTextAlignment(self.oriNumberLabel, self.oriNumberRect, alignment, self.isStaticNumberLabel)
end

function BuyButton:setDiscount(number, text)
	if number <= 0 or number == 10 then
		self.dcNumber:setVisible(false)
		self.dcText:setVisible(false)
		self.discount:setVisible(false)
		self.dcNumber:setText(number)
	else
		self.dcNumber:setVisible(true)
		self.dcText:setVisible(true)
		self.discount:setVisible(true)
		self.dcNumber:setText(number)
		self.dcText:setText(text)
		self.dcNumber:setScale(2.5)
		self.dcText:setScale(1.7)

		--[[
		local scaleBase = self.discount:getScale()
		local actArray = CCArray:create()
		actArray:addObject(CCDelayTime:create(5))
		actArray:addObject(CCScaleTo:create(0.1, scaleBase * 0.95))
		actArray:addObject(CCScaleTo:create(0.1, scaleBase * 1.1))
		actArray:addObject(CCScaleTo:create(0.2, scaleBase * 1))
		self.discount:runAction(CCRepeatForever:create(CCSequence:create(actArray)))
		]]
	end
end

function BuyButton:getDiscount(number)
	return self.dcNumber:getString(), self.dcText:getString()
end

EndGamePropShowPanel = class(BasePanel)

local PropList = table.const{
	kAddMove = {itemid = 10004, goodId = 24, discountGoodsId = 33},
	kRivive = {itemid = 10040, goodId = 46, discountGoodsId = 47},
	kAddTime = {itemid = 16, goodId = 155, discountGoodsId = 155},
} 

local function getGoodId( itemid )
	for k, v in pairs(PropList) do 
		if itemid == v.itemid then return v.goodId end
	end
end

local function getDiscountId( itemid )
	for k, v in pairs(PropList) do 
		if itemid == v.itemid then return v.discountGoodsId end
	end
end

local function getOneFenGoodsId(itemid)
	return 102
end

function EndGamePropShowPanel:create(levelId, levelType, propId, onUseCallback, onCancelCallback)
	local function popoutPanel(decision, paymentType, dcAndroidStatus, otherPaymentTable, repayChooseTable)
		local panel = EndGamePropShowPanel.new()
		panel.levelType = levelType
		panel.onUseTappedCallback = onUseCallback
		panel.onCancelTappedCallback = onCancelCallback
		panel:loadRequiredResource(PanelConfigFiles.panel_add_step)
		if __ANDROID then 
			panel.adDecision = decision
			panel.adPaymentType = paymentType
			panel.dcAndroidStatus = dcAndroidStatus
			panel.adRepayChooseTable = repayChooseTable
		end
		print("propId============================================",propId)
		local isFUUU , fuuuId = FUUUManager:lastGameIsFUUU(true)

		panel.lastGameIsFUUU = isFUUU
		panel.fuuuLogID = fuuuId
		if propId == PropList.kAddMove.itemid then
			panel:initForAddStep(levelId, propId)
			panel:popout()
		else
			if panel:init(levelId, propId) then
				AddFiveStepABCTestLogic:dcLog("pop_add_5_steps", levelId, self.actSource, propId)
				panel:popout() 
			else
				panel = nil
			end
		end
	end

	if __ANDROID then 
		PaymentManager.getInstance():getBuyItemDecision(popoutPanel, getGoodId(propId))
	else
		popoutPanel()
	end
end

function EndGamePropShowPanel:saveBtnScaleInfo(button)
	if self.BtnSourceScale == nil then
		self.BtnSourceScale = {}
	end

	--local btnBGNode = button.background
	local btnBGNode = button.groupNode
	local scaleX = btnBGNode:getScaleX()
	local scaleY = btnBGNode:getScaleY()
	self.BtnSourceScale[tostring(button)] = {ScaleX = scaleX , ScaleY = scaleY}
end

function EndGamePropShowPanel:addBtnPopupEff(button)
	self:removeBtnPopupEff(button)

	--local btnBGNode = button.background
	local btnBGNode = button.groupNode
	
	local ppp = btnBGNode:getAnchorPoint()
	print("RRR   ppp.x = " .. tostring(ppp.x) .. "   ppp.y = " .. tostring(ppp.y))
	--btnBGNode:setAnchorPoint( ccp(ppp.x-200 , ppp.y+0) )
	--btnBGNode:setAnchorPointCenterWhileStayOrigianlPosition()

	local deltaTime = 0.1
	local scaleX = btnBGNode:getScaleX()
	local scaleY = btnBGNode:getScaleY()
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 0.98, scaleY * 0.98))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 1, scaleY * 1))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 1.02, scaleY * 1.02))
	animations:addObject(CCScaleTo:create(deltaTime, scaleX * 1, scaleY * 1))
	animations:addObject(CCScaleTo:create(2, scaleX * 1, scaleY * 1))
	btnBGNode:runAction(CCRepeatForever:create(CCSequence:create(animations)))
end

function EndGamePropShowPanel:removeBtnPopupEff(button)
	if self.BtnSourceScale ~= nil and self.BtnSourceScale[tostring(button)] ~= nil then
		--local btnBGNode = button.background
		local btnBGNode = button.groupNode
		btnBGNode:stopAllActions()
		btnBGNode:setScaleX(self.BtnSourceScale[tostring(button)].ScaleX)
		btnBGNode:setScaleY(self.BtnSourceScale[tostring(button)].ScaleY)
	end
end


function EndGamePropShowPanel:initForAddStep(levelId, propId)
	local timeProps = UserManager:getInstance():getTimePropsByRealItemId(propId)
	local timePropNum = 0
	local returnResult

	local doAddStepsDCLog = function()
		AddFiveStepABCTestLogic:dcLog("pop_add_5_steps" , levelId , self.actSource , propId)
	end

	if timeProps and #timeProps > 0 then
		for _,v in pairs(timeProps) do
			timePropNum = timePropNum + v.num
		end
	end
	self.actSource = 0
	print("RRR   EndGamePropShowPanel:initForAddStep  timePropNum = " .. tostring(timePropNum))
	if timePropNum > 0 then
		returnResult = self:init(levelId, propId)
		doAddStepsDCLog()
		return returnResult
	end

	if __ANDROID then
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
			returnResult = self:initForTimeLimitAddStep(levelId,propId)
			doAddStepsDCLog()
			return returnResult
		end
	end

	if __IOS then

		local prop = UserManager:getInstance():getUserProp(propId)
		if prop == nil or prop.num <= 0 then
			local userExtend = UserManager:getInstance().userExtend
			if not userExtend then 
				returnResult = self:init(levelId, propId) 
				doAddStepsDCLog()
				return returnResult
			end
			if MaintenanceManager:getInstance():isEnabled("Cny1Feature") or not userExtend.payUser then

				local goods = MetaManager:getInstance():getGoodMeta(getDiscountId(propId))
				local normGood, discountGood = goods.qCash, goods.discountQCash
				local userCash = UserManager:getInstance().user:getCash()
				local needCash = 0

				local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(getDiscountId(propId))
				if buyed >= goods.limit then
					needCash = normGood
				else
					needCash = discountGood
				end


				local fuuuDailyData = FUUUManager:getDailyData()
				local continuousFailNum = FUUUManager:getLevelContinuousFailNum(levelId)
				local today = tostring( os.date("%x", os.time()) )

				if self.lastGameIsFUUU then

					if fuuuDailyData then
						if fuuuDailyData.today == today then
							if fuuuDailyData.isEnable == false then
								self.lastGameIsFUUU = false
							end
						else
							fuuuDailyData.today = today
							fuuuDailyData.isEnable = true
						end
					else
						fuuuDailyData = {}
						fuuuDailyData.today = today
						fuuuDailyData.isEnable = true
					end

					if continuousFailNum < FUUUConfig.oneYuanBuyContinuousFailNum then
						self.lastGameIsFUUU = false
					end
				end

				if userCash < needCash then
				end

				if userCash < needCash and self.lastGameIsFUUU then
					if fuuuDailyData then
						fuuuDailyData.today = today
						fuuuDailyData.isEnable = false
						FUUUManager:setDailyData(fuuuDailyData)
					end

					returnResult = self:initForIapPayAddStep(levelId, propId)
					doAddStepsDCLog()
					return returnResult	
				else
					returnResult = self:init(levelId, propId) 
					doAddStepsDCLog()
					return returnResult
				end
			end
		end
	end
	returnResult = self:init(levelId, propId)
	doAddStepsDCLog()
	return returnResult
end

--  一元限购逻辑
function EndGamePropShowPanel:initForIapPayAddStep(levelId, propId)
	print("RRR   EndGamePropShowPanel:initForIapPayAddStep  propId = " .. tostring(propId))
	self.iosRmbPay = true
	
	self:init(levelId, propId)
	self.actSource = 3

	local icon = self.buyButton:getIcon()
	icon:removeFromParentAndCleanup(false)
	self.buyButton.icon = nil
	self.buyButton:setColorMode(kGroupButtonColorMode.blue)

	local data = IapBuyPropLogic:addStep()
	local meta = MetaManager:getInstance():getGoodMeta(data.goodsId)

	self.buyButton:setNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), data.price))
	self.buyButton:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
	self.buyButton:setDiscount(math.ceil(meta.discountRmb / meta.rmb * 10), Localization:getInstance():getText("buy.gold.panel.discount"))
	self.buyButton:setVisible(true)
	--self.buyButton:setPositionY(self.buyButton:getPositionY() - 70)

	-- ////////////////
	local groupNode = self.buyButton.groupNode
	local number = groupNode:getChildByName("number")
	local label = groupNode:getChildByName("label")
	number:setPositionX(number:getPositionX() - 35)
	label:setPositionX(label:getPositionX() + 5)
	-- ////////////////

	local function useAddStepSuccess()
		local function onCallback()
			AddFiveStepABCTestLogic:dcLog("buy_add_5_steps_success" , self.levelId , self.actSource , self.propId)
			if self.onUseTappedCallback then
				self.onUseTappedCallback(propId, UsePropsType.NORMAL)
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
		if AddFiveStepABCTestLogic:needShowCountdown() then
			self:startCountdown(onCountDown)
		end
		self.buyButton:setEnabled(true)
	end

	local function onSuccess()
		useAddStepSuccess()
	end
	local function onFail()
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative", resumeTimer)
		self.buyButton:setEnabled(true)
	end

	-- self.uniquePayId = PaymentIosDCUtil.getInstance():getNewIosPayID()
	self.data = data
	self.dcIosInfo = DCIosRmbObject:create()
	self.dcIosInfo:setGoodsId(data.productIdentifier)
	self.dcIosInfo:setGoodsType(1)
	self.dcIosInfo:setGoodsNum(1)
	self.dcIosInfo:setRmbPrice(data.iapPrice)

	local peDispatcher = PaymentEventDispatcher.new()
	local function successDcFunc(evt)
		self.dcIosInfo:setResult(IosRmbPayResult.kSuccess)
		PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)
	end
	local function failedDcFunc(evt)
		self.dcIosInfo:setResult(IosRmbPayResult.kSdkFail)
		PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)
	end
	peDispatcher:addEventListener(PaymentEvents.kIosBuySuccess, successDcFunc)
	peDispatcher:addEventListener(PaymentEvents.kIosBuyFailed, failedDcFunc)

	local function onButton()
		self.buyButton:setEnabled(false)
		self:stopCountdown()
		IapBuyPropLogic:buy(data, onSuccess, onFail, peDispatcher)
	end
	self.buyButton:removeAllEventListeners()
	self.buyButton:addEventListener(DisplayEvents.kTouchTap, onButton)
end

function EndGamePropShowPanel:initForTimeLimitAddStep(levelId, propId)
	print("RRR   EndGamePropShowPanel:initForTimeLimitAddStep  propId = " .. tostring(propId))
	self:init(levelId, propId)

	local payGiftInfo = UserManager:getInstance().payGiftInfo
	self.isTimeLimitAddStep = true
	self.timeLimitGoodsId = TimeLimitData:getInstance():getIngameGoodsId()


	local bounds = self.ui:getGroupBounds()

	self.timeLimitPanel = self:buildInterfaceGroup("add_step_tip")

	local timeLimitBounds = self.timeLimitPanel:getGroupBounds()

	self.timeLimitPanel:setPositionX(bounds:getMidX() - timeLimitBounds.size.width/2 + 40)
	self.timeLimitPanel:setPositionY(bounds:getMinY() + 170)

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
	local extraHeight = timeLimitBounds.size.height - 60
	local scaleheight = blackBg:boundingBox().size.height + extraHeight
	blackBg:setScaleY(scaleheight / blackBg:getContentSize().height )

	self.countdownLabel:setPositionY(self.countdownLabel:getPositionY() - extraHeight)
	--self.bgBottom:setPositionY(self.bgBottom:getPositionY() - extraHeight)

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
		string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), TimeLimitData:getInstance():getIngameBuyActualValue()),
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
		string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), TimeLimitData:getInstance():getIngameBuyDiscountValue())
	)

	self.buyButton.numberLabel:setPositionX(self.buyButton.numberLabel:getPositionX() - 20)
	originalPriceLabel:setPositionX(originalPriceLabel:getPositionX() - 40)
	line:setPositionX(line:getPositionX() - 40)
	self.buyButton.label:setPositionX(233)

	return true
end

function EndGamePropShowPanel:createAnime(animeType)
	local cryingAnimation = nil

	if animeType == 1 then
		cryingAnimation = AddFiveStepAnimation:create()
	end

	if not cryingAnimation then
		cryingAnimation = AddEnergyAnimation:create()
	end
	
	self.ui:addChild(cryingAnimation)
	self.cryingAnimation = cryingAnimation
	local aSize = self.cryingAnimation:getGroupBounds().size
	local pSize = self.animPh:getGroupBounds().size
	self.cryingAnimation:setPositionXY(
		self.animPh:getPositionX(),
		self.animPh:getPositionY())
	self.cryingAnimation:setScale(pSize.height / aSize.height)
	self.animPh:setVisible(false)
end

function EndGamePropShowPanel:init(levelId, propId)
	print("RRR   EndGamePropShowPanel:init  propId = " .. tostring(propId))
	if not levelId then return false end

	local needRefreshPos = false
	-- data
	self.levelId = levelId
	self.propId = propId
	-- init panel
	self.ui = self:buildInterfaceGroup("newAddStepPanel")
	BasePanel.init(self, self.ui)

	-- get & create controls
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.msgLabel = self.ui:getChildByName("msgLabel")
	self.msgLabelPh = self.ui:getChildByName("msgLabelph")
	self.countdownLabel = self.ui:getChildByName("countdownLabel")
	self.countdownLabel:setScale(1.3)
	self.countdownLabel:setPositionY(self.countdownLabel:getPositionY() + 15)
	self.countdownLabelPos = self.ui:getChildByName('labelPh'):getPosition()
	self.ui:getChildByName('labelPh'):setVisible(false)
	local useBtnRes = self.ui:getChildByName("useBtn")
	local buyBtnRes = self.ui:getChildByName("buyBtn")
	self.buyButton = BuyButton:create(buyBtnRes, self.propId)
	self.useButton = UseButton:create(useBtnRes, self.propId)
	self.animPh = self.ui:getChildByName("animPh")
	self.moneyBar = self.ui:getChildByName("moneyBar")
	self.moneyBar:setVisible(false)

	self:saveBtnScaleInfo(self.buyButton)
	self:saveBtnScaleInfo(self.useButton)
	self:createAnime(1)
	-- set control state
	self.msgLabelPh:setVisible(false)
	local builder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local sprite = builder:buildGroup("Prop_"..tostring(self.propId))
	local icon = self.ui:getChildByName("icon")
	local iSize = icon:getGroupBounds().size
	local sSize = sprite:getGroupBounds().size
	sprite:setScale(iSize.height / sSize.height)
	if self.propId == PropList.kRivive.itemid then
		sprite:setScale(sprite:getScale()*0.9)
	end
	sprite:setPositionXY(icon:getPositionX(), icon:getPositionY())
	self.ui:addChild(sprite)
	self.propIconSprite = sprite
	icon:removeFromParentAndCleanup(true)
	local timeProps = UserManager:getInstance():getTimePropsByRealItemId(self.propId)
	self.timeProps = timeProps
	local propNum = 0
	if #self.timeProps > 0 then
		for _,v in pairs(self.timeProps) do
			propNum = propNum + v.num
		end
	else
		local prop = UserManager:getInstance():getUserProp(self.propId)
		if prop then propNum = prop.num end
	end
	print("RRR   EndGamePropShowPanel:init  propNum = " .. tostring(propNum))
	if propNum > 0 then -- use
		self.useButton:setNumber(propNum)
		self.useButton:setString(Localization:getInstance():getText("add.step.panel.use.btn.txt"))
		self.buyButton:setVisible(false)
	else -- buy
		self.buyButton:setColorMode(kGroupButtonColorMode.blue)
		if __ANDROID then
			self.buyButton.discount:setVisible(false)

			if self.adDecision == IngamePaymentDecisionType.kPayWithWindMill then
				self.moneyBar:setVisible(true)
				local goldText = self.moneyBar:getChildByName("goldText")
				goldText:setString(Localization:getInstance():getText("buy.prop.panel.label.treasure"))
				self.goldNum = self.moneyBar:getChildByName("gold")
				self:updateGoldNum()
			elseif self.adPaymentType == Payments.ALIPAY and UserManager.getInstance():isAliSigned() then
				self.ui:getChildByName("labelAliQuickPay"):setString(localize("alipay.pay.kf.confirm"))
			elseif self.adPaymentType == Payments.WECHAT and UserManager.getInstance():isWechatSigned() and _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then
				self.ui:getChildByName("labelAliQuickPay"):setString(localize("wechat.kf.enter2"))
			end
		end

		local discountGoodsId = getDiscountId(self.propId)
		local goodsInfo = GoodsIdInfoObject:create(discountGoodsId)
		local discountOneYuanGoodsId = goodsInfo:getOneYuanGoodsId()
		local goods = MetaManager:getInstance():getGoodMeta(discountGoodsId)
		local normGood, discountGood
		local adWindMillPay = false
		if __ANDROID then -- ANDROID
			self.buyButton.discount:setVisible(false)
			if self.adDecision == IngamePaymentDecisionType.kPayWithWindMill then
				adWindMillPay = true
				normGood, discountGood = goods.qCash, goods.discountQCash
				self.buyButton:setIconByFrameName("ui_images/ui_image_coin_icon_small0000")
			elseif self:isOneYuanDecision() then
				local goodsMeta = MetaManager:getInstance():getGoodMeta(discountOneYuanGoodsId)
				normGood, discountGood = goodsMeta.thirdRmb / 100, goodsMeta.thirdRmb / 100
			else
				normGood, discountGood = goods.rmb / 100, goods.discountRmb / 100
			end
		else -- else, on IOS and PC we use gold!
			normGood, discountGood = goods.qCash, goods.discountQCash
			self.buyButton:setIconByFrameName("ui_images/ui_image_coin_icon_small0000")
		end
		local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(discountGoodsId)
		local buyedOneYuan = UserManager:getInstance():getDailyBoughtGoodsNumById(discountOneYuanGoodsId)
		if buyed >= goods.limit or buyedOneYuan >= goods.limit  then
			self.buyButton:setDiscount(10)
			if __ANDROID then 
				if adWindMillPay then 
					self.adShowPriceForWindMill = normGood
					self.buyButton:setNumber(normGood)
				else
					if self:isOneYuanDecision() then
						--一元限购时显示原价
						needRefreshPos = true
						self.buyButton:setOriNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"),  goods.rmb / 100))
					end
					self.adShowPriceForRmb = normGood
					self.buyButton:setNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), normGood))
				end
				self.actSource = 5
			else 
				self.iosShowPriceForWindMill = normGood
				self.buyButton:setNumber(normGood) 
				self.actSource = 2
			end
			self.discount = false
		else
			local discountNum = math.ceil(discountGood / normGood * 10)
			if __ANDROID then 
				if adWindMillPay then
					self.adShowPriceForWindMill = discountGood 
					self.buyButton:setNumber(discountGood)
				else
					self.adShowPriceForRmb = discountGood
					self.buyButton:setNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), discountGood))
					--首次打折或者一元特价时显示原价
					needRefreshPos = true
					local oriPrice = normGood
					if self:isOneYuanDecision() then
						oriPrice = goods.rmb / 100
						local goodsInfo = GoodsIdInfoObject:create(discountGoodsId)
						goodsInfo:setGoodsIdChange(GoodsIdChangeType.kOneYuanChange)
						discountNum = goodsInfo:getDiscountNum()
					end
					self.buyButton:setOriNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), oriPrice))
				end
				self.actSource = 4
			else 
				self.iosShowPriceForWindMill = discountGood
				self.buyButton:setNumber(discountGood)
				self.actSource = 1 
			end
			self.buyButton:setDiscount(discountNum, Localization:getInstance():getText("buy.gold.panel.discount"))
			self.discount = true
		end
		self.buyButton.numberLabel:setPositionX(self.buyButton.numberLabel:getPositionX() - 20)
		self.buyButton:setString(Localization:getInstance():getText("add.step.panel.buy.btn.txt"))
		self.useButton:removeFromParentAndCleanup(true)
	end

	-- 周赛用新的文案
	local dimensions = self.msgLabel:getDimensions()
	self.msgLabel:setDimensions(CCSizeMake(dimensions.width, 0))
	if self.levelType == GameLevelType.kDigWeekly then
		self.msgLabel:setString(Localization:getInstance():getText('add.step.panel.msg.weekly.race'))
		if _isQixiLevel then
			self.msgLabel:setString(Localization:getInstance():getText('activity.qixi.fail.add.five'))
		end
	elseif self.levelType == GameLevelType.kMayDay then
		self.msgLabel:setString(Localization:getInstance():getText('activity.dragonboat.fail.add.five'))
	elseif self.levelType == GameLevelType.kRabbitWeekly then
		self.msgLabel:setString(Localization:getInstance():getText('add.step.panel.msg.txt.10040.rabbit'))
	else
		self.msgLabel:setString(Localization:getInstance():getText("add.step.panel.msg.txt."..self.propId))
	end
	local size = self.msgLabel:getContentSize()
	local phSize = self.msgLabelPh:getGroupBounds().size
	self.msgLabel:setPositionY(self.msgLabelPh:getPositionY() - (phSize.height - size.height) / 2)

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
		self.buyButtonTarget = self.buyButton
		self:onBuyBtnTapped()
	end
	self.buyButton:addEventListener(DisplayEvents.kTouchTap, onBuyBtnTapped)

	local function onCloseTapped(evt)
		self:onCloseBtnTapped()
	end
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseTapped)
	self.closeBtn:setTouchEnabled(true)

	if __ANDROID then 
		if self.adDecision ~= IngamePaymentDecisionType.kPayWithWindMill then
			self.buyButton.label:setPositionX(65)
			self.buyButton.numberLabel:setPositionX(-158)

			if needRefreshPos then 
				if self.buyButton.oriNumber then 
					self.buyButton.numberLabel:setPositionY(11)

					self.buyButton.oriNumber:setPosition(ccp(-115, 56))
				end
				if self.buyButton.redLine then 
					self.buyButton.redLine:setPosition(ccp(-110, 50))
				end
			end
		end
	end

	if not AddFiveStepABCTestLogic:needShowCountdown() then
		self:onCountdownComplete()
	end

	if propNum > 0 then
		self.actSource = 6
	end	

	--pay_start打点
	if propNum <= 0 then 
		local goodsId
		if self.isTimeLimitAddStep then
			goodsId = self.timeLimitGoodsId
		elseif self.discount then 
			goodsId = getDiscountId(self.propId)
		else 
			goodsId = getGoodId(self.propId) 
		end

		if __ANDROID then 
			self.adPayStart = true
			if self.adDecision == IngamePaymentDecisionType.kPayWithWindMill then
				self.dcAndroidInfo = DCWindmillObject:create()
				self.dcAndroidInfo:setGoodsId(goodsId)
				self.dcAndroidInfo:setWindMillPrice(self.adShowPriceForWindMill)
				self.dcAndroidInfo:setGoodsNum(1)
				PaymentDCUtil.getInstance():sendAndroidWindMillPayStart(self.dcAndroidInfo)
			else
				self.goodsIdInfo = GoodsIdInfoObject:create(goodsId)
				if self:isOneYuanDecision() then
					self.goodsIdInfo:setGoodsIdChange(GoodsIdChangeType.kOneYuanChange)
				end
				self.dcAndroidInfo = DCAndroidRmbObject:create()
				self.dcAndroidInfo:setGoodsId(self.goodsIdInfo:getGoodsId())
				self.dcAndroidInfo:setGoodsType(self.goodsIdInfo:getGoodsType())
				self.dcAndroidInfo:setGoodsNum(1)
				self.dcAndroidInfo:setTypeStatus(self.dcAndroidStatus)
				if self.adDecision == IngamePaymentDecisionType.kPayFailed then 	
					--加五步面板断网导致支付失败要特殊处理 因为此时面板已经弹出
					if self.adPaymentType == AndroidRmbPayResult.kNoNet then 
						self.dcAndroidInfo:setInitialTypeList(PaymentManager.getInstance():getDefaultThirdPartPayment())
					end
				else
					self.dcAndroidInfo:setInitialTypeList(self.adPaymentType)
				end
				PaymentDCUtil.getInstance():sendAndroidRmbPayStart(self.dcAndroidInfo)
			end
		elseif __IOS and not self.iosRmbPay then 
			self.iosWindMillPay = true
			self.dcIosInfo = DCWindmillObject:create()
			self.dcIosInfo:setGoodsId(goodsId)
			self.dcIosInfo:setWindMillPrice(self.iosShowPriceForWindMill)
			self.dcIosInfo:setGoodsNum(1)
		end
	end

	return true
end

function EndGamePropShowPanel:isOneYuanDecision()
	if self.adDecision and self.adDecision == IngamePaymentDecisionType.kSmsWithOneYuanPay or 
		self.adDecision == IngamePaymentDecisionType.kThirdOneYuanPay then
		return true
	end
	return false
end

function EndGamePropShowPanel:updateGoldNum()
	if self.goldNum then 
		local money = UserManager:getInstance().user:getCash()
		self.goldNum:setString(money)
	end
end

function EndGamePropShowPanel:onUseBtnTapped()
	local usePropType = UsePropsType.NORMAL
	local usePropId = self.propId
	if #self.timeProps > 0 then
		usePropType = UsePropsType.EXPIRE
		usePropId = self.timeProps[1].itemId
	end

	local function onSuccess()
		local function onCallback()
			AddFiveStepABCTestLogic:dcLog("buy_add_5_steps_success" , self.levelId , self.actSource , self.propId)
			if self.onUseTappedCallback then
				self.onUseTappedCallback(usePropId, usePropType)
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
			if AddFiveStepABCTestLogic:needShowCountdown() then
				self:startCountdown(onCountDown)
			end
			self.useButton:setEnabled(true)
		end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative", resumeTimer)
	end
	self.useButton:setEnabled(false)
	self:stopCountdown()
	local logic = UsePropsLogic:create(usePropType, self.levelId, 0, {usePropId})
	logic:setSuccessCallback(onSuccess)
	logic:setFailedCallback(onFail)
	logic:start(true)
	AddFiveStepABCTestLogic:dcLog("click_add_5_steps" , self.levelId , self.actSource , self.propId)
end

function EndGamePropShowPanel:onBuyBtnTapped()
	local goodsId
	if self.isTimeLimitAddStep then
		goodsId = self.timeLimitGoodsId
	elseif self.discount then 
		goodsId = getDiscountId(self.propId)
	else 
		goodsId = getGoodId(self.propId) 
	end

	local function useAddStepSuccess()
		local function onCallback()
			AddFiveStepABCTestLogic:dcLog("buy_add_5_steps_success" , self.levelId , self.actSource , self.propId)
			if self.onUseTappedCallback then
				self.onUseTappedCallback(self.propId, UsePropsType.NORMAL, true)
			end
		end
		-- animation
		if self.isDisposed then return end
		local pos = self.buyButtonTarget:getPosition()
		pos = self.buyButtonTarget:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
		if self.propId == PropList.kAddTime.itemid then
			self:addPropUseAnimation(pos, onCallback)
		else
			setTimeOut(onCallback, 1.3)
			self:addPropUseAnimation(pos)
		end

		self:remove(false)
	end
	local function resumeTimer()
		if self.isDisposed then return end
		local function onCountDown() self:countdownCallback() end
		if AddFiveStepABCTestLogic:needShowCountdown() then
			self:startCountdown(onCountDown)
		end
		self.buyButtonTarget:setEnabled(true)
	end
	local function onCreateGoldPanel()
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			local panel = createMarketPanel(index)
			panel:popout()
			panel:addEventListener(kPanelEvents.kClose, resumeTimer)
		else 
			resumeTimer() 
		end
	end
	local function onBuySuccess()
		self.onEnterForeGroundCallback = nil
		if not self.isDisposed then
			self:stopAllActions()
		end
		local button = HomeScene:sharedInstance().goldButton
		if button then button:updateView() end
		useAddStepSuccess()

		if self.isTimeLimitAddStep then

			local scene = Director.sharedDirector():getRunningScene()
			if scene and scene.propList then
				for k,v in pairs(TimeLimitData:getInstance():getIngameSendItems()) do
					scene.propList:addItemNumber(v.itemId, v.num)
				end
			end

			TimeLimitData:getInstance():setBought()
			DcUtil:UserTrack({ category = 'activity', sub_category = 'buy_failure_panel'})
		end
		if __IOS then 
			self.dcIosInfo:setResult(DCWindmillPayResult.kSuccess)
			PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcIosInfo)
		end
	end
	--for aliquick pay, the evt should be a number, this is for compatiable for other payment.
	local function onBuyFail(errorCode, errorMsg)
		self.onEnterForeGroundCallback = nil

		if not self.isDisposed then
			self:stopAllActions()
		end
		if errorCode and errorCode == 730330 then -- not enough gold
			if __IOS then 
				self.dcIosInfo:setResult(DCWindmillPayResult.kNoWindmill)
				PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcIosInfo)
			end
			local panel = GoldlNotEnoughPanel:create(onCreateGoldPanel, resumeTimer)
			if panel then panel:popout() end 
		else
			if __ANDROID then -- ANDROID
				if errorCode and errorCode == 730241 or errorCode == 730247 or errorCode == SelfDefinePayError.kPaySucCheckFail then
					CommonTip:showTip(errorMsg, "negative")
				else
					CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.fail.android"), "negative")
				end
				resumeTimer()
			else -- else, onIOS and PC we use gold!
				if __IOS then 
					self.dcIosInfo:setResult(DCWindmillPayResult.kFail, evt.data)
					PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcIosInfo)
				end
				if errorCode then 
					CommonTip:showTip(Localization:getInstance():getText("error.tip."..errorCode), "negative", resumeTimer)
				else
					CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.fail.android"), "negative")
				end
			end
		end
	end
	local function onCancel()
		self.onEnterForeGroundCallback = nil
		if not self.isDisposed then
			self:stopAllActions()
		end
		resumeTimer()
	end

	self.buyButtonTarget:setEnabled(false)
	self:stopCountdown()

	if __ANDROID then -- ANDROID
		if self.adDecision == IngamePaymentDecisionType.kPayWithWindMill then
			self:androidBuyWithWindMill(goodsId, onBuySuccess, onBuyFail, onCancel, resumeTimer)
		else
			local logic = IngamePaymentLogic:createWithGoodsInfo(self.goodsIdInfo, self.dcAndroidInfo)
			logic:setBuyConfirmPanel(self)
			logic:endGameBuy(self.adDecision, self.adPaymentType, onBuySuccess, onBuyFail, onCancel, self.onCancelTappedCallback, self.adRepayChooseTable)
			self.buyLogic = logic
			self.onEnterForeGroundCallback = onCancel
		end
	else -- else, on IOS and PC we use gold!
		local logic = BuyLogic:create(goodsId, 2)
		logic:getPrice()
		logic:setCancelCallback(onCancel)
		logic:start(1, onBuySuccess, onBuyFail)
	end
	AddFiveStepABCTestLogic:dcLog("click_add_5_steps" , self.levelId , self.actSource , self.propId)
end

function EndGamePropShowPanel:androidBuyWithWindMill(goodsId, onBuySuccess, onBuyFail, onCancel, resumeTimer)
	local function sucFuncWithDC(data)
		self.dcAndroidInfo:setResult(DCWindmillPayResult.kSuccess)
		PaymentDCUtil.getInstance():sendAndroidWindmillPayEnd(self.dcAndroidInfo)
		if onBuySuccess then onBuySuccess() end
	end

	local function failFuncWithDC(errorCode)
		if errorCode and errorCode == 730330 then -- not enough gold
			self.dcAndroidInfo:setResult(DCWindmillPayResult.kNoWindmill)
		else
			self.dcAndroidInfo:setResult(DCWindmillPayResult.kFail, errorCode)
		end
		PaymentDCUtil.getInstance():sendAndroidWindmillPayEnd(self.dcAndroidInfo)
		if onBuyFail then onBuyFail(errorCode) end
	end

	local logic = BuyLogic:create(goodsId, 2)
	logic:getPrice()
	logic:setCancelCallback(onCancel)
	logic:start(1, sucFuncWithDC, failFuncWithDC)
end

function EndGamePropShowPanel:onCloseBtnTapped()
	--三方查询订单时 不可关闭加五步面板
	if PaymentManager.getInstance():getIsCheckingPayResult() then return end 
	if self.adPayStart then 
		local payResult = self.dcAndroidInfo:getResult()
		if self.adDecision == IngamePaymentDecisionType.kPayWithWindMill then
			if payResult and payResult == DCWindmillPayResult.kNoWindmill then 
				self.dcAndroidInfo:setResult(DCWindmillPayResult.kCloseAfterNoWindmill)
			elseif payResult and payResult == DCWindmillPayResult.kFail then 
				self.dcAndroidInfo:setResult(DCWindmillPayResult.kCloseAfterFail)
			else
				self.dcAndroidInfo:setResult(DCWindmillPayResult.kCloseDirectly)
			end
			PaymentDCUtil.getInstance():sendAndroidWindmillPayEnd(self.dcAndroidInfo)
		else
			if payResult and payResult == AndroidRmbPayResult.kNoNet then  
				self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseAfterNoNet)
			elseif payResult and payResult == AndroidRmbPayResult.kNoPaymentAvailable then 
				self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseAfterNoPaymentAvailable)
			else
				self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseDirectly)
			end
			PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
		end
	elseif __IOS then 
		if self.iosRmbPay then 
			local payResult = self.dcIosInfo:getResult()
			if payResult and payResult == IosRmbPayResult.kSdkFail then 
				self.dcIosInfo:setResult(IosRmbPayResult.kCloseAfterSdkFail)
			else
				self.dcIosInfo:setResult(IosRmbPayResult.kCloseDirectly)
			end
			PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(self.dcIosInfo)
		elseif self.iosWindMillPay then 
			local payResult = self.dcIosInfo:getResult()
			if payResult and payResult == DCWindmillPayResult.kNoWindmill then 
				self.dcIosInfo:setResult(DCWindmillPayResult.kCloseAfterNoWindmill)
			elseif payResult and payResult == DCWindmillPayResult.kFail then 
				self.dcIosInfo:setResult(DCWindmillPayResult.kCloseAfterFail)
			else
				self.dcIosInfo:setResult(DCWindmillPayResult.kCloseDirectly)
			end
			PaymentIosDCUtil.getInstance():sendIosWindmillPayEnd(self.dcIosInfo)
		end
	end

	self:stopCountdown()
	local function hideFinishCallback()
		FUUUManager:clearLastFuuuID()
		if self.onCancelTappedCallback then
			self.onCancelTappedCallback()
		end
	end
	self.allowBackKeyTap = false
	self:remove(hideFinishCallback)
end

function EndGamePropShowPanel:onCountdownComplete(showAnime)
	if AddFiveStepABCTestLogic:needAutoClosePanel() == true then
		print("RRR   EndGamePropShowPanel:onCountdownComplete   needAutoClosePanel")
		self:onCloseBtnTapped()
	else
		print("RRR   EndGamePropShowPanel:onCountdownComplete   needNotAutoClosePanel")

		self.countdownLabel:setVisible(false)
		if not self.onCountdownCompleteAnimePlayed then
			local fixY = 45

			if self.buyButton and self.buyButton.groupNode and self.buyButton.groupNode.parent ~= nil then

				if showAnime then
					self.buyButton.groupNode:runAction( 
						CCMoveTo:create( 0.5 , ccp(self.buyButton:getPositionX(), self.buyButton:getPositionY() + fixY ) ) )
				else
					self.buyButton:setPositionY( self.buyButton:getPositionY() + fixY )
				end
			end

			if self.useButton and self.useButton.groupNode and self.useButton.groupNode.parent ~= nil then

				if showAnime then
					self.useButton.groupNode:runAction( 
						CCMoveTo:create( 0.5 , ccp(self.useButton:getPositionX(), self.useButton:getPositionY() + fixY ) ) )
				else
					self.useButton:setPositionY( self.useButton:getPositionY() + fixY )
				end
			end
			
			if showAnime then
				self.propIconSprite:runAction( 
						CCMoveTo:create( 0.5 , ccp(self.propIconSprite:getPositionX(), self.propIconSprite:getPositionY() + fixY ) ) )
			else
				self.propIconSprite:setPositionY( self.propIconSprite:getPositionY() + fixY )
			end
		end
		
		self.onCountdownCompleteAnimePlayed = true
	end
end

function EndGamePropShowPanel:countdownCallback()
	if self.second == 0 then
		self.countdownLabel:stopAllActions()
		self:onCountdownComplete(true)
	else
		self:setCountdownSceond(self.second)
	end
end

function EndGamePropShowPanel:startCountdown(callback)
	print("type(callback)", type(callback))
	assert(type(callback) == "function")

	local function callbackFunc()
		if self.second and type(self.second) == "number" then
			self.second = self.second - 1
		end
		callback(self.second)
	end

	if self.second and type(self.second) == "number" and self.second > 0 then
		callback(self.second)
		self.countdownLabel:stopAllActions()
		self.countdownLabel:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(callbackFunc))))
	end
end

function EndGamePropShowPanel:stopCountdown()
	self.countdownLabel:stopAllActions()
end

function EndGamePropShowPanel:setCountdownSceond(second)
	assert(type(second) == "number")
	self.secondToCountdown = second
	self.countdownLabel:setText(tostring(second))
	self:positionCountdownLabel()
end

function EndGamePropShowPanel:positionCountdownLabel()
	local countdownLabelSize = self.countdownLabel:getContentSize()
	local posX = self.countdownLabelPos.x - countdownLabelSize.width*self.countdownLabel:getScale()/2
	self.countdownLabel:setPositionX(posX)
end

function EndGamePropShowPanel:popout()
	print('EndGamePropShowPanel:popout(...)')
	local function popoutFinishCallback()
		self.allowBackKeyTap = true
		local function countdownCallback() self:countdownCallback() end
		self.second = 10

		if AddFiveStepABCTestLogic:needShowCountdown() then
			self:startCountdown(countdownCallback)
		end

		if self.propId == 10004 then
			local propNum = UserManager:getInstance():getUserProp(self.propId) 
			if not propNum or propNum.num <= 0 then
				FreeFCashPanel:showWithOwnerCheck(self)
			end
		end
		self:addBtnPopupEff(self.buyButton)
	end
	if self:isOneYuanDecision() then 
		PaymentManager.getInstance():refreshOneYuanShowTime()
	end
	self.panelPopRemoveAnim:popout(popoutFinishCallback)
end

function EndGamePropShowPanel:removePopout()	
	--这个方法在PayPanelRePay里调用 对于加五步面板 不可以直接关闭 隐藏即可
	self.ui:setVisible(false)
end

function EndGamePropShowPanel:remove(animFinishCallback)
	assert(animFinishCallback == false or type(animFinishCallback) == "function")
	FreeFCashPanel:hideWithOwnerCheck(self)

	if self.timeLimitPanel then 
		self.timeLimitPanel:setVisible(false)
	end

	self.panelPopRemoveAnim:remove(animFinishCallback)
end

function EndGamePropShowPanel:setOnUseTappedCallback(onUseCallback)
	assert(type(onUseCallback) == "function")

	self.onUseTappedCallback = onUseCallback
end

function EndGamePropShowPanel:setOnCancelTappedCallback(onCancelCallback)
	assert(type(onCancelCallback) == "function")
	self.onCancelTappedCallback = onCancelCallback
end

function EndGamePropShowPanel:addPropUseAnimation(pos, onAnimFinishedCallback )
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

function EndGamePropShowPanel:onEnterForeGround()
	if self.isDisposed then return end
	if self.buyLogic and self.buyLogic.paymentType and self.buyLogic.paymentType == Payments.WECHAT then
		self.buyLogic = nil
		if self.onEnterForeGroundCallback then 
			local function localCallback()
				if self.ui:isVisible() and not PaymentManager.getInstance():getIsCheckingPayResult() then 
					if not self.isDisposed and self.onEnterForeGroundCallback then 
						self.onEnterForeGroundCallback()
					end
				else
					self.onEnterForeGroundCallback = nil
				end
			end
			self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3), CCCallFunc:create(localCallback)))
		end
	else
		self.onEnterForeGroundCallback = nil
	end
end