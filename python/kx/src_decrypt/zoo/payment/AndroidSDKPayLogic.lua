local AliQuickPayGuide = require 'zoo.panel.alipay.AliQuickPayGuide'

AndroidSDKPayEventDispatcher = class(EventDispatcher)
AndroidSDKPayEvents = {
	kSdkPaySucess = "kSdkPaySucess",
	kSdkPayFail = "kSdkPayFail",
	kSdkPayCancel = "kSdkPayCancel",
	kPreOrderRequestError = "kPreOrderRequestError",
	kAliQuickPaySuccess = "kAliQuickPaySuccess",
    kAliSignAndPaySuccess = 'kAliSignAndPaySuccess',
    kWechatQuickPaySuccess = 'kWechatQuickPaySuccess',
}
function AndroidSDKPayEventDispatcher:ctor()
	
end

function AndroidSDKPayEventDispatcher:dispatchSdkPaySuccess(payResult)
	self:dispatchEvent(Event.new(AndroidSDKPayEvents.kSdkPaySucess, {result = payResult}, self))
end

function AndroidSDKPayEventDispatcher:dispatchSdkPayFail(payErrCode, payErrMsg)
	self:dispatchEvent(Event.new(AndroidSDKPayEvents.kSdkPayFail, {errCode = payErrCode, errMsg = payErrMsg}, self))
end

function AndroidSDKPayEventDispatcher:dispatchSdkPayCancel()
	self:dispatchEvent(Event.new(AndroidSDKPayEvents.kSdkPayCancel, {}, self))
end

function AndroidSDKPayEventDispatcher:dispatchRequestError(errCode, errMsg, choosenType)
	self:dispatchEvent(Event.new(AndroidSDKPayEvents.kPreOrderRequestError, {errCode = errCode, errMsg = errMsg, choosenType = choosenType}, self))
end

function AndroidSDKPayEventDispatcher:dispatchAliQuickPaySuccess()
	self:dispatchEvent(Event.new(AndroidSDKPayEvents.kAliQuickPaySuccess, {errCode = errCode, errMsg = errMsg, choosenType = choosenType}, self))
end

function AndroidSDKPayEventDispatcher:dispatchAliSignAndPaySuccess()
    self:dispatchEvent(Event.new(AndroidSDKPayEvents.kAliSignAndPaySuccess, {errCode = errCode, errMsg = errMsg, choosenType = choosenType}, self))
end

function AndroidSDKPayEventDispatcher:dispatchWechatQuickPaySuccess()
    self:dispatchEvent(Event.new(AndroidSDKPayEvents.kWechatQuickPaySuccess, {errCode = errCode, errMsg = errMsg, choosenType = choosenType}, self))
end



AndroidSDKPayLogic = class()

function AndroidSDKPayLogic:ctor()
	
end

function AndroidSDKPayLogic:init()
	self.eventDispatcher = AndroidSDKPayEventDispatcher.new()
	self.goodsName = Localization:getInstance():getText("goods.name.text"..tostring(self.goodsIdInfo:getGoodsNameId()))
	self.signForThirdPay = PaymentManager.getInstance():getSignForThirdPay(self.goodsIdInfo)
	self.platform = StartupConfig:getInstance():getPlatformName()
	self.goodsPaycodeMeta = self:getGoodsPayCodeMeta()

	self:buildSdkCallBack()

	if self.paymentType == Payments.WECHAT then
        print('wenkan isWechatSigned()', UserManager:getInstance():isWechatSigned()) 
        print('wenkan checkCanWechatQuickPay ', PaymentManager.getInstance():checkCanWechatQuickPay(self.totalFee), self.totalFee)
        print('wenkan goodsId ', self.goodsIdInfo:getGoodsId())
        if UserManager:getInstance():isWechatSigned() and PaymentManager.getInstance():checkCanWechatQuickPay(self.totalFee) 
        then
            print('wenkan doWechatQuickPay')
            self:doWechatQuickPay()
        else
            print('wenkan doWechatPay')
    		self:doWechatPay()
        end
	elseif self.paymentType == Payments.ALIPAY then 
        print('wenkan checkCanAliQuickPay ', PaymentManager.getInstance():checkCanAliQuickPay(self.totalFee))
        print('wenkan isAliSigned ', UserManager.getInstance():isAliSigned(), 'AliQuickPayGuide.isGuideTime() ', AliQuickPayGuide.isGuideTime())
        if not UserManager.getInstance():isAliSigned() and AliAppSignAndPayLogic:getInstance():isEnabled() and PaymentManager.getInstance():checkCanAliQuickPay(self.totalFee) 
        and self.goodsIdInfo:getGoodsId() ~= 18  -- 一元风车币不签约
        then
            print('wenkan self:doAliSignAndPay')
            self:doAliSignAndPay()
		elseif UserManager.getInstance():isAliSigned() and PaymentManager.getInstance():checkCanAliQuickPay(self.totalFee) then 
            print('wenkan self:doAliQuickPay')
			self:doAliQuickPay() 
		else
            print('wenkan self:doAliPay')
			self:doAliPay()
		end
	elseif self.paymentType == Payments.QQ then
		self:doQQPay()
	elseif self.paymentType == Payments.HUAWEI then 
		self:doHuaweiPay()
	elseif self.paymentType == Payments.QQ_WALLET then
		self:doQQWalletPay()
	else
		self:doGeneralPay()
	end
