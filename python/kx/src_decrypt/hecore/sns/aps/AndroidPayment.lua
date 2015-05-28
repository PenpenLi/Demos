AndroidPayment = class()

local decisionStoragePath = "/smspaydecision.ds"
local defaultSMSPaymentDecision = [[
	local androidPlatformName = StartupConfig:getInstance():getPlatformName() 
	local province = Cookie.getInstance():read(CookieKey.kLocationProvince)
	if (province == "宁夏" or province == "福建" or province == "天津" or province == "山西" or province == "甘肃" or province == "新疆" or province == "内蒙古" or province == "河南" or province == "陕西" or province == "山东") then
		return {  Payments.CHINA_MOBILE_GAME,Payments.CHINA_UNICOM,Payments.CHINA_TELECOM }
	end
	if province == "江西" then
		local udid = MetaInfo:getInstance():getUdid()
		if udid then
			local subStr = string.sub(udid, -5)
			if subStr then
				local numUid = tonumber(subStr, 36)
				if numUid and numUid % 5 == 0 then
					return {Payments.CHINA_MOBILE_GAME,Payments.CHINA_MOBILE,Payments.CHINA_UNICOM,Payments.CHINA_TELECOM }
				end
			end
		end
	end
	if androidPlatformName == "he" then
		local udid = MetaInfo:getInstance():getUdid()
		if udid then
			local subStr = string.sub(udid, -5)
			if subStr then
				local numUid = tonumber(subStr, 36)
				if numUid and numUid % 2 == 0 then
					return {Payments.CHINA_MOBILE_GAME,Payments.CHINA_MOBILE,Payments.CHINA_UNICOM,Payments.CHINA_TELECOM }
				end
			end
		end
	end
	return {Payments.CHINA_MOBILE,Payments.CHINA_MOBILE_GAME,Payments.CHINA_UNICOM,Payments.CHINA_TELECOM }
]]
local instance
function AndroidPayment.getInstance()
	if not instance then
		instance = AndroidPayment.new()
		instance:init()
	end
	return instance
end

function AndroidPayment:init()
end

function AndroidPayment:getAPSMgr()
	return luajava.bindClass("com.happyelements.hellolua.aps.APSManager")
end

-- 当前设备的电信运营商
function AndroidPayment:getOperator() 
	local metaInfo = luajava.bindClass("com.happyelements.android.MetaInfo")
	if metaInfo then
		return metaInfo:getNetOperatorType():getValue()
	else
		return 0 -- present unknown
	end
end

-- 支付初始化
function AndroidPayment:initPaymentConfig(paymentCfg)
	if not paymentCfg or type(paymentCfg) ~= "table" then 
		return 
	end

	self.thirdPartyPayment = paymentCfg.thirdPartyPayment or {}
	for i,v in ipairs(self.thirdPartyPayment) do
		if v ~= Payments.UNSUPPORT then
			self:registerPayment(v)
		end
	end

	local operator = self:getOperator()
	local extraData = self:getSmsPaymentsExtraData()

	self.chinaMobilePayment = paymentCfg.chinaMobilePayment or Payments.UNSUPPORT
	local v = self:filterCMPayment()
	if v ~= Payments.UNSUPPORT and operator == TelecomOperators.CHINA_MOBILE then
		if v == Payments.CHINA_MOBILE and extraData.mmAppidRule then -- CMMM
			AndroidPayment:setMMAppidRule(extraData.mmAppidRule)
		end
		self:registerPayment(v)
	end

	self.chinaUnicomPayment = paymentCfg.chinaUnicomPayment or Payments.UNSUPPORT
	if self.chinaUnicomPayment ~= Payments.UNSUPPORT and operator == TelecomOperators.CHINA_UNICOM then
		self:registerPayment(self.chinaUnicomPayment)
	end

	self.chinaTelecomPayment = paymentCfg.chinaTelecomPayment or Payments.UNSUPPORT
	if self.chinaTelecomPayment ~= Payments.UNSUPPORT and operator == TelecomOperators.CHINA_TELECOM then
		self:registerPayment(self.chinaTelecomPayment)
	end

end

function AndroidPayment:getNormalThirdPartPayment()
	for i,v in ipairs(self.thirdPartyPayment) do
		if v ~= PlatformPaymentThirdPartyEnum.kWECHAT and v ~= PlatformPaymentThirdPartyEnum.kALIPAY then 
			return v 
		end
	end
	return PlatformPaymentThirdPartyEnum.kUnsupport
end

