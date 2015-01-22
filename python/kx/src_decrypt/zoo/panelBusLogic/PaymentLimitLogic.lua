
-- 需要限额的支付方式
-- local PaymentsMaxLimitMap = {
--     [Payments.CHINA_MOBILE] = { 
--     	daily=200,monthly=1000 
-- 	},
--     [Payments.CHINA_MOBILE_GAME] = { 
--     	daily=300,monthly=1000 
-- 	},
--     [Payments.CHINA_UNICOM] = { 
--     	daily=300,monthly=500 
-- 	},
--     [Payments.CHINA_TELECOM] = { 
--     	daily=100,monthly=300 
-- 	},
-- }

PaymentLimitLogic = {}

-- 当前支付方式是不是需要限额
function PaymentLimitLogic:isNeedLimit(paymentType)

	print(table.tostring(MetaManager:getInstance().global.ingame_limit))

	return MetaManager:getInstance().global.ingame_limit[paymentType] ~= nil
end

-- 当前支付方式是不是超过限额
local function getPaymentInfosPath( ... )
	return HeResPathUtils:getUserDataPath() .. "/" .. "PaymentLimit_" .. MetaInfo:getInstance():getImsi()
end

local caches = {}
local function read( ... )
	if caches[getPaymentInfosPath()] then 
		return caches[getPaymentInfosPath()]
	end

	local ret = {}
	local file = io.open(getPaymentInfosPath(), "r")
	if file then
		local data = file:read("*a") 
		file:close()
		if data then
			ret = table.deserialize(data) or {}
		end
	end
	
	caches[getPaymentInfosPath()] = ret
	return ret
end

local function write( d )
	local file = io.open(getPaymentInfosPath(),"w")
	if file then 
		file:write(table.serialize(d or {}))
		file:close()
	end
end

local function getPaymentInfo( paymentType )

	-- local paymentInfo = UserManager:getInstance().paymentInfos[paymentType] 
	local paymentInfos = read()
	local paymentInfo = paymentInfos[paymentType]

	if paymentInfo then 
		local last = os.date("*t",(paymentInfo.lastModify or 0)/1000)
		local now = os.date("*t",Localhost:time()/1000)
		if now.year > last.year or now.month > last.month or now.day > last.day then 
			paymentInfo.daily = 0
		end
		if now.year > last.year or now.month > last.month then 
			paymentInfo.monthly = 0
		end
	else
		paymentInfo = { daily=0,monthly=0,lastModify=Localhost:time() }
		-- UserManager:getInstance().paymentInfos[paymentType] = paymentInfo
		paymentInfos[paymentType] = paymentInfo
	end

	print("paymentInfos",table.tostring(paymentInfos))

	return paymentInfo,paymentInfos
end
function PaymentLimitLogic:isExceedDailyLimit(paymentType)
	if MetaManager:getInstance().global.ingame_limit[paymentType] then 
		local paymentInfo = getPaymentInfo(paymentType)
		return paymentInfo.daily >= MetaManager:getInstance().global.ingame_limit[paymentType].daily
	else
		return false
	end
end
function PaymentLimitLogic:isExceedMonthlyLimit(paymentType)
	if MetaManager:getInstance().global.ingame_limit[paymentType] then 
		local paymentInfo = getPaymentInfo(paymentType)
		return paymentInfo.monthly >= MetaManager:getInstance().global.ingame_limit[paymentType].monthly
	else
		return false
	end
end

-- 
function PaymentLimitLogic:buyComplete(paymentType,price)
	if MetaManager:getInstance().global.ingame_limit[paymentType] then 
		local paymentInfo,paymentInfos = getPaymentInfo(paymentType)

		paymentInfo.daily = paymentInfo.daily + price
		paymentInfo.monthly = paymentInfo.monthly + price
		paymentInfo.lastModify = Localhost:time()

		print(table.tostring(paymentInfos))

		write(paymentInfos)
	end
end

