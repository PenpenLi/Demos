-- FileName: ImpelDownMainModel.lua
-- Author: Xufei
-- Date: 2015-09-09
-- Purpose: 深海监狱主界面模块 数据
--[[TODO List]]

module("ImpelDownMainModel", package.seeall)
require "db/DB_Tower"
require "db/DB_Tower_layer"

-- UI控件引用变量 --

-- 模块局部变量 --
local _impelDownInfo = {}
local _dbTower = {}
local _idNowTowerLayer = 1
local _totalNumOfLayer = nil
local _totalNumOfWarLayer = nil
local _highestWarLayerId = nil
local _isCanRefreshView = false
local _isAllHaveDone = false

local timeCompensation = 0

-- 设置后端的初始化信息
function setImpelDownInfo( infoReturn )
	_impelDownInfo = infoReturn


	-- require "script/utils/TimeUtil"
	-- local nowTime = TimeUtil.getSvrTimeByOffset()
	-- timeCompensation = _impelDownInfo.curServerTime - nowTime
	-- logger:debug({timeCompensation=timeCompensation})
end

-- 获得历史最高战绩
function getTopGrade( ... )
	return tonumber(_impelDownInfo.max_level)
end

-- 获得当前所在层数，要先调用setNowTowerLayerId
function getNowTowerLayerId( ... )
	return _idNowTowerLayer
end

-- 获得cur_level
function getCurLevel( ... )
	return tonumber(_impelDownInfo.cur_level)
end

-- 获得剩余的可重置的次数
function getRemainCanResetTimes( ... )
	local total = tonumber(getNumDailyCanReset())
	return total - tonumber(_impelDownInfo.used_reset_num)
end

-- 获得已经挑战失败的次数
function getUsedFailedNum( ... )
	return tonumber(_impelDownInfo.used_atk_num)
end

-- 获得剩余挑战次数
function getRemainChance( ... )
	local totalNum = getFreeLoseTimes() + getBuyChanceTimes()
	local usedFailedNum = getUsedFailedNum()
	if (usedFailedNum>=totalNum) then
		return 0
	else
		return totalNum - usedFailedNum
	end
end

-- 获得购买过几次挑战机会
function getBuyChanceTimes( ... )
	return tonumber(_impelDownInfo.buy_atk_num)
end

-- 判断是否在扫荡过程中
function isSweeping( ... )
	if (not table.isEmpty(_impelDownInfo.sweepInfo)) then
		return true
	else
		return false
	end
end

-- 获得扫荡开始的时间
function getWhenStartSweep( ... )
	if (isSweeping()) then
		return tonumber(_impelDownInfo.sweepInfo.start_time)
	end
end

-- 获得扫荡的结束时间
function getWhenEndSweep( ... )
	if (not isSweeping()) then
		return 0 
	else
		return tonumber(_impelDownInfo.sweepInfo.plan_end_time)
	end
end

-- 获得扫荡开始的层数
function getLayerSweepStartOn( ... )
	return tonumber(_impelDownInfo.cur_level)
end

-- 获得扫荡的结束层数
function getLayerSweepEndBy( ... )
	if (isSweeping()) then
		return tonumber(_impelDownInfo.sweepInfo.plan_end_lv)
	else
		return tonumber(_impelDownInfo.max_level)
	end
end

-- 判断是否有奖励未领取
function isNoGainSweepReward( ... )
	if (not table.isEmpty(_impelDownInfo.noGainSweepReward)) then
		return true
	else
		return false
	end
end

-- 获得扫荡奖励的开始层
function getSweepRewardStartLv( ... )
	if (isNoGainSweepReward()) then
		return tonumber(_impelDownInfo.noGainSweepReward.start_lv)
	end
end

-- 获得扫荡奖励的结束层
function getSweepRewardEndlv( ... )
	if (isNoGainSweepReward()) then
		return tonumber(_impelDownInfo.noGainSweepReward.end_lv)
	end	
end

-- 判断是否有免费的重置次数
function isHasFreeRefresh( ... )
	if (tonumber(_impelDownInfo.used_reset_num) == 0) then
		return true
	else
		return false
	end
