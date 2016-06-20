-- FileName: MainMailView.lua
-- Author: zhangjunwu
-- Date: 2014-06-02
-- Purpose: 邮件主界面view


module("MainMailView", package.seeall)
require "script/module/public/HZListView"
require "script/module/mail/MailCell"

-- UI控件引用变量 --
local m_UIMain

local m_btnAll
local m_btnFight
local m_btnFriends
local m_btnSystem

local m_layCell = nil							--cell模板
local listView  = nil  							--邮件列表
local LAY_CELL  = nil							--cellLay
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

local m_tbCurData = nil							--邮件数据
local m_szCell = nil							--cell的size大小

local hzLayout
local lay_tbView 

local function init(...)
	listView = nil
	m_UIMain = nil
	m_tbCurData = {}
end
--进入战斗的时候 把listview从层容器上删除vhu，防止在结算面板上又点击穿透
function removeListView( ... )
	logger:debug("removeListView")
	--lay_tbView:removeChild(hzLayout)
	-- hzLayout:removeFromParentAndCleanup(false)
	hzLayout:setEnabled(false)
end

--离开结算面板的时候重新吧listview加到层容器上
function addListView( ... )
	hzLayout:setEnabled(true)
	-- lay_tbView:addChild(hzLayout)
end

function destroy(...)
	package.loaded["MainMailView"] = nil
end
function destruct()
	if(listView)then
		listView:removeView()
	end
	listView = nil
end

function moduleName()
	return "MainMailView"
end
--切换标签重新加载tableview
function updateTableData( newData )

	m_tbCurData = newData
	if(listView)then
		listView:removeView()
		initListView()
	else
		initListView()
	end
end
--更多邮件，重新刷新tableview
function setMailData(tbData,newDataCount)
	m_tbCurData = tbData
	listView:changeData(tbData)
	
	--listView:reloadDataByOffset()
	if(newDataCount and newDataCount > 0) then
		--更多邮件

		listView:reloadDataByInsertData(newDataCount or 0)
	else
		--申请好友，拒绝好友
		logger:debug("j决绝好友")
		listView:reloadDataByBeforeOffset()
	end
	--listView:setContentOffset(ccp(0,m_szCell.height * -10))
end
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	lay_tbView =  m_fnGetWidget(m_UIMain,"LAY_MAIN")
	--LAY_CELL:setEnabled(true)
	local btnCell = m_fnGetWidget(LAY_CELL,"LAY_CELL_BTNS")
	m_layCell = btnCell --LAY_CELL:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	-- m_layCell:setScale(g_fScaleX)
	-- m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData, idx)
		m_layCell1 = m_fnGetWidget(m_UIMain,"LAY_FORTBV")
		local cell = MailCell:new(m_layCell1)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(lay_tbView:getSize().width * g_fScaleX,lay_tbView:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width * g_fScaleX,btnCell:getSize().height * g_fScaleX)


	m_szCell = tbView.szCell
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = m_tbCurData

	listView = HZListView:new()
	if (listView:init(tbView)) then
		-- lay_tbView:addNode(listView:getView())
		hzLayout = TableViewLayout:create(listView:getView())
        lay_tbView:addChild(hzLayout)
		listView:refresh()
		-- logger:debug("????")
		--listView:getView():setContentOffset(ccp(0,1))
	end

	LAY_CELL:setEnabled(false)
	m_layCell:setEnabled(false)
end


function create(tbBtnEvent)
	init()
	m_UIMain = g_fnLoadUI("ui/mail_main.json")

	m_btnAll = m_fnGetWidget(m_UIMain, "BTN_ALL")
	m_btnFight = m_fnGetWidget(m_UIMain, "BTN_FIGHT")
	m_btnFriends = m_fnGetWidget(m_UIMain, "BTN_FRIENDS")
	m_btnSystem = m_fnGetWidget(m_UIMain, "BTN_SYSTEM")

	--添加投影
	UIHelper.titleShadow(m_btnAll,m_i18nString(2101))
	UIHelper.titleShadow(m_btnFight,m_i18nString(2102))
	UIHelper.titleShadow(m_btnFriends,m_i18nString(2103))
	UIHelper.titleShadow(m_btnSystem,m_i18nString(2104))


	m_btnAll:addTouchEventListener(tbBtnEvent.onAllMail) 			--注册全部按钮
	m_btnFight:addTouchEventListener(tbBtnEvent.onFightMail) 		--注册战斗按钮
	m_btnFriends:addTouchEventListener(tbBtnEvent.onFriendMail) 	--注册好友按钮
	m_btnSystem:addTouchEventListener(tbBtnEvent.onSystemMail) 		--注册系统按钮

	LAY_CELL = m_fnGetWidget(m_UIMain,"LAY_FORTBV")
	LAY_CELL:setScale(g_fScaleX)
	LAY_CELL:setEnabled(false)

	local IMGBG = m_fnGetWidget(m_UIMain,"IMG_BG")
	IMGBG:setScale(g_fScaleX)

	local IMGBG1 = m_fnGetWidget(m_UIMain,"IMG_BG1")
	IMGBG1:setScale(g_fScaleX)


	local IMGCHAIN = m_fnGetWidget(m_UIMain,"IMG_CHAIN")
	IMGCHAIN:setScale(g_fScaleX)
	
	PlayerPanel.addForPublic()
	--local LAY_INFO = m_fnGetWidget()
	--默认为所有邮件为初始被选中状态
	MainMailCtrl.setTabFocused(m_btnAll)

	return m_UIMain
end

