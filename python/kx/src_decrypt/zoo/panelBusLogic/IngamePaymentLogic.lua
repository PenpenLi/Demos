require 'zoo.panel.ChoosePaymentPanel'
require 'hecore.sns.aps.AndroidPayment'
require "zoo.panelBusLogic.PaymentLimitLogic"

IngamePaymentDecisionType = table.const {
	kPayWithType = 1,
	kChoosePayment = 2,
	kPayFailed = 3,
}



IngamePaymentLogic = class()

function IngamePaymentLogic:create(goodsId, goodsType)
	local logic = IngamePaymentLogic.new()
	if logic:init(goodsId, goodsType) then
		return logic
	else
		logic = nil
		return nil
	end
end

function IngamePaymentLogic:init(goodsId, goodsType)
	self.goodsId = goodsId
	self.goodsType = goodsType or 1
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	self.items = {}
	for __, v in ipairs(meta.items) do table.insert(self.items, {itemId = v.itemId, num = v.num}) end

	local user = UserManager:getInstance().user
	local stageInfo = StageInfoLocalLogic:getStageInfo(user.uid );
	self.levelId = -1
	if stageInfo then
		self.levelId = stageInfo.levelId
	end
	local goodsPayCodeId = self.goodsType == 2 and self.goodsId + 10000 or self.goodsId
	self.goodsMeta = MetaManager:getGoodPayCodeMeta(goodsPayCodeId)
	self.amount = 1

	return true
end

function IngamePaymentLogic:buildPaymentCallback(successCallback, failCallback, cancelCallback, showLoadingAnim)
	local paymentCallback = {}
	paymentCallback.onSuccess = function(para)
		local function onSuccess()
			UserManager:getInstance():getUserExtendRef().payUser = true
			UserService:getInstance():getUserExtendRef().payUser = true
			UserManager:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
			UserService:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
			self:deliverItems()
			if NetworkConfig.writeLocalDataStorage then 
				Localhost:getInstance():flushCurrentUserData()
			else 
				print("RRR Did not write user data to the device.") 
			end
			SyncManager:getInstance():sync(nil, nil, false)
			if successCallback then successCallback() end
			-- Q点不提示
 			if self.paymentType ~= Payments.QQ then
				GlobalEventDispatcher:getInstance():dispatchEvent(
					Event.new(kGlobalEvents.kConsumeComplete,{ price = self.goodsMeta.price, props = self.goodsMeta.props})
				)
			end
		end
		local function onFail(evt)
			if failCallback then failCallback(evt) end
		end

		if self.paymentType==Payments.QQ then
			--QQ后端加道具 不走Ingame 也不用check
			Localhost.getInstance():ingame(self.goodsId, para.orderId, para.channelId, self.goodsType) -- 前端server加道具
			onSuccess()
		elseif PlatformConfig:isNeedOrderSuccessCheck(self.paymentType) then -- 强联网支付需要向后端查下订单是否成功，不需要走ingame逻辑
			local function payCheckSuccess()
				Localhost.getInstance():ingame(self.goodsId, para.orderId, para.channelId, self.goodsType) -- 前端server加道具
				onSuccess()
			end

			local function payCheckFailed(errCode,errMsg)
				if failCallback then failCallback(errMsg) end
			end
			self:checkOnlinePay(para.tradeId, payCheckSuccess, payCheckFailed)
		else
			local http = IngameHttp.new(showLoadingAnim)
			http:ad(Events.kComplete, onSuccess)
			http:ad(Events.kError, onFail)
			if para.channelId ~= PlatformNameEnum.kVivo then
				local detail = para.detail
					if detail and type(detail) == "table" then
					detail = table.serialize(detail)
				end
			end
			http:load(self.goodsId, para.orderId, para.channelId, self.goodsType, detail, para.tradeId)

			if PaymentLimitLogic:isNeedLimit(self.paymentType) then 
				PaymentLimitLogic:buyComplete(self.paymentType, self.goodsMeta.price)
			end
		end
	end
	paymentCallback.onError = function(errCode, errMsg)
		if failCallback then failCallback(errMsg) end
	end
	paymentCallback.onCancel = function(...)
		if cancelCallback then cancelCallback(...) end
	end
	return paymentCallback
end

function IngamePaymentLogic:buy(successCallback, failCallback, cancelCallback, showLoadingAnim)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end
	
	self.paymentCallback = self:buildPaymentCallback(successCallback, failCallback, cancelCallback, showLoadingAnim)

	local decision, paymentType = self:getPaymentDecision()

	self:handlePaymentDecision(self.goodsMeta, self.amount, self.paymentCallback, decision, paymentType)
