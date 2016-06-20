-- FileName: AdvMysticBoxView.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 奇遇事件：神秘宝箱UI模块
--[[TODO List]]
-- 

module("AdvMysticBoxView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

local tfd_time = nil

local tbInfo = {}
local function init(...)
	tbInfo = {}
	tfd_time = nil
end

function destroy(...)
	package.loaded["AdvMysticBoxView"] = nil
end

function moduleName()
    return "AdvMysticBoxView"
end


function initLabel( )
	local lab_title = m_fnGetWidget(m_layMain,"TFD_TITLE")
	lab_title:setText(tbInfo.title)
	LabelStroke(lab_title)

	local lab_des = m_fnGetWidget(m_layMain,"TFD_DESC")
	lab_des:setText(tbInfo.desc)
	LabelStroke(lab_des)
end

-- label添加描边 2px，＃280000
function LabelStroke( label )
	UIHelper.labelNewStroke(label, ccc3(0x28,0,0),2)
end


function initBox(tbEventData, tbArgs)

	local tbReward = lua_string_split(tbInfo.boxView,"|")
	logger:debug(tbInfo)

	local btn_item  =  nil 
	for i=1,6 do 
		btn_item = m_fnGetWidget(m_layMain,"BTN_ITEM_BG_" .. i)
		btn_item:setEnabled(false)
	end 

	-- 初始化奖励图标
	local itemData = nil 
	for i,v in ipairs(tbReward) do
		btn_item = m_fnGetWidget(m_layMain,"BTN_ITEM_BG_" .. i)
		btn_item:setEnabled(true)

		local btn_name = m_layMain["tfd_item_name_" .. i]  
		local itemInfo = ItemUtil.getItemById(tonumber(v))
		logger:debug(v)
		logger:debug(itemInfo)
		btn_name:setText(itemInfo.name)
		btn_name:setColor(g_QulityColor[itemInfo.quality])

		local icon = ItemUtil.createBtnByTemplateId(v,
						function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
							if (eventType == TOUCH_EVENT_ENDED) then
								PublicInfoCtrl.createItemInfoViewByTid(v,nil)
							end
						end) 
		btn_item:addChild(icon)
	end

	-- 三个宝箱状态,tbEventData.box={} 打开的宝箱id(0,1,2)
	for i=1,3 do 
		local btn_box_full = m_fnGetWidget(m_layMain,"BTN_BOX_" .. i .. "_1")
		btn_box_full:setEnabled(true)
		btn_box_full:setVisible(true)
		btn_box_full:setTag(i-1)
		btn_box_full:addTouchEventListener(tbArgs.onOpenBox)

		local btn_box_empty = m_fnGetWidget(m_layMain,"BTN_BOX_" .. i .. "_2")
		btn_box_empty:setEnabled(false)
		btn_box_empty:setVisible(false)
		btn_box_empty:setTag(3+i)
	end

	for k,v in pairs(tbEventData.box) do 
		local index = tonumber(v)+1
		local btn_box_full = m_fnGetWidget(m_layMain,"BTN_BOX_" .. index .. "_1")
		btn_box_full:setEnabled(false)
		btn_box_full:setVisible(false)

		local btn_box_empty = m_fnGetWidget(m_layMain,"BTN_BOX_" .. index.. "_2")
		btn_box_empty:setEnabled(true)
		btn_box_empty:setVisible(true)
	end  
end

function refreashBoxState( id )
	local btn_box_full = m_fnGetWidget(m_layMain,"BTN_BOX_" .. id .. "_1")
	btn_box_full:setEnabled(false)
	btn_box_full:setVisible(false)

	local btn_box_empty = m_fnGetWidget(m_layMain,"BTN_BOX_" .. id .. "_2")
	btn_box_empty:setEnabled(true)
	btn_box_empty:setVisible(true)
end

function updateCD( stime )
	if(tfd_time and stime)then 
		tfd_time:setText(stime)
	end
end 
	

function getCDTime( ... )
	return tfd_time:getStringValue()
end


function create(tbEventData,tbArgs)
	logger:debug(tbArgs)


	init()
	tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)

	m_layMain = g_fnLoadUI("ui/magical_thing_box_3.json")

	local img_bg = m_fnGetWidget(m_layMain,"img_bg")
	img_bg:setScale(g_fScaleX)

    tfd_time = m_fnGetWidget(m_layMain,"TFD_TIME_NUM")
    LabelStroke(tfd_time)

    local label_time = m_fnGetWidget(m_layMain,"tfd_time")  --宝箱消失时间
    LabelStroke(label_time)


	initLabel()

	initBox(tbEventData,tbArgs)

	updateCD(1234)

	
	return m_layMain
end
