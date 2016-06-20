-- FileName: MainRewardCenterView.lua
-- Author: huxiaozhou
-- Date: 2014-05-26
-- Purpose: 奖励中心显示模块
--[[TODO List]]

module("MainRewardCenterView", package.seeall)
-- UI控件引用变量 --

local m_i18n = gi18n
local m_i18nString = gi18nString

-- 模块局部变量 --
local json = "ui/reward_center.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_mainWidget
local m_tbEvent
local listView
local m_layCell
local LSV_TOTAL

local _tbDataSource = {}

local function init(...)

end

function destroy(...)
	package.loaded["MainRewardCenterView"] = nil
end

function moduleName()
    return "MainRewardCenterView"
end

function loadUI(  )
	TimeUtil.timeStart("loadUI")
	local i18ntfd_title = m_fnGetWidget(m_mainWidget,"tfd_title") -- 对话框名称
	local i18nTFD_INFO = m_fnGetWidget(m_mainWidget,"TFD_INFO")   -- 需要本地化点信息框
	local i18ntfd_reward_info = m_fnGetWidget(m_mainWidget,"tfd_reward_info") -- 需要本地化的 “奖励数”
	i18ntfd_reward_info:setText(m_i18n[3303])
	local TFD_REWARD_NUM = m_fnGetWidget(m_mainWidget,"TFD_REWARD_NUM") -- 当前拥有的奖励数
	TFD_REWARD_NUM:setText(RewardCenterModel.getRewardCount())

	local BTN_GET_ALL = m_fnGetWidget(m_mainWidget,"BTN_GET_ALL") -- 全部领取按钮
	BTN_GET_ALL:addTouchEventListener(m_tbEvent.onReceiveAll) --注册全部领取按钮
	UIHelper.titleShadow(BTN_GET_ALL,m_i18n[3304])
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget,"BTN_CLOSE") --关闭按钮
	BTN_CLOSE:addTouchEventListener(m_tbEvent.onClose) -- 注册关闭按钮事件
	LSV_TOTAL = m_fnGetWidget(m_mainWidget, "LSV_TOTAL")
	UIHelper.initListViewCell(LSV_TOTAL)
	TimeUtil.timeEnd("loadUI")
end

function fnInitRewardsData(  )
	TimeUtil.timeStart("fnInitRewardsData")
	_tbDataSource = RewardCenterModel.getRewardList()
	for k,v in pairs(_tbDataSource) do
		v.onReceiveSig = m_tbEvent.onReceiveSig
	end
	TimeUtil.timeEnd("fnInitRewardsData")
end

