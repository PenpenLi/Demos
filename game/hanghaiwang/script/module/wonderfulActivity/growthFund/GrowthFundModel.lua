-- FileName: GrowthFundModel.lua
-- Author: LvNanchun and XuFei
-- Date: 2015-06-17
-- Purpose: 成长基金数据
--[[TODO List]]

module("GrowthFundModel", package.seeall)
require "db/DB_Growth_fund"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tbGrowthInfo = nil
local _tbGrowthData = {}
local _tbCoinsAndLevel = {}

function destroy(...)
	package.loaded["GrowthFundModel"] = nil
end

function moduleName()
    return "GrowthFundModel"
end

-- 返回是否已经拉取过后端数据
function isGotBackEnd()
	if (_tbGrowthInfo) then
		return true
	else
		return false
	end
end

--[[desc:从CTRL获取数据
    arg1: CTRL中获得的后端数据table
    return:无  
—]]
function setGrowthInfo( tbGrowthInfoFromCtrl )
	logger:debug({tbGrowthInfoFromCtrl = tbGrowthInfoFromCtrl})
	_tbGrowthInfo = tbGrowthInfoFromCtrl.growup
end

--[[desc:从配置获取数据
    arg1: 无
    return: 配置表数据table
—]]
local function setGrowthFundData()
	for k,v in pairs(DB_Growth_fund.Growth_fund) do
		table.hcopy(DB_Growth_fund.getDataById(v[1]) , _tbGrowthData)
	end
	logger:debug({_tbGrowthData = _tbGrowthData})
end

--[[desc:判断vip等级是否足够
    arg1: 无
    return: bool判断
—]]
function isVipEnough()
	if (table.isEmpty(_tbGrowthData)) then
		setGrowthFundData()
	end
	return _tbGrowthData.need_vip <= UserModel.getVipLevel()
end

--[[desc:判断是否有足够的金币
    arg1: 无
    return: bool判断
—]]
function isGoldEnough()
	if (table.isEmpty(_tbGrowthData)) then
		setGrowthFundData()
	end
	return _tbGrowthData.need_gold <= UserModel.getGoldNumber()
end

--[[desc:返回配置中要求的vip数
    arg1: 无
    return: 配置中要求的vip数
—]]
function getVipLevelNeeded()
	if (table.isEmpty(_tbGrowthData)) then
		setGrowthFundData()
	end
	return _tbGrowthData.need_vip
end

--[[desc:根据对于已领取按钮的点击改变已领取奖励的table
    arg1: 领取的奖励的id
    return: 无
—]]
function setPrizedArrayById( prizeId )
	table.insert( _tbGrowthInfo.prized , tostring(prizeId))
	logger:debug({ajwioejnvjaerjnfgaiulfjaeiswgjiloadehnbgikjandsf= _tbGrowthInfo})
end


--[[desc:根据后端数据列出已领的奖励
    arg1: 无
    return: 已领奖励的table
—]]
function prizedArray()
	return _tbGrowthInfo.prized
end

--[[desc:设定buytime
    arg1: 购买时间的值。若无则设定为1
    return: 无
—]]
function setBuyTime( timeValue )
	_tbGrowthInfo.buy_time = timeValue or 1
end

--[[desc:获取购买时间
    arg1: 无
    return: 返回购买时间 
—]]
function buyTime()
	return tonumber(_tbGrowthInfo.buy_time)
end

