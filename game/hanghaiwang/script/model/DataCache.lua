-- Filename：	DataCache.lua
-- Author：		Cheng Liang
-- Date：		2013-6-21
-- Purpose：		数据中心


module ("DataCache", package.seeall)
require "script/utils/LuaUtil"
require "script/module/bag/BagUtil"
require "db/DB_Vip"
require "db/DB_Formation"
local _curWorldCache	= nil	-- 当前所在世界地图

local _normalCopyCache 	= nil	-- 普通副本
local _eliteCopyCache 	= nil	-- 精英副本
local _activeCopyCache 	= nil	-- 活动副本

local _formationInfo 	= nil	-- 阵型

local _bagInfo 			= nil	-- 背包
local _squadInfo 		= nil	-- 阵容
local _littleFInfo      = {}   -- 小伙伴
local _benchInfo      = nil   -- 小伙伴

local _starCache 		= nil	-- 名仕

local _shopCache 		= nil	-- 商店信息

local _switchCache 		= nil	-- 功能节点开启信息

local _newNormalCopyId 	= nil 	-- 新开启的副本

local _destinyCurInfo   = nil   -- 当前主角天命中的修炼信息

local _norSignCurInfo   = nil   -- 当前主角签到信息

local _exploreInfo   	= nil   -- 探索信息

local _activityCopyInfo =nil    --活动副本信息

local _adventureData	=nil 	--奇遇数据

local _heroBook		 	= {} 	--曾经拥有的伙伴信息

local _guildCopyInfo    =nil    --公会副本数据

local _guildCopyBaseInfo = nil   --公会副本相关的基本数据

local _isInBattleStatus  = false  --liweidong 记录当前是否在战斗中 

local _isInBattleStatus  = false  --liweidong 记录当前是否在战斗中 

local _tbFightForceCache = {} -- 战斗力缓存

local _tbSkypieaCache = {} -- zhangjunwu  2015-8-18 爬塔数据缓冲

local mBagInfoCache = nil -- 背包二次整理缓冲数据


-- 获取战斗力缓存
function setFightForceInfoInfo( FightForceCache )
	_tbFightForceCache = FightForceCache
end

function getFightForceInfo( ... )
	return _tbFightForceCache
end

-------------------------------------- 每日签到 -------------------------------------

function getExploreInfo( ... )
	return _exploreInfo
end

function setExploreInfo(  exploreInfo )
	_exploreInfo = exploreInfo
	logger:debug("explor data info =====")
	logger:debug(exploreInfo)
	-- require "script/module/copy/ExplorData"
	-- ExplorData.afterExplortion(0)

end
--公会副本数据
function getGuildCopyData()
	return _guildCopyInfo
end
function setGuildCopyData(dataInfo)
	_guildCopyInfo = dataInfo
	logger:debug("_guildCopyInfo data info =====")
	logger:debug(dataInfo)

end
--返回战斗状态 liweidong
-- 战斗模块本身也有是否在战斗中的状态，但由于服务器处理战斗响应比较慢，期间可能其他推送返回（如被踢出公会推送），导致界面跳转，等战斗后加后更新界面引起报错
function getInBattleStatus()
	return _isInBattleStatus
end
--设置战斗状态
function setInBattleStatus(status)
	_isInBattleStatus = status
end
--返回公会副本相关的基本数据
function getGuildCopyBaseData()
	if (_guildCopyBaseInfo==nil) then
		_guildCopyBaseInfo={}
		_guildCopyBaseInfo.atked_num=0
		_guildCopyBaseInfo.buy_atk_num=0
		_guildCopyBaseInfo.jump_num=0
		_guildCopyBaseInfo.jump_switch=0
		_guildCopyBaseInfo.distribute_num=0
	end
	-- logger:debug("_guildCopyBaseInfo data info =====")
	-- logger:debug(_guildCopyBaseInfo)
	return _guildCopyBaseInfo
end
--设置公会副本相关的基本数据的 个人相关数据
function setGuildMemberBaseData(ret)
	local data = getGuildCopyBaseData()
	data.atked_num = ret.atked_num and ret.atked_num or 0
	data.buy_atk_num = ret.buy_atk_num and ret.buy_atk_num or 0
	data.jump_num = ret.jump_num and ret.jump_num or 0
	-- logger:debug(_guildCopyBaseInfo)
end
--设置公会副本相关的基本数据的 公会相关数据
function setGuildCopyBaseData(ret)
	local data = getGuildCopyBaseData()
	data.jump_switch = ret.jump_switch and ret.jump_switch or 0
	data.distribute_num = ret.distribute_num and ret.distribute_num or 0
	-- logger:debug(_guildCopyBaseInfo)
end
--活动副本数据
function getActiviyCopyInfo( ... )
	return _activityCopyInfo
end

function setActiviyCopyInfo(  copyInfo )
	_activityCopyInfo = copyInfo
	logger:debug("activity copy data info =====")
	logger:debug(copyInfo)
end

-- 获取当前主角签到信息  add by  lizy  2014.8.8
function getNorSignCurInfo( ... )
	return _norSignCurInfo
end

