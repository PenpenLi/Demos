-- FileName: GuildListView.lua
-- Author: zhangjunwu
-- Date: 2014-09-15
-- Purpose: l联盟列表界面
--[[TODO List]]

module("GuildListView", package.seeall)
require "script/module/guild/UnionCell"

-- UI控件引用变量 --
local m_mainWidget
local lay_View 							--邮件列表
local m_layCell
local hzLayout

local m_editBoxBg = nil  	----搜素输入框背景
local m_message_input = nil --输入框

-- 模块局部变量 --
local json = "ui/union_apply.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_tbEnionData

--
function getCurUnionDatabyUid(uid)
	for i,v in ipairs(m_tbEnionData) do
		if(tostring(v.leader_uid) == tostring(uid)) then
			return v
		end
	end
	return nil
end

local function init(...)

end

function destroy(...)
	package.loaded["GuildListView"] = nil
end

function moduleName()
	return "GuildListView"
end

function getSearchMessage( ... )
	logger:debug(m_message_input)
	return m_message_input:getText()
end

function resetSearchBox( ... )
	m_message_input:setText("")
end
--创建输入框
local function createEditBox( ... )
	-- 文本框
	local size = m_editBoxBg:getSize()
	m_message_input = UIHelper.createEditBox(CCSizeMake(size.width - 16, size.height),"images/base/potential/input_name_bg1.png",true,kCCVerticalTextAlignmentCenter)
	m_message_input:setFontColor(ccc3(255,0, 0));
	m_message_input:setPlaceHolder(gi18nString(3502));
	m_message_input:setMaxLength(40);
	m_message_input:setPlaceholderFontColor(ccc3( 255,255, 255))
	m_message_input:setReturnType(kKeyboardReturnTypeDone)
	m_message_input:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	m_message_input:setFontColor(ccc3( 0xff, 0xff, 0xff))
	m_message_input:setPosition(ccp(m_editBoxBg:getSize().width /2,0))
	m_editBoxBg:addNode(m_message_input)
end

--撤销申请和申请之后，重新刷新tableview
function updataUnionDataAndUI(tbData,newDataCount)
	logger:debug("重新加载军团列表")
	logger:debug(tbData)
	if(tbData)then    -- 撤销申请
		if(listView)then
			m_tbEnionData = GuildListCtrl.getGuildListData()
			listView:removeView()
			initListView()
		end
	else    --申请
		listView:reloadDataByBeforeOffset()
	end

end

--更多邮件，重新刷新tableview
function updataDataAndUIByMore(tbData,newDataCount)
	if(tbData)then    -- 撤销申请
		m_tbEnionData = tbData
		listView:changeData(tbData)
		listView:reloadDataByInsertData(newDataCount or 0)
	end
end


function updateUI( ... )
	--创建军团按钮
	local BTN_CREATE = m_fnGetWidget(m_mainWidget, "BTN_CREATE")
	BTN_CREATE:addTouchEventListener(m_tbEvent.fnCreateGuild)


	--没有加入任何军团
	if(GuildDataModel.getIsHasInGuild() == true) then
		BTN_CREATE:setEnabled(false)
	end

	--搜素
	local BTN_SEARCH = m_fnGetWidget(m_mainWidget, "BTN_SEARCH")
	BTN_SEARCH:addTouchEventListener(m_tbEvent.fnSearchGuild)
	UIHelper.titleShadow(BTN_SEARCH, gi18n[2914])
	--返回按钮
	local BTN_BACK = m_fnGetWidget(m_mainWidget, "BTN_BACK")
	BTN_BACK:addTouchEventListener(m_tbEvent.fnBack)
	UIHelper.titleShadow(BTN_BACK, gi18n[1019])



end
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
function initListView()
	lay_View =  m_fnGetWidget(m_mainWidget,"LAY_FOR_TBV")
	--LAY_CELL:setEnabled(true)
	local btnCell = m_fnGetWidget(m_mainWidget,"LAY_CELL")
	m_layCell = btnCell  --btnCell:clone()  -- 缓存一个cell的layout，供创建cell用，避免多次读json文件
	m_layCell:setScale(g_fScaleX)
	-- m_layCell:retain() -- 需要单独释放

	local function cellAtIndex( tbData, idx)
		local cell = UnionCell:new(m_layCell)
		cell:init(tbData)
		cell:refresh(tbData,idx)
		return cell
	end

	local tbView = {}
	tbView.szView = CCSizeMake(lay_View:getSize().width * g_fScaleX,lay_View:getSize().height)
	tbView.szCell = CCSizeMake(btnCell:getSize().width * g_fScaleX,btnCell:getSize().height * g_fScaleX)
	tbView.CellAtIndexCallback = cellAtIndex

	tbView.tbDataSource = m_tbEnionData

	listView = HZListView:new()
	if (listView:init(tbView)) then
		-- lay_View:addNode(listView:getView())
		hzLayout = TableViewLayout:create(listView:getView())
		lay_View:addChild(hzLayout)
		listView:refresh()
	end

	btnCell:setEnabled(false)
	m_layCell:setEnabled(false)
end

function create( tbEvent)
	m_tbEvent = tbEvent
	m_tbEnionData = GuildListCtrl.getGuildListData()
	--logger:debug(m_tbEnionData)
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	--搜素输入框背景
	m_editBoxBg = m_fnGetWidget(m_mainWidget,"IMG_TYPE_BG")

	local img_bg = m_fnGetWidget(m_mainWidget,"img_bg")
	local img_yeqian = m_fnGetWidget(m_mainWidget,"img_yeqian")
	img_yeqian:setScaleX(g_fScaleX)
	--img_bg:setScale(g_fScaleX)

	UIHelper.labelNewStroke(m_mainWidget.TFD_UNION_LV, ccc3(0xd6,0x0c,0x06))
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	img_bg:setScale(fScale)

	updateUI()
	--初始化军团列表
	initListView()

	--创建输入框
	createEditBox()

	-- UIHelper.registExitAndEnterCall(m_mainWidget,function (  )
	-- 		GuildDataModel.setIsInGuildFunc(false)
	-- 	end
	-- 	)

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideGuildView"
	if GuideModel.getGuideClass() == ksGuideSmithy and GuideGuildView.guideStep == 1 then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createGuildGuide(2, 0, function (  )
			GuideCtrl.removeGuide()
		end)
	end
	
	return m_mainWidget
end
