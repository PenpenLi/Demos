
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年10月23日 13:53:49
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com
--

assert(not ItemType)

ItemType = {
	INGAME_REFRESH 			= 10001, 
	INGAME_BACK    			= 10002,
	INGAME_SWAP    			= 10003,
	-- Add Step
	ADD_FIVE_STEP	        = 10004,
	INGAME_BRUSH 			=  10005,
	INITIAL_2_SPECIAL_EFFECT	= 10007,
	INGAME_HAMMER 			= 10010,
	INGREDIENT 			= 10011,
	-- Energy Bottle
	SMALL_ENERGY_BOTTLE	= 10012,
	MIDDLE_ENERGY_BOTTLE	= 10013,
	LARGE_ENERGY_BOTTLE	= 10014,
	ADD_THREE_STEP	= 10018,
	INFINITE_ENERGY_BOTTLE	= 10039,
	--兔兔导弹
	RABBIT_MISSILE = 10040,
	OCTOPUS_FORBID = 10052,
	RANDOM_BIRD    = 10055,
	BROOM 		   = 10056,
	RABBIT_WEEKLY_PLAY_CARD = 10054,

	TIMELIMIT_BACK 	= 10058,
	TIMELIMIT_REFRESH 	= 10059,
	TIMELIMIT_HAMMER 	= 10060,
	TIMELIMIT_BRUSH 	= 10061,
	TIMELIMIT_ADD_FIVE_STEP = 10062,
	TIMELIMIT_SWAP 	= 10063,
	TIMELIMIT_BROOM 	= 10064,

	-- Energy Lightning
	ENERGY_LIGHTNING	= 4,
	COIN			= 2,
	REOPEN_LADYBUG_TASK	= 8,
	GOLD			= 14,
	HOURGLASS 				= 10029,
	GEM 					= 10, -- dig gems
	MOONCAKE				= 11,
	MAYDAY_BOSS				= 12,
	HOLYCUP					= 11, -- 感恩节模式（活动不会同时存在，不存在冲突）
	THANKSGIVING_BOSS			= 12,
	WEEKLY_RABBIT     = 13,
	XMAS_BELL				= 11,
	XMAS_BOSS				= 12,
	-- 6  最终加5步
	-- 15 世界杯足球
	ADD_TIME			= 16, -- 最终加15秒

	KEY_GOLD            = 17,  ---解锁钥匙，临时展示用
	KWATER_MELON        =18,
	KELEPHANT           = 19

}

-- Pre Game Property Type, 
-- Each Type Go To Different Location When Game Start
PrePropType = {
	ADD_STEP		= 1,
	REDUCE_TARGET		= 2,
	TAKE_EFFECT_IN_BOARD	= 3,
	ADD_TO_BAR		= 4
}

ItemNotInBag = {
	[ItemType.RABBIT_WEEKLY_PLAY_CARD] = true
}

TimePropMap = {
	[ItemType.TIMELIMIT_BACK] = ItemType.INGAME_BACK,
	[ItemType.TIMELIMIT_REFRESH] = ItemType.INGAME_REFRESH,
	[ItemType.TIMELIMIT_HAMMER] = ItemType.INGAME_HAMMER,
	[ItemType.TIMELIMIT_BRUSH] = ItemType.INGAME_BRUSH,
	[ItemType.TIMELIMIT_ADD_FIVE_STEP] = ItemType.ADD_FIVE_STEP,
	[ItemType.TIMELIMIT_SWAP] = ItemType.INGAME_SWAP,
	[ItemType.TIMELIMIT_BROOM] = ItemType.BROOM,
}

function ItemType:getRealIdByTimePropId( propId )
	assert(type(propId) == "number")
	return TimePropMap[propId]
end

function ItemType:isTimeProp(propId)
	return ItemType:getRealIdByTimePropId(propId) ~= nil
end

function ItemType:isPrePropAddStep(itemType)

	if itemType == ItemType.ADD_FIVE_STEP or
		itemType == ItemType.ADD_THREE_STEP then

			return true
	end

	return false
end

function ItemType:isPrePropReduceTarget(itemType)

	return false
end

function ItemType:isPrePropTakeEffectInBoard(itemType)

	if itemType == ItemType.INITIAL_2_SPECIAL_EFFECT then
		return true
	end

	return false
end

function ItemType:isPrePropAddToBar(itemType)
	-- Note The Check Order In Function ItemType:getPrePropType
	return true
end

function ItemType:getPrePropType(itemType)

	if ItemType:isPrePropAddStep(itemType) then
		return PrePropType.ADD_STEP

	elseif ItemType:isPrePropReduceTarget(itemType) then
		return PrePropType.REDUCE_TARGET

	elseif ItemType:isPrePropTakeEffectInBoard(itemType) then
		return PrePropType.TAKE_EFFECT_IN_BOARD
	else

		return PrePropType.ADD_TO_BAR
	end
end

function ItemType:isItemNeedToBeAdd(itemId)
	local itemType = math.floor(itemId / 10000)
	-- print("itemType = ", itemType)
	if itemType ~= 1 then return false end -- 非道具
	if ItemNotInBag and ItemNotInBag[itemId] then -- 不需要加入背包
		return false
	end
	return true
end
