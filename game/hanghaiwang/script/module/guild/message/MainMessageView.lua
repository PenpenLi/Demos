-- FileName: MainMessageView.lua
-- Author: zhangjunwu
-- Date: 2014-09-22
-- Purpose: l留言板界面
--[[TODO List]]

module("MainMessageView", package.seeall)


require "script/module/guild/message/MessageCell"

-- UI控件引用变量 --
local m_mainWidget
local m_editBoxBg = nil  	----搜素输入框背景
local m_message_input = nil --输入框
local listView = nil

-- 模块局部变量 --
local json = "ui/union_message.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_tbMessageInfoData  		--留言板数据



function getCurMessageDatabyUid(uid)
	for i,v in ipairs(m_tbMessageInfoData.list) do
		if(tostring(v.uid) == tostring(uid)) then
			return v
		end
	end
	return nil
end


--设置留言的次数
local function setLeaveInfo( ... )
	--可留言次数
	local TFD_TIMES = m_fnGetWidget(m_mainWidget,"TFD_TIMES")
	TFD_TIMES:setText(m_tbMessageInfoData.num)

	--天
	local TFD_REMAIN = m_fnGetWidget(m_mainWidget,"TFD_REMAIN")
	TFD_REMAIN:setText("7")
end


function getLeaveMessageTimes( ... )
	if(m_tbMessageInfoData) then
		return tonumber(m_tbMessageInfoData.num) or 0
	end
end

function getMessage( ... )
	return m_message_input:getText()
end

--刷新列表
function refreshList( tbMessageInfoData )
	m_message_input:setText("")
	m_message_input:setPlaceHolder(m_i18nString(3660)); --"留言内容：最多可以输入40字",

	m_tbMessageInfoData = tbMessageInfoData
	listView:changeData(m_tbMessageInfoData.list)
	--listView:reloadDataByInsertData(newDataCount or 0)
	listView:refresh()

	setLeaveInfo()

end


--创建输入框
local function createMessageEditBox( ... )
	-- 文本框
	local size = m_editBoxBg:getSize()
	m_message_input = UIHelper.createEditBox(CCSizeMake(size.width, size.height),"images/base/potential/input_name_bg1.png",false)
	m_message_input:setFontColor(ccc3(0x82, 0x57, 0x00));
	m_message_input:setPlaceHolder(m_i18nString(3660)); --"留言内容：最多可以输入40字",
	m_message_input:setMaxLength(60);
	m_message_input:setFontName(g_sFontCuYuan);
	m_message_input:setPlaceholderFontColor(ccc3(0x82, 0x57, 0x00))
	m_message_input:setReturnType(kKeyboardReturnTypeDone)
	m_message_input:setInputFlag (kEditBoxInputFlagInitialCapsWord)

	--m_message_input:setPosition(ccp(m_editBoxBg:getSize().width /2,0))
	m_editBoxBg:addNode(m_message_input)
end

local function init(...)
	m_tbMessageInfoData = nil
end

function destroy(...)
	package.loaded["MainMessageView"] = nil
end

function moduleName()
	return "MainMessageView"
end

--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	local lay_View =  m_fnGetWidget(m_mainWidget,"LAY_FOR_TBV")
	--LAY_CELL:setEnabled(true)
	local btnCell = m_fnGetWidget(m_mainWidget,"LAY_CELL_1")
	local m_layCell = btnCell --btnCell:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	m_layCell:setScale(g_fScaleX)
	-- m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData ,idx)
		logger:debug("CellAtIndexCallback" .. idx)
		local cell = MessageCell:new(m_layCell)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(lay_View:getSize().width * g_fScaleX,lay_View:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width * g_fScaleX,btnCell:getSize().height * g_fScaleX)
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = m_tbMessageInfoData.list
	listView = HZListView:new()
	if (listView:init(tbView)) then

		hzLayout = TableViewLayout:create(listView:getView())
		lay_View:addChild(hzLayout)
		listView:refresh()
	end
	logger:debug("HZListView create?")
	btnCell:setEnabled(false)
	-- btnCell:removeFromParentAndCleanup(true)
	--m_layCell:setEnabled(false)
end

function create( tbEvent , tbMessageInfoData)
	m_tbEvent = tbEvent
	m_tbMessageInfoData  = tbMessageInfoData

	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)

	m_editBoxBg = m_fnGetWidget(m_mainWidget,"IMG_TYPE")


	-- -- 跑马灯
	-- LayerManager.setPaomadeng(m_mainWidget,10)
	-- UIHelper.registExitAndEnterCall(m_mainWidget, function ( ... )
	-- 	LayerManager.resetPaomadeng()
	-- end)

	createMessageEditBox()

	local BTN_LEAVE_MESSAGE = m_fnGetWidget(m_mainWidget,"BTN_LEAVE_MESSAGE")
	UIHelper.titleShadow(BTN_LEAVE_MESSAGE,m_i18n[2917])
	BTN_LEAVE_MESSAGE:addTouchEventListener(m_tbEvent.fnMessage)

	local BTN_CLOSE = m_fnGetWidget(m_mainWidget,"BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(m_tbEvent.fnClose)
	UIHelper.titleShadow(BTN_CLOSE, gi18n[1019])


	local img_bg = m_fnGetWidget(m_mainWidget,"img_bg")
	local img_background = m_fnGetWidget(m_mainWidget,"img_background")
	--img_background:setScale(g_fScaleX)
	img_bg:setScale(g_fScaleX)


	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	img_background:setScale(fScale)

	--初始留言板列表
	initListView()
	--可以留言
	local tfd_keliuyan = m_fnGetWidget(m_mainWidget,"tfd_keliuyan")
	--tfd_keliuyan:setText(m_i18nString(3650,""))

	--次
	local tfd_ci = m_fnGetWidget(m_mainWidget,"tfd_ci")
	tfd_ci:setText(m_i18nString(2621))

	--留言可保存
	local tfd_kebaocun = m_fnGetWidget(m_mainWidget,"tfd_kebaocun")
	--tfd_kebaocun:setText(m_i18nString(3651,""))
	--天
	local tfd_tian = m_fnGetWidget(m_mainWidget,"tfd_tian")
	tfd_tian:setText(m_i18nString(2631))

	setLeaveInfo()

	return m_mainWidget
end

