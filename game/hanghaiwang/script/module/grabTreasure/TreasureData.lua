-- Filename: TreasureData.lua
-- Author: lichenyang
-- Date: 2013-11-2
-- Purpose: 宝物数据处理层

module("TreasureData", package.seeall)
require "db/DB_Loot"
seizerInfoData = nil
nRobItemNum 	 = 0  	--夺宝指针的个数

local _nCanFuseNum = 0 -- zhangqi, 2015-09-30, 可合成的饰品数量


function getEnemyList( ... )
	return seizerInfoData.enemy_list
end


function getEnemyNum( ... )
	return table.count(seizerInfoData.enemy_list)
end


function clean( ... )
	dataCache = nil
end

function setRobItemNum()
	nRobItemNum =  ItemUtil.getCacheItemNumBy(60020)
end

--[[
	@des   	:得到碎片总数
	@param  :fragment_type  碎片类型。--1：名马 --2：名书 --3：名兵(暂无，预留) --4：珍宝(暂无，预留)
	@return	:碎片数量
]]
function getFragmentCount( fragment_type )
	require "db/DB_Item_treasure_fragment"
	if(seizerInfoData.frag == nil) then
		logger:debug("fragment server info is nil")
		return 0
	end
	local fragmentCount = 0
	for k,v in pairs(seizerInfoData.frag) do
		local fragmentInfo = DB_Item_treasure_fragment.getDataById(v.frag_id)
		if(tonumber(fragmentInfo.type) == tonumber(fragment_type)) then
			fragmentCount = fragmentCount + tonumber(v.frag_num)
		end
	end
	return fragmentCount
end

--[[
	@des   	:得到碎片数量
	@param  :fragment_tid  碎片模板id
	@return	:碎片数量
	modified: zhangqi, 2015-12-10, 在已有碎片情况下返回数量时同时返回 true, 表示已有这个碎片，
			  用于判断添加碎片是否是一个新碎片的补充条件
]]
function getFragmentNum( fragment_tid )
	if (not seizerInfoData.frag) then
		logger:debug("fragment server info is nil")
		return 0
	end
	for k,v in pairs(seizerInfoData.frag) do
		if(tonumber(v.frag_id ) == tonumber(fragment_tid)) then
			return tonumber(v.frag_num), true
		end
	end
	logger:debug("don't find fragment %s in cache data", tostring(fragment_tid));
	return 0
end

--[[
	@des   	:得到碎片详情
	@param  :fragment_tid  碎片模板id
	@return	:
	fragmentInfo:{	
		tid，
		desc,
		name,
		num
	}
]]
function getFragmentInfo( fragment_tid )
	logger:debug(fragment_tid)
	require "db/DB_Item_treasure_fragment"
	local fragmentInfo = {}

	local tableInfo = DB_Item_treasure_fragment.getDataById(fragment_tid)
	fragmentInfo.tid 		= fragment_tid
	fragmentInfo.desc		= tableInfo.info
	fragmentInfo.name		= tableInfo.name
	fragmentInfo.quality	= tableInfo.quality
	fragmentInfo.num		= getFragmentNum(fragment_tid)
	return fragmentInfo
end


--[[desc: 获取已经有的宝物
	arg1: 无返回值
	return: 
		{
			1 = { id1, id2, },
			2 = { id1, id2, },
			3 = { id1, id2, },
			4 = { id1, id2, },
			5 = { id1, id2, },
		}
—]]
function getTreasureList()

	require "db/DB_Item_treasure"
	local lootInfo = DB_Loot.getDataById(1)
	local tbAllTreaIDs = {}

	--基本宝物，没有碎片也要现实
	if (lootInfo.baseTreasures) then
		local baseTreasureIDs = lua_string_split(lootInfo.baseTreasures,",")
		for k,v in pairs(baseTreasureIDs) do
			local dbTrea = DB_Item_treasure.getDataById(v)
			if (tonumber(dbTrea.isExpTreasure) == 1) then -- 如果是经验宝物，类型为5
				table.insert(tbAllTreaIDs, tonumber(v))
			else
				local nType = tonumber(dbTrea.type) == 0 and 3 or tonumber(dbTrea.type)
				table.insert(tbAllTreaIDs, tonumber(v))
			end
		end
	end
	--碎片对应的宝物
	require "db/DB_Item_treasure_fragment"
	logger:debug(seizerInfoData)
	for k,v in pairs(seizerInfoData.frag) do
		if(tonumber(v.frag_num) >  0) then
			local dbTreaFrag = DB_Item_treasure_fragment.getDataById(v.frag_id)
			local nTreaID = tonumber(dbTreaFrag.treasureId)
			local isHave = false
			for i=1,#tbAllTreaIDs do
				if(tonumber(tbAllTreaIDs[i]) == nTreaID) then
					isHave = true
				end
			end
			if (not isHave) then
				local dbTrea = DB_Item_treasure.getDataById(nTreaID)
				if (tonumber(dbTrea.isExpTreasure) == 1) then -- 如果是经验宝物，类型为5
					table.insert(tbAllTreaIDs, nTreaID)
				else
					local nType = tonumber(dbTrea.type) == 0 and 3 or tonumber(dbTrea.type)
					table.insert(tbAllTreaIDs, nTreaID)
				end
			end
		end
	end
	return tbAllTreaIDs
