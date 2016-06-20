-- FileName: ShipBulletBagCtrl.lua
-- Author: yucong
-- Date: 2016-02-14
-- Purpose: 主船炮弹背包
--[[TODO List]]

module("ShipBulletBagCtrl", package.seeall)

local _instance = nil
local _layer = nil
local _curTab = nil
local _gunBarId = nil
local _loadCallBack = nil
local tabColor = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)}

function loadOK( ... )
	LayerManager.removeLayout()
	if (_loadCallBack) then
		_loadCallBack(...)
	end
end

function switchTab( tab )
	if (_curTab) then
		_curTab:setTitleColor(tabColor.normal)
		_curTab:setTouchEnabled(true)
		_curTab:setFocused(false)
		_curTab = nil
	end
	_curTab = g_fnGetWidgetByName(_layer, "BTN_TAB"..tab)
	if (_curTab) then
		_curTab:setTitleColor(tabColor.selected)
		_curTab:setTouchEnabled(false)
		_curTab:setFocused(true)
	end
	ShipBulletBagModel.setBulletType(tab)
	_instance:reload()
end

-- 切换标签
function onBtnTab( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		if (not _curTab or _curTab:getTag() ~= sender:getTag()) then
			switchTab(sender:getTag())
		end
	end
end

-- 穿戴
function onBtnLoad( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playLoadBall()
		ShipBulletRequest.wearBullet(_gunBarId, sender:getTag(), function ( ... )
			loadOK(...)
		end)
	end
end

-- 点击icon
function onBtnIcon( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		
	end
end

-- 返回
function onBtnBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		LayerManager.removeLayout()
	end
end

local function _create( bagType, bulletType )
	ShipBulletBagModel.setBagType(bagType)
	ShipBulletBagModel.setBulletType(bulletType)

	_instance = ShipBulletBagView:new()
	_layer = _instance:create()
	LayerManager.addLayoutNoScale(_layer, LayerManager.getModuleRootLayout())
	LayerManager.setPaomadeng(_layer,0)

	switchTab(ShipBulletBagModel.getBulletType())
end

-- 创建背包
function createBag( bulletType )
	_create(ShipBulletConst.E_BAG, bulletType)
end

-- 创建选择列表
function createSelectList( gunBarId, func, bulletType )
	_gunBarId = assert(gunBarId, "炮筒id未传")
	_loadCallBack = func
	-- 创建数据
	ShipBulletBagModel.handleUnuseBullets()
	_create(ShipBulletConst.E_BAG_LOAD, bulletType)

	PlayerPanel.removeCurrentPanel()
end


function destroy(...)
	logger:debug("ShipBulletBagCtrl_destroy")
	_instance = nil
	_layer = nil
	_curTab = nil
	_gunBarId = nil
	LayerManager.resetPaomadeng()
	if (ShipBulletBagModel.getBagType() == ShipBulletConst.E_BAG_LOAD) then
		PlayerPanel.addForPartnerStrength()
	end
	package.loaded["ShipBulletBagCtrl"] = nil
end

function moduleName()
    return "ShipBulletBagCtrl"
end