require "zoo.payment.PaymentManager"
require "zoo.payment.GoodsIdInfoObject"
require "zoo.payment.paymentDC.PaymentDCUtil"
require "zoo.payment.paymentDC.DCAndroidRmbObject"
require "zoo.payment.PaymentEventDispatcher"
require "zoo.payment.PayPanelWindMill"
require "zoo.payment.PayPanelSingleSms"
require "zoo.payment.PayPanelOneYuanSingle"
require "zoo.payment.PayPanelOneYuanMulti"
require "zoo.payment.PayPanelSingleThird"
require "zoo.payment.PayPanelMultiThird"
require "zoo.payment.PayPanelSingleThirdOff"
require "zoo.payment.PayPanelMultiThirdOff"
require "zoo.payment.PayPanelRePay"

require 'zoo.panel.ChoosePaymentPanel'
require 'hecore.sns.aps.AndroidPayment'
require "zoo.panelBusLogic.PaymentLimitLogic"
require 'zoo.gameGuide.ThirdPayGuideLogic'
require 'zoo.payment.AndroidSDKPayLogic'
require 'zoo.panelBusLogic.AliAppSignAndPayLogic'
require 'zoo.payment.WechatQuickPayLogic'
require 'zoo.panelBusLogic.AliQuickPayPromoLogic'

IngamePaymentLogic = class()

function IngamePaymentLogic:create(goodsId, goodsType, dcAndroidInfo)
	local logic = IngamePaymentLogic.new()
	logic.goodsIdInfo = GoodsIdInfoObject:create(goodsId, goodsType)
	logic:init(dcAndroidInfo)
	return logic
end

function IngamePaymentLogic:createWithGoodsInfo(goodsIdInfo, dcAndroidInfo)
	local logic = IngamePaymentLogic.new()
	logic.goodsIdInfo = goodsIdInfo
	logic:setOriGoodsIdType(goodsIdInfo:getCurrentChangeType())
	logic:init(dcAndroidInfo)
	return logic
end

function IngamePaymentLogic:ctor()
	--与本次支付相关的确认面板 外部面板如加五步需要调用 setBuyConfirmPanel 设置
	self.buyConfirmPanel = nil
	--失败后可能弹出的重新购买面板
	self.repayPanel = nil
	--默认有重新购买
	self.noRePay = false
	--默认checkOnlinePay时 没有loading框
	self.needLoadingMask = false	
	--原始的goodsId转换的状态 只在最初改变的时候记录
	self.oriGoodsIdType = GoodsIdChangeType.kNormal
end

-- goodsType: 1: 要买的是普通道具
--            2: 要买的是风车币
function IngamePaymentLogic:init(dcAndroidInfo)
	self.amount = 1
	if dcAndroidInfo then 
		self.dcAndroidInfo = dcAndroidInfo
	else
		self.dcAndroidInfo = DCAndroidRmbObject:create()
	end

	self.dcAndroidInfo:setGoodsId(self.goodsIdInfo:getGoodsId())
	self.dcAndroidInfo:setGoodsType(self.goodsIdInfo:getGoodsType())
	self.dcAndroidInfo:setGoodsNum(self.amount)
end

