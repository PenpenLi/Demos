
local PayItem = class(BaseUI)
function PayItem:ctor()
	
end

function PayItem:init()
	BaseUI.init(self, self.ui)

	local btnShowConfig = PaymentManager.getInstance():getPaymentShowConfig(self.paymentType)
	--按钮
	self.buyBtnUI = self.ui:getChildByName("buyBtn")
	self.buyButton = ButtonIconsetBase:create(self.buyBtnUI)
	
	local goodsId = self.goodsIdInfo:getGoodsId()
	local goodsType = self.goodsIdInfo:getGoodsType()
	if PaymentManager.getInstance():checkIsNoThirdPayPromotion(self.paymentType) then 
		--短代不能买一元特价的道具
		goodsId = self.goodsIdInfo:getOriginalGoodsId()
	end
	local price = PaymentManager:getPriceByPaymentType(goodsId, goodsType, self.paymentType)
	local formatPrice = string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), price)
	local buyLabel = Localization:getInstance():getText("add.step.panel.buy.btn.txt")
	self.buyButton:setString(formatPrice..buyLabel)
	if not self.isFirst then 
		self.buyButton:setColorMode(kGroupButtonColorMode.blue)
	end
	self.buyButton:setIconByFrameName(btnShowConfig.smallIcon)
	self.buyButton:addEventListener(DisplayEvents.kTouchTap,  function ()
			self:onBuyBtnTap()
		end)

	self:createBtnAnimation()

	--支付名称
	local payNameUI = self.ui:getChildByName("payName")
	payNameUI:setString(btnShowConfig.name)

	--支付大图标
	local payIconPosUI = self.ui:getChildByName("payIconPos")
	payIconPosUI:setOpacity(0)
	local payIconBig = Sprite:createWithSpriteFrameName(btnShowConfig.bigIcon)
	payIconBig:setAnchorPoint(ccp(0, 1))
	payIconPosUI:addChild(payIconBig)

	--打折显示
	local discountUI = self.ui:getChildByName("discount")
	local discountNum = self.goodsIdInfo:getDiscountNum()
	if goodsId == 33 or goodsId == 47 then 
		discountNum = 7
	else
		if PaymentManager.getInstance():checkIsNoThirdPayPromotion(self.paymentType) or discountNum == 10 then 
			discountUI:setVisible(false)
			return
		end
	end
	PayPanelDiscountUI:create(discountUI, discountNum) 
end

function PayItem:onBuyBtnTap()
	if self.btnTapCallback then 
		self.btnTapCallback(self.paymentType)
	end
end

function PayItem:setBtnEnabled(isEnable)
	if self.buyButton and not self.buyButton.isDisposed then 
		self.buyButton:setEnabled(isEnable)
	end
end

function PayItem:createBtnAnimation()
	local oriScaleX = self.buyBtnUI:getScaleX()
	local oriScaleY = self.buyBtnUI:getScaleY() 
	local deltaTime = 0.9
	local animations = CCArray:create()
	animations:addObject(CCScaleTo:create(deltaTime, 0.98*oriScaleX, 1.03*oriScaleY))
	animations:addObject(CCScaleTo:create(deltaTime, 1.01*oriScaleX, 0.96*oriScaleY))
	animations:addObject(CCScaleTo:create(deltaTime, 0.98*oriScaleX,1.03*oriScaleY))
	animations:addObject(CCScaleTo:create(deltaTime, oriScaleX, oriScaleY))
	self.buyBtnUI:runAction(CCRepeatForever:create(CCSequence:create(animations)))

	local backgroundUI = self.buyBtnUI:getChildByName("background")
	local function __onButtonTouchBegin( evt )
		if backgroundUI and not backgroundUI.isDisposed then
			backgroundUI:setOpacity(200)
		end
	end
	local function __onButtonTouchEnd( evt )
		if backgroundUI and not backgroundUI.isDisposed then
			backgroundUI:setOpacity(255)
		end
	end
	self.buyBtnUI:addEventListener(DisplayEvents.kTouchBegin, __onButtonTouchBegin)
	self.buyBtnUI:addEventListener(DisplayEvents.kTouchEnd, __onButtonTouchEnd)
end

function PayItem:create(ui, paymentType, goodsIdInfo, btnTapCallback, isFirst)
	local item = PayItem.new()
	item.ui = ui
	item.paymentType = paymentType
	item.goodsIdInfo = goodsIdInfo
	item.btnTapCallback = btnTapCallback
	item.isFirst = isFirst
	item:init()
	return item
end

-------------------------------------
PayPanelRePay = class(BasePanel)

function PayPanelRePay:ctor()
	self.payItemTable = {}
end

