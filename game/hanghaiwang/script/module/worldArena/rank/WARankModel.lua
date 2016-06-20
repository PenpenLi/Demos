-- FileName: WARankModel.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("WARankModel", package.seeall)

--[[
rank_info = {
	kill_rank = {
		}
		
	conti_rank = {
		}
		
	pos_rank = {
		1 = {
			server_id = "110009"
			pid = "20522"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20522"
			server_name = "myserver"
			level = "50"
			rank = "1"
			figure = "10173"
			}
			
		2 = {
			server_id = "110009"
			pid = "20305"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20305"
			server_name = "myserver"
			level = "50"
			rank = "2"
			figure = "10173"
			}
			
		3 = {
			server_id = "110009"
			pid = "20337"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20337"
			server_name = "myserver"
			level = "50"
			rank = "3"
			figure = "10173"
			}
			
		4 = {
			server_id = "110009"
			pid = "20702"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20702"
			server_name = "myserver"
			level = "50"
			rank = "4"
			figure = "10173"
			}
			
		5 = {
			server_id = "110009"
			pid = "20474"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20474"
			server_name = "myserver"
			level = "50"
			rank = "5"
			figure = "10173"
			}
			
		6 = {
			server_id = "110009"
			pid = "107"
			ship_figure = "0"
			fight_force = "4727"
			vip = "1"
			utid = "1"
			uname = "亨利哈维"
			server_name = "myserver"
			level = "52"
			rank = "6"
			figure = "10173"
			}
			
		7 = {
			server_id = "110009"
			pid = "20670"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20670"
			server_name = "myserver"
			level = "50"
			rank = "7"
			figure = "10173"
			}
			
		8 = {
			server_id = "110009"
			pid = "20466"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20466"
			server_name = "myserver"
			level = "50"
			rank = "8"
			figure = "10173"
			}
			
		9 = {
			server_id = "110009"
			pid = "20662"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20662"
			server_name = "myserver"
			level = "50"
			rank = "9"
			figure = "10173"
			}
			
		10 = {
			server_id = "110009"
			pid = "20185"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20185"
			server_name = "myserver"
			level = "50"
			rank = "10"
			figure = "10173"
			}
			
		11 = {
			server_id = "110009"
			pid = "20273"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20273"
			server_name = "myserver"
			level = "50"
			rank = "11"
			figure = "10173"
			}
			
		12 = {
			server_id = "110009"
			pid = "20353"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20353"
			server_name = "myserver"
			level = "50"
			rank = "12"
			figure = "10173"
			}
			
		13 = {
			server_id = "110009"
			pid = "109"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "2"
			uname = "109"
			server_name = "myserver"
			level = "50"
			rank = "13"
			figure = "10173"
			}
			
		14 = {
			server_id = "110009"
			pid = "20345"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20345"
			server_name = "myserver"
			level = "50"
			rank = "14"
			figure = "10173"
			}
			
		15 = {
			server_id = "110009"
			pid = "20678"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20678"
			server_name = "myserver"
			level = "50"
			rank = "15"
			figure = "10173"
			}
			
		16 = {
			server_id = "110009"
			pid = "108"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "2"
			uname = "108"
			server_name = "myserver"
			level = "50"
			rank = "16"
			figure = "10173"
			}
			
		17 = {
			server_id = "110009"
			pid = "20281"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20281"
			server_name = "myserver"
			level = "50"
			rank = "17"
			figure = "10173"
			}
			
		18 = {
			server_id = "110009"
			pid = "20361"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20361"
			server_name = "myserver"
			level = "50"
			rank = "18"
			figure = "10173"
			}
			
		19 = {
			server_id = "110009"
			pid = "20686"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20686"
			server_name = "myserver"
			level = "50"
			rank = "19"
			figure = "10173"
			}
			
		20 = {
			server_id = "110009"
			pid = "20217"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20217"
			server_name = "myserver"
			level = "50"
			rank = "20"
			figure = "10173"
			}
			
		21 = {
			server_id = "110009"
			pid = "20209"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20209"
			server_name = "myserver"
			level = "50"
			rank = "21"
			figure = "10173"
			}
			
		22 = {
			server_id = "110009"
			pid = "20694"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20694"
			server_name = "myserver"
			level = "50"
			rank = "22"
			figure = "10173"
			}
			
		23 = {
			server_id = "110009"
			pid = "20458"
			ship_figure = "0"
			fight_force = "3451"
			vip = "1"
			utid = "1"
			uname = "mbg20458"
			server_name = "myserver"
			level = "50"
			rank = "23"
			figure = "10173"
			}
			
		}
		
	}
	
}
--]]

