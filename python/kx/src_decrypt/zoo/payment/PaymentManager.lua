require "zoo.payment.WMBBuyItemLogic"
require "zoo.payment.PaymentNetworkCheck"
require "zoo.payment.paymentDC.DCAndroidStatus"
require 'zoo.payment.WechatQuickPayLogic'

IngamePaymentDecisionType = table.const {
	kPayFailed = 1,
	kPayWithType = 2,
	kSmsPayOnly = 3,
	kThirdPayOnly = 4,
	kSmsWithOneYuanPay = 5,			--短代和三方都可用时 一元限购
	kThirdOneYuanPay = 6,			--仅三方可用时 一元限购
	kGoldOneYuanPay = 7,			--一元购买风车币(这个只处理在默认栏里的,若是微信支付宝等独有的栏，不会走这套逻辑)

	kPayWithWindMill = 101,
}

ThirdPayPromotionConfig = table.const {
    [18]    = {itemId = 10014, discount = 1}, -- 高级精力瓶
    -- [17]    = {itemId = 10013, discount = 3}, -- 中级精力瓶 -- 暂时缺短代支付点
    [147]   = {itemId = 10052, discount = 1}, -- 章鱼冰
    [148]   = {itemId = 10052, discount = 1}, -- 章鱼冰（6元打折版）
    [5]     = {itemId = 10005, discount = 1}, -- 条纹刷子
    [3]     = {itemId = 10003, discount = 1}, -- 强制交换
    [4]     = {itemId = 10004, discount = 2}, -- +5道具栏
    [24]    = {itemId = 10004, discount = 2}, -- +5 最终
    [33]    = {itemId = 10004, discount = 2}, -- +5 最终（4元打折版）
    [46]    = {itemId = 10040, discount = 2}, -- 兔兔导弹 飞碟关复活
    [47]    = {itemId = 10040, discount = 2}, -- 兔兔导弹 飞碟关复活（4元打折版）
    -- [150]   = {itemId = 10054, discount = 2}, -- 萌兔周赛次数
    [7]     = {itemId = 10010, discount = 3}, -- 小木槌
    [1]     = {itemId = 10001, discount = 3}, -- 刷新
    [151]   = {itemId = 10055, discount = 3}, -- 随机魔力鸟
    [155]   = {itemId = 16,    discount = 3}, -- +15秒
    [153]   = {itemId = 10056, discount = 3}, -- 消2行
    [2]     = {itemId = 10002, discount = 5}, -- 后退
}

SmsLimitType = table.const {
	kDailyLimit = 1,
	kMonthlyLimit = 2,	
}

SmsDisableReason = table.const{
	kSmsLimit = 1,
	kSmsClose = 2,
	kSimCardError = 3,
}

local ThirdPayWithoutNetCheck = {
	Payments.WO3PAY,
	Payments.TELECOM3PAY,
}

SelfDefinePayError = table.const{
	kPaySucCheckFail = 800000,
}

PaymentManager = class()
local instance = nil

function PaymentManager.getInstance()
	if not instance then
		instance = PaymentManager.new()
		instance:init()
	end
	return instance
end

function PaymentManager:init()
	self.userDefault = CCUserDefault:sharedUserDefault()
	--玩家是否已用过三方支付（服务端记个标识 方便进行开卡活动）
	self.hasFirstThirdPay = false
	--短代是否超限额  
	self.smspayPassLimit = false 
	--短代超限额类型
	self.smspayLimitType = SmsLimitType.kDailyLimit

	self:checkPaymentLimit(self:getDefaultSmsPayment())

	self.defaultSmsPayment = nil
	--本地记录的默认三方支付类型
	self.defaultThirdPartyPayment = self.userDefault:getIntegerForKey("default.third.payment")
	--初始化默认支付（可能是三方或者短代）
	self.defaultPayment = self:getServerDefaultPaymentType()
	if self.defaultPayment == 0 then 
		self.defaultPayment = self.userDefault:getIntegerForKey("default.setting.payment")
	end
	self.lastDefaultPayment = self.defaultPayment
	self.defaultPayment = self:getDefaultPayment()
	--一元特价每日首次提示时间
	self.oneYuanShowTime = self.userDefault:getStringForKey("one.yuan.show.time")
	--今日第一次关卡内触发一元特价时 记录今日时间 
	self.isTodayFirstOneYuanLevel = self.userDefault:getIntegerForKey("one.yuan.today.level")

	--需要向服务端查询订单结果的三方支付  这里记录个查询状态
	self.isCheckingPayResult = false

	--支付宝免密支付上限金额
	self.aliQuickPayLimit = 60

	-- 微信免密支付金额上限
	self.wechatQuickPayLimit = 30

	--风车币默认栏中（包含短代的那个） 是否是一元特价的处理标识
	self.goldOneYuanThirdPay = false 

	--本地记录的连续三次短代支付的次数
	self.continueSmsPayCount = self.userDefault:getIntegerForKey("continue.smspay.count")
end

