-- FileName: ExplorEntCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 进入某个副本探索前的界面
--[[TODO List]]

require "script/module/copy/ExploreProgressRewardCtrl"

module("ExplorEntCtrl", package.seeall)

-- UI控件引用变量 --
local mainLayer = nil
local layoutMain
-- 模块局部变量 --
local copeInfoData = nil

local function init(...)
	local copyname = g_fnGetWidgetByName(mainLayer, "TFD_COPY_NAME")
	copyname:setText(copeInfoData.name)
	
	local itemArr=lua_string_split(copeInfoData.preview_reward,",")
	createRewardList(itemArr)
	UIHelper.labelNewStroke( mainLayer.TFD_LEFT_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayer.TFD_RIGHT_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayer.tfd_slant, ccc3(0x28,0x00,0x00), 2 )
	update()
end

function destroy(...)
	package.loaded["ExplorEntCtrl"] = nil
end

function moduleName()
    return "ExplorEntCtrl"
end
function update()
	local min,max = ExplorData.getExploreProgress()
	mainLayer.TFD_LEFT_NUM:setText(min)
	mainLayer.TFD_RIGHT_NUM:setText(max)

	local npercent = min/max * 100
	local progress = g_fnGetWidgetByName(mainLayer, "LOAD_FINISH")
	progress:setPercent((npercent > 100) and 100 or npercent)

	--进度奖励
	local rewardBtn = g_fnGetWidgetByName(mainLayer, "IMG_SUPAR_REWARD_BG")
	rewardBtn:removeAllChildrenWithCleanup(true)
	rewardBtn:addChild(ExploreProgressRewardCtrl.create(update))
end
function create(ncopyid)
	logger:debug("enter explor ncopyId =="..ncopyid)
	copeInfoData=DB_Copy.getDataById(ncopyid)
	--主背景UI
	layoutMain = Layout:create()
	layoutMain:setSize(g_winSize)
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			)
		--副本标签
		mainLayer = g_fnLoadUI("ui/explore_explain.json")
		mainLayer:setSize(g_winSize)
		layoutMain:addChild(mainLayer)
		
		local closeBtn = g_fnGetWidgetByName(mainLayer, "BTN_CLOSE")
		UIHelper.titleShadow(closeBtn)
		
		closeBtn:addTouchEventListener(
			function(sender, eventType)
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playBackEffect() --返回音效  
				LayerManager.removeLayout()
			end
			)
		
		

		local enterBtn = g_fnGetWidgetByName(mainLayer, "BTN_ENTER")
		UIHelper.titleShadow(enterBtn, gi18n[3104])
		enterBtn:addTouchEventListener(
			function(sender, eventType)
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playCommonEffect() 
				LayerManager.removeLayout()
				MainCopy.setScrollOffset()
				require "script/module/copy/ExplorMainCtrl"
				local explorMain = ExplorMainCtrl.create(ncopyid)
				LayerManager.changeModule(explorMain, ExplorMainCtrl.moduleName(), {1,3}, true)
				PlayerPanel.addForExplorNew()
			end
			)

		local cross = MainCopy.fnCrossCopy(ncopyid)
		local canExplorStatus = copeInfoData.is_exploration==1 and true or false
		if (cross) then
			mainLayer.TFD_OPEN:setVisible(false)
		else
			local tmpStr=gi18n[1972]
			enterBtn:setTouchEnabled(false)
			UIHelper.setWidgetGray(enterBtn,true)
			mainLayer.TFD_OPEN:setText(string.format(tmpStr,copeInfoData.name,copeInfoData.name))
		end

		-- local rewardTfd = g_fnGetWidgetByName(mainLayer, "tfd_reward_title")
		-- UIHelper.labelNewStroke( rewardTfd, ccc3(0x48,0x12,0x00), 2 )
		init()
	end

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideExploreView"
	if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createExploreGuide(3)
	end

	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 7) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTreasGuide(8)
	end

	return layoutMain
end

--创建奖励列表
function createRewardList(_tbItems)
	local LSV_DROP = g_fnGetWidgetByName(mainLayer,"LSV_REWARD_BIG") -- listview
	UIHelper.initListView(LSV_DROP)

	logger:debug(_tbItems)

	local tbSortData = {}

	local tbSub = {}
	for i,v in ipairs(_tbItems) do
		table.insert(tbSub,v)
		if(table.maxn(tbSub)>=4) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		elseif(i==table.maxn(_tbItems)) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		end
	end

	local cell
	for i, itemInfo in ipairs(tbSortData) do
		LSV_DROP:pushBackDefaultItem()
		cell = LSV_DROP:getItem(i-1)  -- cell 索引从 0 开始
		for s,index in ipairs(itemInfo) do
			local itemObj = ItemUtil.getItemById(tonumber(index))
			local item = {}
			item.name = itemObj.name
			item.quality = itemObj.quality
			item.icon = ItemUtil.createBtnByTemplateId(index,
							function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
								if (eventType == TOUCH_EVENT_ENDED) then
									-- AudioHelper.playCommonEffect() -- sunyunpeng 2016.01.03 
									PublicInfoCtrl.createItemInfoViewByTid(index)
								end
							end) 


			local itemlay=g_fnGetWidgetByName(cell,"lay_recruit_bg"..s)

			local img = g_fnGetWidgetByName(itemlay,"IMG_SHOP_RECRUIT_PREVIEW_HEAD_BG")
			img:addChild(item.icon)

			local labName = g_fnGetWidgetByName(itemlay, "TFD_SHOP_RECRUIT_PREVIEW_NAME") -- 名称
			labName:setText(item.name)

			if (item.quality ~= nil) then

				local color =  g_QulityColor2[tonumber(item.quality)]
				if(color ~= nil) then
					labName:setColor(color)
				end
			end

			if (s == table.maxn(itemInfo) and s < 4) then --移除剩余的
				for j=s+1,4 do
					local itemlay=g_fnGetWidgetByName(cell,"lay_recruit_bg"..j)
					itemlay:removeFromParent()
				end
			end	
		end

	end
end