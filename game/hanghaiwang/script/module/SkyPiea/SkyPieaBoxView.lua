-- FileName: SkyPieaBoxView.lua
-- Author: menghao
-- Date: 2015-1-14
-- Purpose: 空岛宝箱层开启箱子view


module("SkyPieaBoxView", package.seeall)


-- UI控件引用变量 --
local m_UIMain
local img_effect 		 = nil 
local TFD_TIMES_NUM 	= nil
local btnBack 			= nil
local btnOpen 			= nil
local m_tbEvent 		= nil
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local OPEN_ANIM_TAG = 101
local DOOR_ANIM_TAG = 102
local m_i18nString = gi18nString
local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaBoxView"] = nil
end


function moduleName()
	return "SkyPieaBoxView"
end

function setMainUIUnVisible()
	m_UIMain:setVisible(false)
end

function setMainUIVisible( _visible)
	m_UIMain:setVisible(_visible)
	if(_visible == true) then
		addDoorAnimationNode()
	end
end

--添加开启宝藏的特效
function addOpenAnimationNode(callBack)
	img_effect:removeNodeByTag(OPEN_ANIM_TAG)
	local tbParams = {
		filePath = "images/effect/skypiea/door.ExportJson",
		animationName = "door",
		-- fnMovementCall = callBack,
		fnFrameCall = function (  bone,frameEventName,originFrameIndex,currentFrameIndex )
			if (frameEventName == "1") then
					callBack()
			end
		end
		}

	--音效
	AudioHelper.playEffect("audio/effect/texiao_shenmikongdao_baozang.mp3")
	local effectNode = UIHelper.createArmatureNode(tbParams)
	-- effectNode:getAnimation():gotoAndPause(10)
	-- effectNode:setAnchorPoint(ccp(0.0,0.0))
	effectNode:setPositionY(effectNode:getPositionY() - 97)
	-- effectNode:setScale(g_fScaleX)
	img_effect:addNode(effectNode,111,OPEN_ANIM_TAG)

end

--添加大门的静止的特效
function addDoorAnimationNode()
	img_effect:removeNodeByTag(OPEN_ANIM_TAG)
	local tbParams = {
		filePath = "images/effect/skypiea/door_nor.ExportJson",
		animationName = "door_nor",
		loop = -1
		}

	local effectNode = UIHelper.createArmatureNode(tbParams)
	-- effectNode:getAnimation():setSpeedScale(0.75)
	-- effectNode:setAnchorPoint(ccp(0.0,0.0))
	effectNode:setPositionY(effectNode:getPositionY() - 70)
	-- effectNode:setPosition(ccp(img_effect:getSize().width / 2,img_effect:getSize().height / 2))
	-- effectNode:setPosition(ccp(0,0))
	img_effect:addNode(effectNode,111,OPEN_ANIM_TAG)

end

function setGoldUI()

	local bCanOpen = SkyPieaModel.canOpenBox()
	logger:debug("还可以继续开宝箱么？")
	logger:debug(bCanOpen)
	btnOpen:addTouchEventListener(m_tbEvent.onOpen)

	--再次开启所需要的金币数量
	local tfdGold = m_fnGetWidget(m_UIMain, "TFD_GOLD")
	local price = SkyPieaModel.getBuyOpenBoxGoldByTimes()
	logger:debug("开启宝箱的金币数量为")
	logger:debug(price)
	tfdGold:setText(tostring(price))

	TFD_TIMES_NUM:setText(tostring(SkyPieaModel.getCanOpenBoxNum()))
end


function create(tbEvent)
	m_tbEvent = tbEvent
	m_UIMain = g_fnLoadUI("ui/air_open_box.json")

	img_effect = m_fnGetWidget(m_UIMain,"img_effect")
	local tfd_open = m_fnGetWidget(m_UIMain,"tfd_open")
	local tfd_conch = m_fnGetWidget(m_UIMain,"tfd_conch")
	local tfd_coin = m_fnGetWidget(m_UIMain,"tfd_coin")
	local tfd_item = m_fnGetWidget(m_UIMain,"tfd_item")
	tfd_open:setText(m_i18nString(5465))
	tfd_conch:setText(m_i18nString(5501))
	tfd_coin:setText(m_i18nString(5414))
	tfd_item:setText(m_i18nString(5466))

	btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")
	btnBack:addTouchEventListener(m_tbEvent.onLeave)
	UIHelper.titleShadow(btnBack,m_i18nString(5475))

	btnOpen = m_fnGetWidget(m_UIMain, "BTN_OPEN")
	-- btnOpen:setTitleText(m_i18nString(5464," "))
	UIHelper.titleShadow(btnOpen,m_i18nString(5464," "))

	local tfd_times = m_fnGetWidget(m_UIMain, "tfd_times")     							--剩余开启次数：
	TFD_TIMES_NUM   = m_fnGetWidget(m_UIMain, "TFD_TIMES_NUM")     					--剩余开启次数：数值
	TFD_TIMES_NUM:setText(SkyPieaModel.getCanOpenBoxNum())

	setGoldUI()

	require "db/DB_Normal_config"
	require "db/DB_Item_normal"
	local tbItemData  = lua_string_split(DB_Normal_config.getDataById(1).air_island_reward, "|")
	-- 道具展示
	for i=1,4 do
		local imgItem = m_fnGetWidget(m_UIMain, "IMG_ITEM_" .. i)
		local tfdItemName = m_fnGetWidget(m_UIMain, "TFD_NAME_" .. i)

		local item_tid = tbItemData[i]
		local itemIcon , itemInfo= ItemUtil.createBtnByTemplateId(item_tid, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(item_tid)
			end
		end)
		logger:debug(itemIcon)
		imgItem:addChild(itemIcon)
		tfdItemName:setText(itemInfo.name)
		tfdItemName:setColor(g_QulityColor[tonumber(itemInfo.quality)])
	end

	addDoorAnimationNode()
	return m_UIMain
end


