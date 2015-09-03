require "zoo.panel.basePanel.BasePanel"

FirstRmbBuyPanel = class(BasePanel)

function FirstRmbBuyPanel:create(goodsId, uniquePayId, parentPanel, peDispatcher, otherPaymentTable, maxTopPosYInWorldSpace, onTouchBtnCallback)
	local panel = FirstRmbBuyPanel.new()
	panel.goodsId = goodsId
	panel.uniquePayId = uniquePayId
	panel.parentPanel = parentPanel
	panel.peDispatcher = peDispatcher
	panel.otherPaymentTable = otherPaymentTable
	panel.maxTopPosYInWorldSpace = maxTopPosYInWorldSpace
	panel.onTouchBtnCallback = onTouchBtnCallback
	panel:loadRequiredResource(PanelConfigFiles.panel_energy_bubble)
	panel:init()

	return panel
end

function FirstRmbBuyPanel:init()
	self.paySuccess = false
	self.failBeforePayEnd = false

	self.promotionConfig = ThirdPayPromotionConfig[self.goodsId]
	self.itemId = self.promotionConfig.itemId
	self.goodsMeta = MetaManager:getInstance():getGoodMeta(self.goodsId + 5000)
	self.discountGoodsId = self.goodsId + 5000

	self.ui	= self:buildInterfaceGroup("IapBuyMidEnergyPanel")
	BasePanel.init(self, self.ui)
	self:scaleAccordingToResolutionConfig()

	local icon = self.ui:getChildByName("icon")
	local text = self.ui:getChildByName("text")
	local button = ButtonNumberBase:create(self.ui:getChildByName("button"))
	local gold = self.ui:getChildByName("gold")
	local charge = self.ui:getChildByName("charge")
	local chargeLine = self.ui:getChildByName("chargeline")
	local discount = self.ui:getChildByName("discount")
	local animalPic = Sprite:createWithSpriteFrameName("npc_small_10000")
	self.button = button
	self.animalPic = animalPic

	local builder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local sprite = builder:buildGroup("Prop_"..self.itemId)
	local sBound = sprite:getGroupBounds().size
	sBound = {width = sBound.width, height = sBound.height}
	local rBound = icon:getGroupBounds().size
	local scale = rBound.width / sBound.width
	if rBound.height / sBound.height < scale then
		scale = rBound.height / sBound.height
	end
	sprite:setScale(scale)
	sprite:setPositionX(icon:getPositionX() + (rBound.width - sBound.width * scale) / 2)
	sprite:setPositionY(icon:getPositionY() - (rBound.height - sBound.height * scale) / 2)
	self.ui:addChild(sprite)
	icon:removeFromParentAndCleanup(true)
	gold:removeFromParentAndCleanup(true)

	charge:setDimensions(CCSizeMake(0, 0))
	charge:setPositionX(charge:getPositionX() - 16)
	charge:setPositionY(charge:getPositionY() - 15)

	charge:setString(string.format("%s%0.0f", Localization:getInstance():getText("buy.gold.panel.money.mark"), self.goodsMeta.rmb / 100))
	local tBound = charge:getContentSize()
	local lBound = chargeLine:getContentSize()
	chargeLine:setPositionXY(charge:getPositionX(), charge:getPositionY())
	chargeLine:setScaleX(tBound.width / lBound.width)
	chargeLine:setScaleY(tBound.height / lBound.height)

	local goodsName = Localization:getInstance():getText("goods.name.text"..self.discountGoodsId)
	text:setString("您获得了"..goodsName.."购买机会！")

	button:setColorMode(kGroupButtonColorMode.blue)
	button:setNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), self.goodsMeta.thirdRmb / 100))
	button:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))
	button.label:setPositionX(button.label:getPositionX() + 25)

	local disNum = discount:getChildByName("num")
	local disText = discount:getChildByName("text")
	disNum:setString(self.promotionConfig.discount)
	disText:setString(Localization:getInstance():getText("buy.gold.panel.discount"))
	local scaleBase = discount:getScale()
	local actArray = CCArray:create()
	actArray:addObject(CCDelayTime:create(5))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 0.95))
	actArray:addObject(CCScaleTo:create(0.1, scaleBase * 1.1))
	actArray:addObject(CCScaleTo:create(0.2, scaleBase * 1))
	discount:runAction(CCRepeatForever:create(CCSequence:create(actArray)))

	self.animalPic:setAnchorPoint(ccp(0, 1))
	-- self.animalPic:setScale(1 / self:getScale())
	self:addChild(self.animalPic)

	local function onBuy()
		self:onBuyButtonTap()
	end
	button:addEventListener(DisplayEvents.kTouchTap, onBuy)

	self.peDispatcher:addEventListener(PaymentEvents.kBuyConfirmPanelClose, function ()
		self:remove()
	end)
end

function FirstRmbBuyPanel:popout()
	PopoutManager:sharedInstance():add(self, false, true)

	local paymentType = PaymentManager.getInstance():getDefaultPayment()
	local alterListForDC =  PaymentDCUtil.getInstance():getAlterPaymentList(self.otherPaymentTable)
	PaymentDCUtil.getInstance():sendPayChoosePop(paymentType, alterListForDC, self.uniquePayId, 1)

	-- if self.animalPic then
	-- 	print("self position", self:getPositionX(), self:getPositionY())
	-- 	print("animal position", self.animalPic:getPositionX(), self.animalPic:getPositionY())
	-- end
	self:_playFadeInAnim()
	self:_calcPosition()
