-- FileName: ArenaLuckView.lua
-- Author: huxaozhou
-- Date: 2014-05-12
-- Purpose: function description of module
--[[TODO List]]

module("ArenaLuckView", package.seeall)
require "db/i18n"
require "script/module/public/UIHelper"

local  luckyJson = "ui/arena_lucky.json"
-- UI控件引用变量 --
local m_tbEvent  -- 按钮事件
local m_mainWidget -- root
local tbLastUICtrl = {} -- 上一届排名的UI控件
local tbCurrentUICtrl = {} -- 当前 排名的UI控件

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n


local function init(...)

end

function destroy(...)
	package.loaded["ArenaLuckView"] = nil
end

function moduleName()
    return "ArenaLuckView"
end

function updateUI(  )
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget,"BTN_CLOSE")
	-- BTN_CLOSE:addTouchEventListener(m_tbEvent.onClose)
	BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	-- local TFD_TITLE =  m_fnGetWidget(m_mainWidget,"TFD_TITLE")
	-- TFD_TITLE:setText(m_i18n[2216])

	local tfd_this_luckyrank = m_fnGetWidget(m_mainWidget,"tfd_this_luckyrank")
	tfd_this_luckyrank:setText(m_i18n[2217])
	local tfd_last_luckyrank = m_fnGetWidget(m_mainWidget,"tfd_last_luckyrank")
	tfd_last_luckyrank:setText(m_i18n[2218])

	local LAY_INFO2 = m_fnGetWidget(m_mainWidget,"LAY_INFO2")
	local tfd_rank1 = m_fnGetWidget(m_mainWidget,"tfd_rank")
	local tfd_gold1 = m_fnGetWidget(m_mainWidget,"tfd_gold")
	tfd_rank1:setText(m_i18n[2219])
	tfd_gold1:setText(m_i18n[2220])
	UIHelper.labelAddStroke(tfd_rank1,m_i18n[2219],ccc3(0x4d,0x26,0x03))
	UIHelper.labelAddStroke(tfd_gold1,m_i18n[2220],ccc3(0x4d,0x26,0x03))

	local LAY_INFO1 = m_fnGetWidget(m_mainWidget,"LAY_INFO1")
	local tfd_rank = m_fnGetWidget(LAY_INFO1,"tfd_rank")
	local tfd_name = m_fnGetWidget(LAY_INFO1,"tfd_name")
	local tfd_gold = m_fnGetWidget(LAY_INFO1,"tfd_gold")
	tfd_rank:setText(m_i18n[2219])
	tfd_gold:setText(m_i18n[2220])
	tfd_name:setText(m_i18n[2221])
	UIHelper.labelAddStroke(tfd_rank,m_i18n[2219],ccc3(0x50,0x25,0x0a))
	UIHelper.labelAddStroke(tfd_gold,m_i18n[2220],ccc3(0x50,0x25,0x0a))
	UIHelper.labelAddStroke(tfd_name,m_i18n[2221],ccc3(0x50,0x25,0x0a))
-- 幸运排名上一轮幸运排名
	for i=1,10 do
		local LAY_RANK_NAME = "LAY_RANK" .. i
		local TFD_RANK_NAME = "TFD_RANK" .. i
		local TFD_NAME_NAME = "TFD_NAME" .. i
		local LAY_RANK = m_fnGetWidget(m_mainWidget,LAY_RANK_NAME)
		local TFD_RANK = m_fnGetWidget(LAY_RANK,TFD_RANK_NAME)
		local TFD_NAME = m_fnGetWidget(LAY_RANK,TFD_NAME_NAME)
		local TFD_GOLD = m_fnGetWidget(LAY_RANK,"TFD_GOLD")

		TFD_RANK:setText("")
		TFD_NAME:setText("")
		TFD_GOLD:setText("")
		local tb = {}
		tb.position = TFD_RANK
		tb.uname = TFD_NAME
		tb.gold = TFD_GOLD

		table.insert(tbLastUICtrl,i,tb)
	end
	logger:debug(ArenaData.luckyListData.last)

	if not table.isEmpty(ArenaData.luckyListData.last) then
		for i=1,#tbLastUICtrl do
			local isNpc = false
			if(tonumber(ArenaData.luckyListData.last[i].uid) >= 11001 and tonumber(ArenaData.luckyListData.last[i].uid) <= 16000)then
	                isNpc = true
	        end

	        if( isNpc )then
	                -- npc
	                local name = ArenaData.getNpcName( tonumber(ArenaData.luckyListData.last[i].uid), tonumber(ArenaData.luckyListData.last[i].utid))
	                tbLastUICtrl[i].uname:setText(name)

	        else
	                -- 不是npc
	            if(ArenaData.luckyListData.last[i].uname ~= nil)then
	        		tbLastUICtrl[i].uname:setText(ArenaData.luckyListData.last[i].uname)

	            end
	        end


	 		tbLastUICtrl[i].gold:setText(ArenaData.luckyListData.last[i].gold)
	 		tbLastUICtrl[i].position:setText(ArenaData.luckyListData.last[i].position)
 		end
	end

-- 幸运排名当前幸运排名
	for i=11,20 do
		local LAY_RANK_NAME = "LAY_RANK" .. i
		local TFD_RANK_NAME = "TFD_RANK" .. i
		local LAY_RANK = m_fnGetWidget(m_mainWidget,LAY_RANK_NAME)
		local TFD_RANK = m_fnGetWidget(LAY_RANK,TFD_RANK_NAME)
		local TFD_GOLD
		-- if (i==18) then 
		-- 	TFD_GOLD = m_fnGetWidget(LAY_RANK,"TFD_GOLD2")
		-- else 
		 	TFD_GOLD = m_fnGetWidget(LAY_RANK,"TFD_GOLD")
		-- end
		logger:debug(i)
		local tb = {}

		tb.position = TFD_RANK
		tb.gold = TFD_GOLD
		TFD_GOLD:setText("")
		TFD_RANK:setText("")
		table.insert(tbCurrentUICtrl,i-10,tb)
	end
	logger:debug(tbCurrentUICtrl)
 -- 进行数据填充 当前幸运排名
 	for i=1,#tbCurrentUICtrl do
 		tbCurrentUICtrl[i].gold:setText(ArenaData.luckyListData.current[i].gold)
 		tbCurrentUICtrl[i].position:setText(ArenaData.luckyListData.current[i].position)
 	end


 	local TFD_DES1 = m_fnGetWidget(m_mainWidget,"TFD_DES1")
 	local TFD_DES2 = m_fnGetWidget(m_mainWidget,"TFD_DES2")
 	TFD_DES2:setText(m_i18n[2223])
 	TFD_DES1:setText(m_i18n[2222])
end


function create(tbEvent)
	m_tbEvent = tbEvent
	tbCurrentUICtrl = {}
	tbLastUICtrl = {}
	m_mainWidget = g_fnLoadUI(luckyJson)
	m_mainWidget:setSize(g_winSize)
	updateUI()
	return m_mainWidget
end

