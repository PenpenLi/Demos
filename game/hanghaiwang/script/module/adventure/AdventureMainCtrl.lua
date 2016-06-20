-- FileName: AdventureMainCtrl.lua
-- Author: liweidong
-- Date: 2015-04-02
-- Purpose: 奇遇主界面列表
--[[TODO List]]

module("AdventureMainCtrl", package.seeall)
require "script/module/adventure/AdBattleEventCtrl"
require "script/module/adventure/AdBattleSingleEventCtrl"
require "script/module/adventure/AdvFrdsCtrl"
require "script/module/adventure/AdvSingleBoxCtrl"
require "script/module/adventure/AdvQuestionCtrl"
require "script/module/adventure/AdvMysticBoxCtrl"
require "script/module/adventure/AdvTraderCtrl"
require "script/module/adventure/AdvRecruitCtrl"

-- UI控件引用变量 --
local layoutMain=nil
-- 模块局部变量 --
local eventData=nil
--db事件对应的处理ctrl
local eventCtrls = {
	[4]=AdBattleEventCtrl,  --继承血量战斗 遭遇海王类
	[5]=AdBattleSingleEventCtrl, --非继承血量战斗
	[6]=AdvTraderCtrl, --神秘熊猫人
	[7]=AdvRecruitCtrl,  --伙伴招募 -慕名而来
	[8]=AdvFrdsCtrl, --好友 -声明远播
	[9]=AdvQuestionCtrl,  --答题事件
	[10]=AdvMysticBoxCtrl,  --神秘宝箱事件 三个宝箱
	[11]=AdvSingleBoxCtrl  --奇遇宝箱 一个宝箱
}
--当前所指向的事件处理ctrl
local curEventCtrl=nil
local curEventInfoId=nil

local function init(...)
	require "script/module/adventure/AdventureModel"
	AdventureModel.refreshAdventureData() --刷新数据
	eventData=AdventureModel.getAdventureData()
	logger:debug("event Data")
	logger:debug(eventData)
end

function destroy(...)
	package.loaded["AdventureMainCtrl"] = nil
end

function moduleName()
    return "AdventureMainCtrl"
end
function updateLSVPos(index)
	index = index or 1
	local LSV_LIST = g_fnGetWidgetByName(layoutMain, "LSV_LIST")
	local listPos=LSV_LIST:getWorldPosition()
	local listRect=CCRectMake(listPos.x,listPos.y,LSV_LIST:getViewSize().width,LSV_LIST:getViewSize().height)
	local leftBorder = listRect.origin.x
	local rightBorder = listRect.origin.x + LSV_LIST:getViewSize().width
	local cell = LSV_LIST:getItem(index-1)
	if cell then
		cell = tolua.cast(cell,"Widget")
		local cellPos=cell:getWorldPosition()
		logger:debug("listPos.x = %s , listPos.y = %s", listPos.x, listPos.y)
		logger:debug("cellPos.x = %s , cellPos.y = %s", cellPos.x, cellPos.y)
		logger:debug("listRect.x = %s", listRect.origin.x + LSV_LIST:getViewSize().width)
		logger:debug("cellPos.x+cell:getSize().width = %s",cellPos.x+cell:getSize().width)

		local cellRight = cellPos.x+cell:getSize().width
		local cellLeft = cellPos.x

		-- 如果在cell 在 listview 外部 右边外部 左边外部不用处理
		if cellLeft >= rightBorder then
			local offset = LSV_LIST:getContentOffset()
			logger:debug("offset.x = %s offset.x = %s", offset, offset)
			LSV_LIST:setContentOffset(ccp(offset-cellRight+rightBorder,0))
		end


		if listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y))then
			return
		end

		
		if listRect:containsPoint(cellPos) and not listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = LSV_LIST:getContentOffset()
			logger:debug("offset.x = %s offset.x = %s", offset, offset)
			LSV_LIST:setContentOffset(ccp(offset-cellRight+rightBorder,0))
		end

		if not listRect:containsPoint(cellPos) and listRect:containsPoint(ccp(cellPos.x+cell:getSize().width, cellPos.y)) then
			local offset = LSV_LIST:getContentOffset()
			logger:debug("offset.x = %s offset.x = %s", offset, offset)
			LSV_LIST:setContentOffset(ccp(offset+leftBorder-cellLeft,0))
		end
	end
end

