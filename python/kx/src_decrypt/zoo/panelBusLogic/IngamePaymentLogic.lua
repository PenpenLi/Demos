require "zoo.payment.PaymentManager"
require "zoo.payment.PaymentDCUtil"
require "zoo.payment.PaymentEventDispatcher"
require "zoo.payment.RmbConfirmPanel"
require "zoo.payment.WindMillConfirmPanel"
require 'zoo.panel.ChoosePaymentPanel'
require 'hecore.sns.aps.AndroidPayment'
require "zoo.panelBusLogic.PaymentLimitLogic"
require 'zoo.gameGuide.ThirdPayGuideLogic'

IngamePaymentLogic = class()

function IngamePaymentLogic:create(goodsId, goodsType, uniquePayId)
	local logic = IngamePaymentLogic.new()
	if logic:init(goodsId, goodsType, uniquePayId) then
		return logic
	else
		logic = nil
		return nil
	end
end
-- goodsType: 1: 要买的是普通道具
--            2: 要买的是风车币
function IngamePaymentLogic:init(goodsId, goodsType, uniquePayId)
	self.goodsIdChange = false
	self.goodsId = goodsId
	self.goodsType = goodsType or 1
	if uniquePayId then 
		self.uniquePayId = uniquePayId
	else
		self.uniquePayId = PaymentDCUtil.getInstance():getNewPayID()
	end
	self.goodsInfoMeta = MetaManager:getInstance():getGoodMeta(goodsId)
	self.items = {}
	for __, v in ipairs(self.goodsInfoMeta.items) do table.insert(self.items, {itemId = v.itemId, num = v.num}) end

	local user = UserManager:getInstance().user
	local stageInfo = StageInfoLocalLogic:getStageInfo(user.uid );
	self.levelId = -1
	if stageInfo then
		self.levelId = stageInfo.levelId
	end
	local goodsPayCodeId
	if self.goodsType == 2 then
		goodsPayCodeId = self.goodsId + 10000
	else
		goodsPayCodeId = self.goodsId
	end
	self.goodsPaycodeMeta = MetaManager:getGoodPayCodeMeta(goodsPayCodeId)
	self.amount = 1

	return true
end