end

function AndroidSDKPayLogic:buildSdkCallBack()
	local function sdkPaySuccess(payResult)
		self.eventDispatcher:dispatchSdkPaySuccess(payResult)
	end

	local function sdkPayFail(payErrCode, payErrMsg)
		self.eventDispatcher:dispatchSdkPayFail(payErrCode, payErrMsg)
	end

	local function sdkPayCancel()
		self.eventDispatcher:dispatchSdkPayCancel()
	end

	self.callbackProxy = luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = sdkPaySuccess,
        onError = sdkPayFail,
        onCancel = sdkPayCancel
    })

end

function AndroidSDKPayLogic:getGoodsPayCodeMeta()
	local goodsPayCodeId = self.goodsIdInfo:getGoodsPayCodeId()
	return MetaManager:getGoodPayCodeMeta(goodsPayCodeId)
end

function AndroidSDKPayLogic:add(evt, fuc)
	self.eventDispatcher:addEventListener(evt, fuc)
end

function AndroidSDKPayLogic:buildPaymentParams()
	local params = luajava.newInstance("java.util.HashMap")
	params:put("uid", UserManager:getInstance().uid or "12345")
	params:put("amount", self.amount)

	local goodsParams = nil
	local paramTable = {}

	local goodsPayCodeId = self.goodsIdInfo:getGoodsPayCodeId()
	

	--之所以这几个三方平台单独拿出来 是因为现在会有goods表里有的商品但goods_pay_code表里没有 即goodsPaycodeMeta可能为空
	--所以这个参数要自己手动构建 之后不用在后台申请计费点的三方支付 都自己构建
	if self.paymentType == Payments.QQ or self.paymentType == Payments.WDJ or self.paymentType == Payments.HUAWEI then 
		paramTable.price = self.totalFee
		paramTable.props = self.goodsName
		goodsParams = luaJavaConvert.table2Map(paramTable)
	elseif self.paymentType == Payments.QIHOO then 
		paramTable.price = self.totalFee
		paramTable.props = self.goodsName
		paramTable.id = goodsPayCodeId
		goodsParams = luaJavaConvert.table2Map(paramTable)
	else
		if self.goodsPaycodeMeta then 
			goodsParams = luaJavaConvert.table2Map(self.goodsPaycodeMeta)
			goodsParams:put("props", self.goodsName)
		end
	end
	if goodsParams then 
		params:put("meta", goodsParams)
	end

	local extraData = {}
	if self.paymentType == Payments.QQ then
        local extendinfo = { 
            platform = self.platform, 
            itemId = tostring(goodsPayCodeId), 
            itemAmount = tostring(self.amount), 
            itemPrice = tostring(self.totalFee * 10), 
            realAmount = tostring(self.amount), 
            curLevel = tostring(UserManager:getInstance().user:getTopLevelId()),
            goodsType = tostring(self.goodsIdInfo:getGoodsType())
        }
        if self.signForThirdPay then 
        	extendinfo.signStr = tostring(self.signForThirdPay)
        end
		extraData.ext = table.serialize(extendinfo)
	end

	if self.paymentType == Payments.CHINA_MOBILE then
		extraData.ext = self.tradeId
	end

	params:put("extraData", luaJavaConvert.table2Map(extraData))
	return params
end

