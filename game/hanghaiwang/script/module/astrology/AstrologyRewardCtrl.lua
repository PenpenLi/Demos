-- FileName: AstrologyRewardCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose: 占卜屋奖励ctrl
--[[TODO List]]

module("AstrologyRewardCtrl", package.seeall)
require "script/module/astrology/AstrologyRewardView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_nPriceStep 			= 0 					--奖励次数
local m_tbAstrologyInfo 	= nil  			--占卜信息，存放于model里
local m_i18nString 			= gi18nString
local function init(...)
	m_nPriceStep = 0
end

function destroy(...)
	package.loaded["AstrologyRewardCtrl"] = nil
end

function moduleName()
	return "AstrologyRewardCtrl"
end
--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]

function resetDataInfo()
	m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo
	m_nPriceStep = tonumber(m_tbAstrologyInfo.prize_step)
	logger:debug("当前领到第几次奖励了%s___" ,m_nPriceStep)
end


function create()
	init()
	m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo
	m_nPriceStep = tonumber(m_tbAstrologyInfo.prize_step)

	local tbEventListener = {}
	--关闭按钮事件回调
	tbEventListener.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onClose clicked")
			AudioHelper.playCloseEffect()
			-- AstrologyRewardView.m_UIMain = nil
			LayerManager.removeLayout()
		end
	end
	--领奖按钮事件回调
	tbEventListener.onAcceptReWard = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.removeGuide()

			AudioHelper.playCommonEffect()

			local dbAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
			local starArray =  lua_string_split(dbAstrology.star_arr,",")
			m_nPriceStep = tonumber(m_tbAstrologyInfo.prize_step)

			if(m_nPriceStep >= 10 or tonumber(starArray[m_nPriceStep + 1]) > tonumber(m_tbAstrologyInfo.integral))then
				local sTips = m_i18nString(2317)
				logger:debug("当前无奖励可领取")
				--[2317] = "当前无奖励可领取",
				LayerManager.addLayout(UIHelper.createCommonDlg(sTips, nil, nil,1))
				return
			end

			--local rewardArray = nil
			local rewardInfo  = MainAstrologyModel.getRewardInfoByStep()

			if("3"==lua_string_split(rewardInfo,"|")[1])then
				local itemId = tonumber(lua_string_split(rewardInfo,"|")[2])
				logger:debug(itemId)
				require "script/module/public/ItemUtil"

				if(itemId >= 1000001 and itemId <= 5000000)then
					--装备碎片
					if(ItemUtil.isArmFragBagFull(true))then
						return
					else
						PreRequest.setBagDataChangedDelete(refreshPrizeDataFromBagDeleget)
					end

				elseif(itemId >= 50001 and itemId <= 60000) then
					-- 坐骑饲料类：50001~80000
					if(ItemUtil.isPropBagFull(true))then
						return
					else
						PreRequest.setBagDataChangedDelete(refreshPrizeDataFromBagDeleget)
					end
				elseif(itemId >= 40001 and itemId <= 50000) then
					-- -- 好感礼物类：100001~120000
					if(ItemUtil.isPropBagFull(true))then
						return
					else
						PreRequest.setBagDataChangedDelete(refreshPrizeDataFromBagDeleget)
					end
				elseif(itemId >= 400001 and itemId <= 500000) then
					-- 武将碎片类：
					PreRequest.setBagDataChangedDelete(refreshPrizeDataFromBagDeleget)
				elseif(itemId >= 100001 and itemId <= 200000) then
					-- -- 装备类：100001~120000
					if(ItemUtil.isEquipBagFull(true))then
						return
					else
						PreRequest.setBagDataChangedDelete(refreshPrizeDataFromBagDeleget)
					end
				end
			end
			logger:debug("star network request")
			RequestCenter.divine_drawPrize(drawPrizeCallback,Network.argsHandler(m_nPriceStep))
		end
	end
	--升级奖励按钮事件回调
	tbEventListener.onUpgradeReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onUpgradeRewarddddddddd clicked")
			AudioHelper.playCommonEffect()
			--可领取奖励的次数
			local currentMaxPrize = 0
			local dbAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
			local starArray =  lua_string_split(dbAstrology.star_arr,",")
			for i=1,#starArray do
				if(tonumber(starArray[i])<=tonumber(m_tbAstrologyInfo.integral))then
					currentMaxPrize = i
				end
			end

			--剩余的领奖次数
			local leftPrize = currentMaxPrize - m_nPriceStep
			if(leftPrize <= 0)then
				local function confirmUpgradeCallback()
					LayerManager:removeLayout()
					RequestCenter.divine_upgrade(upgradeCallback,CCArray:create())
				end

				local dlg1 = UIHelper.createCommonDlg(m_i18nString(2326),nil, confirmUpgradeCallback)
				LayerManager.addLayout(dlg1)
			else
				--[2320] = "领取完所有当前奖励后才可以升级",
				local sTips = m_i18nString(2320)
				LayerManager.addLayout(UIHelper.createCommonDlg(sTips, nil, nil,1))
			end
		end
	end
	--刷新奖励按钮事件回调
	tbEventListener.onRefresh = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onRefresh clicked")
			--音效
			AudioHelper.playCommonEffect()
			--剩余领奖次数
			local leftPrize = MainAstrologyModel.getCanRewardCount()
			local divi_times = tonumber(m_tbAstrologyInfo.divi_times)
			--奖励领完了
			if(m_nPriceStep >= 10 or (leftPrize <= 0 and divi_times >= 16 ))then
				--[2321] = "奖励已经全部领完，无法刷新",
				local sTips = m_i18nString(2321)
				LayerManager.addLayout(UIHelper.createCommonDlg(sTips, nil, nil,1))
				return
			end
			--金币不足
			local refreshPrice = MainAstrologyModel.getRefreshCostPrice()
			if(UserModel.getGoldNumber() < refreshPrice) then
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return
			end
			--没有刷新次数
			local tbDBVip = DB_Vip.getDataById(UserModel.getVipLevel() + 1) or {}
			local nRefreshTimes = string.split(tbDBVip.astrologyCost, "|")[1] or 0
			local nrefreshedTimes = m_tbAstrologyInfo.ref_prize_num

			if(nRefreshTimes - nrefreshedTimes > 0) then
				RequestCenter.divine_refPrize(refreshPrizeCallback,CCArray:create())
			else
				local sTips =m_i18nString(2322)
				--[2322] = "今天没有刷新次数了",
				LayerManager.addLayout(UIHelper.createCommonDlg(sTips, nil, nil,1))
			end
		end
	end

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideAstrologyView"

	if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 8) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createAstrologyGuide(9,0)
	end

	local layMain = AstrologyRewardView.create( tbEventListener ,m_tbAstrologyInfo)

	return layMain