function IngamePaymentLogic:rmbBuySuccess(param, subPaymentType)
	print('wenkan rmbBuySuccess isAliSignPay', subPaymentType == Payments.ALI_SIGN_PAY, self.paymentType)
	print('wenkan rmbBuySuccess isAliSignPay', type(subPaymentType), type(self.paymentType))
	local goodsId = self.goodsIdInfo:getGoodsId()
	local goodsType = self.goodsIdInfo:getGoodsType()
	local function onSuccess()
		UserManager:getInstance():getUserExtendRef().payUser = true
		UserService:getInstance():getUserExtendRef().payUser = true
		UserManager:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
		UserService:getInstance():getUserExtendRef():setLastPayTime(Localhost:time())
		if subPaymentType and subPaymentType == Payments.WECHAT_QUICK_PAY then
			local price = PaymentManager:getPriceByPaymentType(goodsId, goodsType, self.paymentType)
			UserManager:getInstance():getDailyData():setWxPayCount(UserManager:getInstance():getDailyData():getWxPayCount()+1)
			UserManager:getInstance():getDailyData():setWxPayRmb(UserManager:getInstance():getDailyData():getWxPayRmb()+price)
			UserService:getInstance():getDailyData():setWxPayCount(UserService:getInstance():getDailyData():getWxPayCount()+1)
			UserService:getInstance():getDailyData():setWxPayRmb(UserService:getInstance():getDailyData():getWxPayRmb()+price)
		end
		self:deliverItems(goodsId, goodsType)
		if NetworkConfig.writeLocalDataStorage then 
			Localhost:getInstance():flushCurrentUserData()
		else 
			print("RRR Did not write user data to the device.") 
		end
		SyncManager:getInstance():sync(nil, nil, false)

		local iconPos = self:getPanelIconPos()
		if self.successCallback then self.successCallback(self.amount, iconPos) end
		
		self:closeBuyConfirmPanel()				--关掉可能出现的购买确认面板
		self:closeRepayPanel()					--关掉可能出现的重新购买面板

		-- Q点不提示
		if self.paymentType ~= Payments.QQ then
			local finalPrice = PaymentManager:getPriceByPaymentType(goodsId, goodsType, self.paymentType)
			local goodsName = Localization:getInstance():getText("goods.name.text"..tostring(self.goodsIdInfo:getGoodsNameId()))
			GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kConsumeComplete,{ price = finalPrice, props = goodsName }))
		end

		PaymentManager.getInstance():tryChangeDefaultPaymentType(self.paymentType) 
	end

	if subPaymentType and subPaymentType == Payments.ALI_QUICK_PAY then -- 支付宝签约支付 前端server加道具
		Localhost.getInstance():ingame(goodsId, param.orderId, param.channelId, goodsType) 
		onSuccess()
	-- elseif subPaymentType and subPaymentType == Payments.WECHAT_QUICK_PAY then -- TODO
	-- 	Localhost.getInstance():ingame(goodsId, param.orderId, param.channelId, goodsType) 
	-- 	onSuccess()
	elseif PlatformConfig:isNeedOrderSuccessCheck(self.paymentType) then -- 强联网支付需要向后端查下订单是否成功，不需要走ingame逻辑
		print('wenkan checkOnlinePay ', self.paymentType)
		local function payCheckSuccess()
			Localhost.getInstance():ingame(goodsId, param.orderId, param.channelId, goodsType) -- 前端server加道具
			onSuccess()

		end
		local function payCheckFailed(errCode, errMsg)
			PaymentDCUtil.getInstance():sendAndroidPayCheckFailed(self.dcAndroidInfo)
			--这种情况下玩家已付款成功 但是查询未到账 不弹重买面板 直接失败
			self.noRePay = true
			self.checkFailed = true
			self:rmbBuyFailed(errCode, errMsg)
		end
		if param.checkBeforeSuccess then --在成功回调前向服务端请求过支付结果的 无需再次请求（目前用于360或者huawei支付时 特殊错误码）
			print('wenkan checkBeforeSuccess')
			payCheckSuccess()
		elseif self.paymentType == Payments.HUAWEI then --华为的正常支付成功不用向服务端查询订单结果
			payCheckSuccess()
		elseif self.paymentType == Payments.ALIPAY and subPaymentType and subPaymentType == Payments.ALI_SIGN_PAY then
			print('wenkan checkOnlinePayAliSignPay')
			self:checkOnlinePayAliSignPay(param.orderId, payCheckSuccess, payCheckFailed, self.needLoadingMask)
		else
			print('wenkan checkOnlinePay')
			self:checkOnlinePay(param.tradeId, payCheckSuccess, payCheckFailed, self.needLoadingMask)
		end
	else
		local function onIngameSuccess(evt)
			if not self.orderCompleted then
				self.orderCompleted = true
				onSuccess()
			else
				he_log_error(string.format("repeat ingame request: %s", table.tostring(param)))
			end
		end
		local function onIngameFail(errCode)
			self:rmbBuyFailed(errCode) 
		end
		local http = IngameHttp.new(true)
		http:ad(Events.kComplete, onIngameSuccess)
		http:ad(Events.kError, onIngameFail)
		if param.channelId ~= PlatformNameEnum.kVivo then
			local detail = param.detail
			if detail and type(detail) == "table" then
				detail = table.serialize(detail)
			end
		end
		http:load(goodsId, param.orderId, param.channelId, goodsType, detail, param.tradeId)

		if PaymentLimitLogic:isNeedLimit(self.paymentType) then 
			local finalPrice = PaymentManager:getPriceByPaymentType(goodsId, goodsType, self.paymentType)
			PaymentLimitLogic:buyComplete(self.paymentType, finalPrice)
			PaymentManager.getInstance():checkPaymentLimit(self.paymentType)
		end
	end
end

function IngamePaymentLogic:rmbBuyFailed(errCode, errMsg)
	if MaintenanceManager:getInstance():isEnabled("RepayPanelFeature") and not self.noRePay and self.repayChooseTable then 
		self:closeBuyConfirmPanel()                            --关闭可能已弹出的二次确认面板
		self.goodsIdInfo:setGoodsIdChange(self.oriGoodsIdType) --goodsId设为最开始的值 
		self.dcAndroidInfo:increaseTimes() 		   
		if not self.repayPanel then 
			if self.repayPanelPopFunc then self.repayPanelPopFunc() end
			local peDispatcher = self:getPaymentEventDispatcher(true)
			self.repayPanel = PayPanelRePay:create(peDispatcher, self.goodsIdInfo, self.paymentType, self.repayChooseTable)
			self.repayPanel:popout()
		else
			if not self.repayPanel.isDisposed then 
				self.repayPanel:setBuyBtnEnabled(true)
			end
		end
		CommonTip:showTip(Localization:getInstance():getText("payment.failure.tip.repay"), "negative")	
	else
		if self.goodsIdInfo:getGoodsType() == 2 and PaymentManager:isNeedThirdPayGuide(self.paymentType) then 
			ThirdPayGuideLogic:onPayFailure(self.paymentType, function ()
				if self.failCallback then self.failCallback(errCode, errMsg) end
			end)
		else
			if self.failCallback then
				if self.checkFailed then  
					self.failCallback(SelfDefinePayError.kPaySucCheckFail, Localization:getInstance():getText("error.tip.pay.fail.network")) 
				else
					self.failCallback(errCode, errMsg) 
				end
			end
		end
	end
end

