--------------------------------------------------------------------------------
--购买风车币Panel
--------------------------------------------------------------------------------
require "zoo.panel.basePanel.BasePanel"
require "hecore.ui.PopoutManager"
require "zoo.panelBusLogic.BuyGoldLogic"
require "zoo.baseUI.ButtonWithShadow"
require "zoo.panel.RequireNetworkAlert"
require "zoo.util.ChanceUtils"
require 'zoo.panel.FreeCashTaskPanel'

BuyGoldPanel = class(BasePanel)

local kFreeGoldChance = {
	kFreeGold1 = 50, -- Domob
	kFreeGold2 = 50, -- Limei
}

function BuyGoldPanel:create(onSuccess, onCanceled)
	local panel = BuyGoldPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_buy_gold)
	if panel:init(onSuccess, onCanceled) then
		return panel
	else
		panel = nil
		return nil
	end
end

function BuyGoldPanel:init(onSuccess, onCanceled)
	-- 初始化数据
	self.onInitSuccess = onSuccess
	self.onInitCanceled = onCanceled
	self.items = {}

	-- 初始化面板
	self.ui = self:buildInterfaceGroup("BuyGoldPanel")
	BasePanel.init(self, self.ui)
	self:setPositionForPopoutManager()
	local pos = self:getPosition()
	self:setPosition(ccp(pos.x + 12, pos.y))

	-- 获取控件
	self.captain = self.ui:getChildByName("captain")
	self.close = self.ui:getChildByName("close")
	self.tipText = self.ui:getChildByName("tiptext")
	if not self.captain or not self.close then return false end

	-- 设置文字（需要更新本地化文件）
	local charWidth = 58
	local charHeight = 58
	local charInterval = 46
	local fntFile = "fnt/titles.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/titles.fnt" end
	self.panelTitle = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.panelTitle:setAnchorPoint(ccp(0, 1))
	local position = self.captain:getPosition()
	self.panelTitle:setPosition(ccp(position.x, position.y))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(Localization:getInstance():getText("buy.gold.panel.title"))
	self.panelTitle:setToParentCenterHorizontal()
	if __IOS then
		self.tipText:setString(Localization:getInstance():getText("buy.gold.panel.tip"))
	end
	

	-- 列表
	local bdSize = self:getGroupBounds().size
	self.listVHeight = bdSize.height - 245
	self.clippingNode = ClippingNode:create(CCRectMake(0, 0, bdSize.width - 110, self.listVHeight))
	self.clippingNode:setPosition(ccp(45, -bdSize.height + 80))
	self:addChild(self.clippingNode)
	self.goldVisualList = Layer:create()
	self.goldVisualList:setPosition(ccp(0, self.listVHeight))
	self.clippingNode:addChild(self.goldVisualList)

	-- 设置互动事件监听
	local function onCloseTapped()
		if self.failCallback then
			self.failCallback()
		end
		self:onCloseBtnTapped()
	end
	self.close:setTouchEnabled(true)
	self.close:setButtonMode(true)
	self.close:ad(DisplayEvents.kTouchTap, onCloseTapped)

	self.ui:setTouchEnabled(true, 0, true)
	self:getGoldList()

	return true
end

function BuyGoldPanel:setBoughtCallback(callback)
	self.boughtCallback = callback
end
function BuyGoldPanel:onFailCallback(callback)
	self.failCallback = callback
end

function BuyGoldPanel:getGoldList()
	self.buyLogic = BuyGoldLogic:create()
	self.productMeta = self.buyLogic:getMeta()
	local function getGoldListFinish(iapConfig) self:onGetGoldListFinish(iapConfig) end
	local function getGoldListFail(evt)
		if self.failCallback then self.failCallback() end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.get.list.fail"), "negative")
	end
	local function getGoldListTimeout()
		if self.failCallback then self.failCallback() end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.get.list.timeout"), "negative")
	end
	local function getGoldListCanceled()
		if self.onInitCanceled then self.onInitCanceled() end
	end
	self.buyLogic:getProductInfo(getGoldListFinish, getGoldListFail, getGoldListTimeout, getGoldListCanceled)
end