function initListView ()
	UIHelper.reloadListView(LSV_TOTAL,#_tbDataSource,updateCellByIdex, nil, true)
end

function updateCellByIdex(lsv, idx )
	TimeUtil.timeStart("updateCellByIdex")
	local cell = lsv:getItem(idx)
	local tbData = _tbDataSource[idx+1]
	local TFD_CELL_TITLE = m_fnGetWidget(cell,"TFD_CELL_TITLE") --奖励标题
	TFD_CELL_TITLE:setText(tbData.title)

	local TFD_REWARD_TIME = m_fnGetWidget(cell,"TFD_REWARD_TIME") -- 发奖时间
	TFD_REWARD_TIME:setText(tbData.time)

    local TFD_REWARD_TIME0 = m_fnGetWidget(cell,"TFD_REWARD_TIME_0") -- 时间
    if tonumber(tbData.source) == 8 then
        TFD_REWARD_TIME0:setEnabled(true)
    else
        TFD_REWARD_TIME0:setEnabled(false)
    end
    local function updateTime( ... )
        -- logger:debug({tbData =tbData})
        local timeStr = TimeUtil.getTimeByInterval(tbData.expireTime - TimeUtil.getSvrTimeByOffset())
        if timeStr == "00:00:00" then
            timeStr = m_i18n[3361]
        end
        TFD_REWARD_TIME0:setText(timeStr)
    end
    updateTime()
    UIHelper.registExitAndEnterCall(TFD_REWARD_TIME0, function (  )
        logger:debug("rewardCenterTime " ..  idx)
        GlobalScheduler.removeCallback("rewardCenterTime"  .. idx)
    end)
    GlobalScheduler.removeCallback("rewardCenterTime"  .. idx)
    GlobalScheduler.addCallback("rewardCenterTime" .. idx, updateTime)

	local TFD_CELL_INFO = m_fnGetWidget(cell,"TFD_CELL_INFO") -- 恭喜。。。。
	TFD_CELL_INFO:setText(tbData.content)

	local BTN_GET_REWARD = m_fnGetWidget(cell,"BTN_GET_REWARD") -- 领奖按钮
	BTN_GET_REWARD:addTouchEventListener(tbData.onReceiveSig)
	BTN_GET_REWARD:setTag(tbData.rid) -- 添加按钮事件 设置tag
	UIHelper.titleShadow(BTN_GET_REWARD,m_i18n[2309])
	local tbRewardsData = RewardCenterModel.parseRewardsData(tbData)

	local LSV_REWARD = m_fnGetWidget(cell, "LSV_REWARD")
	UIHelper.initListView(LSV_REWARD)
	local cell, nIdx
	for i,cellData in ipairs(tbRewardsData or {}) do
		LSV_REWARD:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = LSV_REWARD:getItem(nIdx)  -- cell 索引从 0 开始
    	createSubView(cell,cellData)
	end
	TimeUtil.timeEnd("updateCellByIdex")
end

function createSubView (cell,tbData) 
        local icon 
        local quality = 1
        --金币图标
        if(tbData.type == "gold") then
            icon = ItemUtil.getGoldIconByNum(tbData.num)
            quality = 5
        end
        --贝里图标
        if(tbData.type == "silver") then
            icon = ItemUtil.getSiliverIconByNum(tbData.num)
            quality = 1
        end
        --经验石图标
        if(tbData.type == "soul") then
            icon = ItemUtil.getSoulIconByNum(tbData.num)
            quality = 4
        end
        -- 声望图标
        if(tbData.type == "prestige") then
            icon = ItemUtil.getPrestigeIconByNum(tbData.num)
            quality = 3
        end
        -- 海魂
        if(tbData.type == "jewel") then
           icon = ItemUtil.getJewelIconByNum(tbData.num)
           quality = 5
        end
        -- 空岛币
        if(tbData.type == "coin") then
           icon = ItemUtil.getSkyBellyIconByNum(tbData.num)
           quality = 5
        end
           --卡牌
        if(tbData.type == "hero") then
                require "db/DB_Heroes"
                require "script/model/utils/HeroUtil"
                local db_hero = DB_Heroes.getDataById(tbData.tid)
                quality = db_hero.quality
                icon = HeroUtil.createHeroIconBtnByHtid(db_hero.id,nil,function ( sender,eventType )
                                            if (eventType == TOUCH_EVENT_ENDED) then
                                                PublicInfoCtrl.createHeroInfoView(db_hero.id,tbData.num)
                                            end
                                        end,tbData.num)
            
        end

        --物品
        if(tbData.type == "item" ) then
                --查询物品信息    
                require "script/module/public/ItemUtil"
                local itemTableInfo = ItemUtil.getItemById(tonumber(tbData.tid))
                quality = itemTableInfo.quality
                icon = ItemUtil.createBtnByTemplateIdAndNumber(itemTableInfo.id,tbData.num,function ( sender,eventType )
                                                if (eventType == TOUCH_EVENT_ENDED) then
                                                    PublicInfoCtrl.createItemInfoViewByTid(itemTableInfo.id,tbData.num)
                                                end
                end)
        end

        -- if(tbData.type == "jewel") then
        --    icon = ItemUtil.getJewelIconByNum(tbData.num)
        -- end
        if(tbData.type == "stamina") then
            icon = ItemUtil.getStaminaIconByNum(tbData.num)
            quality = 1
        end

        if(tbData.type == "execution") then
            icon = ItemUtil.getSmallPhyIconByNum(tbData.num)
            quality = 1
        end

        if tbData.type == "contri" then
        	icon = ItemUtil.getContriIconByNum(tbData.num)
        	quality = 5
        end
        
		local IMG_GOODS = g_fnGetWidgetByName(cell,"IMG_GOODS") --物品背景
		IMG_GOODS:removeChildByTag(10, true)
		IMG_GOODS:addChild(icon,10,10)
		local TFD_GOODS_NAME = g_fnGetWidgetByName(cell,"TFD_GOODS_NAME")
		TFD_GOODS_NAME:setText(tbData.name)

        local color =  g_QulityColor[tonumber(quality)]
        if(color ~= nil) then
            TFD_GOODS_NAME:setColor(color)
        end

end

function reloadData( )
	local TFD_REWARD_NUM = m_fnGetWidget(m_mainWidget,"TFD_REWARD_NUM") -- 当前拥有的奖励数
	TFD_REWARD_NUM:setText(RewardCenterModel.getRewardCount())
	fnInitRewardsData()
	initListView()
end

function loadJson(  )
	m_mainWidget = g_fnLoadUI(json)
end

function create(tbEvent)
	m_tbEvent = tbEvent
    loadJson()
	loadUI()
	fnInitRewardsData()
    performWithDelay(m_mainWidget, function (  )
       initListView() 
    end, 0.1)
	
	return m_mainWidget
end

