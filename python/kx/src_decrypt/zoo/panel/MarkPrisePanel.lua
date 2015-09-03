require "zoo.panel.basePanel.BasePanel"
require "zoo.ui.ButtonBuilder"
require "zoo.data.MetaManager"

AndroidButtonNumberBase = class(GroupButtonBase)
function AndroidButtonNumberBase:create(buttonGroup)
	local button = AndroidButtonNumberBase.new(buttonGroup)
	button:buildUI()
	return button
end
function AndroidButtonNumberBase:buildUI()
	if not self.groupNode then return end

	GroupButtonBase.buildUI(self)
	local groupNode = self.groupNode
	local originNumberSize = groupNode:getChildByName("originSize")
	local originSize = originNumberSize:getContentSize()
	local originPosition = originNumberSize:getPosition()
	local originScaleX = originNumberSize:getScaleX()
	local originScaleY = originNumberSize:getScaleY()
	self.originNumberRect = {x = originPosition.x, y = originPosition.y, width = originSize.width *
		originScaleX, height = originSize.height * originScaleY}
	originNumberSize:removeFromParentAndCleanup(true)
	local discountNumberSize = groupNode:getChildByName("numberSize")
	local discountSize = discountNumberSize:getContentSize()
	local discountPosition = discountNumberSize:getPosition()
	local discountScaleX = discountNumberSize:getScaleX()
	local discountScaleY = discountNumberSize:getScaleY()
	self.discountNumberRect = {x = discountPosition.x, y = discountPosition.y, width = discountSize.width *
		discountScaleX, height = discountSize.height * discountScaleY}
	discountNumberSize:removeFromParentAndCleanup(true)

	self.originNumberLabel = groupNode:getChildByName("origin")
	self.discountNumberLabel = groupNode:getChildByName("number")
	self.originDelete = LayerColor:create()
	self.originDelete:setColor(ccc3(255, 0, 0))
	local index = self.groupNode:getChildIndex(self.originNumberLabel)
	self.groupNode:addChildAt(self.originDelete, index + 2)
end
function AndroidButtonNumberBase:setOriginNumber(str)
	local numberLabel = self.originNumberLabel
	if numberLabel and numberLabel.refCocosObj then
		numberLabel:setText(str)
		InterfaceBuilder:centerInterfaceInbox(numberLabel, self.originNumberRect)
		local size = numberLabel:getGroupBounds().size
		local x, y = numberLabel:getPositionX(), numberLabel:getPositionY()
		self.originDelete:changeWidthAndHeight(size.width, 3)
		self.originDelete:setPositionXY(x, y - size.height / 2 + 2)
	end
end
function AndroidButtonNumberBase:setDiscountNumber(str)
	local numberLabel = self.discountNumberLabel
	if numberLabel and numberLabel.refCocosObj then
		numberLabel:setText(str)
		InterfaceBuilder:centerInterfaceInbox(numberLabel, self.discountNumberRect)
	end
end

MarkPrisePanel = class(BasePanel)
function MarkPrisePanel:create(index)
	if type(index) ~= "number" then return nil end
	local panel = MarkPrisePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_mark_prise)
	if not panel:_init(index) then panel = nil end
	return panel
end