function AndroidSDKPayLogic:doWechatPay()
	local function onFinish(data)
		if not data then
			self.eventDispatcher:dispatchRequestError(-6, "wechat payment network error==0")
		elseif type(data)=="number" then 
			self.eventDispatcher:dispatchRequestError(data, "wechat payment network error=="..data)
		else
			self.paymentDelegate:WXbuy(self.tradeId, data.partnerId, data.prepayId,
								  data.nonceStr, data.timeStamp, data.signStr, 
								  self.callbackProxy) 
		end
	end

    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end 

    local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end

    local function onRequestCancel(evt)
    	evt.target:removeAllEventListeners()
    	if onFinish then onFinish() end
	end

    local function buywithPostLogin()
    	local ip = "127.0.0.1"
	    local http
	    if PaymentManager.getInstance():checkUseNewWechatPay(self.platform) then
	    	print(">>>>>>>>>>>>>>>>>>>>>>>>>>> using doWXOrder v2")--新接入的微信支付接口跟以前不一样了
	    	http = DoWXOrderV2Http.new(true)
	    else
	    	print(">>>>>>>>>>>>>>>>>>>>>>>>>>> using doWXOrder v1")
	    	http = DoWXOrderHttp.new(true)
		end
	    http:addEventListener(Events.kComplete, onRequestFinish)
	    http:addEventListener(Events.kError, onRequestError)
	    http:addEventListener(Events.kCancel, onRequestCancel)
	    http:syncLoad(self.platform, self.signForThirdPay, self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, self.totalFee * 100, ip)
	end

	local function onUserNotLogin()
    	if onFinish then onFinish(-6) end
    end

	RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doQQWalletPay()
	local function onFinish(data)
		if not data then
			self.eventDispatcher:dispatchRequestError(-6, "wechat payment network error==0")
		elseif type(data)=="number" then 
			self.eventDispatcher:dispatchRequestError(data, "wechat payment network error=="..data)
		else
			self.paymentDelegate:QQWalletBuy(
                                                data.tokenId, 
                                                self.tradeId, 
                                                data.pubAcc,
                                                data.nonce,
                                                data.timeStamp,
                                                data.bargainorId,
                                                data.sigType,
                                                data.sig, 
								                self.callbackProxy
                                            ) 
		end
	end

    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end 

    local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end

    local function onRequestCancel(evt)
    	evt.target:removeAllEventListeners()
    	if onFinish then onFinish() end
	end

    local function buywithPostLogin()
        local http = DoQQPaymentOrder.new(true)
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:addEventListener(Events.kCancel, onRequestCancel)
        http:syncLoad(
                        self.platform, 
                        self.signForThirdPay, 
                        self.tradeId, 
                        self.goodsIdInfo:getGoodsPayCodeId(), 
                        self.goodsIdInfo:getGoodsType(), 
                        self.amount, 
                        self.goodsName, 
                        self.totalFee * 100
                    )
	end

	local function onUserNotLogin()
    	if onFinish then onFinish(-6) end
    end

	RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doWechatQuickPay()
    print('wenkan AndroidSDKPayLogic:doWechatQuickPay')
    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        self.eventDispatcher:dispatchWechatQuickPaySuccess()
    end

    local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        local errCode = tonumber(evt.data) or 0
        if errCode == 730241 or errCode == 731307 then --已经解约
            UserManager.getInstance().userExtend.wxIngameState = 2
            UserService.getInstance().userExtend.wxIngameState = 2
            if NetworkConfig.writeLocalDataStorage then 
                Localhost:getInstance():flushCurrentUserData()
            else 
                print("Did not write user data to the device.") 
            end
        elseif errCode == 731308 then -- 支付达到上限
            UserManager.getInstance():getDailyData():setWxPayCount(5)
            UserService.getInstance():getDailyData():setWxPayCount(5)
        end
        local errMessage = localize('error.tip.'..errCode)
        self.eventDispatcher:dispatchRequestError(errCode, errMessage, Payments.WECHAT_QUICK_PAY)
    end

    local function onRequestCancel(evt)
        evt.target:removeAllEventListeners()
        self.eventDispatcher:dispatchRequestError(-6, "ali.quick.pay.error==0", Payments.WECHAT_QUICK_PAY)
    end

    local function buywithPostLogin()
        local http = WxIngame.new(true)
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:addEventListener(Events.kCancel, onRequestCancel)
        local totalFee = self.totalFee
        -- if isLocalDevelopMode then
        --     totalFee = 0.01
        -- end
        print('wenkan totalFee', totalFee)
        http:syncLoad(self.tradeId, self.platform, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, totalFee, self.signForThirdPay)
    end

    local function onUserNotLogin()
        self.eventDispatcher:dispatchRequestError(-6, "ali quick payment network error", Payments.WECHAT_QUICK_PAY)
    end

    RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doAliSignAndPay()
    print('wenkan doAliSignAndPay')
    local function onRequestFinish()
        print('wenkan doAliSignAndPay onRequestFinish')
        self.eventDispatcher:dispatchAliSignAndPaySuccess()
    end

    local function onRequestError()
        print('wenkan doAliSignAndPay onRequestError')
        -- local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"
        -- local errMessage = AliQuickPayGuide.getErrorMessage(evt.data, "ali.quick.pay.error")
        self.eventDispatcher:dispatchRequestError(-6, "ali.quick.pay.error==0", Payments.ALI_SIGN_PAY)
    end

    local function onRequestCancel()
        print('wenkan doAliSignAndPay onRequestCancel')
        self.eventDispatcher:dispatchRequestError(-6, "ali.quick.pay.error==0", Payments.ALI_SIGN_PAY)
    end

    local function buywithPostLogin()
        AliAppSignAndPayLogic:getInstance():start(self.platform, self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, self.totalFee, self.signForThirdPay, onRequestFinish, onRequestError, onRequestCancel)
    end

    RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, function () setTimeOut(onRequestError, 2) end)