-- 设置当前主角签到信息 add by  lizy  2014.8.8
function setNorSignCurInfo( norSignCurInfo )
	_norSignCurInfo = norSignCurInfo
	if _norSignCurInfo.va_normalsign.rewarded == nil then
		_norSignCurInfo.reward_num = 0 .. ""
	else
		if (#(_norSignCurInfo.va_normalsign.rewarded) == 0) then
			_norSignCurInfo.reward_num = 0 .. ""
		else
			_norSignCurInfo.reward_num = "" .. #(_norSignCurInfo.va_normalsign.rewarded)
		end

	end

end

-------------------------------------- 天命 -------------------------------------
-- 获取当前主角天命中的修炼信息  add by  lizy  2014.8.7
function getDestinyCurInfo( ... )
	return _destinyCurInfo
end

-- 设置当前主角天命中的修炼信息 add by  lizy  2014.8.7
function setDestinyCurInfo( destinyCurInfo )
	_destinyCurInfo = destinyCurInfo

end


-------------------------------------- 副本 -------------------------------------
-- 获得新开起的副本
function getNewNormalCopyId()
	return _newNormalCopyId
end
-- 设置新开启的副本
function setNewNormalCopyId(newNormalCopyId)
	_newNormalCopyId = newNormalCopyId
end

-- 普通副本
function getNormalCopyData( )

	-- local data = {}
	-- if (not table.isEmpty(_normalCopyCache)) then
	-- 	local copyList = _normalCopyCache.copy_list
	-- 	local function keySort ( key_1, key_2 )
	-- 	   	return tonumber(key_1) < tonumber(key_2)
	-- 	end
	-- 	local allKeys = table.allKeys(copyList)
	-- 	table.sort( allKeys, keySort )
	-- 	require "db/DB_Copy"
	-- 	for k,keyIndex in pairs(allKeys) do
	-- 		local tbl = copyList[keyIndex]
	-- 		tbl.copyInfo = DB_Copy.getDataById(tbl.copy_id)
	-- 		table.insert(data, tbl)
	-- 	end

	-- 	local copy_len = table.count(data)
	-- 	if(copy_len<CopyUtil.getMaxCopyId())then
	-- 		print("copy_len<CopyUtil.getMaxCopyId()====", copy_len, CopyUtil.getMaxCopyId())
	-- 		local tbl = {}
	-- 		tbl.uid = UserModel.getUserUid()
	-- 		tbl.copy_id = copy_len + 1
	-- 		tbl.score = 0
	-- 		tbl.prized_num = 0
	-- 		tbl.isGray = true
	-- 		tbl.va_copy_info = {}
	-- 		tbl.va_copy_info.progress = {}
	-- 		tbl.va_copy_info.defeat_num = {}
	-- 		tbl.va_copy_info.reset_num = {}
	-- 		tbl.copyInfo = DB_Copy.getDataById(tbl.copy_id)

	-- 		table.insert(data, tbl)
	-- 	end
	-- end

	return _normalCopyCache
end

--------------------------------------------------
function setNormalCopyData( normalCopyData )
	logger:debug("copy list info========>>>")
	logger:debug(normalCopyData)
	logger:debug("copy list info========<<<")
	_normalCopyCache = normalCopyData
	if(normalCopyData.sweep_cd)then
		require "script/utils/TimeUtil"
		_normalCopyCache.sweep_cool_time = tonumber(TimeUtil.getSvrTimeByOffset())+tonumber(normalCopyData.sweep_cd)
	end
	if(normalCopyData.clear_sweep_num)then
		_normalCopyCache.clear_sweep_num = tonumber(normalCopyData.clear_sweep_num)
	end
end

-- 获取副本扫荡的cd时间
function getSweepCoolTime()
	return _normalCopyCache.sweep_cool_time
end
-- 设置副本扫荡的cd时间
function setSweepCoolTime( cd_time)
	require "script/utils/TimeUtil"
	_normalCopyCache.sweep_cool_time = TimeUtil.getSvrTimeByOffset()+tonumber(cd_time)
end

-- 获取清除副本扫荡的次数
function getClearSweepNum()
	return tonumber(_normalCopyCache.clear_sweep_num)
end
-- 设置清除副本扫荡的次数
function setClearSweepNum( times )
	_normalCopyCache.clear_sweep_num = tonumber(times)
end

-- 只拿出副本信息
function setNormalCopyList( copyList )
	_normalCopyCache.copy_list = copyList
end

function getReomteNormalCopyData()
	local copy_list = {}
	if(not table.isEmpty(_normalCopyCache))then
		copy_list = _normalCopyCache.copy_list
	end
	return copy_list
end
-- 修改副本的宝箱状态
function changeCopyBoxStatus( copy_id, prized_num )
	for k, copy_info in pairs(_normalCopyCache.copy_list) do
		if(tonumber(copy_info.copy_id) == tonumber(copy_id))then
			_normalCopyCache.copy_list[k].prized_num = "" .. prized_num
			break
		end
	end
end
--觉醒副本
function setAwakeCopyData(data)
	logger:debug("_awakeCopyCache =======")
	logger:debug(data)
	_awakeCopyCache = data
end
function getAwakeCopyData()
	return _awakeCopyCache
end
-- 精英副本
function getEliteCopyData( )
	return _eliteCopyCache
end

function setEliteCopyData( eliteCopyData )
	_eliteCopyCache = eliteCopyData
end
-- 减少精英副本的攻打次数
function addCanDefatNum(num)
	_eliteCopyCache.can_defeat_num = (_eliteCopyCache.can_defeat_num or 0) + num
end
--通关该精英本同时显示下一个精英本
function updateEliteData( curEliteId,nextEliteId,curStatus,nextStatus )
	if (_eliteCopyCache.va_copy_info) then
		if(_eliteCopyCache.va_copy_info.progress) then
			local progress = _eliteCopyCache.va_copy_info.progress
			progress[tostring(curEliteId)] = "" .. curStatus
			progress[tostring(nextEliteId)] = "" .. nextStatus
		end
	end
end
--显示当前精英本
function openCurEliteData( nextEliteId,curStatus )
	if(_eliteCopyCache) then
		if (_eliteCopyCache.va_copy_info) then
			if(_eliteCopyCache.va_copy_info.progress) then
				local progress = _eliteCopyCache.va_copy_info.progress
				progress[tostring(nextEliteId)] = "" .. curStatus
			end
		end
	end
end

-- 活动副本
function getActiveCopyData()
	local data = {}
	if (_activeCopyCache) then

		local function keySort ( key_1, key_2 )
			return tonumber(key_1) < tonumber(key_2)
		end
		local allKeys = table.allKeys(_activeCopyCache)
		table.sort( allKeys, keySort )
		require "db/DB_Activitycopy"
		for k,keyIndex in pairs(allKeys) do
			local tbl = _activeCopyCache[keyIndex]
			tbl.copyInfo = DB_Activitycopy.getDataById(tbl.copy_id)
			table.insert(data, tbl)
		end
	end
	return data
end
function setActiveCopyData( activeCopyData )
	_activeCopyCache = activeCopyData
end

-- 获得摇钱树活动的剩余次数
function getGoldTreeDefeatNum()
	local defautNum = 0
	if((not table.isEmpty(_activeCopyCache)) )then
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300001 )then
				defautNum = tonumber(v.can_defeat_num)
				break
			end
		end
	end

	return defautNum
end

-- 修改摇钱树活动的剩余次数
function addGoldTreeDefeatNum( add_times )
	add_times = tonumber(add_times) or 0
	if( (not table.isEmpty(_activeCopyCache)) )then
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300001 )then
				_activeCopyCache[copy_id].can_defeat_num = tonumber(_activeCopyCache[copy_id].can_defeat_num) + add_times
				break
			end
		end
	end
end

-- 修改经验宝物活动的剩余次数
function addTreasureExpDefeatNum( add_times )
	add_times = tonumber(add_times) or 0
	if( (not table.isEmpty(_activeCopyCache)) )then
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300002 )then
				_activeCopyCache[copy_id].can_defeat_num = tonumber(_activeCopyCache[copy_id].can_defeat_num) + add_times
				break
			end
		end
	end
end

-- 获得经验宝物活动的剩余次数
function getTreasureExpDefeatNum()
	local defautNum = 0
	if( (not table.isEmpty(_activeCopyCache)) )then
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300002 )then
				defautNum = tonumber(_activeCopyCache[copy_id].can_defeat_num)
				break
			end
		end
	end

	return defautNum
end

-- 获得摇钱树活动的金币挑战的次数
function getAtkGoldTreeByUseGoldNum()
	local defautNum = 0
	if((not table.isEmpty(_activeCopyCache)) )then
		print("***********")
		print_t(_activeCopyCache)
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300001 )then
				defautNum = tonumber(v.va_copy_info.gold_atk_num)
				break
			end
		end
	end
	return defautNum
end

-- 修改摇钱树活动的金币挑战次数
function addAtkGoldTreeByUseGoldNum( add_times )
	add_times = tonumber(add_times) or 0
	if( (not table.isEmpty(_activeCopyCache)) )then
		for copy_id,v in pairs(_activeCopyCache) do
			if(tonumber(copy_id) == 300001 )then
				_activeCopyCache[copy_id].va_copy_info.gold_atk_num = tonumber(_activeCopyCache[copy_id].va_copy_info.gold_atk_num) + add_times
				break
			end
		end
	end
end