function IngamePaymentLogic:rmbBuyCancel()
	if MaintenanceManager:getInstance():isEnabled("RepayPanelFeature") and not self.noRePay and self.repayChooseTable then 
		self:closeBuyConfirmPanel()  						    --关闭可能已弹出的二次确认面板
		self.goodsIdInfo:setGoodsIdChange(self.oriGoodsIdType) 	--goodsId设为最开始的值
		self.dcAndroidInfo:increaseTimes() 	
		if not self.repayPanel then 
			if self.repayPanelPopFunc then self.repayPanelPopFunc() end
			local peDispatcher = self:getPaymentEventDispatcher(true)
			self.repayPanel = PayPanelRePay:create(peDispatcher, self.goodsIdInfo, self.paymentType, self.repayChooseTable)
			self.repayPanel:popout()
		else
			if not self.repayPanel.isDisposed then 
				self.repayPanel:setBuyBtnEnabled(true)
			end
		end
		CommonTip:showTip(Localization:getInstance():getText("payment.cancel.tip.repay"), "negative")
	else
		if self.goodsIdInfo:getGoodsType() == 2 and PaymentManager:isNeedThirdPayGuide(self.paymentType) then 
			ThirdPayGuideLogic:onPayFailure(self.paymentType, function ()
				if self.cancelCallback then self.cancelCallback() end
			end)
		else
			if self.cancelCallback then self.cancelCallback() end
		end
	end
end

function IngamePaymentLogic:getPaymentEventDispatcher(isRepayPanel)
	local peDispatcher = PaymentEventDispatcher.new()
	peDispatcher:addEventListener(PaymentEvents.kBuyConfirmPanelPay, function (evt)
		if isRepayPanel then 
			self:repayPanelPay(evt)
		else
			self:confirmPanelPay(evt)
		end
	end)
	peDispatcher:addEventListener(PaymentEvents.kBuyConfirmPanelClose, function ()
		if isRepayPanel then 
			self:repayPanelClose()
		else
			self:confirmPanelClose()
		end
	end)
	return peDispatcher
end

function IngamePaymentLogic:repayPanelPay(event)
	local paymentType = event.data.defaultPaymentType
	self:buyWithPaymentType(paymentType)
end

function IngamePaymentLogic:repayPanelClose()
	self.repayPanel = nil
	self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseRepayPanel)
	PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
	--执行后续操作 这里加五步要特殊处理 直接结束游戏
	if self.gameOverCallback then 
		self.gameOverCallback()
	else
		if self.cancelCallback then self.cancelCallback() end
	end
end

function IngamePaymentLogic:confirmPanelPay(event)
	local paymentType = event.data.defaultPaymentType
	self:buyWithPaymentType(paymentType)
end

function IngamePaymentLogic:confirmPanelClose()
	self.buyConfirmPanel = nil
	local payResult = self.dcAndroidInfo:getResult()
	if payResult and payResult == AndroidRmbPayResult.kNoNet then 
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseAfterNoNet)
	else
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kCloseDirectly)
	end
	PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
	--执行后续操作
	if self.cancelCallback then self.cancelCallback() end
end

function IngamePaymentLogic:setBuyConfirmPanel(buyConfirmPanel)
	self.buyConfirmPanel = buyConfirmPanel
end

function IngamePaymentLogic:setOriGoodsIdType(oriGoodsIdType)
	self.oriGoodsIdType = oriGoodsIdType
end

function IngamePaymentLogic:getPanelIconPos()
	if self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed and self.buyConfirmPanel.getIconPos then 
		return self.buyConfirmPanel:getIconPos()
	elseif self.repayPanel and not self.repayPanel.isDisposed and self.repayPanel.getIconPos then
		return self.repayPanel:getIconPos()
	end
end

function IngamePaymentLogic:closeBuyConfirmPanel()
	if self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed and self.buyConfirmPanel.removePopout then 
		self.buyConfirmPanel:removePopout()
		self.buyConfirmPanel = nil
	end
end

function IngamePaymentLogic:closeRepayPanel()
	if self.repayPanel and not self.repayPanel.isDisposed and self.repayPanel.removePopout then 
		self.repayPanel:removePopout()
		self.repayPanel = nil
	end
end

function IngamePaymentLogic:hasPanelPopOutOnScene()
	if (self.buyConfirmPanel and not self.buyConfirmPanel.isDisposed and self.buyConfirmPanel:getParent()) or
		(self.repayPanel and not self.repayPanel.isDisposed and self.repayPanel:getParent()) then  
		return true
	end	
	return false
end

function IngamePaymentLogic:setRepayPanelPopFunc(repayPanelPopFunc)
	self.repayPanelPopFunc = repayPanelPopFunc
end

function IngamePaymentLogic:buy(successCallback, failCallback, cancelCallback, noRePay)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end

	self.successCallback = successCallback
	self.failCallback = failCallback
	self.cancelCallback = cancelCallback
	self.noRePay = noRePay

	
	local function handlePayment(decision, paymentType, dcAndroidStatus, otherPaymentTable, repayChooseTable, typeDisplay)
		print('wenkan decision ', decision, 'paymentType ', paymentType)
		if decision ~= IngamePaymentDecisionType.kPayWithWindMill then 		--风车币购买单独打点
			PaymentDCUtil.getInstance():sendAndroidRmbPayStart(self.dcAndroidInfo)
		end
		self.repayChooseTable = repayChooseTable
		self.dcAndroidInfo:setTypeStatus(dcAndroidStatus)
		--type_display：支持QQ钱包的实验用户的6种展示弹窗
		self.dcAndroidInfo:setTypeDisplay(typeDisplay)
		if repayChooseTable then 
			self.dcAndroidInfo:setRepayTypeList(repayChooseTable)
		end
		self:handlePaymentDecision(decision, paymentType, otherPaymentTable)
	end

	PaymentManager.getInstance():getAndroidPaymentDecision(self.goodsIdInfo:getGoodsId(), self.goodsIdInfo:getGoodsType(), handlePayment)