function MarkPrisePanel:_init(index)
	-- get data
	self.index = index
	local goodsId = MarkPrisePanelModel:getGoodsId(index)
	local items = MarkPrisePanelModel:getMarkPriseInfo(index)
	local price, discount = MarkPrisePanelModel:getPriceAndDiscount(index)
	local originPrice = MarkPrisePanelModel:getOriginalPrice(index)
	if type(items) ~= "table" or #items <= 0 then return false end
	if type(price) ~= "number" or type(discount) ~= "number" then return false end

	-- create panel
	self.ui = self:buildInterfaceGroup("MarkPrisePanel")
	BasePanel.init(self, self.ui)
	self:setPositionForPopoutManager()
	self:setPositionY(self:getPositionY() - 200)

	-- get & create control
	local title1 = self.ui:getChildByName("title_st1")
	local title2 = self.ui:getChildByName("title_st2")
	local dValue = self.ui:getChildByName("discount")
	local dBg = self.ui:getChildByName("discountBg")
	local itemArea = self.ui:getChildByName("itemArea")
	local buyBtn = self.ui:getChildByName("buyBtn")
	local androidBuyBtn = self.ui:getChildByName("androidBuyBtn")
	local closeBtn = self.ui:getChildByName("close")
	if __ANDROID  and not PaymentManager.getInstance():checkCanWindMillPay(goodsId) then
		self.buyBtn = AndroidButtonNumberBase:create(androidBuyBtn)
		buyBtn:removeFromParentAndCleanup(true)
	else
		self.buyBtn = ButtonIconNumberBase:create(buyBtn)
		androidBuyBtn:removeFromParentAndCleanup(true)
	end
	self.closeBtn = GroupButtonBase:create(closeBtn)
	self.items = {}
	local builder = InterfaceBuilder:create(PanelConfigFiles.properties)
	for k, v in ipairs(items) do
		local item = self:createItem(builder, v.itemId, v.num)
		self.ui:addChild(item)
		table.insert(self.items, item)
	end

	-- set states
	title1:setString(Localization:getInstance():getText("mark.prise.panel.title1"))
	title2:setString(Localization:getInstance():getText("mark.prise.panel.title2"))
	self.closeBtn:setString(Localization:getInstance():getText("mark.prise.panel.close.btn"))
	self.closeBtn:setColorMode(kGroupButtonColorMode.orange)

	if __ANDROID  and not PaymentManager.getInstance():checkCanWindMillPay(goodsId) then
		self.buyBtn:setString(Localization:getInstance():getText("mark.prise.panel.buy.btn"))
		self.buyBtn:setOriginNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), originPrice))
		self.buyBtn:setDiscountNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), price))
	else
		self.buyBtn:setString(Localization:getInstance():getText("mark.prise.panel.buy.btn"))
		self.buyBtn:setNumber(tostring(price))
		self.buyBtn:setIconByFrameName("wheel0000")
	end
	self.buyBtn:setColorMode(kGroupButtonColorMode.blue)
	if not (__ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goodsId)) and discount < 10 then
		dBg:setVisible(true)
		dValue:setVisible(true)
		dValue:setString(tostring(discount)..Localization:getInstance():getText("buy.gold.panel.discount"))
	else
		dBg:setVisible(false)
		dValue:setVisible(false)
	end
	self:layoutItems(itemArea)
	itemArea:removeFromParentAndCleanup(true)

	-- event listener
	local function onBuy() self:onBuyBtnTapped(index) end
	self.buyBtn:addEventListener(DisplayEvents.kTouchTap, onBuy)
	local function onClose() self:onCloseBtnTapped() end
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onClose)
	local function onTimeout() self:onCloseBtnTapped() end
	MarkModel:getInstance():addEventListener(kMarkEvents.kPriseTimeOut, onTimeout)
	self.removeListeners = function(self)
		self.buyBtn:removeEventListener(DisplayEvents.kTouchTap, onBuy)
		self.closeBtn:removeEventListener(DisplayEvents.kTouchTap, onClose)
		MarkModel:getInstance():removeEventListener(kMarkEvents.kPriseTimeOut, onTimeout)
	end

	return true
end

function MarkPrisePanel:dispose()
	self:removeListeners()
	BasePanel.dispose(self)
end

function MarkPrisePanel:layoutItems(bounding)
	local posBase = {x = bounding:getPositionX(), y = bounding:getPositionY()}
	local sizeBase = bounding:getGroupBounds().size
	local width = self.items[1]:getGroupBounds().size.width
	local totalWidth = width * #self.items + 10 * (#self.items - 1)
	local posBaseAdd = (sizeBase.width - totalWidth) / 2
	for k, v in ipairs(self.items) do
		v:setPositionX(posBase.x + posBaseAdd + (k - 1) * (width + 10))
		v:setPositionY(posBase.y)
	end
end