-- 修改普通副本某个据点的剩余攻打次数
function addDefeatNumByCopyAndFort( copy_id, fort_id, add_times,copyDifficulty)
	local defeatNUm = _normalCopyCache.copy_list["" .. copy_id].va_copy_info.baselv_info["" .. fort_id][""..copyDifficulty].can_atk_num
	if (not defeatNUm) then
		local baseItemInfo = DB_Stronghold.getDataById(fort_id)
		local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
		defeatNUm = tonumber(fightTimes[copyDifficulty])
	end
	logger:debug("copy_id = %s, fort_id = %s, add_times = %s, defeat_Num = %s", tostring(copy_id), tostring(fort_id), tostring(add_times), tostring(defeatNUm))
	local canDefeat = (tonumber(defeatNUm) or 0) + tonumber(add_times)
	canDefeat = canDefeat > 0 and canDefeat or 0
	_normalCopyCache.copy_list["" .. copy_id].va_copy_info.baselv_info["" .. fort_id][""..copyDifficulty].can_atk_num = canDefeat
end

-- 获得摸个据点重置攻打次数所需金币
function getResetDefeatNumGoldBy( copy_id, fort_id)
	local costGold = 20
	if( not table.isEmpty(_normalCopyCache.copy_list["" .. copy_id]) and not table.isEmpty(_normalCopyCache.copy_list["" .. copy_id].va_copy_info))then
		if(_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id])then
			costGold = (tonumber(_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id]) ) *10 + 20
		end
	end

	return costGold
end

-- 修改某个据点重置次数
function addRestDefeatNumTimes( copy_id, fort_id, add_times )
	add_times = tonumber(add_times)
	if(table.isEmpty(_normalCopyCache.copy_list["" .. copy_id]))then
		_normalCopyCache.copy_list["" .. copy_id] = {}
	end
	if(table.isEmpty(_normalCopyCache.copy_list["" .. copy_id].va_copy_info))then
		_normalCopyCache.copy_list["" .. copy_id].va_copy_info = {}
	end
	if(table.isEmpty(_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num))then
		_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num = {}
	end
	if(_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id] == nil)then
		_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id] = "0"
	end
	_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id] = "" .. (tonumber(_normalCopyCache.copy_list["" .. copy_id].va_copy_info.reset_num["" .. fort_id]) + add_times)
end

-- 获得精英副本的剩余次数
function getEliteCopyLeftNum()
	local l_num = 0
	if(_eliteCopyCache and _eliteCopyCache.can_defeat_num)then
		l_num = tonumber(_eliteCopyCache.can_defeat_num)
	end
	return l_num
end

-- 获得活动副本的剩余次数
function getActiveCopyLeftNum()
	local l_num = 0
	l_num = getGoldTreeDefeatNum() + getTreasureExpDefeatNum()
	return l_num
end


-------------------------------------- 阵型和阵容 -------------------------------------
-- 阵型信息
function getFormationInfo()
	return _formationInfo
end
function setFormationInfo( formationData )
	--不能直接设置阵型了。
	_formationInfo = formationData
end

function fnSetShopMysteryTime()
	local _shopInfo 		= getShopCache()
	local dbVipInfo 		= DB_Vip.getDataById(UserModel.getVipLevel())
	local bOpenSwitch 		= SwitchModel.getSwitchOpenState(ksSwitchMysteryShop)
	logger:debug(dbVipInfo.mystical_tavern)
	logger:debug(bOpenSwitch)
	logger:debug(_shopInfo)
	if(_shopInfo and tonumber(_shopInfo.mystery_recruit_time) == 0 and bOpenSwitch and tonumber(dbVipInfo.mystical_tavern) == 1)then
		
		function shopInfoCallback( cbFlag, dictData, bRet )
			setShopCache(dictData.ret)
			MainScene.updateShopTip()
		end
		RequestCenter.shop_getShopInfo(shopInfoCallback, nil)
	end
end

function onLevelUp( ... )
	logger:debug("onLevelUp")

	require "script/model/user/UserModel"
	local userLevel = UserModel.getHeroLevel() 		--当前主角的等级
	--判断神秘招募的逻辑
	logger:debug("fnSetShopMysteryTime")
	fnSetShopMysteryTime()


	local litHeroOpenPos = 0

	local openFriendByLv = DB_Formation.getDataById(1).openFriendByLv
	local splitOpenFriend = lua_string_split(openFriendByLv, ",")

	for i,v in ipairs(splitOpenFriend) do
		local openLv = lua_string_split(v ,"|")[1]
		if(tonumber(userLevel) >= tonumber(openLv)) then
			local openPos = lua_string_split(v , "|")[2]
			if(tonumber(openPos)>tonumber(litHeroOpenPos)) then
				litHeroOpenPos = openPos
			end
		end
	end

	logger:debug(_littleFInfo)
	logger:debug("litHeroOpenPos:".. litHeroOpenPos)
	logger:debug(_littleFInfo[tonumber(litHeroOpenPos)])

	if tonumber(litHeroOpenPos) > 0 then
		local litFriPos = _littleFInfo[tonumber(litHeroOpenPos)]

		logger:debug("litFriPos:".. litFriPos)
		if tonumber(litFriPos) == -1 then
			_littleFInfo[tonumber(litHeroOpenPos)] = "0"
		end
	end

	logger:debug(_littleFInfo)
end

--注册等级升级时的操作
function regLevelUpCallBack( ... )
	GlobalNotify.addObserver(GlobalNotify.LEVEL_UP, onLevelUp, nil, "regLevelUpCallBack")
	logger:debug("regLevelUpCallBack")
end

-- vip等级提升的操作
function onVipLevelUp(  )
	VipGiftModel.setVipUp( true )
	VipGiftModel.setWeekRedPointTrue( true )
end

--注册vip等级提升时的操作
function regVipLevelUpCallBack(  )
	GlobalNotify.addObserver(GlobalNotify.VIP_LEVEL_UP, onVipLevelUp, nil, "regVipLevelUpCallBack")
	logger:debug("regVipLevelUpCallBack")
end

-- 阵容信息
function getSquad()
	return _squadInfo
end
function setSquad( squadData )
	_squadInfo = squadData
end
--小伙伴信息
function getExtra()
	return _littleFInfo
end
function setExtra(extraData)
	_littleFInfo = extraData
end
--替补信息
function getBench()
	return _benchInfo
end
function setBench(benchData)
	_benchInfo = benchData
end

-- 判断一个武将是否在阵上
function isHeroBusy(hid)
	local pHid = tonumber(hid) or nil
	if(not pHid) then
		return false
	end
	local isBusy = false

	if (_formationInfo ~= nil) then
		for k, v in pairs(_formationInfo) do
			if (tonumber(v) == pHid) then
				isBusy=true
				break
			end
		end
	end
	if(isBusy == false)then
		for k, v in pairs(_littleFInfo or {}) do
			if (tonumber(v) == pHid) then
				isBusy=true
				break
			end
		end
	end
	if(not isBusy) then
		for k, v in pairs(_benchInfo or {}) do
			if (tonumber(v) == pHid) then
				isBusy=true
				break
			end
		end
	end

	return isBusy
end


-------------------------------------- 背包 -------------------------------------
-- 背包
function getRemoteBagInfo(  )
	return _bagInfo