function IngamePaymentLogic:buildPaymentCallback(successCallback, failCallback, cancelCallback, showLoadingAnim)
	local paymentCallback = {}
	--风车币购买道具时 直接调这个回调
	paymentCallback.successCallback = successCallback
	paymentCallback.failCallback = failCallback
	paymentCallback.cancelCallback = cancelCallback

	local finalPrice = PaymentManager:getPriceByPaymentType(self.goodsId , self.goodsType, self.paymentType)
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

			--关掉可能出现的购买确认面板
			if self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed then 
				if self.buyConfirmPanel.removePopout then 
					self.buyConfirmPanel:removePopout()
				end
			end

			if successCallback then successCallback() end
			-- Q点不提示
 			if self.paymentType ~= Payments.QQ then
		 		local goodsId = self.goodsId
				if self.goodsType == 2 then 
					goodsId = goodsId + 10000
				end
 				local goodsName = Localization:getInstance():getText("goods.name.text"..tostring(goodsId))
				GlobalEventDispatcher:getInstance():dispatchEvent(
					Event.new(kGlobalEvents.kConsumeComplete,{ price = finalPrice, props = goodsName })
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
				PaymentLimitLogic:buyComplete(self.paymentType, finalPrice)
				PaymentManager.getInstance():checkPaymentLimit(self.paymentType)
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

	local function handlePayment(decision, paymentType, otherPaymentTable)
		self.paymentCallback = self:buildPaymentCallback(successCallback, failCallback, cancelCallback, showLoadingAnim)

		self:handlePaymentDecision(self.goodsPaycodeMeta, self.paymentCallback, decision, paymentType, otherPaymentTable)
	end

	local decision, paymentType, otherPaymentTable = self:getPaymentDecision()
	if decision == IngamePaymentDecisionType.kHandleWithNetwork then 
		PaymentManager.getInstance():getBuyItemDecision(handlePayment, self.goodsId)
	else
		handlePayment(decision, paymentType)
	end
end

--目前用于加五步面板
function IngamePaymentLogic:buyWithDecision(paymentDecision, paymentType, successCallback, failCallback, cancelCallback, dcParamTable)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end
	self.paymentCallback = self:buildPaymentCallback(successCallback, failCallback, cancelCallback)

	local withConfirmPanel = false
	if dcParamTable then 
		withConfirmPanel = true
	end

	local function handlePay()
		self:buyWithPaymentType(paymentType, self.goodsType, self.goodsPaycodeMeta, self.amount, self.paymentCallback, withConfirmPanel, dcParamTable)
	end

	if paymentDecision == IngamePaymentDecisionType.kNoNetWithSmsPay then
		local goodsInfoMeta = MetaManager:getInstance():getGoodMeta(self.goodsId)
		local goodsPrice = goodsInfoMeta.rmb / 100
		if goodsInfoMeta.discountRmb ~= 0 then 
			goodsPrice = goodsInfoMeta.discountRmb / 100
		end

		local netConnectPanel = NetConnectPanel:create(paymentType, handlePay, goodsPrice, cancelCallback, self.uniquePayId, true)
		netConnectPanel:popout()
	else
		handlePay()
	end
end

--目前用于开卡活动
function IngamePaymentLogic:buyWithThirdPartPayment(successCallback, failCallback, cancelCallback, showLoadingAnim, isBuyGold)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end    
    local dcParamTable = {}
    local withConfirmPanel = true

    if self.goodsId == 24 or self.goodsId == 46 or self.goodsId == 155 then
        dcParamTable.paySource = 1 -- 自动弹窗
    else
        dcParamTable.paySource = 0 -- 用户点击
    end

    if not isBuyGold then
        if self.goodsId < 5000 then -- 防止重复加5000
        	self.goodsId = self.goodsId + 5000
        end
        self.goodsPaycodeMeta = MetaManager:getGoodPayCodeMeta(self.goodsId)
    else
        self.goodsPaycodeMeta = MetaManager:getGoodPayCodeMeta(self.goodsId + 10000)
    end

    local callbackWrapperCalled = false
    local function CancelCallbackWrapper() -- 防止cancelCallback多次调用
        if not callbackWrapperCalled then
            if cancelCallback then cancelCallback() end
            callbackWrapperCalled = true
        end
    end


	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	local thirdPartyPaymentNum = #thirdPaymentConfig
	if thirdPartyPaymentNum > 0 then 
		self.paymentCallback = self:buildPaymentCallback(successCallback, failCallback, CancelCallbackWrapper, showLoadingAnim)
		if thirdPartyPaymentNum == 1 then 
            dcParamTable.defaultPaymentType = thirdPaymentConfig[1]
            -- 3秒调取消，解决微信未登录就没有回调的问题
            if thirdPaymentConfig[1] == PlatformPaymentThirdPartyEnum.kWECHAT and cancelCallback then
                setTimeOut(CancelCallbackWrapper, 3)
            end
			self:buyWithPaymentType(thirdPaymentConfig[1], self.goodsType, self.goodsPaycodeMeta, self.amount, self.paymentCallback, withConfirmPanel, dcParamTable)
		else
			local supportedPayments = {}
			for i,v in ipairs(thirdPaymentConfig) do
				supportedPayments[v] = true
			end
			local panel = ChoosePaymentPanel:create(supportedPayments,"选择您希望的支付方式:", true)
            local alterList = {} -- 打点用的
            for k, v in pairs(thirdPaymentConfig) do
                if v ~= Payments.UNSUPPORT then
                    table.insert(alterList, v)
                end
            end
            local _, smsPaymentType = self:getSMSPaymentDecision()
            if smsPaymentType then table.insert(alterList, smsPaymentType) end
            alterList = PaymentDCUtil:getAlterPaymentList(alterList) -- 转数据格式
            PaymentDCUtil.getInstance():sendPayChoosePop(0, alterList, self.uniquePayId, dcParamTable.paySource)
			local function onChoosen(choosenType)
				if choosenType then
                    -- 3秒调取消，解决微信未登录就没有回调的问题
                    if choosenType == PlatformPaymentThirdPartyEnum.kWECHAT and cancelCallback then
                        setTimeOut(CancelCallbackWrapper, 3)
                    end
                    PaymentDCUtil.getInstance():sendPayChoose(0, alterList, choosenType, self.uniquePayId, dcParamTable.paySource)
                    dcParamTable.defaultPaymentType = choosenType
					self:buyWithPaymentType(choosenType, self.goodsType, self.goodsPaycodeMeta, self.amount, self.paymentCallback, withConfirmPanel, dcParamTable)
				else
					if cancelCallback then 
						cancelCallback()
					end
				end
			end
			if panel then panel:popout(onChoosen) end
		end
	end
end

function IngamePaymentLogic:getPaymentDecision()
	if PlatformConfig:getCurrentPayType()==PlatformPayType.kWechat 
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kAlipay 
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kQihoo
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kWandoujia then 
		return self:getThirdPartPaymentDecision()
	else
		local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
		if thirdPartPayment == PlatformPaymentThirdPartyEnum.kMI then
			-- 如果是米币支付方式，直接发起支付
			return self:getThirdPartPaymentDecision()
		elseif thirdPartPayment == PlatformPaymentThirdPartyEnum.kVIVO then
			return self:getThirdPartPaymentDecision()
		else
			if self:isThirdPartPaymentOnly(self.goodsId, self.goodsType) then
				-- 如果是大额支付点，使用三方支付
				return self:getThirdPartPaymentDecision()
			else
				if self.goodsType == 2 then 
					if PaymentManager.getInstance():checkSmsPayEnabled() then 
						return self:getSMSPaymentDecision()
					else
						--买风车币时 若有自己三方支付的平台短代不可用 那小额支付也走平台三方
						return self:getThirdPartPaymentDecision()
					end
				else
					return IngamePaymentDecisionType.kHandleWithNetwork
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

function IngamePaymentLogic:isThirdPartPaymentOnly( goodsId, goodsType )
	local thirdPayOnly = false
	if self.goodsType == 2 then 
		local goodsData = MetaManager:getInstance():getProductAndroidMeta(goodsId)
		if goodsData.rmb >= 3000 then 
			thirdPayOnly = true
		end
	end
	return thirdPayOnly
end

function IngamePaymentLogic:doOrder(tradeId, goodsId, goodsType, amount, onFinish)
    local function onRequestError( evt )
        evt.target:removeAllEventListeners()
        print("onRequestError callback")
        if onFinish then onFinish(-99) end
    end
    local function onRequestFinish( evt )
        evt.target:removeAllEventListeners()
        print("onRequestFinish callback:tradeId="..tostring(tradeId))
        if onFinish then onFinish() end
    end 

    local http = DoOrderHttp.new()
    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(tradeId, goodsId, goodsType, amount)
end

function IngamePaymentLogic:doWXOrder(tradeId, goodsId, goodsType, amount, goodsName, totalFee, onFinish)
	local scene = Director:sharedDirector():getRunningScene()
	local animation

	local signForThirdPay = PaymentManager.getInstance():getSignForThirdPay(goodsId, goodsType)

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

    local platform = StartupConfig:getInstance():getPlatformName()
	print("doWXOrder::platform====================================>", platform)

    local http

    if platform == PlatformNameEnum.kAnZhi then
    	print(">>>>>>>>>>>>>>>>>>>>>>>>>>> using doWXOrder v2")--新接入的微信支付接口跟以前不一样了
    	http = DoWXOrderV2Http.new()
    else
    	print(">>>>>>>>>>>>>>>>>>>>>>>>>>> using doWXOrder v1")
    	http = DoWXOrderHttp.new()
	end

    if PlatformConfig:isQQPlatform() then
    	platform = PlatformNameEnum.kQQ
    end

    local ip = "127.0.0.1"

    local function onCloseButtonTap()
    	http:removeAllEventListeners()
    	animation:removeFromParentAndCleanup(true)
    	if onFinish then onFinish() end
	end
    animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
	-- scene:addChild(animation)

    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(platform, signForThirdPay, tradeId, goodsId, goodsType, amount, goodsName, totalFee, ip)
end

function IngamePaymentLogic:doAliOrder(tradeId, goodsId, goodsType, amount, goodsName, totalFee, onFinish)
	local scene = Director:sharedDirector():getRunningScene()
	local animation

	local signForThirdPay = PaymentManager.getInstance():getSignForThirdPay(goodsId, goodsType)
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
	-- scene:addChild(animation)

    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(platform, signForThirdPay, tradeId, goodsId, goodsType, amount, goodsName, totalFee)
end

function IngamePaymentLogic:buildPaymentParams(paymentType, goodsType, goodsPaycodeMeta, amount, goodsName, tradeId)
	local params = luajava.newInstance("java.util.HashMap")
	params:put("uid", UserManager:getInstance().uid)
	params:put("amount", amount)

	local goodsParams = nil
	local paramTable = {}

	local finalPrice = PaymentManager:getPriceByPaymentType(self.goodsId, goodsType, paymentType)
	local goodsId = self.goodsId
	local signForThirdPay = PaymentManager.getInstance():getSignForThirdPay(goodsId, goodsType)
	if goodsType == 2 then
		goodsId = goodsId + 10000  
	end
	--之所以这几个三方平台单独拿出来 是因为现在会有goods表里有的商品但goods_pay_code表里没有 即goodsPaycodeMeta可能为空
	--所以这个参数要自己手动构建 之后不用在后台申请计费点的三方支付 都自己构建
	if paymentType == Payments.QQ then 
		paramTable.price = finalPrice
		paramTable.props = goodsName
		goodsParams = luaJavaConvert.table2Map(paramTable)
	elseif paymentType == Payments.WDJ then 
		paramTable.price = finalPrice
		paramTable.props = goodsName
		goodsParams = luaJavaConvert.table2Map(paramTable)
	elseif paymentType == Payments.QIHOO then 
		paramTable.price = finalPrice
		paramTable.props = goodsName
		paramTable.id = goodsId
		goodsParams = luaJavaConvert.table2Map(paramTable)
	-- elseif paymentType == Payments.MI then
	-- elseif paymentType == Payments.DUOKU then
	-- elseif paymentType == Payments.WO3PAY then 
	-- elseif paymentType == Payments.VIVO then 
	else
		if goodsPaycodeMeta then 
			goodsParams = luaJavaConvert.table2Map(goodsPaycodeMeta)
			goodsParams:put("props", goodsName)
		end
	end
	if goodsParams then 
		params:put("meta", goodsParams)
	end

	local extraData = {}
	if paymentType == Payments.QQ then
        local extendinfo = { 
            platform = StartupConfig:getInstance():getPlatformName(), 
            itemId = tostring(goodsId), 
            itemAmount = tostring(amount), 
            itemPrice = tostring(finalPrice * 10), 
            realAmount = tostring(amount), 
            curLevel = tostring(UserManager:getInstance().user:getTopLevelId()),
            goodsType = tostring(goodsType)
        }
        if signForThirdPay then 
        	extendinfo.signStr = tostring(signForThirdPay)
        end
		extraData.ext = table.serialize(extendinfo)
	end

	if paymentType == Payments.CHINA_MOBILE then
		extraData.ext = tradeId
	end

	params:put("extraData", luaJavaConvert.table2Map(extraData))
	return params
end

function IngamePaymentLogic:updateBuyConfirmPanelParams(failedPaymentType)
	if self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed then 
		self.buyConfirmPanel:setFailBeforePayEnd()
        self.buyConfirmPanel.failedPaymentType = failedPaymentType
	end	
end

local paymentProxy
function IngamePaymentLogic:buyWithPaymentType(paymentType, goodsType, goodsPaycodeMeta, amount, callback, withConfirmPanel, dcParamTable)
	print("buyWithPaymentType:" .. paymentType)
	self.paymentType = paymentType

	local finalPrice = PaymentManager.getInstance():getPriceByPaymentType(self.goodsId , goodsType, paymentType)

	amount = amount or 1
	if not paymentProxy then
		paymentProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSPaymentProxy"):getInstance()
	end
	paymentProxy:setPaymentType(paymentType)
	local paymentDelegate = paymentProxy:getPaymentDelegate()
	if not paymentDelegate then
		self:updateBuyConfirmPanelParams(paymentType)
		callback.onError(0, "RRR  PaymentType not registered!")
		return
	end
	local tradeId = paymentDelegate:generateOrderId()
	local userGroup = 0
	if not withConfirmPanel and (paymentType == Payments.CHINA_MOBILE or paymentType == Payments.DUOKU) then
		userGroup = 1
	end

	--没有确认面板的支付 pay_start打在这里
	local finalDCParamTable = dcParamTable or {}
	if withConfirmPanel then 
		finalDCParamTable.isSkip = 0
	else
		PaymentDCUtil.getInstance():sendPayStart(self.paymentType, 0, self.uniquePayId, self.goodsId, 
													self.goodsType, 1, 0, 1)	
		finalDCParamTable.defaultPaymentType = self.paymentType
		finalDCParamTable.paySource = 0
		finalDCParamTable.isSkip = 1
	end

	local onButton1Click = function()
		local function buySuccess(result)
			if not PrepackageUtil:checkIsSMSPayment(paymentType) then
				--三方支付 本地留记录
				PaymentManager.getInstance():setHasFirstThirdPay(true, paymentType) 
			end
			if callback then callback.onSuccess(luaJavaConvert.map2Table(result)) end

			PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
									self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
									0, 0, nil, finalDCParamTable.isSkip)
		end
		local function buyError(errCode, errMsg)
			self:updateBuyConfirmPanelParams(paymentType)
			PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
									self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
									0, 1, errCode, finalDCParamTable.isSkip)

			if paymentType == Payments.WDJ and errCode == 1 then
				-- -- 豌豆荚，选择话费支付 算是一次新的支付 更新下唯一支付ID
				-- self.uniquePayId = PaymentDCUtil.getInstance():getNewPayID()
				-- self:smsPay(goodsPaycodeMeta, callback, false)
				
				if callback then callback.onError(errCode, errMsg) end
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
		end
		local function buyCancel(isExceedLimit)
			if callback then callback.onCancel(isExceedLimit) end

			self:updateBuyConfirmPanelParams(paymentType)
			PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
									self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
									0, 2, nil, finalDCParamTable.isSkip)
		end

        local function wrappedBuyError(errCode, errMsg)
            local function doCallback()
                buyError(errCode, errMsg)
            end
            if paymentType == Payments.WECHAT or paymentType == Payments.ALIPAY then -- 支付帮助，只会弹一次
                ThirdPayGuideLogic:onPayFailure(paymentType, doCallback)
            else
                doCallback()
            end
        end

        local function wrappedBuyCancel(isExceedLimit)
            local function doCallback()
                buyCancel(isExceedLimit)
            end
            if paymentType == Payments.WECHAT or paymentType == Payments.ALIPAY then -- 支付帮助，只会弹一次
                ThirdPayGuideLogic:onPayFailure(paymentType, doCallback)
            else
                doCallback()
            end
        end

		local callbackProxy = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = buySuccess,
	        onError = wrappedBuyError,
	        onCancel = wrappedBuyCancel
	    })

		local goodsId = self.goodsId
		if goodsType == 2 then 
			goodsId = goodsId + 10000
		end
		local goodsName = Localization:getInstance():getText("goods.name.text"..tostring(goodsId))

		if paymentType==Payments.WECHAT then 
			local function onFinish(data)
				if not data then
					callback.onError(0, "wechat payment network error")

					self:updateBuyConfirmPanelParams(paymentType)
					PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
											self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
											0, 1, 0, finalDCParamTable.isSkip)
				elseif type(data)~="table" then 
					if data==-6 then	
						callback.onCancel()				
						CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))		
						print("wechat payment network error")

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
												self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
												0, 1, -6, finalDCParamTable.isSkip)
					else
						callback.onError(1, "wechat payment network error")

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
												self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
												0, 1, 1, finalDCParamTable.isSkip)
					end
				else
					if data.errCode then
						callback.onError(data.errCode, data.errMsg)

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
												self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
												0, 1, data.errCode, finalDCParamTable.isSkip)
					else				
						paymentDelegate:WXbuy(tradeId, data.partnerId, data.prepayId,
											  data.nonceStr, data.timeStamp, data.signStr, 
											  callbackProxy) 
					end 
				end
			end
			self:doWXOrder(tradeId, goodsId, goodsType, amount, goodsName, finalPrice*100, onFinish)
		elseif paymentType==Payments.ALIPAY then
			local function onFinish(data)
				if not data then
					callback.onError(0, "ali payment network error")

					self:updateBuyConfirmPanelParams(paymentType)
					PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
											self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
											0, 1, 0, finalDCParamTable.isSkip)
				elseif type(data)~="table" then 
					if data==-6 then	
						callback.onCancel()				
						CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))		
						print("ali payment network error")

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
											self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
											0, 1, -6, finalDCParamTable.isSkip)
					else
						callback.onError(1, "ali payment network error")

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
											self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
											0, 1, 1, finalDCParamTable.isSkip)
					end
				else
					if data.errCode then
						callback.onError(data.errCode, data.errMsg)

						self:updateBuyConfirmPanelParams(paymentType)
						PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
												self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
												0, 1, data.errCode, finalDCParamTable.isSkip)
					else				
						paymentDelegate:ALIbuy(tradeId, data.signStr, callbackProxy)
					end 
				end
			end

			self:doAliOrder(tradeId, goodsId, goodsType, amount, goodsName, finalPrice, onFinish)
		elseif paymentType==Payments.VIVO then

			local params = self:buildPaymentParams(paymentType, goodsType, goodsPaycodeMeta, amount, goodsName, tradeId)
			if AndroidPayment.getInstance():isNeedPreOrder(paymentType) then
				local function onFinish() 
					paymentDelegate:buy(tradeId, params, callbackProxy) 
				end
				self:doOrder(tradeId, goodsId, goodsType, amount, onFinish)
			else
				paymentDelegate:buy(tradeId, params, callbackProxy) 
			end
		else
			local sendPaymentRequest = function()
				local params = self:buildPaymentParams(paymentType, goodsType, goodsPaycodeMeta, amount, goodsName, tradeId)
				if AndroidPayment.getInstance():isNeedPreOrder(paymentType) then
					local function onFinish(errCode) 
						if errCode and errCode == -99 then 
							if goodsType ~= 2 then 
								CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
							end
							callback.onError(errCode, "doOrder failed")

							PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
							self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
							0, 1, errCode, finalDCParamTable.isSkip)
						else
							paymentDelegate:buy(tradeId, params, callbackProxy) 
						end
					end
					self:doOrder(tradeId, goodsId, goodsType, amount, onFinish)
				else
					paymentDelegate:buy(tradeId, params, callbackProxy) 
				end
			end

			local canelPayment = function()
				callback.onCancel()

				PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
										self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
										0, 3, nil, finalDCParamTable.isSkip)
			end

			if userGroup == 1 then
				local isSkipConfirm = MaintenanceManager:getInstance():isEnabled("SecPayPanel")
				if not isSkipConfirm then
					local p = require("zoo.panel.BuyPropsConfirmPanel"):create(self, goodsType, goodsPaycodeMeta, sendPaymentRequest, canelPayment, self._ignoreSecondConfirm)
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

		PaymentDCUtil.getInstance():sendPayEnd(finalDCParamTable.defaultPaymentType, self.paymentType, self.uniquePayId, 
								self.goodsId, goodsType, 1, finalDCParamTable.paySource, finalPrice, 
								0, 3, nil, finalDCParamTable.isSkip)
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
			return IngamePaymentDecisionType.kPayFailed
		else
			return IngamePaymentDecisionType.kPayWithType, defaultSmsPayment
		end
	else -- 无卡或者未知种类
		return IngamePaymentDecisionType.kPayFailed
	end