end

-- 恢复重置次数。（在零点时）
function resetRefreshTimes( ... )
	_impelDownInfo.used_reset_num = 0
end

-------------------------------
-- 设置当前所在层数，无参数时，设置为后端传来的数值
function setNowTowerLayerId( nowLayer )
	-- 判断是否全部打完领完
	if (tonumber(_impelDownInfo.cur_level) == 0 or tonumber(_impelDownInfo.cur_level)>getTotalNumOfLayer()) then
		_impelDownInfo.cur_level = getTotalNumOfLayer()
		_idNowTowerLayer = getTotalNumOfLayer()
		setAllHaveDone()
	else
		setNotAllHaveDone()
		if (nowLayer) then
			_idNowTowerLayer = nowLayer
		elseif (isSweeping()) then
			local nowLayer = countNowLayerBySweep()
			if (nowLayer ~= getNowTowerLayerId()) then
				_idNowTowerLayer = nowLayer
				GlobalNotify.postNotify("UPDATE_IMPEL_TOWER_LEVEL")
			end
		else
			_idNowTowerLayer = tonumber(_impelDownInfo.cur_level)
		end
	end
end

-- 战斗胜利更新数据
function updateDataWhenWinBattle( ... )
	if (tonumber(_impelDownInfo.cur_level) > tonumber(_impelDownInfo.max_level)) then
		_impelDownInfo.max_level = tonumber(_impelDownInfo.max_level) + 1
	end

	if (tonumber(_impelDownInfo.cur_level) < getTotalNumOfLayer()) then
		_impelDownInfo.cur_level = tonumber(_impelDownInfo.cur_level) + 1
	else
		_impelDownInfo.cur_level = 0
	end
end

-- 战斗失败更新数据
function updateDataWhenLoseBattle( ... )
	_impelDownInfo.used_atk_num = tonumber(_impelDownInfo.used_atk_num)+1
end

-- 领取宝箱后更新数据
function updateDataWhenGetBox( ... )
	if (tonumber(_impelDownInfo.cur_level) > tonumber(_impelDownInfo.max_level)) then
		_impelDownInfo.max_level = tonumber(_impelDownInfo.max_level) + 1
	end

	if (tonumber(_impelDownInfo.cur_level) < getTotalNumOfLayer()) then
		_impelDownInfo.cur_level = tonumber(_impelDownInfo.cur_level) + 1
	else
		_impelDownInfo.cur_level = 0
	end
end

-- 购买挑战次数时更新数据
function updateDataWhenBuyFightTimes()
	_impelDownInfo.buy_atk_num = tonumber(_impelDownInfo.buy_atk_num)+1
end

-- 立即完成时更新数据
function updateDataWhenImmediateFinish( ... )
	_impelDownInfo.cur_level = getLayerSweepEndBy() + 1
end

-- 自动停止扫荡时更新数据
function updateDataWhenStopSweepAuto( )
	if (getLayerSweepEndBy() == getTotalNumOfLayer()) then
		_impelDownInfo.cur_level = 0
	else
		_impelDownInfo.cur_level = getLayerSweepEndBy() + 1
	end
	_impelDownInfo.sweepInfo = nil
end

-- 手动停止扫荡更新数据
function updateDataWhenStopSweep( nowLayer )
	_impelDownInfo.sweepInfo = nil
	if (nowLayer<getTotalNumOfLayer()) then
		_impelDownInfo.cur_level = nowLayer+1
	else
		_impelDownInfo.cur_level = 0
	end
end

-- 扫荡不足1层时更新数据
function updateDataWhenSweepNotEnoughTime( ... )
	_impelDownInfo.sweepInfo = nil
end

-- 领取扫荡奖励后更新数据
function updateDataWhenObtainReward( ... )
	_impelDownInfo.noGainSweepReward = nil
end

-- 重置时更新数据
function updateResetGameData( ... )
	_impelDownInfo.used_reset_num = tonumber(_impelDownInfo.used_reset_num) + 1
	_impelDownInfo.cur_level = 1
	_idNowTowerLayer = 1
	_impelDownInfo.sweepInfo = nil
	_impelDownInfo.used_atk_num = 0
	_impelDownInfo.buy_atk_num = 0
