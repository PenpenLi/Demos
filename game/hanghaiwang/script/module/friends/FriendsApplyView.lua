-- FileName: FriendsApplyView.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 好友申请view、
--[[TODO List]]

module("FriendsApplyView", package.seeall)

require "script/module/friends/FriendsApplyModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_main = "friends_apply.json"
-- local m_main ="ui/friends_stamina.json"
local m_layMain = nil
local m_layCell = nil
local LAY_CELL = nil
local listView = nil

local tbArgs = nil

local function init(...)
	listView = nil
end

function destroy(...)
	package.loaded["FriendsApplyView"] = nil
end

function moduleName()
    return "FriendsApplyView"
end

local function cellAtIndex( tbData)
	logger:debug("创建cell")

	local cell = FriendsCell:new({cell = m_layCell,cellType = 4})
	cell:init(tbData)
	cell:refresh(tbData)
	return cell
end

-- 更新list
function updateList( )
	if(not listView)then 
		refreshLayer()
	else
		local data = FriendsApplyModel.getApplyList(tbArgs.onAddFriend,tbArgs.onRefuse)
		listView:changeDataSource(data)
	end 
end

function initListView( ... )
	local LAY_FORTBV = m_fnGetWidget(m_layMain,"LAY_FORTBV")
	local tbView = {}
	tbView.szView = CCSizeMake(LAY_FORTBV:getSize().width,LAY_FORTBV:getSize().height)
	tbView.szCell = CCSizeMake(m_layCell:getSize().width,m_layCell:getSize().height + 10)
	tbView.CellAtIndexCallback = cellAtIndex
	tbView.tbDataSource = FriendsApplyModel.getApplyList(tbArgs.onAddFriend,tbArgs.onRefuse)
	tbView.CellAtIndexCallback = cellAtIndex

	listView = HZListView:new()
	if (listView:init(tbView)) then 
        local hzLayout = TableViewLayout:create(listView:getView())
        LAY_FORTBV:addChild(hzLayout)
        listView:refresh()
    end
end

function refreshLayer( ... )
	local TFD_TIP = m_fnGetWidget(m_layMain,"TFD_TIP")  --没有好友申请
	local btnAddFds = m_fnGetWidget(m_layMain,"BTN_ADD")
	if( FriendsApplyModel.getApplyNum()>0 )then 
		TFD_TIP:setVisible(false)
		btnAddFds:setVisible(false)
		btnAddFds:setEnabled(false)
		initListView()
	else
		TFD_TIP:setVisible(true)
		btnAddFds:setVisible(true)
		btnAddFds:setEnabled(true)
	end
end

function create(tbCallback)
	init()
	tbArgs  = tbCallback
	m_layMain = g_fnLoadUI(m_main)

	UIHelper.registExitAndEnterCall(m_layMain, function ( ... )
		if (LayerManager.getChangModuleType()~=1) then 
			if(m_layCell)then 
				m_layCell:release()
				m_layCell = nil
			end 
			if(listView)then 
				listView:removeView()
				listView = nil
			end 
			logger:debug("registExitAndEnterCall(), listView = %s", type(listView))
		end 
	end)
	
	local btnAddFds = m_fnGetWidget(m_layMain,"BTN_ADD")
	btnAddFds:addTouchEventListener(tbArgs.onBtnAddFds)
	UIHelper.titleShadow(btnAddFds,m_i18n[2921])

	LAY_CELL = m_fnGetWidget(m_layMain,"LAY_CELL")
	m_layCell = LAY_CELL:clone() 
	m_layCell:setScale(g_fScaleX)
	m_layCell:retain()
	LAY_CELL:removeFromParentAndCleanup(true)
	LAY_CELL = nil
	
	UIHelper.labelNewStroke(m_layMain.TFD_TIP, ccc3(0x28,0,0),2)
	refreshLayer()

	return m_layMain
end