end

-- zhangqi, 2014-08-02, 常规背包信息的二次整理结果，每次背包信息发生变动才会更新
function getBagInfo( ... ) -- 重定义 getBagInfo，直接返回缓存结果，避免原来每次计算的耗时
	assert(mBagInfoCache, "mBagInfoCache 背包信息为nil")
	return mBagInfoCache
end

-- zhangqi, 2014-12-22, 删除道具物品的新增标志
function clearNewFlagOfItem( ... )
	logger:debug("clearNewFlagOfItem")
	if (mBagInfoCache) then
		logger:debug("clearNewFlagOfItem-mBagInfoCache")
		for i, item in ipairs(mBagInfoCache.props) do
			logger:debug(item)
			item.newOrder = nil
		end
		logger:debug(mBagInfoCache.props)
	end
end

-- zhangqi, 2014-08-02, 将三国的 getBagInfo 改为 getLocalBagInfo
-- 只在背包信息发生改变时被内部调用，避免外部模块每次调用时产生的计算耗时
function getLocalBagInfo()
	logger:debug("DataCache.getBagInfo")
	local temp_bag_info = nil

	-- 处理
	if(_bagInfo)then
		temp_bag_info = {}
		-- 处理装备
		require "db/DB_Item_arm"
		local temp_arm = {}
		if(not table.isEmpty(_bagInfo.arm))then
			for g_id, s_arm in pairs(_bagInfo.arm) do
				local tempItem = {}
				tempItem = s_arm
				tempItem.gid = g_id
				tempItem.itemDesc = DB_Item_arm.getDataById(s_arm.item_template_id)
				tempItem.itemDesc.desc = tempItem.itemDesc.info
				table.insert(temp_arm, tempItem)
			end
			--table.sort( temp_arm, BagUtil.equipSort )
		end
		temp_bag_info.arm = temp_arm

		-- 处理装备碎片
		local temp_armFrag = {}
		if(not table.isEmpty(_bagInfo.armFrag))then
			for g_id, s_armFrag in pairs(_bagInfo.armFrag) do
				local tempItem = {}
				tempItem = s_armFrag
				tempItem.gid = g_id
				tempItem.itemDesc =  ItemUtil.getItemById(s_armFrag.item_template_id)
				tempItem.itemDesc.desc = tempItem.itemDesc.info
				table.insert(temp_armFrag, tempItem)
			end
			--table.sort( temp_armFrag, BagUtil.propsSort )
		end
		temp_bag_info.armFrag = temp_armFrag

		-- 处理空岛贝, 2015-02-25, zhangqi
		require "db/DB_Item_conch"
		local temp_conch = {}
		if(not table.isEmpty(_bagInfo.conch))then
			for g_id, s_conch in pairs(_bagInfo.conch) do
				local tempItem = {}
				tempItem = s_conch
				tempItem.gid = g_id
				tempItem.itemDesc = DB_Item_conch.getDataById(s_conch.item_template_id)
				tempItem.itemDesc.desc = tempItem.itemDesc.info
				table.insert(temp_conch, tempItem)
			end
		end
		temp_bag_info.conch = temp_conch
		-- logger:debug({DataCache_temp_bag_info_conch = temp_bag_info.conch})

		-- 处理道具
		local temp_props = {}
		if(not table.isEmpty(_bagInfo.props))then
			for g_id, s_item in pairs(_bagInfo.props) do
				local i_id = tonumber( s_item.item_template_id)
				local tempItem = {}
				tempItem = s_item
				tempItem.gid = g_id
				tempItem.itemDesc = ItemUtil.getItemById(i_id) -- zhangqi, 2014-04-23, 直接使用类也用ItemUtil.getItemById获取有问题么？
				if(i_id >= 10001 and i_id <= 20000) then
					tempItem.isDirectUse = true		-- 可以直接使用
				end
				-- if(i_id >= 10001 and i_id <= 20000) then
				-- 	-- 直接使用类：
				-- 	require "db/DB_Item_direct"
				-- 	tempItem.itemDesc = DB_Item_direct.getDataById(i_id)
				-- 	tempItem.isDirectUse = true		-- 可以直接使用
				-- else
				-- 	tempItem.itemDesc = ItemUtil.getItemById(i_id)
				-- end

				table.insert(temp_props,tempItem )
			end
			--table.sort( temp_props, BagUtil.propsSort )
		end
		temp_bag_info.props = temp_props

		-- 宝物
		local temp_treas = {}
		if(not table.isEmpty(_bagInfo.treas))then
			for g_id, s_trea in pairs(_bagInfo.treas) do
				local tempItem = {}
				tempItem = s_trea
				tempItem.gid = g_id
				tempItem.itemDesc = ItemUtil.getItemById(s_trea.item_template_id)
				table.insert(temp_treas, tempItem)
			end
			--table.sort( temp_treas, BagUtil.treasSort )
		end
		temp_bag_info.treas = temp_treas

		-- 专属宝物
		local temp_excl = {}
		if(not table.isEmpty(_bagInfo.excl))then
			for g_id, s_excl in pairs(_bagInfo.excl) do
				local tempItem = {}
				tempItem = s_excl
				tempItem.gid = g_id
				tempItem.itemDesc = ItemUtil.getItemById(s_excl.item_template_id)
				table.insert(temp_excl, tempItem)
			end
			--table.sort( temp_excl, BagUtil.treasSort )
		end
		temp_bag_info.excl = temp_excl
		-- 专属宝物碎片
		local temp_s_exclFrag = {}
		if(not table.isEmpty(_bagInfo.exclFrag))then
			for g_id, s_exclFrag in pairs(_bagInfo.exclFrag) do
				local tempItem = {}
				tempItem = s_exclFrag
				tempItem.gid = g_id
				tempItem.itemDesc = ItemUtil.getItemById(s_exclFrag.item_template_id)
				table.insert(temp_s_exclFrag, tempItem)
			end
		end
		temp_bag_info.exclFrag = temp_s_exclFrag
		-- 觉醒道具
		local temp_awake = {}
		if(not table.isEmpty(_bagInfo.awake))then
			for g_id, s_awake in pairs(_bagInfo.awake) do
				local tempItem = {}
				tempItem = s_awake
				tempItem.gid = g_id
				tempItem.itemDesc = ItemUtil.getItemById(s_awake.item_template_id)
				table.insert(temp_awake, tempItem)
			end
		end
		temp_bag_info.awake = temp_awake
		-- 时装
		-- local temp_dress = {}
		-- if(not table.isEmpty(_bagInfo.dress))then
		-- 	for g_id, s_dress in pairs(_bagInfo.dress) do
		-- 		local tempItem = {}
		-- 		tempItem = s_dress
		-- 		tempItem.gid = g_id
		-- 		tempItem.itemDesc = ItemUtil.getItemById(s_dress.item_template_id)
		-- 		table.insert(temp_dress, tempItem)
		-- 	end
		-- end
		-- temp_bag_info.dress = temp_dress
	end
	return temp_bag_info
end

function setBagInfo( bagData )
	assert(bagData,"bagData 背包信息为nil")
	-- logger:debug("bagInfo begin================:")
	-- logger:debug(bagData)
	-- logger:debug("bagInfo end================:")
	_bagInfo = bagData
	mBagInfoCache = getLocalBagInfo() -- zhangqi, 2014-08-02, 每次背包信息发生变动才会更新

	GlobalNotify.postNotify(GlobalNotify.BAG_CHANGED) -- zhangqi, 2015-09-29, 发送背包变化的通知
