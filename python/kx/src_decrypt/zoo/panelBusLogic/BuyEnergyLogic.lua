
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê01ÔÂ11ÈÕ  9:15:32
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- BuyEnergyLogic
---------------------------------------------------

assert(not BuyEnergyLogic)
BuyEnergyLogic = class()

function BuyEnergyLogic:init(num, ...)
	assert(type(num) == "number")
	assert(#{...} == 0)

	self.num = num

	local user = UserManager:getInstance().user
	local stageInfo = StageInfoLocalLogic:getStageInfo( user.uid );
	self.levelId = -1
	if stageInfo then
		self.levelId = stageInfo.levelId
	end
end

function BuyEnergyLogic:start(showTip, successCallback, failedCallback, ...)
	assert(type(showTip) == "boolean")
	assert(not successCallback or type(successCallback) == "function") 
	assert(not failedCallback or type(failedCallback) == "function") 
	assert(#{...} == 0)

	local function onSuccess(data)
		print("BuyEnergyLogic:start onSuccess Called !")

		-- Add User Energy
		UserManager:getInstance():getUserRef():addEnergy(self.num)

		if successCallback then
			successCallback(data)
		end
	end

	local function onFailed(errorCode)
		print("BuyEnergyLogic:start onFailed Called !")

		if failedCallback then
			failedCallback(errorCode)
		end
	end

	local product = 34
	local buyed = UserManager:getInstance():getDailyBoughtGoodsNumById(product)
	if buyed > 0 then product = 23 end
	local logic = BuyLogic:create(product, 2)
	local price = logic:getPrice()
	print("price, self.num", price, self.num)
	DcUtil:logRewardItem("buy", 4, self.num, self.levelId)
	logic:start(1, onSuccess, onFailed, showTip, price * self.num) 
end

function BuyEnergyLogic:create(num, ...)
	assert(type(num) == "number")
	assert(#{...} == 0)

	local newBuyEnergyLogic = BuyEnergyLogic.new()
	newBuyEnergyLogic:init(num)
	return newBuyEnergyLogic
end