end 

-- 开始扫荡时更新数据
function updateDataWhenStartSweep( tbData )
	_impelDownInfo.cur_level = _idNowTowerLayer
	_impelDownInfo.sweepInfo = {}
	_impelDownInfo.sweepInfo.start_time = tbData.start_time
	_impelDownInfo.sweepInfo.plan_end_lv = getTopGrade()
	_impelDownInfo.sweepInfo.plan_end_time = tbData.plan_end_time
end

-- 接到扫荡完毕推送后更新数据
function updateDataWhenReceiveSweepEndPush( ... )
	_impelDownInfo.noGainSweepReward = {1,2} -- 让noGainSweepReward不为空
end

-------------------------------

-- 根据扫荡数据，计算当前层数
function countNowLayerBySweep( ... )
	require "script/utils/TimeUtil"
	local nowTime = TimeUtil.getSvrTimeByOffset()
	
	-- 前后端有时候计算不一致，考虑可能由于时间误差，在跳层时不一致
	nowTime = nowTime + timeCompensation

	local nowLayer
	local startTime = getWhenStartSweep()
	local startLayer = getLayerSweepStartOn()
	if (startLayer == getTotalNumOfLayer()) then
		nowLayer = getTotalNumOfLayer()
		_impelDownInfo.cur_level = getTotalNumOfLayer()
		_idNowTowerLayer = getTotalNumOfLayer()
		setAllHaveDone()
	else
		local startLayerInfo = getTowerDataByLevel(startLayer)
		local eachWarTime = getWipeCostTime()
		local diffTime
		if (nowTime < startTime) then
			diffTime = 0
		else
			diffTime = nowTime - startTime
		end
		local howManyWarLayer = math.floor( diffTime / eachWarTime )
		-- 如果从宝箱层开始，则跳过宝箱层
		if (startLayerInfo.type == 2) then
			startLayerInfo = getTowerDataByLevel(startLayer+1)
		end
		-- 开始层的战斗层id
		local startLayerWarId = startLayerInfo.fightId
		-- 当前层战斗层id
		local nowLayerWarId = startLayerWarId + howManyWarLayer
		logger:debug({howManyWarLayer =howManyWarLayer})
		if (nowLayerWarId>=getTotalWarLayer()) then
			nowLayerWarId = getTotalWarLayer()
		end
		-- 当前层的info
		logger:debug({nowLayerWarId = nowLayerWarId})
		local nowLayerInfo = DB_Tower_layer.getArrDataByField("fightId", nowLayerWarId)
		-- 当前层id
		nowLayer = nowLayerInfo[1][1]

		if (nowLayer > getTopGrade()) then
			nowLayer = getTopGrade()
		end

		nowLayerInfo = getTowerDataByLevel(nowLayer)

		if (nowLayerInfo.type == 2 and nowLayer < getTotalNumOfLayer()) then
			nowLayer = nowLayer + 1
		end
	end
	return nowLayer
end

-- 判断当前层是否能跳过
function ifThisLayerCanJump( thisLayerId )
	local topLayer = getTopGrade()
	return (topLayer>=thisLayerId)
end

--[[desc:计算当前层在视图中的位置
    arg1: 层数
    return: 返回1，2，3分别表示当前层在视图中的左中右三个位置  
—]]
function getLayerPosition( nowLayer )
	local remainder = nowLayer%3
	if (remainder == 0) then
		return 3
	else
		return remainder
	end
end

--[[desc:根据层数返回当前视图三个据点的数据
    arg1: 当前层数
    return: { index, info={}, isDead, isNowLayer }
—]]
function getNowViewInfo( nowLayer )
	local tbViewInfo = {}
	local function m_fnGetNowViewInfo( leftLayer )
		for i = leftLayer,leftLayer + 2  do
			local tb = {}
			tb.index = getLayerPosition(i)
			if (i == nowLayer) then
				tb.isNowLayer = 1
			else
				tb.isNowLayer = 0
			end
			if (i < nowLayer) then
				tb.isDead = 1
			else
				tb.isDead = 0
			end
			tb.info = getTowerDataByLevel(i)
			table.insert (tbViewInfo, tb)
		end
		table.sort (tbViewInfo, function (a, b)
			return a.index < b.index
		end)
		return tbViewInfo
	end
	local nowLayerPosition = getLayerPosition(nowLayer)
	return m_fnGetNowViewInfo( nowLayer - nowLayerPosition + 1 )
