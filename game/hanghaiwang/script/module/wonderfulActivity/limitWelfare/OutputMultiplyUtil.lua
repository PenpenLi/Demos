-- FileName: OutputMultiplyUtil.lua
-- Author: Xufei
-- Date: 2015-01-19
-- Purpose: 产出倍率
--[[TODO List]]

module("OutputMultiplyUtil", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
	-- start_time = 1456970400
	-- end_time = 1457017200
	-- version = 1456973191
	-- need_open_time = 1456970400
	-- data = {
	-- 	1 = {
	-- 		copy2_add = "20000"
	-- 		id = "1"
	-- 		output = "奖励翻倍翻倍！"
	-- 		bar_discount = "8000"
	-- 		daily_add = "300001|20000,300002|20000,300004|20000"
	-- 		copy3_add = "15000"
	-- 		reward = "60002"
	-- 		coffee_add = "30000"
	-- 		explore_add = "25000"
	-- 		arena_add = "20000"
	-- 		server_time = "20160303000000"
	-- 		start_time = "20160303100000"
	-- 		title = "title_timelimit_welfare.png"
	-- 		copy1_add = "25000"
	-- 		festival_drop = "204001"
	-- 		desc = "参与限时福利活动，可以获得比平时更丰厚的游戏收入哦！"
	-- 		end_time = "20160303230000"
	-- 		awake_add = "20000"
	-- 		resource_add = "15000"
	-- 		icon = "icon_timelimit_welfare.png"
	-- 		elite_copy_add = "20000"
	-- 		name = "name_timelimit_welfare.png"
	-- 		boss_add = "20000"
	-- 		}
			
	-- 	}


local M_BASE_RATE = 10000  --没有活动开启默认返回10000

local m_limitwWelData

local function init(...)

end

function destroy(...)
	package.loaded["OutputMultiplyUtil"] = nil
end

function moduleName()
    return "OutputMultiplyUtil"
end


local tbNames = {
  "resource_add",   -- 1 资源矿产出
  "awake_add",      -- 2 觉醒副本产出
  "explore_add",    -- 3 探索
  "arena_add",      -- 4 竞技场
  "boss_add",       -- 5 世界boss
  "daily_add",      -- 6 日常副本加成
  "coffee_add",     -- 7 喝咖啡
  "bar_discount",	-- 8 酒馆 千万悬赏
  "copy1_add",      -- 9 普通难度副本加成
  "copy2_add",      -- 10 困难难度副本加成
  "copy3_add",      -- 11 炼狱难度副本加成
  "elite_copy_add", -- 12 精英副本加成
}



--[[desc:获取日常副本配置的奖励倍率,计算结果需要除以10000.   活动没开启返回10000
    copyid:当前副本id
    return: 配置的倍率,没有对应活动 返回10000
—]]
function getDailyCopyRateNum( copyid )
	if (not LimitWelfareModel.isLimitWelfareOpen()) then 
		return M_BASE_RATE
	end 
	
	local name = "daily_add"  
	m_limitwWelData = LimitWelfareModel.getLimitWelDB()
	local rate = M_BASE_RATE

	if (tonumber(UserModel.getHeroLevel()) < tonumber(m_limitwWelData.level_limit)) then 
		logger:debug("user level <  level_limit")
		return rate
	end 

	if (m_limitwWelData[name] and m_limitwWelData[name]~="") then 
		local data = lua_string_split(m_limitwWelData[name],',')
		local tbDataTemp = {}
		for k, v in pairs(data) do 
			tbDataTemp[#tbDataTemp+1] = lua_string_split(v,'|')
		end 

		for k,v in pairs(tbDataTemp) do 
			if (tonumber(v[1])==tonumber(copyid)) then 
				rate = tonumber(v[2])
				break
			end 
		end 
	end 

	return rate
end


--[[desc:获取配置的奖励倍率,需要对计算结果除以 10000  活动没开启返回10000 ，此接口用于日常副本之外 
    type:类型 资源矿=1，觉醒副本=2，探索=3，竞技场=4，世界boss=5，喝咖啡加成=7,千万悬赏=8, 普通难度副本 = 9, 困难难度副本加=10 , 炼狱难度副本加成=11, 精英副本加成=12
    return: 配置的倍率,没有对应活动 返回10000
—]]
function getMultiplyRateNum( type )
	if (not LimitWelfareModel.isLimitWelfareOpen()) then 
		return M_BASE_RATE
	end 
	
	local name = tbNames[type]
	if (not name) then 
		return M_BASE_RATE
	end 

	m_limitwWelData = LimitWelfareModel.getLimitWelDB()

	if (tonumber(UserModel.getHeroLevel()) < tonumber(m_limitwWelData.level_limit)) then 
		logger:debug("user level <  level_limit")
		return M_BASE_RATE
	end 

	if (m_limitwWelData[name] and m_limitwWelData[name]~="") then 
		return tonumber(m_limitwWelData[name]) 
	end 

	return M_BASE_RATE
end


--[[desc:限时福利 副本额外掉落 （日常副本，精英副本，觉醒副本，普通副本（简单，困难，炼狱） ）
    arg1: 参数说明
    return: 1 status :bool是否开启额外掉落功能    2 table：{ id1,id2 } 额外掉落的奖励物品id  3 string ：reward字段
—]]
function getAdditionalDrop( ... )
	if (not LimitWelfareModel.isLimitWelfareOpen()) then 
		return false,nil,nil
	end 

	m_limitwWelData = LimitWelfareModel.getLimitWelDB()

	if (tonumber(UserModel.getHeroLevel()) < tonumber(m_limitwWelData.level_limit)) then 
		logger:debug("user level <  level_limit")
		return false,nil,nil
	end 

	if (m_limitwWelData.festival_drop and m_limitwWelData.festival_drop~="") then 
		local reward = m_limitwWelData.reward
		local data = lua_string_split(reward,'|')
		return true, data , reward
	end 

	return false,nil,nil
end



function create(...)

end
