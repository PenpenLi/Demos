--------------------------------------------------------------------------------
--购买物品Panel
--------------------------------------------------------------------------------
require "zoo.panel.basePanel.BasePanel"
require "hecore.ui.PopoutManager"
require "zoo.panelBusLogic.BuyLogic"
require "zoo.panel.CommonTip"
require "zoo.baseUI.BuyAndContinueButton"
require "zoo.panel.CommonTipWithBtn"
require "zoo.panel.RequireNetworkAlert"

AddMinusButton = class(GroupButtonBase)
function AddMinusButton:create(group)
	local button = AddMinusButton.new(group)
	button:buildUI()
	return button
end
local kButtonType = {
	kAdd = 0,
	kMinus = 1,
}
function AddMinusButton:setButtonType(buttonType)
	self.add = self.groupNode:getChildByName("add")
	self.addd = self.groupNode:getChildByName("addd")
	self.minus = self.groupNode:getChildByName("minus")
	self.minusd = self.groupNode:getChildByName("minusd")
	self.buttonType = buttonType
	if buttonType == kButtonType.kAdd then
		self.minus:setVisible(false)
		self.minusd:setVisible(false)
		self.addd:setVisible(false)
	elseif buttonType == kButtonType.kMinus then
		self.add:setVisible(false)
		self.addd:setVisible(false)
		self.minusd:setVisible(false)
	end
end
function AddMinusButton:setEnabled(isEnabled)
	GroupButtonBase.setEnabled(self, isEnabled)
	if self.buttonType == kButtonType.kAdd then
		self.add:setVisible(isEnabled)
		self.addd:setVisible(not isEnabled)
	elseif self.buttonType == kButtonType.kMinus then
		self.minus:setVisible(isEnabled)
		self.minusd:setVisible(not isEnabled)
	end
end

BuyPropPanel = class(BasePanel)

function BuyPropPanel:create(goodsId, noLimitCallback, initNum)
	local panel = BuyPropPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_buy_prop)
	if panel:init(goodsId, noLimitCallback, initNum) then
		return panel
	else
		panel = nil
		return nil
	end
end