function AndroidPayment:getThirdPartPayment()
	local currentPayType = PlatformConfig:getCurrentPayType()
	local thirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport
	if currentPayType == PlatformPayType.kNormal then
		for i,v in ipairs(self.thirdPartyPayment) do
			if v ~= PlatformPaymentThirdPartyEnum.kWECHAT and v ~= PlatformPaymentThirdPartyEnum.kALIPAY then 
				thirdPartyPayment = v 
				break
			end 
		end
	elseif currentPayType == PlatformPayType.kWechat then 
		if table.includes(self.thirdPartyPayment, PlatformPaymentThirdPartyEnum.kWECHAT) then
			thirdPartyPayment = PlatformPaymentThirdPartyEnum.kWECHAT
		end
	elseif currentPayType == PlatformPayType.kAlipay then 
		if table.includes(self.thirdPartyPayment, PlatformPaymentThirdPartyEnum.kALIPAY) then
			thirdPartyPayment = PlatformPaymentThirdPartyEnum.kALIPAY
		end
	end
	return thirdPartyPayment
end

function AndroidPayment:getSmsPaymentsExtraData()
	local func = loadstring(self.smsPayDecisionScript)
    local status, _, result = pcall(func)
	print(status)
	print(table.tostring(result))
	if not status or type(result) ~= "table" then
		result = {}
	end
	return result
end

function AndroidPayment:getSmsPayments()
	local func = loadstring(self.smsPayDecisionScript)
    local status, result = pcall(func)
	print(status)
	print(table.tostring(result))
	if not status or not result or type(result) ~= "table" then
		local func = loadstring(defaultSMSPaymentDecision)
	    local status, result = pcall(func)
		if not status or not result or type(result) ~= "table" then
			result = { Payments.CHINA_MOBILE, Payments.CHINA_MOBILE_GAME, Payments.CHINA_UNICOM, Payments.CHINA_TELECOM }
	    end
	end
	-- local function checkArtInUse()
	-- 	return AndroidPayment:getAPSMgr():isArtInUse()
	-- end

	-- local success, ret = pcall(checkArtInUse)
	-- if success and ret then
	-- 	print("isArtInUse")
		-- table.removeValue(result, Payments.CHINA_MOBILE_GAME)
		-- table.removeValue(result, Payments.CHINA_UNICOM)
	-- end
	return result
end

function AndroidPayment:filterCMPayment()
	local cmPayments = self.chinaMobilePayment
    print("filterCMPayment")
	if type(cmPayments) == "table" then
		if PlatformConfig:isCMPaymentSwitchable() then
			if _G.kDefaultCmPayment then
				print("kDefaultCmPayment cmcc")
				return _G.kDefaultCmPayment
			end
		end
		
		print(table.tostring(cmPayments))
		local result = self:getSmsPayments()
		for i, v in ipairs(result) do
			if table.includes(cmPayments, v) then
				print("filter " .. v)
				return v
			end
		end
	    print("default ")
	end
	return PlatformPaymentChinaMobileEnum.kUnsupport
end

function AndroidPayment:filterCUPayment()
	local cuPayment = self.chinaUnicomPayment
	local result = self:getSmsPayments()
	if table.includes(result, cuPayment) then
		return cuPayment
	end
	return PlatformPaymentChinaUnicomEnum.kUnsupport
end

function AndroidPayment:filterCTPayment()
	local ctPayment = self.chinaTelecomPayment
	local result = self:getSmsPayments()
	if table.includes(result, ctPayment) then
		return ctPayment
	end
	return PlatformPaymentChinaUnicomEnum.kUnsupport
end

function AndroidPayment:getDefaultSmsPayment()
	local operator = self:getOperator()
	print("getOperator:", operator)
	if operator == TelecomOperators.CHINA_MOBILE then
		return self:filterCMPayment()
	elseif operator == TelecomOperators.CHINA_UNICOM then
		return self:filterCUPayment()
	elseif operator == TelecomOperators.CHINA_TELECOM then
		return self:filterCTPayment()
	else
		return nil
	end
end

function AndroidPayment:getDefaultPayment(goodsType, price)
	print("AndroidPayment:getDefaultPayment:", goodsType, ",", price)
	if goodsType == 2 and tonumber(price) >= 10 then
		return self:getThirdPartPayment()
	else
		return self:getDefaultSmsPayment()
	end
end

function AndroidPayment:registerPayment(paymentType)
	print("AndroidPayment:registerPayment:", paymentType)
	if not paymentType or type(paymentType) ~= "number" then return end

	if paymentType ~= Payments.UNSUPPORT then
		local success = AndroidPayment:getAPSMgr():getInstance():registerPayment(paymentType)
		if not success then
			he_log_error("registerPayment failed.paymentType="..tostring(paymentType)..",platform="..PlatformConfig.name)
		end
	end