end

-------------------------------
-- 读取配置表tower数据
function setDbTowerData( ... )
	if (table.isEmpty(_dbTower)) then
		_dbTower = DB_Tower.getDataById(1)
	end
end

-- 获得每日可重置的次数
function getNumDailyCanReset( ... )
	setDbTowerData()
	return _dbTower[2]
end

-- 根据重置的次数，获取重置的花费，如超出次数，返回-1
function getResetCostByTimes( resetTimes )
	setDbTowerData()
	if (resetTimes > getNumDailyCanReset()) then
		return -1
	else 
		local tbConst = lua_string_split(_dbTower[3],",")
		return tonumber(tbConst[resetTimes])
	end
end

-- 获得免费失败的次数
function getFreeLoseTimes( ... )
	setDbTowerData()
	return _dbTower[4]
end

-- 根据失败的次数，获得购买挑战机会的花费
function getBuyChanceCostByLoseTimes( loseTimes )
	setDbTowerData()
	local timesOfBuy = table.count(lua_string_split(_dbTower[5],","))
	if (loseTimes <= getFreeLoseTimes()) then
		return 0
	elseif (loseTimes <= timesOfBuy + getFreeLoseTimes()) then
		return lua_string_split(_dbTower[5],",")[loseTimes-getFreeLoseTimes()]
	else
		return lua_string_split(_dbTower[5],",")[timesOfBuy]
	end
end

-- 得到每层的扫荡时间
function getWipeCostTime( ... )
	setDbTowerData()
	return _dbTower[6]
end

-- 得到立即完成扫荡，每层需要花费的金币数
function getWipeCostGold( ... )
	setDbTowerData()
	return _dbTower[7]
end

-- 得到立即完成扫荡需要花费的总金币数
function getImmediateFinishCost( ... )
	local startLayer = getNowTowerLayerId()
	local endLayer = getTopGrade()

	return getHowManyWarLayerBetweenId(startLayer,endLayer)*getWipeCostGold()
end

-- 获得扫荡的倒计时时间
function getCountdownString( ... )
	require "script/utils/TimeUtil"
	local nowTime = TimeUtil.getSvrTimeByOffset()
	local timeRemain = getWhenEndSweep() - nowTime - timeCompensation
	if (timeRemain > 0) then
		return TimeUtil.getTimeString(timeRemain), timeRemain
	else
		return "00:00:00", timeRemain
	end
end

-- 得到总共的塔层数
function getTotalNumOfLayer( ... )
	if (_totalNumOfLayer == nil) then
		_totalNumOfLayer = table.count(DB_Tower_layer.Tower_layer)
	end
	return _totalNumOfLayer
end

-- 获得总共的战斗层数
function getTotalWarLayer( ... )
	if (_totalNumOfWarLayer == nil) then
		local totalNumLayer = getTotalNumOfLayer()
		local layerInfo = nil
		for i=totalNumLayer, 1, -1 do
			layerInfo = getTowerDataByLevel(i)
			if (layerInfo.type == 1) then
				break
			end
		end
		_totalNumOfWarLayer = layerInfo.fightId
	end
	return _totalNumOfWarLayer 
end

-- 获得最高战斗层的id
function getHighestWarLayerId(  )
	if (_highestWarLayerId == nil) then
		local totalNumOfWarLayer = getTotalWarLayer()
		local layerInfo = DB_Tower_layer.getArrDataByField("fightId", totalNumOfWarLayer)
		_highestWarLayerId = layerInfo[1][1]
	end
	return _highestWarLayerId
end

