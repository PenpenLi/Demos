NetConnectPanel = class(BasePanel)

local PayTextConfig = table.const {
	{payType = 4 ,payTypeName = "豌豆荚支付"},
	{payType = 7 ,payTypeName = "360支付"},
	{payType = 11 ,payTypeName = "微信支付"},
	{payType = 12 ,payTypeName = "支付宝支付"},
}

function NetConnectPanel:ctor()
	
end

function NetConnectPanel:init()
	self.ui	= self:buildInterfaceGroup("NetConnectPanel") 
	BasePanel.init(self, self.ui)

	local text1 = self.ui:getChildByName("text1")
	if self.isRmbPay then 
		local defaultThirdPayType = PaymentManager.getInstance():getDefaultThirdPartPayment()
		local payText = "联网支付"
		for i,v in ipairs(PayTextConfig) do
			if defaultThirdPayType == v.payType then
				 payText = v.payTypeName
			end
		end
		text1:setString(Localization:getInstance():getText("当前没有联网，不能使用"..payText.."哦！"))
	else
		text1:setString(Localization:getInstance():getText("panel.no.net.pay.text1"))
	end
	local text2 = self.ui:getChildByName("text2")
	text2:setString(Localization:getInstance():getText("panel.no.net.pay.text2"))
	text2:setVisible(false)

	self.connectBtn = GroupButtonBase:create(self.ui:getChildByName("connectBtn"))
	self.connectBtn:setString(Localization:getInstance():getText("panel.no.net.pay.botton1"))
	self.connectBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
			self:onConnectBtnTap()
		end)

	local smsPayBtnUI = self.ui:getChildByName("smsPayBtn")
	if self.smsPayType then 
		text2:setVisible(true)
		self.smsPayBtn = GroupButtonBase:create(smsPayBtnUI)
		self.smsPayBtn:setColorMode(kGroupButtonColorMode.blue)
		local label1 = string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), self.goodsPrice)
		local label2 =	label1 .. Localization:getInstance():getText("panel.no.net.pay.botton2")
		self.smsPayBtn:setString(label2)
		self.smsPayBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
				self:onSmsPayBtnTap()
			end)
	else
		smsPayBtnUI:setVisible(false)
	end
end

function NetConnectPanel:onConnectBtnTap()
	local alterList = 0
	if self.smsPayType then 
		local chooseTable = {self.smsPayType}
		alterList = PaymentDCUtil.getInstance():getAlterPaymentList(chooseTable)
	end
	PaymentDCUtil.getInstance():sendPayChoose(-1, alterList, 0, self.uniquePayId, 0)
	if self.connectCallback then 
		self.connectCallback()
	end
	self:removePopout()
end

function NetConnectPanel:onSmsPayBtnTap()
	self:setButtonsEnabled(false)

	local alterList = 0
	if self.smsPayType then 
		local chooseTable = {self.smsPayType}
		alterList = PaymentDCUtil.getInstance():getAlterPaymentList(chooseTable)
	end
	if self.handleCallback then 
		PaymentDCUtil.getInstance():sendPayChoose(-1, alterList, self.smsPayType, self.uniquePayId, 0)
		self.handleCallback()
	end
	-- if self.connectCallback then 
	-- 	self.connectCallback()
	-- end
	self:removePopout()
end

function NetConnectPanel:popout()
	PopoutManager:sharedInstance():add(self, false, false)
	local parent = self:getParent()
	if parent then
		self:setToScreenCenterHorizontal()
		self:setToScreenCenterVertical()		
	end
	self.allowBackKeyTap = true
	local alterList = 0
	if self.smsPayType then 
		local chooseTable = {self.smsPayType}
		alterList = PaymentDCUtil.getInstance():getAlterPaymentList(chooseTable)
	end
	PaymentDCUtil.getInstance():sendPayChoosePop(-1, alterList, self.uniquePayId, 0)
end

function NetConnectPanel:removePopout()
	PopoutManager:sharedInstance():remove(self, true)
	self.allowBackKeyTap = false
end

function NetConnectPanel:setButtonsEnabled(isEnabled)
	if self.isDisposed then return end
	if not isEnabled then isEnabled = false end
	if self.connectBtn then 
		self.connectBtn:setEnabled(isEnabled)
	end
	if self.smsPayBtn then 
		self.smsPayBtn:setEnabled(isEnabled)
	end
end

function NetConnectPanel:onCloseBtnTapped()
	self:onConnectBtnTap()
end

function NetConnectPanel:create(smsPayType, handleCallback, goodsPrice, connectCallback, uniquePayId, isRmbPay)
	local panel = NetConnectPanel.new()
	panel.smsPayType = smsPayType
	panel.handleCallback = handleCallback
	panel.goodsPrice = goodsPrice
	panel.connectCallback = connectCallback
	panel.uniquePayId = uniquePayId
	panel.isRmbPay = isRmbPay
	panel:loadRequiredResource("ui/BuyConfirmPanel.json")
	panel:init()
	return panel
end