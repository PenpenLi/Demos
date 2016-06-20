-- FileName: MainRewardCenterCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-26
-- Purpose: 奖励中心主要控制模块
--[[TODO List]]

module("MainRewardCenterCtrl", package.seeall)

require "script/module/rewardCenter/MainRewardCenterView"
-- UI控件引用变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
-- 模块局部变量 --
local m_tbBagFull  -- 所有需要调用的背包满的函数，zhangqi, 2014-07-17

local function init(...)
	m_tbBagFull = {}
end

function destroy(...)
	package.loaded["MainRewardCenterCtrl"] = nil
end

function moduleName()
    return "MainRewardCenterCtrl"
end

function create(...)
	TimeUtil.timeStart("RewardCenter")
	init()
	TimeUtil.timeStart("RewardCenter network")
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			TimeUtil.timeEnd("RewardCenter network")
			RewardCenterModel.setRewardList(dictData.ret)
			logger:debug("MainRewardCenterCtrl:requestFunc")
			logger:debug(dictData.ret)
			createView()
			TimeUtil.timeEnd("RewardCenter")			
		end
	end

	RequestCenter.reward_getRewardList(requestFunc)
	MainRewardCenterView.loadJson()
end

--领取奖励
--奖励id
function receiveReward( rid,callbackFunc )
	--是否已过期
	if(RewardCenterModel.isTimeOut(rid)) then
		ShowNotice.showShellInfo(m_i18n[3340])
		RewardCenterModel.deleteReward(rid)

		local tbDataSource = RewardCenterModel.getRewardList()
		if (next(tbDataSource)) then
			reloadData()
		else
			MainShip.setRewardCenterBtnEnabled(false)
			LayerManager.removeLayout()
		end
		return
	end
	--背包够用
	require "script/module/public/ItemUtil"
	local rewardInfo = RewardCenterModel.getSingleRewardInfo(rid)
	-- zhangqi, 2014-07-17, 改成按每个物品类型检查对应背包满的机制，增强体验
	if (not table.isEmpty(rewardInfo.va_reward.item)) then
		for i, item in ipairs(rewardInfo.va_reward.item) do
			if (ItemUtil.bagIsFullWithTid(item.tplId, true)) then
				return
			end
		end
	end

	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			local rewardInfo = RewardCenterModel.getSingleRewardInfo(rid)
			local rewardKey = RewardCenterModel.getSingleRewardKey(rid)
			table.remove(RewardCenterModel.tbSubListView, tonumber(rewardKey))

			RewardCenterModel.deleteReward(rid)
			callbackFunc()

			local tbRewardsData = parseRewards(rewardInfo)
			local tbDataSource = RewardCenterModel.getRewardList()
			local alert
			if (next(tbDataSource)) then
				alert = UIHelper.createGetRewardInfoDlg(m_i18n[3341],tbRewardsData)
			else
				alert = UIHelper.createGetRewardInfoDlg(m_i18n[3341],tbRewardsData,remove2Layout,nil, remove2Layout)
			end
			LayerManager.addLayout(alert)

			if(rewardInfo.va_reward.gold ~= nil) then 
				UserModel.addGoldNumber(tonumber(rewardInfo.va_reward.gold))
			end
			if(rewardInfo.va_reward.silver ~= nil) then
				UserModel.addSilverNumber(tonumber(rewardInfo.va_reward.silver))
			end
			if(rewardInfo.va_reward.prestige ~= nil) then
				UserModel.addPrestigeNum(tonumber(rewardInfo.va_reward.prestige))
			end
			if(rewardInfo.va_reward.stamina ~= nil) then -- 增加耐力
				UserModel.addStaminaNumber(tonumber(rewardInfo.va_reward.stamina))
			end
			if(rewardInfo.va_reward.execution ~= nil) then -- 增加体力
				UserModel.addEnergyValue(tonumber(rewardInfo.va_reward.execution))
			end
			if (rewardInfo.va_reward.coin ~= nil) then
				UserModel.addSkyPieaBellyNum(tonumber(rewardInfo.va_reward.coin))
			end
			
		end
	end
	local args = CCArray:create()
	args:addObject(CCInteger:create(rid))
	RequestCenter.reward_receiveReward(requestFunc,args)
end

function remove2Layout( )
	MainShip.setRewardCenterBtnEnabled(false)
	logger:debug("remove2Layout")
	LayerManager.removeLayout()
	LayerManager.removeLayout()									
end

