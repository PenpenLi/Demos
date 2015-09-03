require "hecore.class"
require "zoo.model.LuaXml"
require "zoo.data.DataRef"
require "zoo.data.MetaRef"

local debugMetaData = false

local instance = nil
MetaManager = {
}

function MetaManager.getInstance()
	if not instance then instance = MetaManager end
	return instance
end

local function parseItemDict(metaXML, childName, cls )
	local result = {}
	
	local xmlList = xml.find(metaXML, childName)
	for i,v in ipairs(xmlList) do
		local p = cls.new()
		p:fromLua(v)
		result[p.id] = p
	end
	return result
end 

function MetaManager:initialize()
	--local path = "meta/meta_client.xml"
	--path = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
	--local metaXML = xml.load(path)
	local path = "meta/meta_client.inf"
	if __IOS_FB then  -- TW facebook
	 	path = "meta/fb_meta_client.inf"
	end
	path = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
	local meta_client = HeFileUtils:decodeFile(path)
	local metaXML = xml.eval(meta_client)
	
	assert(metaXML, "meta_client is nil")

	local confList = xml.find(metaXML, "global")
	local conf = GlobalServerConfig.new()
	conf:fromLua(confList)
	self.global = conf

	if __IOS_FB then
		self.gamemode_prop = parseItemDict(metaXML, "gamemode_prop", GameModePropMetaRef)
		self.coin_blocker = parseItemDict(metaXML, "coin_blocker", CoinBlockerMetaRef)
		self.freegift = parseItemDict(metaXML, "freegift", FreegiftMetaRef)
		self.goods = parseItemDict(metaXML, "goods", GoodsMetaRef)
		self.prop = parseItemDict(metaXML, "prop", PropMetaRef)
		self.level_reward = parseItemDict(metaXML, "level_reward", LevelRewardMetaRef)
		self.invite_reward = parseItemDict(metaXML, "invite_reward", InviteRewardMetaRef)
		self.mark = parseItemDict(metaXML, "mark", MarkMetaRef)
		self.hide_area = parseItemDict(metaXML, "hide_area", HideAreaMetaRef)
		self.deco = parseItemDict(metaXML, "deco", DecoMetaRef)
		self.level_area = parseItemDict(metaXML, "level_area", LevelAreaMetaRef)
		self.func = parseItemDict(metaXML, "func", FuncMetaRef)
		self.ladybug_reward = parseItemDict(metaXML, "ladybug_reward", LadybugRewardMetaRef)
		self.star_reward = parseItemDict(metaXML, "star_reward", StarRewardMetaRef)
		self.product = parseItemDict(metaXML, "product", ProductMetaRef)
		self.gift_blocker = parseItemDict(metaXML, "gift_blocker", GiftBlockerMetaRef)
	else
		self.gamemode_prop = parseItemDict(metaXML, "gamemode_prop", GameModePropMetaRef)
		self.coin_blocker = parseItemDict(metaXML, "coin_blocker", CoinBlockerMetaRef)
		self.vip_level = parseItemDict(metaXML, "vip_level", VipLevelMetaRef)
		--self.market_promotion = parseItemDict(metaXML, "market_promotion", MarketPromotionMetaRef)
		self.freegift = parseItemDict(metaXML, "freegift", FreegiftMetaRef)
		self.goods = parseItemDict(metaXML, "goods", GoodsMetaRef)
		self.level_reward = parseItemDict(metaXML, "level_reward", LevelRewardMetaRef)
		self.invite_reward = parseItemDict(metaXML, "invite_reward", InviteRewardMetaRef)
		self.level = parseItemDict(metaXML, "level", LevelMetaRef)
		self.qq_game_vip_daily_reward = parseItemDict(metaXML, "qq_game_vip_daily_reward", QgameVipDailyRewardMetaRef)
		self.deco = parseItemDict(metaXML, "deco", DecoMetaRef)
		self.level_area = parseItemDict(metaXML, "level_area", LevelAreaMetaRef)
		self.func = parseItemDict(metaXML, "func", FuncMetaRef)
		self.fruits = parseItemDict(metaXML, "fruits", FruitsMetaRef)
		self.mark = parseItemDict(metaXML, "mark", MarkMetaRef)
		self.achi = parseItemDict(metaXML, "achi", AchiMetaRef)
		self.digger_match_rank_reward = parseItemDict(metaXML, "digger_match_rank_reward", DiggerMatchRankRewardMetaRef)
		self.digger_match_gem_reward = parseItemDict(metaXML, "digger_match_gem_reward", DiggerMatchGemRewardMetaRef)
		self.fruits_upgrade = parseItemDict(metaXML, "fruits_upgrade", FruitsUpgradeMetaRef)
		self.qq_vip_daily_reward = parseItemDict(metaXML, "qq_vip_daily_reward", QqVipDailyRewardMetaRef)
		self.star_reward = parseItemDict(metaXML, "star_reward", StarRewardMetaRef)
		self.discount_notify = parseItemDict(metaXML, "discount_notify", DiscountNotifyMetaRef)
		self.gift_blocker = parseItemDict(metaXML, "gift_blocker", GiftBlockerMetaRef)
		self.hide_area = parseItemDict(metaXML, "hide_area", HideAreaMetaRef)
		self.ladybug_reward = parseItemDict(metaXML, "ladybug_reward", LadybugRewardMetaRef)
		self.prop = parseItemDict(metaXML, "prop", PropMetaRef)
		self.product = parseItemDict(metaXML, "product", ProductMetaRef)
		self.product_android = parseItemDict(metaXML, "product_android", ProductMetaRef)
		self.goodsPayCode = parseItemDict(metaXML, "goods_pay_code", GoodsPayCodeMetaRef)
		-- self.market_config = parseItemDict(metaXML, "market_config", MarketConfigRef)
		self.weekly_race_exchange = parseItemDict(metaXML, 'weekly_race_exchange', WeeklyRaceExchangeMetaRef)
		self.weekly_race_daily_limit = parseItemDict(metaXML, 'weekly_race_daily_limit', WeeklyRaceDailyLimitMetaRef)
		self.weekly_race_gem_reward = parseItemDict(metaXML, 'weekly_race_gem_reward', WeeklyRaceGemRewardMetaRef)
		self.cn_valentine = parseItemDict(metaXML, 'cn_valentine', CnValentineMetaRef)

		self.activity_rewards = parseItemDict(metaXML,'activity_rewards',ActivityRewardsMetaRef)
		self.rewards = parseItemDict(metaXML, "rewards", RewardsRef)
		self.summerWeeklyRewards = parseItemDict(metaXML,'summer_week_match',SummerWeeklyLevelRewardsRef)

		self.level_status = parseItemDict(metaXML, "level_status", LevelStatusRef)
		
	end
	if __WP8 then
		self.product_wp8 = {
			{id = 1, rmb = 600, cash = 60, discount = 10, productId = "", mmPaycode="30000827625109"},
			{id = 2, rmb = 1200, cash = 125, discount = 10, productId = "", mmPaycode="30000827625110"},
			{id = 3, rmb = 2800, cash = 300, discount = 10, productId = "", mmPaycode="30000827625111"},
			{id = 4, rmb = 12800, cash = 1388, discount = 10, productId = ""},
			--{id = 5, rmb = 1, cash = 10, discount = 10, productId = ""},
		}
	end
