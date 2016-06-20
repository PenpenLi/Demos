require "zoo.data.MetaManager"
require "zoo.payment.paymentDC.DCWindmillObject"

if __IOS then
	require "zoo.util.IosPayment"
elseif __ANDROID then
	require "zoo.panelBusLogic.IngamePaymentLogic"
elseif __WP8 then
	require "zoo.panelBusLogic.Wp8Payment"
end

BuyGoldLogic = class()

function BuyGoldLogic:create()
	local logic = BuyGoldLogic.new()
	return logic
end

function BuyGoldLogic:getMeta()
	if __IOS then
		self.meta = MetaManager:getInstance().product
	elseif __ANDROID then
		self.meta = MetaManager:getInstance().product_android
	elseif __WP8 then
		self.meta = MetaManager:getInstance().product_wp8
	else -- on PC there should not be any gold buying stuff 'cause nothing can be bought
		self.meta = MetaManager:getInstance().product;
	end
	for k, v in ipairs(self.meta) do
		if string.len(v.productId) == 0 then v.productId = tostring(k) end
	end
	return self.meta
end

function BuyGoldLogic:getProductInfo(successCallback, failCallback, timeoutCallback, cancelCallback)
	if not self.meta then self:getMeta() end
	local goldList, counter = {}, 0
	local scene = Director:sharedDirector():getRunningScene()

	local animation
	local function removeLoading()
		if self.schedule then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
			self.schedule = nil
		else return end
		animation:removeFromParentAndCleanup(true)
		self.schedule = nil
	end
	local function onCloseButtonTap()
		removeLoading()
		if cancelCallback then cancelCallback() end
	end
	animation = CountDownAnimation:createNetworkAnimation(scene, onCloseButtonTap)
	-- scene:addChild(animation)
	for __, v in ipairs(self.meta) do
		if v.show then
			if __IOS and v.id == 8 then
				if MaintenanceManager:getInstance():isEnabled("CoinPanelCny1") then 
					counter = counter + 1
					goldList[tostring(counter)] = v.productId
				end
			elseif __IOS and v.id == 9 then
				if MaintenanceManager:getInstance():isEnabled("CoinPanelCny3") then
					counter = counter + 1
					goldList[tostring(counter)] = v.productId
				end
			elseif __IOS and v.id == 10 then
			elseif __IOS and v.id == 11 then
			elseif __IOS and v.id == 12 then
			elseif __IOS and v.id == 13 then
			elseif __IOS and v.id == 14 then
			else
				counter = counter + 1
				goldList[tostring(counter)] = v.productId
			end
		end
	end
	local function onSuccess(iapConfig)
		if self.schedule then
			removeLoading()
			self.iapConfig = iapConfig
			if successCallback then successCallback(iapConfig) end
		end
	end
	local function onFail(evt)
		if self.schedule then
			removeLoading()
			if failCallback then failCallback(evt) end
		end
	end
	local function onTimeout()
		if self.schedule then
			removeLoading()
			if timeoutCallback then timeoutCallback() end
		end
	end
	if __IOS then -- IOS
		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 20, false)
		IosPayment:showPayment(goldList, onSuccess, onFail)
	elseif __ANDROID then -- ANDROID
		local res = {}
		for k, v in ipairs(self.meta) do
			if v.id ~= 16 and v.id ~= 17 and v.id ~= 18 and v.id ~= 29 then -- hide gold payments
				res[tostring(k - 1)] = v
				res[tostring(k - 1)].iapPrice = v.rmb / 100

				-- 默认支付方式是MDO时，单独处理为整5、10的值
				if AndroidPayment.getInstance():getDefaultSmsPayment() == Payments.MDO then
					if v.rmb == 1200 then res[tostring(k - 1)].iapPrice = 10
			        elseif v.rmb == 2800 then
			        	res[tostring(k - 1)].iapPrice = 25
			        	res[tostring(k - 1)].extra = true
			        end
				end
				--[[
				-- 当运营商是移动且平台是91或多库的时候单独处理为整5、10的值
				local telecomOperator = SnsProxy:getOperatorOne()
				if telecomOperator == TelecomOperators.CHINA_MOBILE then
				    if enableMdoPayement then
				    	if PlatformConfig:isBaiduPlatform() then
					        if v.rmb == 1200 then res[tostring(k - 1)].iapPrice = 10
					        elseif v.rmb == 2800 then
					        	res[tostring(k - 1)].iapPrice = 25
					        	res[tostring(k - 1)].extra = true
					        end
				        end
				    end
				end
				]]--

				res[tostring(k - 1)].productIdentifier = v.productId
			end
		end
		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 20, false)

		-- 如果仅支持短代，不显示这些单价>30的商品
		if not PlatformConfig:isBigPayPlatform() then
			for k, v in pairs(res) do 
				if v.iapPrice > 30 then
					res[k] = nil
				end
			end
		end

		onSuccess(res)
	elseif __WP8 then
		local res = {}
		for k, v in ipairs(self.meta) do
			res[tostring(k - 1)] = v
			res[tostring(k - 1)].iapPrice = v.rmb / 100
			res[tostring(k - 1)].productIdentifier = v.productId
		end
		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 20, false)
		onSuccess(res)
	else -- I don't wanna fake a group of info to fool testers, so just skip.
		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 20, false)
		
		onSuccess({["0"] = {productIdentifier = "com.happyelements.animal.gold.cn.1", iapPrice = 6}, 
			       ["1"] = {productIdentifier = "com.happyelements.animal.gold.cn.2", iapPrice = 30}, 
			       ["2"] = {productIdentifier = "com.happyelements.animal.gold.cn.3", iapPrice = 128},
			       ["3"] = {productIdentifier = "com.happyelements.animal.gold.cn.4", iapPrice = 18},  
			       ["4"] = {productIdentifier = "com.happyelements.animal.gold.cn.8", iapPrice = 1},  
			       ["5"] = {productIdentifier = "com.happyelements.animal.gold.cn.9", iapPrice = 3},  
			       });
	end
