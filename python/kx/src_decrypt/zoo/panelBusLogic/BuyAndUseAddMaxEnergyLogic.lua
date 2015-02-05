
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014年01月27日 11:59:01
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- BuyAndUseAddMaxEnergyLogic
---------------------------------------------------


AddMaxEnergyTimeType	= {
	PERMANENT	= 1,
	DAY_7		= 2,
	DAY_15		= 3,
}

local function checkAddMaxEnergyTimeType(timeType, ...)
	assert(timeType == AddMaxEnergyTimeType.PERMANENT or
		timeType == AddMaxEnergyTimeType.DAY_7 or
		timeType == AddMaxEnergyTimeType.DAY_15)
end

AddMaxEnergyType	= {
	MAX_ENERGY_40	= 40,
	MAX_ENERGY_50	= 50,
	MAX_ENERGY_60	= 60,
}

local function checkAddMaxEnergyType(energyType, ...)

	assert( energyType == AddMaxEnergyType.MAX_ENERGY_40 or
		energyType == AddMaxEnergyType.MAX_ENERGY_50 or
		energyType == AddMaxEnergyType.MAX_ENERGY_60 )
end

assert(not BuyAndUseAddMaxEnergyLogic)
BuyAndUseAddMaxEnergyLogic = class()

function BuyAndUseAddMaxEnergyLogic:init(timeType, energyType, ...)
	checkAddMaxEnergyTimeType(timeType)
	checkAddMaxEnergyType(energyType)
	assert(#{...} == 0)

	self.timeType	= timeType
	self.energyType	= energyType

	self.goodsId = 70

	--self.goodsIds	= {}
	--self.goodsIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_40]	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_50]	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_60]	= 00000 -- change this

	--self.goodsIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_40] 	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_50] 	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_60] 	= 00000 -- change this

	--self.goodsIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_40] 	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_50] 	= 00000 -- change this
	--self.goodsIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_60] 	= 00000 -- change this

	self.propIds	= {}
	self.propIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_40]	= 10030 -- change this
	self.propIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_50]	= 10033 -- change this
	self.propIds[AddMaxEnergyTimeType.PERMANENT + AddMaxEnergyType.MAX_ENERGY_60]	= 10036 -- change this

	self.propIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_40] 	= 10031 -- change this
	self.propIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_50] 	= 10034 -- change this
	self.propIds[AddMaxEnergyTimeType.DAY_7 + AddMaxEnergyType.MAX_ENERGY_60] 	= 10037 -- change this

	self.propIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_40] 	= 10032 -- change this
	self.propIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_50] 	= 10035 -- change this
	self.propIds[AddMaxEnergyTimeType.DAY_15 + AddMaxEnergyType.MAX_ENERGY_60] 	= 10038 -- change this
end

