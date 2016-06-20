-- FileName: AwakeCPView.lua
-- Author: 
-- Date: 2015-11-25
-- Purpose: 觉醒合成
--[[TODO List]]

AwakeCPView = class("AwakeCPView")

-- UI控件引用变量 --
local _layMain = nil
local _listViewUp = nil
local _listViewBelow = nil
local _fnGetWidget = g_fnGetWidgetByName
local _btnEvent
local _i18n = gi18n
-- 模块局部变量 --
local DROP_IMAGE_PATH = "images/drop/"


-- 添加listview的cell
function AwakeCPView:fnLayListView()
	local composeLine = AwakeCPData.getComposeLine()
	local numOfCell = #composeLine

	_listViewUp:removeAllItems()		

	for k,v in ipairs(composeLine) do
		_listViewUp:pushBackDefaultItem()
		local cellIndex = k-1
		local btnCell = ItemUtil.createBtnByTemplateId(v, _btnEvent.onLast, {false,false})
		btnCell:setTag(k)

		local layCell = _listViewUp:getItem(cellIndex)
		btnCell:setPosition(ccp(layCell.LAY_ITEM:getContentSize().width*0.5,layCell.LAY_ITEM:getContentSize().height*0.5))
		layCell.LAY_ITEM:addChild(btnCell)

		local itemDB = DB_Item_disillusion.getDataById(v)

		layCell.IMG_ARROW_RIGHT:setVisible(k ~= numOfCell)
		layCell.IMG_ARROW_DOWN:setVisible(k == numOfCell)
	end
	UIHelper.setSliding( _listViewUp )
end


-- 显示下方的区域，判断是合成还是去获取
function AwakeCPView:fnSetComposeArea( ... )
	local nowItemInfo = AwakeCPData.getNowComposeInfo()

	_layMain.TFD_ITEM_NAME_TITLE:setColor(g_QulityColor[nowItemInfo.itemDB.quality])
	_layMain.TFD_ITEM_NAME_TITLE:setText(nowItemInfo.itemDB.name)

	-- 判断能否合成，如果能合成，显示合成树形图，否则，显示去获取列表
	_layMain.LAY_COMPOSE:setEnabled(nowItemInfo.canCompose == 1)
	_layMain.LAY_GET_WAY:setEnabled(nowItemInfo.canCompose == 0)

	_layMain.img_main_bg:setZOrder(-1) ---找翕伦解决


	if (nowItemInfo.canCompose == 1) then
		local function setIcon( lay, nowItemInfo, tag)
			local numHave = nil
			local numNeed = nil
			local itemInfo
			local btnComposeItem
			if (tag ~= 1) then
				itemInfo = nowItemInfo.childItems[tag-1]
				numHave = ItemUtil.getAwakeNumByTid(itemInfo.itemId)
				numNeed = itemInfo.itemNeedNum
				btnComposeItem = ItemUtil.createBtnByItemAndNumCondition( ItemUtil.getItemById(itemInfo.itemId), numHave, numNeed, _btnEvent.onNext)
			else
				itemInfo = nowItemInfo
				btnComposeItem = ItemUtil.createBtnByItemAndNumCondition( ItemUtil.getItemById(itemInfo.itemId), numHave, numNeed, _btnEvent.onGetWay)
			end
			btnComposeItem:setTag(tag)
			btnComposeItem:setPosition(ccp(lay:getContentSize().width*0.5,lay:getContentSize().height*0.5))
			lay:addChild(btnComposeItem)
		end
		for i = 1, 4 do 
			local cell = _fnGetWidget(_layMain.LAY_COMPOSE, "LAY_ITEM" .. i)
			setIcon( cell, nowItemInfo, i)
		end
		
		_layMain.TFD_BELLY_NUM:setText(nowItemInfo.itemDB.need_belly)

		local composeLine = AwakeCPData.getComposeLine()
		local composeRoot = composeLine[1]
		if (nowItemInfo.enough) then
			_layMain.BTN_COMPOSE:addTouchEventListener(_btnEvent.onCompose)
			_layMain.BTN_COMPOSE:setTouchEnabled(true)
			UIHelper.setWidgetGray(_layMain.BTN_COMPOSE, false)
		elseif ( MainAwakeModel.mainGetIfCanCompose(composeRoot, 1) ) then
			_layMain.BTN_COMPOSE:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(_i18n[7424])
				end
			end)
			_layMain.BTN_COMPOSE:setTouchEnabled(true)
			UIHelper.setWidgetGray(_layMain.BTN_COMPOSE, false)
		else
			_layMain.BTN_COMPOSE:addTouchEventListener(_btnEvent.onCompose)
			_layMain.BTN_COMPOSE:setTouchEnabled(false)
			UIHelper.setWidgetGray(_layMain.BTN_COMPOSE, true)
		end

	elseif (nowItemInfo.canCompose == 0) then
		-- 接通用的掉落途径处理
		require "script/module/public/DropLVUtil"
		local dropLVUtil = DropLVUtil:new()
		local GuidInfo = {}
		GuidInfo.guidStuffDB = nowItemInfo.itemDB
		dropLVUtil:create(_layMain.img_main_bg2, GuidInfo, 2)
	end
end

function AwakeCPView:showComposeAni( composeCallback )
	if (_layMain.LAY_COMPOSE:isEnabled()) then
		local animationCompose = UIHelper.createArmatureNode({
			filePath = "images/effect/juexing/awake_item_compose/awake_item_compose.ExportJson",
			animationName = "awake_item_compose",
			loop = 0,
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == EVT_COMPLETE) then
					composeCallback()
				end
			end
		})
		local layAni = _layMain.LAY_ITEM1
		animationCompose:setPosition(layAni:getSize().width/2, layAni:getSize().height/2)
		AudioHelper.playSpecialEffect("awake_item_compose.mp3")
		layAni:addNode(animationCompose,2)
	end
end

function AwakeCPView:refreshView( ... )
	self:fnLayListView()
	self:fnSetComposeArea()
end

function AwakeCPView:ctor( ... )
	local mainLayout = g_fnLoadUI("ui/awake_compose.json")
	self.mainLayout = mainLayout
end

function AwakeCPView:init(...)
	_listViewUp = self.mainLayout.LSV_MAIN
	UIHelper.initListView(_listViewUp)

	UIHelper.initListView(_layMain.img_main_bg2.LSV_LIST)
end

function AwakeCPView:destroy(...)
	package.loaded["AwakeCPView"] = nil
end

function AwakeCPView:moduleName()
    return "AwakeCPView"
end

function AwakeCPView:create( btnEvent )
	_layMain = self.mainLayout


	UIHelper.registExitAndEnterCall(_layMain,
		function()
			GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, "AwakeCPModel")
		end,
		function()
			GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
				LayerManager.removeLayoutByName("layerBlockAwakeComposeAni")
			end,false,"AwakeCPModel")
		end
	)

	self:init()

	_btnEvent = btnEvent

	_layMain.BTN_CLOSE:addTouchEventListener(_btnEvent.onClose)

	self:fnLayListView()
	self:fnSetComposeArea()
	_layMain.TFD_COMSUME:setText(_i18n[7426])
	UIHelper.titleShadow(_layMain.BTN_COMPOSE, _i18n[1604])
	
	_layMain.TFD_TXT:setText(_i18n[7201])
	return _layMain
end
