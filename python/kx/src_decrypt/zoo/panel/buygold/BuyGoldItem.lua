require 'zoo.util.OpenUrlUtil'

BuyGoldItem = class(ItemInClippingNode)

function BuyGoldItem:create(itemData, boughtCallback)
	local instance = BuyGoldItem.new()
	instance:loadRequiredResource(PanelConfigFiles.buy_gold_items)
	instance:init(itemData, boughtCallback)
	return instance
end

function BuyGoldItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function BuyGoldItem:setGoldIconVisiable(index)
	if self.content and type(index) == "number" then
		local icon = self.content:getChildByName("ItemGold"..index)
		if icon then 
			icon:setVisible(true)
		end
	-- 	for i=1,5 do
	-- 		self.content:getChildByName("ItemGold"..i):setVisible(index == i)
	-- 	end
	end
end

function BuyGoldItem:init(itemData, boughtCallback)
	ItemInClippingNode.init(self)
	local ui = self.builder:buildGroup("NewBuyGoldItem")
	self:setContent(ui)

	self.itemData = itemData
	self.buyLogic = BuyGoldLogic:create();
	self.buyLogic:getMeta();
	self.boughtCallback = boughtCallback;

	local extraCash = itemData.extraCash or 0;
	local label, size = ui:getChildByName("goldNum"), ui:getChildByName("goldNum_size")
	label = TextField:createWithUIAdjustment(size, label)
	label:setString(itemData.cash - extraCash)
	ui:addChild(label)

	for _,v in pairs(ui:getChildrenList()) do
		if v.name and string.starts(v.name,"ItemGold") then 
			v:setVisible(false)
		end
	end

	local iconExtra = ui:getChildByName("extraIcon");
	local iconExtra2 = ui:getChildByName("extraIcon2")
	

	if __IOS and (itemData.id == 8 or itemData.id == 9) then 
		iconExtra:setVisible(false)
		iconExtra2:setVisible(true)
	else
		iconExtra2:setVisible(false)
		iconExtra:setVisible(extraCash > 0);
		local discountText = iconExtra:getChildByName("extraNum");
		iconExtra:getChildByName("extraNum"):setDimensions(CCSizeMake(0, 0))
		discountText:setString(tostring(extraCash))

		-- local giveText = iconExtra:getChildByName("giveText");
		-- giveText:setString(Localization:getInstance():getText("buy.gold.panel.give"));
	end

	local btn = ui:getChildByName("button");
	local currencySymbol = Localization:getInstance():getText("buy.gold.panel.money.mark") -- 货币符号
	btn = GroupButtonBase:create(btn)
	btn:setColorMode(kGroupButtonColorMode.blue);
	self.procClick = true
	btn:setString(string.format("%s%0.2f", currencySymbol, itemData.iapPrice))
	self.btnBuy = btn;

	self.btnBuy.setEnabled = function(_self, value)
		_self.groupNode._isEnabled = (value == true)
		_self:setEnabledForColorOnly(value)
	end

	-- 必须要使用原有的hitTestPoint而不是CocosObject的这个函数
	-- 因为要使用ItemInClippingNode的特性：不会在clipping外面点击到
	local oldFunc = self.btnBuy.groupNode.hitTestPoint
	self.btnBuy.groupNode.hitTestPoint = function (_self, worldPosition, useGroupTest)
		if _self._isEnabled == false then
			return false
		else
			return oldFunc(_self, worldPosition, useGroupTest)
		end
	end

	local function onBuyTapped(evt) 
		self:buyGold(evt.context) 
	end
	btn:addEventListener(DisplayEvents.kTouchTap, onBuyTapped, {index = itemData.id, data = itemData})
end

function BuyGoldItem:disableClick()
	self.procClick = false
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
end

function BuyGoldItem:enableClick()
	self.procClick = true
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
end

