-- Filename: UserModel.lua
-- Author: fang
-- Date: 2013-05-31
-- Purpose: 该文件用于用户数据模型
-- Modified:
--	1.2015-01-08，zhangqi, 去主角后删除User的htid和dress字段，玩家头像用 figure 字段（具体是某个伙伴的htid）表示
--  2.2015-01-08, 玩家的主船形象用新增的 ship_figure 字段
--  3.2015-02-05,  huxiaozhou 添加 day_offset 每天刷新的时间偏移

module ("UserModel", package.seeall)

local _userInfo = nil

-- 观察者数组，观察者为数据变更观察者，观察者自身应该为视图
local observers = nil

local _bChanged = false -- zhangqi, 用户信息是否已发生变化，作为是否刷新战斗力数值的参考
function setInfoChanged( bStat )
	_bChanged = bStat
	--print("setInfoChanged: " .. tostring(_bChanged))
	--print(debug.traceback())
end

-- zhangqi, 2015-05-14, 需要检查的玩家属性字段
local _checkField = {exp_num = true, stamina = true, silver_num = true, gold_num = true, execution = true, 
					 prestige_num = true, jewel_num = true, stamina_max_num = true, coin_num = true}

local _oldUserInfo = {} -- zhangqi, 2105-05-14, 记录断线时的玩家信息，用于重连成功后的数据对比

-- zhangqi, 2015-05-14, 断线的通知需要调用，保存断线时的玩家当前信息
function saveOldInfo( ... )
	_oldUserInfo = {}
	table.hcopy(_userInfo or {}, _oldUserInfo)
	logger:debug({saveOldInfo = _oldUserInfo})
end

-- zhangqi, 2015-05-14, 非登陆重连拉取新的玩家信息后通知需要调用，将新老用户信息按需要检查的字段做对比
-- 将老信息中不一致的字段保留，作为重连后第一次变更数据的参考
function checkInfoAfterReconn( ... )
	for k, v in pairs(_userInfo) do
		if (_checkField[k]) then 
			if (tonumber(v) == tonumber(_oldUserInfo[k])) then
				_oldUserInfo[k] = nil
			end
		else
			_oldUserInfo[k] = nil
		end
	end
	logger:debug({checkInfoAfterReconn = _oldUserInfo})
	logger:debug({_userInfo = _userInfo})
end

-- 用户信息结构
--[[
    uid:用户id,
    uname:用户名字,
    utid:用户模版id,
    htid:主角武将的htid
    level:玩家级别
    execution:当前行动力,
    execution_time : 上次恢复行动力时间
    buy_execution_accum : 今天已经购买行动力数量
    vip:vip等级,
    silver_num:银两,
    gold_num:金币RMB,
    exp_num:阅历,
    soul_num:将魂数目
    stamina:耐力
    coin_num : 空岛币数目
    stamina_time:上次恢复耐力的时间
    stamina_max_num:耐力上限
    fight_cdtime : 战斗冷却
    ban_chat_time : 禁言结束时间
    max_level:玩家的等级上限
    hero_limit:武将数目限制
    charge_gold:当前充金币数目
    jewel_num：魂玉数目
    prestige_num：声望数目
    fight_force: zhangqi, 2014-10-12, 后端返回的战斗力数值（由于后端只在每次进战斗时才计算一次战斗力然后缓存，此战斗力值和客户端当前显示的实时战斗力较大概率不同）
-- added by fang, for client data cache
    fight_value: 玩家战斗力
    day_offset: 每天刷新时间偏移
    rime_num: 结晶数
    awakerime_num: 觉醒结晶数
    prison_gold_num:监狱币数量
    ship_figure:主船的id，主船的形象id在UIHelper中的方法获取
    
--]]

function getUserInfo()
	return assert(_userInfo, "警告！！ 用户信息为空，请先设置用户信息")
end

function setUserInfo(pUserInfo)
	_userInfo = pUserInfo
	
	_userInfo.uname = CCCrypto:decodeBase64(_userInfo.uname)
	logger:debug({decode_uname = _userInfo.uname})

	-- zhangqi, 2015-05-27, 注册自动恢复体力耐力定时器
	GlobalScheduler.addCallback("StatminaPowerTimer", updateInfoData)
	-- zhangqi, 注册掉线后停止定时更新耐力体力的回调
	GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED, function ( ... )
		GlobalScheduler.removeCallback("StatminaPowerTimer")
	end, nil, "FAILED_StatminaPower")

	setCurDataTimeMark() --liweidong 设置数据日期标识

	require "script/module/SkyPiea/SkyPieaUtil"
	SkyPieaUtil.setUserRewardTime()  --zhangjunwu 设置次轮发奖的时间信息