--点击某个菜单
function onClickMenuList( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	local idx=sender:getTag()
	loadEventCtrl(idx)
	updateLSVPos(idx)
end
--初始化列表菜单
function initTopListInfo()
	layoutMain.img_bg_top:setScale(g_fScaleX)
	local menuList = g_fnGetWidgetByName(layoutMain, "LSV_LIST")
	UIHelper.initListView(menuList)
	UIHelper.initListWithNumAndCell(menuList,#eventData)
	local i = 0
	for k,v in ipairs(eventData) do
		local cell = menuList:getItem(i) --tolua.cast(menuList:getItem(i), "Widget")  -- cell 索引从 0 开始
		local menuBtn = g_fnGetWidgetByName(cell, "BTN_BG")
		menuBtn:setTouchEnabled(true)
		menuBtn:setTag(k)
		menuBtn:addTouchEventListener(onClickMenuList)
		local eventInfo=eventData[k]
		require "db/DB_Exploration_things"
		local eventDb=DB_Exploration_things.getDataById(eventInfo.etid)
		cell.IMG_ICON:loadTexture("images/adventure/menuicon/"..eventDb.icon)
		cell.IMG_THING_NAME:loadTexture("images/adventure/supar_thing_name/"..eventDb.icon)
		i=i+1
	end
end
--单独更新菜单上的时间 
function updateTopListTime()
	local menuList = g_fnGetWidgetByName(layoutMain, "LSV_LIST")
	local i = 0
	local cell=nil
	for k,v in ipairs(eventData) do
		cell = menuList:getItem(i)  -- cell 索引从 0 开始
		local lbTime = g_fnGetWidgetByName(cell, "TFD_TIME")
		local _,timeStr=AdventureModel.getRemainTimeSec(v.index)
		lbTime:setText(timeStr)
		i=i+1
	end
	if (curEventCtrl.updateCD) then
		local _,timeStr = AdventureModel.getRemainTimeSec(curEventInfoId)
		curEventCtrl.updateCD(timeStr)
	end
end
--加载某个事件ctrl
function loadEventCtrl(idx)
	local eventInfo=eventData[idx]
	curEventInfoId=eventInfo.index
	require "db/DB_Exploration_things"
	local eventDb=DB_Exploration_things.getDataById(eventInfo.etid)
	curEventCtrl=eventCtrls[tonumber(eventDb.thingType)]
	layoutMain:removeChildByTag(100, true) --可能涉及到相同事件切换，如果最后remove 可能在onExit中把界面变量置为空
	
	local eventLayout = curEventCtrl.create(eventInfo.index)
	if (curEventCtrl.updateCD) then
		local _,timeStr = AdventureModel.getRemainTimeSec(curEventInfoId)
		curEventCtrl.updateCD(timeStr)
	end
	if (eventLayout) then
		layoutMain:addChild(eventLayout,1,100)
	end

	local i = 0
	local cell=nil
	local menuList = g_fnGetWidgetByName(layoutMain, "LSV_LIST")
	for k,v in ipairs(eventData) do
		cell = menuList:getItem(i)  -- cell 索引从 0 开始
		local menuBtn = g_fnGetWidgetByName(cell, "BTN_BG")
		menuBtn:setTouchEnabled(true)
		local lightImg = g_fnGetWidgetByName(cell, "img_light")
		lightImg:setVisible(false)
		if (k==idx) then
			lightImg:setVisible(true)
			menuBtn:setTouchEnabled(false)
		end
		i=i+1
	end
end
--传入copyId，用于返回某个副本的探索主界面
function create(copyId)
	init()
	--主背景UI
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			)
		mainLayout = g_fnLoadUI("ui/magical_thing_list.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout,2)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_BACK")
		UIHelper.titleShadow(backBtn, gi18n[1019])
		backBtn:addTouchEventListener(
					function ( sender, eventType )
						if (eventType ~= TOUCH_EVENT_ENDED) then
							return
						end
						AudioHelper.playBackEffect() --返回音效
						require "script/module/copy/MainCopy"
						MainCopy.enterToExploreBaseNormal(copyId)
					end
			)
		initTopListInfo() --加载菜单列表
		loadEventCtrl(1)  --加载事件ctrl
		updateTopListTime() --提前更新一次时间
		schedule(layoutMain,updateTopListTime,1.0) --创建定时，更新剩余时间
	end
	return layoutMain
end