end

------------------------------------------------
-- return value
-- 	arg1 : IngamePaymentDecisionType enum
--	arg2 : paymentType when arg1 is IngamePaymentDecisionType.kPayWithType
------------------------------------------------
function IngamePaymentLogic:getPaymentDecision()

	if PlatformConfig:getCurrentPayType()==PlatformPayType.kWechat 
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kAlipay then 
		return self:getThirdPartPaymentDecision()
	else
		local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
		if thirdPartPayment == PlatformPaymentThirdPartyEnum.kWO3PAY then
			-- 如果是联通三网集成方式，直接发起支付，由于把三网集成归类为三方支付，只能可耻地这么做了
			local operator = AndroidPayment.getInstance():getOperator()
			if operator == TelecomOperators.CHINA_MOBILE or 
			   operator == TelecomOperators.CHINA_UNICOM or
			   operator == TelecomOperators.CHINA_TELECOM then
				return self:getThirdPartPaymentDecision()
			else
				return IngamePaymentDecisionType.kChoosePayment
			end
		elseif thirdPartPayment == PlatformPaymentThirdPartyEnum.kMI then
			-- 如果是米币支付方式，直接发起支付，由于把三网集成归类为三方支付，只能可耻地这么做了
			return self:getThirdPartPaymentDecision()
		elseif thirdPartPayment == PlatformPaymentThirdPartyEnum.kVIVO then
			return self:getThirdPartPaymentDecision()
		else
			if self:isThirdPartPaymentOnly(self.goodsMeta) then
				-- 如果是大额支付点，使用三方支付
				return self:getThirdPartPaymentDecision()
			else
				local isSmsPaymentSupported = AndroidPayment.getInstance():isSmsPaymentSupported()
				if isSmsPaymentSupported then 
					-- if PlatformConfig:isBaiduPlatform() then 
					-- 	-- if AndroidPayment.getInstance():getOperator() == TelecomOperators.CHINA_MOBILE then
					-- 	-- 	return self:getSMSPaymentDecision()
					-- 	-- else
					-- 	-- 	return self:getThirdPartPaymentDecision()
					-- 	-- end
					-- 	return self:getThirdPartPaymentDecision()
					-- else 
						return self:getSMSPaymentDecision()
					-- end
				else -- 如果不支持任何短贷支付方式
					return IngamePaymentDecisionType.kChoosePayment
				end
			end
		end
	end
end

function IngamePaymentLogic:getThirdPartPaymentDecision()
	local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
	if not thirdPartPayment or thirdPartPayment == Payments.UNSUPPORT then
		return IngamePaymentDecisionType.kPayFailed
	else
		return IngamePaymentDecisionType.kPayWithType, thirdPartPayment
	end
end

function IngamePaymentLogic:isThirdPartPaymentOnly( goodsMeta )
	return self.goodsType == 2 and tonumber(goodsMeta.price) >= 30
end

function IngamePaymentLogic:doOrder(tradeId, goodsId, goodsType, amount, onFinish)
    local function onRequestError( evt )
        evt.target:removeAllEventListeners()
        print("onRequestError callback")
        if onFinish then onFinish() end
    end
    local function onRequestFinish( evt )
        evt.target:removeAllEventListeners()
        print("onRequestFinish callback:tradeId="..tostring(tradeId))
        if onFinish then onFinish(tradeId) end
    end 

    local http = DoOrderHttp.new()
    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(tradeId, goodsId, goodsType, amount)
end

function IngamePaymentLogic:doWXOrder(tradeId, goodsId, goodsType, amount, goodsName, totalFee, onFinish)
	local scene = Director:sharedDirector():getRunningScene()
	local animation

    local function onRequestError( evt )
        evt.target:removeAllEventListeners()
        print("DoWXOrderHttp onRequestError callback")
        animation:removeFromParentAndCleanup(true)
        if onFinish then onFinish(evt.data) end
    end
    local function onRequestFinish( evt )
        evt.target:removeAllEventListeners()
        print("DoWXOrderHttp onRequestFinish callback:tradeId="..tostring(tradeId))
        animation:removeFromParentAndCleanup(true)
        if onFinish then onFinish(evt.data) end
    end 

    local http = DoWXOrderHttp.new()
    local platform = StartupConfig:getInstance():getPlatformName()
    local ip = "127.0.0.1"

    local function onCloseButtonTap()
    	http:removeAllEventListeners()
    	animation:removeFromParentAndCleanup(true)
    	if onFinish then onFinish() end
	end
    animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
	scene:addChild(animation)

    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(platform, tradeId, goodsId, goodsType, amount, goodsName, totalFee, ip)
