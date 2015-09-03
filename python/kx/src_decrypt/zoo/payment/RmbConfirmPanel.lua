require "zoo.payment.BuyConfirmPanel"
require "zoo.payment.FirstRmbBuyPanel"

RmbConfirmPanel = class(BuyConfirmPanel)

function RmbConfirmPanel:ctor()
	--三方打八折
	self.discountNum = 8
	--区别支付失败关闭面板和直接关闭面板
	self.failBeforePayEnd = false
end

function RmbConfirmPanel:init()
	BuyConfirmPanel.init(self)

	self.windMillPart:setVisible(false)

	--将可选支付列表转成数字作为打点参数
	-- self.alterListForDC = PaymentDCUtil.getInstance():getAlterPaymentList(self.otherPaymentTable)

	local bg = self.rmbPart:getChildByName("bg")
	bg:setVisible(false)

	local goodsInfoMeta = MetaManager:getInstance():getGoodMeta(self.goodsId)
	self.showPrice = goodsInfoMeta.thirdRmb / 100

	self.buyButton = ButtonIconNumberBase:create(self.rmbPart:getChildByName("buyBtn"))
	self.buyButton:setNumber(string.format("%s%0.2f", Localization:getInstance():getText("buy.gold.panel.money.mark"), self.showPrice))
	self.buyButton.numberLabel:setPositionX(self.buyButton.numberLabel:getPositionX() - 20)
	self.buyButton:setString(Localization:getInstance():getText("add.step.panel.buy.btn.txt"))
	self.buyButton:setColorMode(kGroupButtonColorMode.blue)
	self.buyButton:addEventListener(DisplayEvents.kTouchTap,  function ()
			self:onRmbBuyBtnTap()
		end)

	self.btnDiscount = self.rmbPart:getChildByName("discount")
	self.btnDiscountNum = self.btnDiscount:getChildByName("num")
	self.btnDiscount:setVisible(false)
end

--IngamePaymentLogic那边支付失败时 调一下这个
function RmbConfirmPanel:setFailBeforePayEnd()
	self.failBeforePayEnd = true
end

function RmbConfirmPanel:onCloseBtnTap()
	local endResult = 3
	if self.failBeforePayEnd then 
		endResult = 4
	end
	local choosenType = self.paymentType
	if self.choosenType then 
		choosenType = self.choosenType
	end
	PaymentDCUtil.getInstance():sendPayEnd(self.paymentType, 
					choosenType, 
					self.uniquePayId, 
					self.goodsId, 
					self.goodsType, 
					1, 
					0, 
					self.showPrice, 
					0, 
					endResult, 
					nil, 
					0)
	BuyConfirmPanel.onCloseBtnTap(self)
end

function RmbConfirmPanel:onRmbBuyBtnTap()
	local function rebecomeEnable()
		if self.buyButton and not self.buyButton.isDisposed then 
			self.buyButton:setEnabled(true)
		end
	end
	if self.buyButton and not self.buyButton.isDisposed then 
		self.buyButton:setEnabled(false)
		setTimeOut(rebecomeEnable, 3)
	end
	if self.peDispatcher then 
		self.peDispatcher:dispatchRmbBuyItemEvent(self.goodsId, self.paymentType, 0)
	end
end

function RmbConfirmPanel:setBuyBtnEnabled(isEnable)
	if self.buyButton and not self.buyButton.isDisposed then 
		self.buyButton:setEnabled(isEnable)
	end
end

function RmbConfirmPanel:popout()
	BuyConfirmPanel.popout(self)
	PaymentDCUtil.getInstance():sendPayStart(self.paymentType, 
											0, 
											self.uniquePayId, 
											self.goodsId, 
											self.goodsType, 
											1, 
											0, 
											0)		

	self:showFirstRmbBuyPanel()
end

function RmbConfirmPanel:showFirstRmbBuyPanel()
	PaymentManager.getInstance():refreshOneYuanShowTime()
	
	local popoutPos = self:getPosition()
	local selfSize = self.ui:getGroupBounds().size
	local energyPanelBottomPosY = popoutPos.y - selfSize.height
	local selfParent = self:getParent()
	local posInWorldSpace = selfParent:convertToWorldSpace(ccp(0, energyPanelBottomPosY))
	local panel = FirstRmbBuyPanel:create(self.goodsId, self.uniquePayId, self, self.peDispatcher, self.otherPaymentTable, posInWorldSpace.y)
	panel:popout()
end

function RmbConfirmPanel:removePopout()
	if self.peDispatcher then 
		self.peDispatcher:dispatchPanelCloseEvent()
	end
	BuyConfirmPanel.removePopout(self)
end

function RmbConfirmPanel:create(peDispatcher, goodsId, goodsType, paymentType, otherPaymentTable, uniquePayId)
	local panel = RmbConfirmPanel.new()
	panel.peDispatcher = peDispatcher
	panel.goodsId = goodsId
	panel.goodsType = goodsType
	panel.paymentType = paymentType
	panel.otherPaymentTable = otherPaymentTable
	panel.uniquePayId = uniquePayId
	panel:loadRequiredResource("ui/BuyConfirmPanel.json")
	panel:init()
	return panel
end