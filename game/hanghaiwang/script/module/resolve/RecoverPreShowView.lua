-- FileName: RecoverPreShowView.lua
-- Author:zhangjunwu
-- Date: 2014-09-29
-- Purpose: 分解选择界面


module("RecoverPreShowView", package.seeall)

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_tbCurData = {}
local m_nCurTabIndex = 1

-- UI控件引用变量 --
local m_UIMain

local function init(...)

end
--释放资源
function destruct( ... )

end

function destroy(...)
	package.loaded["RecoverPreShowView"] = nil
end

function moduleName()
	return "RecoverPreShowView"
end

local function initRewardListView( tbListData )
	local lsv = m_UIMain.LSV_REWARD_BIG
	UIHelper.initListView(lsv)
	logger:debug(tbListData)
	for i=1,#tbListData do
		lsv:pushBackDefaultItem()
		local itemInfo  = tbListData[i]
		local item = lsv:getItem(i - 1)

		for i=1,4 do
			local lay_item = m_fnGetWidget(item,"lay_reward_bg" .. i)
			if(itemInfo[i]) then
				lay_item.TFD_NAME:setText(itemInfo[i].name)
				lay_item.TFD_NAME:setColor(g_QulityColor[tonumber(itemInfo[i].quality)])
				itemInfo[i].icon:setPosition(ccp(lay_item.lay_icon:getSize().width / 2,lay_item.lay_icon:getSize().height / 2))
				lay_item.lay_icon:addChild(itemInfo[i].icon)
			else
				lay_item:setEnabled(false)
			end
		end
	end
end

--tbOnTouch:点击事件，tbSelectId:已经选中的id集合，tabType:四个tab中得哪一个
function create( tbOnTouch ,tbListData,tabType )
	m_UIMain = g_fnLoadUI("ui/decompose_preview.json")
	m_nCurTabIndex = tabType

	local btnSure= m_fnGetWidget(m_UIMain, "BTN_YES")
	local btnBack = m_fnGetWidget(m_UIMain, "BTN_NO")
	UIHelper.titleShadow(btnSure, m_i18n[1324])
	UIHelper.titleShadow(btnBack, m_i18n[1325])

	btnSure:addTouchEventListener(tbOnTouch.onSure)
	btnBack:addTouchEventListener(tbOnTouch.onBack)
	m_UIMain.BTN_CLOSE:addTouchEventListener(tbOnTouch.onBack)

	-- m_UIMain.tfd_desc:setText("回收后可获得物品")
	--此次回收中含有高品质伙伴
	if(ResolveModel.fnHasHightItem()) then
		m_UIMain.TFD_PROMPT:setText(ResolveModel.tbRecoveryTips[tabType])
	else
		m_UIMain.TFD_PROMPT:setEnabled(false)
	end

	if(tabType == ResolveModel.T_RebornParnter) then
		m_UIMain.img_title:loadTexture("images/common/title_reborn_preview.png")
	else
		m_UIMain.img_title:loadTexture("ui/title_back_reward_preview.png")
	end

	initRewardListView(tbListData)

	return m_UIMain
end

