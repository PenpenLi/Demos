require "zoo.payment.NetConnectPanel"
require "zoo.payment.WMBBuyItemLogic"
require "zoo.payment.PaymentNetworkCheck"


IngamePaymentDecisionType = table.const {
	kPayWithType = 1,
	kChoosePayment = 2,
	kPayFailed = 3,
	kSmsPayOnly = 4,
	kThirdPayOnly = 5,
	kThirdPayWithSms = 6,
	kSmsWithThirdPay = 7,
	kPayWithWindMill = 8,
	kNoNetWithSmsPay = 9,
	kSmsWithOneYuanPay = 10,
	kHandleWithNetwork = 99,
}

ThirdPayPromotionConfig = table.const {
    [18]    = {itemId = 10014, discount = 1}, -- 高级精力瓶
    -- [17]    = {itemId = 10013, discount = 3}, -- 中级精力瓶 -- 暂时缺短代支付点
    [147]   = {itemId = 10052, discount = 1}, -- 章鱼冰
    [5]     = {itemId = 10005, discount = 1}, -- 条纹刷子
    [3]     = {itemId = 10003, discount = 1}, -- 强制交换
    [4]     = {itemId = 10004, discount = 2}, -- +5道具栏
    [24]    = {itemId = 10004, discount = 2}, -- +5 最终
    [46]    = {itemId = 10040, discount = 2}, -- 兔兔导弹 飞碟关复活
    [150]   = {itemId = 10054, discount = 2}, -- 萌兔周赛次数
    [7]     = {itemId = 10010, discount = 3}, -- 小木槌
    [1]     = {itemId = 10001, discount = 3}, -- 刷新
    [151]   = {itemId = 10055, discount = 3}, -- 随机魔力鸟
    [155]   = {itemId = 16,    discount = 3}, -- +15秒
    [153]   = {itemId = 10056, discount = 3}, -- 消2行
    [2]     = {itemId = 10002, discount = 5}, -- 后退
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
	self:checkPaymentLimit(self:getDefaultSmsPayment())

	self.defaultSmsPayment = nil
	--本地记录的默认三方支付类型
	self.defaultThirdPartyPayment = self.userDefault:getIntegerForKey("default.third.payment")
	--初始化默认支付（可能是三方或者短代）
	self.defaultPayment = self:getServerDefaultPaymentType()
	if self.defaultPayment == 0 then 
		self.defaultPayment = self.userDefault:getIntegerForKey("default.setting.payment")
	end
	self.defaultPayment = self:getDefaultPayment()
	--一元特价每日首次提示时间
	self.oneYuanShowTime = self.userDefault:getStringForKey("one.yuan.show.time")
end

function PaymentManager:checkSmsPayEnabled()
	local smsPayEnabled = true
	local operator = AndroidPayment.getInstance():getOperator()
	
	--是否超限额 
	if self:getPaymentLimit() then 
		smsPayEnabled = false
	else
		--是否关停
		if operator == TelecomOperators.CHINA_MOBILE then
	        if AndroidPayment.getInstance():filterCMPayment() == PlatformPaymentChinaMobileEnum.kUnsupport then 
	            smsPayEnabled = false
	        end
	    elseif operator == TelecomOperators.CHINA_UNICOM then
	        if AndroidPayment.getInstance():filterCUPayment() == PlatformPaymentChinaUnicomEnum.kUnsupport then 
	            smsPayEnabled = false
	        end
	    elseif operator == TelecomOperators.CHINA_TELECOM then
	        if AndroidPayment.getInstance():filterCTPayment() == PlatformPaymentChinaTelecomEnum.kUnsupport then 
	            smsPayEnabled = false
	        end
	    else
	    	--没卡 或者卡有问题等情况
	    	smsPayEnabled = false
	    end
	end
	return smsPayEnabled
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
				else
					--大额支付也在normal那一栏里 所以这里要判断下
					if v == PlatformPaymentThirdPartyEnum.kQQ or 
					  v == PlatformPaymentThirdPartyEnum.kMI then 
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

	return tab_normal, tab_wechat, tab_ali, tab_qihoo, tab_wandoujia
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
		if user:getCash() >= finalCash then
			return true
		end
	end
	return false
end

function PaymentManager:getBuyItemDecision(handlePayment, goodsId)
	if self:checkCanWindMillPay(goodsId) then 
		if handlePayment then 
			handlePayment(IngamePaymentDecisionType.kPayWithWindMill)
		end
	else
		self:getRMBBuyItemDecision(handlePayment, goodsId)
	end
end

function PaymentManager:getRMBBuyItemDecision(handlePayment, goodsId)
	assert(handlePayment)
	if not handlePayment then return end
	if self:checkSmsPayEnabled() then 
		if self:checkThirdPartPaymentEabled() then 
			if not self:checkDefaultPaymentIsSmsPay() then 
				PaymentNetworkCheck.getInstance():check(function ()
					--仅三方支付
					local defaultThirdPartPayment = self:getDefaultThirdPartPayment()
					handlePayment(IngamePaymentDecisionType.kThirdPayOnly, defaultThirdPartPayment) 
				end, function ()
					--提示联网 可选短代
					local defaultSmsPayment = self:getDefaultSmsPayment()
					handlePayment(IngamePaymentDecisionType.kNoNetWithSmsPay, defaultSmsPayment) 
				end)
			else
				if self:checkNeedOneYuanPay(goodsId) then 
					--短代带一元支付三方
					local defaultSmsPayment = self:getDefaultSmsPayment()
					local thirdPartPaymentTable = AndroidPayment.getInstance().thirdPartyPayment
					-- local finalChooseTable = self:getPaymentTableForChoose(defaultSmsPayment, thirdPartPaymentTable)
					handlePayment(IngamePaymentDecisionType.kSmsWithOneYuanPay, defaultSmsPayment, thirdPartPaymentTable) 
				else
					--仅短代支付
					local defaultSmsPayment = self:getDefaultSmsPayment()
					handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment) 
				end
			end
		else
			--仅短代支付
			local defaultSmsPayment = self:getDefaultSmsPayment()
			handlePayment(IngamePaymentDecisionType.kSmsPayOnly, defaultSmsPayment) 
		end
	else
		if self:checkThirdPartPaymentEabled() then 
			--仅三方支付
			local defaultThirdPartPayment = self:getDefaultThirdPartPayment()
			handlePayment(IngamePaymentDecisionType.kThirdPayOnly, defaultThirdPartPayment) 
		else
			--无法支付 
			handlePayment(IngamePaymentDecisionType.kPayFailed, Payments.UNSUPPORT) 
		end
	end