end

--目前用于加五步面板 
--没有走统一的buy方法是因为加五步面板的特殊性 需要提前调用PaymentManager.getInstance():getBuyItemDecision
function IngamePaymentLogic:endGameBuy(decision, paymentType, successCallback, failCallback, cancelCallback, gameOverCallback, repayChooseTable)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end

	self.successCallback = successCallback
	self.failCallback = failCallback
	self.cancelCallback = cancelCallback
	self.gameOverCallback = gameOverCallback
	self.repayChooseTable = repayChooseTable
	self.needLoadingMask = true

	if decision == IngamePaymentDecisionType.kPayFailed then 	
		--加五步面板断网导致支付失败要特殊处理 因为此时面板已经弹出
		if paymentType == AndroidRmbPayResult.kNoNet then 
			paymentType = PaymentManager.getInstance():getDefaultThirdPartPayment()
		else
			self:handlePayFailed(paymentType)
			return 
		end
	end

	if repayChooseTable then 
		self.dcAndroidInfo:setRepayTypeList(repayChooseTable)
	end
	self:buyWithPaymentType(paymentType)
end

--目前用于安卓破冰促销购买
function IngamePaymentLogic:salesBuy(paymentType, successCallback, failCallback, cancelCallback, repayChooseTable)
	if PrepackageUtil:isPreNoNetWork() then
		PrepackageUtil:showInGameDialog(cancelCallback)
		return 
	end

	self.successCallback = successCallback
	self.failCallback = failCallback
	self.cancelCallback = cancelCallback
	self.repayChooseTable = repayChooseTable
	self.needLoadingMask = true

	if repayChooseTable then 
		self.dcAndroidInfo:setRepayTypeList(repayChooseTable)
	end
	self:buyWithPaymentType(paymentType)
end

local paymentProxy
function IngamePaymentLogic:buyWithPaymentType(paymentType)
	print("wenkan zhijian==IngamePaymentLogic:buyWithPaymentType======",paymentType)
	self.paymentType = paymentType

	local goodsId = self.goodsIdInfo:getGoodsId()
	local goodsType = self.goodsIdInfo:getGoodsType()
	local finalPrice = PaymentManager.getInstance():getPriceByPaymentType(goodsId, goodsType, paymentType)

	self.dcAndroidInfo:setTypeChoose(paymentType)
	self.dcAndroidInfo:setGoodsId(goodsId)
	self.dcAndroidInfo:setRmbPrice(finalPrice)

	if not paymentProxy then
		paymentProxy = luajava.bindClass("com.happyelements.hellolua.aps.proxy.APSPaymentProxy"):getInstance()
	end
	paymentProxy:setPaymentType(paymentType)
	local paymentDelegate = paymentProxy:getPaymentDelegate()
	if not paymentDelegate then
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSdkInitFail)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
		self:rmbBuyFailed(0, "RRR  PaymentType not registered!")
		return
	end
	local tradeId = paymentDelegate:generateOrderId()

	local function sdkPaySuccess(evt)
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSuccess)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
		local result = evt.data.result
		self:rmbBuySuccess(luaJavaConvert.map2Table(result)) 
	end

	local function sdkPayFail(evt)
		local errCode = evt.data.errCode
		local errMsg = evt.data.errMsg
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSdkFail, errCode)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)

		self:sdkPayFailed(paymentType, tradeId, errCode, errMsg)
	end

	local function sdkPayCancel(evt)
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSdkCancel)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
		self:rmbBuyCancel() 
	end

	local function requsetErrorFunc(evt)
		local errCode = evt.data.errCode
		local errMsg = evt.data.errMsg
		local choosenType = evt.data.choosenType
		if choosenType then 
			self.dcAndroidInfo:setTypeChoose(choosenType)
		end
		if errCode == -6 then 
			self.dcAndroidInfo:setResult(AndroidRmbPayResult.kNoNet)
			if self.repayPanel and not self.repayPanel.isDisposed and self.repayPanel.setBuyBtnEnabled then 
				CommonTip:showTip(Localization:getInstance():getText("ali.quick.pay.error"))
				self.repayPanel:setBuyBtnEnabled(true)
			else
				self:rmbBuyFailed(errCode, errMsg)
			end
		else
			self.dcAndroidInfo:setResult(AndroidRmbPayResult.kDoOrderFail)
			self:rmbBuyFailed(errCode, errMsg)
		end
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
	end

	local function aliQuickPaySucFunc()
		self.dcAndroidInfo:setTypeChoose(Payments.ALI_QUICK_PAY)
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSuccess)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)

        self:rmbBuySuccess({orderId = tradeId, channelId = 0}, Payments.ALI_QUICK_PAY) 
	end

	local function aliSignAndPaySucFunc()
		print('wenkan aliSignAndPaySucFunc')
		self.dcAndroidInfo:setTypeChoose(Payments.ALI_QUICK_PAY) -- 支付统计到快付里面
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSuccess)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)

        self:rmbBuySuccess({orderId = tradeId, channelId = 0}, Payments.ALI_SIGN_PAY) 
	end

	local function WechatQuickPaySucFunc()
		print('wenkan WechatQuickPaySucFunc')
		self.dcAndroidInfo:setTypeChoose(Payments.WECHAT_QUICK_PAY)
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSuccess)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)

        self:rmbBuySuccess({tradeId = tradeId, channelId = 0}, Payments.WECHAT_QUICK_PAY) 
	end

	local onButton1Click = function()
		local sdkPayLogic = AndroidSDKPayLogic:create(paymentType, paymentDelegate, tradeId, self.goodsIdInfo, self.amount, finalPrice)
		sdkPayLogic:add(AndroidSDKPayEvents.kSdkPaySucess, sdkPaySuccess)
		sdkPayLogic:add(AndroidSDKPayEvents.kSdkPayFail, sdkPayFail)
		sdkPayLogic:add(AndroidSDKPayEvents.kSdkPayCancel, sdkPayCancel)
		sdkPayLogic:add(AndroidSDKPayEvents.kPreOrderRequestError, requsetErrorFunc)
		sdkPayLogic:add(AndroidSDKPayEvents.kAliQuickPaySuccess, aliQuickPaySucFunc)
		sdkPayLogic:add(AndroidSDKPayEvents.kAliSignAndPaySuccess, aliSignAndPaySucFunc)
		sdkPayLogic:add(AndroidSDKPayEvents.kWechatQuickPaySuccess, WechatQuickPaySucFunc)
	end


	local onButton2Click = function()
		self.dcAndroidInfo:setResult(AndroidRmbPayResult.kSmsPermission)
		PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
		self:rmbBuyCancel() 
	end

	if PaymentManager:checkPaymentTypeIsSms(paymentType) then
		CommonAlertUtil:showPrePkgAlertPanel(onButton1Click, NotRemindFlag.SMS_ALLOW, Localization:getInstance():getText("pre.tips.sms"),
											 nil, nil, onButton2Click)
	else
		onButton1Click()
	end