function BuyGoldItem:buyGold(context)
	local function onOver()
		--nothing todo;
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		PlatformConfig:setCurrentPayType()
	end
	local function onCancel()
		if self.itemData.payType == PlatformPayType.kWechat then
			DcUtil:successEnterWechatBuyGoldItem(context.index)
		end
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		PlatformConfig:setCurrentPayType()
	end
	local function onFail()
		if self.itemData.payType == PlatformPayType.kWechat then
			DcUtil:successEnterWechatBuyGoldItem(context.index)
		end
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		PlatformConfig:setCurrentPayType()
	end
	local function onSuccess()
		if self.itemData.payType == PlatformPayType.kWechat then
			DcUtil:successEnterWechatBuyGoldItem(context.index)
		elseif self.itemData.payType == PlatformPayType.kAlipay then
			DcUtil:successfulBuyCashByAlipay(context.index)
		end
		local scene = HomeScene:sharedInstance()
		local button
		if scene then button = scene.goldButton end
		if button then button:updateView() end
		if self.boughtCallback then self.boughtCallback(self.itemData.payType) end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.success"), "positive", onOver)
	end

	if __IOS then -- IOS
		self.btnBuy:setEnabled(false)
		local function startBuyLogic()
			if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
			self.buyLogic:buy(context.index, context.data, onSuccess, onFail, onCancel)
		end
		local function onFailLogin()
			self.btnBuy:setEnabled(true)
		end
		RequireNetworkAlert:callFuncWithLogged(startBuyLogic, onFailLogin)
	else -- on ANDROID and PC we don't need to check for network
		PlatformConfig:setCurrentPayType(self.itemData.payType)
		if self.itemData.payType == PlatformPayType.kWechat then
			DcUtil:clickWechatBuyGoldItem(context.index)
			local function enableButton()
				if not self.isDisposed then
					if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
				end
			end
			setTimeOut(enableButton, 3)
		elseif self.itemData.payType == PlatformPayType.kAlipay then
			DcUtil:clickAlipayBuyGoldItem(context.index)
		end
		if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
		self.buyLogic:buy(context.index, context.data, onSuccess, onFail, onCancel)
	end
end

function BuyGoldItem:update()

end

FreeGoldItem = class(ItemInClippingNode);

function FreeGoldItem:create()
	local instance = FreeGoldItem.new()
	instance:loadRequiredResource(PanelConfigFiles.buy_gold_items)
	instance:init()
	return instance
end

function FreeGoldItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function FreeGoldItem:init()
	ItemInClippingNode.init(self)
	local ui = self.builder:buildGroup("NewFreeGoldItem")
	self:setContent(ui);

	local btn = ui:getChildByName("button");
	btn = GroupButtonBase:create(btn)
	btn:setColorMode(kGroupButtonColorMode.green);
	btn:setString(Localization:getInstance():getText("buy.gold.panel.btn.free.text"));

	--change the item background color
	local itemBG = ui:getChildByName("bg");
	itemBG:adjustColor( 27/255, 0, 0, 0 );
	itemBG:applyAdjustColorShader();

	local function popoutPanel()
		local panel = FreeCashTaskPanel:create()
		panel:popout()
	end

	local function onBuyTapped(evt) 
		RequireNetworkAlert:callFuncWithLogged(popoutPanel)
	end
	btn:addEventListener(DisplayEvents.kTouchTap, onBuyTapped, self);
end


ThirdPayLinkItem = class(ItemInClippingNode)
function ThirdPayLinkItem:create(txt, linkAddr, clickCallback)
	local instance = ThirdPayLinkItem.new()
	instance:loadRequiredResource(PanelConfigFiles.buy_gold_items)
	instance:init(txt, linkAddr, clickCallback)
	return instance
end

function ThirdPayLinkItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function ThirdPayLinkItem:init(txt, linkAddr, clickCallback)
	ItemInClippingNode.init(self)
	local ui = self.builder:buildGroup("thirdPartyLinkItem")
	self:setContent(ui)

	self.btn = ui:getChildByName('btn')
	self.btn:setButtonMode(true)
	self.btnTxt = self.btn:getChildByName('txt')

	ui:getChildByName('bg'):setVisible(false)

	-- self.btnTxt:setString(txt)

	local function onBtnTapped(evt) 
		OpenUrlUtil:openUrl(linkAddr)
		if clickCallback then
			clickCallback()
		end
	end
	self.btn:addEventListener(DisplayEvents.kTouchTap, onBtnTapped)
end

function ThirdPayLinkItem:disableClick()
	self.procClick = false
	if not self.btn.isDisposed then self.btn:setTouchEnabled(false) end
end

function ThirdPayLinkItem:enableClick()
	self.procClick = true
	if not self.btn.isDisposed then self.btn:setTouchEnabled(true) end
end


DiscountBuyGoldItem = class(ItemInClippingNode)
function DiscountBuyGoldItem:create(countdownTime, buyNum, giveNumber, goodsId, payment, buySuccessCallback)
	local instance = DiscountBuyGoldItem.new()
	instance:loadRequiredResource(PanelConfigFiles.buy_gold_items)
	instance:init(countdownTime, buyNum, giveNumber, goodsId, payment, buySuccessCallback)
	return instance
end

function DiscountBuyGoldItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function DiscountBuyGoldItem:init(countdownTime, buyNum, giveNumber, goodsId, payment, buySuccessCallback)
	ItemInClippingNode.init(self)
	local ui = self.builder:buildGroup("DiscountBuyGoldItem")
	self:setContent(ui)
	self.countdown = ui:getChildByName('countdown')
	self.buyNum = ui:getChildByName('buyNum')
	self.buyNum_size = ui:getChildByName('buyNum_size')
	self.giveNum = ui:getChildByName('giveNum')
	self.giveNum_size = ui:getChildByName('giveNum_size')
	self.btnBuy = GroupButtonBase:create(ui:getChildByName('btn'))
	self.desc = ui:getChildByName('desc')

	local buyNumLabel = TextField:createWithUIAdjustment(self.buyNum_size, self.buyNum)
	buyNumLabel:setString(buyNum)
	ui:addChild(buyNumLabel)

	local giveNumLabel = TextField:createWithUIAdjustment(self.giveNum_size, self.giveNum)
	giveNumLabel:setString(giveNumber)
	ui:addChild(giveNumLabel)

	self.goodsId = goodsId
	local meta = MetaManager:getInstance():getProductAndroidMeta(goodsId)
	local price = tonumber(meta.rmb) / 100

	self.btnBuy:setString(string.format("%s%0.2f", localize('buy.gold.panel.money.mark'), price))
	self.btnBuy:setColorMode(kGroupButtonColorMode.orange)
	self.btnBuy:ad(DisplayEvents.kTouchTap, function () self:onBuyBtnTapped() end)
	self.desc:setString(localize('market.panel.buy.gold.text.1'))

	self.payment = payment

	self.buyLogic = BuyGoldLogic:create();
	self.buyLogic:getMeta();

	self.buySuccessCallback = buySuccessCallback

	if countdownTime > 0 then
		self:startTimer(countdownTime)
	end
end

function DiscountBuyGoldItem:onBuyBtnTapped()

	if PaymentManager:getInstance():getHasFirstThirdPay() then -- 防止重复购买
		return 
	end

	local function onCancel()
		print('DiscountBuyGoldItem onCancel')
		if self.isDisposed then return end
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		PlatformConfig:setCurrentPayType()
	end
	local function onFail()
		print('DiscountBuyGoldItem onFail')
		if self.isDisposed then return end
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		PlatformConfig:setCurrentPayType()
	end
	local function onSuccess()
		print('DiscountBuyGoldItem onSuccess')
		if self.isDisposed then return end
		local scene = HomeScene:sharedInstance()
		local button
		if scene then button = scene.goldButton end
		if button then button:updateView() end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.success"), "positive")
		if self.buySuccessCallback then
			self.buySuccessCallback()
		end
	end
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
	if self.payment == Payments.WECHAT then
		PlatformConfig:setCurrentPayType(PlatformPayType.kWechat)
		local function enableButton()
			if not self.isDisposed then
				if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
			end
		end
		setTimeOut(enableButton, 3)
	elseif self.payment == Payments.ALIPAY then
		PlatformConfig:setCurrentPayType(PlatformPayType.kAlipay)
	elseif self.payment == Payments.WDJ then
		PlatformConfig:setCurrentPayType(PlatformPayType.kWandoujia)
	elseif self.payment == Payments.QIHOO then
		PlatformConfig:setCurrentPayType(PlatformPayType.kQihoo)		
	else
		self.buyLogic:setIsThirdPayPromotion() -- 使用三方支付
	end
	self.buyLogic:buy(self.goodsId, nil, onSuccess, onFail, onCancel)
end

function DiscountBuyGoldItem:startTimer(countdownTime)
	local function onTick()
		if self.isDisposed then
			return
		end

		if self.countdownTime > 0 then
			self.countdown:setString(convertSecondToHHMMSSFormat(self.countdownTime))
			self.countdownTime = self.countdownTime - 1
		else
			if self.timer.started == true then
				self.countdown:setString(convertSecondToHHMMSSFormat(0))
				self.timer:stop()
				self:removeFromLayout()
			end
		end
	end
	self.countdownTime = countdownTime
	self.timer = OneSecondTimer:create()
	self.timer:setOneSecondCallback(onTick)
	self.timer:start()
	onTick()
end

function DiscountBuyGoldItem:removeFromLayout()
	if self.isDisposed then return end
	if self.parentView and not self.parentView.isDisposed then
		local layout = self.parentView.content
		if layout and not layout.isDisposed then
			layout:removeItemAt(self:getArrayIndex(), true)
		end
	end
end