end

-- 根据item_id 重置装备属性信息
function resetArmInfoByItemID( item_id )
	item_id = tonumber(item_id)
	if(not table.isEmpty(_bagInfo.arm))then
		for g_id, s_arm in pairs(_bagInfo.arm) do
			if(tonumber(s_arm.item_id) == item_id)then
				print("_bagInfo信息")
				print_t(_bagInfo.arm)
				_bagInfo.arm[g_id].va_item_text.armReinforceLevel = "0"
				_bagInfo.arm[g_id].va_item_text.armReinforceCost = "0"
				_bagInfo.arm[g_id].va_item_text.armPotence = nil

				break
			end
		end
	end
end


-- 根据itemID重置宝物属性信息
function resetTreasureInfoByItemID( item_id )
	item_id = tonumber(item_id)
	if not table.isEmpty(_bagInfo.treas) then
		for g_id,s_arm in pairs(_bagInfo.treas) do
			if tonumber(s_arm.item_id) == item_id then
				_bagInfo.treas[g_id].va_item_text.treasureEvolve = "0"
				_bagInfo.treas[g_id].va_item_text.treasureExp = "0"
				_bagInfo.treas[g_id].va_item_text.treasureLevel = "0"
				break
			end
		end
	end
end


-- 修改开启格子的个数
function addGidNumBy( t_type, addNum )
	if(t_type == 1) then
		_bagInfo.gridMaxNum.arm = "" .. (tonumber(_bagInfo.gridMaxNum.arm) + addNum)
	elseif(t_type == 2) then
		_bagInfo.gridMaxNum.props = "" .. (tonumber(_bagInfo.gridMaxNum.props) + addNum)
	elseif(t_type == 3) then
		_bagInfo.gridMaxNum.treas = "" .. (tonumber(_bagInfo.gridMaxNum.treas) + addNum)
	elseif(t_type == 4) then
		_bagInfo.gridMaxNum.armFrag = "" .. (tonumber(_bagInfo.gridMaxNum.armFrag) + addNum)
	elseif(t_type == 5) then
		-- _bagInfo.gridMaxNum.dress = "" .. (tonumber(_bagInfo.gridMaxNum.dress) + addNum)
		_bagInfo.gridMaxNum.excl = "" .. (tonumber(_bagInfo.gridMaxNum.excl) + addNum)
	elseif(t_type == 6) then
		_bagInfo.gridMaxNum.exclFrag = "" .. (tonumber(_bagInfo.gridMaxNum.exclFrag) + addNum)
	elseif (t_type == 7) then	-- 觉醒背包
		_bagInfo.gridMaxNum.awake = "" .. (tonumber(_bagInfo.gridMaxNum.awake) + addNum)
	end
end

-- 修改装备的强化等级
function changeArmReinforceBy( item_id, addLv )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then
			local level = tonumber(arm_info.va_item_text.armReinforceLevel) + addLv
			_bagInfo.arm[g_id].va_item_text.armReinforceLevel = "" .. level
			isInBag = true
			break
		end
	end
	if( isInBag == false)then
	-- TODO 英雄身上
	end
end

-- 修改装备的强化等级
function setArmReinforceLevelBy( item_id, curLv )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then
			_bagInfo.arm[g_id].va_item_text.armReinforceLevel = "" .. curLv
			isInBag = true
			break
		end
	end
end
-- 修改装备的附魔等级
function setArmEnchantLevelBy( item_id, curLv )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then

			_bagInfo.arm[g_id].va_item_text.armEnchantLevel = "" .. curLv
			isInBag = true
			break
		end
	end
	return isInBag
end
-- 修改装备的附魔经验
function setArmEnchantExpBy( item_id, curExp )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then
			_bagInfo.arm[g_id].va_item_text.armEnchantExp = "" .. curExp
			isInBag = true
			break
		end
	end
end

-- 修改装备的强化费用
function setArmReinforceLevelCostBy( item_id, curCost )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then
			_bagInfo.arm[g_id].va_item_text.armReinforceCost = "" .. curCost
			isInBag = true
			break
		end
	end
end

-- 修改装备的强化费用
function changeArmReinforceCostBy( item_id, addCost )
	local isInBag = false
	for g_id, arm_info  in pairs(_bagInfo.arm) do
		if ( arm_info.item_id == "" .. item_id ) then
			if(_bagInfo.arm[g_id].va_item_text.armReinforceCost)then
				_bagInfo.arm[g_id].va_item_text.armReinforceCost = tostring(tonumber(arm_info.va_item_text.armReinforceCost) + addCost)
			else
				_bagInfo.arm[g_id].va_item_text.armReinforceCost = "" .. addCost
			end
			isInBag = true
			break
		end
	end
	if( isInBag == false)then
	-- TODO 英雄身上
	end
end

-- 修改宝物强化等级
function changeTreasReinforceBy( item_id, addLv, totalExp )
	local isInBag = false
	for g_id, treas_info  in pairs(_bagInfo.treas) do
		if ( treas_info.item_id == "" .. item_id ) then
			local level = tonumber(treas_info.va_item_text.treasureLevel) + addLv
			_bagInfo.treas[g_id].va_item_text.treasureLevel = "" .. level
			_bagInfo.treas[g_id].va_item_text.treasureExp = totalExp
			isInBag = true
			break
		end
	end
	if( isInBag == false)then
	-- TODO 英雄身上
	end
end

-- 从背包中获得武魂数据
-- added by fang. 2013.08.08
function getHeroFragFromBag()
	if not _bagInfo then
		return nil
	end
	return _bagInfo.heroFrag
end
-- 在背包中删除gid对应的武魂数据（在招募后该武将对应的武魂数据为0）
-- added by fang. 2013.08.08
function delHeroFragOfGid(gid)
	_bagInfo.heroFrag[tostring(gid)] = nil
end
-- 在招募后减少背包gid对应的武魂数据
-- added by fang. 2013.08.08
function setHeroFragItemNumOfGid(gid, item_num)
	_bagInfo.heroFrag[tostring(gid)].item_num = item_num
end

-- 通过模板id后的武魂数量(如果没有返回0 )
-- added by zhz ,2013.10.5
function getHeroFragNumByItemTmpid( item_template_id )
	local fragNum = 0
	-- if(table.isEmpty(_bagInfo.heroFrag)) then
	-- 	return 0
	-- end
	for k ,v in pairs(_bagInfo.heroFrag) do
		if(tonumber(v.item_template_id) == tonumber(item_template_id)) then
			fragNum = fragNum + tonumber(v.item_num)
		end
	end
	return fragNum
end


-- 通过模板id后的武魂数量(如果没有返回0 )
-- added by zhz ,2013.10.5
function getEquipFragNumByItemTmpid( item_template_id )
	local fragNum = 0
	-- if(table.isEmpty(_bagInfo.heroFrag)) then
	-- 	return 0
	-- end
	for k ,v in pairs(_bagInfo.armFrag) do
		if(tonumber(v.item_template_id) == tonumber(item_template_id)) then
			fragNum = fragNum + tonumber(v.item_num)
		end
	end
	return fragNum