function BuyAndUseAddMaxEnergyLogic:start(onSuccessCallback, onFailedCallback, onCancelCallback, ...)
	assert(false == onSuccessCallback or type(onSuccessCallback) == "function")
	assert(false == onFailedCallback or type(onFailedCallback) == "function")
	assert(false == onCancelCallback or type(onCancelCallback) == "function")
	assert(#{...} == 0)

	-----------------------
	-- Check If Can Take Effect
	-- -------------------------
	local userExtend 		= UserManager.getInstance().userExtend
	local energyPlusEffectTime	= userExtend:getEnergyPlusEffectTime()
	local now 			= Localhost:time()

	local canUse = true

	if energyPlusEffectTime > now then
		-- Replace This Effext
		-- May Needed Implement Confirm

		canUse = true

	elseif userExtend.energyPlusPermanentId > 0 then
		-- Permanent Prop In Effext

		local inEffectId		= userExtend.energyPlusPermanentId
		local propMeta 			= MetaManager.getInstance():getPropMeta(inEffectId)
		assert(propMeta)

		local inEffectAddedMaxEnergy	= propMeta.confidence

		if self.energyType > inEffectAddedMaxEnergy then
			-- Take Effext
			canUse = true
		else
			canUse = false
		end
	end

	if canUse then
		-- --------------
		-- Buy The Prop
		-- --------------
		print("BuyAndUseAddMaxEnergyLogic:start Called !!!!!")
		print("Mock Implemented !! ")
		--debug.debug()

		--local goodsId	= self.goodsIds[self.timeType + self.energyType]
		local propId	= self.propIds[self.timeType + self.energyType]
		local moneyType	= 2 -- Gold
		local num	= 1

		local function onBuySuccess()

			-----------------------
			-- Truely Use The Prop
			-- -------------------
			--local function onUseSuccess()
			HomeScene:sharedInstance().goldButton:updateView()

				if self.timeType == AddMaxEnergyTimeType.PERMANENT then
					-- Set Permanent Prop Data
					userExtend.energyPlusPermanentId = propId
					
					-- Clear Time Lmited Prop
					userExtend:setEnergyPlusEffectTime(0)
					userExtend.energyPlusId	= 0

				elseif self.timeType == AddMaxEnergyTimeType.DAY_7 or
					self.timeType == AddMaxEnergyTimeType.DAY_15 then

					---- Set Permanent Prop Data
					--userExtend.energyPlusPermanentId = 0
					
					-- Set Time Limited Prop
					userExtend.energyPlusId	= propId

					local now = Localhost:time()

					if self.timeType == AddMaxEnergyTimeType.DAY_7 then
						userExtend:setEnergyPlusEffectTime(now + 7*24*60*60*1000)

					elseif self.timeType == AddMaxEnergyTimeType.DAY_15 then
						userExtend:setEnergyPlusEffectTime(now + 15*24*60*60*1000)

					else
						assert(false)
					end
				else
					assert(false)
				end

				-- Set The Energy
				local maxEnergy 	= MetaManager.getInstance().global.user_energy_max_count or 30
				local propMeta 		= MetaManager.getInstance():getPropMeta(propId)
				local newFullEnergy 	= maxEnergy + propMeta.confidence
				UserManager:getInstance():refreshEnergy()
				UserManager.getInstance().user:setEnergy(newFullEnergy)

				-- Callback
				if onSuccessCallback then
					onSuccessCallback()
				end
			--end

			--local function onUseFailed()
			--	if onFailedCallback then
			--		onFailedCallback()
			--	end
			--end

			--local useLogic = UsePropsLogic:create(UsePropsType.NORMAL, 0, 0, {})
			--useLogic:setSuccessCallback(onUseSuccess)
			--useLogic:setFailedCallback(onUseFailed)
			--useLogic:start(true)
			---- Wait Server To Implemente, Debug Purpose Mock Success
			--onUseSuccess()
		end

		local function onBuyFailed(event)

			--print("BuyAndUseAddMaxEnergyLogic:start onBuyFailed Called !")
			--debug.debug()
			if onFailedCallback then
				onFailedCallback(event)
			end
		end

		local function onBuyCanceled()
			if onCancelCallback then
				onCancelCallback()
			end
		end

		print("BuyAndUseAddMaxEnergyLogic:start Called !")
		print("goodsId: " .. self.goodsId)
		print("moneyType: " .. moneyType)
		--debug.debug()
		
		if __ANDROID then -- ANDROID
			local logic = IngamePaymentLogic:create(70)
			logic:buy(onBuySuccess, onBuyFailed, onBuyCanceled)
		else -- else, on IOS and PC we use gold!
			local buyLogic = BuyLogic:create(self.goodsId, moneyType)
			buyLogic:getPrice()
			buyLogic:start(1, onBuySuccess, onBuyFailed, true)
		end
	end
end

function BuyAndUseAddMaxEnergyLogic:create(timeType, energyType, ...)
	assert(#{...} == 0)

	local logic = BuyAndUseAddMaxEnergyLogic.new()
	logic:init(timeType, energyType)
	return logic
end