end

function AndroidSDKPayLogic:doAliQuickPay()
    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        self.eventDispatcher:dispatchAliQuickPaySuccess()
    end

	local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        local errCode = tonumber(evt.data)
        if errCode == 730241 then --已经解约
        	UserManager.getInstance().userExtend.aliIngameState = 2
			UserService.getInstance().userExtend.aliIngameState = 2
			if NetworkConfig.writeLocalDataStorage then 
				Localhost:getInstance():flushCurrentUserData()
			else 
				print("Did not write user data to the device.") 
			end
        end
        local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"
        local errMessage = AliQuickPayGuide.getErrorMessage(evt.data, "ali.quick.pay.error")
        self.eventDispatcher:dispatchRequestError(errCode, errMessage, Payments.ALI_QUICK_PAY)
    end

    local function onRequestCancel(evt)
    	evt.target:removeAllEventListeners()
    	self.eventDispatcher:dispatchRequestError(-6, "ali.quick.pay.error==0", Payments.ALI_QUICK_PAY)
	end

    local function buywithPostLogin()
    	local http = GetAliIngamePayment.new(true)
	    http:addEventListener(Events.kComplete, onRequestFinish)
		http:addEventListener(Events.kError, onRequestError)
		http:addEventListener(Events.kCancel, onRequestCancel)
	    http:syncLoad(self.tradeId, self.platform, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, self.totalFee, self.signForThirdPay)
    end

	local function onUserNotLogin()
    	self.eventDispatcher:dispatchRequestError(-6, "ali quick payment network error", Payments.ALI_QUICK_PAY)
    end

    RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doAliPay()
	local function onFinish(data)
		if not data then
			self.eventDispatcher:dispatchRequestError(-6, "ali payment network error==0")
		elseif type(data)=="number" then 	
			self.eventDispatcher:dispatchRequestError(data, "ali payment network error=="..data)
		else		
			self.paymentDelegate:ALIbuy(self.tradeId, data.signStr, self.callbackProxy)
		end
	end

    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end

    local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end

    local function onRequestCancel(evt)
    	evt.target:removeAllEventListeners()
    	if onFinish then onFinish() end
	end

    local function buywithPostLogin()
    	local http = DoAliOrderHttp.new(true)
	    http:addEventListener(Events.kComplete, onRequestFinish)
	    http:addEventListener(Events.kError, onRequestError)
	    http:addEventListener(Events.kCancel, onRequestCancel)
	    http:syncLoad(self.platform, self.signForThirdPay, self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, self.totalFee)
	end

	local function onUserNotLogin()
    	if onFinish then onFinish(-6) end
    end

	RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doQQPay()
	local function onFinish(data, isLogin)
		if not data then
			self.eventDispatcher:dispatchRequestError(-6, "qq payment network error==0")
		elseif type(data)=="number" then 
			self.eventDispatcher:dispatchRequestError(data, "qq payment network error=="..data)
		else	
			local params = self:buildPaymentParams()
			self.paymentDelegate:buyWithToken(self.tradeId, params, data.tokenUrl, isLogin, self.callbackProxy)
		end
	end

	local function sendOrderInfoToServer(openId, accessToken, payToken, pf, pfKey, isLogin)
	    local function onRequestFinish(evt)
	        evt.target:removeAllEventListeners()
	        if onFinish then onFinish(evt.data, isLogin) end
	    end 

	    local function onRequestError(evt)
	        evt.target:removeAllEventListeners()
	        if onFinish then onFinish(evt.data) end
	    end

	    local function onRequestCancel(evt)
	    	evt.target:removeAllEventListeners()
	    	if onFinish then onFinish() end
		end

	    local http = DoMSDKOrderHttp.new(true)
	    local platform = StartupConfig:getInstance():getPlatformName()

	    http:addEventListener(Events.kComplete, onRequestFinish)
	    http:addEventListener(Events.kError, onRequestError)
	    http:addEventListener(Events.kCancel, onRequestCancel)

	    http:syncLoad(self.platform, self.signForThirdPay, self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, 
	    		self.totalFee * 100, openId, accessToken, payToken, pf, pfKey, isLogin)
	end

	-- 目前应用宝平台登录走老版（新版不支持离线） 支付走新版（新版支付免QQ登录）
	local function buywithPostLogin()
		local openId = UserManager:getInstance().uid or "12345"
		local loginCache = SnsProxy:getAccountInfo()
		if loginCache and loginCache.openId and loginCache.openId ~= "" then 
			openId = loginCache.openId
		end
	   	sendOrderInfoToServer(openId, "openkey", "paytoken", "desktop_m_guest-2001-android-2001", "pfkey", false)
	end

    local function onUserNotLogin()
    	if onFinish then onFinish(-6) end
    end

	RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doHuaweiPay()
	local function onFinish(data)
		if not data then
			self.eventDispatcher:dispatchRequestError(-6, "wechat payment network error==0")
		elseif type(data)=="number" then 
			self.eventDispatcher:dispatchRequestError(data, "wechat payment network error=="..data)
		else
			local params = self:buildPaymentParams()
			self.paymentDelegate:huaweiBuy(self.tradeId, data.signStr, params, self.callbackProxy) 
		end
	end

    local function onRequestFinish(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end 

    local function onRequestError(evt)
        evt.target:removeAllEventListeners()
        if onFinish then onFinish(evt.data) end
    end

    local function onRequestCancel(evt)
    	evt.target:removeAllEventListeners()
    	if onFinish then onFinish() end
	end

    local function buywithPostLogin()
	    local http = DoHuaweiOrderHttp.new(true)
	    http:addEventListener(Events.kComplete, onRequestFinish)
	    http:addEventListener(Events.kError, onRequestError)
	    http:addEventListener(Events.kCancel, onRequestCancel)
	    http:syncLoad(self.platform, self.signForThirdPay, self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount, self.goodsName, self.totalFee * 100)
	end

	local function onUserNotLogin()
    	if onFinish then onFinish(-6) end
    end

	RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
end

function AndroidSDKPayLogic:doGeneralPay()
	if AndroidPayment.getInstance():isNeedPreOrder(self.paymentType) then
		local function onFinish(data) 
			if data and type(data)=="number" then 
				self.eventDispatcher:dispatchRequestError(data, "do generalpay network error=="..data)
			else	
				local params = self:buildPaymentParams()
				self.paymentDelegate:buy(self.tradeId, params, self.callbackProxy) 
			end
		end

	    local function onRequestFinish(evt)
	        evt.target:removeAllEventListeners()
	        if onFinish then onFinish() end
	    end 

		local function onRequestError(evt)
	        evt.target:removeAllEventListeners()
	        if onFinish then onFinish(evt.data) end
	    end

	    local function onRequestCancel(evt)
	        evt.target:removeAllEventListeners()
	        if onFinish then onFinish(-6) end
	    end

	    local function buywithPostLogin()
		    local http = DoOrderHttp.new(true)
		    http:addEventListener(Events.kComplete, onRequestFinish)
		    http:addEventListener(Events.kError, onRequestError)
		    http:addEventListener(Events.kCancel, onRequestCancel)
		    http:syncLoad(self.tradeId, self.goodsIdInfo:getGoodsPayCodeId(), self.goodsIdInfo:getGoodsType(), self.amount)
		end

		local function onUserNotLogin()
	    	if onFinish then onFinish(-6) end
	    end

		RequireNetworkAlert:callFuncWithLogged(buywithPostLogin, onUserNotLogin, -999)
	else
		local params = self:buildPaymentParams()
		self.paymentDelegate:buy(self.tradeId, params, self.callbackProxy) 
	end
end

function AndroidSDKPayLogic:create(paymentType, paymentDelegate, tradeId, goodsIdInfo, amount, totalFee)
	local logic = AndroidSDKPayLogic.new()
	logic.paymentType = paymentType
	logic.paymentDelegate = paymentDelegate
	logic.tradeId = tradeId
	logic.goodsIdInfo = goodsIdInfo
	logic.amount = amount or 1
	logic.totalFee = totalFee

	logic:init()
	return logic
end