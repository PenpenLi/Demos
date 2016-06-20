-- FileName: WorldArenaModel.lua
-- Author: huxiaozhou
-- Date: 2016-02-04
-- Purpose: 巅峰对决的数据，服务端返回数据的缓存
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WorldArenaModel", package.seeall)

-- 模块局部变量 --

local _tWorldArenaInfo 				= nil 	-- 巅峰对决数据

local _bSkip 					= false 	-- 是否跳过战斗 false不跳过，true跳过

--[[
	@des 	: 设置巅峰对决数据
	@param 	: 
	@return :
--]]
function setWorldArenaInfo( tInfo )
	_tWorldArenaInfo = tInfo
end

--[[
	@des 	: 得到巅峰对决数据
	@param 	: 
	@return :
--]]
function getWorldArenaInfo(  )
	return _tWorldArenaInfo 
end

--[[
	@des 	: 更新巅峰对决数据
	@param 	: 
	@return :
--]]
function updateWorldArenaInfo( tExtraInfo )
	if( table.isEmpty(tExtraInfo) )then
		return
	end
	-- 更新信息
	_tWorldArenaInfo.extra = tExtraInfo
end

--[[
	@des 	: 报名开始时间
	@param 	: 
	@return : num
--]]
function getSignUpStartTime(  )
	return tonumber(_tWorldArenaInfo.signup_bgn_time)
end

--[[
	@des 	: 报名结束时间
	@param 	: 
	@return : num
--]]
function getSignUpEndTime(  )
	return tonumber(_tWorldArenaInfo.signup_end_time)
end

--[[
	@des 	: 攻打开始时间
	@param 	: 
	@return : num
--]]
function getAttackStartTime( )
	return tonumber(_tWorldArenaInfo.attack_bgn_time)
end

--[[
	@des 	: 攻打结束时间
	@param 	: 
	@return : num
--]]
function getAttackEndTime(  )
	return tonumber(_tWorldArenaInfo.attack_end_time)
end

--[[
	@des 	: 活动结束时间
	@param 	: 
	@return : num
--]]
function getWorldArenaEndTime(  )
	return tonumber(_tWorldArenaInfo.period_end_time)
end

--[[
	@des 	: 得到我的报名时间 0是没报名
	@param 	: 
	@return : num
--]]
function getMySignUpTime(  )
	return tonumber(_tWorldArenaInfo.signup_time)
end

--[[
	@des 	: 设置我的报名时间
	@param 	: 
	@return : 
--]]
function setMySignUpTime( nTime )
	_tWorldArenaInfo.signup_time = nTime
end

--[[
	@des 	: 得到上次更新战斗力时间
	@param 	: 
	@return : num
--]]
function getlastUpdateFightForceTime(  )
	local retData = 0 
	if( not table.isEmpty(_tWorldArenaInfo.extra) )then
		retData = tonumber(_tWorldArenaInfo.extra.update_fmt_time)
	end
	return retData
end

--[[
	@des 	: 设置上次更新战斗力时间
	@param 	: 
	@return : 
--]]
function setlastUpdateFightForceTime( nTime )
	if( not table.isEmpty(_tWorldArenaInfo.extra) )then
		_tWorldArenaInfo.extra.update_fmt_time = nTime
	else
		_tWorldArenaInfo.extra = {}
		_tWorldArenaInfo.extra.update_fmt_time = nTime
	end
end

--[[
	@des 	: 得到活动是否开启
	@param 	: 
	@return : true or false
--]]
function getworldArenaIsOpen(  )
	local bOpen = false
	local curTime = TimeUtil.getSvrTimeByOffset(0)
	local startTime = getSignUpStartTime()
	if( tonumber(_tWorldArenaInfo.team_id) > 0 and tonumber(_tWorldArenaInfo.room_id) > 0 and curTime >= startTime )then
		bOpen = true
	end
	return bOpen
end

--[[
	@des 	: 得到活动配置
	@param 	: 
	@return : 
--]]
function getworldArenaConfig(  )
	local configData = ActivityConfigUtil.getDataByKey("worldarena").data[1]
	return configData
end

--[[
	@des 	: 得到报名需要的等级
	@param 	: 
	@return : num
--]]
function getworldArenaNeedLv(  )
	local configData = getworldArenaConfig()
	return tonumber(configData.level)
end

--[[
	@des 	: 得到更新战斗力的cd
	@param 	: 
	@return : num
--]]
function getUpdateFightForceCD(  )
	local configData = getworldArenaConfig()
	return tonumber(configData.update_time)