function MarkPrisePanel:createItem(builder, itemId, num)
	if type(itemId) ~= "number" or type(num) ~= "number" then return nil end
	local item = self:buildInterfaceGroup("MarkPriseItem")
	local itemPh = item:getChildByName("itemPh")
	local number = item:getChildByName("number")
	local bubble = item:getChildByName("bubble")

	local sprite = builder:buildGroup("Prop_"..tostring(itemId))
	local position = itemPh:getPosition()
	sprite:setPosition(ccp(position.x, position.y))
	item:addChild(sprite)
	item.sprite = sprite
	itemPh:removeFromParentAndCleanup(true)
	number:setText("x"..tostring(num))
	number:setScale(2)
	local size = number:getContentSize()
	local bound = item:getChildByName("bubble"):getContentSize()
	number:setPositionX((bound.width - size.width - 30) / 2)

	item.itemId, item.num = itemId, num

	return item
end

function MarkPrisePanel:popout()
	if self.isDisposed then return end
	PopoutManager:sharedInstance():add(self, false, false)
	self.allowBackKeyTap = true
end

function MarkPrisePanel:onCloseBtnTapped()
	if self.isDisposed then return end
	self.allowBackKeyTap = false
	self.buyBtn:setEnabled(false)
	self.closeBtn:setEnabled(false)
	self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self))
	PopoutManager:sharedInstance():remove(self, true)
end

function MarkPrisePanel:onBuyBtnTapped(index)
	if self.isDisposed then return end
	local scene = HomeScene:sharedInstance()
	local function onSuccess()
		scene:checkDataChange()
		if scene and scene.goldButton and not scene.goldButton.isDisposed then scene.goldButton:updateView() end
		if not self.isDisposed then
			for k, v in ipairs(self.items) do
				if v.itemId == 2 then
					local config = {updateButton = true,}
					local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
					local position = v:getPosition()
					local wPosition = v:getParent():convertToWorldSpace(ccp(position.x, position.y))
					anim.sprites:setPosition(ccp(wPosition.x + 100, wPosition.y - 90))
					scene:addChild(anim.sprites)
					anim:play()
				elseif v.itemId == 14 then
					local num = v.num
					if num > 10 then num = 10 end
					local config = {number = num, updateButton = true,}
					local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
					local position = v:getPosition()
					local size = v:getGroupBounds().size
					local wPosition = v:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
					for k, v2 in ipairs(anim.sprites) do
						v2:setPosition(ccp(wPosition.x, wPosition.y))
						v2:setScaleX(v.sprite:getScaleX())
						v2:setScaleY(v.sprite:getScaleY())
						scene:addChild(v2)
					end
					anim:play()
				else
					local num = v.num
					if num > 10 then num = 10 end
					local config = {propId = v.itemId, number = num, updateButton = true,}
					local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
					local position = v:getPosition()
					local size = v:getGroupBounds().size
					local wPosition = v:getParent():convertToWorldSpace(ccp(position.x + size.width / 8, position.y - size.height / 8))
					for k, v2 in ipairs(anim.sprites) do
						v2:setPosition(ccp(wPosition.x, wPosition.y))
						v2:setScaleX(v.sprite:getScaleX())
						v2:setScaleY(v.sprite:getScaleY())
						scene:addChild(v2)
					end
					anim:play()
				end
			end
		end
		MarkModel:getInstance():removeIndex(index)
		if not self.isDisposed then self:onCloseBtnTapped() end
	end
	local function onGoldNotEnough()
		local function createGoldPanel()
			local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
			if index ~= 0 then
				local panel = createMarketPanel(index)
				panel:popout()
			end
		end
		-- local text = {
		-- 	tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
		-- 	yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
		-- 	no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
		-- }
		-- CommonTipWithBtn:setShowFreeFCash(true)
		-- CommonTipWithBtn:showTip(text, "negative", createGoldPanel)
		GoldlNotEnoughPanel:create(createGoldPanel, nil, nil):popout()
		self.buyBtn:setEnabled(true)
	end
	local function onFail(err)
		if self.isDisposed then return end
		if not err then
			CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		elseif err == 730330 then onGoldNotEnough()
		else CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative") end
		self.buyBtn:setEnabled(true)
	end
	local function onCancel()
		self.buyBtn:setEnabled(true)
	end
	self.buyBtn:setEnabled(false)

	MarkPrisePanelModel:buyMarkPrise(index, onSuccess, onFail, onCancel, self)
