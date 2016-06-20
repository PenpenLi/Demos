-- FileName: ArenaCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-12-10
-- Purpose: 竞技场排行和商店 控制器
-- /

module("ArenaCtrl", package.seeall)
require "script/module/arena/ArenaView"
require "script/module/arena/ArenaReplayCtrl"
require "script/module/arena/ArenaMesShopCtrl"
require "script/module/arena/ArenaShopCtrl"
-- UI控件引用变量 --
local m_fnCallback
-- 模块局部变量 --
tbType = {
	rank = 1,
	shop = 2,
}

local m_curType
local _args = nil
local m_arenaInfo = nil
local m_view = nil
local function init(...)
	m_arenaInfo = nil
	m_fnCallback = nil
	m_view = nil
	_args = nil
end

function destroy(...)
	package.loaded["ArenaCtrl"] = nil
end

function moduleName()
    return "ArenaCtrl"
end

local function fnDoBack()
	MainArenaCtrl.create()
end

local function fnBindingFun(  )
		-- 按钮事件
	local tbBtnEvent = {}
	-- 按钮1
	tbBtnEvent.onBtn1 = function( sender, eventType)
		if (ArenaView.getSelectedBtnTag() == sender:getTag()) then
				ArenaView.btnSelectFunc(sender)
			end
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBtn1")
			if (ArenaView.getSelectedBtnTag() == sender:getTag()) then
				ArenaView.btnSelectFunc(sender)
				return
			end
			showArenaTab(sender:getTag())
			ArenaView.btnSelectFunc(sender)
			AudioHelper.playTabEffect()
            if tonumber(m_curType) == tonumber(tbType.shop) then
				-- 快捷出售界面 sunyunpeng 2015-04-14
		        require("script/module/rapidSale/RapidSaleCtrl")
		        RapidSaleCtrl.create()
		    end
		end	
	end
	-- 按钮2
	tbBtnEvent.onBtn2 = function (sender, eventType) 
		if (ArenaView.getSelectedBtnTag() == sender:getTag()) then
				ArenaView.btnSelectFunc(sender)
		end
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onBtn2")
			if (ArenaView.getSelectedBtnTag() == sender:getTag()) then
				ArenaView.btnSelectFunc(sender)
				return
			end
			if ArenaData.arenaInfo == nil then
				MainArenaCtrl.getArenaInfo(function( ) showArenaTab(sender:getTag()) end)
			else
				showArenaTab(sender:getTag())
			end
			ArenaView.btnSelectFunc(sender)
			AudioHelper.playTabEffect()
			if tonumber(m_curType) == tonumber(tbType.shop) then
					--快捷出售界面 sunyunpeng 2015-04-14
				ArenaData.setNeedShowRedPoint(false)
				sender.IMG_SHOP_TIP:removeAllNodes()
		        require("script/module/rapidSale/RapidSaleCtrl")
		        RapidSaleCtrl.create()
		    end
		end	
	end
	-- 退出按钮
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED)then
			AudioHelper.playBackEffect()
			fnDoBack()
		end
	end
	if m_fnCallback then
		tbBtnEvent.onBack = m_fnCallback
	end
	return tbBtnEvent
end

function showArenaTab( tag)
	if(m_arenaInfo) then
		m_arenaInfo:removeFromParentAndCleanup(true)
		m_arenaInfo = nil
	end
	if tonumber(m_curType) == tonumber(tbType.rank) then
		if tonumber(tag) == 1 then
			m_arenaInfo = ArenaRankCtrl.create()
			m_view:addChild(m_arenaInfo)
		else
			m_arenaInfo = ArenaReplayCtrl.create()
			m_view:addChild(m_arenaInfo)
		end

	else
		if tonumber(tag) == 1 then
			m_arenaInfo = ArenaMesShopCtrl.create()
			m_view:addChild(m_arenaInfo)
		else
			m_arenaInfo = ArenaShopCtrl.create()
			m_view:addChild(m_arenaInfo)
		end
	end
	
end


-- 得到前十排行榜数据
local function getRankList( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			ArenaData.rankListData = dictData.ret
			callbackFunc()
		end
	end
	RequestCenter.arena_getRankList(requestFunc)
end

local function getReplayList( callBackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			logger:debug(dictData)
			-- callbackFunc()
			ArenaData.setReplayList(dictData.ret)
		end
	end
	RequestCenter.arena_getReplayList(requestFunc)
end


local function getShopInfo( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			logger:debug(dictData)
			ArenaData.setArenaMesShopInfo(dictData.ret)
			callbackFunc()	       
		end
	end
	RequestCenter.arenamystshop_getShopInfo(requestFunc)
end

local function createView( ... )
	local tbEvent = fnBindingFun()
	m_view = ArenaView.create(tbEvent,m_curType)
	showArenaTab(1)
	LayerManager.changeModule(m_view, moduleName(), {1,3}, true, _args)
	PlayerPanel.addForArena()
	if (m_curType == tbType.shop) then
		RapidSaleCtrl.create()
	end
end

function getCurType( )
	return m_curType
end

function create(nType, fnCallBack, args)
	init()
	m_fnCallback = fnCallBack
	_args = args
	m_curType = nType or tbType.rank
	
	if (tonumber(m_curType) == tonumber(tbType.rank)) then
		getRankList(createView)
		getReplayList()
	else
		ArenaMesShopCtrl.init()
		getShopInfo(createView)
		-- createView()
	end
end