-- UI控件引用变量 --

-- 模块局部变量 --

local TAB_NAME = {
	TAB_1 = "1",
	TAB_2 = "2",
	TAB_3 = "3",
}

local _tabNum
local _WArankInfo

function setTabName( tabName )
	_tabNum = TAB_NAME[tabName]
end

function getTabNum( ... )
	return _tabNum
end

local function setWARankInfo( rankInfo )
	_WArankInfo = rankInfo
end

local function getWARankInfo( ... )
	return _WArankInfo
end

local getContiRank = function ( ... )
	local rankInfo = getWARankInfo()
	local contiRankInfo = rankInfo.conti_rank

	return contiRankInfo
end

local getKillRank = function ( ... )
	local rankInfo = getWARankInfo()
	local killRankInfo = rankInfo.kill_rank

	return killRankInfo
end

local getPosRank = function ( ... )
	local rankInfo = getWARankInfo()
	local posRankInfo = rankInfo.pos_rank

	return posRankInfo
end

local TAB_FUNC = {
	["1"] = getContiRank,
	["2"] = getKillRank,
	["3"] = getPosRank,
}

function getMyRankInfo( rankViewInfo )
	local myServerId = UserModel.getServerId()
	local myPid = UserModel.getPid()
	local isInNowRank = false
	for k,v in pairs (rankViewInfo) do
		if (v.server_id..v.pid == myServerId..myPid) then
			isInNowRank = true 
			return v
		end
	end
	return nil
end

function getNowTabInfo( ... )
	local tabNum = getTabNum()
	logger:debug({tabNum_rankModel = tabNum})
	local fnGetRankViewInfo = TAB_FUNC[tabNum]
	local rankViewInfo = fnGetRankViewInfo()
	local myRankInfo = getMyRankInfo(rankViewInfo)
	rankViewInfo.myRankInfo = myRankInfo
	return rankViewInfo
end

local function init(...)
	_tabNum = TAB_NAME.TAB_1
end

function destroy(...)
	package.loaded["WARankModel"] = nil
end

function moduleName()
    return "WARankModel"
end

function create( rankInfo )
	init()
	-- rankInfo = {
	-- 	kill_rank = {
	-- 		[1] = {
	-- 		["server_id"] = "110009",
	-- 		["kill_num"] = "5",
	-- 		["pid"] = "20522",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20522",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "1",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[2] = {
	-- 		["server_id"] = "110009",
	-- 		["kill_num"] = "6",
	-- 		["pid"] = "20305",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20305",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "2",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[3] = {
	-- 		["server_id"] = "110009",
	-- 		["kill_num"] = "7",
	-- 		["pid"] = "20337",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20337",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "3",
	-- 		["figure"] = "10173",
	-- 		},
	-- 	},
		
	-- 	conti_rank = {
	-- 		[1] = {
	-- 		["server_id"] = "110009",
	-- 		["max_conti_num"] = "6",
	-- 		["pid"] = "20522",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20522",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "1",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[2] = {
	-- 		["server_id"] = "110009",
	-- 		["max_conti_num"] = "7",
	-- 		["pid"] = "20305",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20305",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "2",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[3] = {
	-- 		["server_id"] = "110009",
	-- 		["max_conti_num"] = "8",
	-- 		["pid"] = "20337",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20337",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "3",
	-- 		["figure"] = "10173",
	-- 		},
	-- 	},
		
	-- 	pos_rank = {
	-- 		[1] = {
	-- 		["server_id"] = "110009",
	-- 		["pid"] = "20522",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20522",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "1",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[2] = {
	-- 		["server_id"] = "110009",
	-- 		["pid"] = "20305",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20305",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "2",
	-- 		["figure"] = "10173",
	-- 		},
			
	-- 		[3] = {
	-- 		["server_id"] = "110009",
	-- 		["pid"] = "20337",
	-- 		["ship_figure"] = "0",
	-- 		["fight_force"] = "3451",
	-- 		["vip"] = "1",
	-- 		["utid"] = "1",
	-- 		["uname"] = "mbg20337",
	-- 		["server_name"] = "myserver",
	-- 		["level"] = "50",
	-- 		["rank"] = "3",
	-- 		["figure"] = "10173",
	-- 		},
	-- 	},
	-- }
	setWARankInfo( rankInfo )
end
