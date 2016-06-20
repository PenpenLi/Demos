-- FileName: ExplorRewardCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 探索获得物品奖励及领取
--[[TODO List]]

module("ExplorRewardCtrl", package.seeall)

-- UI控件引用变量 --
local layoutMain = nil
local mainLayer = nil
-- 模块局部变量 --
local iteminfo = nil
local eventinfo = nil
local  itemnamestr = ""
local m_callback=nil
local m_isAdventure =nil --"是否是奇遇中掉落的物品"

local function init(...)
	--说话文案
	local sayText = g_fnGetWidgetByName(mainLayer, "TFD_EXPLAIN")
	sayText:setText(eventinfo.thingDesc)

	--显示item
	local itemid,itemnum = 0,0
	for key,val in pairs(iteminfo) do
		itemid,itemnum=key,val
	end
	local itemObj = ItemUtil.getItemById(itemid)
	local item = {}
	item.name = itemObj.name
	item.quality = itemObj.quality
	item.icon = ItemUtil.createBtnByTemplateId(itemid,
					function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(itemid)
							--AudioHelper.playCommonEffect()
						end
					end)
	local itembg = g_fnGetWidgetByName(mainLayer, "IMG_ITEM_BG")
	itembg:addChild(item.icon)
	local itemType=ItemUtil.getItemTypeByTid(itemid)
	-- itemType.isSpeTreasureFragment = true --test code
	if (itemType.isFragment or itemType.isTreasureFragment or itemType.isSpeTreasureFragment) then
		itemnamestr=item.name..gi18n[2448].."*"..itemnum
	elseif (itemType.isShadow) then
		itemid = tonumber(itemid)
		if (itemid==440022 or itemid==440023 or itemid==440001 or itemid==440002) then
			itemnamestr=item.name.."*"..itemnum
		else
			itemnamestr=item.name..gi18n[1002].."*"..itemnum
		end
	else
		itemnamestr=item.name.."*"..itemnum
	end
	local itemname = g_fnGetWidgetByName(mainLayer, "TFD_ITME_NAME")
	itemname:setText(itemnamestr)
	UIHelper.labelNewStroke(itemname,ccc3(0x28,0,0))
	if (item.quality ~= nil) then
		local color =  g_QulityColor2[tonumber(item.quality)]
		if(color ~= nil) then
			itemname:setColor(color)
		end
	end

	local actionCallback = function()
		local getBtn = g_fnGetWidgetByName(mainLayer, "BTN_GET")
		--UIHelper.titleShadow(getBtn,"获取")
		
		local akeyDelayTime = 0
		if (itemType.isSpeTreasureFragment) then
			akeyDelayTime=2.5
			-- LayerManager.addUILayer()
			local aniImg = g_fnGetWidgetByName(mainLayer, "IMG_EFFECT")
			local m_arAni1 = UIHelper.createArmatureNode({
				filePath = "images/effect/explore_exclusive/explore_exclusive.ExportJson",
				animationName = "explore_exclusive",
				loop = 0,
				fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
								if (frameEventName == "1") then
									--1小女孩出现
									mainLayer.img_txt_bg:setVisible(true)
								end
								if (frameEventName == "2") then
									--2图标 并 特效1
									itembg:setVisible(true)
									local m_arAni2 = UIHelper.createArmatureNode({
											filePath = "images/effect/explore_exclusive_1/explore_exclusive_1.ExportJson",
											animationName = "explore_exclusive_1",
											loop = -1
										})
									aniImg:addNode(m_arAni2)
								end
								if (frameEventName == "3") then
									--3 特效2出现
									AudioHelper.playSpecialEffect("explore_exclusive_01.mp3")
									local m_arAni2 = UIHelper.createArmatureNode({
											filePath = "images/effect/explore_exclusive_02/explore_exclusive_02.ExportJson",
											animationName = "explore_exclusive_02",
											loop = 0
										})
									m_arAni2:setPosition(ccp(0,aniImg:getSize().height/2+65))
									mainLayer.IMG_EFFECT_TXT:addNode(m_arAni2)
									getBtn:setTouchEnabled(true)
								end
							end,
				fnMovementCall = function ( armature,movementType,movementID )
								if (movementType == 1) then
									
								end
							end
			})
			mainLayer.IMG_EFFECT_1:addNode(m_arAni1)
			AudioHelper.playSpecialEffect("explore_exclusive.mp3")
		else
			getBtn:setTouchEnabled(true)
			playItemAnimation(item.quality)
			AudioHelper.playBtnEffect("tansuo02.mp3")
		end

		require "script/module/guide/GuideModel"
		if (GuideModel.getGuideClass() == ksGuideRobTreasure) then
			ExploreKeyCtrl.removeKeyExplore() -- 如果是一键探索 则停止一键探索
			require "script/module/guide/GuideCtrl"
			local scene = CCDirector:sharedDirector():getRunningScene()
		    performWithDelay(scene, function(...)
		        local pos = getBtn:getWorldPosition()
    			GuideCtrl.createRobGuide(1,0,pos)
		    end, 0.05)
			
		end

		if (GuideModel.getGuideClass() == ksGuideTreasure) then
			ExploreKeyCtrl.removeKeyExplore() -- 如果是一键探索 则停止一键探索
			require "script/module/guide/GuideCtrl"
    		
    		local scene = CCDirector:sharedDirector():getRunningScene()
		    performWithDelay(scene, function(...)
		        local pos = getBtn:getWorldPosition()
    			GuideCtrl.createTreasGuide(1, 0, pos)
		    end, 0.05)
		end

		ExploreKeyCtrl.clickGetItemBtn(m_isAdventure,akeyDelayTime) --告诉控制器点击获取按钮
		

	end
	itembg:setVisible(false)
	local array = CCArray:create()
	
	if (itemType.isSpeTreasureFragment) then
		mainLayer.img_txt_bg:setVisible(false)
		array:addObject(CCDelayTime:create(0.3))
		-- array:addObject(CCShow:create())
	else
		array:addObject(CCShow:create())
		local pos= itembg:getPositionPercent()
		local posx,posy= itembg:getPosition()
		itembg:setPositionType(POSITION_ABSOLUTE)
		itembg:setPosition(ccp(posx,g_winSize.height/2+posy))
		local easeMove=CCEaseExponentialIn:create(CCMoveTo:create(0.3, ccp(posx,posy))) 
		array:addObject(easeMove)
	end
	
	-- 暂时保留注释动画需求不稳定
	-- local moveByPos = CCMoveBy:create(0.7, ccp(0,-layoutMain:getContentSize().height*1.3))
	-- local easeSine=CCEaseExponentialIn:create(moveByPos
	array:addObject(CCCallFuncN:create(actionCallback))
	local action = CCSequence:create(array)
	itembg:runAction(action)
end

--[[desc:奖励物品背景特效果
    arg1: nil
    return: nil  
—]]
function playItemAnimation(quality)
	local tbNames = {"win_drop_black/white", "win_drop_black/white", "win_drop_green", "win_drop_blue", "win_drop_purple", "win_drop_orange"}
	local aniImg = g_fnGetWidgetByName(mainLayer, "IMG_EFFECT")
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = "images/effect/battle_result/win_drop.ExportJson",
		animationName = tbNames[tonumber(quality)],
		loop = -1,
	})
	--m_arAni1:setAnchorPoint(ccp(0.5,1))
	aniImg:addNode(m_arAni1,-100)