local itemInitPos = ccp(0, 0)
local itemIndexPos = ccp(310, -320)
function BuyGoldPanel:onGetGoldListFinish(iapConfig)
	local count = 0
	-- 获取购买金币列表
	while iapConfig[tostring(count)] do
		local function getIndex(id)
			for k, v in ipairs(self.productMeta) do
				if v.productId == id then return k end
			end
			return 0
		end
		local index = getIndex(iapConfig[tostring(count)].productIdentifier)
		table.insert(self.items, self:buildBuyGoldItem(index, iapConfig[tostring(count)]))
		count = count + 1
	end
	if __IOS then -- 新增中间计费点，需要排序
		table.sort(self.items, function(a, b) return a.iapPrice < b.iapPrice end)
		-- 重新计算图标
		for index, v in ipairs(self.items) do
			for i = 1, 5 do
				v:getChildByName("icon"..i):setVisible(i == index)
			end
		end
	end

	-- 获取免费金币列表
	if not __WP8 then

		local function popoutPanel()
			print('BuyGoldPanel free cash task panel pop out')
			local panel = FreeCashTaskPanel:create()
			panel:popout()
		end
		if MaintenanceManager:getInstance():isEnabled("FreeCash_1")
		or MaintenanceManager:getInstance():isEnabled("FreeCash_2")
		or MaintenanceManager:getInstance():isEnabled("FreeCash_3") then
			table.insert(self.items, self:buildFreeGoldItem(popoutPanel))
		end
	end

	-- 设置位置
	count = 1
	if self.items and #self.items <= 4 then itemInitPos.y = -60 end
	while self.items[count] do
		self.items[count]:setPosition(ccp(itemInitPos.x, itemInitPos.y + itemIndexPos.y * (count - 1) / 2))
		self.goldVisualList:addChild(self.items[count])
		print("showing list:", count, itemInitPos.x, itemIndexPos.y * (count - 1) / 2)
		if self.items[count + 1] then
			self.items[count + 1]:setPosition(ccp(itemIndexPos.x, itemInitPos.y + itemIndexPos.y * (count - 1) / 2))
			self.goldVisualList:addChild(self.items[count + 1])
			print("showing list:", count + 1, itemIndexPos.x, itemIndexPos.y * (count - 1) / 2)
		end
		count = count + 2
	end

	-- 列表拖动
	self.listHeight = math.ceil(#self.items / 2) * itemIndexPos.y
	print("self.listHeight", self.listHeight)
	local function checkTouchArea(positionY)
		local pos = ccp(0, -self.listVHeight - 70)
		pos = self:convertToWorldSpace(ccp(0, pos.y))
		return not (positionY > pos.y + self.listVHeight or positionY < pos.y)
	end

	local function onTouchBegin(evt)
		self.goldVisualList:stopAllActions()
		self.lastY = evt.globalPosition.y
		self.disableListening = not checkTouchArea(self.lastY)
	end
	local function onTouchMove(evt)
		if self.disableListening then return end
		local nowPos = self.goldVisualList:getPosition().y
		local deltaY = evt.globalPosition.y - self.lastY
		if nowPos < self.listVHeight then
			if math.abs(self.listVHeight - nowPos) > 10 then
				deltaY = deltaY / ((self.listVHeight - nowPos) / 10)
			end
		elseif nowPos + self.listHeight > 0 then
			if math.abs(nowPos + self.listHeight) > 10 then
				deltaY = deltaY / ((nowPos + self.listHeight) / 10)
			end
		end
		self.goldVisualList:runAction(CCMoveBy:create(0, ccp(0, deltaY)))
		self.lastY = evt.globalPosition.y
	end
	local function onTouchEnd(evt)
		self.goldVisualList:stopAllActions()
		local nowPos = self.goldVisualList:getPosition().y
		if nowPos < self.listVHeight then
			self.goldVisualList:runAction(CCMoveTo:create(0.2, ccp(0, self.listVHeight)))
		elseif nowPos + self.listHeight > 0 then
			self.goldVisualList:runAction(CCMoveTo:create(0.2, ccp(0, -self.listHeight)))
		end
		self.lastY = nil
		print(nowPos, self.listHeight)
	end
	if #self.items > 4 then
		self.goldVisualList:setTouchEnabled(true)
		self.goldVisualList:ad(DisplayEvents.kTouchBegin, onTouchBegin)
		self.goldVisualList:ad(DisplayEvents.kTouchMove, onTouchMove)
		self.goldVisualList:ad(DisplayEvents.kTouchEnd, onTouchEnd)
	end

	self:popout()
	if self.onInitSuccess then
		self.onInitSuccess()
	end
end

function BuyGoldPanel:buildBuyGoldItem(index, iapConfigItem)
	local item = self:buildInterfaceGroup("BuyGoldItem")
	item.name = "buy"
	item.iapPrice = iapConfigItem.iapPrice
	local label, size = item:getChildByName("gold"), item:getChildByName("gold_fontSize")
	label = TextField:createWithUIAdjustment(size, label)
	label:setString(self.productMeta[index].cash)
	item:addChild(label)
	for i = 1, 5 do
		item:getChildByName("icon"..i):setVisible(i == index)
		-- if i ~= index then item:getChildByName("icon"..i):setVisible(false) end
	end
	if __WP8 and index > 3 then
		item:getChildByName("icon3"):setVisible(true)
	end
	local btn = item:getChildByName("buyBtn")
	
	-- if __IOS_FB then
	local currencySymbol = Localization:getInstance():getText("buy.gold.panel.money.mark") -- 货币符号
	if __IOS then
		currencySymbol = string.gsub(iapConfigItem.proudctPrice, iapConfigItem.iapPrice..".*$", "")
	end
	btn = ButtonNumberBase:create(btn)
	-- 货币符号，字号偏小
	btn:useStaticNumberLabel(42)
	btn:setNumber(currencySymbol)
	btn:setNumberAlignment(kButtonTextAlignment.right)
	btn.numberLabel:enableShadow(CCSizeMake(3, -3), 1, 1)
	-- 价格，字号偏大
	btn:useStaticLabel(57)
	btn:setString(iapConfigItem.iapPrice)
	btn:setStringAlignment(kButtonTextAlignment.left)
	btn.label:enableShadow(CCSizeMake(3, -3), 1, 1)
	-- 计算偏移量
	local labelOffset = {x=0, y=0}
	local currencyLen = string.len(currencySymbol)
	local priceLen = string.len(iapConfigItem.iapPrice)		
	labelOffset.x = (3 - priceLen) * 6 + (currencyLen - 1) * 4

	if __ANDROID then -- android坐标修正
		labelOffset.y = 10
	end

	local currencySymbolLen = string.len(currencySymbol)
	if labelOffset.x ~= 0 or labelOffset.y ~= 0 then
	 	local numberLabelPosi = btn.numberLabel:getPosition()
		btn.numberLabel:setPosition(ccp(numberLabelPosi.x + labelOffset.x, numberLabelPosi.y + labelOffset.y))
		local labelPosi = btn.label:getPosition()
		btn.label:setPosition(ccp(labelPosi.x + labelOffset.x, labelPosi.y + labelOffset.y))
	end
	-- else
	-- 	btn = GroupButtonBase:create(btn)
	-- 	btn:setString(Localization:getInstance():getText("buy.gold.panel.money.mark")..iapConfigItem.iapPrice)
	-- end

	btn:setColorMode(kGroupButtonColorMode.blue)
	item.btnBuy = btn
	local discount = item:getChildByName("discount")
	discount:removeFromParentAndCleanup(false)
	item:addChild(discount)
	discount:getChildByName("text"):setString(Localization:getInstance():getText("buy.gold.panel.discount"))
	local discountText = discount:getChildByName("num")
	if tonumber(self.productMeta[index].discount) < 10 then
		discountText:setString(self.productMeta[index].discount)
	else discount:setVisible(false) end
	local extraGold = item:getChildByName("extra")
	if extraGold then
		if not iapConfigItem.extra then extraGold:setVisible(false) end
	end

	local function onBuyTapped(evt) self:buyGold(evt.context) end
	btn:addEventListener(DisplayEvents.kTouchTap, onBuyTapped, {index = index, data = iapConfigItem})

	return item
end

local freeGoldCounter = 0
function BuyGoldPanel:buildFreeGoldItem(func)
	local item
	if freeGoldCounter % 2 == 0 then item = self:buildInterfaceGroup("FreeGoldItem")
	else item = self:buildInterfaceGroup("FreeGoldItem2") end
	freeGoldCounter = freeGoldCounter + 1
	item.name = "free"
	local btn = item:getChildByName("getBtn")
	btn = GroupButtonBase:create(btn)
	btn:setString(Localization:getInstance():getText("buy.gold.panel.btn.free.text"))
	
	local function onGetTapped(evt)
		RequireNetworkAlert:callFuncWithLogged(func)
	end
	btn:addEventListener(DisplayEvents.kTouchTap, onGetTapped)

	return item
end

function BuyGoldPanel:buyGold(item)
	local function onOver()
		if not self.isDisposed then
			self:onCloseBtnTapped()
		end
	end
	local function onCancel()
		self:enableClick()
	end
	local function onFail()
		self:enableClick()
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
	end
	local function onSuccess()
		local scene = HomeScene:sharedInstance()
		local button
		if scene then button = scene.goldButton end
		if button then button:updateView() end
		if self.boughtCallback then self.boughtCallback() end
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.success"), "positive", onOver)
	end

	if __IOS then -- IOS
		self:disableClick()
		local function startBuyLogic()
			self.buyLogic:buy(item.index, item.data, onSuccess, onFail, onCancel)
		end
		local function onLoginFail()
			self:enableClick()
		end
		RequireNetworkAlert:callFuncWithLogged(startBuyLogic, onLoginFail)
	else -- on ANDROID and PC we don't need to check for network
		self:disableClick()
		self.buyLogic:buy(item.index, item.data, onSuccess, onFail, onCancel)
	end
end

function BuyGoldPanel:disableClick()
	for __, v in ipairs(self.items) do
		if v.name == "buy" and not v.isDisposed then v.btnBuy:setEnabled(false) end
	end
end

function BuyGoldPanel:enableClick()
	for __, v in ipairs(self.items) do
		if v.name == "buy" and not v.isDisposed then v.btnBuy:setEnabled(true) end
	end
end

function BuyGoldPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
end

function BuyGoldPanel:onCloseBtnTapped()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
end