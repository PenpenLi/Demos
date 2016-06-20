-- FileName: activityCtrl.lua
-- Author:  lizy
-- Date: 2014-05-15
-- Purpose: 活动模块的控制层
--[[TODO List]]
-------------------------------------------------
-- changeLog: modified by huxiaozhou 2015-01-09
-- 整理代码
-------------------------------------------------


module("MainActivityCtrl", package.seeall)
require "script/module/activity/MainActivityView"
require "script/module/config/AudioHelper"


-- UI控件引用变量 --
local m_layMain -- zhangqi, 2014-07-28, 主画布layout，便于添加玩家信息条

-- 模块局部变量 --
tBtnImgs = {}


--跳转到竞技场
function onArena(  )
	if(not SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
		return
	end
 	require "script/module/arena/MainArenaCtrl"     
    MainArenaCtrl.create()
end
--跳转到夺宝
function onGrabTrea(  )
   require "script/module/grabTreasure/MainGrabTreasureCtrl"
   MainGrabTreasureCtrl.create()
end

-- 去打世界boss
function onBoss(  )
	if(not SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,true)) then
		return
	end
	require "script/module/WorldBoss/MainWorldBossCtrl"
	MainWorldBossCtrl.create(true)
end

-- 去空岛爬塔
function onSkyPiea(  )
	if(not SwitchModel.getSwitchOpenState(ksSwitchTower,true)) then
		return
	end
	require "script/module/SkyPiea/MainSkyPieaCtrl"
	MainSkyPieaCtrl.create()
end

-- 去活动副本
function onAcopy(  )
	--活动副本
	if (SwitchModel.getSwitchOpenState(ksSwitchActivityCopy,true)) then
		require "script/module/copyActivity/MainCopyCtrl"
		MainCopyCtrl.create()
	end
	
end
--去探索
function onExplore()
	require "script/module/copy/MainCopy"
	MainCopy.extraToExploreScene()
end

-- 去资源矿
function onMine()
	if (SwitchModel.getSwitchOpenState(ksSwitchResource,true)) then
		require "script/module/mine/MainMineCtrl"
		MainMineCtrl.create()
	end
end

-- 去深海监狱
function onImpel()
	if (SwitchModel.getSwitchOpenState(ksSwitchImpelDown,true)) then
		require "script/module/impelDown/MainImpelDownCtrl"
		MainImpelDownCtrl.create()
	end
end


local imgPath = "images/active/"
local tbArena =  {n = imgPath .. "active_arena_n.png", h = imgPath .. "active_arena_h.png", p = imgPath .. "active_arena_info.png", key = "arena", switchId = 8, btnEvent = onArena}
local tbAcopy =  {n = imgPath .. "active_acopy_n.png", h = imgPath .. "active_acopy_h.png", p = imgPath .. "active_acopy_info.png", key = "acopy", switchId = 9, btnEvent = onAcopy}
local tbExplore =  {n = imgPath .. "active_explore_n.png", h = imgPath .. "active_explore_h.png", p = imgPath .. "active_explore_info.png",}
local tbSkyPiea = {n = imgPath .. "active_skypiea_n.png", h = imgPath .. "active_skypiea_h.png", p = imgPath .. "active_skypiea_info.png"}
local tbBoss = {n = imgPath .. "active_boss_n.png", h = imgPath .. "active_boss_h.png", p = imgPath .. "active_boss_info.png", key = "boss",  switchId = 27, btnEvent = onBoss}
local tbMine = {n = imgPath .. "active_res_n.png", h = imgPath .. "active_res_h.png", p = imgPath .. "active_res_info.png", key = "mine",  switchId = 11, btnEvent = onMine}
local tbImpelDown = {n = imgPath .. "active_impel_down_n.png", h = imgPath .. "active_impel_down_h.png", p = imgPath .. "active_impel_down_info.png", key="impel", switchId = 38, btnEvent = onImpel}


local tGuide = {
	[ksGuideArena] = "arena",
	[ksGuideAcopy] = "acopy",
	[ksGuideSkypiea] = "",
	[ksGuideResource] = "mine",
	[ksGuideBoss]     = "boss",
	[ksGuideImpelDown] = "impel",
}

local function getActitiyInTimeByType(tImgs)
	local ttImgs = {}
	for index,v in ipairs(tImgs or {}) do
		if v.key == "boss" and WorldBossModel.isOpen() then
			table.insert(ttImgs, 1, tImgs[index])
		else
			table.insert(ttImgs, tImgs[index])
		end
	end
	return ttImgs
end

local function getActivityTypeGuide( tImgs, guideType)
	local ttImgs = {}
	for index,v in ipairs(tImgs or {}) do
		if v.key == tGuide[guideType] then
			table.insert(ttImgs, 1, tImgs[index])
		else
			table.insert(ttImgs, tImgs[index])
		end
	end
	return ttImgs
end

-- 获取默认的排序列表
local function getDefautArr( )
	local tbBtnImgs = {tbArena, tbAcopy,tbMine, tbBoss, tbImpelDown}
	table.sort(tbBtnImgs, function ( t1, t2)
		local level1 = DB_Switch.getDataById(t1.switchId).level
		local level2 = DB_Switch.getDataById(t2.switchId).level
		return tonumber(level1) < tonumber(level2)
	end)
	return tbBtnImgs
end


local tableReverse = function ( tbArr )
	local tbReverse = {}
	for i,v in ipairs(tbArr or {}) do
		tbReverse[v] = i
	end
	return tbReverse
end
local function fuctionForGuide( ... )

	local tbBtnImgs = getDefautArr()
	local guideType = GuideModel.getGuideClass()
	if tGuide[guideType] ~= nil then
		tBtnImgs = getActivityTypeGuide(tbBtnImgs, guideType)
	else
		tBtnImgs = getActitiyInTimeByType(tbBtnImgs)
	end

	for i,tb in ipairs(tBtnImgs) do
		tb[tb.key] = i
	end

	logger:debug({tBtnImgs = tBtnImgs})
end



local function init(...)
	fuctionForGuide()
end

function destroy(...)
	package.loaded["MainActivityCtrl"] = nil
end

function moduleName()
    return "MainActivityCtrl"
end

--显示活动场景
function create( ... )
	-- 按钮事件
	local tbBtnEvent = {}
	
	-- 竞技按钮
	tbBtnEvent.onAction = function ( sender, eventType)
		
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("huodong.mp3")
			local sender = tolua.cast(sender, "Button")
			local senderType = sender:getTag()
			logger:debug("senderType = %s", senderType)
			logger:debug({tbValue = tBtnImgs[senderType]})
			tBtnImgs[senderType].btnEvent()			
		end
	end
    init()
	m_layMain =  MainActivityView.create(tbBtnEvent)
	return m_layMain
end

