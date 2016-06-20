-- FileName: MainSkyPieaCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛主要场景控制器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("MainSkyPieaCtrl", package.seeall)
local srcPath = "script/module/SkyPiea/"
local m_i18nString 					=  gi18nString
local m_fnGetWidget 				= g_fnGetWidgetByName
-- local m_nEnterDataTimeInt 			= 0     --记录 进入爬塔的时间
-- local m_nStartRewardTimeInt 		= 0 	--开始发奖的时间


require "script/module/SkyPiea/MainSkyPieaView"
require "script/module/SkyPiea/PassLastLevel"
require "script/module/SkyPiea/SkyPieaModel"
require "script/module/SkyPiea/SkyPieaUtil"
require "script/module/SkyPiea/SkyPieaRank/SkyPieaRankCtrl"
require "script/module/SkyPiea/SkyPieaShop/SkyPieaShopCtrl"
require "script/module/SkyPiea/SkyPieaBattle/SkyPieaChooseCtrl"
require "script/module/SkyPiea/SkyPieaBuffCtrl"
require "script/module/SkyPiea/SkyPieaBoxCtrl"
require "db/DB_Sky_piea_box"
require "script/module/activity/MainActivityCtrl"

local function init(...)

end

function destroy(...)
	package.loaded["MainSkyPieaCtrl"] = nil
end

function moduleName()
	return "MainSkyPieaCtrl"
end



--获取当天刷新数据的方法
local function fnSetRefreshDataTime()
	-- 当前服务器时间
	-- m_nEnterDataTimeInt = 0
	-- m_nEnterDataTimeInt = TimeUtil.getSvrTimeByOffset()

	local _userInfo = UserModel.getUserInfo()
	local nStarSecond = tonumber(_userInfo.timeConf.pass.handsOffBeginTime)
	local nDurSecond = tonumber(_userInfo.timeConf.pass.handsOffLastSeconds)
	logger:debug(nStarSecond)
	logger:debug(nDurSecond)


	local nTimeIntZero = TimeUtil.getIntervalByTime(000000)
	m_nStartRewardTimeInt = nTimeIntZero + nStarSecond

	-- local nTimeToRward = m_nStartRewardTimeInt - m_nEnterDataTimeInt
	-- logger:debug(nTimeToRward)
end

--断线重连回掉方法
local function fnNetWorkReconnCall()
	logger:debug("没有空岛数据，不处理断线重练")
	if(SkyPieaModel.getSkyFloorData() == nil) then
		logger:debug("没有空岛数据，不处理断线重练")
		return
	end
	if(SkyPieaUtil.isResetTime()) then
		-- [5455] = "神秘空岛发生错误的事件，需要退出重新进入！",
		ShowNotice.showShellInfo(m_i18nString(5455))
		local layActivity = MainActivityCtrl.create()
		LayerManager.changeModule(layActivity, MainActivityCtrl.moduleName(), {1,3}, true)
		PlayerPanel.addForActivity()
	end
end



function create()
	-- fnSetRefreshDataTime()
	createView()
end


local function selectEvent()

	MainSkyPieaView.removeUnTouchLayer()

	local nMeetType = SkyPieaModel.getFloorType()
	if(nMeetType == SkyPieaModel.EVENTTYPE.BATTLE_LAYER)then
		logger:debug("tbEvent.BATTLE_LAYER")
		SkyPieaChooseCtrl.create()

	elseif(nMeetType == SkyPieaModel.EVENTTYPE.BOX_LAYER) then
		logger:debug("tbEvent.BOX_LAYER")
		SkyPieaBoxCtrl.create()
	elseif(nMeetType == SkyPieaModel.EVENTTYPE.BUFF_LAYER) then
		logger:debug("tbEvent.BUFF_LAYER")
		SkyPieaBuffCtrl.create()
	elseif(nMeetType == SkyPieaModel.EVENTTYPE.LAST_LAYER) then
		logger:debug("tbEvent.LAST_LAYER")
		LayerManager.addLayoutNoScale(PassLastLevel.create())
		MainSkyPieaView.luffyWin()
		return
	end