end

function IngamePaymentLogic:sdkPayFailed(paymentType, tradeId, errCode, errMsg)
	local function payCheckSuccess(param)
		self:rmbBuySuccess(param)
	end
	local function payCheckFailed(eCode, eMsg)
		self:rmbBuyFailed(eCode, eMsg)
	end
	if paymentType == Payments.QIHOO then
		if errCode == -2 then 
			-- 360 支付正在进行中，轮询支付结果
			self:checkOnlinePay(tradeId, payCheckSuccess, payCheckFailed, false, "360")
		elseif errCode == 4010201 then --access token失效 提示重新登录
			self:rmbBuyCancel()
			CommonTip:showTip(Localization:getInstance():getText("本次支付失败，请在联网状态下重新登录。"), "negative")
		elseif errCode == 4009911 then --QT失效 提示重新登录
			self:rmbBuyCancel()
			CommonTip:showTip(Localization:getInstance():getText("本次支付失败，请在联网状态下重新登录。"), "negative")
		else
			self:rmbBuyFailed(errCode, errMsg)
		end
	elseif paymentType == Payments.HUAWEI then 
		-- 40002 "支付成功，但验签失败！"   30002 "sdk支付结果查询超时" 这两个结果需要我们自己向后端轮询
		if errCode == 40002 or errCode == 30002 then 
			self:checkOnlinePay(tradeId, payCheckSuccess, payCheckFailed, true, "huawei")
		elseif errCode == 30008 then --"用户需要重新登录！"
			local function successFunc(data)
				self:buyWithPaymentType(paymentType)
			end
			local function failFunc(err, msg)
				self:rmbBuyFailed(errCode, errMsg)
			end
			SnsProxy:huaweiIngameLogin(successFunc, failFunc, failFunc)
		else
			self:rmbBuyFailed(errCode, errMsg)
		end
	else
		self:rmbBuyFailed(errCode, errMsg) 
	end
end

function IngamePaymentLogic:checkNeedSecondConfirm(paymentType)
	if not self._ignoreSecondConfirm and
		(paymentType == Payments.CHINA_MOBILE or paymentType == Payments.DUOKU and not MaintenanceManager:getInstance():isEnabled("SecPayPanel")) or 	
		(paymentType == Payments.CHINA_UNICOM and not MaintenanceManager:getInstance():isEnabled("SecPayPanel_Uni")) or 
		(paymentType == Payments.CHINA_TELECOM or paymentType == Payments.TELECOM3PAY and not MaintenanceManager:getInstance():isEnabled("SecPayPanel_189")) or 
		(paymentType == Payments.CHINA_MOBILE_GAME and not MaintenanceManager:getInstance():isEnabled("SecPayPanel_Cmgame")) then 
		return true
	end
	return false
end

function IngamePaymentLogic:handlePaymentDecision(decision, paymentType, otherPaymentTable)
	print("wenkan pay_process handlePaymentDecision: "..tostring(decision))
	if decision == IngamePaymentDecisionType.kPayFailed then 				    --支付失败
		self:handlePayFailed(paymentType)
	elseif decision == IngamePaymentDecisionType.kPayWithType then 				--正常选定支付(购买风车币)
		self:handlePayWithType(paymentType)
	elseif decision == IngamePaymentDecisionType.kSmsPayOnly then               --仅短代支付 
		self:handleSmsPayOnly(paymentType)
	elseif decision == IngamePaymentDecisionType.kThirdPayOnly then             --仅三方支付
		self:handleThirdPayOnly(paymentType, otherPaymentTable)
	elseif decision == IngamePaymentDecisionType.kSmsWithOneYuanPay then        --短代带三方一元特价
		self:pocessOneYuanCommon()
		self:handleSmsWithOneYuanPay(paymentType, otherPaymentTable)
	elseif decision == IngamePaymentDecisionType.kThirdOneYuanPay then 	        --仅三方一元特价
		self:pocessOneYuanCommon()
		self:handleThirdOneYuanPay(paymentType, otherPaymentTable)
	elseif decision == IngamePaymentDecisionType.kGoldOneYuanPay then 			--一元购买风车币活动
		self:handleGoldOneYuanPay()
	elseif decision == IngamePaymentDecisionType.kPayWithWindMill then		    --风车币支付
		self:handlePayWithWindMill()
	else
		assert("Unexcepted payment decision " .. decision .. ", " .. paymentType)
	end 
