PaymentEventDispatcher = class(EventDispatcher)

PaymentEvents = {
	kRmbBuyItem = "kRmbBuyItem",
	kBuyWithChoosenType = "kBuyWithChoosenType",
	kBuyConfirmPanelClose = "kBuyConfirmPanelClose",
	kIosBuySuccess = "kIosBuySuccess",
	kIosBuyFailed = "kIosBuyFailed",
}

function PaymentEventDispatcher:ctor()
	
end

function PaymentEventDispatcher:dispatchRmbBuyItemEvent(goods_id, default_payment_type, pay_source)
	self:dispatchEvent(Event.new(PaymentEvents.kRmbBuyItem, {goodsId = goods_id, defaultPaymentType = default_payment_type, paySource = pay_source}, self))
end

function PaymentEventDispatcher:dispatchChoosenTypeEvent(goods_id, choosenType, default_payment_type, pay_source)
	self:dispatchEvent(Event.new(PaymentEvents.kBuyWithChoosenType, {goodsId = goods_id, paymentType = choosenType, defaultPaymentType = default_payment_type, paySource = pay_source}, self))
end

function PaymentEventDispatcher:dispatchPanelCloseEvent()
	self:dispatchEvent(Event.new(PaymentEvents.kBuyConfirmPanelClose, {}, self))
end

function PaymentEventDispatcher:dispatchIosBuySuccess()
	self:dispatchEvent(Event.new(PaymentEvents.kIosBuySuccess, {}, self))
end

function PaymentEventDispatcher:dispatchIosBuyFailed()
	self:dispatchEvent(Event.new(PaymentEvents.kIosBuyFailed, {}, self))
end