
-- FileName: MainGrabTreasureCtrl.lua
-- Author: menghao
-- Date: 2014-5-9
-- Purpose: 夺宝主界面ctrl


module("MainGrabTreasureCtrl", package.seeall)


require "script/module/grabTreasure/MainGrabTreasureView"
require "script/module/grabTreasure/AvoidWarCtrl"
require "script/module/grabTreasure/FragmentInfoCtrl"
require "script/module/grabTreasure/RobTreasureCtrl"
require "script/module/treasure/NewTreaInfoCtrl"
require "script/module/activity/MainActivityCtrl"


-- UI控件引用变量 --


-- 模块局部变量 --
local m_nTreasureType
local m_nIndex
local m_nCurTreasureID
local m_nCurFragmentID
local m_nCurNumNeed
local m_nCurNumHave
local m_updateScheduler 		-- 更新时间线程
local m_nCopyID

local m_isShowGuideUI
 
-- 初始化
local function init(...)
	if (not m_nTreasureType) then
		m_nTreasureType = 1
	end
end


-- 销毁
function destroy(...)
	package.loaded["MainGrabTreasureCtrl"] = nil
end


-- 模块名称
function moduleName()
	return "MainGrabTreasureCtrl"
end


local function updateTime( ... )
	local nAvoidTime = TreasureData.getHaveShieldTime()
	MainGrabTreasureView.updateAvoidTime(nAvoidTime)
end


-- 启动scheduler
local function startScheduler()
	if(m_updateScheduler == nil) then
		m_updateScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTime, 0.9, false)
	end
end


-- 停止scheduler
local function stopScheduler()
	if(m_updateScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateScheduler)
		m_updateScheduler = nil
	end
end


-- 生命周期事件
-- local function onNodeEvent(eventType )
-- 	if(eventType == "enter") then
-- 	elseif(eventType == "exit") then
-- 		stopScheduler()
-- 	end
-- end


local function updateUIAfterSynthetic( bValue )
	local index = nil
	if bValue then
		local afterAnimation = function ( ... )
			-- 合成成功移除屏蔽层
			LayerManager.removeLayout()

			local layTreaInfo = NewTreaInfoCtrl.createBtTid(m_nCurTreasureID)
			LayerManager.addLayout(layTreaInfo)
			require "script/module/grabTreasure/ShowGetCtrl"
			local treaName = DB_Item_treasure.getDataById(m_nCurTreasureID).name
			layTreaInfo:addChild(ShowGetCtrl.create(m_nCurTreasureID, treaName), 100)

			local tbTreasureIds = TreasureData.getTreasureList(m_nTreasureType)
			MainGrabTreasureView.updateUIByIDs(tbTreasureIds, m_nTreasureType)
			if m_nCurTreasureID then
				for i=1,#tbTreasureIds do
					if tbTreasureIds[i] == m_nCurTreasureID then
						index = i - 1
					end
				end
			else
				index = 0
			end
			MainGrabTreasureView.adjustPGV(index)
		end
		MainGrabTreasureView.fuseAnimation(m_nIndex, m_nCurNumNeed, afterAnimation)
	else
		-- 合成失败移除屏蔽层
		LayerManager.removeLayout()

		-- 合成失败提示
		LayerManager.addLayout(UIHelper.createCommonDlg(gi18nString(2439), nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				LayerManager.removeLayout()
			end
		end, 1))
		TreasureService.getSeizerInfo( function ( ... )
			local tbTreasureIds = TreasureData.getTreasureList(m_nTreasureType)
			MainGrabTreasureView.updateUIByIDs(tbTreasureIds, m_nTreasureType)
			if m_nCurTreasureID then
				for i=1,#tbTreasureIds do
					if tbTreasureIds[i] == m_nCurTreasureID then
						index = i - 1
					end
				end
			else
				index = 0
			end
			MainGrabTreasureView.adjustPGV(index)
		end )
	end
end