end

--[[
	@des   	:通过宝物id得到宝物对应的碎片
	@param  :void
	@return	:
]]
function getTreasureFragments( treasure_id )
	require "db/DB_Item_treasure"
	local treasureInfo = DB_Item_treasure.getDataById(treasure_id)
	local fragmentIds  = lua_string_split(treasureInfo.fragment_ids,",") -- “,” 是对多个碎片的分隔符，不能随意改动
	return fragmentIds
end

-- zhangqi, 2015-09-30, 登录拉取夺宝信息后初始化
function setTreasFrag( dictRet )
	seizerInfoData = dictRet

	setCurGrabNum() -- 设置当前夺宝次数

	calcCanFuseNum() -- 计算碎片可合成的宝物数量
end

-- zhangqi, 2015-09-30, 根据宝物tid返回对应的宝物碎片tid和合成需要数量
function getCompondNum( treasId )
	require "db/DB_Item_treasure"
	local dbTrea = DB_Item_treasure.getDataById(treasId)
	local tbRet = string.strsplit(dbTrea.fragment_ids, "|")
	return tonumber(tbRet[2])
end

function getCompondNumByFragId( fragId )
	require "db/DB_Item_treasure_fragment"
	local dbFrag = DB_Item_treasure_fragment.getDataById(fragId)
	return tonumber(getCompondNum(dbFrag.treasureId))
end

-- zhangqi, 2015-09-30, 计算可合成的宝物数量
function calcCanFuseNum( ... )
	_nCanFuseNum = 0
	
	require "db/DB_Item_treasure_fragment"

	local nOwn, nNeed, dbFrag = 0, 0, nil
	for i, frag in ipairs(seizerInfoData.frag or {}) do
		dbFrag = DB_Item_treasure_fragment.getDataById(frag.frag_id)

		nOwn = tonumber(frag.frag_num)  -- 已有数量
		nNeed = getCompondNum(dbFrag.treasureId) -- 合成需要数量
		if (nOwn >= nNeed) then
			_nCanFuseNum = _nCanFuseNum + math.floor(nOwn/nNeed) -- 每个可堆叠的碎片实际可以兑换宝物的数量
		end
	end
	logger:debug({calcCanFuseNum_nCanFuseNum = _nCanFuseNum})
end

-- zhangqi, 2015-09-30, 返回所有饰品碎片可以合成的宝物数量
function getCanFuseNum( ... )
	return _nCanFuseNum
end