-- 计算两层之间有多少战斗层
function getHowManyWarLayerBetweenId( idLow, idHigh )
	local lowInfo = getTowerDataByLevel(idLow)
	if (idHigh<getTotalNumOfLayer()) then 
		idHigh = idHigh + 1 
	else
		idHigh = getTotalNumOfLayer()
	end
	local highInfo = getTowerDataByLevel(idHigh)
	local num = 0
	if (lowInfo.type == 2) then
		lowInfo = getTowerDataByLevel(idLow-1)
		num = num-1
	end
	if (highInfo.type == 2) then
		highInfo = getTowerDataByLevel(idHigh-1)
		num = num+1
	end
	return highInfo.fightId - lowInfo.fightId + num
end

-- 获得两层之间的奖励数组
function getRewardArrayById( leftId, rightId )
	local belly = 0
	local prison = 0
	local rewardString = {}
	local rewardIds = {}
	for i = leftId, rightId do
		local nowLayerInfo = getTowerDataByLevel(i)
		if (nowLayerInfo.type == 1) then
			belly = belly + nowLayerInfo.belly
			prison = prison + nowLayerInfo.prison
		elseif (nowLayerInfo.type == 2) then
			local stringReward = nowLayerInfo.items
			local tbRewardString = lua_string_split(stringReward, ",")
			for k,v in pairs(tbRewardString) do
				local tbReward = lua_string_split(v, "|")
				local rewardId = tbReward[1]
				local rewardCount = tbReward[2]
				if (not table.include(rewardIds, rewardId)) then
					table.insert(rewardIds, rewardId)
					rewardString[rewardId] = tonumber(rewardCount)
				else
					rewardString[rewardId] = rewardString[rewardId] + tonumber(rewardCount)
				end
			end
		end
	end
	local strReward = ""
	for k,v in pairs(rewardString) do
		local str = "7|" .. k .. "|" .. v
		strReward = strReward .. str .. ","
	end
	strReward = string.sub(strReward, 1, -2)

	logger:debug({
		leftId = leftId,
		rightId = rightId,
		rewardString = rewardString,
		belly= belly,
		prison = prison,
		strReward = strReward
		})
	local ret = {strReward = strReward,
		belly= belly,
		prison = prison}
	return ret
end

-- 判断id是否对应宝箱层，返回true，false
function isBoxLayerById( id )
	if (id > getTotalNumOfLayer() or id < 1) then
		return false
	else
		local layerInfo = getTowerDataByLevel(id)
		if (tonumber(layerInfo.type) == 1) then
			return false
		elseif(tonumber(layerInfo.type) == 2) then
			return true
		end
	end
end

-- 将配置表中的奖励字符串格式化为RewardUtil里的
function getRewardString( str )
	local stringRet = ""
	local strPrefix = "7|"
	local tbStr = lua_string_split(str, ",")
	for k,v in pairs(tbStr) do
		local strOneReward = strPrefix .. v
		stringRet = stringRet .. strOneReward .. ","
	end
	stringRet = string.sub(stringRet, 1, -2)
	
	return stringRet
end

-- 将普通id转化为战斗层数的id，若遇到宝箱层，则返回nil，若遇到0层，返回0
function getFightLayerIdByNormalId( normalId )
	local layerInfo
	if (normalId == 0) then
		return 0
	else
		layerInfo = getTowerDataByLevel(normalId)
		if (layerInfo.type == 2) then
			return nil
		elseif (layerInfo.type == 1) then
			return layerInfo.fightId
		end
	end
end

-- 根据id获取layerName
function getLayerNameById( id )
	local layerInfo = getTowerDataByLevel(id)
	return layerInfo.layerName
end

-- 根据扫荡结束层（包含）id获取提示语
function getEndSweepLayerName( id )
	local maxLayer = id
	local layerId
	if (maxLayer == getTotalNumOfLayer()) then
		layerId = maxLayer-1
	elseif (maxLayer < getTotalNumOfLayer()) then
		if (isBoxLayerById(maxLayer+1)) then
			if (maxLayer+1 == getTotalNumOfLayer()) then
				layerId = maxLayer
			else
				layerId = maxLayer+2
			end
		else
			layerId = maxLayer+1
		end
	end
	return getLayerNameById( layerId )
end