end

function IngamePaymentLogic:smsPay(goodsPaycodeMeta, callback, withConfirmPanel)	
	local decision, paymentType = self:getSMSPaymentDecision()
    local otherPaymentTable = {}
	self:handlePaymentDecision(goodsPaycodeMeta, callback, decision, paymentType, otherPaymentTable, withConfirmPanel)
end

function IngamePaymentLogic:handlePaymentDecision(goodsPaycodeMeta, callback, decision, paymentType, otherPaymentTable, withConfirmPanel)
	local function onRmbBuyItemListener(event)
		if self.goodsIdChange then 
			self.goodsIdChange = false
			self.goodsId = event.data.goodsId
		end
		amount = 1
		local dcParamTable = {}
		dcParamTable.defaultPaymentType = event.data.defaultPaymentType
		dcParamTable.paySource = event.data.paySource
		self:buyWithPaymentType(paymentType, self.goodsType, goodsPaycodeMeta, amount, callback, true, dcParamTable)
	end

	local function onBuyWithChoosenTypeListener(event)
		if not self.goodsIdChange then 
			self.goodsIdChange = true
			self.goodsId = event.data.goodsId
		end
		local choosenPaymentType = event.data.paymentType
		local dcParamTable = {}
		dcParamTable.defaultPaymentType = event.data.defaultPaymentType
		dcParamTable.paySource = event.data.paySource
		if choosenPaymentType then 
			amount = 1
			self:buyWithPaymentType(choosenPaymentType, self.goodsType, goodsPaycodeMeta, amount, callback, true, dcParamTable)
		else
			if callback and callback.onCancel then
				callback.onCancel() 
			end
		end
	end

	local function onBuyConfirmPanelCloseListener()
		if callback and callback.onCancel then 
			callback.onCancel()
		end
		self.buyConfirmPanel = nil
	end

	if decision == IngamePaymentDecisionType.kPayWithType then 				--正常选定三方支付
        local dcParamTable = {}
        dcParamTable.defaultPaymentType = paymentType
        if self.goodsId == 24 or self.goodsId == 46 or self.goodsId == 155 then 
            dcParamTable.paySource = 1
        else
            dcParamTable.paySource = 0
        end
		self:buyWithPaymentType(paymentType, self.goodsType, goodsPaycodeMeta, amount, callback, withConfirmPanel, dcParamTable)
	elseif decision == IngamePaymentDecisionType.kPayFailed then
		if self.goodsType ~= 2 then 
			CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
		end
		if callback.onError then callback.onError(nil, "No payment type supported") end
		local paySource = 0
		if self.goodsId == 24 or self.goodsId == 46 or self.goodsId == 155 then 
            paySource = 1
        end
		PaymentDCUtil.getInstance():sendPayEnd(-3, nil, self.uniquePayId, 
								self.goodsId, self.goodsType, 1, paySource, 0, 
								0, 1, 0, 1)
	else
		if decision == IngamePaymentDecisionType.kSmsPayOnly or 				--仅短代支付
			-- decision == IngamePaymentDecisionType.kSmsWithThirdPay or 		--短代支付 三方可选
			-- decision == IngamePaymentDecisionType.kThirdPayWithSms or 		--三方支付 短代可选
			decision == IngamePaymentDecisionType.kThirdPayOnly then 			--仅三方支付
			
			--去掉支付确认二次弹窗
			self:buyWithPaymentType(paymentType, self.goodsType, goodsPaycodeMeta, amount, callback)
		elseif decision == IngamePaymentDecisionType.kNoNetWithSmsPay then 
			local goodsInfoMeta = MetaManager:getInstance():getGoodMeta(self.goodsId)
			local goodsPrice = goodsInfoMeta.rmb / 100
			if goodsInfoMeta.discountRmb ~= 0 then 
				goodsPrice = goodsInfoMeta.discountRmb / 100
			end
			local function handleSmsPay()
				self:buyWithPaymentType(paymentType, self.goodsType, goodsPaycodeMeta, amount, callback, true)
			end

			local connectCallback = nil
			if callback and callback.onCancel then 
				connectCallback = callback.onCancel
			end
			local netConnectPanel = NetConnectPanel:create(paymentType, handleSmsPay, goodsPrice, connectCallback, self.uniquePayId, true)
			netConnectPanel:popout()
		elseif decision == IngamePaymentDecisionType.kSmsWithOneYuanPay then 
			otherPaymentTable = otherPaymentTable or {}
			local peDispatcher = PaymentEventDispatcher.new()
			peDispatcher:addEventListener(PaymentEvents.kRmbBuyItem, onRmbBuyItemListener)
			peDispatcher:addEventListener(PaymentEvents.kBuyWithChoosenType, onBuyWithChoosenTypeListener)
			peDispatcher:addEventListener(PaymentEvents.kBuyConfirmPanelClose, onBuyConfirmPanelCloseListener)

			self.buyConfirmPanel = RmbConfirmPanel:create(peDispatcher, self.goodsId, self.goodsType, paymentType, otherPaymentTable, self.uniquePayId)
			self.buyConfirmPanel:popout()
		elseif decision == IngamePaymentDecisionType.kPayWithWindMill then		--风车币支付
			local buyConfirmPanel = WindMillConfirmPanel:create(self.goodsId, self.goodsType, callback, self.uniquePayId)
			buyConfirmPanel:popout()
		else
			assert("Unexcepted payment decision " .. decision .. ", " .. paymentType)
		end 
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

