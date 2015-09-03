if __IOS or __WIN32 then
	require 'zoo.gameGuide.IosPayGuide'
end

GoldlNotEnoughPanel = class(BasePanel)

function GoldlNotEnoughPanel:ctor()
	
end

function GoldlNotEnoughPanel:init()
	self.ui	= self:buildInterfaceGroup("GoldlNotEnoughPanel") 
	BasePanel.init(self, self.ui)

	local text = self.ui:getChildByName("text")
	text:setString(Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"))

	self.discountSign = self.ui:getChildByName("sign")
	self.discountSign:setVisible(false)
	if __ANDROID then
		if PaymentManager.getInstance():checkThirdPartPaymentEabled() then
			self.discountSign:setVisible(true)
		end
	end
	self.buyBtn = GroupButtonBase:create(self.ui:getChildByName("buyBtn"))
	self.buyBtn:setString(Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"))
	self.buyBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
			self:onBuyBtnTap()
		end)

	self.nextBtn = GroupButtonBase:create(self.ui:getChildByName("nextBtn"))
	self.nextBtn:setString(Localization:getInstance():getText("buy.prop.panel.not.buy.btn"))
	self.nextBtn:setColorMode(kGroupButtonColorMode.blue)
	self.nextBtn:addEventListener(DisplayEvents.kTouchTap,  function ()
			self:onNextBtnTap()
		end)

	if __IOS or __WIN32 then
		if IosPayGuide:shouldShowMarketOneYuanFCash() then
			self:showDiscountSign(true)
		end
	end
end

function GoldlNotEnoughPanel:showDiscountSign(enable)
	self.discountSign:setVisible(enable == true)
end

function GoldlNotEnoughPanel:onBuyBtnTap()
	if self.confirmFunc then self.confirmFunc() end
	self:removePopout()
end

function GoldlNotEnoughPanel:onNextBtnTap()
	if __ANDROID then
		PaymentDCUtil.getInstance():sendPayChoose(-2, 0, 0, self.uniquePayId, 0)
	elseif __IOS then 
		PaymentIosDCUtil.getInstance():sendPayChoose(-2, 0, 0, self.uniquePayId, 0)
	end
	self:removeSelf()
end

function GoldlNotEnoughPanel:removeSelf()
	if self.cancelFunc then self.cancelFunc() end
	self:removePopout()
end

function GoldlNotEnoughPanel:popout()
	PopoutManager:sharedInstance():add(self, false, false)
	local parent = self:getParent()
	if parent then
		self:setToScreenCenterHorizontal()
		self:setToScreenCenterVertical()		
	end
	self.allowBackKeyTap = true 
	if __ANDROID then
		PaymentDCUtil.getInstance():sendPayChoosePop(-2, 0, self.uniquePayId, 0)
	elseif __IOS then 
		PaymentIosDCUtil.getInstance():sendPayChoosePop(-2, 0, self.uniquePayId, 0)
	end
end

function GoldlNotEnoughPanel:removePopout()
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
end

function GoldlNotEnoughPanel:onCloseBtnTapped()
	if __ANDROID then
		PaymentDCUtil.getInstance():sendPayChoose(-2, 0, 0, self.uniquePayId, 0)
	elseif __IOS then 
		PaymentIosDCUtil.getInstance():sendPayChoose(-2, 0, 0, self.uniquePayId, 0)
	end
	self:removeSelf()
end

function GoldlNotEnoughPanel:create(confirmFunc, cancelFunc, uniquePayId)
	local panel = GoldlNotEnoughPanel.new()
	panel.confirmFunc = confirmFunc
	panel.cancelFunc = cancelFunc
	panel.uniquePayId = uniquePayId
	panel:loadRequiredResource("ui/BuyConfirmPanel.json")
	panel:init()
	return panel
end