-- zhangqi, 2015-10-12，修改碎片信息
function setFrag( fragment_id, num )
	local fragmentNum, oldFrag = getFragmentNum(fragment_id)
	local bagHandler = BagModel.getBagHandler(BAG_TYPE_STR.treasFrag)

	if (oldFrag) then
		for k,v in pairs(seizerInfoData.frag) do
			if (tonumber(v.frag_id) == tonumber(fragment_id)) then
				seizerInfoData.frag[k].frag_num = num
				bagHandler:replaceItemByGid(v.frag_id, seizerInfoData.frag[k])
				break
			end
		end
	else
		local t = {}
		t.frag_id = fragment_id
		t.frag_num = num
		seizerInfoData.frag[#seizerInfoData.frag + 1] = t
		bagHandler:replaceItemByGid(fragment_id, t) -- 同步饰品碎片背包信息
	end

	-- logger:debug({seizerInfoData_frag = seizerInfoData.frag})

	calcCanFuseNum() -- 修改碎片数量后重新计算可合成的宝物数量

	-- zhangqi, 2015-10-21, 饰品碎片信息变化改为全局的通知
	GlobalNotify.postNotify(GlobalNotify.TREAS_FRAG_CHANGED)
end

--[[
	@des   	:修改当前拥有碎片的数量
	@param  :fragment_id 碎片id,num 碎片的变化量 正数增加 负数减少
	@return	:
]]
function addFragment( fragment_id, num )
	local fragNum = getFragmentNum(fragment_id) + tonumber(num)
	setFrag(fragment_id, fragNum)
end

robberInfo = nil
tbRobberInfo = nil   --经过解析后的robber信息
--[[
	@des   	:获取可抢夺用户信息
	@param  :
	@return	: 
	table :{	
	        (
            [level] => 等级
            [htid] => 1
            [uid] => 玩家的uid
            [percent] =>概率
            [utid] => 1
            [uname] => 名字
            [npc] => npc 类型
            [frag_num] => 碎片数量
            [squad] => Table  阵容
                (
                    [1] => 20002
                )
            [ratioDesc] => 极高概率
	        ),
	        ...
		}
	@author :zhz
]]
function getRobberList( )
	require "script/module/grabTreasure/TreasureUtil"
	logger:debug(tbRobberInfo)
	if(tbRobberInfo == nil) then
		logger:debug(robberInfo)
		tbRobberInfo = {}
		if(robberInfo == nil) then
			logger:debug(" Robberinfo is nil")
			return 0
		end
		for k,v in pairs(robberInfo) do
			-- 处理npc 的状态
			if(tonumber(v.npc)== 1) then
				local npcData = {}

				logger:debug(level)
				npcData = getNpcData(v.uid,1)
				npcData.ratioDesc= TreasureUtil.getFragmentPercentDesc(v.percent)
				npcData.npc= v.npc
				npcData.uid = v.uid

				logger:debug(npcData)
				table.insert(tbRobberInfo,npcData)
			else
				v.ratioDesc = TreasureUtil.getFragmentPercentDesc(v.percent)
				table.insert(tbRobberInfo, v)
			end
		end
		local function keySort ( robberData_1, robberData_2 )
			-- if(NewGuide.guideClass == ksGuideRobTreasure) then
			-- 	return tonumber(robberData_1.npc ) > tonumber(robberData_2.npc)
			-- else
			return tonumber(robberData_1.npc ) < tonumber(robberData_2.npc)
				-- end
		end
		table.sort( tbRobberInfo, keySort)

		return tbRobberInfo
	else
		--	不需要从网络断重新获取数据，直接返回
		return tbRobberInfo
	end
end

-- 获取npc的数据，将npc数据添加到 robberInfo中
function getNpcData( uid ,utid)
	require "db/DB_Army"
	require "db/DB_Team"
	require "db/DB_Monsters_tmpl"
	require "db/DB_Monsters"
	require "script/model/user/UserModel"
	require "script/module/arena/ArenaData"
	local npcData = {}
	math.randomseed(os.time())
	repeat
		npcData.level = UserModel.getHeroLevel() + math.random(-1,1)  -- DB_Army.getDataById(uid).display_lv
	until npcData.level <= UserModel.getUserMaxLevel()
	--npcData.uname  = ArenaData.getNpcName( tonumber(uid), tonumber(utid) )
	npcData.uname = DB_Army.getDataById(uid).display_name

	-- 获得阵容
	local monster_group= DB_Army.getDataById(uid).monster_group
	local monsterID = DB_Team.getDataById(monster_group).monsterID
	local monsterTable = lua_string_split(monsterID,",")
	local monsteRealTable = {}
	--
	for k,v in pairs(monsterTable) do
		if(tonumber(v)~= 0) then
			table.insert(monsteRealTable, v)
		end
	end
	-- 查找DB_Monsters表，找到对应的htid
	local monsterHtidTable = {}
	local hid = nil
	for i=1,#monsteRealTable do
		local htid = DB_Monsters.getDataById(monsteRealTable[i]).htid
		if(hid == nil)then
			hid = DB_Monsters.getDataById(monsteRealTable[i]).hid
		end
		table.insert(monsterHtidTable, htid)
	end
	logger:debug(monsterHtidTable)
	-- table.insert(npcData,monsterHtidTable)
	npcData.squad = monsterHtidTable
	--用来获取头像的时候用
	npcData.hid = hid

	return npcData
end

--[[
	@des   	:获取夺宝的耐力消耗
	@param  :
	@return	: int
]]
function getEndurance( )
	require "db/DB_Loot"
	local lootData = DB_Loot.getDataById(1)
	local endurance = lootData.costEndurance
	return endurance
end

--[[
	@des 	:得到宝物名称
]]
function getTreasureName( treasure_id )
	local treasureInfo 	= DB_Item_treasure.getDataById(treasure_id)
	return treasureInfo.name
end

----------------------------------------------------[[免战功能接口]]---------------------------------------------------------------------------

--[[
	@des:		得到免战消耗物品以及数量
	@return 	{
		{itemTid,num}
		...
	}
]]
function getShieldItemInfo( ... )
	local itemTable = {}

	require "db/DB_Loot"
	require "db/DB_Item_treasure"
	local lootInfo 		= DB_Loot.getDataById(1)
	local itemIdInfo 	= lua_string_split(lootInfo.shieldSpentItemId, ",")

	for k,v in pairs(itemIdInfo) do
		local itemInfo = lua_string_split(v,"|")
		local item = {}
		item.itemTid = 	itemInfo[1]
		item.num 	 =  itemInfo[2]
		table.insert(itemTable, item)
	end
	return itemTable
end


--[[
	@des:	得到金币免战话费数量
	@return number
]]
function getGlodByShieldTime( ... )
	require "db/DB_Loot"
	require "db/DB_Item_treasure"
	local lootInfo 		= DB_Loot.getDataById(1)
	return  tonumber(lootInfo.shieldSpentGold)
end

--[[
	@des:		得到单次免战时间
	@return:	返回hh:mm:ss这样的时间
]]
function getShieldTime( ... )
	require "db/DB_Loot"
	require "db/DB_Item_treasure"
	local lootInfo 		= DB_Loot.getDataById(1)
	require "script/utils/TimeUtil"
	return TimeUtil.getTimeDesByInterval(tonumber(lootInfo.shieldTime))
end

--[[
	@des:		得到全局免战时间戳
	@param:		void
	@return 	bTime 全局免战开启时间, eTime 全局免战结束时间
]]
function getGlobalShieldTime( ... )
	require "db/DB_Loot"
	require "db/DB_Item_treasure"
	local lootInfo 			= DB_Loot.getDataById(1)
	local globalShieldTime  = lua_string_split(lootInfo.allShieldTime, "|")
	local bOtime, eOtime	= TimeUtil.getSecondByTime(globalShieldTime[1]),TimeUtil.getSecondByTime(globalShieldTime[2])

	local serverTime 		= TimeUtil.getSvrTimeByOffset()
	local oh,om,os   		= TimeUtil.getLocalOffsetDate("%H",serverTime), TimeUtil.getLocalOffsetDate("%M",serverTime), TimeUtil.getLocalOffsetDate("%S",serverTime)
	local serverOriginTime 	= serverTime - tonumber(oh)*3600 - tonumber(om)*60 - tonumber(os)

	local bTime = serverOriginTime + bOtime
	local eTime = serverOriginTime + eOtime
	return bTime,eTime
end

--[[
	@des:		是否处于全局免战状态
	@return:	bool
]]
function isGlobalShieldState( ... )
	local nowTime 		= TimeUtil.getSvrTimeByOffset()
	local gBtime,gEtime = getGlobalShieldTime()
	return (nowTime > gBtime and nowTime < gEtime)
end

--[[
	@des: 		是否处于手动免战状态
	@return		bool
]]
function isShieldState( ... )
	local nowTime = TimeUtil.getSvrTimeByOffset()
	logger:debug("nowTime = %d, white_end_time = %d", nowTime, tonumber(seizerInfoData.white_end_time))
	return nowTime < tonumber(seizerInfoData.white_end_time)
end


--[[
	@des:		得到免战剩余时间
	@return:	time interval
]]
function getHaveShieldTime( ... )
	local endShieldTime = tonumber(seizerInfoData.white_end_time)
	if(endShieldTime == 0) then
		return 0
	else
		local havaTime = endShieldTime - TimeUtil.getSvrTimeByOffset()
		return havaTime > 0 and havaTime or 0
	end
end

--[[
	@des:增加免战时间
]]
function addShieldTime()
	require "db/DB_Loot"
	local lootInfo 	= DB_Loot.getDataById(1)
	local addTime = tonumber(lootInfo.shieldTime)
	if(tonumber(seizerInfoData.white_end_time) <= 0 or isShieldState() == false) then
		seizerInfoData.white_end_time = TimeUtil.getSvrTimeByOffset()
	else
		if(getHaveShieldTime() +  tonumber(lootInfo.shieldTime) > tonumber(lootInfo.shieldTimeLimit)) then
			addTime = tonumber(lootInfo.shieldTimeLimit) - getHaveShieldTime()
		end
	end

	seizerInfoData.white_end_time = tonumber(seizerInfoData.white_end_time) + addTime
	logger:debug("seizerInfoData.white_end_time = " .. seizerInfoData.white_end_time)
end


--[[
	@des:获得全局免战的起止时间
	return: 开始时间 和结束时间 如：00:00 10:00
]]
function getShieldStartAndEndTime( ... )
	require "db/DB_Loot"
	local lootInfo 			= DB_Loot.getDataById(1)
	local globalShieldTime  = lua_string_split(lootInfo.allShieldTime, "|")

	local startTime = lua_string_split(globalShieldTime[1], ":")
	local endTime = lua_string_split(globalShieldTime[2],":")
	return startTime[1]..":"..startTime[2], endTime[1]..":"..endTime[2]
end

--[[
	@des: 清除免战状态
]]
function clearShieldTime( ... )
	seizerInfoData.white_end_time  = 0
end


--[[
	@des:	计算使用免战后增加的时间
]]
function getUsingShieldAddTime( ... )
	require "db/DB_Loot"
	require "db/DB_Item_treasure"
	local lootInfo 		= DB_Loot.getDataById(1)

	local addTime = tonumber(lootInfo.shieldTime)
	if(getHaveShieldTime() +  tonumber(lootInfo.shieldTime) > tonumber(lootInfo.shieldTimeLimit)) then
		addTime = tonumber(lootInfo.shieldTimeLimit) - getHaveShieldTime()
	end
	require "script/utils/TimeUtil"
	return TimeUtil.getTimeDesByInterval(addTime)
end

--[[
	@des   	:获取夺宝次数上限
	@param  :
	@return	: int
]]
function getGrabMaxNum( ... )

	local lootData = DB_Loot.getDataById(1)
	local grabTimes = tonumber(lootData.dayNum)
	return grabTimes
end

--获取夺宝次数
function getSeizeNum()
	return  seizerInfoData.buy_seize_num
end

--获取夺宝次数已经购买的次数
function getbuySeizeNum()
	return  seizerInfoData.buy_seize_num
end

--设置夺宝次数的购买次数
function setbuySeizeNum()
	seizerInfoData.buy_seize_num = seizerInfoData.buy_seize_num + 1
end

--获取今天总共抢夺了多少次
function getSeizeNum()
	return  seizerInfoData.seized_num or 0
end

--设置今天总共抢夺了多少次
function setSeizeNum()
	seizerInfoData.seized_num = seizerInfoData.seized_num + 1
end

function getSeizeNumStr( ... )
	setCurGrabNum()
	local maxNum = getGrabMaxNum()
	local curNum = seizerInfoData.curSeizeNum
	return curNum .. "/" .. maxNum
end

--设置当前的夺宝个数
function setCurGrabNum()
	-- 每天的次数 + 购买的次数*每天的次数-已经抢夺的次数
	local timeEveryDay = tonumber(getGrabMaxNum())
	--已经抢夺的次数
	local timesRobed = tonumber(TreasureData.seizerInfoData.seized_num or 0)
	--已经购买的次数
	local timesBought = tonumber(TreasureData.seizerInfoData.buy_seize_num or 0)
	logger:debug("每天的次数:%s | 已经抢夺的次数:%s | 已经购买的次数%s:" ,timeEveryDay,timesRobed,timesBought)
	seizerInfoData.curSeizeNum = timeEveryDay + timeEveryDay * timesBought - timesRobed

end
