require "zoo.payment.BuyConfirmPanel"

WindMillConfirmPanel = class(BuyConfirmPanel)

function WindMillConfirmPanel:ctor()
	--风车币买道具默认数量
	self.targetNumber = 1
	--区别支付失败关闭面板和直接关闭面板
	self.failBeforePayEnd = false
end

function WindMillConfirmPanel:init()
	BuyConfirmPanel.init(self)
	self.rmbPart:setVisible(false)

	-- 获取数据
	self.target = {}
	local goodsData = MarketManager:sharedInstance():getGoodsById(self.goodsId)
	self.buyLogic = BuyLogic:create(self.goodsId, 2)
	local price, num = self.buyLogic:getPrice()
	if price == 0 then return false end
	if num == -1 then num = 9 end
	if self.targetNumber <= 1 then self.targetNumber = 1 end
	if num < self.targetNumber then self.targetNumber = num end
	self.target.goodsId = goodsData.id
	self.target.id = goodsData.items[1].itemId
	self.target.price = price
	self.target.maxNum = num
	
	local bg = self.windMillPart:getChildByName("bg")
	bg:setVisible(false)

	local buyBtnRes = self.windMillPart:getChildByName("btnBuy")
	self.btnBuyWindMill = ButtonIconNumberBase:create(buyBtnRes)
	self.btnBuyWindMill:setIconByFrameName("ui_images/ui_image_coin_icon_small0000")
	self.btnBuyWindMill:setColorMode(kGroupButtonColorMode.blue)
	self.btnBuyWindMill:setString(Localization:getInstance():getText("buy.prop.panel.btn.buy.txt"))
	self.btnBuyWindMill:setNumber(self.targetNumber * self.target.price)
	self.btnBuyWindMill:addEventListener(DisplayEvents.kTouchTap, function ()
		self:onWindMillBuyBtnTap()
	end)

	local goldText = self.windMillPart:getChildByName("goldText")
	goldText:setString(Localization:getInstance():getText("buy.prop.panel.label.treasure"))

	self.gold = self.windMillPart:getChildByName("gold")
	local money = UserManager:getInstance().user:getCash()
	self.gold:setString(money)

	local numContrlRes = self.windMillPart:getChildByName("numContrl")
	self.leftNumBtn = numContrlRes:getChildByName("minus")
	self.leftNumBtn.bg = self.leftNumBtn:getChildByName("bg")
	self.leftNumBtn:setButtonMode(true)
	self.leftNumBtn:setTouchEnabled(true)
	self.leftNumBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
		self:onMinusBtnTap()
	end)
	self.rightNumBtn = numContrlRes:getChildByName("plus")
	self.rightNumBtn.bg = self.rightNumBtn:getChildByName("bg")
	self.rightNumBtn:setButtonMode(true)
	self.rightNumBtn:setTouchEnabled(true)
	self.rightNumBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
		self:onPlusBtnTap()
	end)
	self.itemNum = numContrlRes:getChildByName("num")
	self.itemNum:setString("x "..self.targetNumber)
	self:updateNumBtnShow()
end

function WindMillConfirmPanel:onCloseBtnTap()
	local endResult = 3
	if self.failBeforePayEnd then 
		endResult = 4
	end
	PaymentDCUtil.getInstance():sendPayEnd(Payments.WIND_MILL, Payments.WIND_MILL, self.uniquePayId, self.goodsId, self.goodsType, 
							self.targetNumber, 0, 0, self.targetNumber * self.target.price, endResult, nil, 0)

	BuyConfirmPanel.onCloseBtnTap(self)
end

function WindMillConfirmPanel:onMinusBtnTap()
	self.targetNumber = self.targetNumber - 1
	if self.targetNumber <= 1 then self.targetNumber = 1 end
	self:updateNumBtnShow()
	self.itemNum:setString("x "..self.targetNumber)
	self.btnBuyWindMill:setNumber(self.targetNumber * self.target.price)
end

function WindMillConfirmPanel:onPlusBtnTap()
	self.targetNumber = self.targetNumber + 1
	if self.targetNumber >= self.target.maxNum then self.targetNumber = self.target.maxNum end
	self:updateNumBtnShow()
	self.itemNum:setString("x "..self.targetNumber)
	self.btnBuyWindMill:setNumber(self.targetNumber * self.target.price)
end

function WindMillConfirmPanel:updateNumBtnShow()
	local leftEnable = false
	if self.targetNumber > 1 then leftEnable = true end
	local rightEnable = false
	if self.targetNumber < self.target.maxNum then rightEnable = true end

	self:setNumBtnEnable(self.leftNumBtn, leftEnable)
	self:setNumBtnEnable(self.rightNumBtn, rightEnable) 
end

function WindMillConfirmPanel:setNumBtnEnable(numBtn, isEnable)
	if not isEnable then isEnable = false end
	if numBtn and numBtn.refCocosObj then 
		numBtn.bg:applyAdjustColorShader()
		if isEnable then 
			numBtn.bg:clearAdjustColorShader()
		else
			numBtn.bg:adjustColor(0,-1, 0, 0)
		end
		numBtn:setTouchEnabled(isEnable)
	end
end

function WindMillConfirmPanel:onWindMillBuyBtnTap()
	self.btnBuyWindMill:setEnabled(false)
	local function successCallback(goodsNum)
		if self.callback and self.callback.successCallback then 
			self.callback.successCallback(goodsNum) 
		end
		if not self.isDisposed then 
			self.btnBuyWindMill:setEnabled(true)
			self:removePopout()
		end
	end

	local function failCallback()
		if self.isDisposed then return end
		self.failBeforePayEnd = true
		self.btnBuyWindMill:setEnabled(true)
	end

	local function cancelCallback()
		if self.isDisposed then return end
		self.failBeforePayEnd = true
		self.btnBuyWindMill:setEnabled(true)
	end

	local function updateGold()
		if self.isDisposed then return end
		local money = UserManager:getInstance().user:getCash()
		self.gold:setString(money)
		self.btnBuyWindMill:setEnabled(true)
	end

	local logic = WMBBuyItemLogic:create()
	logic:buy(self.goodsId, self.targetNumber, self.uniquePayId, self.buyLogic, successCallback, failCallback, cancelCallback, updateGold)
end

function WindMillConfirmPanel:popout()
	BuyConfirmPanel.popout(self)
	PaymentDCUtil.getInstance():sendPayStart(Payments.WIND_MILL, 0, self.uniquePayId, self.goodsId, self.goodsType, 
											self.targetNumber, 0, 0)	
end

function WindMillConfirmPanel:removePopout()
	if self.callback and self.callback.onCancel then 
		self.callback.onCancel()
	end
	BuyConfirmPanel.removePopout(self)
end

function WindMillConfirmPanel:create(goodsId, goodsType, callback, uniquePayId)
	local panel = WindMillConfirmPanel.new()
	panel.goodsId = goodsId
	panel.goodsType = goodsType
	panel.callback = callback
	panel.uniquePayId = uniquePayId
	panel:loadRequiredResource("ui/BuyConfirmPanel.json")
	panel:init()
	return panel
end