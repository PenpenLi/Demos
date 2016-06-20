-- FileName: SBListView.lua
-- Author: liweidong
-- Date: 2014-09-15
-- Purpose: 专属宝物背包list view
--[[TODO List]]

module("SBListView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil

-- 模块局部变量 --
local m_i18n = gi18n
local _listType = 1 --列表类型 显示控制变量 1宝物 2碎片
local g_fScaleX = g_fScaleX

local function init(...)

end

function destroy(...)
	package.loaded["SBListView"] = nil
end

function moduleName()
    return "SBListView"
end
--绘制宝物列表一行cell
function updateItemCell(list,idx)
	local cell = list:getItem(idx)
	-- local itemListData = SBListModel.getItemListData()
	local itemInfo = SBListModel.getItemCellData(idx+1)
	cell.item.TFD_NAME:setText(itemInfo.itemDesc.name)
	cell.item.TFD_OWNER:setText(itemInfo.parter)
	cell.item.TFD_RANK:setText(itemInfo.itemDesc.base_score)
	cell.item.LAY_ICON:removeAllChildrenWithCleanup(true)
	local icon = ItemUtil.createBtnByTemplateId(itemInfo.itemDesc.id,function()
			AudioHelper.playInfoEffect()
			SBListCtrl.onClickItemIcon(idx+1)
		end)
	icon:setPosition(ccp(cell.item.LAY_ICON:getSize().width/2, cell.item.LAY_ICON:getSize().height/2))
	cell.item.LAY_ICON:addChild(icon)
	cell.item.TFD_SPECIAL_LV:setText(itemInfo.va_item_text.exclusiveEvolve .. m_i18n[6933])
	UIHelper.titleShadow(cell.item.BTN_LOAD)
	cell.item.BTN_LOAD:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			SBListCtrl.onclickAdvanced(idx+1)
		end
	end)
	--绘制属性
	local tbAttr = itemInfo.property
	for i=1,6 do
		if (tbAttr[i]) then
			cell.item["TFD_AFFIX_".. i]:setText(tbAttr[i].name .. "：")
			cell.item["TFD_AFFIX_NUM_".. i]:setText("+" .. tbAttr[i].value)
			cell.item["TFD_AFFIX_".. i]:setVisible(true)
			cell.item["TFD_AFFIX_NUM_".. i]:setVisible(true)
		else
			cell.item["TFD_AFFIX_".. i]:setVisible(false)
			cell.item["TFD_AFFIX_NUM_".. i]:setVisible(false)
		end
	end
end
--刷新宝物背包
function refreshItemList()
	local fragListData = SBListModel.getItemListData()
	UIHelper.reloadListView(_layoutMain.listView,table.count(fragListData),updateFragCell)
end
--加载宝物背包 enterAction==nil时执行动画
function loadItemList(enterAction,offset)
	_layoutMain.LAY_BAG:removeAllChildrenWithCleanup(true)
	_layoutMain.listView = UIHelper.createListView({sizeType=SIZE_ABSOLUTE,
		size=CCSizeMake(_layoutMain.LAY_BAG:getContentSize().width,_layoutMain.LAY_BAG:getContentSize().height)})
	_layoutMain.LAY_BAG:addChild(_layoutMain.listView)

	-- _layoutMain.listView:jumpToTop()
	-- local instCell = TreasureCell:new()
	-- instCell:init(CELL_USE_TYPE.LOAD)
	-- instCell:refresh(tbDat)
	-- return instCell

	local cell = getCellByType(CELLTYPE.SPECIAL)
	local cellItem = cell.LAY_SPECIAL:clone()
	cellItem.LAY_SPECIAL_REBORN:removeFromParent()
	cellItem.LAY_SPECIAL_LOAD:removeFromParent()
	cellItem.LAY_SPECIAL_BAG:setVisible(true)
	cellItem.lay_special_icon:setVisible(true)
	cellItem.tfd_special_quality_lv:setText(m_i18n[4901])
	cellItem.BTN_LOAD:setTitleText(m_i18n[1005])
	-- UIHelper.titleShadow(cellItem.BTN_LOAD)

	local itemListData = SBListModel.getItemListData()
	cellItem:setSize(CCSizeMake(cellItem:getSize().width*g_fScaleX,cellItem:getSize().height*g_fScaleX)) --缩放cell
	cellItem.img_special_bg:setScale(g_fScaleX)
	-- TimeUtil.timeStart("list View create")
	UIHelper.initListViewCell(_layoutMain.listView,cellItem)
	-- TimeUtil.timeEnd("list View create")
	-- TimeUtil.timeStart("list View load")
	UIHelper.reloadListView(_layoutMain.listView,table.count(itemListData),updateItemCell,offset,(not enterAction) and 1)
	-- TimeUtil.timeEnd("list View load")
	_listType = 1
	if (not enterAction) then
		-- listEnterAction()
	end