end


function getAllHerofragByTid( ... )
	local _tbHerofragsById = {}  --  -- sunyunoeng 2015-8-24 影子列表数据，根据tid分组，算出每组的总和
	-- 深度复制表
	function deepcopy(object)
	    local lookup_table = {}
	    if object == nil then
	        return nil
	    end
	    
	    local function _copy(object)
	        if type(object) ~= "table" then
	            return object
	        elseif lookup_table[object] then
	            return lookup_table[object]
	        end  -- if
	        local new_table = {}
	        lookup_table[object] = new_table
	        for index, value in pairs(object) do
	            new_table[_copy(index)] = _copy(value)
	        end  -- for
	        return setmetatable(new_table, getmetatable(object))
	    end  -- function _copy
	    return _copy(object)
	end  -- function deepcopy


	local function sortFrags( leftFragItems )
		local itemNum = table.count(leftFragItems)
		local reset = false
 		local indexnum = 0
 		local tempGid 
 		local tempHeroFrag 
 		local leftNums = 0 

		if (itemNum == 0) then
			return
		end
		local leftItems = {}
		for k, v in pairs(leftFragItems) do
			if (not reset) then
				reset = true
				tempGid = k
				tempHeroFrag = v
				_tbHerofragsById[tempGid] =  tempHeroFrag
			end
            if tonumber(tempHeroFrag.item_template_id) == tonumber(v.item_template_id) then
            	if (tempGid ~= k) then
                	_tbHerofragsById[tempGid].item_num = _tbHerofragsById[tempGid].item_num +  tonumber(v.item_num)
                end
            else
                leftNums = leftNums + 1
            	leftItems[k] = v
            end
            indexnum = indexnum + 1
            if (indexnum == itemNum) then
            	reset = false
            end
        end
        sortFrags(leftItems) 
	end

	if(table.isEmpty(_bagInfo.heroFrag)) then
		return 0
	else
		local heroFragsbyTid = deepcopy(_bagInfo.heroFrag)
		sortFrags(heroFragsbyTid)
	end
	return _tbHerofragsById
end

---------------------------- 名仕 --------------------------------
-- 保存
function saveStarInfoToCache( starInfo )
	_starCache = starInfo
end
-- 获取
function getStarInfoFromCache()
	return _starCache
end
-- 获取所有star列表 id 递增
function getStarArr()
	local starArr = {}
	if( (not table.isEmpty(_starCache)) and  (not table.isEmpty(_starCache.star_list)) ) then
		local allKeys = table.allKeys(_starCache.star_list)
		local function keySort ( key_1, key_2 )
			return tonumber(key_1) < tonumber(key_2)
		end
		table.sort( allKeys, keySort )

		for k,keyIndex in pairs(allKeys) do
			local tbl = _starCache.star_list[keyIndex]
			table.insert(starArr, tbl)
		end
	end

	return starArr
end

-- 修改名将的经验
-- function addExpToStar( star_id, addExp, ratioGrow)
-- 	if( (not table.isEmpty(_starCache)) and  (not table.isEmpty(_starCache.star_list)) ) then
-- 		for key, star_info in pairs(_starCache.star_list) do
-- 			if(tonumber(key) == tonumber(star_id) ) then
-- 				_starCache.star_list[key].total_exp = _starCache.star_list[key].total_exp + tonumber(addExp)
-- 				require "db/DB_Star_level"
-- 				local tempData = DB_Star_level.getDataById(tonumber(_starCache.star_list[key].star_tid))
-- 				-- local lastLv = tonumber(_starCache.star_list[key].level)
-- 				_starCache.star_list[key].level = StarUtil.getLevelByTotalExp( _starCache.star_list[key].total_exp, _starCache.star_list[key].star_tid )
-- 				-- if(lastLv < tonumber(_starCache.star_list[key].level) )then
-- 				-- 	_starCache.star_list[key].ratio = 0
-- 				-- else
-- 				-- 	_starCache.star_list[key].ratio = tonumber(_starCache.star_list[key].ratio) + tonumber(ratioGrow)
-- 				-- end

-- 				break
-- 			end
-- 		end
-- 	end
-- end

-- 修改名将的等级
-- function addLevelToStar( star_id, addLv)
-- 	if( (not table.isEmpty(_starCache)) and  (not table.isEmpty(_starCache.star_list)) ) then
-- 		for key, star_info in pairs(_starCache.star_list) do
-- 			if(tonumber(key) == tonumber(star_id) ) then
-- 				_starCache.star_list[key].level = tonumber(_starCache.star_list[key].level) + addLv
-- 				-- 修改经验
-- 				_starCache.star_list[key].total_exp = StarUtil.getTotalExpByLevel(_starCache.star_list[key].star_tid, _starCache.star_list[key].level)
-- 				-- _starCache.star_list[key].ratio = 0
-- 				break
-- 			end
-- 		end
-- 	end
-- end

-- 增加一个名将
-- function addStarToCache( starInfo )
-- 	if(table.isEmpty(_starCache)) then
-- 	-- _starCache ={}
-- 	-- _starCache.rob_num = 0
-- 	-- _starCache.star_list = {}
-- 	-- _starCache.star_list[starInfo.star_id] = starInfo
-- 	else
-- 		_starCache.star_list[starInfo.star_id] = starInfo
-- 	end
-- end

-- 比武和打劫的次数
function addRobNum( times )
	_starCache.rob_num = tostring(tonumber(_starCache.rob_num) + times)
end

-- 次数
function getRobNum()
	return tonumber(_starCache.rob_num)
end

------------------- shop ----------------

--[[
      ret : 
          dictionary{
              uid : "25034"
              point : "0"
              bronze_recruit_num : "238"  
              bronze_recruit_free : "1"   					已经使用过的免费次数
              bronze_recruit_time : "1426657629.000000"  	上次招募的时间戳
              silver_recruit_num : "1"
              silver_recruit_time : "0"
              silver_recruit_status : "3"
              gold_recruit_num : "1"
              gold_recruit_time : "0"
              gold_recruit_status : "3"
              gold_recruit_sum : "1958"
          }
--]]

function setShopCache( shopInfo )
	if(shopInfo == nil ) then
		return
	end
	-- logger:debug("shopInfo ====== %s", type(shopInfo))
	_shopCache = shopInfo

	resetShopDataInfo()
end