function PaymentManager:getPaymentShowConfig(paymentType)
	local function generateConfig(name, smallIcon, bigIcon)
		local showConfig = {}
		showConfig.name = name
		showConfig.smallIcon = smallIcon
		showConfig.bigIcon = bigIcon
		return showConfig
	end

	if paymentType == Payments.CHINA_MOBILE or paymentType == Payments.CHINA_MOBILE_GAME then
		return generateConfig(localize("panel.no.net.pay.botton2"), "pay_icon/icon_mobile_small0000", "pay_icon/icon_mobile_big0000")
	elseif paymentType == Payments.CHINA_UNICOM then 
		return generateConfig(localize("panel.no.net.pay.botton2"), "pay_icon/icon_unicom_small0000", "pay_icon/icon_unicom_big0000")
	elseif paymentType == Payments.CHINA_TELECOM then 
		return generateConfig(localize("panel.no.net.pay.botton2"), "pay_icon/icon_telecom_small0000", "pay_icon/icon_telecom_big0000")
	elseif paymentType == Payments.WECHAT then
		if UserManager:getInstance():isWechatSigned() and _G.wxmmGlobalEnabled and WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then 
			return generateConfig(localize("wechat.kf.button"), "pay_icon/icon_wechat_small0000", "pay_icon/icon_wechat_big0000")
		else
			return generateConfig(localize("panel.choosepayment.wechat"), "pay_icon/icon_wechat_small0000", "pay_icon/icon_wechat_big0000")
		end
	elseif paymentType == Payments.QQ then 
		return generateConfig(localize("panel.choosepayment.wechat"), "pay_icon/icon_wechat_small0000", "pay_icon/icon_wechat_big0000")
	elseif paymentType == Payments.ALIPAY then 
		if UserManager:getInstance():isAliSigned() then 
			return generateConfig(localize("accredit.title"), "pay_icon/icon_ali_small0000", "pay_icon/icon_ali_big0000")		--支付宝快付
		else
			return generateConfig(localize("panel.choosepayment.alipay"), "pay_icon/icon_ali_small0000", "pay_icon/icon_ali_big0000")
		end
	elseif paymentType == Payments.WDJ then 
		return generateConfig(localize("market.panel.buy.gold.title.wandoujia"), "pay_icon/icon_wdj_small0000", "pay_icon/icon_wdj_big0000")
	elseif paymentType == Payments.QIHOO then 
		return generateConfig(localize("panel.choosepayment.payment.360"), "pay_icon/icon_qihoo_small0000", "pay_icon/icon_qihoo_big0000")
	elseif paymentType == Payments.MI then 
		return generateConfig(localize("panel.choosepayment.payments.mi"), "pay_icon/icon_mi_small0000", "pay_icon/icon_mi_big0000")
	elseif paymentType == Payments.HUAWEI then 
		return generateConfig(localize("panel.choosepayment.payments.huawei"), "pay_icon/icon_huawei_small0000", "pay_icon/icon_huawei_big0000")
	elseif paymentType == Payments.QQ_WALLET then 
		return generateConfig(localize("panel.choosepayment.payments.qqwallet"), "pay_icon/icon_qqwallet_small0000", "pay_icon/icon_qqwallet_big0000")
	else
		return generateConfig(localize("panel.no.net.pay.botton2"), "pay_icon/icon_sms_union_small0000", "pay_icon/icon_sms_union_big0000")
	end
end

function PaymentManager:checkSmsPayEnabled()
	local smsPayEnabled = true
	local smsPayDisableReason = nil
	
	--是否超限额 
	if self:getIsSmsPaymentLimit() then 
		smsPayEnabled = false
		smsPayDisableReason = SmsDisableReason.kSmsLimit
	else
		local operator = AndroidPayment.getInstance():getOperator()
		--是否关停
		if operator == TelecomOperators.CHINA_MOBILE then
	        if AndroidPayment.getInstance():filterCMPayment() == PlatformPaymentChinaMobileEnum.kUnsupport then 
	            smsPayEnabled = false
	            smsPayDisableReason = SmsDisableReason.kSmsClose
	        end
	    elseif operator == TelecomOperators.CHINA_UNICOM then
	        if AndroidPayment.getInstance():filterCUPayment() == PlatformPaymentChinaUnicomEnum.kUnsupport then 
	            smsPayEnabled = false
	            smsPayDisableReason = SmsDisableReason.kSmsClose
	        end
	    elseif operator == TelecomOperators.CHINA_TELECOM then
	        if AndroidPayment.getInstance():filterCTPayment() == PlatformPaymentChinaTelecomEnum.kUnsupport then 
	            smsPayEnabled = false
	            smsPayDisableReason = SmsDisableReason.kSmsClose
	        end
	    else
	    	--没卡 或者卡有问题等情况
	    	smsPayEnabled = false
	    	smsPayDisableReason = SmsDisableReason.kSimCardError
	    end
	end
	return smsPayEnabled, smsPayDisableReason
end

function PaymentManager:checkThirdPartPaymentEabled()
	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	if thirdPaymentConfig then 
		for i,v in ipairs(thirdPaymentConfig) do
			if v ~= PlatformPaymentThirdPartyEnum.kUnsupport then 
				return true
			end
		end
	end
	return false
end

function PaymentManager:getWindMillTabShowState()
	local tab_normal = false
	local tab_wechat = false
	local tab_ali = false
	local tab_qihoo = false
	local tab_wandoujia = false
	local tab_msdk = false
	local tab_mi = false
	local tab_huawei = false
	local tab_qqwallet = false
	if self:checkSmsPayEnabled() then 
		tab_normal = true
		if self:checkThirdPartPaymentEabled() then 
			local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
			for i,v in ipairs(thirdPaymentConfig) do
				if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
					tab_wechat = true
				elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
				  	tab_ali = true
				elseif v == PlatformPaymentThirdPartyEnum.k360 then 
				  	tab_qihoo = true
				elseif v == PlatformPaymentThirdPartyEnum.kWDJ then 
				  	tab_wandoujia = true
				elseif v == PlatformPaymentThirdPartyEnum.kQQ then 
				  	tab_msdk = true
				elseif v == PlatformPaymentThirdPartyEnum.kMI and PlatformConfig:isPlatform(PlatformNameEnum.kMI) then
					tab_mi = true
				elseif v == PlatformPaymentThirdPartyEnum.kHUAWEI then 
					tab_huawei = true
				elseif v == PlatformPaymentThirdPartyEnum.kQQ_WALLET then 
					tab_qqwallet = true
				end 
			end
		end
	else
		if self:checkThirdPartPaymentEabled() then 
			--仅三方支付
			local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
			for i,v in ipairs(thirdPaymentConfig) do
				if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
					tab_wechat = true
				elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
				  	tab_ali = true
				elseif v == PlatformPaymentThirdPartyEnum.k360 then 
				  	tab_qihoo = true
				elseif v == PlatformPaymentThirdPartyEnum.kWDJ then 
				  	tab_wandoujia = true
				elseif v == PlatformPaymentThirdPartyEnum.kQQ then 
					tab_msdk = true
				elseif v == PlatformPaymentThirdPartyEnum.kMI and PlatformConfig:isPlatform(PlatformNameEnum.kMI) then
					tab_mi = true
				elseif v == PlatformPaymentThirdPartyEnum.kHUAWEI then 
					tab_huawei = true
				elseif v == PlatformPaymentThirdPartyEnum.kQQ_WALLET then 
					tab_qqwallet = true
				else
					--大额支付也在normal那一栏里 所以这里要判断下
					if v == PlatformPaymentThirdPartyEnum.kMI 
						or v == PlatformPaymentThirdPartyEnum.kWO3PAY
						or v == PlatformPaymentThirdPartyEnum.kTELECOM3PAY then 
					  	tab_normal = true
					end 
				end 
			end
		else
			--无法支付
			--无法支付也给显示个普通栏 虽然支付会失败
			tab_normal = true
		end
	end
	return tab_normal, tab_wechat, tab_ali, tab_qihoo, tab_wandoujia, tab_msdk, tab_mi, tab_huawei, tab_qqwallet
