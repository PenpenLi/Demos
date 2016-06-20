-- FileName: MainAchieveCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-11-10
-- Purpose: function description of module
--[[TODO List]]
-- 每日任务 和成就系统的标签显示页 控制器


module("MainAchieveCtrl", package.seeall)

require "script/module/achieve/MainAchieveView"
require "script/module/achieve/AchieveCtrl"
require "script/module/dailyTask/MainDailyTaskCtrl"
require "script/module/dailyTask/MainDailyTaskData"
 
-- UI控件引用变量 --
local m_CurWidgetName
local m_CurWidget
local m_MainWidget

-- 模块局部变量 --
local m_tbWidgetName = {
	"task", --  每日任务标签
	"achieve", -- 成就标签
}

local m_tbCreate = {
	MainDailyTaskCtrl.create, --  每日任务创建方法
	AchieveCtrl.create,	-- 成就创建方法
}


local function init(...)
	m_CurWidgetName = nil
	m_CurWidget = nil
end

function destroy(...)
	m_CurWidgetName = nil
	package.loaded["MainAchieveCtrl"] = nil
end

function moduleName()
    return "MainAchieveCtrl"
end

-- 拉取服务器上每日任务的数据
function getTaskInfo( callfunc)
	function getAchieInfoCallBack(cbFlag, dictData, bRet)
		logger:debug("dailyTask data in server")
		logger:debug(dictData)
		MainDailyTaskData.setDailyTaskInfo(dictData.ret)
		
		createView()
		--pcall(callfunc)
	end
	RequestCenter.getActiveInfo(getAchieInfoCallBack)
end



-- 创建 Sub View
-- local createSubView(tbIndex)
-- 	return m_tbCreate[tbIndex]
-- end


--  tabIndex  1 每日任务， 2 成就  ， 3 成就总览
local function addSubView(tabIndex)
	if m_CurWidget ~= nil then
		m_CurWidget:removeFromParentAndCleanup(true)
		m_CurWidget = nil
	end
	m_CurWidget = m_tbCreate[tonumber(tabIndex)]()
	m_MainWidget:addChild(m_CurWidget)
	m_CurWidgetName = m_tbWidgetName[tabIndex]
end

function createView(  )
	-- 按钮事件
	local tbBtnEvent = {}
	-- 每日任务按钮
	tbBtnEvent.onTask = function ( sender, eventType)
		local sender = tolua.cast(sender, "Button")
		if (MainAchieveView.getSelectedBtnTag() == sender:getTag()) then
			MainAchieveView.btnSelectFunc(sender)
		end

	    if (eventType == TOUCH_EVENT_ENDED) then
 			logger:debug("tbBtnEvent.onTask")
 			if (MainAchieveView.getSelectedBtnTag() == sender:getTag()) then
				MainAchieveView.btnSelectFunc(sender)
				return
			end
			AudioHelper.playTabEffect()
			addSubView(1)
			MainAchieveView.btnSelectFunc(sender)
		end
	end
	-- 成就按钮
	tbBtnEvent.onAchieve = function ( sender, eventType)
		local sender = tolua.cast(sender, "Button")
		if (MainAchieveView.getSelectedBtnTag() == sender:getTag()) then
			MainAchieveView.btnSelectFunc(sender)
		end
	    if (eventType == TOUCH_EVENT_ENDED) then
 			logger:debug("tbBtnEvent.onAchieve")
 			if (MainAchieveView.getSelectedBtnTag() == sender:getTag()) then
				MainAchieveView.btnSelectFunc(sender)
				return
			end
			AudioHelper.playTabEffect()
			addSubView(2)
			MainAchieveView.btnSelectFunc(sender)
		end
	end

	-- 返回按钮
	tbBtnEvent.onBack = function ( sender, eventType)
	    if (eventType == TOUCH_EVENT_ENDED) then
	    	AudioHelper.playBackEffect()
 			require "script/module/main/MainScene"
 			MainScene.homeCallback()
		end
	end
	local view = MainAchieveView.create(tbBtnEvent)
	m_MainWidget = view
	addSubView(1)
	LayerManager.changeModule(view, MainAchieveCtrl.moduleName(), {1,3}, true)
	PlayerPanel.addForPublic()
end

-- 拉去成就相关
local function getAchieveInfo()
	function getAchieInfoCallBack(cbFlag, dictData, bRet)
		assert(dictData.err == "ok", "成就系统getinfo挂了")
		logger:debug(dictData)
		require "script/module/achieve/AchieveModel"
		AchieveModel.setAchieve(dictData.ret)
	end
	RequestCenter.getAchieInfo(getAchieInfoCallBack)
end

function resetView( ... )
	if (not SwitchModel.getSwitchOpenState(ksSwitchEveryDayTask)) then
		return
	end 
	if(m_CurWidgetName ~= m_tbWidgetName[1]) then
		logger:debug("wm----dailytask resetView false")
		return
	end
	logger:debug("wm----dailytask resetView true")

	function getAchieInfoCallBack(cbFlag, dictData, bRet)
		logger:debug("dailyTask data in server")
		logger:debug(dictData)
		MainDailyTaskData.setDailyTaskInfo(dictData.ret)
		
		addSubView(1)
		MainAchieveView.updateUI()
		--pcall(callfunc)
	end
	RequestCenter.getActiveInfo(getAchieInfoCallBack)
	
end

function create(...)
	LayerManager.addUILoading()
	init()
		getAchieveInfo()
	--if DataCache.getDailyTaskInfo() == nil then 
		getTaskInfo(createView) -- 如果datacache中没有数据  就再去拉取一遍
	--else
	--	createView()
	--end
	
end