end

--[[
	@des 	: 得到最后10分钟挑战的cd
	@param 	: 
	@return : num
--]]
function getFightCDLastTen(  )
	local configData = getworldArenaConfig()
	local retNum = 0
	if( configData.fight_time )then
		retNum = tonumber(configData.fight_time)+2
	end
	return retNum
end

--[[
	@des 	: 得到上次主动挑战的时间
	@param 	: 
	@return : num
--]]
function getLastAttackTime( ... )
	return tonumber(_tWorldArenaInfo.extra.last_attack_time) 
end

--[[
	@des 	: 得到是否在最后10分钟
	@param 	: 
	@return : ture or false
--]]
function getIsInLastTen()
	local bInLast = false
	if( TimeUtil.getSvrTimeByOffset(0) >= tonumber(_tWorldArenaInfo.attack_end_time)- tonumber(_tWorldArenaInfo.cd_duration_before_end) and
		TimeUtil.getSvrTimeByOffset(0) < tonumber(_tWorldArenaInfo.attack_end_time) )then
		bInLast = true
	end
	return bInLast
end

-- 获取挑战cd
function getAtkCD( ... )
	local atkCd = 0
	if getIsInLastTen() then
		local curTime = TimeUtil.getSvrTimeByOffset(0)
		local needCD = getFightCDLastTen()
		local lastAtkTime = getLastAttackTime()
		atkCd = lastAtkTime + needCD - curTime
		if atkCd <=0 then
			atkCd = 0
		end
		return atkCd
	end
	return atkCd
end

-- 获取自己的保护时间
function getProtectCd( )
	local protectCd = 0
	local configDb = getworldArenaConfig()
	local db_protect_time = tonumber(configDb.protect_time)
	local curTime = TimeUtil.getSvrTimeByOffset(0)
	local lastAtkTime = getLastAttackTime()
	protectCd = db_protect_time + lastAtkTime - curTime
	if protectCd <= 0 then
		protectCd = 0
	end
	return protectCd
end