function BuyPropPanel:init(goodsId, noLimitCallback, initNum)
	if not goodsId then return false end

	-- 数据初始化
	self.onBought = nil
	self.onExit = nil
	self.target = {}
	self.targetNumber = initNum or 1
	self.userMoney = 0
	self.bought = false

	-- 获取数据
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	self.buyLogic = BuyLogic:create(goodsId, 2)
	local price, num = self.buyLogic:getPrice()
	print("num:", num)
	if price == 0 then return false end
	if num == -1 then num = 9 end
	if self.targetNumber <= 1 then self.targetNumber = 1 end
	if num < self.targetNumber then self.targetNumber = num end
	self.target.goodsId = meta.id
	self.target.id = meta.items[1].itemId
	self.target.name = Localization:getInstance():getText("goods.name.text"..self.target.goodsId)
	local props = meta.items
	if type(props) ~= "table" or #props <= 0 then return false end
	-- self.target.tip = Localization:getInstance():getText("level.prop.tip."..tostring(props[1].itemId), {n = '\n'})
	self.target.tip = ""
	self.target.icon = ResourceManager:sharedInstance():getItemResNameFromGoodsId(self.target.goodsId)
	self.target.icon:setScale(1.5)
	self.target.price = price
	self.target.maxNum = num
	if self.target.maxNum <= 0 then
		if noLimitCallback then
			noLimitCallback()
		end
		return false
	end
	local money = UserManager:getInstance().user:getCash()

	-- 建立窗口UI和初始化
	print("building up window")
	self.ui = self:buildInterfaceGroup("BuyPropPanel")
	BasePanel.init(self, self.ui)

	-- 获取控件
	print("gettting controls")
	self.yellowBg = self.ui:getChildByName("_yellowBg")
	self.panelTitle = self.ui:getChildByName("panelTitle")
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.targetIconPlaceHolder = self.ui:getChildByName("targetIconPlaceHolder")
	-- self.numberTitle = self.ui:getChildByName("numberTitle")
	self.number = self.ui:getChildByName("number")
	self.numberMinus = self.ui:getChildByName("numberMinus")
	self.numberAdd = self.ui:getChildByName("numberAdd")
	self.btnBuy = self.ui:getChildByName("btnBuy")
	self.goldText = self.ui:getChildByName("goldText")
	self.gold = self.ui:getChildByName("gold")
	self.propInfo = self.ui:getChildByName("propInfo")
	if not self.panelTitle or not self.closeBtn or not self.targetIconPlaceHolder or not self.number or
	not self.numberMinus or not self.numberAdd or not self.btnBuy or not self.goldText or not self.gold then
	return false end

	self.numberAdd = AddMinusButton:create(self.numberAdd)
	self.numberAdd:setButtonType(kButtonType.kAdd)
	self.numberMinus = AddMinusButton:create(self.numberMinus)
	self.numberMinus:setButtonType(kButtonType.kMinus)
	self.btnBuy = ButtonIconNumberBase:create(self.btnBuy)
	self.btnBuy:setIconByFrameName("ui_images/ui_image_coin_icon_small0000")
	self.btnBuy:setColorMode(kGroupButtonColorMode.blue)

	-- 设置文字、占位符（需要更新本地化文件）
	print("setting up controls")
	self.panelTitle:setString(Localization:getInstance():getText("buy.prop.panel.title", {prop = self.target.name}))
	local dimension = self.propInfo:getDimensions()
	self.propInfo:setDimensions(CCSizeMake(dimension.width, 0))
	self.propInfo:setString(Localization:getInstance():getText(self.target.tip))
	-- self.numberTitle:setString(Localization:getInstance():getText("buy.prop.panel.label.number"))
	self.btnBuy:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))
	self.goldText:setString(Localization:getInstance():getText("buy.prop.panel.label.treasure"))

	self.targetIconPlaceHolder:getParent():addChild(self.target.icon)
	local pos = self.targetIconPlaceHolder:getPosition()
	-- print(x.x, x.y, y)
	self.target.icon:setPositionXY(pos.x, pos.y)
	self.targetIconPlaceHolder:removeFromParentAndCleanup(true)
	self.number:setString("x "..self.targetNumber)
	self.btnBuy:setNumber(self.targetNumber * self.target.price)
	self.gold:setString(money)
	local bgSize = self.yellowBg:getPreferredSize()
	local txtSize = self.propInfo:getContentSize()
	self.yellowBg:setPreferredSize(CCSizeMake(bgSize.width, -self.propInfo:getPositionY() + txtSize.height + 30))
	-- self.yellowBg:setPositionY(-bgSize.height)

	-- 设置互动事件监听
	print("adding listeners")
	local function onClose()
		self:onCloseBtnTapped()
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:ad(DisplayEvents.kTouchTap, onClose)

	local function onMinus()
		self.targetNumber = self.targetNumber - 1
		if self.targetNumber <= 1 then self.targetNumber = 1 end
		self:updateNumberMethod()
		self.number:setString("x "..self.targetNumber)
		self.btnBuy:setNumber(self.targetNumber * self.target.price)
	end
	self.numberMinus:addEventListener(DisplayEvents.kTouchTap, onMinus)

	local function onAdd()
		self.targetNumber = self.targetNumber + 1
		if self.targetNumber >= self.target.maxNum then self.targetNumber = self.target.maxNum end
		self:updateNumberMethod()
		self.number:setString("x "..self.targetNumber)
		self.btnBuy:setNumber(self.targetNumber * self.target.price)
	end
	self.numberAdd:addEventListener(DisplayEvents.kTouchTap, onAdd)

	local function onBuy()
		self:onBtnBuyTapped()
	end
	self.btnBuy:addEventListener(DisplayEvents.kTouchTap, onBuy)

	self:updateNumberMethod()
	self:setPositionForPopoutManager()
	print("all done")
	return true