end

function IngamePaymentLogic:doAliOrder(tradeId, goodsId, goodsType, amount, goodsName, totalFee, onFinish)
	local scene = Director:sharedDirector():getRunningScene()
	local animation

    local function onRequestError( evt )
        evt.target:removeAllEventListeners()
        print("DoALIOrderHttp onRequestError callback")
        animation:removeFromParentAndCleanup(true)
        if onFinish then onFinish(evt.data) end
    end
    local function onRequestFinish( evt )
        evt.target:removeAllEventListeners()
        print("DoALIOrderHttp onRequestFinish callback:tradeId="..tostring(tradeId))
        animation:removeFromParentAndCleanup(true)
        if onFinish then onFinish(evt.data) end
    end 

    local http = DoAliOrderHttp.new()
    local platform = StartupConfig:getInstance():getPlatformName()

    local function onCloseButtonTap()
    	http:removeAllEventListeners()
    	animation:removeFromParentAndCleanup(true)
    	if onFinish then onFinish() end
	end
    animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
	scene:addChild(animation)

    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(platform, tradeId, goodsId, goodsType, amount, goodsName, totalFee)
end

function IngamePaymentLogic:buildPaymentParams(paymentType, goodsType, goodsMeta, amount)
	-- goodsMeta.price = 0.01 -- for test
	local params = luajava.newInstance("java.util.HashMap")
	params:put("uid", UserManager:getInstance().uid)
	params:put("amount", amount)

	local goodsParams = luaJavaConvert.table2Map(goodsMeta)
	-------------------------
	-- TODO
	-- 360和豌豆荚,QQ支付购买回退一步价格应为2元
	-------------------------
	local priceNeedFix = paymentType == Payments.QIHOO or paymentType == Payments.WDJ or paymentType == Payments.QQ or paymentType == Payments.MDO
	if priceNeedFix and goodsMeta.id == 2 then
		-- if goodsMeta.price then
			-- local priceInt = math.floor(tonumber(goodsMeta.price))
			goodsParams:put("price", "2")
		-- end
	end
	params:put("meta", goodsParams)

	local extraData = {}
	if paymentType == Payments.QQ then
        local extendinfo = { 
            platform = StartupConfig:getInstance():getPlatformName(), 
            itemId = tostring(goodsMeta.id), 
            itemAmount = tostring(amount), 
            itemPrice = tostring(goodsMeta.price * 10), 
            realAmount = tostring(amount), 
            curLevel = tostring(UserManager:getInstance().user:getTopLevelId()),
            goodsType = tostring(goodsType)
        }
		extraData.ext = table.serialize(extendinfo)
	end

	if paymentType == Payments.CHINA_MOBILE then
		local uid = UserManager:getInstance().uid or ""
		if string.len(uid) > 15 then
			uid = "0"
		end
		extraData.ext = uid
	end

	params:put("extraData", luaJavaConvert.table2Map(extraData))
	return params
end