end

--升级奖励表的回调
function upgradeCallback(cbFlag, dictData, bRet)
	if(bRet)then
		logger:debug(dictData)
		refreshRewardViewDataAndUI()
	end
end

--发送领奖请求后，背包的推送之后更新本界面的数据
function refreshPrizeDataFromBagDeleget( ... )
	--如果已经退出了占卜界面，则不刷新界面
	if(not MainAstrologyView.m_UIMain) then

		refreshRewardViewDataAndUI()

	end
end

--刷新奖励表的回调
function refreshPrizeCallback(cbFlag, dictData, bRet)
	if(bRet)then
		logger:debug("刷新奖励表 后返回的数据是：")
		logger:debug(dictData)

		local nRefreshPrice = MainAstrologyModel.getRefreshCostPrice()
		--减去刷新所用的金币
		UserModel.addGoldNumber(-nRefreshPrice)
		--重新拉取数据并更新界面
		refreshRewardViewDataAndUI()
	end
end
--领奖回调
function drawPrizeCallback(cbFlag, dictData, bRet)
	logger:debug("领奖回调:")
	logger:debug(dictData)
	if(bRet)then
		--判断奖励类型
		local rewardInfo = MainAstrologyModel.getRewardInfoByStep(m_tbAstrologyInfo)

		if("0"==lua_string_split(rewardInfo,"|")[1])then
			UserModel.addSilverNumber(tonumber(lua_string_split(rewardInfo,"|")[2]))
		elseif("1"==lua_string_split(rewardInfo,"|")[1])then
			UserModel.addGoldNumber(tonumber(lua_string_split(rewardInfo,"|")[2]))
		-- elseif("2"==lua_string_split(rewardInfo,"|")[1])then -- zhangqi, 2015-01-10, 去经验石
		-- 	UserModel.addSoulNum(tonumber(lua_string_split(rewardInfo,"|")[2]))
		end

		local rewardName,rewardNum = MainAstrologyModel.getRewardNameAndNumByStep()

		local str = gi18n[2632] .. "[" .. rewardName .. "]" .."×" .. tostring(rewardNum)
		ShowNotice.showShellInfo(str)

		--领奖次数加一
		MainAstrologyModel.addRewardStep()

		MainAstrologyView.setCanGetPriceNum()

		reloadRewardView()
	else
		--local sTips = 	[2317] = "当前无奖励可领取",
		LayerManager.addLayout(UIHelper.createCommonDlg(m_i18nString(2317), nil, nil,1))
	end
end

--重新载入领奖界面
function reloadRewardView( ... )
	local rewardArray = nil
	--是否有随机奖励
	local newreward = m_tbAstrologyInfo.va_divine.newreward or {}

	if(table.count(newreward) <= 0)then
		AstrologyRewardView.fnRefreshRewardsWithNorm()
	else
		AstrologyRewardView.fnRefreshRewardsWithRandom()
	end

	--更新领奖次数
	m_nPriceStep = tonumber(m_tbAstrologyInfo.prize_step)
end

----重新拉取数据并更新界面
function refreshRewardViewDataAndUI( ... )
	function getAstrologyInfoCallBack1(cbFlag, dictData, bRet)
		logger:debug(dictData)
		if(bRet)then
			m_tbAstrologyInfo = dictData.ret
			table.hcopy(dictData.ret, m_tbAstrologyInfo)

			MainAstrologyModel.setDiviInfo(m_tbAstrologyInfo)
			--更新占卜界面的数据
			MainAstrologyCtrl.setAstrologyDataFromRewardView()
			reloadRewardView()
		end
	end
	RequestCenter.divine_getDiviInfo(getAstrologyInfoCallBack1,CCArray:create())
end
