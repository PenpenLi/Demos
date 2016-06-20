-- FileName: recomdFdsView.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 推荐好友ui显示
--[[TODO List]]

module("recomdFdsView", package.seeall)

require "script/module/friends/recomdFdsData"
require "script/module/public/Cell/FriendsCell"
require "script/module/public/HZListView"

-- UI控件引用变量 --
local jsonFdsRecomd = "ui/friends_recommend.json"
local jsonFdsInvite = "ui/friends_invite.json"

local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

-- 模块局部变量 --
local fdsRecommend
local fnOnCallBack
local LAYCELL = nil
local listView = nil
local m_layCell = nil

msg_input = nil
name_input = nil

local function init(...)
	LAYCELL = nil
	listView = nil
	m_layCell = nil
end

function destroy(...)
	m_layCell = nil
	listView = nil
	LAYCELL = nil
	package.loaded["recomdFdsView"] = nil
end

function moduleName()
    return "recomdFdsView"
end

function create(callBack)
	init()

	fnOnCallBack = callBack

	fdsRecommend = g_fnLoadUI(jsonFdsRecomd)
	-- zhangqi, 2014-07-17, 注册UI被remove的回调，将TableView的引用置为nil，避免后端推送刷新时刷新不存在的UI
	UIHelper.registExitAndEnterCall(fdsRecommend, function ( ... )
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

	local tfd_friends_own = fdsRecommend.IMG_BOTTOM_BG.tfd_friends_own
	UIHelper.labelNewStroke( tfd_friends_own, ccc3(0x28,0,0), 2 )
	
	local btn_more = m_fnGetWidget(fdsRecommend,"BTN_MORE")
	UIHelper.titleShadow(btn_more,m_i18n[2255])  
	btn_more:addTouchEventListener(fnOnCallBack.onBtnMore)

	-- 好友数量
	UIHelper.labelNewStroke(fdsRecommend.tfd_friends_own, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsRecommend.TFD_FRIENDS_NUM1, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsRecommend.TFD_FRIENDS_NUM2, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsRecommend.TFD_FRIENDS_NUM3, ccc3(0x28,0,0),2)

	fdsRecommend.TFD_FRIENDS_NUM1:setText(MainFdsData.getFriendsCount())
	fdsRecommend.TFD_FRIENDS_NUM3:setText("500")

	searchLayer()
	initListView()

	return fdsRecommend
end

-----------------推荐好友列表------------
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
local function cellAtIndex( tbData, idx)
	local cell = FriendsCell:new({cell = m_layCell,cellType = 2})
	cell:init(tbData)
	cell:refresh(tbData)
	return cell
end

function initListView(  )
	local LAY_FORTBV = m_fnGetWidget(fdsRecommend,"LAY_FORTBV")
	LAYCELL = m_fnGetWidget(LAY_FORTBV,"LAY_CELL")
	m_layCell = LAYCELL:clone() 
	m_layCell:setScale(g_fScaleX)
	m_layCell:retain()

	local tbView = {}
	tbView.szView = CCSizeMake(LAY_FORTBV:getSize().width,LAY_FORTBV:getSize().height)
	logger:debug(tbView.szView.width)
	logger:debug(tbView.szView.height)
	tbView.szCell = CCSizeMake(LAYCELL:getSize().width,LAYCELL:getSize().height + 10)
	tbView.CellAtIndexCallback = cellAtIndex
	tbView.tbDataSource = recomdFdsData.getPageFdsData(fnOnCallBack)


	listView = HZListView:new()
	if (listView:init(tbView)) then 
        local hzLayout = TableViewLayout:create(listView:getView())
        LAY_FORTBV:addChild(hzLayout)
        listView:refresh()
    end

    LAYCELL:removeFromParentAndCleanup(true)
end

-- ret=true,删除一个cell。ret=false,listview的数据全部更新
function updateListView( ret )
	if(ret)then 
		listView:changeDataSource(recomdFdsData.getPageData())
	else 
		listView:changeDataSource(recomdFdsData.getPageFdsData(fnOnCallBack))
	end 
	
end

----------------模糊搜索-------------------
function searchLayer( ... )
	local btnSearch = m_fnGetWidget(fdsRecommend,"BTN_SEARCH")
	UIHelper.titleShadow(btnSearch,m_i18n[2914])
	btnSearch:addTouchEventListener(fnOnCallBack.onBtnSearch)

	local ImgSearch = m_fnGetWidget(fdsRecommend,"IMG_TYPE_NAME")
	ImgSearch:setScale(g_fScaleX)

	name_input = UIHelper.createEditBox(CCSizeMake(ImgSearch:getSize().width - btnSearch:getSize().width, ImgSearch:getSize().height),
											nil, false,kCCVerticalTextAlignmentCenter)
    name_input:setAnchorPoint(ccp(0, 0))
    name_input:setFontColor(ccc3(255, 255, 255))
    name_input:setMaxLength(50);
    name_input:setPlaceHolder(m_i18n[2902]);
    name_input:setReturnType(kKeyboardReturnTypeDone)
    -- name_input:setInputMode(kEditBoxInputModeAny)
    name_input:setOpacity(0)
    name_input:setPosition(ccp(-ImgSearch:getSize().width/2 + 10,-ImgSearch:getSize().height / 2))
	ImgSearch:addNode(name_input,999,999)
end


----------------邀请好友-------------------

-- 文本框
-- local function createEditBoxWithLayout(boxSize)
-- 	require "script/module/public/UIHelper"
-- 	msg_input = UIHelper.createEditBox(boxSize, nil, true)
--     msg_input:setAnchorPoint(ccp(0, 0))
--     msg_input:setFontColor(ccc3(255, 255, 255))
--     msg_input:setMaxLength(50);
--     msg_input:setReturnType(kKeyboardReturnTypeDone)
-- 	msg_input:setInputMode(kEditBoxInputModeAny)
--     msg_input:setText(m_i18n[2901])
--     return msg_input
-- end



-- 废弃
-- function createInviteLayer( idx )
-- 	local fdsInvite = g_fnLoadUI(jsonFdsInvite)
-- 	LayerManager.addLayout(fdsInvite)

-- 	local btnClose = m_fnGetWidget(fdsInvite,"BTN_CLOSE")
-- 	btnClose:addTouchEventListener(fnOnCallBack.onBtnClose)

-- 	local btnBack = m_fnGetWidget(fdsInvite,"BTN_BACK")
-- 	UIHelper.titleShadow(btnConfirm,m_i18n[1019])
-- 	btnBack:addTouchEventListener(fnOnCallBack.onBtnClose)

-- 	local btnConfirm = m_fnGetWidget(fdsInvite,"BTN_CONFIRM")
-- 	UIHelper.titleShadow(btnConfirm,m_i18n[1029])
-- 	btnConfirm:addTouchEventListener(fnOnCallBack.onBtnConfirm)
-- 	btnConfirm.idx = idx

-- 	local imgTypeWords = m_fnGetWidget(fdsInvite,"IMG_TYPE_WORDS")
-- 	local msgLayer = createEditBoxWithLayout(CCSizeMake(imgTypeWords:getSize().width-10, imgTypeWords:getSize().height))
-- 	msgLayer:setPosition(ccp(g_winSize.width/2 - imgTypeWords:getSize().width/2+5,g_winSize.height/2 - imgTypeWords:getSize().height / 2))
-- 	fdsInvite:addNode(msgLayer,0,999)
-- end