-- 根据id获取背景名称
function getBgNameById( nowLayerId )
	local info = getTowerDataByLevel(nowLayerId)
	return info.change_bg
end

--[[desc:获取是否需要显示难度提示
    arg1: 参数说明
    return: 判断本层的level_type，和上层的level_type，如果相同，则返回false,反之返回true
—]]
function isNeedShowDifficultyNotice( ... )
	local nowLv = getNowTowerLayerId()
	if (nowLv == 1) then
		logger:debug("isNeedShowDifficultyNotice return false")
		return false
	else
		local nowLvInfo = getTowerDataByLevel(nowLv)
		local lastLvInfo = getTowerDataByLevel(nowLv-1)
		if (nowLvInfo.level_type ~= lastLvInfo.level_type) then
			logger:debug("isNeedShowDifficultyNotice return true")
			return true
		elseif (nowLvInfo.level_class ~= lastLvInfo.level_class) then
			logger:debug("isNeedShowDifficultyNotice return true")
			return true
		else
			logger:debug("isNeedShowDifficultyNotice return false")
			return false
		end
	end
end

-- 获取本层的难度提示语特效Id和难度等级
function getDifficultyNoticeInfo( ... )
	local nowLv = getNowTowerLayerId()
	local nowLvInfo = getTowerDataByLevel(nowLv)
	local prisonId = nowLvInfo.level_type
	local diffiLv = nowLvInfo.level_class
	
	logger:debug({prisonId = prisonId, diffiLv=diffiLv})
	return prisonId, diffiLv
end

-- 根据层数获得塔信息
function getTowerDataByLevel( towerLevel )
	local towerLayerData = DB_Tower_layer.getDataById(towerLevel)
	return towerLayerData
end

-------------------------------
-- 将状态改为可以重新刷新界面
function setCanRefreshView( ... )
	_isCanRefreshView = true
end

-- 将状态改为不可以重新刷新界面
function setNotCanRefreshView( ... )
	_isCanRefreshView = false
end

-- 获取可否重新刷新界面
function getCanRefreshView( ... )
	return _isCanRefreshView 
end

-- 设置已经全部爬完塔
function setAllHaveDone()
	_isAllHaveDone = true
end

-- 设置没有全部爬完塔
function setNotAllHaveDone( ... )
	_isAllHaveDone = false
end

-- 获取是否全部爬完塔
function getIfAllHaveDone( ... )
	return _isAllHaveDone
end

-- 获取当前所在层和他的名字，如果是宝箱层则返回他的下一层，如果下一层大于最高层，则返回空
function getCurLvAndName( ... )
	local tbRet = {}
	local nowLayerId = getNowTowerLayerId()
	local nowLayerInfo = getTowerDataByLevel( nowLayerId )
	local nowLayerIsBox = isBoxLayerById( nowLayerId )
	if (not nowLayerIsBox) then
		tbRet.Effect = true
		tbRet.name = nowLayerInfo.layerName
		tbRet.layerId = nowLayerId
	elseif ( tonumber(nowLayerId) < tonumber(getTotalNumOfLayer()) ) then
		tbRet.Effect = true
		nowLayerId = nowLayerId + 1
		nowLayerInfo = getTowerDataByLevel( nowLayerId )
		tbRet.name = nowLayerInfo.layerName
		tbRet.layerId = nowLayerId
	else
		tbRet.Effect = false
	end

	logger:debug({Cul_level_info_for_strategy_impel = tbRet})
	return tbRet
end

-- 获取最高记录的层数并转化为战斗层id，如遇宝箱层则下降一层
function getTopGradeFightId( ... )
	if (not SwitchModel.getSwitchOpenState(ksSwitchImpelDown)) then
		return 0
	else
		local topGradeId = getTopGrade()
		local topGradeFightId = getFightLayerIdByNormalId(topGradeId)
		if (not topGradeFightId) then
			topGradeFightId = getFightLayerIdByNormalId(topGradeId - 1)
		end
		return topGradeFightId
	end
end

-------------------------------
local function init(...)

end

function destroy(...)
	package.loaded["ImpelDownMainModel"] = nil
end

function moduleName()
    return "ImpelDownMainModel"
end

function create(...)

end