end


--获取当前时间对应的数据的日期标识 liweidong
function createTimeMarkBySvrTime()
 --每天上午11点重置数据，每天的时间偏移，如果是晚上12点重置，则为0.用于计算当前数据是那天的数据
	local resetDataTime=getDayOffset()
	local curTime = TimeUtil.getSvrTimeByOffset()
	curTime=curTime-resetDataTime
	return tostring(TimeUtil.getLocalOffsetDate("%x",curTime))
end
--设置当前数据的日期标识 liweidong
function setCurDataTimeMark()
	_userInfo.dateTimeMark = createTimeMarkBySvrTime()
	logger:debug("cur data mark:".._userInfo.dateTimeMark)
end
--获取当前数据的日期标识
function getCurDataTimeMark()
	return _userInfo.dateTimeMark
end

--是否可发言，true为可发言，false为不可，方法未写完
function isChatable()
	if(getUserInfo().ban_chat_time<=0) then
		return true
	else
		return false
	end
end

-- 判断用户是否达到最大等级
function hasReachedMaxLevel( ... )
	return tonumber(_userInfo.level) >= tonumber(_userInfo.max_level)
end

-- 用户升级表数据
local _tObserverForLevelUp = {}
-- 为用户升级提供观察者
-- pKey, string类型, pFnObserver唯一标识符
-- pFnObserver: 需要调用的函数
function addObserverForLevelUp(pKey, pFnObserver)
	-- for debug
	-- 以下代码用于调试，正式代码应该去掉
	if type(pKey) ~= "string" or type(pFnObserver) ~= "function" then
		print("Error, UserModel.addObserverForLevelUp, new observer is wrong.")
		return
	end
	for k, v in pairs(_tObserverForLevelUp) do
		if k == pKey then
			print("Error, UserModel.addObserverForLevelUp, observers have the same key named as ", k)
			break
		end
	end

	_tObserverForLevelUp[pKey] = pFnObserver
end
-- 删除自定义观察者
function removeObserverForLevelUp(pKey)
	_tObserverForLevelUp[pKey]=nil
end

-- 获取体力值方法
function getEnergyValue()
	if _userInfo then
		return tonumber(_userInfo.execution)
	end
	return 0
end

-- 获得 max_level added by zhz
function getUserMaxLevel( )
	return tonumber(_userInfo.max_level)
end

-- 获得玩家的sex added by zhz；2015-01-08，zhangqi，去主角后默认性别为男性
-- return, 1男，2女
function getUserSex()
	-- 	require "db/DB_Heroes"
	-- 	local model_id = DB_Heroes.getDataById(tonumber(_userInfo.htid)).model_id
	-- 	if model_id == 20001 then
	-- 		return 1
	-- 	elseif model_id == 20002 then
	-- 		return 2
	-- 	end
	-- 	return -1
	return 1
end

-- zhangqi, 2015-05-14, 用断线时的老信息为参考检查需要变更的数值是否不需要处理
-- 如果变更值加上老信息的值和新信息的值相同，则不需要处理
local function checkNotNeedAdd( sField, nValue )
	logger:debug("checkNotNeedAdd: sField = %s, nValue = %s", sField, tostring(nValue))
	local ret = false
	if (_oldUserInfo[sField]) then -- 该字段在老信息中表示断网重连前后不一致
		ret = (tonumber(_oldUserInfo[sField]) + tonumber(nValue) == tonumber(_userInfo[sField]))
		_oldUserInfo[sField] = nil -- 赋值nil保证每次断网重连只进行一次对比，后续必然都需要处理
	end

	if (ret) then
		updateInfoBar() -- 不需要重复变更，但需要刷新信息条UI
	end
	
	return ret
end

function checkValueCallback(cbFlag, dictData, bRet)
	print_table("checkValueCallback",dictData)
	if(dictData.ret~=nil and (tonumber(dictData.ret.exp_num)~=tonumber(_userInfo.exp_num) or tonumber(dictData.ret.level)~=tonumber(_userInfo.level))) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		RequestCenter.gm_reportClientError(nil,Network.argsHandler("exp error _userInfo.exp_num:" .. _userInfo.exp_num .. ",_userInfo.level:" .. _userInfo.level))
	end
end

