-- FileName: ShipRebornModel.lua
-- Author: Xufei
-- Date: 2015-10-21
-- Purpose: 主船重生数据模块
--[[TODO List]]

module("ShipRebornModel", package.seeall)
-- UI控件引用变量 --

-- 模块局部变量 --
local _shipId = nil
local _shipLv = nil

function setShipInfo( shipId, shipLv )
	_shipId = shipId
	_shipLv = shipLv
end

function getShipId( ... )
	return tonumber(_shipId)
end

--[[desc:获得主船强化所花费的贝里和物品
    arg1: 主船的id, 主船的强化等级
    return: 返回花费的贝里数，和花费的物品字符串
—]]
function getStrengthenCost()
	local shipInfo = ShipData.getShipInfoById(_shipId)
	-- 获取花费的物品
	local strGoodsCost = shipInfo.str_item_fee
	local tbSplStrGoodsCost = lua_string_split(strGoodsCost, ",")
	local tbGoodCostIds = {}
	local tbGoodCostString = {}
	-- 获取花费的贝里
	local strBellyCost = shipInfo.str_belly_fee
	local tbSplStrBellyCost = lua_string_split(strBellyCost, "|")
	local numBellyCost = 0
	-- 如果等级为1，则返回0贝里和空的物品表
	if (_shipLv<1) then
		return numBellyCost, {}
	else
		for i=1,tonumber(_shipLv) do
			-- 贝里数累积
			numBellyCost = numBellyCost + tonumber(tbSplStrBellyCost[i])
			-- 获取物品的信息
			local stringReward = tbSplStrGoodsCost[i]
			local tbReward = lua_string_split(stringReward, "|")
			local rewardId = tbReward[1]
			local rewardCount = tbReward[2]
			-- 如果没有遇到过这个种类的奖励，将它加入tbGoodCostIds表，并记下数量
			if (not table.include(tbGoodCostIds, rewardId)) then
				table.insert(tbGoodCostIds, rewardId)
				tbGoodCostString[rewardId] = tonumber(rewardCount)
			else
				-- 如果已经遇到过这个种类的奖励，则累积数量
				tbGoodCostString[rewardId] = tbGoodCostString[rewardId] + tonumber(rewardCount)
			end
		end
	end
	-- 将奖励和贝里转换成奖励字符串
	local strReward = ""
	for k,v in pairs(tbGoodCostString) do
		local str = "7|" .. k .. "|" .. v
		strReward = strReward .. str .. ","
	end
	strReward = string.sub(strReward, 1, -2)
	strReward = "1|0|"..tostring(numBellyCost)..","..strReward

	logger:debug({goodsCost_________  =  strReward,
		BellyCost__________ = numBellyCost})

	return numBellyCost, strReward
end

-----------------------------
local function init(...)

end

function destroy(...)
	package.loaded["ShipRebornModel"] = nil
end

function moduleName()
    return "ShipRebornModel"
end

function create(...)

end
