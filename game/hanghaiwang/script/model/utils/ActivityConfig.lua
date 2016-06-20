-- Filename：	ActivityConfig.lua
-- Author：		lichenyang
-- Date：		2011-1-8
-- Purpose：		活动配置
-- modified:    huxiaozhou 2015-07-01

module("ActivityConfig" , package.seeall)
require "db/DB_Wheel"

--[[
	@des:取数据（eg:消费累积）
	--读取消费累积的第一行
	ActivityConfig.ConfigCache.spend.data[1].des
	ActivityConfig.ConfigCache.spend.start_time			--开启时间
	ActivityConfig.ConfigCache.spend.end_time			--关闭时间
	ActivityConfig.ConfigCache.spend.need_open_time`		--需要开启时间
--]]
ConfigCache 	= 	{}

keyConfig 		= 	{}

--消费累积
keyConfig.spend 			= {
	"id", "des", "expenseGold", "reward", 
}

--充值回馈
keyConfig.topupFund 		= {
	"id", "des", "expenseGold", "array_type","reward", 
}

-- 幸运轮盘
keyConfig.turntable = {
	"id", "lv_limit", "vip_num", "total_times", "cost_1", "max_gain_1", "cost_2", "max_gain_2", "cost_3", "max_gain_3", "cost_4", "max_gain_4", "cost_5", "max_gain_5", "cost_6", "max_gain_6",
}

-- 充值红利
keyConfig.chargeWeal = {
	"id", "array_type", "array", "original_cost", "discount_price", "recharge_day", 
}

--挑战小福利
keyConfig.wealLittle  = {
	"id", "type", "server_time", "start_time", "end_time", "icon", "name", "title", "desc", "task_desc", "require1", "reward_id1", "require2", "reward_id2", "require3", "reward_id3", "require4", "reward_id4", "require5", "reward_id5", "require6", "reward_id6", "require7", "reward_id7", "require8", "reward_id8", "require9", "reward_id9", "require10", "reward_id10", 
}

-- 累计登录
keyConfig.accgift = {
	"id", "type", "icon", "name", "LAY", "desc", "reward_type", "reward_array", 
}

--zhangjunwu --2015-11-12
--装备打折
keyConfig.equipmentDiscount  = {
	"id", "array_type", "items", "original_price", "current_price", "global_limit", "self_limit", }
--饰品打折
keyConfig.treasureDiscount  = {
	"id", "array_type", "items", "original_price", "current_price", "global_limit", "self_limit",}
--空岛贝打折
keyConfig.conchDiscount  = {
	"id", "array_type", "items", "original_price", "current_price", "global_limit", "self_limit",}
--专属宝物打折
keyConfig.exclusiveDiscount  = {
	"id", "array_type", "items", "original_price", "current_price", "global_limit", "self_limit",}
	--专属宝物打折
keyConfig.propertyDiscount  = {
	"id", "array_type", "items", "original_price", "current_price", "global_limit", "self_limit",}

-- 动态福利商店
keyConfig.actwelfareshop = {
	"id", "server_time", "activity_time", "activity_icon", "activity_name", "activity_title", "goods_list", 
}	

-- 限时福利
keyConfig.weal = {
   -- 新配置 2016.2.29 modify by yangna
   "id", "server_time", "start_time", "end_time", "icon", "name", "title", "desc", "output", "resource_add", "awake_add", "explore_add", "arena_add", "boss_add", "daily_add", "coffee_add", "bar_discount", "festival_drop", "reward", "copy1_add", "copy2_add", "copy3_add", "elite_copy_add", "level_limit",
}

keyConfig.worldarena = {
	"ID", "activity_time", "server_time", "level", "update_time", "protect_time", "effect_time", "fight_time", "fight_num", "buy_num", "gold_recover", "silver_recover", 
	"fight_reward", "streak_reward", "rank_desc", "rank_reward", "kill_reward", "continue_reward", "group_num", "min_num", "target_num", "silver_limit", "gold_limit", "multiple_num", "nosign_player_level", "nosign_player_cd", "message_num", "bet_time",
}
-- -------------------------------------[[ 开服活动配置 ]]---------------------------------------------------------

function getNewServerData( key )
	local data = nil
	if(key == "turntable") then
		data = DB_Wheel.Wheel
	else

	end
	return data
end