end

function BuyGoldLogic:buy(index, data, successCallback, failCallback, cancelCallback)
	local function onSuccess()
		local user = UserManager:getInstance().user
		local serv = UserService:getInstance().user
		local oldCash = user:getCash()
		local newCash = oldCash + self.meta[index].cash;
		user:setCash(newCash)
		serv:setCash(newCash)

		local userExtend = UserManager:getInstance().userExtend
		if type(userExtend) == "table" then userExtend.payUser = true end
		if __IOS or __WIN32 then
			UserManager:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
			UserService:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
		end
		
		DcUtil:logCreateCash("charge", self.meta[index].cash, oldCash, -1)
		
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
		if successCallback then
			successCallback()
		end

		if __IOS then 
			GlobalEventDispatcher:getInstance():dispatchEvent(
				Event.new(kGlobalEvents.kConsumeComplete,{
					price=self.meta[index].price,
					props=Localization:getInstance():getText("consume.history.panel.gold.text",{n=self.meta[index].cash}),
				})
			)
		end
	end
	local function onFail(errCode, errMsg)
		if failCallback then
			failCallback(errCode, errMsg)
		end
	end
	local function onCancel()
		if cancelCallback then
			cancelCallback()
		end
	end
	if __IOS then -- IOS
		local dcIosInfo = DCIosRmbObject:create()
	    dcIosInfo:setGoodsId(data.productIdentifier)
	    dcIosInfo:setGoodsType(2)
	    dcIosInfo:setGoodsNum(1)
	    dcIosInfo:setRmbPrice(data.iapPrice)

		local peDispatcher = PaymentEventDispatcher.new()
		local function successDcFunc(evt)
			dcIosInfo:setResult(IosRmbPayResult.kSuccess)
        	PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(dcIosInfo)
		end
		local function failedDcFunc(evt)
			dcIosInfo:setResult(IosRmbPayResult.kSdkFail)
        	PaymentIosDCUtil.getInstance():sendIosRmbPayEnd(dcIosInfo)
		end
		peDispatcher:addEventListener(PaymentEvents.kIosBuySuccess, successDcFunc)
		peDispatcher:addEventListener(PaymentEvents.kIosBuyFailed, failedDcFunc)
		IosPayment:buy(data.productIdentifier, data.iapPrice, data.priceLocale, "", onSuccess, onFail, peDispatcher)
	elseif __ANDROID then -- ANDROID
		local logic = IngamePaymentLogic:create(index, 2)
		logic:ignoreSecondConfirm(true)
		logic:buy(onSuccess, onFail, onCancel)
	elseif __WP8 then
		local logic = Wp8Payment:create(index)
		logic:buy(onSuccess, onFail, onCancel)
	else -- on PC, there is no payment, u should not have come here!
		local http = IngameHttp.new(false)
		http:ad(Events.kComplete, onSuccess)
		http:ad(Events.kError, onFail)
		local tradeId = Localhost:time()
		http:load(index, tradeId, "chinaMobile", 2, nil, tradeId)
	end
end