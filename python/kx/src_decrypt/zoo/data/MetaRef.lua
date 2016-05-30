require "zoo.util.MemClass"

local debugDataRef = false


--
-- RewardItemRef ---------------------------------------------------------
--
RewardItemRef = class()
function RewardItemRef:ctor(itemId, num)
	self.itemId = itemId or 0
	self.num = num or 0
end

--
-- util func ---------------------------------------------------------
--

local function parseItemDict( src )
	if not src then return {} end
	assert(type(src) == "string")

	local result = {}
	local items = src:split(",")

	if items and #items > 0 then
		for i,v in ipairs(items) do
			local content = v:split(":")
			if content and #content > 0 then
				local key = tonumber(content[1])
				local value = tonumber(content[2])
				table.insert(result, RewardItemRef.new(key, value))
			end
		end
	end

	if debugDataRef then
		print("parseItemDict", #result)
	end
	return result
end 

local function parseItemList( src )
	if not src then return {} end
	assert(type(src) == "string")

	local result = {}
	local items = src:split(",")

	if items and #items > 0 then
		for i,v in ipairs(items) do
			result[i] = tonumber(v)
		end
	end

	if debugDataRef then
		print("parseItemList", #result)
	end
	return result
end

local function parseConditionRewardList(src)
	if type(src) ~= "string" then return {} end

	local result = {}
	local rewards = string.split(src, ";")

	if rewards then
		for i, v in ipairs(rewards) do
			local reward = RewardsWithConditionRef.new()
			reward:fromLua(v)
			result[i] = reward
		end
		table.sort(result, function(a,b) return a.condition < b.condition end)
		for index, k in ipairs(result) do
			k.id = index
		end
	end
	return result
end

function parseIngameLimitDict( src )
	if not src then return {} end
	assert(type(src) == "string")

	local result = {}
	local items = src:split(",")

	if items and #items > 0 then
		for i,v in ipairs(items) do
			local content = v:split(":")
			if content and #content == 4 then

				local key = tonumber(content[1])
				local value = { daily= tonumber(content[3]),monthly= tonumber(content[4])  }
				result[key] = value

			end
		end
	end

	return result
end 
--
-- GlobalServerConfig ---------------------------------------------------------
--
GlobalServerConfig = class()
function GlobalServerConfig:ctor()
	self.single_item = 10
	self.ice = 1000
	self.blocker = 100
	self.collect = 10000
	self.lock = 100
	self.coin = 5
	self.cuteBall = 100
	self.crystalBall = 100
	self.strip = 200
	self.wrap = 250
	self.color = 300
	self.mixed_strip_strip = 500
	self.mixed_wrap_strip = 1000
	self.mixed_wrap_wrap = 1500
	self.mixed_color_strip = 2000
	self.mixed_color_color = 5000
	self.mixed_wrap_color = 2500
	self.multiple_wrap = 1
	self.multiple_strip = 0.5
	self.multiple_strip_strip = 2
	self.multiple_color = 1.5
	self.multiple_wrap_wrap = 3
	self.multiple_wrap_strip = 2.5
	self.multiple_color_wrap = 3.5
	self.multiple_color_strip = 3
	self.moveTranslateToStrip = 2500
	self.multiple_color_color = 4
	self.freeUnlockBagConfig = {2,5,10,16,25,36}
	self.translateStripBlast = 200
	self.compound_strip = 2
	self.initBagSize = 20 --18
	self.daily_max_send_gift_count = 5
	self.daily_max_receive_gift_count = 5
	self.compound_wrap = 3
	self.compound_color = 6
	self.user_energy_init_count = 30
	self.user_energy_max_count = 30
	self.invite_friends_count = 10
	self.invite_friends_continue_day = 60
	self.user_energy_request_get = 1
	self.daily_max_request_energy_count = 10
	self.user_energy_request_get = 1
	self.daily_max_request_energy_count = 10
	self.user_energy_recover_time_unit = 480000
	self.user_energy_level_consume = 5
	self.fruit_grow_cycle = 180000
	self.bag_capacity = 10
	self.time_max_request_energy_receive_count = 5
	self.user_init_coin = 30000
	self.star_pot_view = {0,18,36}
	self.join_QQ_panel_reward = {}
	self.disable_payment = false
	self.fruit_crow_count_num = 5
	self.promotion_qq_new_user_reward = {}
	self.energy_fruit_ratio = 18
	self.bug_mission_start = 2
	self.qq_new_user_reward = {}
	self.replace_color_upgrade = 400
	self.digTreasure_play_num = 5
	self.current_digger_match = 1
	self.fillSign = {}
	self.score_game_day = 5
	self.score_game_reward = {}
	self.enter_invite_code_reward = {}
	self.new_user_reward_normal = {}
	self.new_user_reward_baidu = {}
	self.new_user_reward_qq = {}
	self.week_match_levels = {}
	self.rabbit_week_match_levels = {}
	self.summer_week_match_levels = {}
	self.ingame_limit = {}
	self.ingame_limit_low = {}
	self.weekRankMinNum = 50
	self.weekSurpassLimit = 200
	self.weekSurpassReward = {}
	self.weekWeeklyReward = {}
	self.failLevelNumToShowJump = 999
	self.firstNewObstacleLevels = {}
	self.missionAutoLaunch = 0
end
function GlobalServerConfig:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil of GlobalServerConfig")
		return		
	end

	for k,v in pairs(src) do
		if type(v) == "table" then
			local key = v.key
			local value = v[1]
			if key == "freeUnlockBagConfig" or key == "star_pot_view" or key == "fillSign" then
				value = parseItemList(value)
			elseif key == "join_QQ_panel_reward" or key == "score_game_reward" or key == "enter_invite_code_reward" or key == "new_user_reward_normal" or key == "new_user_reward_baidu" or key == "new_user_reward_qq" then
				value = parseItemDict(value)
			elseif key == "disable_payment" then
				value = (value == "true")
			elseif key == "fillSign" then
				local addMarkPrice = {}
				local ss = string.split(value, ",")
				for ids, mpi in ipairs(ss) do
					table.insert(addMarkPrice, tonumber(mpi))
				end
				value = addMarkPrice
				print("fillSign", table.tostring(value))
			elseif key == 'week_match_levels' then
				value = parseItemList(value)
			elseif key == 'rabbit_week_match_levels' then
				value = parseItemList(value)
			elseif key == 'summer_week_match_levels' then
				value = parseItemList(value)
			elseif key == "autumn_week_match_levels" then
				value = parseItemList(value)
			elseif key == "winter_week_match_levels" then
				value = parseItemList(value)
			elseif key == "spring_week_match_levels" then
				value = parseItemList(value)
			elseif key == "summer_week_match_levels_2016" then
				value = parseItemList(value)
			elseif key == 'ingame_limit' then 
				value = parseIngameLimitDict(value)
			elseif key == 'ingame_limit_low' then 
				value = parseIngameLimitDict(value)
			elseif key == 'weekSurpassReward' then
				value = parseItemDict(value)
			elseif key == "weekWeeklyReward" then
				value = parseConditionRewardList(value)
			elseif key == "winterWeeklyReward" then
				value = parseConditionRewardList(value)
			elseif key == "firstNewObstacleLevels" then
				value = parseItemList(value)
			else
				value = tonumber(value)
			end

			if value == nil then print("GlobalServerConfig value should not be nil, key="..key) end
			self[key] = value

			if debugDataRef then
				print(key, value)
			end
		end		
	end
end
function GlobalServerConfig:getAddMarkPirce( addMarkNum )
	addMarkNum = addMarkNum or 0
	local price = self.fillSign[addMarkNum]
	if price == nil then return 0
	else return price end
end
--
-- MetaRef ---------------------------------------------------------
--
MetaRef = class()
function MetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil")
		return
	end

	for k,v in pairs(src) do
		if type(k) == "string" then
			self[k] = tonumber(v)
			if debugDataRef then print(k, v) end
		end
	end
end

--
-- DiggerMatchGemRewardMetaRef ---------------------------------------------------------
--
-- <diggerMatchGemReward id="1" gemCount="1" rewards="2:100"/> 
DiggerMatchGemRewardMetaRef = class(MetaRef)
function DiggerMatchGemRewardMetaRef:ctor()
	self.id = 0
	self.gemCount = 1
	self.rewards = {}
end
function DiggerMatchGemRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at DiggerMatchGemRewardMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "rewards" then
			self.rewards = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- GameModePropMetaRef ---------------------------------------------------------
--
-- <gamemode_prop id="1" gamemode="Classic moves" ingameProps="10001,10010,10002,10003,10005,10004" initProps="10018,10015,10007"/>  
GameModePropMetaRef = class(MetaRef)
function GameModePropMetaRef:ctor()
	self.id = 0
	self.gamemode = ""
	self.ingameProps = {}
	self.initProps = {}
end
function GameModePropMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at GameModePropMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "ingameProps" then
			self.ingameProps = parseItemList(v)
		elseif k == "initProps" then
			self.initProps = parseItemList(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- CoinBlockerMetaRef ---------------------------------------------------------
--
-- <coin_blocker id="1" coin_amount="50" level="91"/>   
CoinBlockerMetaRef = class(MetaRef)
function CoinBlockerMetaRef:ctor()
	self.id = 0
	self.coin_amount = 0
	self.level = 0
end

--
-- VipLevelMetaRef ---------------------------------------------------------
--
-- <vip_level id="0" vipExp="10"/>  
VipLevelMetaRef = class(MetaRef)
function VipLevelMetaRef:ctor()
	self.id = 0
	self.vipExp = 0
end

--
-- MarketPromotionMetaRef ---------------------------------------------------------
--
-- <market_promotion id="1" condition="1:999" contractId="12345678" rewards="2:100"/> 
MarketPromotionMetaRef = class(MetaRef)
function MarketPromotionMetaRef:ctor()
	self.id = 0
	self.condition = {}
	self.contractId = 0
	self.rewards = {}
end
function MarketPromotionMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at MarketPromotionMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "rewards" then
			self.rewards = parseItemDict(v)
		elseif k == "condition" then
			self.condition = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- FreegiftMetaRef ---------------------------------------------------------
--
-- <freegift id="1" item="2:300" topLevel="30"/>  
FreegiftMetaRef = class(MetaRef)
function FreegiftMetaRef:ctor()
	self.id = 0
	self.item = {}
	self.topLevel = 0
end
function FreegiftMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at FreegiftMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "item" then
			self.item = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- GoodsMetaRef ---------------------------------------------------------
--
-- <goods id="1" coin="0" discountQCash="0" fCash="99" items="10001:1" level="1" limit="0" on="1" point="0" qCash="39" sort="6"/>  
GoodsMetaRef = class(MetaRef)
function GoodsMetaRef:ctor()
	self.id = 0
	self.coin = 0
	self.discountQCash = 0
	self.fCash = 0
	self.items = {}
	self.level = 0
	self.limit = 0
	self.on = 0
	self.point = 0
	self.qCash = 0
	self.sort = 0
	self.fCash = 0
	self.discountFCash = 0
	self.sign = nil
	self.thirdRmb = 0
end
function GoodsMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at GoodsMetaRef:fromLua")
		return
	end

	local function parseTag(src)
		local tags  = src:split(',')
		local ret = {}
		for k, v in pairs(tags) do 
			table.insert(ret, tonumber(v))
		end
		return ret
	end

	for k,v in pairs(src) do
		if k == "items" then
			self.items = parseItemDict(v)
		elseif k == 'tag' then
			self.tag = parseTag(v)
		elseif k == "beginDate" then
			self.beginDate = tostring(v)
		elseif k == "endDate" then
			self.endDate = tostring(v)
		elseif k == "sign" then 
			self.sign = tostring(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end

	if __IOS_FB then -- facebook使用fCash字段
		self.qCash = self.fCash
		self.discountQCash = self.discountFCash
	end
end

function GoodsMetaRef:getCash()
	--current we use qCash
	if self.discountQCash > 0 then return self.discountQCash 
	else return self.qCash end
end

--static
function GoodsMetaRef:isSupplyEnergyGoods( goodsId )
	if goodsId == 23 or goodsId == 34 then return true
	else return false end
end

--
-- GoodsPayCodeMetaRef ---------------------------------------------------------
--
-- <goodsPayCode id="1" mmPayCode="30000807400101" uniPayCode="140121023049" miPayCode="com.xiaomi.xiaoxiaole.code1" price="3" />
GoodsPayCodeMetaRef = class(MetaRef)
function GoodsPayCodeMetaRef:ctor()
	self.id = 0
	self.props = ""
	self.mmPayCode = ""
	self.mmPayCode_two = ""
	self.mmPayCode_three = ""
	self.uniPayCode = ""
	self.miPayCode = ""
	self.ctPayCode = ""
	self.ctCustomPayCode = ""
	self.price = ""
end
function GoodsPayCodeMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at GoodsPayCodeMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "id" then
			self[k] = tonumber(v)
			if debugDataRef then print(k, v) end
		elseif type(k) == "string" then
			self[k] = tostring(v)
			if debugDataRef then print(k, v) end
		end
	end
end

--
-- LevelRewardMetaRef ---------------------------------------------------------
--
-- <level_reward id="2" failNum="3" failTips="2,3" levelId="2" oneStarDefaultReward="2:20" oneStarReward="2:300" threeStarDefaultReward="2:35" threeStarReward="2:300,4:3" twoStarDefaultReward="2:25" twoStarReward="2:300,4:2"/>  

LevelRewardMetaRef = class(MetaRef)
function LevelRewardMetaRef:ctor()
	self.id = 0
	self.failNum = 0
	self.failTips = 0
	self.levelId = 0
	self.oneStarDefaultReward = {}
	self.oneStarReward = {}
	self.threeStarDefaultReward = {}
	self.threeStarReward = {}
	self.twoStarDefaultReward = {}
	self.twoStarReward = {}
	self.fourStarReward = {}
	self.fourStarDefaultReward = {}

	self.newRewardItemsIndex = {}
	self.defaultRewardItemsIndex = {}
	self.skipLevel = 0    --跳关需要花费的金豆荚数
end
function LevelRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at LevelRewardMetaRef:fromLua")
		return
	end
	local dictItems = {oneStarReward=1, oneStarDefaultReward=1, twoStarReward=1, twoStarDefaultReward=1, threeStarReward=1, threeStarDefaultReward=1, fourStarReward=1,fourStarDefaultReward=1}
	for k,v in pairs(src) do
		if dictItems[k]~= nil then
			self[k] = parseItemDict(v)
		else 
			if k == "moneyTreeReward" then 
				self.moneyTreeReward = parseItemDict(v)
			elseif k == "failTips" then
				self.failTips = parseItemList(v)
			else
				if type(k) == "string" then
					self[k] = tonumber(v)
					if debugDataRef then print(k, v) end
				end
			end			
		end
	end

	self.newRewardItemsIndex[1] = self.oneStarReward
	self.newRewardItemsIndex[2] = self.twoStarReward
	self.newRewardItemsIndex[3] = self.threeStarReward
	self.newRewardItemsIndex[4] = self.fourStarReward

	self.defaultRewardItemsIndex[1] = self.oneStarDefaultReward
	self.defaultRewardItemsIndex[2] = self.twoStarDefaultReward
	self.defaultRewardItemsIndex[3] = self.threeStarDefaultReward
	self.defaultRewardItemsIndex[4] = self.fourStarDefaultReward
end
function LevelRewardMetaRef:getNewStarRewards( star )
	return self.newRewardItemsIndex[star]
end

function LevelRewardMetaRef:getDefaultStarRewards( star )
	return self.defaultRewardItemsIndex[star]
end

function LevelRewardMetaRef:getSkipLevelSpend( ... )
	-- body
	return self.skipLevel
end
--
-- InviteRewardMetaRef ---------------------------------------------------------
--
-- <invite_reward id="1" condition="0:1" rewards="2:500"/>  
InviteRewardMetaRef = class(MetaRef)
function InviteRewardMetaRef:ctor()
	self.id = 0
	self.condition = {}
	self.rewards = {}
end
function InviteRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at InviteRewardMetaRef:fromLua")
		return
	end

	for k,v in pairs(src) do
		if k == "condition" then
			self.condition = parseItemDict(v)
		elseif k == "rewards" then
			self.rewards = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- LevelMetaRef ---------------------------------------------------------
--
-- <level id="1" exp="10"/>  
LevelMetaRef = class(MetaRef)
function LevelMetaRef:ctor()
	self.id = 0
	self.exp = 0
end

--
-- QgameVipDailyRewardMetaRef ---------------------------------------------------------
--
-- <qq_game_vip_daily_reward id="1" reward="10012:2,2:1000" type="1" vipLevel="1"/>  

QgameVipDailyRewardMetaRef = class(MetaRef)
function QgameVipDailyRewardMetaRef:ctor()
	self.id = 0
	self.reward = {}
	self.type = 0
	self.vipLevel = 0
end
function QgameVipDailyRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at QgameVipDailyRewardMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "reward" then
			self.reward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- DecoMetaRef ---------------------------------------------------------
--
-- <deco id="20001" type="1"/> 
DecoMetaRef = class(MetaRef)
function DecoMetaRef:ctor()
	self.id = 0
	self.type = 0
end

--
-- LevelAreaMetaRef ---------------------------------------------------------
--
-- <level_area id="40001" maxLevel="15" minLevel="1" star="0"/>  
LevelAreaMetaRef = class(MetaRef)
function LevelAreaMetaRef:ctor()
	self.id = 0
	self.maxLevel = 0
	self.minLevel = 0
	self.star = 0
	self.unlockTaskLevelId = nil
end

--
-- FuncMetaRef ---------------------------------------------------------
--
-- <func id="30001" type="1"/>  
FuncMetaRef = class(MetaRef)
function FuncMetaRef:ctor()
	self.id = 0
	self.type = 0
end

--
-- FruitsMetaRef ---------------------------------------------------------
--
-- <fruits id="1" level="1" reward="2:1150,4:1" upgrade="100"/>  

FruitsMetaRef = class(MetaRef)
function FruitsMetaRef:ctor()
	self.id = 0
	self.level = 0
	self.reward = {}
	self.upgrade = 0
end
function FruitsMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at FruitsMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "reward" then
			self.reward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- MarkMetaRef ---------------------------------------------------------
--
-- <mark id="1" rewards="2:1000" type="1"/>  

MarkMetaRef = class(MetaRef)
function MarkMetaRef:ctor()
	self.id = 0
	self.rewards = {}
	self.type = 0
end
function MarkMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at MarkMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "rewards" then
			self.rewards = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- AchiMetaRef ---------------------------------------------------------
--
-- <achi id="1" type="3"/>  
AchiMetaRef = class(MetaRef)
function AchiMetaRef:ctor()
	self.id = 0
	self.type = 0
end

--
-- DiggerMatchRankRewardMetaRef ---------------------------------------------------------
--
-- <digger_match_rank_reward id="1" maxRange="1" minRange="1" rewards="2:100"/> 

DiggerMatchRankRewardMetaRef = class(MetaRef)
function DiggerMatchRankRewardMetaRef:ctor()
	self.id = 0
	self.maxRange = 0
	self.minRange = 0
	self.rewards = {}
end
function DiggerMatchRankRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at DiggerMatchRankRewardMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "rewards" then
			self.rewards = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- DiggerMatchGemRewardMetaRef ---------------------------------------------------------
--
-- <digger_match_gem_reward id="1" gemCount="1" rewards="2:100"/> 

--jDiggerMatchGemRewardMetaRef = class(DiggerMatchRankRewardMetaRef)
--jfunction DiggerMatchGemRewardMetaRef:ctor()
--j	self.id = 0
--j	self.gemCount = 0
--j	self.rewards = {}
--jend

--
-- FruitsUpgradeMetaRef ---------------------------------------------------------
--
-- <fruits_upgrade id="3" coin="120000" level="3" lock="false" pickCount="4" plus="50" upgradeCondition="2:2"/>  

FruitsUpgradeMetaRef = class(MetaRef)
function FruitsUpgradeMetaRef:ctor()
	self.id = 0
	self.coin = 0
	self.level = 0
	self.lock = false
	self.pickCount = 0
	self.plus = 0
	self.upgradeCondition = {}
end
function FruitsUpgradeMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at FruitsUpgradeMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "upgradeCondition" then
			self.upgradeCondition = parseItemDict(v)
		elseif k == "lock" then
			self.lock = (v == "true")
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end


--
-- QqVipDailyRewardMetaRef ---------------------------------------------------------
--
-- <qq_vip_daily_reward id="1" reward="10012:1,2:500" type="1" vipLevel="1"/>  

QqVipDailyRewardMetaRef = class(MetaRef)
function QqVipDailyRewardMetaRef:ctor()
	self.id = 0
	self.reward = {}
	self.type = 0
	self.vipLevel = 0
end
function QqVipDailyRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at QqVipDailyRewardMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "reward" then
			self.reward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- StarRewardMetaRef ---------------------------------------------------------
--
-- <star_reward id="1" reward="10013:2" starNum="24"/>  

StarRewardMetaRef = class(MetaRef)
function StarRewardMetaRef:ctor()
	self.id = 0
	self.reward = {}
	self.starNum = 0
	self.delta = 0
end
function StarRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at StarRewardMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "reward" then
			self.reward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- DiscountNotifyMetaRef ---------------------------------------------------------
--
-- <discount_notify id="1" conditions="1:3,2:2" goods="37:7" mode="2"/>  

DiscountNotifyMetaRef = class(MetaRef)
function DiscountNotifyMetaRef:ctor()
	self.id = 0
	self.conditions = {}
	self.goods = {}
	self.mode = 0
end
function DiscountNotifyMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at DiscountNotifyMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "conditions" then
			self.conditions = parseItemDict(v)
		elseif k == "goods" then
			self.goods = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- GiftBlockerMetaRef ---------------------------------------------------------
--
-- <gift_blocker id="5" level="10013" prop_id="10026,10025"/> 

GiftBlockerMetaRef = class(MetaRef)
function GiftBlockerMetaRef:ctor()
	self.id = 0
	self.prop_id = {}
	self.level = 0
end
function GiftBlockerMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at GiftBlockerMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "prop_id" then
			self.prop_id = parseItemList(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- HideAreaMetaRef ---------------------------------------------------------
--
-- <hide_area id="1" continueLevels="1-44" hideAreaId="0" hideLevelRange="1-3"/>  

HideAreaMetaRef = class(MetaRef)
function HideAreaMetaRef:ctor()
	self.id = 0
	self.continueLevels = {0,1}
	self.hideAreaId = 0
	self.hideLevelRange = {0,1}
	self.hideReward = {}
end
local function parseHideAreaLevel( src )
	if not src then return {} end
	assert(type(src) == "string")
	local content = src:split("-")
	local beginNum = tonumber(content[1])
	local endNum = tonumber(content[2])
	local result = {}
	for i = beginNum, endNum do
		table.insert(result, i)
	end
	return result
end 
function HideAreaMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at HideAreaMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "continueLevels" then
			self.continueLevels = parseHideAreaLevel(v)
		elseif k == "hideLevelRange" then
			self.hideLevelRange = parseHideAreaLevel(v)
		elseif k == "hideReward" then
			self.hideReward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- LadybugRewardMetaRef ---------------------------------------------------------
--
-- <ladybug_reward id="1" goalType="1:12" missionReward="2:3000,10013:2" timeLimit="24"/>  

LadybugRewardMetaRef = class(MetaRef)
function LadybugRewardMetaRef:ctor()
	self.id = 0
	self.goalType = {}
	self.missionReward = {}
	self.timeLimit = 0
end
function LadybugRewardMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at LadybugRewardMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "goalType" then
			self.goalType = parseItemDict(v)
		elseif k == "missionReward" then
			self.missionReward = parseItemDict(v)
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end


--
-- PropMetaRef ---------------------------------------------------------
--
-- <prop id="10004" confidence="0" maxUsetime="0" reward="1" sell="100" type="true" unlock="1" useable="false" value="5"/>  

PropMetaRef = class(MetaRef)
function PropMetaRef:ctor()
	self.id = 0
	self.confidence = 0
	self.maxUsetime = 0
	self.reward = 0
	self.sell = 0
	self.type = true
	self.unlock = 0
	self.useable = false
	self.value = 0
	self.expireTime = 0
end
function PropMetaRef:fromLua( src )
	if not src then
		print("  [WARNING] lua data is nil at PropMetaRef:fromLua")
		return
	end
	for k,v in pairs(src) do
		if k == "type" then
			self.type = (v == "true")
		elseif k == "useable" then
			self.useable = (v == "true")
		else 
			if type(k) == "string" then
				self[k] = tonumber(v)
				if debugDataRef then print(k, v) end
			end
		end
	end
end

--
-- ProductMetaRef ---------------------------------------------------------
--
-- <product id="1" cash="60" productId="com.happyelements.animal.gold.cn.1" discount="10"/>
ProductMetaRef = class(MetaRef)
function ProductMetaRef:ctor()
	self.id = 0
	self.cash = 0
	self.productId = ""
	self.show = true
	discount = 10
end
function ProductMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at ProductMetaRef:fromLua")
		return
	end

	for k, v in pairs(src) do
		if k == "productId" then
			self.productId = v
		elseif k == "show" then
			self.show = v == "1"
		elseif k == "tag" then
			self.tag = v
		else
			if type(k) == "string" then
				self[k] = tonumber(v)
			end
			if debugDataRef then print(k, v) end
		end
	end
end

MarketConfigRef = class(MetaRef)
function MarketConfigRef:ctor()
	self.goods = {}
	self.id = 0
	self.textKey = ''
end
function MarketConfigRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at MarketConfigRef:fromLua")
		return
	end

	for k, v in pairs(src) do
		if k == 'id' then
			self.id = tonumber(v)
		elseif k == 'textKey' then
			self.textKey = v
		elseif type(v) == 'table' then
			table.insert(self.goods, tonumber(v.id))
		end
	end
end

WeeklyRaceExchangeMetaRef = class(MetaRef)
function WeeklyRaceExchangeMetaRef:ctor()
end

function WeeklyRaceExchangeMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at MarketConfigRef:fromLua")
		return
	end

	local function parseDailyRewardBox(id, str)
		assert(str)
		local reward = {}
		local step1 = str:split("=")
		reward.id = id
		reward.needCount = tonumber(step1[1])
		reward.items = parseItemDict(step1[2])
		return reward
	end

	self.dailyRewardBoxes = {}
	for k, v in pairs(src) do 
		if k == 'id' then 
			self.id = tonumber(v)
		elseif k == 'coinExchangeReward' then
			self.coinExchangeReward = parseItemDict(v)
		elseif k == 'energyExchangeReward' then
			self.energyExchangeReward = parseItemDict(v)
		elseif k == 'surpassReward' then
			self.surpassReward = parseItemDict(v)
		elseif k == 'reward1' then
			self.dailyRewardBoxes[1] = parseDailyRewardBox(1, v)
		elseif k == 'reward2' then
			self.dailyRewardBoxes[2] = parseDailyRewardBox(2, v)
		elseif k == 'reward3' then
			self.dailyRewardBoxes[3] = parseDailyRewardBox(3, v)
		elseif k == 'reward4' then
			self.dailyRewardBoxes[4] = parseDailyRewardBox(4, v)
		else
			self[k] = tonumber(v)
		end
	end
end

WeeklyRaceDailyLimitMetaRef = class(MetaRef)
function WeeklyRaceDailyLimitMetaRef:ctor()
end

function WeeklyRaceDailyLimitMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at MarketConfigRef:fromLua")
		return
	end

	for k, v in pairs(src) do 
		self[k] = tonumber(v)
	end
end


WeeklyRaceGemRewardMetaRef = class(MetaRef)
function WeeklyRaceGemRewardMetaRef:ctor()
end

function WeeklyRaceGemRewardMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at MarketConfigRef:fromLua")
		return
	end

	for k, v in pairs(src) do 
		if k == 'id' then 
			self.id = tonumber(v)
		elseif k == 'reward1' then
			self.reward1 = parseItemDict(v)
		elseif k == 'reward2' then
			self.reward2 = parseItemDict(v)
		elseif k == 'reward3' then
			self.reward3 = parseItemDict(v)
		elseif k == 'reward4' then
			self.reward4 = parseItemDict(v)
		elseif k == 'reward5' then
			self.reward5 = parseItemDict(v)
		else
			self[k] = tonumber(v)
		end
	end
end

CnValentineMetaRef = class(MetaRef)
function CnValentineMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at MarketConfigRef:fromLua")
		return
	end

	for k, v in pairs(src) do
		if k == 'id' then
			self.id = tonumber(v)
		elseif k == 'num' then
			self.num = tonumber(v)
		elseif k == 'rewards' then
			self.rewards = parseItemDict(v)
		else 
			self[k] = v
		end
	end
end

ActivityRewardsMetaRef = class(MetaRef)
function ActivityRewardsMetaRef:fromLua(src)
	if not src then
		print("		[WARNING] lua data is nil at ActivityRewardsMetaRef:fromLua")
		return
	end

	for k, v in pairs(src) do
		if k == "rewards" then 
			self.rewards = parseItemDict(v) 
		else
			self[k] = v
		end
	end
end

RewardsRef = class(MetaRef)
function RewardsRef:fromLua(src)
	if not src then return end
	for k, v in pairs(src) do
		if k == "rewards" then
			self.rewards = parseItemDict(v)
		else self[k] = tonumber(v) end
	end
end

RewardsWithConditionRef = class(MetaRef)
function RewardsWithConditionRef:ctor()
	self.id = 0
	self.condition = 0
	self.items = {}
end

function RewardsWithConditionRef:fromLua(src)
	if type(src) == "string" then
		local vals = string.split(src, "=")
		local condition = 0
		local items = {}
		if #vals > 1 then
			condition = tonumber(vals[1])
			items = parseItemDict(vals[2])
		elseif #vals == 1 then
			items = parseItemDict(vals[1])
		end
		self.condition = condition
		self.items = items
	end
end

SummerWeeklyLevelRewardsRef = class(MetaRef)
function SummerWeeklyLevelRewardsRef:ctor()
	self.id = 0
	self.levelId = 0
	self.dailyRewards = {} 		-- 每日奖励list
	self.weeklyRewards = {}		-- 每周奖励
	self.rankRewards = {}		-- 排名奖励
	self.surpassRewards = {}	-- 每超越一名好友的奖励
	self.rankMinNum = 20		-- 进入排行榜的最低成绩
	self.surpassLimit = 200		-- 超越好友奖励最大奖励人数
end

function SummerWeeklyLevelRewardsRef:fromLua(src)
	local function parseDailyRewards(src)
		if type(src) ~= "string" then return {} end
		local ret = {}
		local dailyRewards = string.split(src, "|")
		if dailyRewards and #dailyRewards > 0 then
			for i, v in ipairs(dailyRewards) do
				ret[i] = parseConditionRewardList(v)
			end
		end
		-- print("dailyRewards:", tostring(ret))
		return ret
	end

	for k, v in pairs(src) do
		if k == 'id' then 
			self.id = tonumber(v)
		elseif k == "levelId" then	
			self.levelId = tonumber(v)
		elseif k == 'dailyReward' then
			self.dailyRewards = parseDailyRewards(v)
		elseif k == 'weeklyReward' then
			self.weeklyRewards = parseConditionRewardList(v)
		elseif k == 'rankReward' then
			self.rankRewards = parseConditionRewardList(v)
		elseif k == 'surpassReward' then
			self.surpassRewards = parseItemDict(v)
		elseif k == 'rankMinNum' then
			self.rankMinNum = tonumber(v)
		elseif k == 'surpassLimit' then
			self.surpassLimit = tonumber(v)
		else
			self[k] = tonumber(v)
		end
	end
end

AutumnWeeklyLevelRewardsRef = class(MetaRef)
function AutumnWeeklyLevelRewardsRef:ctor()
	self.id = 0
	self.day = 0
	self.dailyRewards = {} 		-- 每日奖励list
end

function AutumnWeeklyLevelRewardsRef:fromLua(src)
	for k, v in pairs(src) do
		if k == 'id' then 
			self.id = tonumber(v)
		elseif k == "day" then	
			self.day = tonumber(v)
		elseif k == 'dailyReward' then
			self.dailyRewards = parseConditionRewardList(v)
		end
	end
end

LevelStatusRef = class(MetaRef)

MissionRef = class(MetaRef)
function MissionRef:ctor()
	self.id = 0
	self.mType = 0
	self.cType = {}
	self.condition = {}
end

function MissionRef:fromLua(src)
	for k,v in pairs(src) do
		if k == "cType" then
			self.cType = string.split(v, ',')
			for i,v in ipairs(self.cType) do
				self.cType[i] = tonumber(v)
			end
		elseif k == "condition" then
			self.condition = string.split(v, ',')
			for i,v in ipairs(self.condition) do
				local values = string.split(v, ':')
				self.condition[i] = {}
				for j, w in ipairs(values) do
					table.insert(self.condition[i], tonumber(w))
				end
			end
		else
			self[k] = tonumber(v)
		end
	end
end

MissionCreateInfoRef = class(MetaRef)
function MissionCreateInfoRef:ctor()
	self.id = 0
	self.special = false
	self.weekly = 0
	self.daily = 0
	self.minLevel = 0
	self.maxLevel = 0
	self.priority = 0
	self.minLogin = 0
	self.maxLogin = 0
	self.maxReturn = 0
	self.maxSignIn = 0
end

function MissionCreateInfoRef:fromLua(src)
	for k,v in pairs(src) do
		if k == "special" then
			self.special = string.lower(v) == "true"
		else
			self[k] = tonumber(v) or 0
		end
	end
end