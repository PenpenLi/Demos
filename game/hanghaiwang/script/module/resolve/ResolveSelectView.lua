-- FileName: ResolveSelectView.lua
-- Author:zhangjunwu
-- Date: 2014-05-28
-- Purpose: 分解选择界面


module("ResolveSelectView", package.seeall)
require "script/module/public/HZListView"
require "script/module/public/Cell/HeroCell"
require "script/module/public/Cell/EquipCell"
require "script/module/public/Cell/TreasureCell"
require "script/module/public/Cell/SpecialTreasCell"
require "script/module/public/Cell/ItemCell"
--local m_szCell = nil
local m_layTbListParent = nil           --tableview 的父容器
local m_listResolve = nil                --tableview
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)}  -- g_TabTitleColor
local m_tbCurData = {}
local m_tbListData = {}
local m_nCurTabIndex = 1
local m_curCell = nil

-- UI控件引用变量 --
local m_UIMain

local m_imgBG
local m_imgChain
local m_imgSmallBG

local m_labSelectInfo  =  nil  --已选择的**
local m_labSelectNum = nil 		--0/1
local m_labText = {m_i18nString(1523),m_i18n[1020],m_i18nString(1713),m_i18nString(1524)}

local IMG_CHOOSELIST = {
	 "images/common/title_choose_partner.png",
     "images/common/title_choose_shadow.png",
     "images/common/title_choose_partner.png",
   	 "images/common/renascence_choose_equip.png",
     "images/common/title_choose_treasure.png",
     "images/common/renascence_choose_treasure.png",
     "images/common/title_choose_ship.png",
}

local m_tableView = nil
local m_szView = nil

local function init(...)
	if(m_listResolve)then
		m_listResolve:removeView()
	end
	m_listResolve = nil
end
--释放资源
function destruct( ... )
	logger:debug("释放资源")
	if(m_listResolve)then
		m_listResolve:removeView()
	end
	m_listResolve = nil
	m_tbSeletedIds = {}
end

function destroy(...)

	package.loaded["ResolveSelectView"] = nil
end

function moduleName()
	return "ResolveSelectView"
end

function getSelectedid( ... )
	return m_tbSeletedIds
end

function updateTableData( newData )

	m_tbCurData = newData
	-- logger:debug(m_tbCurData)
	if(m_listResolve)then
		m_listResolve:removeView()
		initTableView()
	end
end

function resetSelectState( ... )
	-- logger:debug(m_tbCurData)
	for i = 1,#m_tbCurData do
		if(m_tbCurData[i].bSelect == true) then
			m_tbCurData[i].bSelect = false
		end
	end
end

--第一次进来默认的tab
function initTabFocused( index )
	updateSelectNumText()
end
--
function removeSelectedItem( itemId )
	for i = 1,#m_tbSeletedIds do
		if(m_tbSeletedIds[i] == itemId) then
			table.remove(m_tbSeletedIds,i)
		end
	end
end
--更新下方选择个数面板
function updateSelectNumText( ... )
	m_labSelectInfo:setText(ResolveModel.tbChoiceTips[m_nCurTabIndex])
	local nSelectedCount = ResolveModel.getSelectedCount()
	if(m_nCurTabIndex == ResolveModel.T_RebornParnter) then
		m_labSelectNum:setText(nSelectedCount  .. "/" .. "1")
	else
		m_labSelectNum:setText(nSelectedCount  .. "/" .. "5")
	end
end

local function tableCellTouched( view, cell,objCell)
	AudioHelper.playCommonEffect()
	local idx = cell:getIdx()
	local itemData =  m_tbCurData[idx+1]
	local bSelectStat  =  itemData.isSelected
	if(m_nCurTabIndex == ResolveModel.T_RebornParnter) then

		if(bSelectStat == true)then
			if (objCell.cbxSelect) then
				objCell.cbxSelect:setSelectedState(not bSelectStat)
				itemData.isSelected = not bSelectStat

				updateSelectNumText()
			end
		end

		if(bSelectStat == false) then
			local nSelectedCount =ResolveModel.getSelectedCount()
			if(nSelectedCount >= 1) then
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(7138))
			else
				objCell.cbxSelect:setSelectedState(not bSelectStat)
				itemData.isSelected = not bSelectStat
				updateSelectNumText()
			end
		end

	else


		if(itemData.bCanSelectd ~= nil and itemData.bCanSelectd == false) then
			ShowNotice.showShellInfo(m_i18nString(7141))
			return
		end

		
		if(bSelectStat == true)then
			if (objCell.cbxSelect) then
				objCell.cbxSelect:setSelectedState(not bSelectStat)
				itemData.isSelected = not bSelectStat

				updateSelectNumText()
			end
		end

		if(bSelectStat == false) then
			local nSelectedCount =ResolveModel.getSelectedCount()
			if(nSelectedCount >= 5) then
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(7138))
			else
				objCell.cbxSelect:setSelectedState(not bSelectStat)
				itemData.isSelected = not bSelectStat
				updateSelectNumText()
			end
		end

	end

end

