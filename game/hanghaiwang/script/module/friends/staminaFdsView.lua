-- FileName: staminaFdsView.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友赠送耐力ui显示
--[[TODO List]]

module("staminaFdsView", package.seeall)

require "script/module/friends/staminaFdsData"

-- UI控件引用变量 --
local jsonFdsStamina = "ui/friends_stamina.json"
local jsonFdsSucceed = "ui/friends_succeed.json"

-- 模块局部变量 --
local fdsStamina 
local tbStaminaData --耐力数据
local fnOnCallBack
local tbView = nil
local m_layCell = nil
local LAYCELL = nil
local tfdTimesNum = nil --剩余领取次数
local listView = nil

local m_fnGetWidget = g_fnGetWidgetByName

local function init(...)
	tbView = nil
	LAYCELL = nil
	m_layCell = nil
	listView = nil
	tfdTimesNum = nil
end

function destroy(...)
	package.loaded["staminaFdsView"] = nil
end

function moduleName()
    return "staminaFdsView"
end
--------------可领取耐力列表--------------
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
local function cellAtIndex( tbData, idx)
	local cell = FriendsCell:new({cell = m_layCell,cellType = 3})
	cell:init(tbData)
	cell:refresh(tbData,idx,1)
	return cell
end

function initListView(  )
	local LAY_FORTBV = m_fnGetWidget(fdsStamina,"LAY_FORTBV")
	LAYCELL = m_fnGetWidget(LAY_FORTBV,"LAY_CELL")
	m_layCell = LAYCELL:clone() 
	m_layCell:setScale(g_fScaleX)
	m_layCell:retain()
	
	local tbView = {}
	tbView.szView = CCSizeMake(LAY_FORTBV:getSize().width,LAY_FORTBV:getSize().height)
	tbView.szCell = CCSizeMake(LAYCELL:getSize().width,LAYCELL:getSize().height + 10)
	tbView.CellAtIndexCallback = cellAtIndex
	tbView.tbDataSource = staminaFdsData.getReceiveList(fnOnCallBack)

	listView = HZListView:new()
	if (listView:init(tbView)) then 
        -- LAY_FORTBV:addNode(listView:getView())
        local hzLayout = TableViewLayout:create(listView:getView())
        LAY_FORTBV:addChild(hzLayout)
        listView:refresh()
    end

    LAYCELL:removeFromParentAndCleanup(true)
end

function updateListView( ... )
	if (listView) then
		if (tfdTimesNum) then
			tfdTimesNum:setText(staminaFdsData.getTodayReceiveTimes())
		end
		listView:changeDataSource(staminaFdsData.getReceiveList(fnOnCallBack))
	end
end

--------------领取所有耐力成功--------------
function getAllLayer( num,times )
	local fdsSucceed = g_fnLoadUI(jsonFdsSucceed)
	LayerManager.addLayout(fdsSucceed)

	local btnColse = m_fnGetWidget(fdsSucceed,"BTN_CLOSE")
	btnColse:addTouchEventListener(fnOnCallBack.onBtnClose)

	local btnConfirm = m_fnGetWidget(fdsSucceed,"BTN_CONFIRM")
	btnConfirm:addTouchEventListener(fnOnCallBack.onBtnClose)
	UIHelper.titleShadow(btnConfirm,gi18n[5508])

	local tfdspNum = m_fnGetWidget(fdsSucceed,"TFD_SP_NUM")
	if (num) then
		tfdspNum:setText("x" .. num)
	end

	local tfdTimesNums = m_fnGetWidget(fdsSucceed,"TFD_TIMES_NUM_Copy0")
	if (tfdTimesNums) then
		UIHelper.labelStroke(tfdTimesNums)
		--UIHelper.labelShadow(tfdTimesNums,CCSizeMake(3,-3))
		tfdTimesNums:setText(times)
	end

	local tfdTimesNums = m_fnGetWidget(fdsSucceed,"tfd_times_info_Copy0")
	UIHelper.labelStroke(tfdTimesNums)
	
end

function create(callBack)
	init()

	fnOnCallBack = callBack
	tbStaminaData = staminaFdsData.getStaminaList()

	fdsStamina = g_fnLoadUI(jsonFdsStamina)
	-- zhangqi, 2014-07-17, 注册UI被remove的回调，将TableView的引用置为nil，避免后端推送刷新时刷新不存在的UI
	UIHelper.registExitAndEnterCall(fdsStamina, function ( ... )
		if (LayerManager.getChangModuleType()~=1) then 
			if(m_layCell)then 
				m_layCell:release()
				m_layCell = nil
			end 

			if(listView)then 
				listView:removeView()
				listView = nil
			end 
		end 
	end)
	local layNoStamina = m_fnGetWidget(fdsStamina,"LAY_NOSTAMINA")
	local layFortbv = m_fnGetWidget(fdsStamina,"LAY_FORTBV")
	tfdTimesNum = m_fnGetWidget(fdsStamina,"TFD_TIMES_NUM")
	tfdTimesNum:setText(staminaFdsData.getTodayReceiveTimes())
	UIHelper.labelStroke(tfdTimesNum)

	local tfdTimesInfo = m_fnGetWidget(fdsStamina,"tfd_times_info")
	UIHelper.labelAddStroke(tfdTimesInfo,gi18n[2923])
	
	local btnGetAll = m_fnGetWidget(fdsStamina,"BTN_GET_ALL")
	UIHelper.titleShadow(btnGetAll,gi18n[2922])

	if (#tbStaminaData > 0) then
		layNoStamina:setVisible(false)
		layFortbv:setVisible(true)
		btnGetAll:setEnabled(true)
		btnGetAll:addTouchEventListener(fnOnCallBack.onBtnGetAll)
		initListView()
	else
		local btnGive = m_fnGetWidget(layNoStamina,"BTN_GIVE_STAMINA")
		UIHelper.titleShadow(btnGive,gi18n[2912])
		btnGive:addTouchEventListener(fnOnCallBack.onBtnGoGive)

		layNoStamina:setVisible(true)
		layFortbv:setVisible(false)
		btnGetAll:setEnabled(false)
	end

	UIHelper.labelNewStroke(fdsStamina.tfd_times_info, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsStamina.TFD_TIMES_NUM, ccc3(0x28,0,0),2)
	-- UIHelper.labelNewStroke(fdsStamina.BTN_GET_ALL, ccc3(0x28,0,0),2)     --坑爹的tolua.cast, UIButton类型当成CCLabel类型用，特娘的程序运行不报错，不定时崩掉。
	UIHelper.labelNewStroke(fdsStamina.TFD_TIP, ccc3(0x28,0,0),2)

	return fdsStamina
end