--[[
	@des 	: 得到购买挑战最大次数
	@param 	: 
	@return : num
--]]
function getBuyAtkMaxNum()
	local configData = getworldArenaConfig()
	local costStr = string.split(configData.buy_num, ",")
	local temp = string.split(costStr[#costStr], "|")
	local retData = tonumber(temp[1])
	return retData
end

--[[
	@des 	: 得到购买挑战次数花费
	@param 	: nBuyNum 购买次数
	@return : num
--]]
function getBuyAtkNumCost( nBuyNum )
	local configData = getworldArenaConfig()
	local haveBuyNum = getHaveBuyAtkNum() or 0
	local costStr = string.split(configData.buy_num, ",")

	local retCost = 0
	for i=1,nBuyNum do
		local nextNum = haveBuyNum + i
		for i=1,#costStr do
			local temp = string.split(costStr[i], "|")
			if( nextNum <= tonumber(temp[1]) )then
				retCost = retCost + tonumber(temp[2])
				break
			end
		end
	end
	logger:debug({retCostGold = {retCost = retCost, nBuyNum =nBuyNum }})
	return retCost
end

--[[
	@des 	: 得到剩余挑战次数
	@param 	: 
	@return : num
--]]
function getAtkNum(  )
	return tonumber(_tWorldArenaInfo.extra.atk_num) or 0
end

--[[
	@des 	: 设置剩余挑战次数
	@param 	: 
	@return : 
--]]
function setAtkNum( nAtkNum )
	_tWorldArenaInfo.extra.atk_num = nAtkNum
end

--[[
	@des 	: 得到已购买挑战次数
	@param 	: 
	@return : num
--]]
function getHaveBuyAtkNum(  )
	return tonumber(_tWorldArenaInfo.extra.buy_atk_num)
end

--[[
	@des 	: 设置已购买挑战次数
	@param 	: 
--]]
function setHaveBuyAtkNum( nBuyAtkNum )
	_tWorldArenaInfo.extra.buy_atk_num = nBuyAtkNum
end

--[[
	@des 	: 得到银币重置下次花费
	@return : num
--]]
function getNextResetCostBySilver()
	local configData = getworldArenaConfig()
	local costStr = string.split(configData.silver_recover, ",")
	local curNum = getHaveResetNumBySilver()
	local nextNum = curNum + 1
	local retCost = 0
	for i=1,#costStr do
		local temp = string.split(costStr[i], "|")
		if( nextNum <= tonumber(temp[1]) )then
			retCost = tonumber(temp[2])
			break
		end
	end
	logger:debug({retCostSilver = retCost})
	return retCost
end

--[[
	@des 	: 得到银币重置最大次数
	@param 	:  
	@return : num
--]]
function getMaxResetNumBySilver()
	local configData = getworldArenaConfig()
	local costStr = string.split(configData.silver_recover, ",")
	local temp = string.split(costStr[#costStr], "|")
	local retMax = tonumber(temp[1])
	return retMax
end

--[[
	@des 	: 得到银币已重置次数
	@param 	: 
	@return : num
--]]
function getHaveResetNumBySilver(  )
	return tonumber(_tWorldArenaInfo.extra.silver_reset_num)
end

--[[
	@des 	: 设置银币已重置次数
	@param 	: 
	@return : 
--]]
function setHaveResetNumBySilver( nSilverResetNum )
	_tWorldArenaInfo.extra.silver_reset_num = nSilverResetNum
end

--[[
	@des 	: 得到金币重置下次花费
	@param 	: p_num 
	@return : num
--]]
function getNextResetCostByGold()
	local configData = getworldArenaConfig()
	local costStr = string.split(configData.gold_recover, ",")
	local curNum = getHaveResetNumByGold()
	local nextNum = curNum + 1
	local retCostGold = 0
	for i=1,#costStr do
		local temp = string.split(costStr[i], "|")
		if( nextNum <= tonumber(temp[1]) )then
			retCostGold = tonumber(temp[2])
			break
		end
	end
	logger:debug({retCostGold = retCostGold})
	return retCostGold
end

--[[
	@des 	: 得到金币已重置次数
--]]
function getHaveResetNumByGold( )
	return tonumber(_tWorldArenaInfo.extra.gold_reset_num)
end

--[[
	@des 	: 设置金币已重置次数
--]]
function setHaveResetNumByGold( nGoldResetNum )
	_tWorldArenaInfo.extra.gold_reset_num = nGoldResetNum
end

--[[
	@des 	: 得到攻击跳过数据
--]]
function getSkipData( ... )
	return _bSkip
end

--[[
	@des 	: 设置攻击跳过数据
	@param 	: false不跳过 true是跳过 
--]]
function setSkipData( bSkip )
	_bSkip = bSkip or false
end


--[[
	@des 	: 得到我的击杀数
--]]
function getMyKillNum( )
	return tonumber(_tWorldArenaInfo.extra.kill_num) 
end

--[[
	@des 	: 得到我的当前连杀数
--]]
function getMyCurContiNum(  )
	return tonumber(_tWorldArenaInfo.extra.cur_conti_num) 
end

--[[
	@des 	: 得到我的最大连杀数
--]]
function getMyMaxContiNum(  )
	return tonumber(_tWorldArenaInfo.extra.max_conti_num)
end

--[[
	@des 	: 得到四个人的信息
--]]
function getPlayer()
	if( table.isEmpty(_tWorldArenaInfo.extra) )then
		return {}
	end

	local retData = {}
	local myInfo = nil
	local tempInfo = {}
	local playerInfo = _tWorldArenaInfo.extra.player
	for k,v in pairs(playerInfo) do
		v.rank = tonumber(k)
		if(tonumber(v.self) == 1)then
			myInfo = v
		else
			table.insert(tempInfo,v)
		end
	end

	-- 排名从大到小
	local sortCallFun = function ( data1, data2 )
		return tonumber(data1.rank) < tonumber(data2.rank)
	end
	table.sort( tempInfo, sortCallFun )

	for i=1,#tempInfo do
		tempInfo[i].index = i
		table.insert(retData,tempInfo[i])
	end
	myInfo.index = 4
	table.insert(retData,myInfo)

	return retData
end


--[[
	@des 	: 得到挑战胜利将
	@param 	: p_winReward 后端返回胜利奖
	@return : 
--]]
function getRewardData( p_reward )
	local temp = {}
	for k,v in pairs(p_reward) do
		local tab = {}
		tab.type = v[1]
		tab.tid  = v[2]
		tab.num  = v[3]
		table.insert(temp,tab)
	end

	local retData = ItemUtil.getItemsDataByStr(nil,temp)

	return retData
end

--[[
	@des 	: 得到我自己的pid
--]]
function getMyPid()
	local pid = UserModel.getPid()
	return tonumber(pid)
end

--[[
	@des 	: 得到我自己的serverId
--]]
function getMyServerId()
	local serverId = UserModel.getServerId()
	return tonumber(serverId)
end


--[[
	@des 	: 得到是否显示入口按钮
--]]
function isShowBtn()
	local isShow = false
	-- 活动开没开
	local isOpen = ActivityConfigUtil.isActivityOpen("worldarena")

	if( isOpen and not table.isEmpty(_tWorldArenaInfo) and 
		tonumber(_tWorldArenaInfo.team_id) > 0  and
		TimeUtil.getSvrTimeByOffset(0) >= tonumber(_tWorldArenaInfo.signup_bgn_time) and
		TimeUtil.getSvrTimeByOffset(0) < tonumber(_tWorldArenaInfo.period_end_time) )  then 
		-- 活动开了，有分组，到报名时间了
		isShow = true
	end
	return isShow
end

-- 获取未报名玩家的操作等级限制
function getNoSignPlayerLevel( ... )
	return tonumber(getworldArenaConfig().nosign_player_level)
end

-- 获取未报名玩家是否可以进行操作
-- 等级是否够
function getNoSignPlayerCanOpt(  )
	return UserModel.getAvatarLevel() >= getNoSignPlayerLevel()
end

--[[
	@des 	: 加奖励
--]]
function addRewardData( p_reward )
	for k,v in pairs(p_reward) do
		local rewardData = getRewardData(v)
		ItemUtil.addRewardByTable( rewardData )
	end
end

--[[
	@des 	: 报名时间内，若该玩家满足报名条件，且他未报名时，则该玩家每次登录时，主界面的“跨服争霸赛”按钮会有红点提示，当玩家点击进入并返回主界面后，此红点提示消失，玩家再次上线后可看到此红点提示。
--]]
local isIn = nil
function isShowSigupRedTip()
	local isShow = false
	-- 活动开没开
	local isOpen = ActivityConfigUtil.isActivityOpen("worldarena")
	if( isOpen and not table.isEmpty(_tWorldArenaInfo) and 
		tonumber(_tWorldArenaInfo.team_id) > 0  and tonumber(_tWorldArenaInfo.room_id) > 0 and
		TimeUtil.getSvrTimeByOffset(0) >= tonumber(_tWorldArenaInfo.signup_bgn_time) and
		TimeUtil.getSvrTimeByOffset(0) < tonumber(_tWorldArenaInfo.signup_end_time) 
		and tonumber(_tWorldArenaInfo.signup_time) <= 0 and isIn == nil ) then
		-- 活动开了,有分组,在报名时间内,没有报名,没有进入巅峰对决界面,级别够参加
		local needLv = WorldArenaMainData.getworldArenaNeedLv()
		if( needLv <= UserModel.getHeroLevel() )then
			isShow = true
		end
	end
	return isShow
end

--[[
	@des 	: 是否进入主界面
--]]
function setIsIn( p_isIn )
	isIn = p_isIn
end


--[[
	@des 	: 免费次数小红点
--]]
function isShowFreeNumRedTip()
	local isShow = false
	local isOpen = ActivityConfigUtil.isActivityOpen("worldarena")
	if( isOpen and not table.isEmpty(_tWorldArenaInfo) and 
		tonumber(_tWorldArenaInfo.team_id) > 0 and tonumber(_tWorldArenaInfo.room_id) > 0 and
		TimeUtil.getSvrTimeByOffset(0) >= tonumber(_tWorldArenaInfo.attack_bgn_time) and
		TimeUtil.getSvrTimeByOffset(0) < tonumber(_tWorldArenaInfo.attack_end_time) 
		and tonumber(_tWorldArenaInfo.signup_time) > 0 and isIn == nil ) then
		-- 活动开了,有分组,在攻击时间内,有报名,没有进入巅峰对决界面,有免费挑战次数
		local haveBuyNum = getHaveBuyAtkNum()
		local subNum = getAtkNum()
		if( subNum-haveBuyNum > 0 )then
			isShow = true
		end
	end
	return isShow
end

--[[
	@des 	: 主界面按钮小红点
--]]
function isShowRedTip()
	local isShow = false
	-- 报名小红点
	local isShowSigup = isShowSigupRedTip()
	local isShowFree = isShowFreeNumRedTip()
	if( isShowSigup or isShowFree )then
		isShow = true
	end
	return isShow
end