local function tableCellAtIndexCallback( tbData )
	require "script/module/public/Cell/HeroCell"
	--伙伴影子
	if(m_nCurTabIndex ==  ResolveModel.T_Shadow) then
		local instCell = ShadowCell:new()
		instCell:init(CELL_USE_TYPE.DECOMP)
		instCell:refresh(tbData)
		return instCell
	elseif(m_nCurTabIndex == ResolveModel.T_Parnter) then
		--伙伴
		local instCell = PartnerCell:new()
		instCell:init(CELL_USE_TYPE.DECOMP)
		instCell:refresh(tbData)
		return instCell
	elseif(m_nCurTabIndex ==  ResolveModel.T_Treasure)then
		--宝物
		local instCell = TreasureCell:new()
		instCell:init(CELL_USE_TYPE.REBORN)
		instCell:refresh(tbData)
		return instCell
	elseif(m_nCurTabIndex == ResolveModel.T_Equip) then
		--装备
		local instCell = EquipCell:new()
		instCell:init(CELL_USE_TYPE.REBORN)
		instCell:refresh(tbData)
		return instCell

	elseif(m_nCurTabIndex == ResolveModel.T_SPTreasure) then
		--专属宝物
		local instCell = SpecialTreasCell:new()
		instCell:init(CELL_USE_TYPE.REBORN)
		instCell:refresh(tbData)
		return instCell
	elseif(m_nCurTabIndex == ResolveModel.T_SPShipItem) then
		--主船道具
		local instCell = ItemCell:new()
		instCell:init(CELL_USE_TYPE.DECOMP)
		instCell:refresh(tbData)
		return instCell
	elseif(m_nCurTabIndex == ResolveModel.T_RebornParnter) then
		--chongsheng
		--伙伴
		local instCell = PartnerCell:new()
		instCell:init(CELL_USE_TYPE.DECOMP)
		instCell:refresh(tbData)
		return instCell
	end
end

--创建tableview
function initTableView()
	local nsType = 0
	if(m_nCurTabIndex ==  ResolveModel.T_Shadow) then
		nsType = CELLTYPE.SHADOW 
	elseif(m_nCurTabIndex == ResolveModel.T_Parnter) then
		nsType = CELLTYPE.PARTNER
	elseif(m_nCurTabIndex ==  ResolveModel.T_Treasure)then
		nsType = CELLTYPE.TREASURE
	elseif(m_nCurTabIndex == ResolveModel.T_Equip) then
		nsType = CELLTYPE.EQUIP
	elseif(m_nCurTabIndex == ResolveModel.T_SPTreasure) then
		nsType = CELLTYPE.SPECIAL
	elseif(m_nCurTabIndex == ResolveModel.T_SPShipItem) then
		nsType = CELLTYPE.ITEM
	elseif(m_nCurTabIndex == ResolveModel.T_RebornParnter) then
		nsType = CELLTYPE.PARTNER
	end
	local sizeCell = g_fnCellSize(nsType)
	tbView = {szView = m_szView, szCell = sizeCell,
			 tbDataSource = m_tbCurData, CellAtIndexCallback = tableCellAtIndexCallback,
			 CellTouchedCallback = tableCellTouched,didScrollCallback = tableDidScrollCallback}

	if (not m_listResolve) then
		m_listResolve= HZListView:new()
	end

	if(m_listResolve:init(tbView)) then
		local hzLayout = TableViewLayout:create(m_listResolve:getView())
		m_layTbListParent:addChild(hzLayout)
		m_listResolve:refresh()

	end
end
--tbOnTouch:点击事件，tbSelectId:已经选中的id集合，tabType:四个tab中得哪一个
function create( tbOnTouch ,tbListData,tabType )
	logger:debug(tbListData)
	logger:debug(tabType)
	m_UIMain = g_fnLoadUI("ui/renascence_choose.json")
	m_nCurTabIndex = tabType
	local imgBg = m_fnGetWidget(m_UIMain, "img_choose_bottom_bg")
	imgBg:setScale(g_fScaleX) -- 2015-04-29

	local btnSure= m_fnGetWidget(m_UIMain, "BTN_SURE")
	local btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")

	m_labSelectInfo = m_fnGetWidget(m_UIMain,"TFD_CHOOSE_TXT")
	m_labSelectNum = m_fnGetWidget(m_UIMain,"TFD_CHOOSE_NUM")

	m_imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	m_imgChain = m_fnGetWidget(m_UIMain, "img_partner_chain")
	m_imgSmallBG = m_fnGetWidget(m_UIMain, "img_small_bg")

	local img_title = m_fnGetWidget(m_UIMain, "IMG_CHOOSE_TITLE")
	img_title:loadTexture(IMG_CHOOSELIST[tabType])

	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	m_imgBG:setScale(fScale)
	-- m_imgChain:setScale(g_fScaleX)
	m_imgSmallBG:setScale(g_fScaleX)


	UIHelper.titleShadow(btnSure,m_i18nString(1029))
	UIHelper.titleShadow(btnBack,m_i18n[1019])

	btnSure:addTouchEventListener(tbOnTouch.onSure)
	btnBack:addTouchEventListener(tbOnTouch.onBack)

	-- m_tbListData = tbListData
	m_tbCurData = tbListData
	initTabFocused(tabType)

	m_layTbListParent= m_fnGetWidget(m_UIMain,"lay_renascence_list")
	m_szView = CCSizeMake(m_layTbListParent:getSize().width, m_layTbListParent:getSize().height)
	return m_UIMain
end

