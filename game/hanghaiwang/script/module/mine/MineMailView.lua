-- FileName: MineMailView.lua
-- Author: sunyunpeng
-- Date: 2014-06-01
-- Purpose: 资源矿邮件信息view
--[[TODO List]]

module("MineMailView", package.seeall)
require "script/module/mine/MineMailData"

-- UI控件引用变量 --
local _UIMain

local _btnRevengeDetail
local _btnResourceExhaust
local _btnGrabDetail
local _btnOnback
local _btnCounterAttack

local _layCell = nil							--cell模板
local listView  = nil  							--邮件列表
-- 模块局部变量 --
local m_i18n = gi18n
local _tbCurData = nil							--邮件数据
local _szCell = nil								--cell的size大小
-- local _notifyFunTB = nil
local _curPage = 0

local hzLayout
local lay_tbView 
local _Tabs = {}
local _BtnEvent
local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)} --  g_TabTitleColor

local function init(...)
	listView = nil
	_UIMain = nil
	_curPage = 0
	_tbCurData = {}
	-- _notifyFunTB = {MineMailData._MSG_.CB_PUSH_MAIL_REVENGETIP , MineMailData._MSG_.CB_PUSH_MAIL_RESOURCETIP}

end

function destroy(...)
	_curPage = 0
	package.loaded["MineMailView"] = nil
end

function moduleName()
    return "MineMailView"
end

--进入战斗的时候 把listview从层容器上删除vhu，防止在结算面板上又点击穿透
function removeListView( ... )
	logger:debug("removeListView")
	--lay_tbView:removeChild(hzLayout)
	hzLayout:removeFromParentAndCleanup(false)
end

--离开结算面板的时候重新吧listview加到层容器上
function addListView( ... )
	lay_tbView:addChild(hzLayout)
end

--切换标签重新加载tableview
function updateTableData( newData,cellType ) 
	_tbCurData = newData

	_curPage = cellType
	logger:debug({_curPage=_curPage})

	if(listView)then
		logger:debug("have listView")
		listView:removeView()
		initListView(cellType)
	else
		logger:debug("no listView")
		initListView(cellType)
	end
end

--更多邮件，重新刷新tableview
function setMailData(tbData,newDataCount)
	_tbCurData = tbData
	listView:changeData(tbData)
	if(newDataCount and newDataCount > 0) then
		--更多邮件
		logger:debug(tbData)
		logger:debug(newDataCount)		
		logger:debug("reloadDataByInsertData")

		listView:reloadDataByInsertData(newDataCount or 0)
	else
		listView:reloadDataByBeforeOffset()
	end
	
end

function initListView(cellType)
	lay_tbView =  _UIMain.LAY_MAIL



	local layCell = lay_tbView.lay_cell

	local noBtnCell = _UIMain.LAY_CELL_NOBTNS
	local btnCell = _UIMain.LAY_CELL_BTNS
	local moreBtnCell = _UIMain.LAY_MORE

	_layCell = layCell:clone()

	_layCell:setScale(g_fScaleX)
	_layCell:retain() -- 需要单独释放

	local cellNum = #_tbCurData + 1

	local function cellAtIndex( tbData, idx)
		local layCell = _layCell
		require "script/module/mine/MineMailCell"
		local cell = MineMailCell:new(layCell,moreBtnCell:clone())
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(lay_tbView:getSize().width * g_fScaleX,lay_tbView:getSize().height)
	tbView.szCell = CCSizeMake(_layCell:getSize().width * g_fScaleX,_layCell:getSize().height * g_fScaleX)


	_szCell = tbView.szCell
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = _tbCurData
	listView = HZListView:new()

	if (listView:init(tbView)) then
		hzLayout = TableViewLayout:create(listView:getView())
        lay_tbView:addChild(hzLayout)
		listView:refresh()
	end
    
end


function showMailTip( tabIndex )
	local tipNode
    if ( _curPage == 0) then
    	return
    end
	if (tabIndex == 1 and _UIMain.BTN_TAB1 ) then
		tipNode = _UIMain.BTN_TAB1.IMG_RED
	elseif (tabIndex == 2  and _UIMain.BTN_TAB2) then
		tipNode = _UIMain.BTN_TAB2.IMG_RED
	end
	if(not tipNode:getNodeByTag(10) and tabIndex ~= _curPage ) then
		local tipAni = UIHelper.createRedTipAnimination()
		tipAni:setTag(10)
		tipNode:addNode(tipAni,10)
	end
	tipNode:setVisible(true)
end

-- 去掉Tab红点
function updateTipNode( tabIndex )
	local tipNode 
    if (tabIndex == 1) then                                							 -- 去仇人信息红点 并删除通知
    	tipNode = _UIMain.BTN_TAB1.IMG_RED
    	tipNode:setVisible(false)
    	g_redPoint.newMineMail.FirstTabShowRed = false	 

    elseif (tabIndex == 2) then                    									-- 去仇人信息红点 并删除通知
    	tipNode = _UIMain.BTN_TAB2.IMG_RED
    	tipNode:setVisible(false)
    	g_redPoint.newMineMail.SecondTabShowRed = false	
    end

	local FirstTabShowTag  =  g_redPoint.newMineMail.FirstTabShowRed
	local SecondTabShowTag =  g_redPoint.newMineMail.SecondTabShowRed

	if (not FirstTabShowTag and not SecondTabShowTag) then 							-- 主界面邮件取消红点
		g_redPoint.newMineMail.visible = false
	end