end
--绘制宝物碎片列表一行cell
function updateFragCell(list,idx)
	local itemInfo = SBListModel.getFragCellData(idx+1)
	local cell = list:getItem(idx)
	cell.item.TFD_NAME:setText(itemInfo.itemDesc.name)
	local itemNum = tonumber(itemInfo.item_num)
	local itemMax = tonumber(itemInfo.itemDesc.need_part_num)
	cell.item.TFD_MEMBER_NUM:setText(itemNum)
	cell.item.TFD_DOMIT_NUM:setText(itemMax)
	cell.item.TFD_DESC:setVisible(itemNum<itemMax)
	cell.item.BTN_DROP:setEnabled(itemNum<itemMax)
	cell.item.BTN_DROP:setTag(idx+1)
	cell.item.BTN_DROP:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			SBListCtrl.onclickToGet(sender:getTag(),itemInfo.itemDesc.id)
		end
	end)
	cell.item.BTN_COMPOND:setEnabled(itemNum>=itemMax)
	cell.item.BTN_COMPOND:setTag(idx+1)
	UIHelper.titleShadow(cell.item.BTN_COMPOND)
	cell.item.BTN_COMPOND:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			SBListCtrl.onclickCompond(sender:getTag())
		end
	end)
	cell.item.LAY_ICON:removeAllChildrenWithCleanup(true)
	local icon = ItemUtil.createBtnByTemplateId(itemInfo.itemDesc.id,function()
			AudioHelper.playInfoEffect()
			SBListCtrl.onClickFragIcon(idx+1)
		end)
	icon:setPosition(ccp(cell.item.LAY_ICON:getSize().width/2, cell.item.LAY_ICON:getSize().height/2))
	cell.item.LAY_ICON:addChild(icon)
end
--加载宝物碎片背包  enterAction==nil时执行动画
function loadFragList(enterAction,offset) 
	_layoutMain.LAY_BAG:removeAllChildrenWithCleanup(true)
	_layoutMain.listView = UIHelper.createListView({sizeType=SIZE_ABSOLUTE,
		size=CCSizeMake(_layoutMain.LAY_BAG:getContentSize().width,_layoutMain.LAY_BAG:getContentSize().height)})
	_layoutMain.LAY_BAG:addChild(_layoutMain.listView)
	-- _layoutMain.listView:jumpToTop()
	local cell = getCellByType(CELLTYPE.SPECIAL_FRAG)
	local cellItem = cell.LAY_SPEC_GRAG:clone()
	cellItem.tfd_progress_i18n:setText(m_i18n[1332])
	cellItem.TFD_DESC:setText(m_i18n[1127])
	cellItem.BTN_COMPOND:setTitleText(m_i18n[1604])

	local fragListData = SBListModel.getFragListData()
	cellItem:setSize(CCSizeMake(cellItem:getSize().width*g_fScaleX,cellItem:getSize().height*g_fScaleX)) --缩放cell
	cellItem.img_special_fragment_bg:setScale(g_fScaleX)
	UIHelper.initListViewCell(_layoutMain.listView,cellItem)
	UIHelper.reloadListView(_layoutMain.listView,table.count(fragListData),updateFragCell,offset,(not enterAction) and 1)
	_listType = 2
	if (not enterAction) then
		-- listEnterAction()
	end
end
--返回列表定位
function getListOffset()
	return _layoutMain.listView:getJumpOffset()
end
function setListOffset(pos)
	_layoutMain.listView:setJumpOffset(pos)
end
--刷新宝物碎片背包
function refreshFragList()
	local fragListData = SBListModel.getFragListData()
	UIHelper.reloadListView(_layoutMain.listView,table.count(fragListData),updateFragCell)
end
--列表飞入动画 
function listEnterAction()
	_layoutMain.listView:setVisible(false)
	local shieldLayout =Layout:create() --屏蔽层 
	if (_layoutMain.listView:getItems():count()>0) then
		shieldLayout:setTouchEnabled(true)
		shieldLayout:setSize(g_winSize)
		_layoutMain:addChild(shieldLayout)
		shieldLayout:setTag(9999)
		_layoutMain.listView:setTouchEnabled(false)
	end
	performWithDelayFrame(_layoutMain,function(frame)
			_layoutMain.listView:setVisible(true)
			local actionIdx =1
			local endActionNum =1
			for i=0,_layoutMain.listView:getItems():count()-1 do
				local cell = _layoutMain.listView:getItem(i)
				if (cell.refreshstatus==1 and actionIdx<6) then
					UIHelper.startCellAnimation(cell.item, actionIdx,function ( ) 
						endActionNum=endActionNum+1
						if (endActionNum+1>=actionIdx) then
							_layoutMain.listView:setTouchEnabled(true)
							_layoutMain:removeChildByTag(9999,true)
						end
			        end)
					actionIdx = actionIdx+1
				end
			end
		end,2)