end

function AndroidPayment:getChinaMobileChannelId()
	return AndroidPayment:getAPSMgr():getInstance():getChinaMobileChannelId()
end

function AndroidPayment:getPaymentDelegate(paymentType)
	if not paymentType or type(paymentType) ~= "number" then return nil end
	return AndroidPayment:getAPSMgr():getInstance():getPaymentDelegate(paymentType)
end

function AndroidPayment:isNeedPreOrder(paymentType)
	if not paymentType then return false end
	return table.includes(PaymentsNeedPreOrder, paymentType)
end

function AndroidPayment:isPaymentTypeSupported(paymentType)
	local isCMSupported = false
	if type(self.chinaMobilePayment) == "table" then
		isCMSupported = table.includes(self.chinaMobilePayment, paymentType)
	else
		isCMSupported = self.chinaMobilePayment == paymentType
	end
	local isCUSupported = self.chinaUnicomPayment == paymentType
	local isCTSupported = self.chinaTelecomPayment == paymentType
	local isThirdPartySupported = self:getNormalThirdPartPayment() == paymentType

	return paymentType and (isCMSupported or isCUSupported or isCTSupported or isThirdPartySupported)
end

function AndroidPayment:getPaymentsChoosement()
	local result = {}
	local ctPaymentChoosement = self:filterCTPayment()
	if ctPaymentChoosement and ctPaymentChoosement ~= Payments.UNSUPPORT then result[ctPaymentChoosement] = true end
	local cuPaymentChoosement = self:filterCUPayment()
	if cuPaymentChoosement and cuPaymentChoosement ~= Payments.UNSUPPORT then result[cuPaymentChoosement] = true end
	local cmPaymentChoosement = self:filterCMPayment()
	if cmPaymentChoosement and cmPaymentChoosement ~= Payments.UNSUPPORT then result[cmPaymentChoosement] = true end

	for i, v in ipairs(self.thirdPartyPayment) do
		if v == PlatformPaymentThirdPartyEnum.kWECHAT then 
			if PlatformConfig:isWechatPaySupport() then 
				result[v] = true
			end
		elseif v == PlatformPaymentThirdPartyEnum.kALIPAY then 
			if PlatformConfig:isAliPaySupport() then 
				result[v] = true
			end
		else
			result[v] = true
		end
	end

	return result
end

function AndroidPayment:isSmsPaymentSupported()
	return self:filterCUPayment() ~= Payments.UNSUPPORT
		or self:filterCTPayment() ~= Payments.UNSUPPORT
		or self:filterCMPayment() ~= Payments.UNSUPPORT
end

function AndroidPayment:isThirdPartyPaymentSupported()
	return getNormalThirdPartPayment() ~= Payments.UNSUPPORT
end

function AndroidPayment:initCMPaymentDecisionScript()
	local storageSrc = Localhost:readFromStorage(decisionStoragePath)
	print("initCMPaymentDecisionScript")
	if storageSrc then
		print("storageSrc")
		print(storageSrc)
		local func = loadstring(storageSrc)
		local status, result = pcall(func)
		if status then
			print("decode success")
			print(storageSrc)
			self.smsPayDecisionScript = storageSrc
			return
		end
	end

	self.smsPayDecisionScript = defaultSMSPaymentDecision
end

function AndroidPayment:changeSMSPaymentDecisionScript(src)
	if src and src ~= "" and src ~= self.smsPayDecisionScript then
	    local func = loadstring(src)
	    local status, result = pcall(func)
	    print("changeCMPaymentDecisionScript")
	    print(src)
	    if status then
	    	print("change src")
		    local encodeSrc = amf3.encode(src)
	        local path = HeResPathUtils:getUserDataPath() .. decisionStoragePath
	        Localhost:safeWriteStringToFile(encodeSrc, path)
	    end
	end
end

function AndroidPayment:setMMAppidRule(appidRule)
	-- print("AndroidPayment:setMMAppidRule:", table.tostring(appidRule))
	local function setMMAppidRule()
		local rule = {}
		if type(appidRule) == "table" then
			for _,v in ipairs(appidRule) do
				if v.from and v.to then
					rule[tostring(v.from)] = tostring(v.to)
				end
			end
			luajava.bindClass("com.happyelements.android.operatorpayment.iap.IAPPayment"):setAppidReplaceRule(luaJavaConvert.table2Map(rule))
		end
	end
	local success, ret = pcall(setMMAppidRule)
	if not success then
		he_log_error("setMMAppidRule failed. err:"..tostring(ret))
	end
end