end

--触发一元特价时 所有统一的处理
function IngamePaymentLogic:pocessOneYuanCommon()
	self:pocessOneYuanEnergyBottle()
	PaymentManager.getInstance():refreshOneYuanShowTime()
	self:setOriGoodsIdType(GoodsIdChangeType.kOneYuanChange)
	self.goodsIdInfo:setGoodsIdChange(GoodsIdChangeType.kOneYuanChange)
end

--高级精力瓶要有特殊处理 同一个精力面板下 只要没买 可以一直触发一元特价
function IngamePaymentLogic:pocessOneYuanEnergyBottle()
	local goodsId = self.goodsIdInfo:getOriginalGoodsId()
	if goodsId == 18 then 
		local curEnergyPanel = PaymentManager.getInstance():getCurrentEnergyPanel()
		PaymentManager.getInstance():setOneYuanEnergyPanel(curEnergyPanel)
	end
end

function IngamePaymentLogic:handlePayFailed(resultCode)
	if not resultCode then resultCode = AndroidRmbPayResult.kNoPaymentAvailable end
	if resultCode == AndroidRmbPayResult.kNoNet then 
		local defaultThirdPartPayment = PaymentManager.getInstance():getDefaultThirdPartPayment()
		self.dcAndroidInfo:setInitialTypeList(defaultThirdPartPayment)
		self.dcAndroidInfo:setTypeChoose(defaultThirdPartPayment)
		CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"), "negative")
	else
		CommonTip:showTip(Localization:getInstance():getText("buy.gold.panel.err.undefined"), "negative")
	end
	self.dcAndroidInfo:setResult(resultCode)
	PaymentDCUtil.getInstance():sendAndroidRmbPayEnd(self.dcAndroidInfo)
	if self.cancelCallback then self.cancelCallback() end
end

function IngamePaymentLogic:handlePayWithType(paymentType)
	print('wenkan handlePayWithType ', paymentType)
    self.dcAndroidInfo:setInitialTypeList(paymentType)
	self:buyWithPaymentType(paymentType)
end

function IngamePaymentLogic:handleSmsPayOnly(paymentType)
	self.dcAndroidInfo:setInitialTypeList(paymentType)
	if self:checkNeedSecondConfirm(paymentType) then 
		local peDispatcher = self:getPaymentEventDispatcher()
		self.buyConfirmPanel = PayPanelSingleSms:create(peDispatcher, self.goodsIdInfo, paymentType)
		self.buyConfirmPanel:popout()
	else
		self:buyWithPaymentType(paymentType)
	end
end

function IngamePaymentLogic:handleThirdPayOnly(paymentType, otherPaymentTable)
	print('wenkan handleThirdPayOnly ', paymentType)
	self.dcAndroidInfo:setInitialTypeList(otherPaymentTable, paymentType)
	local peDispatcher = self:getPaymentEventDispatcher()
	if otherPaymentTable and #otherPaymentTable>0 then 
		--创建两个按钮的三方支付面板
		self.buyConfirmPanel = PayPanelMultiThird:create(peDispatcher, self.goodsIdInfo, paymentType, otherPaymentTable)
		self.buyConfirmPanel:popout()
	else
		local AliQuickPayGuide = require "zoo.panel.alipay.AliQuickPayGuide"
		local WechatQuickPayGuide = require "zoo.panel.wechatPay.WechatQuickPayGuide"
		if paymentType == Payments.ALIPAY and 
			(UserManager.getInstance():isAliSigned() 
				or UserManager.getInstance():isAliNeverSigned() and AliQuickPayGuide.isGuideTime())then
			print('wenkan PayPanelSingleThird111')
			self.buyConfirmPanel = PayPanelSingleThird:create(peDispatcher, self.goodsIdInfo, paymentType)
			self.buyConfirmPanel:popout()
			AliQuickPayGuide.updateGuideTimeAndPopCount()
		elseif paymentType == Payments.WECHAT and
			(UserManager.getInstance():isWechatSigned()
				or UserManager.getInstance():isWechatNeverSigned() and WechatQuickPayGuide.isGuideTime()) and _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then
			print('wenkan PayPanelSingleThird444')
			self.buyConfirmPanel = PayPanelSingleThird:create(peDispatcher, self.goodsIdInfo, paymentType)
			self.buyConfirmPanel:popout()
			WechatQuickPayGuide.updateGuideTimeAndPopCount()
		elseif self:checkNeedSecondConfirm(paymentType) then 
			print('wenkan PayPanelSingleThird222')
			self.buyConfirmPanel = PayPanelSingleThird:create(peDispatcher, self.goodsIdInfo, paymentType)
			self.buyConfirmPanel:popout()
		else
			print('wenkan PayPanelSingleThird333')
			self:buyWithPaymentType(paymentType)
		end
	end
end

