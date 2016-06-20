-- FileName: ShipBulletBagView.lua
-- Author: yucong
-- Date: 2016-02-14
-- Purpose: 主船炮弹view
--[[TODO List]]
require "script/module/public/CCommonView"
ShipBulletBagView = class("ShipBulletBagView", CCommonView)

local m_fnGetWidget = g_fnGetWidgetByName

function ShipBulletBagView:notifications( ... )
	return {
		-- [ShipBulletConst.MSG_BULLET_LOAD_OK]	= function (...) self:fnMSG_BULLET_LOAD_OK(...) end,
	}
end

function ShipBulletBagView:adaptItems( ... )
	return {
		self._mainLayer.img_bg,
		self._mainLayer.img_small_bg,
		self._mainLayer.img_partner_chain,
		self._mainLayer.img_title_bg,
	}
end

function ShipBulletBagView:fnUpdate( ... )
	
end

function ShipBulletBagView:ctor()
	
end

function ShipBulletBagView:create( ... )
	self._mainLayer = g_fnLoadUI("ui/ship_skill_bag.json")

	-- 注册onExit()
	self:registExitAndEnterCall(function ( ... )
		ShipBulletBagCtrl.destroy()
    end)
    self:createFrame()

	return self._mainLayer
end

function ShipBulletBagView:createFrame( ... )
	local bagType = ShipBulletBagModel.getBagType()
	local BTN_BACK = nil
	if (bagType == ShipBulletConst.E_BAG) then
		self._mainLayer.img_title_bg:setVisible(false)
		self._mainLayer.img_title_bg:setEnabled(false)
		BTN_BACK = self._mainLayer.lay_bag_tab.BTN_BACK
	elseif (bagType == ShipBulletConst.E_BAG_LOAD) then
		self._mainLayer.lay_bag_tab.BTN_BACK:setVisible(false)
		self._mainLayer.lay_bag_tab.BTN_BACK:setTouchEnabled(false)
		BTN_BACK = self._mainLayer.img_title_bg.BTN_BACK
	end
	local tabDes = {"输出型", "治疗型", "辅助型"}
	for i = 1, 3 do
		local btn = g_fnGetWidgetByName(self._mainLayer, "BTN_TAB"..i)
		btn:setTag(i)
		btn:addTouchEventListener(ShipBulletBagCtrl.onBtnTab)
		btn:setTitleText(tabDes[i])
		btn:setTitleColor(ccc3(0xbf, 0x93, 0x67))
	end
	BTN_BACK:addTouchEventListener(ShipBulletBagCtrl.onBtnBack)
	-- BTN_BACK:setTitleText(m_i18n[1019])
	UIHelper.titleShadow(BTN_BACK, self:i18n(1019))

	self:initLsv()
end

function ShipBulletBagView:initLsv( ... )
	self._mainLayer.listView = UIHelper.createListView({
		sizeType = SIZE_ABSOLUTE,
		size = CCSizeMake(self._mainLayer.lay_choose:getContentSize().width, self._mainLayer.lay_choose:getContentSize().height)
	})
	self._mainLayer.lay_choose:addChild(self._mainLayer.listView)

	local cell = self._mainLayer.LAY_SKILL_CELL
	cell:removeFromParent()
	local cellItem = cell:clone()
	
	cellItem:setSize(CCSizeMake(cellItem:getSize().width * g_fScaleX, cellItem:getSize().height * g_fScaleX)) --缩放cell
	cellItem.img_cell_skill_bg:setScale(g_fScaleX)
	UIHelper.initListViewCell(self._mainLayer.listView, cellItem)
end

function ShipBulletBagView:reload( ... )
	self._mainLayer.listView:removeAllItems()
	UIHelper.reloadListView(self._mainLayer.listView, table.count(ShipBulletBagModel.getDatasByType()), function ( ... )
		self:cellAtIndex(...)
	end, nil, 2)
end

function ShipBulletBagView:cellAtIndex( list, idx )
	logger:debug("cellAtIndex")
	local cell = nil
	local bagType = ShipBulletBagModel.getBagType()
	local bullets = ShipBulletBagModel.getDatasByType() 
	local db_bullet = bullets[idx + 1]

	if (bagType == ShipBulletConst.E_BAG) then
		cell = list:getItem(idx).item
		cell.BTN_EQUIP:setVisible(false)
		cell.BTN_EQUIP:setTouchEnabled(false)
		-- 是否已装备
		local isLoad = ShipBulletBagModel.isBulletLoad(db_bullet.id)
		cell.IMG_ALREADY_EQUIP:setVisible(isLoad)
	elseif (bagType == ShipBulletConst.E_BAG_LOAD) then
		cell = list:getItem(idx).item
		cell.IMG_ALREADY_EQUIP:setVisible(false)
		cell.BTN_EQUIP:addTouchEventListener(ShipBulletBagCtrl.onBtnLoad)
		UIHelper.titleShadow(cell.BTN_EQUIP)
	end
	
	-- name
	cell.TFD_NAME:setText(db_bullet.skill_name)--base_desc
	cell.TFD_NAME:setColor(g_QulityColor[db_bullet.quality])
	-- attrib
	local sAttrib, attribName, attribValue = ShipBulletBagModel.getBulletAttrib(db_bullet.id)
	cell.TFD_DESC:setText(db_bullet.base_desc)
	cell.TFD_ATTR:setText(attribName..":")
	cell.TFD_ATTR_NUM:setText(attribValue)
	-- btn
	cell.BTN_EQUIP:setTag(db_bullet.id)
	-- icon
	local icon = ShipBulletBagModel.createBulletIcon(db_bullet.id)-- 不添加点击事件, ShipBulletBagCtrl.onBtnIcon)
	local szIcon = cell.LAY_ICON:getSize()
	icon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
	cell.LAY_ICON:removeAllChildren()
	cell.LAY_ICON:addChild(icon)

	cell.img_desc_bg:updateSizeAndPosition()
end