local function getRealOriGoodsId(oriGoodsId)
	local realOriGoodsId = oriGoodsId 
	if oriGoodsId == 33 then --这里是加五步面板打折道具的特殊处理 打折道具的名字这里不可以带打折。产品需求。
		realOriGoodsId = 24
	elseif oriGoodsId == 47 then 
		realOriGoodsId = 46
	elseif oriGoodsId == 148 then 
		realOriGoodsId = 147
	end

	return realOriGoodsId
end

function PayPanelRePay:init()
	self.ui	= self:buildInterfaceGroup("PayPanelRePay")
	BasePanel.init(self, self.ui)

	--重新排列下支付方式的显示
	self:reorderPaymentTable()

	local goodsIdForName = getRealOriGoodsId(self.goodsIdInfo:getOriginalGoodsId())
	self.goodsName = Localization:getInstance():getText("goods.name.text"..tostring(goodsIdForName))

	self:initTitlePart()
	self:initItemBubble()
	self:initNpc()
	self:initPayItem()
end

function PayPanelRePay:reorderPaymentTable()
	local firstPaymentType = self.paymentTable[1]
	local lastPaymentIndex = nil
	--记录上次支付的支付方式在重买支付方式列表中的位置
	for i,v in ipairs(self.paymentTable) do
		if v == self.lastPaymentType then 
			lastPaymentIndex = i
			break
		end
	end

	--如果重买支付方式列表中的第一种支付方式是短代
	if PaymentManager:checkPaymentTypeIsSms(firstPaymentType) then 
		--上次支付的支付方式也是短代
		if PaymentManager:checkPaymentTypeIsSms(self.lastPaymentType) then 
			--排序为：短代 优先三方 其它三方
			local defaultThirdPaymentType = PaymentManager.getInstance():getDefaultThirdPartPayment()
			local defaultPaymentIndex = nil 
			for i,v in ipairs(self.paymentTable) do
				if v == defaultThirdPaymentType then 
					defaultPaymentIndex = i
					break
				end
			end
			if defaultPaymentIndex then 
				table.remove(self.paymentTable, defaultPaymentIndex)
				table.insert(self.paymentTable, 2, defaultThirdPaymentType)
			end
		else
			--如果上次支付的支付方式为三方且在重买支付方式列表中 
			if lastPaymentIndex then 
				--排序为：短代 上次三方 其它三方
				table.remove(self.paymentTable, lastPaymentIndex)
				table.insert(self.paymentTable, 2, self.lastPaymentType)
			end
		end
	else
		--重买支付方式列表中的第一种为三方且不是上次支付的支付方式且上次支付的支付方式不是短代
		if self.lastPaymentType ~= firstPaymentType and not PaymentManager:checkPaymentTypeIsSms(self.lastPaymentType) then
			--如果上次支付的支付方式为三方且在重买支付方式列表中 
			--排序为：上次三方 其它三方 短代
			if lastPaymentIndex then 
				table.remove(self.paymentTable, lastPaymentIndex)
			end
			table.insert(self.paymentTable, 1, self.lastPaymentType)
		end
	end
end

function PayPanelRePay:initTitlePart()
	local panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(panelTitle)
	panelTitle:setString("重新购买 "..self.goodsName)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
		self:onCloseBtnTap()
	end)
end

function PayPanelRePay:onCloseBtnTap()
	if self.peDispatcher then 
		self.peDispatcher:dispatchPanelCloseEvent()
	end
	self:removePopout()	
end

function PayPanelRePay:initItemBubble()
	local upPartUI = self.ui:getChildByName("upPart")
	local goodsId = getRealOriGoodsId(self.goodsIdInfo:getOriginalGoodsId())
	local goodsType = self.goodsIdInfo:getGoodsType()
	local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local itemIcon = nil
	if goodsType == 2 then -- 购买金币
		itemIcon = iconBuilder:buildGroup("Prop_14")
	elseif goodsType == 1 then
		if string.find(self.goodsName, "新区域解锁") then
			itemIcon = Sprite:createWithSpriteFrameName("buy_confirm_panel/cells/unlockIcon0000")
			itemIcon:setAnchorPoint(ccp(0,1))
		elseif string.find(self.goodsName, "签到礼包") then
			itemIcon = Sprite:createWithSpriteFrameName("buy_confirm_panel/cells/checkinIcon0000")
			itemIcon:setAnchorPoint(ccp(0,1))
		else
			if string.find(self.goodsName, "加5步") then
				goodsId = 4
			elseif string.find(self.goodsName, "追踪导弹") then
				goodsId = 45
			end
			itemIcon = iconBuilder:buildGroup('Goods_'..goodsId)
		end
	end

	local holder = upPartUI:getChildByName("icon")
	local holderIndex = upPartUI:getChildIndex(holder)
	local bSize = holder:getGroupBounds().size
	if itemIcon then 
		local iSize = itemIcon:getGroupBounds().size
		itemIcon:setPositionXY(holder:getPositionX() + (bSize.width - iSize.width) / 2, holder:getPositionY() - (bSize.height - iSize.height) / 2)
		upPartUI:addChildAt(itemIcon, holderIndex)
		self.itemIcon = itemIcon
	end
	holder:removeFromParentAndCleanup(true)

	local priceLabelUI = upPartUI:getChildByName("price")
	local goodsInfoMeta = MetaManager:getInstance():getGoodMeta(goodsId)
	local oldPrice = goodsInfoMeta.rmb / 100
	local oldPricePre = Localization:getInstance():getText("payment_normal_price")
	local formatOldPrice = string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), oldPrice)
	priceLabelUI:setString(oldPricePre..formatOldPrice)