end

local function now()
	return os.time() + (__g_utcDiffSeconds or 0)
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function PaymentManager:checkNeedOneYuanPay(goodsId)
	if not goodsId then return end
	if self:getHasFirstThirdPay() then return end
	if self.defaultPayment ~= self:getDefaultSmsPayment() then return end
	if not self:checkThirdPartPaymentEabled() then return end
	local needShow = false
	for k,v in pairs(ThirdPayPromotionConfig) do
		if k == goodsId then 
			needShow = true
			break
		end
	end
	if not needShow then return end
	local showToday = true
	if not self.oneYuanShowTime or self.oneYuanShowTime == "" then  
		self.oneYuanShowTime = 0
	end
	local lastStartTime = getDayStartTimeByTS(tonumber(self.oneYuanShowTime))
	local nowStartTime = getDayStartTimeByTS(now())
	if nowStartTime > lastStartTime then 
		showToday = false
	end

	if not showToday then 
		return true
	end 
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

function PaymentManager:getDefaultThirdPartPayment()
	if not self.defaultThirdPartyPayment or self.defaultThirdPartyPayment == 0 then
		local hasWechat = false
		local hasAli = false
		local hasOther = false
		local otherThirdPaymentType = nil
		self.defaultThirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		for i,v in ipairs(thirdPaymentConfig) do
			if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
				hasWechat = true
			elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
				hasAli = true
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
function PaymentManager:getDefaultPayment()
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
		self:setDefaultPayment(tempDefaultPayment)
	else
		local noDefaultPayment = false
		if self.defaultPayment == Payments.UNSUPPORT then 
			noDefaultPayment = true
		else
			local defaultIsNotSms = false
			if self.defaultPayment ~= self:getDefaultSmsPayment() then 
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
	local curSettingFlag = UserManager.getInstance().setting
	local bit = require("bit")
	--低位15位都是用来存储支付类型的 先清空
	local tempFlag = bit.rshift(curSettingFlag, 15)
	tempFlag = bit.lshift(tempFlag, 15) 
	if paymentType > 0 then 
		local paymentFlag = bit.lshift(1, paymentType-1) 
		tempFlag = tempFlag + paymentFlag
	end
	return tempFlag