end

MarkPrisePanelModel = {}

function MarkPrisePanelModel:buyMarkPrise(index, successCallback, failCallback, cancelCallback, parentPanel)
	local function onSuccess()
		if successCallback then successCallback() end
	end
	local function onFailForIOS(evt)
		local errorCode = nil
		if evt and evt.data then 
			errorCode = evt.data
		end
		if failCallback then failCallback(errorCode) end
	end
	local function onFailForAndroid(evt)
		if parentPanel and not parentPanel.isDisposed then 
			parentPanel.buyBtn:setEnabled(true)
		end
	end
	local function onFail(evt)
		if failCallback then failCallback() end
	end
	local function onCancel(evt)
		if cancelCallback then cancelCallback() end
	end
    local function updateFunc()
		if parentPanel and not parentPanel.isDisposed then 
			parentPanel.buyBtn:setEnabled(true)
		end
    end
	local goodsId = MarkPrisePanelModel:getGoodsId(index)

	if __ANDROID then
		if PaymentManager.getInstance():checkCanWindMillPay(goodsId) then
			local uniquePayId = PaymentDCUtil.getInstance():getNewPayID()
			PaymentDCUtil.getInstance():sendPayStart(Payments.WIND_MILL, 0, uniquePayId, goodsId, 1, 1, 0, 1)

   			local logic = WMBBuyItemLogic:create()
            local buyLogic = BuyLogic:create(goodsId, 2)
            buyLogic:getPrice()
            logic:buy(goodsId, 1, uniquePayId, buyLogic, onSuccess, onFailForAndroid, onFailForAndroid, updateFunc)
		else
			local logic = IngamePaymentLogic:create(goodsId)
			logic:buy(onSuccess, onFail, onCancel, true)
		end
	else
		local logic = BuyLogic:create(goodsId, 2)
		logic:getPrice()
		logic:start(1, onSuccess, onFailForIOS)
	end
end

function MarkPrisePanelModel:getMarkPriseInfo(index)
	local goodsId = MarkPrisePanelModel:getGoodsId(index)
	if type(goodsId) ~= "number" then return {} end
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	if type(meta) ~= "table" then return {} end
	local res = {}
	for k, v in ipairs(meta.items) do
		table.insert(res, {itemId = v.itemId, num = v.num})
	end
	return res
end

function MarkPrisePanelModel:getPriceAndDiscount(index)
	local goodsId = MarkPrisePanelModel:getGoodsId(index)
	if type(goodsId) ~= "number" then return end
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	if type(meta) ~= "table" then return end
	local price, discount = meta.qCash, 10
	if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goodsId) then
		price, discount = meta.rmb / 100, 10
	end
	if meta.discountQCash > 0 or (__ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goodsId)) and meta.discountRmb then
		local function mathRound(num)
			if (num * 100) % 10 > 5 then 
				return math.ceil(num * 10)
			else 
				return math.floor(num * 10) 
			end
		end
		price, discount = meta.discountQCash, mathRound(meta.discountQCash / meta.qCash)
		if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goodsId) then
			price, discount = meta.discountRmb / 100, mathRound(meta.discountRmb / meta.rmb)
		end
	end
	return price, discount
end

-- android only
function MarkPrisePanelModel:getOriginalPrice(index)
	local goodsId = MarkPrisePanelModel:getGoodsId(index)
	if type(goodsId) ~= "number" then return end
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	if type(meta) ~= "table" then return end
	if __ANDROID and not PaymentManager.getInstance():checkCanWindMillPay(goodsId) then 
		return meta.rmb / 100
	else 
		return meta.qCash 
	end
end

function MarkPrisePanelModel:getGoodsId(index)
	local markMeta = MetaManager:getInstance().mark
	if type(markMeta) ~= "table" then return end
	if type(markMeta[index]) ~= "table" then return end
	return markMeta[index].goodsId
end