--- 获取解析后的奖励列表
function parseRewards(tbData)
	local tbRewardsData = {}
	for k,v in pairs(tbData.va_reward) do
		logger:debug(v)
		--金币图标
        if(k == "gold") then
            local goldInfo = {}
            goldInfo.name =  m_i18n[2220]-- "金币"
            local imgGold = ItemUtil.getGoldIconByNum(v)
            goldInfo.icon = imgGold
            goldInfo.quality = 5
            table.insert(tbRewardsData, goldInfo)
        end
		--贝里图标
        if(k == "silver") then
            local silverInfo ={}
            local imgSilver = ItemUtil.getSiliverIconByNum(v)
            silverInfo.icon = imgSilver
            silverInfo.quality = 2
            require "db/i18n"
            silverInfo.name = m_i18n[1520] -- "贝里" 
            table.insert(tbRewardsData, silverInfo)
        end
		--将魂图标
        if(k == "soul") then
            local soulInfo ={}
           	local imgSoul = ItemUtil.getSoulIconByNum(v)
           	soulInfo.icon = imgSoul
            soulInfo.name = m_i18n[1087] --"经验石"
            soulInfo.quality = 4
            table.insert(tbRewardsData, soulInfo)
        end
        -- 声望图标
        if(k == "prestige") then
        	local prestigeInfo ={}
            local imgPrestige = ItemUtil.getPrestigeIconByNum(v)
            prestigeInfo.icon = imgPrestige
            prestigeInfo.name = m_i18n[1921] --"声望"
            prestigeInfo.quality = 3
            table.insert(tbRewardsData, prestigeInfo)
        end
        -- 海魂
        if(k == "jewel") then
        	local jewelInfo ={}
          	local imgJewel = ItemUtil.getJewelIconByNum(v)
          	jewelInfo.icon = imgJewel
            jewelInfo.name = m_i18n[2082] --"魂玉"
            jewelInfo.quality = 5
            table.insert(tbRewardsData, jewelInfo)
        end
           --卡牌
        if(k == "hero") then
	        for key,heroInfo in pairs(v) do
	    		require "db/DB_Heroes"
	    		require "script/model/utils/HeroUtil"
				local db_hero = DB_Heroes.getDataById(heroInfo.tplId)
				local card ={}
	          	local btnHero = HeroUtil.createHeroIconBtnByHtid(db_hero.id,nil,function ( sender,eventType )
											if (eventType == TOUCH_EVENT_ENDED) then
												PublicInfoCtrl.createHeroInfoView(db_hero.id,heroInfo.num)
											end
										end,heroInfo.num)
	            card.icon  = btnHero
	            card.name = db_hero.name
	            card.quality = db_hero.quality
	            table.insert(tbRewardsData, card)
	        end
        end

        --物品
        if(k == "item" ) then
			for key,itemInfo in pairs(v) do
				local rewardItem = {}
				--查询物品信息	
				local itemTableInfo = ItemUtil.getItemById(tonumber(itemInfo.tplId))
				local btnIcon = ItemUtil.createBtnByTemplateIdAndNumber(itemTableInfo.id,itemInfo.num,function ( sender,eventType )
												if (eventType == TOUCH_EVENT_ENDED) then
													PublicInfoCtrl.createItemInfoViewByTid(itemTableInfo.id,itemInfo.num)
												end
				end)

				rewardItem.icon = btnIcon
				rewardItem.name = itemTableInfo.name
				rewardItem.quality = itemTableInfo.quality
				table.insert(tbRewardsData,rewardItem)
			end
		end

--	 签到奖励特殊处理

		 --奖励 体力
		if(k == "execution") then
			local executionInfo = {}
			local imgExecution = ItemUtil.getSmallPhyIconByNum(v)
          	executionInfo.icon = imgExecution
            executionInfo.name = m_i18n[1922] --"体力"
            table.insert(tbRewardsData, executionInfo)
		end

		-- --  奖励耐力
		if(k == "stamina") then
			-- ("images/base/props/naili_xiao.png")
			logger:debug("stamina == " .. v)
			local staminaInfo = {}
			local imgStamina = ItemUtil.getStaminaIconByNum(v)
          	staminaInfo.icon = imgStamina
            staminaInfo.name = m_i18n[1923]--"耐力"
            table.insert(tbRewardsData, staminaInfo)
		end

		if (k=="coin") then
			local coinInfo ={}
			local imgCoin = ItemUtil.getSkyBellyIconByNum(v)
          	coinInfo.icon = imgCoin
            coinInfo.name = m_i18n[5414]
            table.insert(tbRewardsData, coinInfo)
		end

		if (k=="contri") then
        	local contriInfo ={}
          	contriInfo.type = k
          	local imgContri = ItemUtil.getContriIconByNum(v)
          	contriInfo.icon = imgContri
            contriInfo.name = m_i18n[3716]
            contriInfo.num = v
            contriInfo.quality = 5
            table.insert(tbRewardsData, contriInfo)
		end
	end
	return tbRewardsData	
end


local function parseAllRewards(tRewards)
	local tShowRewards = {}
	for _,t in ipairs(tRewards) do
		for i,v in ipairs(t) do
			table.insert(tShowRewards, v)
		end
	end
	return tShowRewards
end

