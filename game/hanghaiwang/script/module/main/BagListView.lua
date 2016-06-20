-- FileName: BagListView.lua
-- Author: LvNanchun
-- Date: 2015-09-25
-- Purpose: function description of module
--[[TODO List]]

BagListView = class("BagListView")
require "script/module/main/MainScene"

-- UI variable --
local _layMain

-- module local variable --

function moduleName()
    return "BagListView"
end

function BagListView:ctor(...)
	_layMain = g_fnLoadUI("ui/all_bag.json")
	_layMain.LAY_MAIN:setAnchorPoint(ccp(0.5 , 0))
	_layMain.LAY_MAIN:setScaleX(0.1)
end		

function BagListView:create(...)
	_layMain.LAY_ROOT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainMenuBtn() -- 2015-12-29
			LayerManager.removeLayout()
		end
	end)

	_layMain.IMG_ANNIU_BG:setTouchEnabled(true)
	_layMain.IMG_ANNIU_BG:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainMenuBtn() -- 2015-12-29
			LayerManager.removeLayout()
		end
	end)

	-- 背包展开的动作
	local array = CCArray:create()
	local wait1=CCDelayTime:create(0.01)
	local scale = CCScaleTo:create(8/60 , 1 , 1)
	array:addObject(wait1)
	array:addObject(scale)
	local seq = CCSequence:create(array)
	_layMain.LAY_MAIN:runAction(seq)

	-- 装备背包
	local function onEquip( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect() -- 2015-12-29
	
			require "script/module/equipment/MainEquipmentCtrl"
			if not (LayerManager.isRunningModule(MainEquipmentCtrl)) then 
				local layEquipment = MainEquipmentCtrl.create()
				if layEquipment then
					LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
					MainScene.updateBgLightOfMenu()
					PlayerPanel.removeCurrentPanel()
					PlayerPanel.addForPartnerStrength()
				end
			end
		end
	end
	-- 道具背包
	local function onItem( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect() -- 2015-12-29

			require "script/module/bag/MainBagCtrl"
			if (not LayerManager.isRunningModule(MainBagCtrl)) then
				MainBagCtrl.create()
				MainScene.updateBgLightOfMenu()
			end
		end
	end

	-- 饰品背包(宝物背包)
	local function onJewel( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect() -- 2015-12-29

			require "script/module/treasure/MainTreaBagCtrl"
			if (not LayerManager.isRunningModule(MainTreaBagCtrl)) then
				MainTreaBagCtrl.create() -- 默认显示宝物列表
				MainScene.updateBgLightOfMenu()
			end
		end
	end

	-- 宝物背包（专属宝物）
	local function onTrea( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect() -- 2015-12-29

			require "script/module/specialBag/SBListCtrl"
			logger:debug("========")
			SBListCtrl:create()
			MainScene.updateBgLightOfMenu()
		end
	end

	-- 贝类背包
	local function onConch ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			require "script/module/conch/ConchBag/MainConchCtrl"
			local curModuleName = LayerManager.curModuleName()
			if (MainConchCtrl.moduleName() ~= curModuleName) then
				local layBag = MainConchCtrl.create( curModuleName ) -- 默认显示道具列表
				if (layBag) then
					LayerManager.removeLayout()
					LayerManager.changeModule(layBag, MainConchCtrl.moduleName(), {1, 3}, true , 1)
--					PlayerPanel.removeCurrentPanel()
					PlayerPanel.addForPublic()
					MainScene.updateBgLightOfMenu()
				end
			end
		end
	end

	-- 觉醒背包
	local function onAwake( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local curModuleName = LayerManager.curModuleName()
			if (AwakeBagCtrl.moduleName() ~= curModuleName) then
				AwakeBagCtrl.create()
			end
		end
	end

	local tbRedPointState = g_redPoint
	logger:debug({tbRedPointState = tbRedPointState})
	-- 装备红点的判断并不涉及g_redPoint，只涉及到装备碎片的合成数量。这里的tbRedPointState.equip.visible暂时保留
	require "script/model/utils/EquipFragmentHelper"
	_layMain.BTN_EQUIP.IMG_TIP_RED:setVisible(tbRedPointState.equip.visible or (EquipFragmentHelper.getCanFuseNum() > 0))
	-- 空岛贝背包删除
--	_layMain.BTN_CONCH.IMG_TIP_RED:setVisible(tbRedPointState.conch.visible)
	-- 此处添加这些碎片个数的判断独立于利用物品变动的推送引起的g_redPoint变动，用于在刚刚进入游戏时显示红点
	require "script/module/grabTreasure/TreasureData"
	local treaFragNum = TreasureData.getCanFuseNum()
	_layMain.BTN_JEWEL.IMG_TIP_RED:setVisible(tbRedPointState.treasure.visible or treaFragNum > 0)
	require "script/module/specialBag/SBListModel"
	logger:debug({baglistview = SBListModel.getFragCompoundNum()})
	_layMain.BTN_TREA.IMG_TIP_RED:setVisible(tbRedPointState.special.visible or (SBListModel.getFragCompoundNum() > 0))
	_layMain.BTN_ITEM.IMG_TIP_RED:setVisible(tbRedPointState.bag.visible)
	_layMain.BTN_AWAKE.IMG_TIP_RED:setVisible(false)

	-- 按钮事件绑定
	-- 空岛贝背包删除，加入觉醒背包
	_layMain.BTN_EQUIP:addTouchEventListener(onEquip)
--	_layMain.BTN_CONCH:addTouchEventListener(onConch)
	_layMain.BTN_JEWEL:addTouchEventListener(onJewel)
	_layMain.BTN_TREA:addTouchEventListener(onTrea)
	_layMain.BTN_ITEM:addTouchEventListener(onItem)
	_layMain.BTN_AWAKE:addTouchEventListener(onAwake)

	-- 按钮位置设置,暂时屏蔽觉醒背包
	if (SwitchModel.getSwitchOpenState(ksSwitchAwake,false)) then
		_layMain.BTN_AWAKE:setVisible(true)
		_layMain.BTN_AWAKE:setTouchEnabled(true)
	else
		-- 在觉醒未开启时，将按钮右移一个按钮的宽度，并缩小背景的宽度
		local positionSub = _layMain.BTN_ITEM:getPositionX() - _layMain.BTN_EQUIP:getPositionX()
		local changeScale = (_layMain.IMG_BAG_BG:getSize().width - positionSub) / _layMain.IMG_BAG_BG:getSize().width
		_layMain.IMG_ANNIU_BG:setPositionType(0)
		_layMain.IMG_ANNIU_BG:setPositionX(_layMain.IMG_ANNIU_BG:getPositionX() + positionSub / 6 * 5)
		_layMain.IMG_BAG_BG:setScaleX(changeScale)
		_layMain.BTN_AWAKE:setVisible(false)
		_layMain.BTN_AWAKE:setTouchEnabled(false)
	end

	_layMain:setName("all_bag")

	return _layMain
end