local paymentProxy
function IngamePaymentLogic:buyWithPaymentType(paymentType, goodsType, goodsMeta, amount, callback)
	print("buyWithPaymentType:" .. paymentType)
	self.paymentType = paymentType

	amount = amount or 1
	if not paymentProxy then
		paymentProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSPaymentProxy"):getInstance()
	end
	paymentProxy:setPaymentType(paymentType)
	local paymentDelegate = paymentProxy:getPaymentDelegate()
	if not paymentDelegate then
		callback.onError(0, "RRR  PaymentType not registered!")
		return
	end
	local tradeId = paymentDelegate:generateOrderId()
	DcUtil:payStart(paymentType,tradeId,self.goodsId,goodsType)

	local onButton1Click = function()
		local function buySuccess(result)
			if callback then callback.onSuccess(luaJavaConvert.map2Table(result)) end

			DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,0)
		end
		local function buyError(errCode, errMsg)
			if paymentType == Payments.WDJ and errCode == 1 then
				-- 豌豆荚，选择话费支付
				self:smsPay(goodsMeta, amount, callback)
			elseif paymentType == Payments.QIHOO then
				if errCode == -2 then 
					-- 360 支付正在进行中，轮询支付结果
					self:waitForQihooOrderFinish(tradeId, callback)
				elseif errCode == 4010201 then 
					--access token失效 提示重新登录
					callback.onCancel()
					CommonTip:showTip(Localization:getInstance():getText("本次支付失败，请在联网状态下重新登录。"), "negative")
				elseif errCode == 4009911 then 
					--QT失效 提示重新登录
					callback.onCancel()
					CommonTip:showTip(Localization:getInstance():getText("本次支付失败，请在联网状态下重新登录。"), "negative")
				else
					if callback then callback.onError(errCode, errMsg) end
				end
			else
				if callback then callback.onError(errCode, errMsg) end
			end

			DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,errCode)
		end
		local function buyCancel(isExceedLimit)
			if callback then callback.onCancel(isExceedLimit) end

			DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,2)
		end
		local callbackProxy = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = buySuccess,
	        onError = buyError,
	        onCancel = buyCancel
	    })

		if PaymentLimitLogic:isNeedLimit(paymentType) then 
			local supportedPayments = {}
			if PlatformConfig:isMarketAliPaySupport() then 
				supportedPayments[Payments.ALIPAY] = true
			end
			if PlatformConfig:isMarketWechatPaySupport() then 
				supportedPayments[Payments.WECHAT] = true
			end
			local thirdPartPayment = AndroidPayment.getInstance():getNormalThirdPartPayment()
			if thirdPartPayment ~= Payments.UNSUPPORT then  
				supportedPayments[thirdPartPayment] = true
			end

			if PaymentLimitLogic:isExceedMonthlyLimit(paymentType) then
				if table.size(supportedPayments) > 0 then 
					self:choosePaymentToPay(supportedPayments, goodsMeta, amount, callback,
						Localization:getInstance():getText("payment.Limit.title.2")
					)
					--"本月话费支付已达上限，请您选择以下支付方式"
				else
					CommonTip:showTip(Localization:getInstance():getText("payment.Limit.tip.2"),"negative")
						-- "您本月已超运营商短代限额，花钱太多也不好哟~下月才能支付啦~"
					buyCancel(true)
				end
				return
			elseif PaymentLimitLogic:isExceedDailyLimit(paymentType) then 
				if table.size(supportedPayments) > 0 then 
					self:choosePaymentToPay(supportedPayments, goodsMeta, amount, callback,
						Localization:getInstance():getText("payment.Limit.title.1")
					)
					-- "今日话费支付已达上限，请您选择以下支付方式"					
				else
					-- "您今天已超运营商短代限额，花钱太多也不好哟~明天再来吧~"
					CommonTip:showTip(Localization:getInstance():getText("payment.Limit.tip.1"),"negative")
					buyCancel(true)
				end
				return
			end
		end

		if paymentType==Payments.WECHAT then 
			local function onFinish(data)
				if not data then
					callback.onError(0, "wechat payment network error")

					DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,0)
				elseif type(data)~="table" then 
					if data==-6 then					
						CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
						callback.onCancel()
						print("wechat payment network error")

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,2)
					else
						callback.onError(1, "wechat payment network error")

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,1)
					end
				else
					if data.errCode then
						callback.onError(data.errCode, data.errMsg)

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,data.errCode)
					else				
						paymentDelegate:WXbuy(tradeId, data.partnerId, data.prepayId,
											  data.nonceStr, data.timeStamp, data.signStr, 
											  callbackProxy) 
					end 
				end
			end
			self:doWXOrder(tradeId, goodsMeta.id, goodsType, amount, goodsMeta.props, goodsMeta.price*100, onFinish)
		elseif paymentType==Payments.ALIPAY then
			local function onFinish(data)
				if not data then
					callback.onError(0, "ali payment network error")

					DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,0)
				elseif type(data)~="table" then 
					if data==-6 then					
						CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
						callback.onCancel()
						print("ali payment network error")

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,2)
					else
						callback.onError(1, "ali payment network error")

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,1)
					end
				else
					if data.errCode then
						callback.onError(data.errCode, data.errMsg)

						DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,1,data.errCode)
					else				
						paymentDelegate:ALIbuy(tradeId, data.signStr, callbackProxy)
					end 
				end
			end
			self:doAliOrder(tradeId, goodsMeta.id, goodsType, amount, goodsMeta.props, goodsMeta.price, onFinish)
		elseif paymentType==Payments.VIVO then

			local params = self:buildPaymentParams(paymentType, goodsType, goodsMeta, amount)
			if AndroidPayment.getInstance():isNeedPreOrder(paymentType) then
				local function onFinish() 
					paymentDelegate:buy(tradeId, params, callbackProxy) 
				end
				self:doOrder(tradeId, goodsMeta.id, goodsType, amount, onFinish)
			else
				paymentDelegate:buy(tradeId, params, callbackProxy) 
			end
		else
			local sendPaymentRequest = function()
				local params = self:buildPaymentParams(paymentType, goodsType, goodsMeta, amount)
				if AndroidPayment.getInstance():isNeedPreOrder(paymentType) then
					local function onFinish() 
						paymentDelegate:buy(tradeId, params, callbackProxy) 
					end
					self:doOrder(tradeId, goodsMeta.id, goodsType, amount, onFinish)
				else
					paymentDelegate:buy(tradeId, params, callbackProxy) 
				end
			end

			local canelPayment = function()
				callback.onCancel()

				DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,2)
			end

			-- local operator = AndroidPayment.getInstance():getOperator()
			-- if operator == TelecomOperators.CHINA_MOBILE then
			if paymentType == Payments.CHINA_MOBILE  or paymentType == Payments.DUOKU then
				local isSkipConfirm = MaintenanceManager:getInstance():isEnabled("SecPayPanel")
				if not isSkipConfirm then
					local p = require("zoo.panel.BuyPropsConfirmPanel"):create(self.goodsId, goodsType, goodsMeta, sendPaymentRequest, canelPayment, self._ignoreSecondConfirm)
					p:popout()
				else
					sendPaymentRequest()
				end
			else
				sendPaymentRequest()
			end
			
		end
	end

	local onButton2Click = function()
		if callback and callback.onCancel then 
			callback.onCancel() 
		end

		DcUtil:payEnd(paymentType,tradeId,self.goodsId,goodsType,2)
	end

	if PrepackageUtil:checkIsSMSPayment(paymentType) then
		CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,
											 NotRemindFlag.SMS_ALLOW,
											 Localization:getInstance():getText("pre.tips.sms"),
											 nil,nil,
											 onButton2Click);
	else
		onButton1Click()
	end
