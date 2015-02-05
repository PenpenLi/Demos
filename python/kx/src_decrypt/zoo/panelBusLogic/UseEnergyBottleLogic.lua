
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年12月 6日 21:19:09
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- UseEnergyBottleLogic
---------------------------------------------------

assert(not UseEnergyBottleLogic)
UseEnergyBottleLogic = class()

function UseEnergyBottleLogic:init(energyType, ...)
	assert(type(energyType) == "number")
	assert(#{...} == 0)

	assert(energyType == ItemType.SMALL_ENERGY_BOTTLE or
		energyType == ItemType.MIDDLE_ENERGY_BOTTLE or
		energyType == ItemType.LARGE_ENERGY_BOTTLE or 
		energyType == ItemType.INFINITE_ENERGY_BOTTLE )

	self.energyType = energyType

	self.successCallback = false
end

function UseEnergyBottleLogic:setSuccessCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.successCallback = callback
end

function UseEnergyBottleLogic:start(popWaitTip, ...)
	--assert(type(popWaitTip) == "boolean")
	assert(#{...} == 0)

	local function successCallback()

		-- Add The Energy
		local numberOfEnergyToAdd = false

		if self.energyType == ItemType.SMALL_ENERGY_BOTTLE then
			numberOfEnergyToAdd = 1
			UserManager:getInstance():getUserRef():addEnergy(numberOfEnergyToAdd)
		elseif self.energyType == ItemType.MIDDLE_ENERGY_BOTTLE then
			numberOfEnergyToAdd = 5
			UserManager:getInstance():getUserRef():addEnergy(numberOfEnergyToAdd)
		elseif self.energyType == ItemType.LARGE_ENERGY_BOTTLE then
			numberOfEnergyToAdd = 30
			UserManager:getInstance():getUserRef():addEnergy(numberOfEnergyToAdd)
		elseif self.energyType == ItemType.INFINITE_ENERGY_BOTTLE then
			local oldBuff = UserManager:getInstance().userExtend:getNotConsumeEnergyBuff()
			local newBuff = 0
			if oldBuff < Localhost:time() then
				newBuff = Localhost:time() + 3600 * 1000
			else
				newBuff = oldBuff + 3600 * 1000
			end
			UserManager:getInstance().userExtend:setNotConsumeEnergyBuff(newBuff)
		else 
			assert(false)
		end

		-- Callback
		if self.successCallback then
			self.successCallback()
		end

	end

	local logic = UsePropsLogic:create(UsePropsType.NORMAL, 0, 0, {self.energyType})
	logic:setSuccessCallback(successCallback)
	logic:start(popWaitTip)
end

function UseEnergyBottleLogic:create(energyType, ...)
	assert(type(energyType) == "number")
	assert(#{...} == 0)

	local newUseEnergyBottlLogic = UseEnergyBottleLogic.new()
	newUseEnergyBottlLogic:init(energyType)
	return newUseEnergyBottlLogic
end
