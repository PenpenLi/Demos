-- FileName: AdvTraderCtrl.lua
-- Author: zhangqi
-- Date: 2015-04-02
-- Purpose: 神秘熊猫人奇遇事件主控模块
--[[TODO List]]

module("AdvTraderCtrl", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local m_defTimeString = "00:00:00"

local m_viewInstance -- view 的对象实例

local function init(...)
	m_viewInstance = nil
end

function destroy(...)
	m_viewInstance = nil
	package.loaded["AdvTraderCtrl"] = nil
end

function moduleName()
    return "AdvTraderCtrl"
end

function create(eventInfoId)
	init()

	require "script/module/adventure/AdventureModel"
	local tbEvent = AdventureModel.getEventItemById(eventInfoId)

	require "db/DB_Exploration_things"
	local dbData = DB_Exploration_things.getDataById(tbEvent.etid)
	logger:debug(dbData)

	local tbArgs = {}

	tbArgs.complete = tbEvent.complete -- 记录事件是否完成

	tbArgs.sTitle = dbData.title
	tbArgs.sTraderImg = "images/base/hero/body_img/" .. dbData.thingHeroImg

	tbArgs.desc = dbData.desc

	local itemInfo = nil
	local sItemType, sItemTid, sItemNum = string.match(dbData.itemID, "(.*)|(.*)|(.*)")
	tbArgs.btnItemIcon, itemInfo = ItemUtil.createBtnByTemplateIdAndNumber(sItemTid, sItemNum, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("btnItemIcon onClicked")
			PublicInfoCtrl.createItemInfoViewByTid(sItemTid, sItemNum)
		end
	end)

	tbArgs.sItemName = itemInfo.name
	tbArgs.nItemQuality = itemInfo.quality

	-- 构造物品奖励信息，用于全屏奖励UI显示
	tbArgs.tbReward = {name = itemInfo.name, quality = itemInfo.quality, tid = sItemTid, num = sItemNum}

	tbArgs.sAgioSign = "images/adventure/agio/" .. dbData.itemAgio
	local agoNum, nowNum = string.match(dbData.itemPrice, "(.*)|(.*)")
	tbArgs.nAgoNum, tbArgs.nNowNum = tonumber(agoNum), tonumber(nowNum)
	tbArgs.sTime = "18:25:11"

	tbArgs.fnBuyCallback = function ( ... )
		logger:debug("btnBuy on clicked: need gold: %d", tbArgs.nNowNum)
		if (UserModel.getGoldNumber() < tbArgs.nNowNum) then
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			return
		end

		if (m_viewInstance:getCDString() == m_defTimeString) then
			require "script/module/public/ShowNotice"
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo(m_i18n[4364])
			return
		end

		AudioHelper.playBtnEffect("buttonbuy.mp3")
		-- 购买请求回调
		local function buyCallback( cbFlag, dictData, bRet )
			if (bRet) then
				AdventureModel.setEventCompleted(eventInfoId) -- 置事件完成状态

				UserModel.addGoldNumber(-tbArgs.nNowNum) -- 成功扣金币

				m_viewInstance:updateOKState() -- 刷新奇遇事件的UI

				-- 显示全屏奖励领取
				tbArgs.tbReward.icon = ItemUtil.createBtnByTemplateIdAndNumber(tbArgs.tbReward.tid, tbArgs.tbReward.num)
				local rewardDlg = UIHelper.createRewardDlg({tbArgs.tbReward}, nil, true)
				LayerManager.addLayoutNoScale(rewardDlg)
			end
		end

		-- 发送购买请求
		logger:debug("eventInfoId = " .. eventInfoId)
		local tbRpcArgs = {tonumber(eventInfoId),}
		RequestCenter.exploreDoEvent(buyCallback, Network.argsHandlerOfTable(tbRpcArgs))
	end


	require "script/module/adventure/AdvTraderView"
	m_viewInstance = AdvTraderView:new()
	return m_viewInstance:create(tbArgs)
end

function updateCD( sTime )
	if (m_viewInstance) then
		m_viewInstance:updateCD(sTime)
	end
end

