-- FileName: MainAstrologyModel.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose:占卜屋数据类
--[[TODO List]]

module("MainAstrologyModel", package.seeall)
require "script/module/astrology/MainAstrologyCtrl"
require "script/module/astrology/AstrologyRewardView"
require "script/module/astrology/MainAstrologyView"
require "script/module/astrology/AstrologyRewardCtrl"

m_tbAstrologyInfo  = nil      --占卜的信息，从后端拉取

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MainAstrologyModel"] = nil
end

function moduleName()
	return "MainAstrologyModel"
end

function create(...)

end

function resetView()
	if(not SwitchModel.getSwitchOpenState( ksSwitchStar)) then
		return
	end
	if (not MainAstrologyView.m_UIMain) then
		return 
	end

	function callBack(cbFlag, dictData, bRet)
		if(bRet)then

			local tbAstrologyInfo = dictData.ret
			setDiviInfo(tbAstrologyInfo)

			MainAstrologyView.updateAstroView()
			logger:debug(AstrologyRewardView.getMainLayer())
			if (AstrologyRewardView.getMainLayer() == nil) then
				return 
			end
			logger:debug("重置领奖界面数据")
			AstrologyRewardCtrl.resetDataInfo()
			AstrologyRewardView.initData()
			AstrologyRewardCtrl.reloadRewardView()

		end
	end
	RequestCenter.divine_getDiviInfo(callBack,CCArray:create())
end


function setDiviInfo( tbData )
	m_tbAstrologyInfo = tbData
	logger:debug(m_tbAstrologyInfo)
end

--判断是否需要红点显示
function hasRedPoint( ... )
	g_redPoint.diviStar.visible = false
	return 
	--删除占卜屋 2015-5-14
	-- local bNeed = false
	-- local canEnter = SwitchModel.getSwitchOpenState( ksSwitchStar , false)
	-- logger:debug(canEnter)
	-- if( canEnter == false ) then
	-- 	return
	-- end

	-- if(m_tbAstrologyInfo == nil ) then 
	-- 	return 
	-- end
	
	-- --已经占星次数
	-- if(m_tbAstrologyInfo ~= nil and tonumber(m_tbAstrologyInfo.divi_times) < 16) then

	-- 	g_redPoint.diviStar.visible = true
	-- 	return
	-- end
	-- --可领奖次数
	-- local nCanRewardCount = getCanRewardCount(m_tbAstrologyInfo)

	-- logger:debug(nCanRewardCount)

	-- if(m_tbAstrologyInfo ~= nil and tonumber(nCanRewardCount)  > 0 ) then

	-- 	g_redPoint.diviStar.visible = true
	-- 	return

	-- end

	-- g_redPoint.diviStar.visible = false
end

--从后端读取占卜的数据 然后是初始化界面
function createViewByGetAstrologyInfo()

	if(m_tbAstrologyInfo) then

		local layAstrology = MainAstrologyCtrl.create(m_tbAstrologyInfo)
		if layAstrology then
			LayerManager.changeModule(layAstrology, MainAstrologyCtrl.moduleName(), {1,3}, true)
			PlayerPanel.addForPublic()
		else
			logger:debug("layAstrology  nil")
		end
	else
		function callBack(cbFlag, dictData, bRet)
			if(bRet)then

				local tbAstrologyInfo = dictData.ret
				setDiviInfo(tbAstrologyInfo)

				local layAstrology = MainAstrologyCtrl.create(tbAstrologyInfo)
				if layAstrology then
					LayerManager.changeModule(layAstrology, MainAstrologyCtrl.moduleName(), {1,3}, true)
					PlayerPanel.addForPublic()
				else
					logger:debug("layAstrology  nil")
				end

			end
		end
		RequestCenter.divine_getDiviInfo(callBack,CCArray:create())
	end
end

--根据领奖步数 获取此次领奖物品信息
function getRewardInfoByStep()
	--是否有随机奖励
	local newreward 	= m_tbAstrologyInfo.va_divine.newreward or {}
	local dbAstrology 	= DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
	local nPriceStep  	= tonumber(m_tbAstrologyInfo.prize_step)
	local rewardInfo    = nil 
	if(table.count(newreward) <= 0)then
		local rewardArray = string.split(dbAstrology.reward_arr, ",")
		rewardInfo = rewardArray[nPriceStep+1]
	else
		--随机奖励的下表数组
		local rewardArray = m_tbAstrologyInfo.va_divine.newreward
		--一次读取十个随机奖励数据
		local randwardData = dbAstrology["randReward" .. (nPriceStep+1)]
		logger:debug(randwardData)
		--根据返回的下表读取奖励数据
		rewardInfo = lua_string_split(randwardData,",")[tonumber(rewardArray[nPriceStep+1]) + 1]
	end
	return rewardInfo
end

--获取每一次奖励的名字和个数
function getRewardNameAndNumByStep()
    local rewardInfo = getRewardInfoByStep()
    local rewardName  = ""
    local rewardNum = 0
    --判断奖励类型
	if("0"==lua_string_split(rewardInfo,"|")[1])then
		--贝里
		resultIcon = ItemUtil.getSiliverIconByNum()
		rewardName = gi18n[1520]
        rewardNum =  lua_string_split(rewardInfo,"|")[2]
	elseif("1"==lua_string_split(rewardInfo,"|")[1])then
		--金币
		rewardName = gi18n[2220]
        rewardNum = lua_string_split(rewardInfo,"|")[2]
	elseif("2"==lua_string_split(rewardInfo,"|")[1])then
		--经验石
        rewardName = gi18n[1087]
        rewardNum = lua_string_split(rewardInfo,"|")[2]
	elseif("3"==lua_string_split(rewardInfo,"|")[1])then
		--道具
		rewardName = ItemUtil.getItemById(lua_string_split(rewardInfo,"|")[2]).name
        rewardNum = 1
	end


	return rewardName ,rewardNum
end

--可领取奖励的次数
function getCanRewardCount()
	--ke领取奖励的次数
	local currentMaxPrize = 0
	local dbAstrology 	= DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
	local starArray =  lua_string_split(dbAstrology.star_arr,",")
	for i=1,#starArray do
		if(tonumber(starArray[i])<=tonumber(m_tbAstrologyInfo.integral))then
			currentMaxPrize = i
		end
	end
	local nleftPrizeTimes = (currentMaxPrize-tonumber(m_tbAstrologyInfo.prize_step)) or 0
	return nleftPrizeTimes
end

--增加一次领奖次数
function addRewardStep()
	--ke领取奖励的次数
	m_tbAstrologyInfo.prize_step = m_tbAstrologyInfo.prize_step + 1
end

--刷新一次奖励列表需要的金币数量
function getRefreshCostPrice( ... )
	--根据刷新所需的金币数刷新面边
	local tbDBVip = DB_Vip.getDataById(UserModel.getVipLevel() + 1) or {}

	local nRefreshBaseCost = string.split(tbDBVip.astrologyCost, "|")[2] or 0
	local nRefreshRiseCost = string.split(tbDBVip.astrologyCost, "|")[3] or 0
	
	local nRefreshPrice= nRefreshBaseCost + nRefreshRiseCost * m_tbAstrologyInfo.ref_prize_num

	return nRefreshPrice
end