end
--[[
	@desc: 获取要绑定的function
    @return: tb  type: table
—]]
function getBtnBindingFuctions()

	local tbEvent = {}

	tbEvent.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			local layActivity = MainActivityCtrl.create()
			LayerManager.changeModule(layActivity, MainActivityCtrl.moduleName(), {1,3}, true)
			PlayerPanel.addForActivity()
		end
	end

	-- 说明按钮事件
	tbEvent.onHelp = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local layIntroduce = g_fnLoadUI("ui/air_help.json")
			LayerManager.addLayout(layIntroduce)

			local i18nDesc = g_fnGetWidgetByName(layIntroduce, "tfd_desc")
			i18nDesc:setText(m_i18nString(5432))

			-- local i18nTitle = g_fnGetWidgetByName(layIntroduce,"TFD_DESC_TITLE")
			-- UIHelper.labelAddStroke(i18nTitle,m_i18nString(2043))

			local btnClose = m_fnGetWidget(layIntroduce,"BTN_CLOSE")
			btnClose:addTouchEventListener(function ( sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()
					LayerManager.removeLayout()
				end
			end
			)
		end
	end

	-- 商店按钮事件
	tbEvent.onShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			SkyPieaShopCtrl.create()
		end
	end

	-- 排行按钮事件
	tbEvent.onRank = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			SkyPieaRankCtrl.create()
		end
	end

	-- zhangqi, 2015-03-02, 空岛贝背包按钮事件
	tbEvent.onConch = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			require "script/module/conch/ConchBag/MainConchCtrl"
			if (MainConchCtrl.moduleName() ~= LayerManager.curModuleName()) then
				local layBag = MainConchCtrl.create() -- 默认显示道具列表
				if (layBag) then
					LayerManager.changeModule(layBag, MainConchCtrl.moduleName(), {1, 3}, true)
					PlayerPanel.addForPublic()
				end
			end
		end
	end

	-- 开始爬塔
	tbEvent.onStartClimb = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onStartClimb")
			--跑向目标
			if (SkyPieaModel.getIsAllDead()) then
				ShowNotice.showShellInfo(gi18n[5440])
				return
			end

			if(SkyPieaUtil.isRewardTime()) then
				logger:debug("当前正在发奖中ing")
				ShowNotice.showShellInfo(m_i18nString(5458)) --	[5458] = "神秘空岛开始发奖，无法继续进行活动！",
				return
			end

			local nMeetType = SkyPieaModel.getFloorType()

			if(nMeetType == SkyPieaModel.EVENTTYPE.BOX_LAYER) then
				-- 需要判断的背包类型：空岛贝背包、道具背包、装备碎片背包
				-- or ItemUtil.isConchBagFull(true)

				if ItemUtil.isPropBagFull(true) or ItemUtil.isConchBagFull(true) or ItemUtil.isArmFragBagFull(true) then
					return
				else
					MainSkyPieaView.runToTarget(selectEvent)
				end
			else
				MainSkyPieaView.runToTarget(selectEvent)
			end
		end
	end

	return tbEvent
end



function createView()
	local function getSkyPieaInfoCallBack(cbFlag, dictData, bRet)
		if(bRet) then

			DataCache.setSkypieaData(dictData.ret)
			
			SkyPieaModel.setSkypieaData(dictData.ret)
			logger:debug(TimeUtil.getTimeFormatYMDHMS(dictData.ret.refresh_time))
			local tbEvent = getBtnBindingFuctions()
			local view = MainSkyPieaView.create(tbEvent)
			if view then
				LayerManager.changeModule(view, moduleName(), {1}, true)
			end

			PlayerPanel.addForSkyPiea()
		else
			logger:debug("没有取到爬塔数据")
		end

	end

	RequestCenter.skyPieaEnter(getSkyPieaInfoCallBack)

	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, fnNetWorkReconnCall, nil, "fnNetWorkReconnCall")
end
