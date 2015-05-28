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
		discountText:setString(tostring(extraCash))

		local giveText = iconExtra:getChildByName("giveText");
		giveText:setString(Localization:getInstance():getText("buy.gold.panel.give"));
	end

	local btn = ui:getChildByName("button");
	local currencySymbol = Localization:getInstance():getText("buy.gold.panel.money.mark") -- 货币符号
	btn = GroupButtonBase:create(btn)
	btn:setColorMode(kGroupButtonColorMode.blue);
	self.procClick = true
	btn:setString(string.format("%s%0.2f", currencySymbol, itemData.iapPrice))
	self.btnBuy = btn;

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
		if self.boughtCallback then self.boughtCallback() end
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