end

function FirstRmbBuyPanel:remove()
	local function onAnimFinished()
		if self and not self.isDisposed then
			PopoutManager:sharedInstance():remove(self)
		end
	end

	self.button:setEnabled(false)
	self:_playFadeOutAnim(onAnimFinished)
end

function FirstRmbBuyPanel:_calcPosition()
	local selfSize = self:getGroupBounds().size
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local deltaWidth = vSize.width - selfSize.width
	local selfParent = self:getParent()

	print("selfParent", selfParent)
	if selfParent and self.maxTopPosYInWorldSpace then
		local pos = selfParent:convertToNodeSpace(ccp(vOrigin.x + deltaWidth / 2, self.maxTopPosYInWorldSpace))
		local manualAdjustPosY = 140
		self:setPosition(ccp(pos.x, pos.y + manualAdjustPosY))
	end

	if self.animalPic then
		local animalParent 	= self.animalPic:getParent()
		local animalPicSize	= self.animalPic:getGroupBounds().size
		local pos = animalParent:convertToNodeSpace(ccp(vOrigin.x, vOrigin.y + animalPicSize.height))

		self.animalPic:setPosition(ccp(pos.x, pos.y))
	end
	
end

function FirstRmbBuyPanel:_playFadeInAnim()
	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	local fadeInTime = 0.3

	for k,v in pairs(visibleChildren) do
		local fadeInAction = CCFadeIn:create(fadeInTime)
		v:runAction(fadeInAction)
	end
	local function onFinish() self.allowBackKeyTap = true end
	self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(fadeInTime), CCCallFunc:create(onFinish)))
end

function FirstRmbBuyPanel:_playFadeOutAnim(animFinishCallback)
	local visibleChildren = {}
	self:getVisibleChildrenList(visibleChildren)

	local fadeOutTime	= 0.3

	self.allowBackKeyTap = false
	local spawnActionArray = CCArray:create()
	for k,v in pairs(visibleChildren) do
		local fadeOutAction 	= CCFadeOut:create(fadeOutTime)
		local targetAction	= CCTargetedAction:create(v.refCocosObj, fadeOutAction)
		spawnActionArray:addObject(targetAction)
	end
	local spawn = CCSpawn:create(spawnActionArray)

	local function animFinishedFunc()
		if animFinishCallback then
			animFinishCallback()
		end
	end
	local animFinishedAction = CCCallFunc:create(animFinishedFunc)

	local actionArray = CCArray:create()
	actionArray:addObject(spawn)
	actionArray:addObject(animFinishedAction)

	local seq = CCSequence:create(actionArray)
	self:runAction(seq)
end

function FirstRmbBuyPanel:onBuyButtonTap()
	if self.onTouchBtnCallback then 
		self.onTouchBtnCallback()
	end
	local paymentType = PaymentManager.getInstance():getDefaultPayment()
	local alterListForDC =  PaymentDCUtil.getInstance():getAlterPaymentList(self.otherPaymentTable)

	self.button:setEnabled(false)
	if self.parentPanel and self.parentPanel.setBuyBtnEnabled then 
		self.parentPanel.setBuyBtnEnabled(self.parentPanel, false)
	end
	if #self.otherPaymentTable == 1 then 
		if self.peDispatcher then 
			self.peDispatcher:dispatchChoosenTypeEvent(self.discountGoodsId, self.otherPaymentTable[1], paymentType, 0)
			local function rebecomeEnable()
				if not self.isDisposed and self.button and not self.button.isDisposed then 
					self.button:setEnabled(true)
				end
				if self.parentPanel and self.parentPanel.setBuyBtnEnabled then 
					self.parentPanel.setBuyBtnEnabled(self.parentPanel, true)
				end
			end
			setTimeOut(rebecomeEnable, 1)
			PaymentDCUtil.getInstance():sendPayChoose(paymentType, alterListForDC, self.otherPaymentTable[1], self.uniquePayId, 1)
		end
	else
		local supportedPayments = {}
		for i,v in ipairs(self.otherPaymentTable) do
			supportedPayments[v] = true
		end

		local panel = ChoosePaymentPanel:create(supportedPayments,"选择您希望的支付方式:", true, self.discountGoodsId)
		local function onChoosen(choosenType)
			if self.peDispatcher then 
				self.peDispatcher:dispatchChoosenTypeEvent(self.discountGoodsId, choosenType, paymentType, 0)
			end
			if choosenType then 
				PaymentDCUtil.getInstance():sendPayChoose(paymentType, alterListForDC, choosenType, self.uniquePayId, 1)
			else
				PaymentDCUtil.getInstance():sendPayChoose(paymentType, alterListForDC, 0, self.uniquePayId, 1)
			end
			local function rebecomeEnable()
				if not self.isDisposed and self.button and not self.button.isDisposed then 
					self.button:setEnabled(true)
				end
				if self.parentPanel and self.parentPanel.setBuyBtnEnabled then 
					self.parentPanel.setBuyBtnEnabled(self.parentPanel, true)
				end
			end
			setTimeOut(rebecomeEnable, 1)
		end
		if panel then panel:popout(onChoosen) end
	end
end