end
function destroy(...)
	package.loaded["ExplorRewardCtrl"] = nil
end

function moduleName()
    return "ExplorRewardCtrl"
end

function showItemRward(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	if (m_callback) then
		m_callback()
	end
	AudioHelper.playBtnEffect("tansuo02.mp3")
	-- AudioHelper.playCommonEffect()
	LayerManager.removeLayout()
	--暂时保留注释
	-- UIHelper.showExplorDropItemDlg({item=iteminfo},gi18n[1932],function()
	-- 		LayerManager.removeLayout()
	-- 	end
	-- )
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideRobView"
	if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		local pos = ExplorMainCtrl.getRobBtnWorldPos()
		GuideCtrl.createRobGuide(2, 0, pos)
	end

	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTreasGuide(2)
	end

	ShowNotice.showShellInfo(gi18n[2632]..itemnamestr)
end
--[[desc:功能简介
    arg1: item：{id=数量}  eventid:探索事件id
    return: 是否有返回值，返回值说明  
—]]
function create(item,eventid,callback,isAdventure)
	LayerManager.removeLayoutByName("Explor_mask_layout") --只要出现物品就移除探索mask
	m_callback=callback
	m_isAdventure = isAdventure
	iteminfo=item
	logger:debug("drow item =======")
	logger:debug(iteminfo)
	eventinfo=DB_Exploration_things.getDataById(eventid)
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
		--副本标签
		mainLayer = g_fnLoadUI("ui/explore_item_reward.json")
		mainLayer:setSize(g_winSize)
		layoutMain:addChild(mainLayer)
		
		local getBtn = g_fnGetWidgetByName(mainLayer, "BTN_GET")
		getBtn:setTouchEnabled(false)
		getBtn:addTouchEventListener(showItemRward)
		UIHelper.titleShadow(getBtn,gi18n[4342])
		
		init()
	end

	return layoutMain
end
