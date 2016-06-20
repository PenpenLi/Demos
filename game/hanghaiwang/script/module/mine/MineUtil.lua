-- FileName: MineUtil.lua
-- Author: huxiaozhou
-- Date: 2015-06-02
-- Purpose: 资源矿工具类
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("MineUtil", package.seeall)

require "script/module/mine/MineModel"
require "db/DB_Normal_config"

local _dbNormalConfig = DB_Normal_config.getDataById(1) -- normalconfig 配置
local _fMineRatio = _dbNormalConfig.res_ratio 	 -- 5*10^-5 -- 资源矿系数
local _fMineWoodRatio = _dbNormalConfig.res_wood_ratio  -- 资源矿木材系数
local _resPlayerLv = _dbNormalConfig.resPlayerLv
local _nLevel = math.max(30, UserModel.getAvatarLevel()) -- 玩家等级修正
local m_i18n = gi18n

local _nRatio = 10000000

--[[
	规则： 如果自己占有一个普通或者高级矿，则不能进行协助，
		  如果已经进行了协助，则不能进行占矿
--]]
-- 是否可以占矿
function hasNormal( )
	local tSelfInfo = MineModel.getSelfInfo()
	logger:debug(tSelfInfo)
	if table.isEmpty(tSelfInfo.tNormal) then
		return false
	end
	return true
end

--是否可以抢金矿 因金币区的矿不需要协助 不需要判断协助的方法
function hasGold( )
	local tSelfInfo = MineModel.getSelfInfo()
	if table.isEmpty(tSelfInfo.tGold) then
		return false
	end
	return true
end

-- 是否可以协助
function hasGuard(  ) 
	local tSelfInfo = MineModel.getSelfInfo()
	logger:debug(tSelfInfo)
	if table.isEmpty(tSelfInfo.tHelp) then
		return false
	end
	return true
end

-- 判断一个矿点协助军是否已满 如果已经满了就不能进行协助了
function isGuardMax( tPitInfo)
	local tGurad = tPitInfo.arrGuard
	if not tPitInfo.res_attr then
		local db_data = DB_Res.getDataById(tPitInfo.domain_id)
		tPitInfo.res_attr = string.split(db_data["res_attr" .. tPitInfo.pit_id], ",")
	end
	local max = tPitInfo.res_attr[3]
	logger:debug({tPitInfo = tPitInfo})
	return tonumber(max) <= table.count(tGurad)
end

-- 获取某个pit 的协助军数量
function hasGuarder(tPitInfo)
	local tGurad = tPitInfo.arrGuard
	return table.count(tGurad)==0
end

-- 判断当前时间是否在需要额外花费20金币的时间段内
-- 在 23点 到 早上9点需要额外花费20gold 去抢夺 金币区资源
function getExtraGold(  )
	local tUserInfo = UserModel.getUserInfo()
	local tArrTime = tUserInfo.timeConf.mineral
	local strStart = tArrTime[1]
	local strEnd = tArrTime[2]

	local timeIntervalStart = TimeUtil.getIntervalByTime(strStart)
	local timeIntervalEnd = TimeUtil.getIntervalByTime(strEnd)
	local timeIntervalNow = TimeUtil.getSvrTimeByOffset()

	-- zhangqi, 2016-02-22, timeIntervalNow 是一个时区无关的时间戳
	-- 但是 timeIntervalStart 和 timeIntervalEnd 表示服务器当天某个时间的时间戳，和服务器时区有关
	-- 需要转换为时区无关的标准时间戳再和 timeIntervalNow 进行比较
	local absTvStart = TimeUtil.standTimestamp(timeIntervalStart)
	local absTvEnd = TimeUtil.standTimestamp(timeIntervalEnd)
	
	if (timeIntervalNow >= absTvStart) and (timeIntervalNow <= absTvEnd) then
		return 0 ,false -- 从09：00：00 到 23：00：00  不用额外花费金币
	else
		return 20, true -- 固定值 20gold
	end
end


-- 协助军收入=int【 资源矿游戏币基础值*协助时间*资源矿系数*(玩家等级+资源矿玩家等级修正)*协助军收入系数/100*（1+城池资源矿增益/10000）】
-- 资源矿系数 =5*10^-5
-- 玩家等级=max（30，玩家实际等级）
-- int【】内向上取整
-- 协助军或得奖励贝里计算
-- tPit: 矿坑信息
-- nTime: 协助时间
function guardBelly(tPit, nTime)
	local baseBelly = tPit.res_attr[1] 	--资源矿游戏币基础值
	local guardTime = nTime or 0		--协助时间
	local helpArmyIncomeRatio = _dbNormalConfig.helpArmyIncomeRatio --协助军收入系数
	return math.ceil((baseBelly*guardTime*_fMineRatio*(_nLevel+_resPlayerLv)*helpArmyIncomeRatio)/100/_nRatio)
