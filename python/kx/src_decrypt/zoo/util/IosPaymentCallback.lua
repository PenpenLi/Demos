waxClass{"IosPaymentCallback", NSObject, protocols = {"GspPaymentDelegate"}}

function init_getFunc_completeFunc_errorFunc(self, getFunc, completeFunc, errorFunc)
	self.super:init()
	self.getFunc = getFunc
	self.completeFunc = completeFunc
	self.errorFunc = errorFunc
	return self
end

function paymentComplete_errorInfo_userInfo(self, orderId, errorInfo, userInfo)
	self.completeFunc(orderId, errorInfo, userInfo)
end

function paymentGetIapConfig(self, iapConfig)
	self.getFunc(iapConfig);
end

function paymentError(self, errorInfo)
	self.errorFunc(errorInfo)
end