end

function PaymentManager:getAndroidPaymentDecision(goodsId, goodsType, handlePayment)
	if goodsType == 2 then 
		print('wenkan getAndroidPaymentDecision 111111111111111')
		self:getBuyGoldDecision(handlePayment, goodsId)
	else
		print('wenkan getAndroidPaymentDecision 222222222222222')
		self:getBuyItemDecision(handlePayment, goodsId)
	end
end

function PaymentManager:getBuyGoldDecision(handlePayment, goodsId)
	local decesion, payment
	if PaymentManager.getInstance():getGoldOneYuanThirdPay() then 			--风车币默认栏 可能出现的一元特价
		decesion = IngamePaymentDecisionType.kGoldOneYuanPay
	elseif PlatformConfig:getCurrentPayType()==PlatformPayType.kWechat 		--风车币微信栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kAlipay 		--风车币支付宝栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kQihoo		--风车币360栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kWandoujia  	--风车币豌豆荚栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kQQ 			--风车币QQ栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kMI 			--风车币小米栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kHuaWei 		--风车币华为栏
		or PlatformConfig:getCurrentPayType()==PlatformPayType.kQQWallet 	--风车币QQ钱包栏
		or self:isThirdPartPaymentOnly(goodsId, 2)							--风车币普通栏里的大额支付
		or not self:checkSmsPayEnabled() then 								--短代不可用
			decesion, payment = self:getThirdPartPaymentDecision()
	else
		decesion, payment = self:getSMSPaymentDecision()
	end
	handlePayment(decesion, payment)
end

function PaymentManager:getBuyItemDecision(handlePayment, goodsId)
	assert(handlePayment)
	if self:checkCanWindMillPay(goodsId) then 
		if handlePayment then 
			handlePayment(IngamePaymentDecisionType.kPayWithWindMill)
		end
	else
		self:getRMBBuyItemDecision(handlePayment, goodsId)
	end
end

function PaymentManager:getThirdPartPaymentReorder( needReorder )
	if not needReorder or not self:isQQWalletNeedReorder() then 
		return AndroidPayment.getInstance().thirdPartyPayment 
	end

	local defaultThirdPartyPayment = self:getDefaultThirdPartPayment(needReorder)
	local otherThirdPayTable = self:getOtherThirdPartPayment(needReorder)

	table.insert(otherThirdPayTable, 1, defaultThirdPartyPayment)

	return otherThirdPayTable
end

