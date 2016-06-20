PaymentEventDispatcher = class(EventDispatcher)

PaymentEvents = {
	kBuyConfirmPanelPay = "kBuyConfirmPanelPay",
	kBuyConfirmPanelClose = "kBuyConfirmPanelClose",
	kIosBuySuccess = "kIosBuySuccess",
	kIosBuyFailed = "kIosBuyFailed",
}

function PaymentEventDispatcher:ctor()
	
end

function PaymentEventDispatcher:dispatchPanelPayEvent(default_payment_type)
	self:dispatchEvent(Event.new(PaymentEvents.kBuyConfirmPanelPay, {defaultPaymentType = default_payment_type}, self))
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