function resetShopDataInfo( ... )
	require "db/DB_Tavern"
	local dbLower = DB_Tavern.getDataById(1)
	local dbMedium = DB_Tavern.getDataById(2)
	local dbSenior = DB_Tavern.getDataById(3)

	local nomalConfig = DB_Normal_config.getDataById(1)

	_shopCache.bronzeExpireTime = dbLower.free_time_cd + tonumber(_shopCache.bronze_recruit_time)
	_shopCache.silverExpireTime = dbMedium.free_time_cd + tonumber(_shopCache.silver_recruit_time)
	_shopCache.goldExpireTime = dbSenior.free_time_cd + tonumber(_shopCache.gold_recruit_time)
	_shopCache.MysteryExpireTime = nomalConfig.free_time_cd + tonumber(_shopCache.mystery_recruit_time)

	local nBronzeLeftTime = _shopCache.bronzeExpireTime - TimeUtil.getSvrTimeByOffset()
	local nSilverLeftTime = _shopCache.silverExpireTime - TimeUtil.getSvrTimeByOffset()
	local nGoldLeftTime = _shopCache.goldExpireTime - TimeUtil.getSvrTimeByOffset()
	local nMysteryLeftTime = _shopCache.MysteryExpireTime - TimeUtil.getSvrTimeByOffset()
	nBronzeLeftTime = (nBronzeLeftTime < 0) and 0 or nBronzeLeftTime
	nSilverLeftTime = (nSilverLeftTime < 0) and 0 or nSilverLeftTime
	nGoldLeftTime 	 = (nGoldLeftTime < 0) and 0 or nGoldLeftTime
	nMysteryLeftTime = (nMysteryLeftTime < 0) and 0 or nMysteryLeftTime

	require "script/module/main/MainScene"
	local scene = CCDirector:sharedDirector():getRunningScene()

	local nLeftFreeNum = dbLower.free_times - tonumber(_shopCache.bronze_recruit_free)
	if (nLeftFreeNum > 0) then
		if (nBronzeLeftTime == 0) then
			_shopCache.lowerFreeNum = 1
		else
			local function bronzeUpdate()
				-- logger:debug("bronzeUpdate" .. _shopCache.bronzeExpireTime - TimeUtil.getSvrTimeByOffset())
				if (_shopCache.bronzeExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then
					_shopCache.lowerFreeNum = 1
					MainScene.updateShopTip()
					GlobalScheduler.removeCallback("brozenShop")
				end
			end
			GlobalScheduler.addCallback("brozenShop", bronzeUpdate)
			_shopCache.lowerFreeNum = 0
		end
	else
		_shopCache.lowerFreeNum = 0
	end

	if (nSilverLeftTime == 0) then
		_shopCache.mediumFreeNum = 1
	else
		local function SilverUpdate()
			-- logger:debug("SilverUpdate" .. _shopCache.silverExpireTime - TimeUtil.getSvrTimeByOffset())
			if (_shopCache.silverExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then
				_shopCache.mediumFreeNum = 1
				MainScene.updateShopTip()
				GlobalScheduler.removeCallback("SilverShop")
			end
		end
		GlobalScheduler.addCallback("SilverShop", SilverUpdate)

		_shopCache.mediumFreeNum = 0
	end

	if (nGoldLeftTime == 0) then
		_shopCache.seniorFreeNum = 1
	else
		local function seniorUpdate()
			-- logger:debug("goldUpdate" .. _shopCache.goldExpireTime - TimeUtil.getSvrTimeByOffset())
			if (_shopCache.goldExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then
				_shopCache.seniorFreeNum = 1
				MainScene.updateShopTip()
				GlobalScheduler.removeCallback("goldShop")
			end
		end
		GlobalScheduler.addCallback("goldShop", seniorUpdate)

		_shopCache.seniorFreeNum = 0
	end

	if (nMysteryLeftTime == 0) then
		_shopCache.mySteryFreeNum = 1
	else
		local function mySteryUpdate()
			-- logger:debug("goldUpdate" .. _shopCache.goldExpireTime - TimeUtil.getSvrTimeByOffset())
			if (_shopCache.MysteryExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then
				_shopCache.mySteryFreeNum = 1
				MainScene.updateShopTip()
				GlobalScheduler.removeCallback("mysteryShop")
			end
		end
		GlobalScheduler.addCallback("mysteryShop", mySteryUpdate)

		_shopCache.mySteryFreeNum = 0
	end
end

function getShopCache( )
	return _shopCache
end


--[[desc:更新百万招募免费次数
    arg1:无
    return:无
—]]
function setItemFreeNum( num )
	_shopCache.lowerFreeNum = num
end


-- 修改千万招募免费次数  暂时去掉了
function addSiliverFreeNum( addNum )
	_shopCache.mediumFreeNum = tonumber(_shopCache.mediumFreeNum) + tonumber(addNum)
	if(tonumber(_shopCache.mediumFreeNum)<=0)then
		require "db/DB_Tavern"
		local mediumDesc = DB_Tavern.getDataById(2)

		_shopCache.silver_recruit_time  = TimeUtil.getSvrTimeByOffset()
		_shopCache.silverExpireTime 	= mediumDesc.free_time_cd + TimeUtil.getSvrTimeByOffset()
	end
end
-- 修改 亿万招募免费次数 
function addGoldFreeNum( addNum )
	_shopCache.seniorFreeNum = tonumber(_shopCache.seniorFreeNum) + tonumber(addNum)
	if(tonumber(_shopCache.seniorFreeNum)<=0)then
		require "db/DB_Tavern"
		local seniorDesc = DB_Tavern.getDataById(3)

		_shopCache.gold_recruit_time = TimeUtil.getSvrTimeByOffset()
		_shopCache.goldExpireTime 	 = seniorDesc.free_time_cd + TimeUtil.getSvrTimeByOffset()
	end
end

-- 修改 神秘招募免费次数 
function addMysteryFreeNum( addNum )
	_shopCache.mySteryFreeNum = tonumber(_shopCache.mySteryFreeNum) + tonumber(addNum)
	if(tonumber(_shopCache.mySteryFreeNum)<=0)then
		require "db/DB_Tavern"
		local nomalConfig = DB_Normal_config.getDataById(1)
		_shopCache.mystery_recruit_time = TimeUtil.getSvrTimeByOffset()
		_shopCache.MysteryExpireTime 	 = nomalConfig.free_time_cd + TimeUtil.getSvrTimeByOffset()
	end
end

-- 修改神将累积招将次数, added by zhz
function changeGoldRecruitSum(addNum )
	_shopCache.gold_recruit_num = _shopCache.gold_recruit_num + tonumber(addNum)
end


-- 添加神将信息
function changeSeniorHeros( gold_recruit_t, htid )
	_shopCache.va_shop.gold_recruit = gold_recruit_t
	_shopCache.va_shop.gold_hero = htid
end
-- 修改摸个商品的购买次数
function addBuyNumberBy( goods_id, addNum )
	logger:debug(_shopCache)
	addNum = tonumber(addNum)
	if(table.isEmpty(_shopCache.goods)) then
		_shopCache.goods = {}
	end
	if(_shopCache.goods["" .. goods_id])then
		_shopCache.goods["" .. goods_id].num = tonumber(_shopCache.goods["" .. goods_id].num) + addNum
	else
		_shopCache.goods["" .. goods_id] = {}
		_shopCache.goods["" .. goods_id].num = addNum
	end
end

-- 修改首刷状态
function changeFirstStatus()
	if( tonumber(_shopCache.gold_recruit_status) <2 ) then
		_shopCache.gold_recruit_status = "" .. (tonumber(_shopCache.gold_recruit_status) + 2)
	end
end

-- 修改战将首刷状态
function changeSiliverFirstStatus()
	if( tonumber(_shopCache.silver_recruit_status) <2 ) then
		_shopCache.silver_recruit_status = "" .. (tonumber(_shopCache.silver_recruit_status) + 2)
	end
end

-- 获得积分
function getShopPoint(  )
	return _shopCache.point
end
-- 修改积分
function changeShopPoint( point)
	_shopCache.point = tonumber(_shopCache.point) - point
end
-- 增加积分
function addShopPoint( point)
	_shopCache.point = tonumber(_shopCache.point) + point
end

-- 获得当前可以领取的vip礼包数量, added by zhz
function getCanReceiveVipNUm(  )
	require "script/model/user/UserModel"
	require "script/module/shop/ShopGiftData"
	if(_shopCache == nil or table.isEmpty(_shopCache) ) then
		return 0
	end
	local vip_gift=   _shopCache.va_shop.vip_gift
	local num=0
	-- logger:debug(vip_gift)
	if( not table.isEmpty(vip_gift)) then
		for i=1, #vip_gift do

			local vipData = DB_Vip.getDataById(i)
			local vip_gift_ids = string.split(vipData.vip_gift_ids, "|")

			if(tonumber(vip_gift[i]) == 0 and vipData.vip_gift_ids ~= nil) then
				num = num+1
			end
		end
	else
		-- logger:debug(UserModel.getVipLevel())
		if(UserModel.getVipLevel() > 10) then
			num = VipGiftModel.getVipGiftCount() or 0

		else
			num = UserModel.getVipLevel()+1
		end

	end
	return num
end

-- 获得可以招募的英雄数目
function getRecuitFreeNum( )
	local num=0
	if(table.isEmpty(_shopCache) or _shopCache== nil) then
		return num
	end

	if (_shopCache.lowerFreeNum > 0) then
		num = num + _shopCache.lowerFreeNum
	end

	-- if ( tonumber(_shopCache.mediumFreeNum) >0 ) then
	-- 	num= num+tonumber(_shopCache.mediumFreeNum)
	-- end
	if( tonumber(_shopCache.seniorFreeNum) >0) then
		num= num+tonumber(_shopCache.seniorFreeNum)
	end

	if( tonumber(_shopCache.mySteryFreeNum) >0 and tonumber(_shopCache.mystery_recruit_time) > 0) then
		num= num+tonumber(_shopCache.mySteryFreeNum)
	end
	return num
end

function getShopGiftForFree( ... )
	local num = getRecuitFreeNum()+ getCanReceiveVipNUm()
	return num
end

----------------------------------  设置charge_gold:用户充值金币的数量 ---------------
require "script/module/IAP/IAPData"
function setChargeGoldNum( chargeGold )
	IAPData.setChargeGoldNum(chargeGold)
end


-- 此处获取的充值金币数 只能计算vip等级 
function getChargeGoldNum( )
	return  IAPData.getChargeGoldNum()
end



--------------------------------奖励中心通知状态---------------------------
local bNewRewardStatus=false
-- 获取奖励中心状态
function getRewardCenterStatus( ... )
	return bNewRewardStatus
end
-- 设置奖励中心状态
function setRewardCenterStatus(pStatus)
	bNewRewardStatus = pStatus
end


--设置vip礼包购买状态
function setBuyedVipGift( vipLevel )
	_shopCache.va_shop.vip_gift[tostring(vipLevel)] = 1

end

------------------------------------- 对手阵容的查看 -----------------------
local _rivalFormation = {}

function addFormaton( formation )
	table.insert(_rivalFormation, formation)
end

function getFromation(uid )
	for k,formation in pairs(_rivalFormation) do
		if( formation.uid == uid) then
			return formation
		end
	end
	return false
end

function setBagItemPotentiality( item_id )
	print("setBagItemPotentiality = ", item_id)
	print_t(potentiality_info)
	print("开始设置")
	for k,v in pairs(_bagInfo.arm) do
		if(tonumber(v.item_id) == tonumber(item_id)) then
			_bagInfo.arm[tostring(k)].va_item_text.armPotence = v.va_item_text.armFixedPotence
			_bagInfo.arm[tostring(k)].va_item_text.armFixedPotence = nil
			print("正在设置")
			break
		end
	end
	print("设置结束")
	print_t(_bagInfo.arm)
end

function setBagItemFixedPotentiality( item_id ,potentiality_info )
	print("setBagItemFixedPotentiality = ", item_id)
	print_t(potentiality_info)
	print("开始设置")
	for k,v in pairs(_bagInfo.arm) do
		if(tonumber(v.item_id) == tonumber(item_id)) then
			_bagInfo.arm[tostring(k)].va_item_text.armFixedPotence = potentiality_info
			print("正在设置")
			break
		end
	end
	print("设置结束")
	print_t(_bagInfo.arm)
end

--[[
	@设置宝物精炼等级
]]
function setTreasureEvolveLevel( item_id, evolve_level )
	for k,v in pairs(_bagInfo.treas) do
		if(tonumber(v.item_id) == tonumber(item_id)) then
			_bagInfo.treas[tostring(k)].va_item_text.treasureEvolve = evolve_level
			break
		end
	end
end


-- 修改战魂等级
function changeFSLvByItemId( item_id, level, totalExp )
	local isInBag = false
	for g_id, fs_info  in pairs(_bagInfo.fightSoul) do
		if ( fs_info.item_id == "" .. item_id ) then
			_bagInfo.fightSoul[g_id].va_item_text.fsLevel = "" .. level
			_bagInfo.fightSoul[g_id].va_item_text.fsExp = "" .. totalExp
			isInBag = true
			break
		end
	end
	if( isInBag == false)then
	-- TODO 英雄身上
	end
end

-- 判断简单难度的据点是否打过
function isStrongHoldChallenged( strongHoldId,hardLevel)
	assert(strongHoldId,"paramter error  in DataCache.isStrongHoldChallenged")

	if(hardLevel == nil or hardLevel < 0) then
		hardLevel = 1
	end

	--判断是否攻打过
	local normalCopyList = getNormalCopyData()
	local currentStar = 0

	for cNum,copy_info_all in pairs(normalCopyList.copy_list) do
		local copy_info = copy_info_all.va_copy_info

		if(copy_info~=nil and copy_info.progress~=nil and copy_info.progress["" .. strongHoldId]~=nil) then
			currentStar = tonumber(copy_info.progress["" .. strongHoldId])
			if(currentStar == nil) then
				currentStar = -1
			else
				currentStar = currentStar - 2
			end

			break
		end -- if end
	end

	if(currentStar>=hardLevel and hardLevel>0) then
		return true
	end
	return false
end

--对本地背包的宝物信息进行排序
function fnSortTreasInBag ()

	local tbTreas = mBagInfoCache.treas

	if(not table.isEmpty(tbTreas)) then
		table.sort(tbTreas, BagUtil.treasSort)
	end

end

-----------------------------曾经拥有过的伙伴集合------------------------------

function getHeroBook( ... )
	return _heroBook
end

function setHeroBook( tbData )
	_heroBook = tbData
	logger:debug({yc = _heroBook})
end

function addHeroBook( tbData )
	for k, v in pairs(tbData) do
		table.insert(_heroBook, v)
	end
end

function isInHeroBook( htid )
	local thashData = {}
	for k, v in pairs(_heroBook or {}) do
		thashData[tostring(v)] = 1
	end
	return thashData[tostring(htid)] and true or false
end


-------------
function setSkypieaData( _data )
	_tbSkypieaCache = _data.va_pass.heroInfo or {}
	logger:debug(_tbSkypieaCache)
end

function getSkypieaData( _data )
	return _tbSkypieaCache
end