end

--协助军木材收入=int【 资源矿木材基础值*协助时间*资源矿木材系数*10^-7*协助军收入系数/100】
function guardWood( tPit, nTime )
	local baseWood = tPit.res_attr[4] 	--资源矿游戏币基础值
	local guardTime = nTime or 0		--协助时间
	local helpArmyIncomeRatio = _dbNormalConfig.helpArmyIncomeRatio --协助军收入系数
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 1 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	return math.ceil((baseWood*guardTime*_fMineWoodRatio*helpArmyIncomeRatio*multiplyRate)/100/_nRatio)
end

--占领者资源矿游戏币收益=int【 资源矿游戏币基础值*（占领时间+协助军协助时间总和*单个协助军收入增益/100）*资源矿系数*(玩家等级+资源矿玩家等级修正)*（1+城池资源矿增益/10000）】
-- 计算预估收益  预估收益 = int【 资源矿游戏币基础值*占领时间*资源矿系数*(玩家等级+资源矿玩家等级修正)】
function getMineBelly( tPit, sec)
	local baseBelly = tPit.res_attr[1] 	--资源矿游戏币基础值
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 1 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	return math.ceil(multiplyRate * _fMineRatio*(_nLevel+_resPlayerLv)*sec*baseBelly/_nRatio)
end

-- 木材 预估收益 = int【 资源矿木材基础值*占领时间*资源矿木材系数】
function getMineWood( tPit, sec )
	local baseWood = tPit.res_attr[4] 	--资源矿木材基础值
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 1 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	return math.ceil(multiplyRate*_fMineWoodRatio*sec*baseWood/_nRatio)
end


-- 延期计算需要的时间等
function getDelayData(tPit)
	-- {hour = 8, nBelly = 99999, nCostPower = 5, nGold = 10},
	local tDelay = {}
	local resAddTime = _dbNormalConfig.resAddTime--"28800|0|5,57600|10|10,86400|20|15"--_dbNormalConfig.resAddTime
	local resArr = string.split(resAddTime, ",")

	if 	MineConst.MineInfoType.MINE_SELF == tPit.infoType  or 
		MineConst.MineInfoType.MINE_SELF_GOLD == tPit.infoType then 
		local num = tonumber(tPit.delay_times) or 0
		local sec = 0
		local power = 0
		local gold = 0
		local tTmp = {}
		for index, str in ipairs(resArr) do
			local temp = {}
			if index==1 then
				tTmp[index] = temp
			else
				local tt = string.split(str, "|")
				logger:debug("strwood = %s",str)
				if num==0 then
					sec = sec + tt[1]
					power = power + tt[3]
					gold = gold + tt[2]
				elseif(num==1) then
					local tt2 = string.split(resArr[index], "|")
					sec = tt[1]
					power = tt[3]+tt2[3]
					gold = tt[2]+tt2[2]
				else
					
				end
			
				temp.hour = sec/3600 
				temp.nBelly = getMineBelly(tPit, sec)
				temp.nCostPower = power
				temp.nGold = gold
				temp.nWood = getMineWood(tPit, sec)
				tTmp[index] = temp
			end
		end

		for i,v in ipairs(tTmp) do
			if not table.isEmpty(v) then
				table.insert(tDelay, v)
			end
		end
		for i=#tDelay+1,#tTmp do
			tDelay[i] = {}
		end
		tTmp = nil

	else
		local sec = 0
		local power = 0
		local gold = 0

		if MineConst.MineInfoType.MINE_NONE_GOLD == tPit.infoType or 
			MineConst.MineInfoType.MINE_OTHER_GOLD == tPit.infoType then -- 如果是金币区抢矿则需要多花费额外的金币
			gold = getGoldMineNeedGold()
		end


		for index, str in ipairs(resArr) do
			local tt = string.split(str, "|")
			local temp = {}
			sec = sec + tt[1]
			temp.hour = sec/3600 
			temp.nBelly = getMineBelly(tPit, sec)
			temp.nWood = getMineWood(tPit, sec)
			power = power + tt[3]
			temp.nCostPower = power
			gold = gold + tt[2]
			temp.nGold = gold
			tDelay[index] = temp
		end
 	end

	logger:debug(tDelay)
	return tDelay

end

-- 显示不显示工会加成
function getShowGCInCom( pit_id )
	local strLegion = _dbNormalConfig.res_silver_legionadd
	local count = MineModel.getSameGCCount(pit_id)
	logger:debug({count = count})
	logger:debug({strLegion = strLegion})
	if not count then
		return false
	else
		local arr = string.split(strLegion, ",")
		for i, str in ipairs(arr or {}) do
			local arrLegion = string.split(str, "|")
			if tonumber(count) == tonumber(arrLegion[1]) then
				local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 1 )/10000 -- 限时福利活动倍率
				logger:debug({multiplyRate = multiplyRate})
				return true, arrLegion[2]*multiplyRate
			end
		end
	end
	return false