end

function IngamePaymentLogic:getSMSPaymentDecision()
	local defaultSmsPayment = AndroidPayment.getInstance():getDefaultSmsPayment()
	if defaultSmsPayment then -- 有sim卡
		if defaultSmsPayment == Payments.UNSUPPORT then -- 不支持的运营商
			return IngamePaymentDecisionType.kChoosePayment
		else
			return IngamePaymentDecisionType.kPayWithType, defaultSmsPayment
		end
	else -- 无卡或者未知种类
		return IngamePaymentDecisionType.kChoosePayment
	end
end

function IngamePaymentLogic:smsPay(goodsMeta, amount, callback)	
	local decision, paymentType = self:getSMSPaymentDecision()
	self:handlePaymentDecision(goodsMeta, amount, callback, decision, paymentType)
end

function IngamePaymentLogic:handlePaymentDecision(goodsMeta, amount, callback, decision, paymentType)
	if decision == IngamePaymentDecisionType.kPayWithType then
		assert(paymentType)
		self:buyWithPaymentType(paymentType, self.goodsType, goodsMeta, amount, callback)
	elseif decision == IngamePaymentDecisionType.kChoosePayment then
		local supportedPayments = AndroidPayment.getInstance():getPaymentsChoosement() 
		self:choosePaymentToPay(supportedPayments, goodsMeta, amount, callback)
	elseif decision == IngamePaymentDecisionType.kPayFailed then
		if callback.onError then callback.onError(nil, "No payment type supported") end
	else
		assert("Unexcepted payment decision " .. decision .. ", " .. paymentType)
	end
end

function IngamePaymentLogic:waitForQihooOrderFinish(orderId, callback)
	local tips = Localization:getInstance():getText("tips.in.pay.not.finish")
    if __ANDROID then AlertDialogImpl:toast(tips) end

    local retry = 3
    local interval = 2

    function queryQihooOrderState()
        -- body
        print("queryQihooOrderState.."..tostring(retry))
        local function onRequestError( evt )
            evt.target:removeAllEventListeners()
            print("onRequestError callback")
            if retry > 0 then
           	 	setTimeOut(queryQihooOrderState, interval)
           	else
            	callback.onError(0, "purchase failed")
        	end
        end
        local function onRequestFinish( evt )
            evt.target:removeAllEventListeners()
            print("onRequestFinish callback")
            if evt.data and evt.data.finished then
                if evt.data.success then
                	local ret = {orderId = orderId, tradeId = orderId, channelId = "360"}
                    callback.onSuccess(ret)
                elseif retry > 0 then
           	 		setTimeOut(queryQihooOrderState, interval)
                else
                    callback.onError(0, "purchase failed")
                end
            else
                callback.onError(1, "purchase failed")
            end
        end

        local http = QueryQihooOrderHttp.new()
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:load(orderId)

        interval = interval * 2
        retry = retry - 1
    end

    setTimeOut(queryQihooOrderState, interval)
