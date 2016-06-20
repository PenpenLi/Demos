-- FileName: CafeRewardCtrl.lua
-- Author: menghao
-- Date: 2014-09-15
-- Purpose: 联盟人鱼咖啡厅奖励预览ctrl


require "script/module/guild/cafeHouse/CafeRewardView"


module("CafeRewardCtrl", package.seeall)


-- UI控件引用变量 --


-- 模块局部变量 --


function getRewardData( ... )
	require "db/DB_Legion_feast"

	local tbRewards = {}

	local dbInfo = DB_Legion_feast.getDataById(1)
	local rate = OutputMultiplyUtil.getMultiplyRateNum(7)  --限时福利倍率

	for i=0,tonumber(GuildUtil.getMaxGongyuLevel()) do
		local tbOneReward = {}
		tbOneReward.id = i

		tbOneReward.execution = math.floor(dbInfo.baseExecution + dbInfo.growExecution * i / 100)
		tbOneReward.stamina = math.floor(dbInfo.baseStamina + dbInfo.growStamina * i / 100)
		tbOneReward.prestige = math.floor(dbInfo.basePrestige + dbInfo.growPrestige * i / 100)
		tbOneReward.silver = math.floor(dbInfo.baseSilver + dbInfo.growSilver * i / 100)
		tbOneReward.gold = math.floor(dbInfo.baseGold + dbInfo.growGold * i / 100)

		tbOneReward.execution = math.floor(tbOneReward.execution * rate / 10000)
		tbOneReward.stamina = math.floor(tbOneReward.stamina * rate / 10000)
		tbOneReward.prestige = math.floor(tbOneReward.prestige * rate / 10000)
		tbOneReward.silver = math.floor(tbOneReward.silver * rate / 10000)
		tbOneReward.gold = math.floor(tbOneReward.gold * rate / 10000)

		table.insert(tbRewards, tbOneReward)
	end

	return tbRewards
end


local function init(...)

end


function destroy(...)
	package.loaded["CafeRewardCtrl"] = nil
end


function moduleName()
	return "CafeRewardCtrl"
end


function create(...)
	local tbRewards = getRewardData()
	local layMain = CafeRewardView.create(tbRewards)
	LayerManager.addLayout(layMain)
	CafeRewardView.adjustLsv(tbRewards)
end