end


-- 获取一个资源矿要显示的倒计时
function getPitOccupyTimeStr( tPitInfo )

	if not tPitInfo.delay_times then
		return TimeUtil.getTimeString(0)
	end

	local resAddTime = _dbNormalConfig.resAddTime
	local resArr = string.split(resAddTime, ",")
	local sec = 0
	local delayTimes = tonumber(tPitInfo.delay_times) + 1 -- 后端给得 从0 开始 
	for index, str in ipairs(resArr) do
		if index <= delayTimes then
			local tt = string.split(str, "|")
			sec = sec + tt[1]
		else
			break
		end
	end

	local count = tPitInfo.occupy_time + sec - TimeUtil.getSvrTimeByOffset()
	return  TimeUtil.getTimeString(count)
end

-- 获取已占领时间的百分比
function getPassPercent( tPitInfo, isHelper )
	isHelper = isHelper or false
	uid = uid or 0
	local resAddTime = _dbNormalConfig.resAddTime
	local resArr = string.split(resAddTime, ",")
	local sec = 0 	-- 矿主总时间
	local hSec = 0 	-- 协助军总时间
	local delayTimes = tonumber(tPitInfo.delay_times) + 1 -- 后端给得 从0 开始 
	for index, str in ipairs(resArr) do
		if index <= delayTimes then
			local tt = string.split(str, "|")
			sec = sec + tt[1]
			if (hSec == 0) then
				hSec = sec
			end
		else
			break
		end
	end
	-- 协助军显示的时间判断
	local beginTime = tPitInfo.occupy_time
	if (isHelper) then
		local info = MineModel.getHelperInfo(tPitInfo.arrGuard, UserModel.getUserUid())
		local hbeginTime = tonumber(info.guard_time)

		local remainTime = beginTime + sec - TimeUtil.getSvrTimeByOffset()	-- 矿主剩余时间
		local hremainTime = hbeginTime + hSec - TimeUtil.getSvrTimeByOffset()	-- 协助军剩余时间
		-- 矿主剩余 > 协助军剩余，则使用协助军时间倒计时；否则用矿主时间倒计时
		if (remainTime > hremainTime) then
			beginTime = hbeginTime
			sec = hSec
		end
	end
	local count = math.max(beginTime + sec - TimeUtil.getSvrTimeByOffset(), 0)
	if (count > sec) then
		count = sec
	end
	return (1 - count / sec) * 100, TimeUtil.getTimeString(count)
end

-- 获取抢夺协助军需要的体力
function getRobGuardNeedPower( ... )
	return tonumber(_dbNormalConfig.lootHelpArmyCostExection)
end

-- 获取金币区开启条件
function getGoldMineNeedVip(  )
	local resPlayerVip = _dbNormalConfig.resPlayerVip
	return tonumber(resPlayerVip)
end

--金币矿区花费金币
function getGoldMineNeedGold(  )
	local goldResCost = _dbNormalConfig.goldResCost
	return tonumber(goldResCost)
end

-- 资源区的描述 
-- return: xx区xx号
-- ex.普通区12号
function getDomainDescribe( domainId )
	local area = MineModel.convertDomainToArea(tostring(domainId))	-- 区域
	local page = MineModel.convertDomainToPage(tostring(domainId))	-- 号
	--local tbAreas = {"高级区", "普通区", "金币区"}
	local areaDes = ""
	local db_res = DB_Res
	for k, info in pairs(db_res.Res) do
		local data = db_res.getDataById(info[1])
		if (area == data.type) then	-- 指定区域
			areaDes = data.name
		end
	end
	return areaDes, ""..tostring(page)..m_i18n[5674]
end

-- 矿坑类型的描述
function getMineTypeDescribe( type )
	local tbDatas = {}
	local db_res = DB_Res
	for k, info in pairs(db_res.Res) do
		local data = db_res.getDataById(info[1])
		for i = 1, 5 do
			if (tonumber(data["res_type"..i]) == tonumber(type)) then
				return data["res_name"..i]
			end
			--tbDatas[tonumber(data["res_type"..i])] = data["res_name"..i]
		end
	end
	return " "--tbDatas[tonumber(type)]
	--local tbNames = {"铁矿", "银矿", "金矿", "宝石矿", "", "蓝宝石矿", "钻石矿"}
	--return tbNames[type]
end

-- 获取对应矿坑的矿类型
function getMineType( domainId, pitId )
	local tbDatas = {}
	local db_res = DB_Res
	for k, info in pairs(db_res.Res) do
		local data = db_res.getDataById(info[1])
		-- 指定矿区
		if (data.id == tonumber(domainId)) then
			for i = 1, 5 do
				-- 指定矿坑
				if (i == tonumber(pitId)) then
					return tonumber(data["res_type"..i])
				end
			end
		end
	end
end


