-- FileName: WARewardModel.lua
-- Author: Xufei
-- Date: 2016-02-18
-- Purpose: 奖励预览
--[[TODO List]]

module("WARewardModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local TAB_NAME = {
	TAB_1 = "1",
	TAB_2 = "2",
	TAB_3 = "3",
}

local _tabNum

function setTabName( tabName )
	_tabNum = TAB_NAME[tabName]
end

function getTabNum( ... )
	return _tabNum
end

function getRankDesc( ... )

	local arenaConfig = WorldArenaModel.getworldArenaConfig()
	local strRankDesc = arenaConfig.rank_desc
	local splitRankDesc = lua_string_split(strRankDesc, ",")
	return splitRankDesc
end

local getRankReward = function()
	logger:debug("getRankReward")

	local arenaConfig = WorldArenaModel.getworldArenaConfig()
	local strRankReward = arenaConfig.rank_reward

	local splitRankReward = lua_string_split(strRankReward, ";")
	return splitRankReward
end

local getKillReward = function()
	logger:debug("getKillReward")

	local arenaConfig = WorldArenaModel.getworldArenaConfig()
	local strKillReward = arenaConfig.kill_reward

	local splitKillReward = lua_string_split(strKillReward, ";")
	return splitKillReward
end

local getContinueReward = function()
	logger:debug("getContinueReward")

	local arenaConfig = WorldArenaModel.getworldArenaConfig()
	local strContinueReward = arenaConfig.continue_reward

	local splitContinueReward =lua_string_split(strContinueReward, ";")
	return splitContinueReward
end

local TAB_FUNC = {
	["1"] = getRankReward,
	["2"] = getKillReward,
	["3"] = getContinueReward,
}

local function getOnlyRewardsStr( rewardDB )
	local splitRewardDB = lua_string_split(rewardDB, ",")
	local rewardStr = ""
	for k,v in ipairs(splitRewardDB) do
		if (k~=1) then
			rewardStr = rewardStr..","
			rewardStr = rewardStr..v
		end
	end
	return string.sub(rewardStr,2,-1)
end

-- 根据当前的tab编号，返回显示出来的奖励列表数据
function getNowTabInfo( ... )
	local tabNum = getTabNum()
	local fnGetRewardDB = TAB_FUNC[tabNum]
	local RewardDB = fnGetRewardDB()
	local rewardDesc = getRankDesc()
	local tabInfo = {}
	for k,v in ipairs (rewardDesc) do
		local tempTb = {}
		tempTb.desc = v
		tempTb.DB = RewardDB[k]
		tempTb.DBOnlyRewards = getOnlyRewardsStr(RewardDB[k])
		table.insert(tabInfo, tempTb)
	end
	return tabInfo
end

local function init(...)
	_tabNum = TAB_NAME.TAB_1
end

function destroy(...)
	package.loaded["WARewardModel"] = nil
end

function moduleName()
    return "WARewardModel"
end

function create(...)
	init()
end