end

function PaymentManager:getServerDefaultPaymentType()
	local curSettingFlag = UserManager.getInstance().setting
	local serverPaymentType = 0
	for i=0,14 do
		if 1 == bit.band(bit.rshift(curSettingFlag, i), 0x01) then 
			serverPaymentType = i + 1
			break 
		end
	end
	return serverPaymentType
end

-- --默认支付方式是否是三方
-- function PaymentManager:checkDefaultPaymentIsThirdPay()
-- 	if self.defaultPayment == self:getDefaultThirdPartPayment() then 
-- 		return true
-- 	end
-- 	return false
-- end

-- 默认支付方式是否是短代
function PaymentManager:checkDefaultPaymentIsSmsPay()
	if self.defaultPayment == self:getDefaultSmsPayment() then 
		return true
	end
	return false
end

--当其它可选的支付方式大于等于两个时 要弹出支付选择面板 其中要包含默认的支付方式
function PaymentManager:getPaymentTableForChoose(defaultPayment, otherTable)
	if #otherTable > 1 then 
		local paymentForChoose = {}
		table.insert(paymentForChoose, defaultPayment) 
		local finalTable = table.union(paymentForChoose, otherTable)
		return finalTable
	else
		return otherTable
	end
end

function PaymentManager:getOtherThirdPartPayment()
	local otherThirdPayTable = {}
	local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
	for i,v in ipairs(thirdPaymentConfig) do
		if v ~= self.defaultThirdPartyPayment and v ~= PlatformPaymentThirdPartyEnum.kUnsupport then 
			table.insert(otherThirdPayTable, v)
		end
	end
	return otherThirdPayTable
end

--准备弃用
function PaymentManager:getNotDefaultThirdPayOpen()
	-- return self.notDefaultThirdPayOpen
end

--准备弃用
function PaymentManager:setNotDefaultThirdPayOpen(isOpen)
	-- if not isOpen then isOpen = false end
	-- self.notDefaultThirdPayOpen = isOpen
	-- self.userDefault:setBoolForKey("not.default.third.open", isOpen)
	-- self.userDefault:flush()
end

function PaymentManager:setHasFirstThirdPay(firstThirdPay, paymentType)
	self.hasFirstThirdPay = firstThirdPay
	--记录玩家首次支付的三方支付方式
	if PaymentManager.getInstance():shouldShowDefaultPaymentPanel() then 
		local thirdPaymentConfig = AndroidPayment.getInstance().thirdPartyPayment
		for i,v in ipairs(thirdPaymentConfig) do
			if v == paymentType then
				PaymentManager.getInstance():setDefaultPayment(paymentType)
				break 
			end
		end
	end
	GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kThirdPaySuccess))
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
			elseif PaymentLimitLogic:isExceedDailyLimit(paymentType) then 
				self.smspayPassLimit = true
			end
		end
	end
end

function PaymentManager:getPaymentLimit()
	return self.smspayPassLimit
end

function PaymentManager:getPriceByPaymentType(goodsId , goodsType, paymentType)
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

function PaymentManager:getSignForThirdPay(goodsId, goodsType)
	local signForThirdPay = nil
	if goodsType ~= 2 then 
		local goodsData = MetaManager:getInstance():getGoodMeta(goodsId)
		if goodsData then 
			signForThirdPay = goodsData.sign
		end
	end
	return signForThirdPay
end

function PaymentManager:supportThirdPayPromotion()
	local thirdPaymentConfig = PlatformConfig.paymentConfig.thirdPartyPayment
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiPad) then
		return false
	end
	if type(thirdPaymentConfig) ~= 'table' then
		return thirdPaymentConfig ~= PlatformPaymentThirdPartyEnum.kUnsupport
	else
		return thirdPaymentConfig[1] ~= PlatformPaymentThirdPartyEnum.kUnsupport
	end
end


function PaymentManager:shouldShowDefaultPaymentPanel()
	if not self.userDefault:getBoolForKey('third.payment.has.shown.default', false)
	and self.hasFirstThirdPay then
		return true
	else
		return false
	end
end

function PaymentManager:onDefaultPaymentPanelPopped()
	self.userDefault:setBoolForKey('third.payment.has.shown.default', true)
end