-- 模块创建
function create(treaTid, treaType, copyID)

	if(copyID) then
		m_nCopyID = copyID
	end
	m_nCopyID = copyID or 1
	if (treaTid) then
		m_nCurTreasureID = tonumber(treaTid)
	end
	if (treaType) then
		m_nTreasureType = treaType
	end

	-- 先判断功能有没有开启
	if (not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure, true)) then
		return
	end

	if (m_isShowGuideUI == nil) then
		m_isShowGuideUI = BTUtil:getGuideState()
	end

	init()

	local tbInfo = {}

	local callfunc = function ( ... )
		local tbTreasureIds = TreasureData.getTreasureList(m_nTreasureType) 		-- 宝物ids
		MainGrabTreasureView.updateUIByIDs( tbTreasureIds, m_nTreasureType, m_isShowGuideUI)
		MainGrabTreasureView.adjustPGV()
	end

	-- View里面的按钮事件
	tbInfo.onWind = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nTreasureType ~= 1) then
				m_nTreasureType = 1
				callfunc()
			end
		end
	end

	tbInfo.onThunder = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nTreasureType ~= 2) then
				m_nTreasureType = 2
				callfunc()
			end
		end
	end

	tbInfo.onWater = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nTreasureType ~= 3) then
				m_nTreasureType = 3
				callfunc()
			end
		end
	end

	tbInfo.onFire = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nTreasureType ~= 4) then
				m_nTreasureType = 4
				callfunc()
			end
		end
	end

	tbInfo.onAvoidWar = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(AvoidWarCtrl.create())
		end
	end

	tbInfo.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()

			require "script/module/copy/MainCopy"
			logger:debug(m_nCopyID)
			MainCopy.enterToExploreBaseNormal(m_nCopyID)
		end
	end

	tbInfo.onTreasureModel = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(NewTreaInfoCtrl.createBtTid(m_nCurTreasureID))
		end
	end

	tbInfo.onGrab = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			function createView( ... )
				local layGrabTreasure = RobTreasureCtrl.create(m_nCurFragmentID)
				LayerManager.changeModule(layGrabTreasure, RobTreasureCtrl.moduleName(), {1, 3}, true)
				PlayerPanel.addForGrab()
			end

			if (m_isShowGuideUI) then
				m_isShowGuideUI = false
			end

			TreasureService.getRecRicher(createView,m_nCurFragmentID)
		end
	end

	tbInfo.onSynthetic = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			--是否背包满
			if(ItemUtil.isTreasBagFull(true, nil) == true) then
				return
			end
			TreasureService.fuse(m_nCurTreasureID, updateUIAfterSynthetic)
			-- 合成时加屏蔽层
			local layout = Layout:create()
			layout:setName("layForShield")
			LayerManager.addLayout(layout)
		end
	end


	tbInfo.pageViewEvent = function (sender, eventType)
		if eventType == PAGEVIEW_EVENT_TURNING then
			-- 获取当前宝物id
			local pageView = tolua.cast(sender, "PageView")
			m_nIndex = pageView:getCurPageIndex() + 1
			MainGrabTreasureView.changeHighlight(m_nIndex)
			local tbTreasureIds = MainGrabTreasureView.getTreaIDs()
			m_nCurTreasureID = tbTreasureIds[m_nIndex]

			-- 根据当前宝物id得到碎片id和碎片数量
			if m_nCurTreasureID then
				local flag = true
				m_nCurNumHave = 0
				m_nCurNumNeed = 0
				local fragments = TreasureData.getTreasureFragments(m_nCurTreasureID)

				for k,v in pairs(fragments) do
					local itemArr = string.split(v, "|")
					local fragmentID = itemArr[1]
					local numNeed = tonumber(itemArr[2])
					m_nCurNumNeed = m_nCurNumNeed + numNeed

					local numHave = TreasureData.getFragmentNum(fragmentID)
					if (numHave < numNeed) then
						flag = false
						m_nCurFragmentID = fragmentID
						m_nCurNumHave = m_nCurNumHave + numHave
					else
						m_nCurNumHave = m_nCurNumHave + numHave
					end
				end
				if  (flag ) then
					MainGrabTreasureView.grabOrSynthetic(1)
				else
					MainGrabTreasureView.grabOrSynthetic(2)
				end
			else
				m_nCurFragmentID = nil
			end
		end
	end

	local getCallfunc = function ( ... )
		local layMain = MainGrabTreasureView.create( tbInfo )
		-- layMain:registerScriptHandler(onNodeEvent)
		--liweidong 改成以下格式
		UIHelper.registExitAndEnterCall(layMain,function()
			stopScheduler()
		end)

		updateTime()
		startScheduler()
		local tbTreasureIds = TreasureData.getTreasureList(m_nTreasureType) -- 宝物ids
		logger:debug({tbTreasureIds = tbTreasureIds})
		MainGrabTreasureView.updateUIByIDs( tbTreasureIds, m_nTreasureType, m_isShowGuideUI)

		logger:debug(m_nCurTreasureID)
		logger:debug(m_nTreasureType)
		if m_isShowGuideUI then
			m_nCurTreasureID = 501501
		end
		if m_nCurTreasureID then
			for i=1,#tbTreasureIds do
				if tbTreasureIds[i] == m_nCurTreasureID then
					tbInfo.index = i - 1
				end
			end
		else
			tbInfo.index = 0
		end

		LayerManager.changeModule(layMain, MainGrabTreasureCtrl.moduleName(), {1, 3}, true)
		PlayerPanel.addForGrab()

		--结算面板 确定 之后 防止会有 夺宝玩家选择界面的残留问题
		--删除战斗场景 或者副本战斗升级界面，去竞技，防止界面跳转的时候 有副本界面的残留
		logger:debug(BattleState.isPlaying())
		if(BattleState.isPlaying() == true) then
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
			SwitchCtrl.postBattleNotification("END_BATTLE")
			AudioHelper.playMainMusic()

		end

		MainGrabTreasureView.adjustPGV(tbInfo.index)
	end

	-- 网络请求
	TreasureService.getSeizerInfo( getCallfunc )
end