end

function PayPanelRePay:initNpc()
	local upPartUI = self.ui:getChildByName("upPart")
	self.tipLabel = upPartUI:getChildByName("tipLabel")
	self.tipLabel:setString(Localization:getInstance():getText("payment_repay_panel_desc"))
end

function PayPanelRePay:initPayItem()
	local payItemNum = #self.paymentTable
	if payItemNum > 4 then payItemNum = 4 end
	self.bg1 = self.ui:getChildByName("bg1")
	self.bg2 = self.ui:getChildByName("bg2")
	local bgSize1 = self.bg1:getGroupBounds().size
	local bgSize2 = self.bg2:getGroupBounds().size
	local payItemHeight = 137
	self.bg1:setPreferredSize(CCSizeMake(bgSize1.width, bgSize1.height - (4-payItemNum)*payItemHeight)) 
	self.bg2:setPreferredSize(CCSizeMake(bgSize2.width, bgSize2.height - (4-payItemNum)*payItemHeight)) 

	local function payItemBtnTap(paymentType)
		self:onRmbBuyBtnTap(paymentType)
	end

	for i=1,4 do
		local paymentType = self.paymentTable[i]
		local payItemUI = self.ui:getChildByName("payItem"..i)
		local isFirst = i == 1 and payItemNum ~= 1
		if paymentType then 
			local payItem = PayItem:create(payItemUI, paymentType, self.goodsIdInfo, payItemBtnTap, isFirst)
			table.insert(self.payItemTable, payItem)
		else
			payItemUI:setVisible(false)
		end
	end
end

function PayPanelRePay:onRmbBuyBtnTap(paymentType)
	local function rebecomeEnable()
		self:setBuyBtnEnabled(true)
	end

	self:setBuyBtnEnabled(false)
	if paymentType == Payments.WECHAT or paymentType == Payments.QQ_WALLET then 
		setTimeOut(rebecomeEnable, 3)		--这里是防止微信未登录没有回调的情况
	end

	if PaymentManager.getInstance():checkIsNoThirdPayPromotion(paymentType) then
		self.goodsIdInfo:setGoodsIdChange(GoodsIdChangeType.kNormal)
	end

	if self.peDispatcher then 
		self.peDispatcher:dispatchPanelPayEvent(paymentType)
	end
end

function PayPanelRePay:setBuyBtnEnabled(isEnable)
	if self.isDisposed or not self.paymentTable then return end
	for i,v in ipairs(self.payItemTable) do
		v:setBtnEnabled(isEnable)
	end
end

function PayPanelRePay:popout()
	PopoutManager:sharedInstance():add(self, true, false)

	self:_calcPosition()
end

function PayPanelRePay:_calcPosition()
	local selfSize = self:getGroupBounds().size
	local vOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local vSize = CCDirector:sharedDirector():getVisibleSize()

	if vSize.height / selfSize.height < 1.0 then
		self:setScale(vSize.height / selfSize.height)
	end
	selfSize = self:getGroupBounds().size

	local deltaWidth = vSize.width - selfSize.width
	local deltaHeight = vSize.height - selfSize.height
	local selfParent = self:getParent()

	if selfParent then
		local pos = selfParent:convertToNodeSpace(ccp(vOrigin.x + deltaWidth / 2, vOrigin.y + selfSize.height + deltaHeight / 2))
		self:setPosition(ccp(pos.x, pos.y))
	end
end

function PayPanelRePay:removePopout()
	PopoutManager:sharedInstance():remove(self)
end

function PayPanelRePay:getIconPos()
	if not self.isDisposed and self.itemIcon then 
		return self.itemIcon:convertToWorldSpace(ccp(0,0))
	end
end

function PayPanelRePay:create(peDispatcher, goodsIdInfo, lastPaymentType, paymentTable)
	local panel = PayPanelRePay.new()
	panel.peDispatcher = peDispatcher
	panel.goodsIdInfo = goodsIdInfo
	panel.lastPaymentType = lastPaymentType
	panel.paymentTable = paymentTable
	panel:loadRequiredResource("ui/BuyConfirmPanel.json")
	panel:init()
	return panel
end