end

function BuyPropPanel:onCloseBtnTapped()
	if self.onExit then
		self.onExit()
	end
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
end

function BuyPropPanel:updateNumberMethod()
	local function setAddEnabled(enabled)
		self.numberAdd:setTouchEnabled(enabled)
		self.numberAdd:setButtonMode(enabled)
		self.numberAdd:getChildByName("disabled"):setVisible(not enabled)
		self.numberAdd:getChildByName("enabled"):setVisible(enabled)
		self.numberAdd:getChildByName("addd"):setVisible(not enabled)
		self.numberAdd:getChildByName("add"):setVisible(enabled)
	end
	local function setMinusEnabled(enabled)
		self.numberMinus:setTouchEnabled(enabled)
		self.numberMinus:setButtonMode(enabled)
		self.numberMinus:getChildByName("disabled"):setVisible(not enabled)
		self.numberMinus:getChildByName("enabled"):setVisible(enabled)
		self.numberMinus:getChildByName("minusd"):setVisible(not enabled)
		self.numberMinus:getChildByName("minus"):setVisible(enabled)
	end

	self.numberMinus:setEnabled(self.targetNumber > 1)
	self.numberAdd:setEnabled(self.targetNumber < self.target.maxNum)
	-- setMinusEnabled(self.targetNumber > 1)
	-- setAddEnabled(self.targetNumber < self.target.maxNum)
end

function BuyPropPanel:onBtnBuyTapped()
	local animation = nil
	local listening = true
	local function onAnimCloseBtn()
		if animation then
			animation:removeFromParentAndCleanup(true) 
			animation = nil
			listening = false
		end
	end
	local function onSuccess(evt)
		if not listening then return end
		onAnimCloseBtn()
		self.bought = true
		if self.onBought then
			self.onBought(self.target.id, self.targetNumber)
		end
		local scene = HomeScene:sharedInstance()
		local button = scene.goldButton
		if button then button:updateView() end
		CommonTip:showTip(Localization:getInstance():getText("buy.prop.panel.success"), "positive")
		PopoutManager:sharedInstance():remove(self, true)
	end
	local function onFail(evt)
		if not listening then return end
		onAnimCloseBtn()
		if evt.data == 730330 then
			self:goldNotEnough()
		else
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		end
	end

	local function onUserHasLogin()
		self.buyLogic:start(self.targetNumber, onSuccess, onFail)
	end
	RequireNetworkAlert:callFuncWithLogged(onUserHasLogin)
end

function BuyPropPanel:goldNotEnough()
	local function updateGold()
		local money = UserManager:getInstance().user:getCash()
		self.gold:setString(money)
	end
	local function createGoldPanel()
		print("createGoldPanel")
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			local config = {TabsIdConst.kHappyeCoin}
			local panel = createMarketPanel(index,config)
			panel:addEventListener(kPanelEvents.kClose, updateGold)
			panel:popout()
		else updateGold() end
	end
	local function askForGoldPanel()
		print("ask for gold panel")
		local text = {
			tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
			yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
			no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
		}
		CommonTipWithBtn:setShowFreeFCash(true)
		local positionY = self:getPositionY()
		CommonTipWithBtn:showTip(text, "negative", createGoldPanel, nil, {y = positionY})
	end
	askForGoldPanel()
end

function BuyPropPanel:setBoughtCallback(callback)
	self.onBought = callback
end

function BuyPropPanel:setExitCallback(callback)
	self.onExit = callback
end

function BuyPropPanel:popout()
	PopoutManager:sharedInstance():add(self, false, false)
	self:setPositionY(self:getPositionY() + 130)
	self:runAction(CCEaseElasticOut:create(CCMoveBy:create(0.8, ccp(0, -130))))
	self.allowBackKeyTap = true
end