end


-- 更新仇人信息红点
function updateRevengeRedTip( ... )
    local FirstTabShowTag  =  g_redPoint.newMineMail.FirstTabShowRed
    if (FirstTabShowTag) then
    	showMailTip( 1 )
    end
end

-- 更新资源到期红点
function updateResourceRedTip( ... )
    local SecondTabShowTag =  g_redPoint.newMineMail.SecondTabShowRed
    if (SecondTabShowTag) then
    	showMailTip( 2 )
    end
end

function changeTabStat( btn, bStat )

	local tabStat = bStat
	for i, tab in ipairs(_Tabs) do
		logger:debug({btn=btn})
		logger:debug({tab=tab})

		tabStat = (tab == btn) and bStat or (not bStat)
		logger:debug({tabStat=tabStat})
		if (tabStat) then
			local btnTag = btn:getTag()
			if (btnTag==1) then
				_BtnEvent.onRevengeDetail()
			elseif (btnTag==2) then
				_BtnEvent.onResourcesExhaust()
			else
				_BtnEvent.onGrabDetail()
			end

		end
		tab:setFocused(tabStat)
		tab:setTitleColor(tabStat and m_color.selected or m_color.normal)
		tab:setTouchEnabled(not tabStat)
	end

end

function tabOnTouch ( sender ,tabOnTouch)
	--logger:debug("tabOnTouch: tag = %d", sender:getTag())
	local btn = tolua.cast(sender, "Button")
	changeTabStat(btn, true) -- 保持按下状态
end



function create( tbBtnEvent )
	init()
	_BtnEvent = tbBtnEvent
	_UIMain = g_fnLoadUI("ui/resource_mail.json")
	_curPage = 1

	local layCell = _UIMain.lay_cell
	layCell:setEnabled(false)

	local imgbg = _UIMain.IMG_BG
	imgbg:setScale(g_fScaleX)

	local imgSmallBg = _UIMain.img_small_bg
	imgSmallBg:setScale(g_fScaleX)

	local imgline = _UIMain.img_line
	imgline:setScale(g_fScaleX)

	-- local layMail = _UIMain.LAY_MAIL
	-- layMail:setScale(g_fScaleX)

	-- _btnRevengeDetail = _UIMain.BTN_TAB1
	-- _btnResourceExhaust = _UIMain.BTN_TAB2
	-- _btnGrabDetail = _UIMain.BTN_TAB3
	_btnOnback = _UIMain.BTN_BACK
	UIHelper.titleShadow(_btnOnback,m_i18n[1019]) 	              -- 返回	
	_Tabs = {}
	for i=1,3 do
		local widgetName = "BTN_TAB" .. i
		local btn = _UIMain[widgetName]
		table.insert(_Tabs, btn)

		btn:setTitleColor(m_color.normal)
		btn:setTag(i)
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playTabEffect()
				tabOnTouch(sender)
			end
		end)
	end

	-- _btnRevengeDetail:addTouchEventListener(tbBtnEvent.onRevengeDetail) 			--注册仇人信息按钮
	-- table.insert(_Tabs, _btnRevengeDetail)
	-- _btnRevengeDetail:setTitleColor(g_TabTitleColor.normal)

	-- _btnResourceExhaust:addTouchEventListener(tbBtnEvent.onResourcesExhaust) 		--注册资源到期按钮
	-- table.insert(_Tabs, _btnResourceExhaust)
	-- _btnResourceExhaust:setTitleColor(g_TabTitleColor.normal)

	-- _btnGrabDetail:addTouchEventListener(tbBtnEvent.onGrabDetail) 					--注册抢夺信息按钮
	-- table.insert(_Tabs, _btnGrabDetail)
	-- _btnGrabDetail:setTitleColor(g_TabTitleColor.normal)

	_btnOnback:addTouchEventListener(tbBtnEvent.onBack) 							--注册返回按钮
	changeTabStat(_UIMain.BTN_TAB1,true)
	-- MineMailCtrl.setTabFocused(_btnRevengeDetail)


	local topLayer = CCLayer:create()
	topLayer:setTouchEnabled(true)
	topLayer:registerScriptTouchHandler(function ( eventType, x, y )
		if (eventType == "began") then
			MineMailData._menuBtnCanCall = false          -- 重置资源矿邮件中的 menubtn 不可触发  false为没有点击到listView里面 addby sunyunpeng --2015.6.28
		end
	end,
	false, g_tbTouchPriority.touchEffect)
	_UIMain:addNode(topLayer)

   return _UIMain

end