--[[desc:金币和需要的级数的table
    arg1: 无
    return: 返回金币和需要的级数的table
—]]
local function dealCoinsAndLevelTable()
	if (table.isEmpty(_tbGrowthData)) then
		setGrowthFundData()
	end
	local strCoinsAndLevel = _tbGrowthData.golds_array
	local tbFinalCoinsAndLevel = {}
	local tbOneCoinsAndLevel = {}

	local tbCoinsAndLevel = lua_string_split(strCoinsAndLevel, ',')

	for k,v in pairs(tbCoinsAndLevel) do
		tbOneCoinsAndLevel = lua_string_split(v, '|')

		logger:debug({tbOneCoinsAndLevel = tbOneCoinsAndLevel})

		tbFinalCoinsAndLevel[k] = {}

		tbFinalCoinsAndLevel[k]['level'] = tonumber(tbOneCoinsAndLevel[1])
		tbFinalCoinsAndLevel[k]['coins'] = tonumber(tbOneCoinsAndLevel[2])
	end

	function keySort(data1, data2)
		return tonumber(data1.level) < tonumber(data2.level)
	end

	table.sort( tbFinalCoinsAndLevel , keySort)

	logger:debug({tbFinalCoinsAndLevel = tbFinalCoinsAndLevel})

	_tbCoinsAndLevel = tbFinalCoinsAndLevel
end

--[[desc:获取配置表金币等级
    arg1: 无
    return: 返回金币和等级
—]]
function getCoinsAndLevel( )
	if table.isEmpty(_tbCoinsAndLevel) then
		dealCoinsAndLevelTable()
	end
	return _tbCoinsAndLevel
end

--[[desc:只根据等级和后端数据判断的未领取数
    arg1: 无
    return: 返回未领取数
—]]
function getUnprizedNumByLevel()
	local numPerLevel = UserModel.getHeroLevel()
	local numNotPrized = 0

	if table.isEmpty(_tbCoinsAndLevel) then
		dealCoinsAndLevelTable()
	end

	for k,v in pairs(_tbCoinsAndLevel) do
		if (v.level <= numPerLevel) then 
			numNotPrized = numNotPrized + 1
		end
	end
	numNotPrized = numNotPrized - #prizedArray()

	return numNotPrized
end

--[[desc:根据购买时间判断的未领取数
    arg1: 无
    return: 返回未领取数
—]]
function getUnprizedNumByTime()
	local numNotPrized = getUnprizedNumByLevel()
	local timeBuy = buyTime()

	if (timeBuy == 0) then 
		return 0
	else 
		return numNotPrized
	end
end

--[[desc:判断是否需要显示按钮
    arg1: 无
    return: bool值，true则需要显示，false不需显示
—]]
function needShowGrowthFund( )
	if table.isEmpty(_tbCoinsAndLevel) then
		dealCoinsAndLevelTable()
	end
	require "script/module/wonderfulActivity/growthFund/EveryoneWelfareModel"
	if (not EveryoneWelfareModel.isAllHaveGot()) then
		return true
	end
	return not (#prizedArray() == #_tbCoinsAndLevel)
end

--[[desc:最大能领取奖励的等级数
    arg1: 无
    return: 返回int表示最大能领取的奖励的等级
—]]
function maxPrizeLevel()
	local numPerLevel = UserModel.getHeroLevel()
	local numMaxLevel = 0
	if table.isEmpty(_tbCoinsAndLevel) then
		dealCoinsAndLevelTable()
	end

	for k,v in pairs(_tbCoinsAndLevel) do
		if (v.level <= numPerLevel) then 
			numMaxLevel = numMaxLevel + 1
		end
	end
	logger:debug({numMaxLevel = numMaxLevel})
	return numMaxLevel
end

--[[desc:根据配置计算总金币数
    arg1: 无
    return: 返回总金币数
—]]
function countSumOfCoins()
	local numSumOfCoins = 0
	if table.isEmpty(_tbCoinsAndLevel) then
		dealCoinsAndLevelTable()
	end

	for k,v in pairs(_tbCoinsAndLevel) do
		numSumOfCoins = numSumOfCoins + tonumber(v.coins)
	end

	return numSumOfCoins
end


--[[desc:返回需要的金币数
    arg1: 无
    return: 返回一个数字为需要的金币数
—]]
function coinsNeeded()
	if (table.isEmpty(_tbGrowthData)) then
		setGrowthFundData()
	end
	return _tbGrowthData.need_gold
end