function IngamePaymentLogic:deliverItems()
	if self.goodsType == 1 then 
		self:updatePropCount()
		--
		local price = PaymentManager:getPriceByPaymentType(self.goodsId , self.goodsType, self.paymentType)
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

function IngamePaymentLogic:tryThirdPayPromotion(successCallback, failCallback, cancelCallback, showLoadingAnim)
    if self.goodsType == 1 and not PaymentManager:getInstance():getHasFirstThirdPay()
    and PaymentManager:supportThirdPayPromotion() then
        local _isPromotionGoods = ThirdPayGuideLogic:isPromotionGoods(self.goodsId) 
        if _isPromotionGoods then

            local panel
            local originalGoodsId = self.goodsId
            local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
            local defaultPaymentType, alterList, paySource
            if type(thirdPaymentConfig) == 'table' and #thirdPaymentConfig == 1 then
                defaultPaymentType = thirdPaymentConfig[1]
            else
                defaultPaymentType = 0 -- 未知
            end

            alterList = {} -- 打点用的
            for k, v in pairs(thirdPaymentConfig) do
                if v ~= Payments.UNSUPPORT then
                    table.insert(alterList, v)
                end
            end
            local _, smsPaymentType = self:getSMSPaymentDecision()
            if smsPaymentType then table.insert(alterList, smsPaymentType) end
            local alterList = PaymentDCUtil:getAlterPaymentList(alterList) -- 转数据格式
            if originalGoodsId == 24 or originalGoodsId == 46 or originalGoodsId == 155 then
                paySource = 1 -- 来自+5面板
            else
                paySource = 0
            end

        	local function thirdPayCloseCallback(failBeforePayEnd, goodsPrice)
                local endResult = 3
                if failBeforePayEnd then
                    endResult = 4
                end
                local choosenType = 0
                if self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed and self.buyConfirmPanel.failedPaymentType then
                    choosenType = self.buyConfirmPanel.failedPaymentType
                end
                PaymentDCUtil.getInstance():sendPayEnd(defaultPaymentType, 
                    choosenType, 
                    self.uniquePayId, 
                    originalGoodsId + 5000, 
                    1, 
                    1, 
                    paySource, 
                    goodsPrice, 
                    0, 
                    endResult, 
                    nil, 
                    0)

        		if cancelCallback then
        			cancelCallback()
        		end
        	end
            -- 购买成功关闭面板
            -- 购买失败、取消直接回调，不关闭面板
            local function localBuySuccessCallback()
                if panel and not panel.isDisposed then
                    panel:removeSelf() -- 关闭而没有任何callback
                    panel = nil
                end
                if successCallback then
                    successCallback()
                end
            end
            local function localBuyCancelCallback() 
                if panel and not panel.isDisposed then
                    panel:enableButtons()
                end
                -- 如果是+5面板买东西，只需要管关闭按钮的回调，失败和取消不需要回调，否则游戏就会失败
                if originalGoodsId == 24 or originalGoodsId == 46 or originalGoodsId == 155 then
                    CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.cancel.android"), "negative")
                    return
                end
                if cancelCallback then
                    cancelCallback()
                end
            end
            local function localBuyFailCallback()
                if panel and not panel.isDisposed then
                    panel:enableButtons()
                end
                if originalGoodsId == 24 or originalGoodsId == 46 or originalGoodsId == 155 then
                    CommonTip:showTip(Localization:getInstance():getText("add.step.panel.buy.fail.android"), "negative")
                    return
                end
                if failCallback then
                    failCallback()
                end
            end
        	local function smsBuyBtnCallback()
                PaymentDCUtil.getInstance():sendPayChoose(0, alterList, smsPaymentType, self.uniquePayId, paySource)
                if self.goodsId > 5000 then -- 恢复goodsId 防止已经被+5000
                    self.goodsId = self.goodsId - 5000
                end
        		self.goodsPaycodeMeta = MetaManager:getGoodPayCodeMeta(self.goodsId)
        		self:smsPay(self.goodsPaycodeMeta, self:buildPaymentCallback(localBuySuccessCallback, localBuyFailCallback, localBuyCancelCallback, showLoadingAnim), true)
        	end
        	local function thirdPayBuyBtnCallback()
        		self:buyWithThirdPartPayment(localBuySuccessCallback, localBuyFailCallback, localBuyCancelCallback, showLoadingAnim)
        	end

			panel = ThirdPayDiscountPanel:create(
				originalGoodsId, 
				thirdPayCloseCallback,
				thirdPayBuyBtnCallback, 
				smsBuyBtnCallback)
			panel:popout()
            self.buyConfirmPanel = panel
            PaymentDCUtil.getInstance():sendPayStart(defaultPaymentType, 
                                            alterList, 
                                            self.uniquePayId, 
                                            originalGoodsId + 5000, 
                                            1, 
                                            1, 
                                            paySource, 
                                            0)  
			return true
		end
	end
	return false
end