function IngamePaymentLogic:handleSmsWithOneYuanPay(paymentType, otherPaymentTable)
	self.dcAndroidInfo:setInitialTypeList(otherPaymentTable, paymentType)
	local peDispatcher = self:getPaymentEventDispatcher()
	self.buyConfirmPanel = PayPanelSingleSms:create(peDispatcher, self.goodsIdInfo, paymentType, otherPaymentTable)
	self.buyConfirmPanel:popout()
end

function IngamePaymentLogic:handleThirdOneYuanPay(paymentType, otherPaymentTable)
	self.dcAndroidInfo:setInitialTypeList(otherPaymentTable, paymentType)
	local peDispatcher = self:getPaymentEventDispatcher()
	if otherPaymentTable and #otherPaymentTable>0 then 
		--创建两个按钮的三方一元支付面板
		self.buyConfirmPanel = PayPanelMultiThirdOff:create(peDispatcher, self.goodsIdInfo, paymentType, otherPaymentTable)
		self.buyConfirmPanel:popout()
	else
		--创建一个按钮的三方一元支付面板
		self.buyConfirmPanel = PayPanelSingleThirdOff:create(peDispatcher, self.goodsIdInfo, paymentType)
		self.buyConfirmPanel:popout()
	end
end

function IngamePaymentLogic:handleGoldOneYuanPay()
	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	local thirdPartyPaymentNum = #thirdPaymentConfig
	local cancelCallback = function ()
		self:rmbBuyCancel()
	end 
	local withConfirmPanel = true
	if thirdPartyPaymentNum > 0 then 
		self.dcAndroidInfo:setInitialTypeList(thirdPaymentConfig)
		if thirdPartyPaymentNum == 1 then 
            if thirdPaymentConfig[1] == PlatformPaymentThirdPartyEnum.kWECHAT then setTimeOut(cancelCallback, 3) end -- 3秒调取消，解决微信未登录就没有回调的问题
			self:buyWithPaymentType(thirdPaymentConfig[1])
		else
			--50%的用户引导开通支付宝快捷支付
			local uid = tonumber(UserManager.getInstance().uid) or 0
			if uid%2 == 0 or not table.includes(thirdPaymentConfig, PlatformPaymentThirdPartyEnum.kALIPAY) then
				local supportedPayments = {}
				for i,v in ipairs(thirdPaymentConfig) do supportedPayments[v] = true end
				local panel = ChoosePaymentPanel:create(supportedPayments,"选择您希望的支付方式:", true)
				local function onChoosen(choosenType)
					if choosenType then            
	                    if choosenType == PlatformPaymentThirdPartyEnum.kWECHAT then setTimeOut(cancelCallback, 3) end -- 3秒调取消，解决微信未登录就没有回调的问题
						self:buyWithPaymentType(choosenType)
					else
						cancelCallback() 
					end
				end
				if panel then panel:popout(onChoosen) end
			else
				local function onChoosen(choosenType)
					if choosenType then
						if choosenType == PlatformPaymentThirdPartyEnum.kALI_QUICK_PAY then
							local function onSignSuccess()
								self:buyWithPaymentType(PlatformPaymentThirdPartyEnum.kALIPAY)
							end

							local AliPaymentSignAccountPanel = require "zoo.panel.alipay.AliPaymentSignAccountPanel"
							local panel = AliPaymentSignAccountPanel:create(AliQuickSignEntranceEnum.BUY_IN_GAME_PANEL)
							if AliQuickPayPromoLogic:isEntryEnabled() then
				                panel:setReduceShowOption(AliPaymentSignAccountPanel.showNormalReduce)
				            end
							panel:popout(onSignSuccess)
						else
							-- 3秒调取消，解决微信未登录就没有回调的问题
		                    if choosenType == PlatformPaymentThirdPartyEnum.kWECHAT then setTimeOut(cancelCallback, 3) end
							self:buyWithPaymentType(choosenType)
						end
					else
						cancelCallback()
					end
				end

				local NewChoosePaymentPanel = require "zoo.panel.alipay.NewChoosePaymentPanel"
				local panel = NewChoosePaymentPanel:create()
				panel:popout(onChoosen)
			end
		end
	else
		assert(false, "IngamePaymentLogic:handleGoldOneYuanPay---impossible")
	end
end

function IngamePaymentLogic:handlePayWithWindMill()
	local buyConfirmPanel = PayPanelWindMill:create(self.goodsIdInfo:getGoodsId(), self.successCallback, self.cancelCallback)
	buyConfirmPanel:popout()
end