end

function IngamePaymentLogic:checkOnlinePay(orderId, successCallback, failedCallback)
	local tips = Localization:getInstance():getText("tips.in.pay.not.finish")
    --if __ANDROID then AlertDialogImpl:toast(tips) end

    local retry = 3
    local interval = 2

    function queryOnlinePayState()
        print("queryOnlinePayState.."..tostring(retry))
        local function onRequestError( evt )
            evt.target:removeAllEventListeners()
            print("onRequestError callback")
            if retry > 0 then
           	 	setTimeOut(queryOnlinePayState, interval)
           	else
            	failedCallback(0, "purchase failed")
        	end
        end
        local function onRequestFinish( evt )
            evt.target:removeAllEventListeners()
            print("onRequestFinish callback")
            if evt.data and evt.data.finished then
                if evt.data.success then
					successCallback()
                else
                    failedCallback(0, "purchase failed")
                end
            else
                if retry > 0 then
           	 		setTimeOut(queryOnlinePayState, interval)
                else
                    failedCallback(1, "purchase failed")
                end
            end
        end

        local http = QueryQihooOrderHttp.new()
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:load(orderId)

        interval = interval * 2
        retry = retry - 1
    end

    queryOnlinePayState()
end

function IngamePaymentLogic:choosePaymentToPay(supportedPayments, goodsMeta, amount, callback, title)

	local function thirdPartPay()
		local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
		if not thirdPartPayment or thirdPartPayment == Payments.UNSUPPORT then
			if failCallback then failCallback("No payment type supported") end
		else
			self:buyWithPaymentType(thirdPartPayment, self.goodsType, goodsMeta, amount, callback)
		end
	end

	if supportedPayments and table.size(supportedPayments) > 0 then
		local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
		local numPayments = table.size(supportedPayments)
		if numPayments == 1 and supportedPayments[thirdPartPayment] then -- 只有唯一个三方支付方式可选时，直接调用这个三方支付
	    	thirdPartPay()
		else
			local panel = ChoosePaymentPanel:create(supportedPayments,title)
			local function onChoosen(choosenType)
				if choosenType then
					self:buyWithPaymentType(choosenType, self.goodsType, self.goodsMeta, amount, callback)
				else
					if callback then callback.onCancel() end
				end
			end
			if panel then panel:popout(onChoosen) end
		end
	else
		CommonTip:showTip(Localization:getInstance():getText('panel.choosepayment.unsupport.tips'), 'negative', nil, 3)
		if callback then callback.onCancel() end
	end
end

function IngamePaymentLogic:deliverItems()
	if self.goodsType == 1 then 
		self:updatePropCount()
		--
		local price = MetaManager:getGoodPayCodeMeta(self.goodsId).price
		local meta = MetaManager:getGoodMeta(self.goodsId)
		local rmb = meta.discountRmb > 0 and meta.discountRmb or meta.rmb
		DcUtil:logBuyCashItem(self.goodsId,price,1, UserManager:getInstance().user:getCash(), self.levelId,rmb)
	end -- items 
	-- 更新本日购买列表
	print("Update buyed list")
	local meta = MetaManager:getInstance():getGoodMeta(self.goodsId)
	if meta and meta.limit > 0 then
		UserManager:getInstance():addBuyedGoods(self.goodsId, 1)
		UserService.getInstance():addBuyedGoods(self.goodsId, 1)
	end
end

function IngamePaymentLogic:updatePropCount()
	local manager = UserManager:getInstance()

	-- 加东西
	for __, v in ipairs(self.items) do
		if ItemType:isItemNeedToBeAdd(v.itemId) then
			manager:addUserPropNumber(v.itemId, v.num)
			DcUtil:logRewardItem("buy", v.itemId, v.num, self.levelId)
		end
	end
end

function IngamePaymentLogic:itemNotToBeAdded(itemId)
	local itemType = math.floor(itemId / 10000)
	print("itemType = ", itemType)
	if itemType == 1 then return false end
	return true
end

function IngamePaymentLogic:ignoreSecondConfirm(value)
	self._ignoreSecondConfirm = value
end