function receiveByRidArr( )
	local tbDataSource = RewardCenterModel.getRewardList()
	local rid_table = {}
	local bRidCounts = false
	for k,v in pairs(tbDataSource) do
		table.insert(rid_table, v.rid)
		if(table.maxn(rid_table)>=20) then
			bRidCounts = true
			break
		end
	end

	--背包是否满
	--背包够用
	require "script/module/public/ItemUtil"
	local tbTids = {}
	for k,v in ipairs(rid_table) do
		local rewardInfo = RewardCenterModel.getSingleRewardInfo(v)
		-- zhangqi, 2014-07-17, 改成按每个物品类型检查对应背包满的机制，增强体验
		if (not table.isEmpty(rewardInfo.va_reward.item)) then
			for i, item in ipairs(rewardInfo.va_reward.item) do
				if (ItemUtil.bagIsFullWithTid(item.tplId, true)) then
					return
				end
			end
		end	
	end


	
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then

			-- ShowNotice.showShellInfo(m_i18n[3306])

			local tRewards = {}
			for i,v in ipairs(rid_table) do
				local rewardInfo = RewardCenterModel.getSingleRewardInfo(v)
				logger:debug({rewardInfo = rewardInfo})
				local t = parseRewards(rewardInfo)
				table.insert(tRewards, t)
			end
			local tShowRewards = parseAllRewards(tRewards)

			--更新数据
			for k,v in ipairs(rid_table) do
				local rewardInfo = RewardCenterModel.getSingleRewardInfo(v)
				if(rewardInfo.va_reward.gold ~= nil) then 
					UserModel.addGoldNumber(tonumber(rewardInfo.va_reward.gold))
				end
				if(rewardInfo.va_reward.silver ~= nil) then
					UserModel.addSilverNumber(tonumber(rewardInfo.va_reward.silver))
				end
				if(rewardInfo.va_reward.prestige ~= nil) then
					UserModel.addPrestigeNum(tonumber(rewardInfo.va_reward.prestige))
				end	
				if(rewardInfo.va_reward.stamina ~= nil) then -- 增加耐力
					UserModel.addStaminaNumber(tonumber(rewardInfo.va_reward.stamina))
				end
				if(rewardInfo.va_reward.execution ~= nil) then -- 增加体力
					UserModel.addEnergyValue(tonumber(rewardInfo.va_reward.execution))
				end
				if (rewardInfo.va_reward.coin ~= nil) then
					UserModel.addSkyPieaBellyNum(tonumber(rewardInfo.va_reward.coin))
				end			
				RewardCenterModel.deleteReward(v)
			end			
			
			local tbDataSource = RewardCenterModel.getRewardList()
			local alert
			if (bRidCounts) then
				alert = UIHelper.createGetRewardInfoDlg(m_i18n[3341],tShowRewards)
			else
				alert = UIHelper.createGetRewardInfoDlg(m_i18n[3341],tShowRewards,remove2Layout,nil, remove2Layout)
			end
			LayerManager.addLayout(alert)

			if(bRidCounts)	then
				reloadData() 
			end
		end
	end
	local args = CCArray:create()
	local ridArray = CCArray:create()

	if table.isEmpty(rid_table) then
		ShowNotice.showShellInfo(m_i18n[2317]) -- 当前无奖励可领取
		return
	end

	for k,v in pairs(rid_table) do
		if(RewardCenterModel.isTimeOut(v) ~= true) then
			ridArray:addObject(CCString:create(v))
		end
	end

	if ridArray:count() == 0 then
		ShowNotice.showShellInfo(m_i18n[3340]) -- 很抱歉，奖励已过期，无法领取
		return 
	end

	logger:debug(ridArray)
	args:addObject(ridArray)
	RequestCenter.reward_receiveByRidArr(requestFunc,args)
end



function reloadData(  )
	logger:debug("reloadData")
	MainRewardCenterView.reloadData()
end


function createView( )
	local tbBtnEvent = {}
	-- 按钮 全部领取按钮
	tbBtnEvent.onReceiveAll = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("tansuo02.mp3")
			logger:debug("tbBtnEvent.onReceiveAll")
			receiveByRidArr()
		end
	end

	tbBtnEvent.onReceiveSig = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("tansuo02.mp3")
			logger:debug("tbBtnEvent.onReceiveSig" .. sender:getTag())
			receiveReward(sender:getTag(),reloadData)
		end
	end

	tbBtnEvent.onClose = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onClose")
			AudioHelper.playCloseEffect()

		local tbDataSource = RewardCenterModel.getRewardList()
		if (not next(tbDataSource)) then
			MainShip.setRewardCenterBtnEnabled(false)
			LayerManager.removeLayout()
		end
		return

			LayerManager.removeLayout()
		end
	end

	local mainView = MainRewardCenterView.create(tbBtnEvent)
	LayerManager.addLayout(mainView)
end