end
--国际化
function setUIStyleAndI18n(base)
	base.BTN_TAB1:setTitleText(m_i18n[6905])
	base.BTN_TAB2:setTitleText(m_i18n[6906])
	base.TFD_CARRY_NUM:setText(m_i18n[1004])
	-- UIHelper.titleShadow(base.BTN_RECORD)
	-- UIHelper.titleShadow(base.BTN_BACK)
	-- UIHelper.labelNewStroke( base.tfd_soldier_title, ccc3(0x28,0x00,0x00), 2 )
end
--加载UI
function loadUI()
	logger:debug("ui/bag_common.json")
	_layoutMain = g_fnLoadUI("ui/bag_common.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				-- _layoutMain=nil
			end,
			function()
			end
		)
	setUIStyleAndI18n(_layoutMain)
	_layoutMain.BTN_TAB3:setEnabled(false)
	_layoutMain.BTN_WEAR_CONCH:setEnabled(false)
	_layoutMain.BTN_BACK:setEnabled(false)
	_layoutMain.BTN_SALE:setEnabled(false)
	_layoutMain.BTN_TAB1.IMG_TAB_TIPS:setVisible(false)
	_layoutMain.BTN_TAB2.IMG_TAB_TIPS:setVisible(false)
	_layoutMain.img_bg:setScale(g_fScaleX)
	_layoutMain.lay_easy_info:setScale(g_fScaleX)
	_layoutMain.img_partner_chain:setScale(g_fScaleX)
	_layoutMain.img_small_bg:setScale(g_fScaleX)

	_layoutMain.BTN_TAB1:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			SBListCtrl.onclickItemTag()
		end
	end)
	_layoutMain.BTN_TAB2:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			SBListCtrl.onclickFragTag()
		end
	end)
	_layoutMain.BTN_EXPANG:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			SBListCtrl.onExpand(_listType)
		end
	end)
end
--更新界面
function updateUI()
	local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)} 
	if (_listType==1) then
		_layoutMain.BTN_TAB1:setTitleColor(m_color.selected)
		_layoutMain.BTN_TAB1:setFocused(true)
		_layoutMain.BTN_TAB1:setTouchEnabled(false)
		_layoutMain.BTN_TAB2:setTitleColor(m_color.normal)
		_layoutMain.BTN_TAB2:setFocused(false)
		_layoutMain.BTN_TAB2:setTouchEnabled(true)
		_layoutMain.TFD_BAG_NUM:setText(SBListModel.getItemMaxNum())
		_layoutMain.TFD_OWN_NUM:setText(SBListModel.getItemNum())
	else
		_layoutMain.BTN_TAB2:setTitleColor(m_color.selected)
		_layoutMain.BTN_TAB2:setFocused(true)
		_layoutMain.BTN_TAB2:setTouchEnabled(false)
		_layoutMain.BTN_TAB1:setTitleColor(m_color.normal)
		_layoutMain.BTN_TAB1:setFocused(false)
		_layoutMain.BTN_TAB1:setTouchEnabled(true)
		_layoutMain.TFD_BAG_NUM:setText(SBListModel.getFragMaxNum())
		_layoutMain.TFD_OWN_NUM:setText(SBListModel.getFragmentNum())
	end
	--碎片红点
	local compoundNum = SBListModel.getFragCompoundNum()
	-- _layoutMain.BTN_TAB2.LABN_NUM:setStringValue(compoundNum) --换红点，不需要数值
	if (compoundNum<=0) then
		-- _layoutMain.BTN_TAB2.IMG_TAB_TIPS:setVisible(false)--换红点，不需要数值
		_layoutMain.BTN_TAB2.IMG_RED:setVisible(false)
	else
		-- _layoutMain.BTN_TAB2.IMG_TAB_TIPS:setVisible(true)--换红点，不需要数值
		_layoutMain.BTN_TAB2.IMG_RED:setVisible(true)
		_layoutMain.BTN_TAB2.IMG_RED:removeAllNodes()
		_layoutMain.BTN_TAB2.IMG_RED:addNode(UIHelper.createRedTipAnimination())
	end
end
function create(...)
	loadUI()
	return _layoutMain
end