function DiscountBuyGoldItem:disableClick()
	self.procClick = false
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
end

function DiscountBuyGoldItem:enableClick()
	self.procClick = true
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
end



IosOneYuanBuyGoldItem = class(ItemInClippingNode)
function IosOneYuanBuyGoldItem:create(itemData, countdownTime, buySuccessCallback)
	local instance = IosOneYuanBuyGoldItem.new()
	instance:loadRequiredResource(PanelConfigFiles.buy_gold_items)
	instance:init(itemData, countdownTime, buySuccessCallback)
	return instance
end

function IosOneYuanBuyGoldItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function IosOneYuanBuyGoldItem:init(itemData, countdownTime, buySuccessCallback)
	ItemInClippingNode.init(self)
	local ui = self.builder:buildGroup("IosOneYuanBuyGoldItem")
	self:setContent(ui)
	self.countdown = ui:getChildByName('countdown')
	self.buyNum = ui:getChildByName('buyNum')
	self.buyNum_size = ui:getChildByName('buyNum_size')
	self.btnBuy = GroupButtonBase:create(ui:getChildByName('btn'))


	ui:getChildByName('hit_bg'):setVisible(false)

	self.text = ui:getChildByName('text')
	self.text:setString(localize('ios.tuiguang.desc1'))

	self.itemData = itemData
	self.buyLogic = BuyGoldLogic:create();
	self.buyLogic:getMeta();
	self.procClick = true

	local buyNumLabel = TextField:createWithUIAdjustment(self.buyNum_size, self.buyNum)
	buyNumLabel:setString(itemData.cash)
	ui:addChild(buyNumLabel)

	self.goodsId = goodsId

	local function onBuyTapped(evt) 
		self:buyGold(evt.context) 
	end
	self.btnBuy:setString(string.format("%s%0.2f", localize('buy.gold.panel.money.mark'), itemData.iapPrice))
	self.btnBuy:setColorMode(kGroupButtonColorMode.orange)
	self.btnBuy:ad(DisplayEvents.kTouchTap, onBuyTapped, {index = itemData.id, data = itemData})


	self.buySuccessCallback = buySuccessCallback

	if countdownTime > 0 then
		self:startTimer(countdownTime)
	end
end

function IosOneYuanBuyGoldItem:buyGold(context)
	local function onOver()
		--nothing todo;
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		PlatformConfig:setCurrentPayType()
	end
	local function onCancel()
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		PlatformConfig:setCurrentPayType()
	end
	local function onFail()
		if self.procClick and not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		PlatformConfig:setCurrentPayType()
	end
	local function onSuccess()
		local scene = HomeScene:sharedInstance()
		local button
		if scene then button = scene.goldButton end
		if button then button:updateView() end
		if self.buySuccessCallback then self.buySuccessCallback() end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.success"), "positive", onOver)
	end

	if __IOS then -- IOS
		self.btnBuy:setEnabled(false)
		local function startBuyLogic()
			if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
			self.buyLogic:buy(context.index, context.data, onSuccess, onFail, onCancel)
		end
		local function onFailLogin()
			self.btnBuy:setEnabled(true)
		end
		RequireNetworkAlert:callFuncWithLogged(startBuyLogic, onFailLogin)
	else -- on ANDROID and PC we don't need to check for network
		onSuccess()
	end
end

function IosOneYuanBuyGoldItem:startTimer(countdownTime)
	local function onTick()
		if self.isDisposed then
			return
		end

		if self.countdownTime > 0 then
			self.countdown:setString(convertSecondToHHMMSSFormat(self.countdownTime))
			self.countdownTime = self.countdownTime - 1
		else
			if self.timer.started == true then
				self.countdown:setString(convertSecondToHHMMSSFormat(0))
				self.timer:stop()
				self:removeFromLayout()
			end
		end
	end
	self.countdownTime = countdownTime
	self.timer = OneSecondTimer:create()
	self.timer:setOneSecondCallback(onTick)
	self.timer:start()
	onTick()
end

function IosOneYuanBuyGoldItem:removeFromLayout()
	if self.isDisposed then return end
	if self.parentView and not self.parentView.isDisposed then
		local layout = self.parentView.content
		if layout and not layout.isDisposed then
			layout:removeItemAt(self:getArrayIndex(), true)
		end
	end
end

function IosOneYuanBuyGoldItem:disableClick()
	self.procClick = false
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(false) end
end

function IosOneYuanBuyGoldItem:enableClick()
	self.procClick = true
	if not self.btnBuy.isDisposed then self.btnBuy:setEnabled(true) end
end