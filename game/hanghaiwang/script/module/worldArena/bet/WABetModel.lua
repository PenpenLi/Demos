-- FileName: WABetModel.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("WABetModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local TAB_NAME = {
	TAB_1 = "1",
	TAB_2 = "2",
	TAB_3 = "3",
}

local _tabNum
local _betInfo
local _preBetInfo
local _contiTime

function setTabName( tabName )
	_tabNum = TAB_NAME[tabName]
end

function getTabNum( ... )
	return _tabNum
end

local function setWABetInfo( betInfo )
	_betInfo = betInfo
end

local function getWABetInfo( ... )
	return _betInfo
end

local function getRankInfo( rankType )
	local tbRankType = {
		killRank = 1,
		contiRank = 2,
		posRank = 3,
	}

	local betInfo = getWABetInfo()
	local fightForceRank = betInfo.fight_force_rank
	local selfBet = betInfo.self_bet

	local betAtThisType = nil
	for k,v in pairs (selfBet) do
		if (tonumber(v.rank_type)==tbRankType[rankType]) then 	-- 榜单类型：'1'击杀排行/'2'连杀排行/'3'名次排行
			betAtThisType = {}
			betAtThisType = v
		end
	end

	local rankInfo = {}
	local numOfRank = table.count(fightForceRank)
	local isBetInList = false
	for k,v in pairs (fightForceRank) do
		local temp = {}
		if (betAtThisType) then
			if (v.server_id..v.pid == betAtThisType.server_id..betAtThisType.pid) then
				isBetInList = true
				temp = betAtThisType
				temp.sort = "0"
			else
				temp = v
				temp.sort = temp.rank
			end
		else
			temp = v
			temp.sort = temp.rank
		end
		table.insert(rankInfo, temp)
	end
	if (betAtThisType and not(isBetInList)) then -- 如果有押注且不在前20里
		betAtThisType.sort = "0"
		table.insert(rankInfo, betAtThisType)
	end
	table.sort (rankInfo, function (a, b)
		return tonumber(a.sort) < tonumber(b.sort)
	end)

	logger:debug({print_rankinfo = rankInfo,
		print_betType = rankType,
		print_betted = betAtThisType,
		print_isbetInList = isBetInList})
	return rankInfo, betAtThisType
end


local getContiBet = function ( ... )
	local contiBetInfo, betAtConti = getRankInfo( "contiRank" )

	return contiBetInfo, betAtConti
end

local getKillBet = function ( ... )
	local killBetInfo, betAtKill = getRankInfo( "killRank" )

	return killBetInfo, betAtKill
end

local getPosBet = function ( ... )
	local posBetInfo, betAtPos = getRankInfo( "posRank" )

	return posBetInfo, betAtPos
end

local TAB_FUNC = {
	["1"] = getContiBet,
	["2"] = getKillBet,
	["3"] = getPosBet,
}

function getNowTabInfo( ... )
	local tabNum = getTabNum()
	logger:debug({tabNum_betModel = tabNum})
	local fnGetRecordViewInfo = TAB_FUNC[tabNum]
	local recordViewInfo, betAtThis = fnGetRecordViewInfo()
	return recordViewInfo, betAtThis
end

local function init(...)
	_tabNum = TAB_NAME.TAB_1
end

function destroy(...)
	package.loaded["WABetModel"] = nil
end

function moduleName()
    return "WABetModel"
end

function updateBetData(tbData, viewIns)
	WAService.getBetList( function ( betInfo )
		setWABetInfo(betInfo)
		viewIns:showBetView()
	end )
end

function getEndBetTime( ... )
	local startBetTime = tonumber(WorldArenaModel.getAttackStartTime())
	local timePlusConfigTime = startBetTime + getWAbetContiTime()
	local endAttackTime = tonumber(WorldArenaModel.getAttackEndTime())
	local endBetTime = math.min (timePlusConfigTime, endAttackTime)
	logger:debug({WABet_time_print_startBetTime = TimeUtil.getTimeToMin( startBetTime ),
		WABet_time_print_endBetTime = TimeUtil.getTimeToMin( endBetTime ),
		WABet_time_print_timePlusConfig = TimeUtil.getTimeToMin( timePlusConfigTime ),
		WABet_time_print_endAttackTime = TimeUtil.getTimeToMin( endAttackTime )})
	return endBetTime
end


function getIsShowRedPoint( ... )
	if (table.count(_preBetInfo) >= 3) then
		return false
	else
		local startBetTime = tonumber(WorldArenaModel.getAttackStartTime())
		local endBetTime = getEndBetTime()
		local nowTime = tonumber(TimeUtil.getSvrTimeByOffset())
		return ( (nowTime>startBetTime) and (nowTime<endBetTime) )
	end
end

function addPreBetInfo( betData )
	--table.insert(_preBetInfo, betData)
	_preBetInfo[table.count(_preBetInfo)+1] = betData
	logger:debug({print_betInfo_after_update = _preBetInfo})
end

function preSetWABetInfo( preBetInfo )
	_preBetInfo = preBetInfo
end

function preSetWAbetContiTime( contiTime )
	_contiTime = contiTime
end

function getWAbetContiTime( ... )
	return tonumber(_contiTime) or tonumber(WorldArenaModel.getworldArenaConfig().bet_time)
end

function create( betInfo )
	init()
	-- betInfo.self_bet = {
	-- 	[1] = {
	-- 		["rank_type"] = "2",
	-- 		["bet_type"] = "1",
	-- 		["bet_num"] = "20",
	-- 		["level"] = "75",
	-- 		["fight_force"] = "4727",
	-- 		["server_id"] = "110009",
	-- 		["pid"] = "108",
	-- 		["server_name"] = "myserver",
	-- 		["utid"] = "2",
	-- 		["vip"] = "1",
	-- 		["figure"] = "10173",
	-- 		["uname"] = "108",
	-- 		["ship_figure"] = "0",
	-- 		["rank"] = "123",
	-- 		["beted_num"] = "333",

	-- 	},
	-- 	[2] = {
	-- 		["rank_type"] = "1",
	-- 		["bet_type"] = "2",
	-- 		["bet_num"] = "230",
	-- 		["level"] = "75",
	-- 		["fight_force"] = "4727",
	-- 		["server_id"] = "110009",
	-- 		["pid"] = "1028",
	-- 		["server_name"] = "myserver",
	-- 		["utid"] = "2",
	-- 		["vip"] = "1",
	-- 		["figure"] = "10173",
	-- 		["uname"] = "1028",
	-- 		["ship_figure"] = "0",
	-- 		["rank"] = "123",
	-- 		["beted_num"] = "444",
	-- 	},

	-- }
	setWABetInfo(betInfo)
end
