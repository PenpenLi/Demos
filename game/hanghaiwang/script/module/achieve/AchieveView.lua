-- FileName: AchieveView.lua
-- Author: huxiaozhou
-- Date: 2014-11-11
-- Purpose: function description of module
-- 成就界面显示界面


module("AchieveView", package.seeall)

require "script/module/achieve/AchieveModel"

local json = "ui/achievement_list.json"
local m_i18n = gi18n
local m_i18nString = gi18nString

local listview
-- UI控件引用变量 --
-- 模块局部变量 --
local m_tbEvent
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName


local tAchives
-- 按钮的表

local function init(...)
	logger:debug("AchieveView init")
	m_tbEvent = nil
	m_mainWidget = nil
	listview = nil
end

function destroy(...)
	package.loaded["AchieveView"] = nil
end

function moduleName()
    return "AchieveView"
end

function updateCellByIdex( lsv, idx )
	local tbData = tAchives[idx+1]

	local cell = lsv:getItem(idx)

	local btnBg = m_fnGetWidget(cell, "BTN_BG")
	btnBg:setTag(tbData.id)
	btnBg:addTouchEventListener(m_tbEvent.onAction)
	btnBg:setTouchEnabled(false)


	local imgIcon = m_fnGetWidget(cell, "img_icon")
	imgIcon:loadTexture("images/base/props/" .. tbData.achie_icon)
	local aName = m_fnGetWidget(cell, "TFD_NAME") -- 成就名字
	aName:setText(tbData.achie_name)
	local aDesc = m_fnGetWidget(cell, "TFD_DESC") --成就描述
	aDesc:setText(tbData.achie_des)
	
	local quality = tbData.achie_quality
	-- local iconBg = m_fnGetWidget(cell, "IMG_ICON_BG")

	cell.item.IMG_ICON_BG:loadTexture("images/base/potential/color_" .. quality .. ".png")

	cell.item.IMG_BODER:loadTexture("images/base/potential/equip_" .. quality .. ".png")
	-- local color =  g_QulityColor2[tonumber(tbData.achie_quality)]
	-- if(color ~= nil) then
	-- 	aName:setColor(color)
	-- end
	-- UIHelper.labelNewStroke(aName,ccc3(0x39, 0x02,0x00))
	
	local imgCanGet = m_fnGetWidget(cell, "IMG_CAN_GET") -- 可领奖
	local imgRewarded = m_fnGetWidget(cell, "IMG_REACHED") -- 已经领取
	local imgNotGot = m_fnGetWidget(cell, "IMG_NOT_REACHED") -- 未完成
	imgCanGet:setEnabled(false)
	imgRewarded:setEnabled(false)
	imgNotGot:setEnabled(false)
	local lay_progress = m_fnGetWidget(cell, "lay_progress")
	lay_progress:setEnabled(true)

	local img_info_bg = m_fnGetWidget(cell, "img_info_bg")

	img_info_bg:loadTexture("ui/bag_cell_txt_1_bg.png")
	btnBg:loadTextureNormal("ui/bag_cell_1_bg.png")
	btnBg:loadTexturePressed("ui/bag_cell_1_bg.png")


	if tbData.status == 0 then
		imgNotGot:setEnabled(true)
	elseif tbData.status == 1 then
		btnBg:setTouchEnabled(true)
		imgCanGet:setEnabled(true)
		lay_progress:setEnabled(false)
		img_info_bg:loadTexture("images/common/cell/bag_cell_txt_3_bg.png")
		btnBg:loadTextureNormal("images/common/cell/bag_cell_3_bg.png")
		btnBg:loadTexturePressed("images/common/cell/bag_cell_3_bg.png")
	elseif tbData.status == 2 then
		imgRewarded:setEnabled(true)
	end

	local TFD_LEFT = m_fnGetWidget(cell, "TFD_LEFT")
	local TFD_RIGHT = m_fnGetWidget(cell, "TFD_RIGHT")
	TFD_LEFT:setText(tbData.finish_num)
	TFD_RIGHT:setText(tbData.max_num)

	local name, num = AchieveModel.getStringByRewardStr(tbData.achie_reward)
	local TFD_REWARD_NAME = m_fnGetWidget(cell, "TFD_REWARD_NAME")
	TFD_REWARD_NAME:setText(name)
	local TFD_REWARD_NUM = m_fnGetWidget(cell, "TFD_REWARD_NUM")
	TFD_REWARD_NUM:setText(num)
	local tfd_reward = m_fnGetWidget(cell, "tfd_reward")
	tfd_reward:setText(m_i18n[1994])
	local TFD_PROGRESS = m_fnGetWidget(cell, "TFD_PROGRESS")
	TFD_PROGRESS:setText(m_i18n[1011])
end

local function getListCount(  )
	return #tAchives
end

-- 加载UI
local function loadUI(  )
	tAchives = AchieveModel.getShowAchieves()
	local cell = m_fnGetWidget(m_mainWidget, "lay_cell")
	local bg = m_fnGetWidget(cell, "BTN_BG")
	bg:setScale(g_fScaleX)
	cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX , cell:getSize().height * g_fScaleX))

	UIHelper.initListViewCell(listview)
	UIHelper.reloadListView(listview,getListCount(),updateCellByIdex,nil,true)
end

-- 领取奖励后刷新UI
function reLoadUI()
	tAchives = AchieveModel.getShowAchieves()
	UIHelper.reloadListView(listview,getListCount(),updateCellByIdex)
end


function create(tbEvent)
	init()
	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	listview = m_fnGetWidget(m_mainWidget, "LSV_LIST")
	loadUI()
	UIHelper.registExitAndEnterCall(m_mainWidget, function (  )
		GlobalNotify.removeObserver(GlobalNotify.PUSHNEWACHIEVE, GlobalNotify.PUSHNEWACHIEVE)
	end, function (  )
		GlobalNotify.addObserver(GlobalNotify.PUSHNEWACHIEVE, function (  )
			MainAchieveView.updateRedPoint()
			AchieveView.reLoadUI()
		end, nil, GlobalNotify.PUSHNEWACHIEVE)
	end)
	return m_mainWidget
end