end

function MetaManager:inviteReward_getInviteRewardMetaById(id, ...)
	assert(type(id) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.invite_reward) do

		if v.id == id then
			return v
		end
	end

	return false
end

function MetaManager:ladybugReward_getLadyBugRewardMeta(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.ladybug_reward) do
		if v.id == taskId then
			return v
		end
	end

	return false
end

function MetaManager:starReward_getRewardLevel(starNum, ...)
	assert(type(starNum) == "number")
	assert(#{...} == 0)


	local nearestLevel	= false

	for k,v in ipairs(self.star_reward) do

		if starNum >= v.starNum then

			if not nearestLevel or
				nearestLevel.starNum < v.starNum then
				nearestLevel = v
			end
		end
	end

	return nearestLevel
end

function MetaManager:starReward_getNextRewardLevel(starNum, ...)
	assert(type(starNum) == "number")
	assert(#{...} == 0)


	local nextNearestLevel	= false

	for k,v in ipairs(self.star_reward) do

		if starNum < v.starNum then

			if not nextNearestLevel or
				nextNearestLevel.starNum > v.starNum then
				nextNearestLevel = v
			end
		end
	end

	return nextNearestLevel
end

function MetaManager:starReward_getStarRewardMetaById(id, ...)
	assert(type(id) == "number")
	assert(#{...} == 0)

	for k,v in ipairs(self.star_reward) do

		assert(type(v.id) == "number")
		if v.id == id then
			return v
		end
	end

	return false
end

function MetaManager:isMinLevelAreaId( levelId )
	for i,v in pairs(self.level_area) do
		if v.minLevel == levelId then return true end
	end
	return false
end
function MetaManager:getLevelAreaById( levelId )
	return self.level_area[levelId]
end
function MetaManager:getCoinBlockersByLevelId( levelId )
	return self.coin_blocker[levelId]
end
function MetaManager:getPropMeta(propId)
	return self.prop[propId]
end
function MetaManager:getGoodMeta(goodId) 
	return self.goods[goodId]
end
function MetaManager:getGoodPayCodeMeta(goodId)
	return self.goodsPayCode[goodId]
end
function MetaManager:getProductAndroidMeta(goodId)
	return self.product_android[goodId]
end
function MetaManager:getGoodMetaByItemID( itemId )
	for k,v in pairs(self.goods) do
		--RewardItemRef
		if #v.items == 1 and v.items[1].itemId == itemId then
			return v
		end
	end
	return nil
end

function MetaManager:getLevelRewardByLevelId( levelId )
	for k,v in pairs(self.level_reward) do
		if v.levelId == levelId then return v end
	end
	return nil
	--return self.level_reward[levelId]
end
function MetaManager:getMarkByNum( markNum )
	return self.mark[markNum]
end
function MetaManager:getGameModePropByModeId( gameMode )
	return self.gamemode_prop[gameMode]
end

function MetaManager:getLevelAreaRefByLevelId(levelId, ...)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	for k,v in pairs(self.level_area) do

		if tonumber(v.minLevel) <= levelId and
			levelId <= tonumber(v.maxLevel) then
			return v
		end
	end

	return nil
end

function MetaManager:getNextLevelAreaRefByLevelId(levelId, ...)
	assert(#{...} == 0)

	local curLevelArea	= self:getLevelAreaRefByLevelId(levelId)
	local nextLevelArea	= false

	if curLevelArea then
		local curLevelAreaMaxLevel	= tonumber(curLevelArea.maxLevel)
		local nextLevelAreaMinLevel	= curLevelAreaMaxLevel + 1
		nextLevelArea = self:getLevelAreaRefByLevelId(nextLevelAreaMinLevel)
	end

	return nextLevelArea
end

function MetaManager:getMaxNormalLevelByLevelArea()
	local maxLevel = 0
	for k, v in pairs(self.level_area) do
		if v.maxLevel > maxLevel and v.maxLevel < 999 then
			maxLevel = v.maxLevel
		end
	end
	return maxLevel
end

function MetaManager:getTaskLevelId(areaId)
	for k, v in pairs(self.level_area) do 
		if tonumber(areaId) == tonumber(v.id) then 
			return v.unlockTaskLevelId
		end
	end
end

function MetaManager:isTaskCanUnlockLevalArea(areaId)
	if self:getTaskLevelId(areaId) then 
		return true
	else
		return false
	end
end

function MetaManager:getAreaIdByTaskLevelId(taskLevelId)
	for k, v in pairs(self.level_area) do 
		if v.unlockTaskLevelId and v.unlockTaskLevelId == taskLevelId then 
			return v.id 
		end
	end
end

function MetaManager:getHideAreaLevelIds()
	local hideAreaLevelIds = {}
	local HIDE_LEVEL_ID_START = 10000
	for k,hideArea in pairs(self.hide_area) do
		local hideLevels = hideArea.hideLevelRange
		for i,v in ipairs(hideLevels) do
			table.insert(hideAreaLevelIds, HIDE_LEVEL_ID_START + v)
		end		
	end

	local function levelIdSorter(pre, next)
		return pre < next
	end

	table.sort(hideAreaLevelIds, levelIdSorter)
	
	return hideAreaLevelIds
end

function MetaManager:getHideAreaByHideLevelId(levelId)
	levelId = levelId - LevelMapManager.getInstance().hiddenNodeRange
	for k, hideArea in pairs(self.hide_area) do
		local hideLevels = hideArea.hideLevelRange
		for i, v in ipairs(hideLevels) do
			if v == levelId then
				return hideArea
			end
		end		
	end
	return nil
end

function MetaManager:getGiftBlockerByLevelId(levelId)
	if self.gift_blocker then
		for k, v in pairs(self.gift_blocker) do
			if v.level == levelId then
				return v
			end
		end
	end
	
	return nil
end

function MetaManager:getEnterInviteCodeReward()
	return self.global.enter_invite_code_reward
end

function MetaManager:getInitBagSize()
	return self.global.initBagSize
end

function MetaManager:getBagCapacity()
	return self.global.bag_capacity
end

function MetaManager:getProductMetaByID( id )
	for k, v in pairs(self.product) do
		if v.id == id then
			return v
		end
	end
	
	return nil
end

function MetaManager:getDailyMaxSendGiftCount()
	return self.global.daily_max_send_gift_count
end

function MetaManager:getDailyMaxReceiveGiftCount()
	return self.global.daily_max_receive_gift_count
end

function MetaManager:getFreegift(topLevel)
	local res
	print("topLevel", topLevel)
	if self.freegift and #self.freegift > 0 then
		res = self.freegift[1]
	else
		return nil
	end
	for k, v in ipairs(self.freegift) do
		if topLevel < v.topLevel then
			print("v.topLevel", v.topLevel)
			return res.item[1]
		else
			print("v.topLevel", v.topLevel)
			res = v
		end
	end
end

function MetaManager:getNewUserRewards()
	if PlatformConfig:isBaiduPlatform() then
		return self.global.new_user_reward_baidu
	else
		return self.global.new_user_reward_normal
	end
end

function MetaManager:getMarketConfig()
	return self.market_config
end

function MetaManager:getFruitGrowCycle()
	return self.global.fruit_grow_cycle
end

function MetaManager:getCrowCountNum()
	return self.global.fruit_crow_count_num
end

function MetaManager:getInviteFriendCount()
	return self.global.invite_friends_count
end