function IngamePaymentLogic:checkOnlinePayAliSignPay(orderId, successCallback, failedCallback, needLoading)
	print('wenkan checkOnlinePayAliSignPay orderId ', orderId)
	local tips = Localization:getInstance():getText("tips.in.pay.not.finish")
    local animation

    local retry = 3
    local interval = 2

    function queryOnlinePayState()
    	PaymentManager.getInstance():setIsCheckingPayResult(true)

        print("queryOnlinePayState.."..tostring(retry))
        local function onRequestError( evt )
            evt.target:removeAllEventListeners()
            print("onRequestError callback")
            if retry > 0 then
           	 	setTimeOut(queryOnlinePayState, interval)
           	else
           		if animation then animation:removeFromParentAndCleanup(true) end 
           		PaymentManager.getInstance():setIsCheckingPayResult(false)

            	failedCallback(0, "purchase failed")
        	end
        end
        local function onRequestFinish( evt )
        	print('wenkan onRequestFinish ', evt.finished, evt.success, evt.agreeNo)
            evt.target:removeAllEventListeners()
            print("onRequestFinish callback")
            if evt.data and evt.data.finished then
            	if animation then animation:removeFromParentAndCleanup(true) end 
            	PaymentManager.getInstance():setIsCheckingPayResult(false)


            	-- 默认认为签约已经成功
                -- if evt.data.agreeNo and evt.data.agreeNo ~= '' then
                	UserManager.getInstance().userExtend.aliIngameState = 1
					UserService.getInstance().userExtend.aliIngameState = 1
					if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
	  				else print("Did not write user data to the device.") end
                -- end

                if evt.data.success then
					successCallback()
                else
                    failedCallback(0, "purchase failed")
                end

            else
                if retry > 0 then
           	 		setTimeOut(queryOnlinePayState, interval)
                else
                	if animation then animation:removeFromParentAndCleanup(true) end 
                	PaymentManager.getInstance():setIsCheckingPayResult(false)

                    failedCallback(1, "purchase failed")
                end
            end
        end

        local http = QueryAliOrderHttp.new()
        http:addEventListener(Events.kComplete, onRequestFinish)
        http:addEventListener(Events.kError, onRequestError)
        http:load(orderId)

        interval = interval * 2
        retry = retry - 1
    end

    if needLoading then 
    	local scene = Director:sharedDirector():getRunningScene()
	    animation = CountDownAnimation:createNetworkAnimation(scene, nil, Localization:getInstance():getText("订单结果查询中"))
    end

    queryOnlinePayState()
end

function IngamePaymentLogic:checkOnlinePay(orderId, successCallback, failedCallback, needLoading, checkBeforeSuccessChanel)
	print('wenkan IngamePaymentLogic:checkOnlinePay')
	local tips = Localization:getInstance():getText("tips.in.pay.not.finish")
    local animation

    local retry = 3
    local interval = 2

    function queryOnlinePayState()
    	PaymentManager.getInstance():setIsCheckingPayResult(true)

        print("queryOnlinePayState.."..tostring(retry))
        local function onRequestError( evt )
            evt.target:removeAllEventListeners()
            print("onRequestError callback")
            if retry > 0 then
           	 	setTimeOut(queryOnlinePayState, interval)
           	else
           		if animation then animation:removeFromParentAndCleanup(true) end 
           		PaymentManager.getInstance():setIsCheckingPayResult(false)

            	failedCallback(0, "purchase failed")
        	end
        end
        local function onRequestFinish( evt )
            evt.target:removeAllEventListeners()
            print("onRequestFinish callback")
            if evt.data and evt.data.finished then
            	if animation then animation:removeFromParentAndCleanup(true) end 
            	PaymentManager.getInstance():setIsCheckingPayResult(false)

                if evt.data.success then
                	if checkBeforeSuccessChanel then 
                		local ret = {orderId = orderId, tradeId = orderId, channelId = checkBeforeSuccessChanel, checkBeforeSuccess = true}
                    	successCallback(ret)
                	else
						successCallback()
					end
                else
                    failedCallback(0, "purchase failed")
                end
            else
                if retry > 0 then
           	 		setTimeOut(queryOnlinePayState, interval)
                else
                	if animation then animation:removeFromParentAndCleanup(true) end 
                	PaymentManager.getInstance():setIsCheckingPayResult(false)

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

    if needLoading then 
    	local scene = Director:sharedDirector():getRunningScene()
	    animation = CountDownAnimation:createNetworkAnimation(scene, nil, Localization:getInstance():getText("订单结果查询中"))
    end

    queryOnlinePayState()
end

function IngamePaymentLogic:getLevelId()
	local user = UserManager:getInstance().user
	local stageInfo = StageInfoLocalLogic:getStageInfo(user.uid)
	if stageInfo then 
		return stageInfo.levelId 
	else
		return -1
	end
end

function IngamePaymentLogic:deliverItems(goodsId, goodsType)
	local goodsInfoMeta = MetaManager:getInstance():getGoodMeta(goodsId)
	local price = PaymentManager:getPriceByPaymentType(goodsId, goodsType, self.paymentType)
	local levelId = self:getLevelId()
	if goodsType == 1 then 
		self:updatePropCount(goodsInfoMeta, levelId)
	end
	DcUtil:logRmbBuy(goodsId, goodsType, price, self.amount, levelId) 
	-- items 
	-- 更新本日购买列表
	print("Update buyed list")
	if goodsInfoMeta and goodsInfoMeta.limit > 0 then
		UserManager:getInstance():addBuyedGoods(goodsId, 1)
		UserService.getInstance():addBuyedGoods(goodsId, 1)
	end
end

function IngamePaymentLogic:updatePropCount(goodsInfoMeta, levelId)
	local manager = UserManager:getInstance()
	local items = {}
	for __, v in ipairs(goodsInfoMeta.items) do 
		table.insert(items, {itemId = v.itemId, num = v.num}) 
	end
	-- 加东西
	for __, v in ipairs(items) do
		local user = UserManager:getInstance():getUserRef()
		if v.itemId == 2 then
			user:setCoin(user:getCoin() + v.num)
		elseif v.itemId == 14 then
			user:setCash(user:getCash() + v.num)
		elseif ItemType:isItemNeedToBeAdd(v.itemId) then
			manager:addUserPropNumber(v.itemId, v.num)
			DcUtil:logRewardItem("buy", v.itemId, v.num, levelId)
		end
	end
end

function IngamePaymentLogic:ignoreSecondConfirm(value)
	self._ignoreSecondConfirm = value
end