-- zhangqi, 2015-05-29, 获取当前经验值和升下一级需要的经验值
function getExpAndNextExp( ... )
	require "db/DB_Level_up_exp"
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nLevelUpExp = tUpExp["lv_"..(tonumber(_userInfo.level)+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(_userInfo.exp_num) -- 当前的经验值
	return nExpNum, nLevelUpExp
end

-- 增加经验值方法
function addExpValue(value, sourceFlag, bInfoPanelNotUpdate)
	assert( value and sourceFlag, "addExpValue need at least 2 args, value and sourceFlag")
	
	if hasReachedMaxLevel() then
		return
	end

	-- if (checkNotNeedAdd("exp_num", value)) then
	-- 	return
	-- end

	_userInfo.exp_num = tonumber(_userInfo.exp_num) + value

	require "script/model/hero/HeroModel"
	require "db/DB_Level_up_exp"
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local bUpgraded = false
	local status = true
	if tonumber(_userInfo.level) >= tonumber(_userInfo.max_level) then
		status = false
	end
	while status do
		local nLevelUpExp = tUpExp["lv_"..(tonumber(_userInfo.level)+1)]
		if (tonumber(_userInfo.exp_num) >= nLevelUpExp) then
			_userInfo.exp_num = tonumber(_userInfo.exp_num) - nLevelUpExp

			bUpgraded = true
			_userInfo.level = tonumber(_userInfo.level) + 1
			--addGoldNumber(10)									-- 2015.7.28 新需求，升级不再送金币
		else
			status = false
		end
	end
	if bUpgraded then
		for k, fn in pairs(_tObserverForLevelUp) do
			fn(_userInfo.level)
		end
		HeroModel.setMainHeroLevel(_userInfo.level)
		_bChanged = true -- zhangqi, 2014-10-20, 升级了标记需要更新战斗力
	end

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end

	if (g_debug_mode) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		RequestCenter.user_checkValue(checkValueCallback,Network.argsHandler("exp_num",_userInfo.exp_num,"user.checkValue_exp:" .. sourceFlag))
	end
end
-- 通过传入经验值判断是否会升级
-- tParam = {}
-- tParam.exp_num(用户的当前经验)
-- tParam.add_exp_num (增加的经验值)
-- tParam.level (相应的等级)
-- 返回值 tRet = {}
-- tRet.isUpgraded=true(升级了), false(未升级)
-- tRet.level（返回的等级）
-- tRet.ratio (剩于的比率)
function getUpgradingStatusIfAddingExp(tParam)
	local tRet = {}
	tRet.level = tParam.level
	require "db/DB_Level_up_exp"
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local bUpgraded = false
	local status = true
	local nTotalExpNum = tParam.exp_num+tParam.add_exp_num
	while status do
		local nLevelUpExp = tUpExp["lv_"..(tRet.level+1)]
		if (nTotalExpNum >= nLevelUpExp) then
			bUpgraded = true
			nTotalExpNum = nTotalExpNum - nLevelUpExp
			tRet.level = tRet.level + 1
		else
			tRet.ratio = nTotalExpNum/nLevelUpExp
			status = false
		end
	end
	tRet.isUpgraded = bUpgraded

	return tRet
end

-- 获得用户当前vip等级
function getVipLevel()
	local vipLevel = _userInfo.vip or 0

	return tonumber(vipLevel)
end
-- 获得用户当前武将限制数量
function getHeroLimit( ... )
	return tonumber(_userInfo.hero_limit)
end
-- 设置用户当前武将限制数量
function setHeroLimit(pHeroLimit)
	_userInfo.hero_limit = pHeroLimit
end

-- 获取银币值
function getSilverNumber()
	local nValue = tonumber(_userInfo.silver_num)
	if nValue < 0 then
		nValue = 0
	end
	return nValue
end
-- 获取金币值
function getGoldNumber()
	return tonumber(_userInfo.gold_num)
end

-- 获取耐力上限
function getMaxStaminaNumber()
	if _userInfo then
		return tonumber(_userInfo.stamina_max_num)
	else
		return 0
	end
end
-- 获取耐力值
function getStaminaNumber()
	-- do return 1 end
	if _userInfo then
		return tonumber(_userInfo.stamina)
	else
		return 0
	end
end
-- 获得上次恢复耐力时间
function getStaminaTime()
	if _userInfo then
		return tonumber(_userInfo.stamina_time)
	else
		return 0
	end
end
-- 获取经验值方法
function getExpValue(value)
	return tonumber(_userInfo.exp_num)
end
-- 获取当前等级方法
function getHeroLevel()
	return tonumber(_userInfo.level)
end
function setUserLevel( level )
	local newLevel = tonumber(level)
	if (newLevel and newLevel > tonumber(_userInfo.level)) then
		_userInfo.level = newLevel
	end
end
-- 获取当前等级方法
function getAvatarLevel()
	return tonumber(_userInfo.level)
end
-- 获得将魂数量方法
-- function getSoulNum( ... )
-- 	return tonumber(_userInfo.soul_num)
-- end
-- 获得用户uid
function getUserUid()
	return tonumber(_userInfo.uid)
end
-- 获得用户utid
function getUserUtid()
	return tonumber(_userInfo.utid)
end

-- 获取用户跨服pid
function getPid(  )
	return tonumber(_userInfo.pid)
end

--获取用户跨服serverId
function getServerId(  )
	return tonumber(_userInfo.server_id)
end

-- 获得用户的名字
function getUserName()
	return _userInfo.uname
end
-- 修改用户的名字
function setUserName( sName )
	if (sName) then
		_userInfo.uname = sName
	end
end
-- 获得玩家的htid；2015-01-08，zhangqi, 去主角后玩家头像用figure字段
function getAvatarHtid( ... )
	return _userInfo.figure
end
-- 重新设置主角头像的htid
function setAvatarHtid( htid )
	-- zhangqi, 2015-01-09, 去主角修改
	_userInfo.figure = htid
	updateInfoBar() -- 新信息条统一刷新方法
end

--[[desc:zhangqi, 2015-07-28, 获取玩家当前所选头像或指定htid代表的hero的品质颜色
    arg1: tbArgs = {htid = nil, bright = nil}, tbArgs 可以是nil
    	  默认取玩家当前头像代表的hero的品质颜色，指定htid则返回对应hero的品质颜色
    	  默认使用较暗的配色，指定 bright = true 时使用较亮的配色
    return: ccc3Color
—]]
function getPotentialColor( tbArgs )
	local args = tbArgs or {}
	local db_hero = DB_Heroes.getDataById(args.htid or _userInfo.figure)
	local color = args.bright == true and g_QulityColor2 or g_QulityColor
	return color[db_hero.potential] or color[1]
end
-- 获取玩家主船形象的id
function getShipFigure( ... )
	return _userInfo.ship_figure
end
-- 设置玩家主船形象id，一般在主船升级后
function setShipFigure( figure )
	_userInfo.ship_figure = figure
end
-- 获取玩家“角色创建时间戳”
function getCreateTime( ... )
	return _userInfo.create_time
end

-- 获取应该刷新的时间点
function getDayOffset(  )
	return tonumber(_userInfo.day_offset)
end

-- 刷新后重置刷新时间点
function setDayOffset( dayOffset )
	_userInfo.day_offset = dayOffset
end

-- 获得上次恢复体力时间
function getEnergyValueTime()
	if _userInfo and _userInfo.execution_time then
		return tonumber(_userInfo.execution_time)
	end
	return os.time()
end
-- 获得用户声望
function getPrestigeNum( ... )
	return tonumber(_userInfo.prestige_num)
end
-- 获得玩家魂玉
function getJewelNum( ... )
	return tonumber(_userInfo.jewel_num)
end

--  获取玩家空岛币数
function getSkyPieaBellyNum(  )
	return tonumber(_userInfo.coin_num)
end

-- 获取玩家深海监狱币数
function getImpelDownNum()
	return tonumber(_userInfo.prison_gold_num) -- 2015-09-14等后端加入后，再添加到用户信息结构注释中
end

--  结晶数目
function getRimeNum(  )
	return tonumber(_userInfo.rime_num)
end

-- 修改结晶数目
function addRimeNum( value, bInfoPanelNotUpdate)
	logger:debug("oldRimeNum: %d, add value: %d", _userInfo.rime_num, value )
	_userInfo.rime_num = tonumber(_userInfo.rime_num) + value
	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end
end

-- 觉醒结晶数目
function getAwakeRimeNum(  )
	return tonumber(_userInfo.awakerime_num)
end

-- 修改觉醒结晶数
function addAwakeRimeNum( value, bInfoPanelNotUpdate)
	logger:debug("oldAwakeRimeNum: %d, add value: %d", _userInfo.awakerime_num, value )
	_userInfo.awakerime_num = tonumber(_userInfo.awakerime_num) + value
	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end
end


-- 加减空岛币值方法
function addSkyPieaBellyNum(value, bInfoPanelNotUpdate)
	logger:debug("oldSkyBellyNum: %d, add value: %d", _userInfo.coin_num, value )

	-- if (checkNotNeedAdd("coin_num", value)) then -- 2015-05-14
	-- 	return
	-- end
	
	_userInfo.coin_num = tonumber(_userInfo.coin_num) + value

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end
end

--加减监狱币方法 2015-09-14
function addImpelDownNum( value, bInfoPanelNotUpdate )
	logger:debug("oldImpelDownNum: %d, add value: %d", _userInfo.prison_gold_num, value )

	-- if (checkNotNeedAdd("prison_num", value)) then -- 2015-05-14
	-- 	return
	-- end
	
	_userInfo.prison_gold_num = tonumber(_userInfo.prison_gold_num) + value

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end
end

-- 加减耐力值方法
function addStaminaNumber(value, bInfoPanelNotUpdate)
	logger:debug("oldStamina: %d, add value: %d", _userInfo.stamina, value )

	-- if (checkNotNeedAdd("stamina", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.stamina = tonumber(_userInfo.stamina) + value
	logger:debug("newStamina: %d", _userInfo.stamina )

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end

	if (g_debug_mode) then
		--验证耐力
		require "script/network/RequestCenter"
		require "script/network/Network"
		RequestCenter.user_checkValue(nil,Network.argsHandler("stamina",_userInfo.stamina,""),"user.checkValue_stamina" .. math.random(999))
	end
end

-- 加减耐力值上限的方法
function addStaminaMaxNumber(value, bInfoPanelNotUpdate)
	-- if (checkNotNeedAdd("stamina_max_num", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.stamina_max_num = tonumber(_userInfo.stamina_max_num) + value

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end
end
-- 增减银币
function addSilverNumber(value, bInfoPanelNotUpdate,updateInfo)
	-- if (checkNotNeedAdd("silver_num", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.silver_num = tonumber(_userInfo.silver_num) + value

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		if (updateInfo) then
			updateInfoBar(updateInfo) -- zhangqi, 2015-04-29, 新的信息条UI统一刷新
		else
			updateInfoBar() -- zhangqi, 2015-04-29, 新的信息条UI统一刷新
		end
	end

	if (g_debug_mode) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		RequestCenter.user_checkValue(nil,Network.argsHandler("silver_num",tonumber(_userInfo.silver_num),""),"user.checkValue_silver_num" .. math.random(999))

	end
	--检测阵容的红点
	ItemUtil.justiceBagInfo()
end
-- 增减金币
function addGoldNumber(value, bInfoPanelNotUpdate)
	-- if (checkNotNeedAdd("gold_num", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.gold_num = tonumber(_userInfo.gold_num) + value
	logger:debug("new gold = %d", _userInfo.gold_num)

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end

	GlobalNotify.postNotify("SpendAccumulateGoldSpend", value)

	if (g_debug_mode) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		RequestCenter.user_checkValue(nil,Network.argsHandler("gold_num",tonumber(_userInfo.gold_num),""),"user.checkValue_gold_num" .. math.random(999))
	end
end
-- 增减体力值方法
function addEnergyValue(value, bInfoPanelNotUpdate)
	-- if (checkNotNeedAdd("execution", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.execution = tonumber(_userInfo.execution) + value

	-- zhangqi, 2016-01-25, 对线上出现体力为负值的情况做容错处理，并收集调用信息上传
	if (_userInfo.execution < 0) then
		_userInfo.execution = 0
		if (Platform.isPlatform()) then
			local pkgVer, resVer = Helper.getVersion() 
			local msg = string.format("negative power, %s:%s:%s:%s", pkgVer, resVer, Platform.getPL(), Platform.getPid())
			loggerHttp:fatal(msg .."\n".. debug.traceback())
		end
	end

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end

	-- if(g_system_type == kBT_PLATFORM_IOS) then
	-- 体力变化时，调用体力注册通知 add by chengliang
	-- require "script/utils/NotificationUtil"
	-- NotificationUtil.addRestoreEnergyNotification()
	-- end
end
-- 增减声望值方法
function addPrestigeNum(value, bInfoPanelNotUpdate)
	-- if (checkNotNeedAdd("prestige_num", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.prestige_num = tonumber(_userInfo.prestige_num) + value
	if (g_debug_mode) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		--RequestCenter.user_checkValue(nil,Network.argsHandler("prestige_num",tonumber(_userInfo.prestige_num),""),"user.checkValue_prestige_num" .. math.random(999))
	end

	if (not bInfoPanelNotUpdate) then -- 默认nil，表示需要及时刷洗信息条
		updateInfoBar() -- 信息条UI统一刷新
	end

	return _userInfo.prestige_num
end
-- 增减玩家魂玉值方法
function addJewelNum(value)
	-- if (checkNotNeedAdd("jewel_num", value)) then -- 2015-05-14
	-- 	return
	-- end

	_userInfo.jewel_num = tonumber(_userInfo.jewel_num) + value

	if (g_debug_mode) then
		require "script/network/RequestCenter"
		require "script/network/Network"
		--RequestCenter.user_checkValue(nil,Network.argsHandler("jewel_num",tonumber(_userInfo.jewel_num),""),"user.checkValue_jewel_num" .. math.random(999))
	end
	return _userInfo.jewel_num
end

-- 设置上次恢复体力时间
function setEnergyValueTime( value )
	_userInfo.execution_time = value
end

-- 设置体力回复满的时间，若满则为： 0
function getEnergyFullTime( )
	local energyNum =  g_maxEnergyNum - _userInfo.execution
	local energyAddTime = energyNum*g_energyTime
	local energyFullTime =0
	if (tonumber(g_maxEnergyNum) >  tonumber(_userInfo.execution) ) then
		energyFullTime = energyAddTime + _userInfo.execution_time - TimeUtil.getSvrTimeByOffset()
	else
		energyFullTime =0
	end
	return energyFullTime

end
--设置耐力值
function setStaminaNumber(value)
	if _userInfo then
		_userInfo.stamina = tonumber(value)
	end
end
-- 设置上次恢复耐力时间
function setStaminaTime( value )
	if _userInfo then
		_userInfo.stamina_time = tonumber(value)
	end
	-- _userInfo.stamina_time = value
end

-- 修改用户信息
function changeUserInfo(tParam)
	if not (tParam and type(tParam)=="table") then
		return
	end
	if tParam.execution then
		_userInfo.execution = tParam.execution
	end
	if tParam.level then
		_userInfo.level = tParam.level
	end
	if tParam.execution_time then
		_userInfo.execution_time = tParam.execution_time
	end
	if tParam.vip then
		-- 若修改了vip等级且不是第一次拉取信息，发送vip等级提升通知 lvnanchun
		if (_userInfo.vip and tonumber(_userInfo.vip) < tonumber(tParam.vip)) then
			GlobalNotify.postNotify(GlobalNotify.VIP_LEVEL_UP)
		end
		_userInfo.vip = tParam.vip
	end
	if tParam.silver_num then
		_userInfo.silver_num = tParam.silver_num
	end
	if tParam.gold_num then
		_userInfo.gold_num = tParam.gold_num
	end
	if tParam.exp_num then
		_userInfo.exp_num = tParam.exp_num
	end
	if tParam.soul_num then
		_userInfo.soul_num = tParam.soul_num
	end
	if tParam.stamina then
		_userInfo.stamina = tParam.stamina
	end
	if tParam.stamina_time then
		_userInfo.stamina_time = tParam.stamina_time
	end
	if tParam.stamina_max_num then
		_userInfo.stamina_max_num = tParam.stamina_max_num
	end
	if tParam.fight_cdtime then
		_userInfo.fight_cdtime = tParam.fight_cdtime
	end
	if tParam.ban_chat_time then
		_userInfo.ban_chat_time = tParam.ban_chat_time
	end
	if tParam.max_level then
		_userInfo.max_level = tParam.max_level
	end
	if tParam.hero_limit then
		_userInfo.hero_limit = tParam.hero_limit
	end
	if tParam.charge_gold then
		_userInfo.charge_gold = tParam.charge_gold
	end

	updateInfoBar() -- 新信息条统一刷新方法
end

-- zhangqi, 战斗力相关
function setFightForceValue(pFightValue)
	if(_userInfo.fight_value == pFightValue) then
		-- sunyunpeng 2105-12-31  在战斗力没有变化的时候 用当前战斗力更新旧的战斗力值  
		-- 避免在执行 MainFormationTools.fnShowFightForceChangeAni() 时 新老战斗力相同不票字
		_userInfo.oldFight_value = _userInfo.fight_value or pFightValue
		return
	end
	logger:debug("fight_value = %s", pFightValue)
	_userInfo.oldFight_value = _userInfo.fight_value or pFightValue
	_userInfo.fight_value = pFightValue
end

function getFightForceValueNewAndOld( ... )
	if _userInfo.fight_value then
		return _userInfo.fight_value , _userInfo.oldFight_value
	else
		return 0 , 0
	end
end

function getFightForceValue()
	if _userInfo.oldFight_value then
		return _userInfo.fight_value
	else
		return 0
	end
end


--[[ 里面缓存 
	hid = {
		magicDefend = 2363
		life = 30270
		physicalDefend = 2367
		speed = 10
		talent_magAtt = 2.03
		talent_phyDef = 0.87
		strength = 0
		vitalStat = 19819
		physicalAttack = 6031
		talent_magDef = 0.98
		generalAttack = 0
		talent_phyAtt = 1.74
		magicAttack = 6031
		talent_hp = 1.34
		command = 0
		intelligence = 0
		fightForce = 19819
		}
		
	}
--]]

local _tFightCache={}


-- 更新战斗力方法, zhangqi, 2014-04-09 整理自 MainScene.lua 里的 fnUpdateFightValue
function updateFightValue( tHids )
	if (not _bChanged and _userInfo.fight_value) then
		return -- zhangqi, 2014-10-20, 如果信息没有发生变化且fight_value有值，则不用刷新战斗力数值
	end
	print(debug.traceback())

	local tHids = tHids or {} --更新指定的hid table 或者 更新全部
	logger:debug({tHids=tHids})
	-- 战斗力
	TimeUtil.timeStart("updateFightValue")
	require "script/model/hero/HeroModel"
	local heroIDs = HeroModel.getAllHeroesHid()
	local fight_value = 0

	require "script/module/partner/HeroFightUtil"
	HeroFightUtil.clearAllForceCache() -- zhangqi, 2015-06-18
	for i=1, #heroIDs do
		local isBusy = HeroPublicUtil.isOnFmtByHid(heroIDs[i])
		if table.isEmpty(tHids) then
			if isBusy then
				_tFightCache[heroIDs[i]] = HeroFightUtil.getAllForceValuesByHidNew(heroIDs[i], {0})
			end
		else

			for hid, tNeedUpate in pairs(tHids) do
				if tonumber(hid) == tonumber(heroIDs[i]) and isBusy then
					logger:debug({huxiaozhouhid = hid})
					logger:debug({tNeedUpate = tNeedUpate})
					_tFightCache[heroIDs[i]] = HeroFightUtil.getAllForceValuesByHidNew(hid,tNeedUpate)
				end
			end
		end
	end

	for hid, tRet in pairs(_tFightCache) do
		if HeroPublicUtil.isOnFmtByHid(hid) then
			fight_value = fight_value + (tRet.fightForce or 0)
		end
	end

	-- 船炮 炮强化 增加战斗力 sunyupeng
	fight_value = fight_value + CannonModel.getCannonFightValue()

	TimeUtil.timeEnd("updateFightValue")


	-- logger:debug("current force = " .. getFightForceValue() .. " new force = " .. fight_value)
	setFightForceValue(math.floor(fight_value))

	_bChanged = false

	return fight_value
end

--  直接更新战斗力缓存方法
function updateFightValueByValue( hid,fightValue )
	local heroIDs = HeroModel.getAllHeroesHid()
	if (not _bChanged and _userInfo.fight_value) then
		return 
	end

	local fight_value = 0

	HeroFightUtil.clearAllForceCache() 
	for i=1, #heroIDs do
		local isBusy = HeroPublicUtil.isOnFmtByHid(heroIDs[i])
		if tonumber(hid) == tonumber(heroIDs[i]) and isBusy then
			_tFightCache[heroIDs[i]] = fightValue  -- 直接修改，因为已经计算过 ，伙伴进阶和强化和突破的时候 已经做了计算
		end

	end

	for hid, tRet in pairs(_tFightCache) do
		if HeroPublicUtil.isOnFmtByHid(hid) then
			fight_value = fight_value + tRet.fightForce
		end
	end
	
	-- 船炮 炮强化 增加战斗力 sunyupeng
	fight_value = fight_value + CannonModel.getCannonFightValue()
	
	setFightForceValue(math.floor(fight_value))
	_bChanged = false

	return fight_value
end

-- 设置玩家时装id
function setUserFtid( ftid )
	_userInfo.ftid = ftid
end

-- 得到玩家的时装信息
function getDressIdByPos( pos_id )
	if _userInfo.dress ~= nil then
		return  _userInfo.dress[tostring(pos_id)]
	end
end

-- 设置玩家时装id
function setDressIdByPos( pos_id, dress_id )
	_userInfo.dress[tostring(pos_id)] = dress_id
end

-- zhangqi, 2015-05-27
-- 耐力变化注册函数
function registerStaminaNumberChangeCallback( callFunc )
	fnStaminaNumberChange = callFunc
end
-- 更新体力，耐力数据
function updateInfoData( ... )
	-- logger:debug("begin updateInfoData")

	local m_nPowerTime = g_energyTime -- 体力恢复一点时间
	local m_nPowerMax = g_maxEnergyNum -- 体力值上限
	local m_nStamTime = g_stainTime -- 耐力恢复一点时间
	local m_nStaminaMax = UserModel.getMaxStaminaNumber() -- 耐力上限

	local curServerTime = TimeUtil.getSvrTimeByOffset() -- 当前服务器时间
	local curExecution = getEnergyValue() -- 当前体力值
	local execution_time = getEnergyValueTime()
	-- 小于上限开始恢复
	local passTime = tonumber(curServerTime) - execution_time
	local addExecution = math.floor(passTime/m_nPowerTime)

	if(addExecution >= 1)then
		local allExecution = curExecution + addExecution
		if(curExecution < m_nPowerMax)then
			if(allExecution < m_nPowerMax)then
				logger:debug("Pow all < Max, add: " .. addExecution)
				addEnergyValue(addExecution) -- 体力恢复
			else
				local addExecution = m_nPowerMax - curExecution
				logger:debug("Pow all >= Max, add: " .. addExecution)
				addEnergyValue(addExecution) -- 体力恢复
			end

		end
		-- 恢复体力的时间
		local curServerTime = TimeUtil.getSvrTimeByOffset()
		setEnergyValueTime(curServerTime)
	end


	local curStamina = getStaminaNumber() -- 当前耐力值
	local stamina_time = getStaminaTime() -- 上次恢复耐力时间

	-- 小于上限开始恢复
	local passTime = tonumber(curServerTime) - stamina_time
	local addStamina = math.floor(passTime/m_nStamTime)
	--logger:debug("m_nStaminaMax = " .. m_nStaminaMax .. " curStamina = " .. curStamina .. " stamina_time = " .. stamina_time .. " passTime = " .. passTime .. " addStamina = " .. addStamina)

	if(addStamina >= 1)then
		local allStamina = curStamina + addStamina
		if(curStamina < m_nStaminaMax)then
			if(allStamina < m_nStaminaMax)then
				logger:debug("Stam all < Max, add: " .. addStamina)
				addStaminaNumber(addStamina) -- 耐力恢复
			else
				local addStamina = m_nStaminaMax - curStamina
				logger:debug("Stam all >= Max, add: " .. addStamina)
				addStaminaNumber(addStamina) -- 耐力恢复
			end
		end

		setStaminaTime(stamina_time + addStamina*m_nStamTime) -- 恢复耐力的时间
		-- 调用耐力注册函数
		if(fnStaminaNumberChange ~= nil)then
			fnStaminaNumberChange()
		end
	end
end

-- 2015-11-24, 记录某些用户操作发给后端
-- zhangqi, 2016-01-05, 增加线下模式不记录的处理
function recordUsrOperation( stepKey, stepValue )
	if (g_debug_mode) then
		return
	end

    local tbParams = {Platform.getUUID(), stepKey, stepValue}

    Network.setShowLoading(true) -- reportFrontStep没有返回，先设置true保证不显示Loading

    require "script/network/RequestCenter"
    RequestCenter.user_reportFrontStep(function ( cbFlag, dictData, bRet )
    	logger:debug({recordUsrOperation_dictData = dictData})
    end, Network.argsHandlerOfTable(tbParams))
end


-- 从6级强制新手引导完后—— 到8级之前（包括7级）            
local function getNeedRecord(  )
	local bNeedRecord = false                              
	if getAvatarLevel() < 8 then                           
		bNeedRecord = true                                 
    end                                                    
	return bNeedRecord                                     
end                                                        
                                                                                    
-- 带判断条件的 记录用户操作
-- zhangqi, 2016-01-05, 增加线下模式不记录的处理                              
function recordUsrOperationByCondition(stepKey, stepValue)
	if (g_debug_mode) then
		return
	end

	if getNeedRecord() then                                
		recordUsrOperation(stepKey, stepValue)             
	end                                                    
end                                                        