function PaymentManager:getRMBBuyItemDecision(handlePayment, goodsId)
	local repayChooseTable = {}
	local dcAndroidStatus = DCAndroidStatus:create()

	if self:checkDefaultPaymentIsSmsPay() then 
		dcAndroidStatus:push(DecisionJudgeType.kDefaultPaymentType.YES) 
		local smsEnable, disableReason = self:checkSmsPayEnabled()
		dcAndroidStatus:pushWithSmsEnableCheck(disableReason) 
		if smsEnable then 
			local defaultSmsPayment = self:getDefaultSmsPayment()
			if self:checkNeedOneYuanPay(goodsId) then 
				dcAndroidStatus:push(DecisionJudgeType.kOneYuanEnable.YES)
				PaymentNetworkCheck.getInstance():check(function ()
					--短代原价 + 三方 一元限购  加五步面板的特殊（无短代）
					dcAndroidStatus:push(DecisionJudgeType.kNetEnable.YES)
	
					if self:isEndGamePanelGoods(goodsId) then
						--重新获取defaultThirdPartyPayment，防止其他操作对加5步的影响
						local defaultThirdPartyPayment = self:getDefaultThirdPartPayment()
						local thirdPartPaymentTable = AndroidPayment.getInstance().thirdPartyPayment
						repayChooseTable = table.union(thirdPartPaymentTable, {defaultSmsPayment})

						handlePayment(IngamePaymentDecisionType.kSmsWithOneYuanPay, defaultThirdPartyPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
					else
						--打点需求，临时传递,支持QQ钱包的实验用户的6种展示弹窗
						local thirdPartPaymentTable = self:getThirdPartPaymentReorder(true)
						if #thirdPartPaymentTable > 2 then
							for index = 3,#thirdPartPaymentTable do
								table.remove(thirdPartPaymentTable, index)
							end
						end

						local typeDisplay = self:getTypeDisplay()
						repayChooseTable = table.union(AndroidPayment.getInstance().thirdPartyPayment, {defaultSmsPayment})
						handlePayment(IngamePaymentDecisionType.kSmsWithOneYuanPay, defaultSmsPayment, dcAndroidStatus:getStatus(), thirdPartPaymentTable, repayChooseTable, typeDisplay) 
						self:cleanTypeDisplay()

						--防止qq钱包规则对其他逻辑的影响
						self.defaultThirdPartyPayment = 0
					end
				end, function ()
					--短代原价
					self:resetOneYuanCheckCondition()	--触发了一元特价但是断网 不算玩家真正触发 

					dcAndroidStatus:push(DecisionJudgeType.kNetEnable.NO)
					table.insert(repayChooseTable, defaultSmsPayment)
					handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
				end)
			else
				dcAndroidStatus:push(DecisionJudgeType.kOneYuanEnable.NO)
				if self:checkThirdPartPaymentEabled() then
					PaymentNetworkCheck.getInstance():check(function ()
						--短代原价 重买带三方
						local thirdPartPaymentTable = AndroidPayment.getInstance().thirdPartyPayment
						repayChooseTable = table.union(thirdPartPaymentTable, {defaultSmsPayment})
						handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
					end, function ()
						--短代原价 重买不带三方
						table.insert(repayChooseTable, defaultSmsPayment)
						handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
					end)
				else
					--短代原价 重买不带三方
					table.insert(repayChooseTable, defaultSmsPayment)
					handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
				end
			end 
		else
			if self:checkThirdPartPaymentEabled() then
				dcAndroidStatus:push(DecisionJudgeType.kThirdPayEnable.YES)

				local defaultThirdPartyPayment = nil
				local otherThirdPartPayment = nil

				if self:isEndGamePanelGoods(goodsId) then
					defaultThirdPartPayment = self:getDefaultThirdPartPayment()
					otherThirdPartPayment = self:getOtherThirdPartPayment()
				else
					defaultThirdPartyPayment = self:getDefaultThirdPartPayment(true)
					otherThirdPartPayment = self:getOtherThirdPartPayment(true)
					if #otherThirdPartPayment > 1 then
						for index = 2,#otherThirdPartPayment do
							table.remove(otherThirdPartPayment, index)
						end
					end
				end

				repayChooseTable = table.clone(AndroidPayment.getInstance().thirdPartyPayment)
				local typeDisplay = self:getTypeDisplay()
				if self:checkNeedOneYuanPay(goodsId) then 
					--全部三方 一元限购
					dcAndroidStatus:push(DecisionJudgeType.kOneYuanEnable.YES)
					handlePayment(IngamePaymentDecisionType.kThirdOneYuanPay, defaultThirdPartyPayment, dcAndroidStatus:getStatus(), otherThirdPartPayment, repayChooseTable, typeDisplay) 
				else
					--全部三方 原价或首次打折
					dcAndroidStatus:push(DecisionJudgeType.kOneYuanEnable.NO)
					handlePayment(IngamePaymentDecisionType.kThirdPayOnly, defaultThirdPartyPayment, dcAndroidStatus:getStatus(), otherThirdPartPayment, repayChooseTable, typeDisplay) 
				end
				self:cleanTypeDisplay()
				--防止qq钱包规则对其他逻辑的影响
				self.defaultThirdPartyPayment = 0
			else
				--支付失败 errortip
				dcAndroidStatus:push(DecisionJudgeType.kThirdPayEnable.NO)
				handlePayment(IngamePaymentDecisionType.kPayFailed, AndroidRmbPayResult.kNoPaymentAvailable, dcAndroidStatus:getStatus()) 
			end
		end
	else
		dcAndroidStatus:push(DecisionJudgeType.kDefaultPaymentType.NO)
		if self:checkThirdPartPaymentEabled() then 
			dcAndroidStatus:push(DecisionJudgeType.kThirdPayEnable.YES)
			local defaultSmsPayment = self:getDefaultSmsPayment()
			local thirdPartPaymentTable = AndroidPayment.getInstance().thirdPartyPayment
			local defaultThirdPartyPayment = self:getDefaultThirdPartPayment()
			if table.includes(ThirdPayWithoutNetCheck, defaultThirdPartyPayment) then 
				--这里的三方 不用联网检测 比如TELECOM3PAY
				dcAndroidStatus:push(DecisionJudgeType.kNetEnable.YES)
				--这里不判断短代是否可用了 不联网三方一般融合短代 不会用我们的短代
				repayChooseTable = table.clone(thirdPartPaymentTable)
				handlePayment(IngamePaymentDecisionType.kThirdPayOnly, defaultThirdPartyPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
			else
				PaymentNetworkCheck.getInstance():check(function ()
					--一种优先三方 若为支付宝引导快付
					dcAndroidStatus:push(DecisionJudgeType.kNetEnable.YES)
					
					local smsEnable, disableReason = self:checkSmsPayEnabled()
					if smsEnable then 
						repayChooseTable = table.union(thirdPartPaymentTable, {defaultSmsPayment})
					else
						repayChooseTable = table.clone(thirdPartPaymentTable)
					end
					handlePayment(IngamePaymentDecisionType.kThirdPayOnly, defaultThirdPartyPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
				end, function ()
					dcAndroidStatus:push(DecisionJudgeType.kNetEnable.NO)
					local smsEnable, disableReason = self:checkSmsPayEnabled()
					dcAndroidStatus:pushWithSmsEnableCheck(disableReason)
					if smsEnable then 
						--短代原价
						repayChooseTable = table.union({defaultSmsPayment}, thirdPartPaymentTable)
						handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
					else
						--去联网 errortip
						repayChooseTable = table.clone(thirdPartPaymentTable)
						handlePayment(IngamePaymentDecisionType.kPayFailed, AndroidRmbPayResult.kNoNet, dcAndroidStatus:getStatus(), nil, repayChooseTable) 
					end
				end)
			end
		else
			--支付失败 errortip
			dcAndroidStatus:push(DecisionJudgeType.kThirdPayEnable.NO)
			handlePayment(IngamePaymentDecisionType.kPayFailed, AndroidRmbPayResult.kNoPaymentAvailable, dcAndroidStatus:getStatus()) 
		end
	end
end

function PaymentManager:getSMSPaymentDecision()
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

function PaymentManager:getThirdPartPaymentDecision()
	local thirdPartPayment = AndroidPayment.getInstance():getThirdPartPayment()
	if not thirdPartPayment or thirdPartPayment == Payments.UNSUPPORT then
		return IngamePaymentDecisionType.kPayFailed
	else
		return IngamePaymentDecisionType.kPayWithType, thirdPartPayment
	end
end

function PaymentManager:setGoldOneYuanThirdPay(isOneYuan)
	self.goldOneYuanThirdPay = isOneYuan
end

function PaymentManager:getGoldOneYuanThirdPay()
	return self.goldOneYuanThirdPay
end

function PaymentManager:isThirdPartPaymentOnly(goodsId, goodsType)
	local thirdPayOnly = false
	if self.goodsType == 2 then 
		local goodsData = MetaManager:getInstance():getProductAndroidMeta(goodsId)
		if goodsData.rmb >= 3000 then 
			thirdPayOnly = true
		end
	end
	return thirdPayOnly
end

function PaymentManager:checkCanWindMillPay(goodsId)
	if not goodsId then return false end
	local user = UserManager:getInstance().user
	local meta = MetaManager:getInstance():getGoodMeta(goodsId)
	if user and meta then
		local finalCash = meta.qCash
		if meta.discountQCash and meta.discountQCash ~=0 then 
			finalCash = meta.discountQCash
		end
		if finalCash == 0 then
			return false
		elseif user:getCash() >= finalCash then
			return true
		end
	end
	return false
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end

function PaymentManager:checkNeedOneYuanPay(goodsId)
	if not goodsId then return end
	if self:getHasFirstThirdPay() then return end
	if not self:checkThirdPartPaymentEabled() then return end
	if not self:checkHasRealThirdPay() then return end

	if self.oneYuanGoodsId and self.oneYuanGoodsId ~= goodsId then
		return
	end

	local needShow = false
	for k,v in pairs(ThirdPayPromotionConfig) do
		if k == goodsId then 
			needShow = true
			break
		end
	end
	if not needShow then return end

	--检查是否在同一局关卡
	if not self.oneYuanShowTime or self.oneYuanShowTime == "" then  
		self.oneYuanShowTime = 0
	end
	local lastStartTime = math.floor(tonumber(self.oneYuanShowTime) / 3600 / 24)
	local nowStartTime = math.floor(now() / 3600 / 24)

	--关卡外
	local scene = Director.sharedDirector():getRunningScene()
	if scene and (not scene:is(GamePlaySceneUI)) then
		if goodsId == 18 then 	--这里 针对高级精力瓶要有特殊处理 同一个精力面板下 只要没买 可以一直触发一元特价
			if nowStartTime == lastStartTime and self.oneYuanEnergyPanel ~= self.currentEnergyPanel then
				return
			end
		else
			if nowStartTime == lastStartTime then
				return
			end
		end
	else
		local isSameLevel = self:checkSameLevel(nowStartTime)
		if nowStartTime == lastStartTime and isSameLevel == false then
			return
		end
	end
	
	self.oneYuanGoodsId = goodsId
	return true
end

function PaymentManager:resetOneYuanCheckCondition()
	self.oneYuanGoodsId = nil
	self.oneYuanShowTime = nil
end

--一些三网融合的SDK 我们放在三方的配置中 但该三方会调起对应的短代 这不算纯粹的三方支付 
function PaymentManager:checkHasRealThirdPay()
	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
    for k,payment in pairs(thirdPaymentConfig) do
        if payment ~= Payments.UNSUPPORT and payment ~= Payments.WO3PAY and payment ~= Payments.TELECOM3PAY then
            return true
        end
    end
    return false
end

function PaymentManager:checkIsNoThirdPayPromotion(paymentType)
	if paymentType == Payments.CHINA_MOBILE or paymentType == Payments.CHINA_MOBILE_GAME or paymentType == Payments.CHINA_UNICOM 
		or paymentType == Payments.CHINA_TELECOM  or paymentType == Payments.WO3PAY or paymentType == Payments.TELECOM3PAY then 
		return true
	end
	return false
end

function PaymentManager:setOneYuanEnergyPanel(oneYuanEnergyPanel)
	self.oneYuanEnergyPanel = oneYuanEnergyPanel
end

function PaymentManager:setCurrentEnergyPanel(currentEnergyPanel)
	self.currentEnergyPanel = currentEnergyPanel
end

function PaymentManager:getCurrentEnergyPanel()
	return self.currentEnergyPanel
end

function PaymentManager:checkSameLevel(nowDay)
	local scene = Director.sharedDirector():getRunningScene()

	if (not scene or scene:is(GamePlaySceneUI)) and self.oneYuanScene == nil then 
		if not self.isTodayFirstOneYuanLevel or self.isTodayFirstOneYuanLevel == 0 or self.isTodayFirstOneYuanLevel < nowDay then 
			self.isTodayFirstOneYuanLevel = nowDay
			self.userDefault:setIntegerForKey("one.yuan.today.level", nowDay)
			self.userDefault:flush()
			self.oneYuanScene = scene
			return true
		end
	end

	if scene == self.oneYuanScene then 
		return true
	else
		return false
	end
end

function PaymentManager:checkIsSpecialItem(goodsId)
	--购买时需要特殊处理的道具 18是高级精力瓶 目前只有它
	local specialGoodsTable = {18}
	if goodsId and table.includes(specialGoodsTable, goodsId) then
		return true 
	end
	return false	
end

function PaymentManager:refreshOneYuanShowTime()
	self.oneYuanShowTime = now()
	self.userDefault:setStringForKey("one.yuan.show.time", self.oneYuanShowTime)
	self.userDefault:flush()
end

function PaymentManager:getDefaultSmsPayment()
	if __ANDROID then
		self.defaultSmsPayment = AndroidPayment.getInstance():getDefaultSmsPayment()
	end
	return self.defaultSmsPayment
end

function PaymentManager:checkHaveAliAPP()
	if __ANDROID then
		local function checkAndroidApp( pkgName )
			local help = luajava.bindClass("com.happyelements.android.ApplicationHelper")
			return help:checkApkExist(pkgName)
		end
		
		if self.haveAliApp == true then return self.haveAliApp end

		local ok, haveAliApp = pcall(checkAndroidApp, "com.eg.android.AlipayGphone")

		if ok == true then
			self.haveAliApp = haveAliApp
			return haveAliApp
		else
			return false
		end
	end
end

local PaymentReorderType = {
	{Payments.WECHAT, Payments.ALIPAY}, 	--index = 1
	{Payments.WECHAT, Payments.QQ_WALLET}, 	--index = 2
	{Payments.ALIPAY, Payments.QQ_WALLET}, 	--index = 3
	{Payments.ALIPAY, Payments.WECHAT}, 	--index = 4
	{Payments.QQ_WALLET, Payments.WECHAT}, 	--index = 5
	{Payments.QQ_WALLET, Payments.ALIPAY}, 	--index = 6
}

function PaymentManager:isQQWalletNeedReorder()
	local hasWechat = false
	local hasAli = false
	local hasQQWallet = false

	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	for i,v in ipairs(thirdPaymentConfig) do
		if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
			hasWechat = true
		elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
			hasAli = true
		elseif v == PlatformPaymentThirdPartyEnum.kQQ_WALLET then
			hasQQWallet = true
		end 
	end

	local configValue = MaintenanceManager:getInstance():getValue("QqWalletShowUi") or 0

	self.paymentReorderTable = {}

	for index, v in ipairs(PaymentReorderType) do
		if bit.band(configValue, bit.lshift(1, index - 1)) ~= 0 then
			v[3] = index
			table.insert(self.paymentReorderTable, v)
		end
	end

	self.typeDisplay = nil

	local enable = MaintenanceManager:getInstance():isEnabled("QqWalletShowUi")

	local configEnbale = (#self.paymentReorderTable ~= 0) and enable
 
	return configEnbale and hasWechat and hasAli and hasQQWallet
end

function PaymentManager:assembleQQWalletOrder()
	local uid = tonumber(UserManager.getInstance().user.uid or "0") or 0
	local part = uid % 100
	local partOne = 100 / (#self.paymentReorderTable)

	local defaultThirdPartyPayment
	local otherFirstThirdPartyPayment

	for index,v in ipairs(self.paymentReorderTable) do
		if part < index * partOne then
			defaultThirdPartyPayment = v[1]
			otherFirstThirdPartyPayment = v[2]
			self.typeDisplay = v[3]
			break
		end
	end

	return defaultThirdPartyPayment, otherFirstThirdPartyPayment
end

function PaymentManager:getTypeDisplay()
	return self.typeDisplay
end

function PaymentManager:cleanTypeDisplay()
	self.typeDisplay = nil
end

function PaymentManager:getDefaultThirdPartPayment(needReorder)
	if not self.defaultThirdPartyPayment or self.defaultThirdPartyPayment == 0 or needReorder then
		local hasWechat = false
		local hasAli = false
		local hasOther = false
		local hasQQWallet = false
		local otherThirdPaymentType = nil
		self.defaultThirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		for i,v in ipairs(thirdPaymentConfig) do
			if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
				hasWechat = true
			elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
				hasAli = true
			elseif v == PlatformPaymentThirdPartyEnum.kQQ_WALLET then
				hasQQWallet = true
			elseif v ~= PlatformPaymentThirdPartyEnum.kUnsupport then 
				hasOther = true
				otherThirdPaymentType = v
			end 
		end

		if hasWechat == true then 
			self.defaultThirdPartyPayment = PlatformPaymentThirdPartyEnum.kWECHAT
		elseif hasAli == true then
			self.defaultThirdPartyPayment = PlatformPaymentThirdPartyEnum.kALIPAY
		elseif hasOther == true then 
			self.defaultThirdPartyPayment = otherThirdPaymentType
		end

		if self:isQQWalletNeedReorder() and needReorder then
			self.defaultThirdPartyPayment = self:assembleQQWalletOrder()
		end

		self.userDefault:setIntegerForKey("default.third.payment", self.defaultThirdPartyPayment)
		self.userDefault:flush()
	else
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		if thirdPaymentConfig then 
			if not table.includes(thirdPaymentConfig, self.defaultThirdPartyPayment) then 
				self.defaultThirdPartyPayment = 0
				return self:getDefaultThirdPartPayment()
			end
		else
			self.defaultThirdPartyPayment = 0
			return self:getDefaultThirdPartPayment()
		end
	end
	return self.defaultThirdPartyPayment
end

function PaymentManager:setDefaultThirdPartPayment(thirdPartPay)
	if thirdPartPay and type(thirdPartPay) == "number" then
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		for i,v in ipairs(thirdPaymentConfig) do
			if v == thirdPartPay then
				self.defaultThirdPartyPayment = thirdPartPay
				self.userDefault:setIntegerForKey("default.third.payment", thirdPartPay)
				self.userDefault:flush()
				return 
			end
		end
	end
end

--设置面板上需求的默认支付方式 
function PaymentManager:getDefaultPayment(isRefresh)
	if isRefresh == true then
		self.defaultPayment = 0
	end

	if not self.defaultPayment or self.defaultPayment == 0 then
		local tempDefaultPayment = nil
		local noThirdPay = false
		local noSmsPay = false
		if self:checkThirdPartPaymentEabled() then 
			if _G.kUserLogin and self:getHasFirstThirdPay() then
				tempDefaultPayment = self:getDefaultThirdPartPayment()
				if tempDefaultPayment == Payments.UNSUPPORT then 
					noThirdPay = true
				end
			else
				tempDefaultPayment = self:getDefaultSmsPayment()
				if not tempDefaultPayment or tempDefaultPayment == Payments.UNSUPPORT then 
					noSmsPay = true
				end
			end
		else
			tempDefaultPayment = self:getDefaultSmsPayment()
		end
		if noThirdPay then 
			tempDefaultPayment = self:getDefaultSmsPayment()
		elseif noSmsPay then 
			tempDefaultPayment = self:getDefaultThirdPartPayment()
		end
		if tempDefaultPayment == nil then 
			tempDefaultPayment = Payments.UNSUPPORT
		end
		PaymentDCUtil.getInstance():sendDefaultPaymentChange(nil, self.lastDefaultPayment, tempDefaultPayment, 3)
		self:setDefaultPayment(tempDefaultPayment)
	else
		local noDefaultPayment = false
		if self.defaultPayment == Payments.UNSUPPORT then 
			noDefaultPayment = true
		else
			local defaultIsNotSms = false
			if not self:checkPaymentIsInSmsConfig(self.defaultPayment) then 
				defaultIsNotSms = true
			end

			local defaultIsNotThirdPay = true
			if self.defaultPayment ~= self:getDefaultThirdPartPayment() then 
				local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
				if thirdPaymentConfig then  
					for i,v in ipairs(thirdPaymentConfig) do
						if self.defaultPayment == v then
							self.defaultThirdPartyPayment = v
							self.userDefault:setIntegerForKey("default.third.payment", thirdPartPay)
							self.userDefault:flush()
							defaultIsNotThirdPay = false
							break
						end
					end
				end
			else
				defaultIsNotThirdPay = false
			end

			if defaultIsNotSms and defaultIsNotThirdPay then 
				noDefaultPayment = true
			end
		end 
		if noDefaultPayment then 
			self.defaultPayment = 0
			return self:getDefaultPayment()
		end
	end
	return self.defaultPayment
end

function PaymentManager:setDefaultPayment(paymentType)
	if paymentType and type(paymentType) == "number" then
		if paymentType == self.defaultPayment then return end
		self.lastDefaultPayment = paymentType
		self.defaultPayment = paymentType
		self.userDefault:setIntegerForKey("default.setting.payment", paymentType)
		self.userDefault:flush()

		--向后端同步当前默认支付方式
		local curSettingFlag = self:getSettingFlag(paymentType)
		local http = SettingHttp.new()
		http:load(curSettingFlag)

		self:setDefaultThirdPartPayment(paymentType)
	end
end

function PaymentManager:getSettingFlag(paymentType)
	local curSettingFlag = UserManager.getInstance().setting or 0
	local bit = require("bit")
	--低位24位都是用来存储支付类型的 先清空
	local tempFlag = bit.rshift(curSettingFlag, 24)
	tempFlag = bit.lshift(tempFlag, 24) 
	if paymentType > 0 then 
		local paymentFlag = bit.lshift(1, paymentType-1) 
		tempFlag = tempFlag + paymentFlag
	end
	return tempFlag
end

function PaymentManager:getServerDefaultPaymentType()
	local curSettingFlag = UserManager.getInstance().setting or 0
	local serverPaymentType = 0
	for i=0,23 do
		if 1 == bit.band(bit.rshift(curSettingFlag, i), 0x01) then 
			serverPaymentType = i + 1
			break 
		end
	end
	return serverPaymentType
end

-- 默认支付方式是否是短代
function PaymentManager:checkDefaultPaymentIsSmsPay()
	return self:checkPaymentIsInSmsConfig(self.defaultPayment)
end

function PaymentManager:getOtherThirdPartPayment(needReorder)
	local otherThirdPayTable = {}
	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	for i,v in ipairs(thirdPaymentConfig) do
		if v ~= self.defaultThirdPartyPayment and v ~= PlatformPaymentThirdPartyEnum.kUnsupport then 
			table.insert(otherThirdPayTable, v)
		end
	end

	if self:isQQWalletNeedReorder() and needReorder then
		local _, otherFirstThirdPartyPayment = self:assembleQQWalletOrder()
		local index = table.indexOf(otherThirdPayTable, otherFirstThirdPartyPayment)

		if index ~= 1 then
			local oldFirst = otherThirdPayTable[1]
			otherThirdPayTable[1] = otherFirstThirdPartyPayment
			otherThirdPayTable[index] = oldFirst
		end
	end

	return otherThirdPayTable
end

function PaymentManager:setHasFirstThirdPay(firstThirdPay)
	self.hasFirstThirdPay = firstThirdPay
end

function PaymentManager:getHasFirstThirdPay()
	if self.hasFirstThirdPay then 
		return self.hasFirstThirdPay
	else
		return UserManager:getInstance().userExtend:hasFirstThirdPay()
	end
end

--每次支付成功了检测下 
function PaymentManager:checkPaymentLimit(paymentType)
	if not paymentType then return end
	--这个会在user里面由服务端返回 暂时不用
	local serverLimit = false
	if serverLimit then
		self.smspayPassLimit = serverLimit
	else
		if PaymentLimitLogic:isNeedLimit(paymentType) then 
			if PaymentLimitLogic:isExceedMonthlyLimit(paymentType) then
				self.smspayPassLimit = true
				self.smspayLimitType = SmsLimitType.kMonthlyLimit
			elseif PaymentLimitLogic:isExceedDailyLimit(paymentType) then 
				self.smspayPassLimit = true
				self.smspayLimitType = SmsLimitType.kDailyLimit
			end
		end
	end
end

function PaymentManager:getIsSmsPaymentLimit()
	return self.smspayPassLimit
end

function PaymentManager:getSmsPaymentLimitType()
	return self.smspayLimitType
end

function PaymentManager:getPriceByPaymentType(goodsId, goodsType, paymentType)
	if goodsType == 2 then 
		local goodsData = MetaManager:getInstance():getProductAndroidMeta(goodsId)
		return goodsData.rmb / 100
	else
		local goodsData = MetaManager:getInstance():getGoodMeta(goodsId)
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		for i,v in ipairs(thirdPaymentConfig) do
			if v == paymentType then 
				if v == Payments.QIHOO then 
					return math.floor(goodsData.thirdRmb / 100)
				else
					return goodsData.thirdRmb / 100
				end
			end
		end
		if goodsData.discountRmb ~= 0 and goodsData.discountRmb ~= "0" then
			return goodsData.discountRmb / 100
		else
			return goodsData.rmb / 100
		end
	end
end

function PaymentManager:getSignForThirdPay(goodsIdInfo)
	local goodsId = goodsIdInfo:getGoodsId()
	local goodsType = goodsIdInfo:getGoodsType()

	local signForThirdPay = nil
	if goodsType ~= 2 then 
		local goodsData = MetaManager:getInstance():getGoodMeta(goodsId)
		if goodsData then 
			signForThirdPay = goodsData.sign
		end
	end
	return signForThirdPay
end

function PaymentManager:setIsCheckingPayResult(isChecking)
	self.isCheckingPayResult = isChecking
end

function PaymentManager:getIsCheckingPayResult()
	return self.isCheckingPayResult
end

function PaymentManager:getAliQuickPayLimit()
	return self.aliQuickPayLimit 	
end

function PaymentManager:getWechatQuickPayLimit()
	return self.wechatQuickPayLimit
end

--是否是支付宝免密支付大限度的平台 目前he和tf 支持上限开到60块 其它小于60块
function PaymentManager:isHighLimitPlatform()
	local limitPlatformTable = {
	    PlatformNameEnum.kTF,
	    PlatformNameEnum.kHE,
	}
	local plarformName = StartupConfig:getInstance():getPlatformName()
	if plarformName and table.includes(limitPlatformTable, plarformName) then 
		return true
	end
	return false 
end

function PaymentManager:checkCanAliQuickPay(payPrice)
	if not payPrice then return false end

	local quickPayLimit = self:getAliQuickPayLimit()
	local isHighLimitPF = self:isHighLimitPlatform()
	if payPrice < quickPayLimit or (isHighLimitPF and payPrice <= quickPayLimit) then
		return true
	end
	return false
end

function PaymentManager:checkCanWechatQuickPay(payPrice)
	if not _G.wxmmGlobalEnabled or not WechatQuickPayLogic:getInstance():isMaintenanceEnabled() then return false end -- 未开开关，全都不可免密支付

	if not payPrice then return false end

	local quickPayLimit = self:getWechatQuickPayLimit()
	local isHighLimitPF = self:isHighLimitPlatform()
	if payPrice < quickPayLimit or (isHighLimitPF and payPrice <= quickPayLimit) then
		return true
	end
	return false
end

function PaymentManager:checkUseNewWechatPay(pf)
	if not pf then return false end
	local useNewWechatTable = {
		PlatformNameEnum.kAnZhi,
		PlatformNameEnum.kZTEMINIPre,
		PlatformNameEnum.kAsusPre,
		PlatformNameEnum.kMI,
	}
	if table.includes(useNewWechatTable, pf) then 
		return true
	end
	return false
end

function PaymentManager:checkPaymentTypeIsSms(paymentType)
	if paymentType and paymentType == Payments.CHINA_MOBILE or 
		paymentType == Payments.CHINA_UNICOM or 
		paymentType == Payments.CHINA_TELECOM or
		paymentType == Payments.CHINA_MOBILE_GAME then 
		return true
	end
	return false
end

function PaymentManager:setContinueSmsPayCount(count)
	if not count then count = 0 end
	self.continueSmsPayCount = count
	self.userDefault:setIntegerForKey("continue.smspay.count", count)
	self.userDefault:flush()
end

function PaymentManager:tryChangeDefaultPaymentType(paymentType)
	local oriPaymentType = self.defaultPayment
	local isSmsPay = self:checkPaymentTypeIsSms(paymentType)
	if isSmsPay then 
		if paymentType == self.defaultPayment then 
			return
		elseif self:checkPaymentIsInSmsConfig(self.defaultPayment) then 
			--走到这里证明玩家可用的短代和当前记录的默认支付方式（必为短代）不符 这里自动改掉
			--这样的特殊处理是基于产品需求 导致我们获取的默认支付方式不是玩家可用的支付方式 具体参考本次修改记录中的其它代码
			self:setDefaultPayment(paymentType)
			return
		else
			local continueSmsPayCount = self.continueSmsPayCount
			if continueSmsPayCount < 2 then 
				self:setContinueSmsPayCount(continueSmsPayCount + 1)
			else
				PaymentDCUtil.getInstance():sendDefaultPaymentChange(nil, self.defaultPayment, paymentType, 2)
				self:setDefaultPayment(paymentType)
				self:setContinueSmsPayCount(0)
				if not self.paymentAutoChangeFlag then
					self.paymentAutoChangeFlag = true 
					self.paymentBeforeAutoChange = oriPaymentType
					GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kDefaultPaymentTypeAutoChange))
				end
			end
		end
	else
		if self.continueSmsPayCount and self.continueSmsPayCount ~= 0 then 
			self:setContinueSmsPayCount(0)
		end
		self:setHasFirstThirdPay(true)
		if paymentType ~= self.defaultPayment then 
			PaymentDCUtil.getInstance():sendDefaultPaymentChange(nil, self.defaultPayment, paymentType, 1)
			self:setDefaultPayment(paymentType)
			if not self.paymentAutoChangeFlag then
				self.paymentAutoChangeFlag = true 
				self.paymentBeforeAutoChange = oriPaymentType
				GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kDefaultPaymentTypeAutoChange))
			end
		end
	end
end

function PaymentManager:setPaymentAutoChangeFlag(paymentAutoChange)
	self.paymentAutoChangeFlag = paymentAutoChange
	
end

function PaymentManager:setPaymentBeforeAutoChange(paymentBeforeAutoChange)
	self.paymentBeforeAutoChange = paymentBeforeAutoChange
end

function PaymentManager:getPaymentBeforeAutoChange()
	return self.paymentBeforeAutoChange
end

function PaymentManager:isEndGamePanelGoods(oriGoodsId)
	if oriGoodsId == 24 or oriGoodsId == 46 or oriGoodsId == 155 then 
		return true
	end
	return false
end

function PaymentManager:isNeedThirdPayGuide(paymentType)
	if paymentType and paymentType == Payments.WECHAT or paymentType == Payments.ALIPAY or paymentType == Payments.QQ then 
		return true
	end
	return false
end

function PaymentManager:checkPaymentIsInSmsConfig(paymentType)
	local paymentConfig = PlatformConfig.paymentConfig
	local allSmsTable = {}
	for i,v in ipairs(paymentConfig.chinaMobilePayment) do
		if v ~= Payments.UNSUPPORT then 
			table.insert(allSmsTable, v)
		end
	end
	if paymentConfig.chinaUnicomPayment ~= Payments.UNSUPPORT then 
		table.insert(allSmsTable, paymentConfig.chinaUnicomPayment)
	end
	if paymentConfig.chinaTelecomPayment ~= Payments.UNSUPPORT then 
		table.insert(allSmsTable, paymentConfig.chinaTelecomPayment)
	end
	if table.includes(allSmsTable, paymentType) then 
		return true
	end
	return false
end