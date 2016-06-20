-- FileName: AwakeItemInfoView.lua
-- Author: LvNanchun
-- Date: 2015-11-18
-- Purpose: 道具信息界面view
--[[TODO List]]

AwakeItemInfoView = class("AwakeItemInfoView")

-- UI variable --
local _layMain

-- module local variable --
local _fnGetWidget = g_fnGetWidgetByName
local _i18n = gi18n

function AwakeItemInfoView:moduleName()
    return "AwakeItemInfoView"
end

function AwakeItemInfoView:ctor(...)
	_layMain = g_fnLoadUI("ui/awake_item_info.json")
	-- 将三个按钮在初始化时变得看不见摸不到
	_layMain.LAY_BTN1:setEnabled(false)
	_layMain.LAY_BTN2:setEnabled(false)
	_layMain.BTN_SURE:setEnabled(false)
	_layMain.BTN_GAIN:setEnabled(false)
	_layMain.BTN_COMPOSE:setEnabled(false)
	-- 初始化一些控件的值
	_layMain.TFD_TIP:setText(_i18n[7427])
	_layMain.TFD_ITEM_NUM_WORD:setText(_i18n[6907])
end

function AwakeItemInfoView:refreshHaveNum( haveNum )
	_layMain.TFD_ITEM_NUM:setText(tostring(haveNum))
end

function AwakeItemInfoView:create( tbBtn, tbInfo )
	-- 确认按钮
	if (tbBtn.sure) then
		_layMain.BTN_SURE:setEnabled(true)
		_layMain.LAY_BTN1:setEnabled(true)
		_layMain.BTN_SURE:addTouchEventListener(tbBtn.sure)
	end
	-- 获取按钮
	if (tbBtn.gain) then
		_layMain.LAY_BTN2:setEnabled(true)
		_layMain.BTN_GAIN:setEnabled(true)
		_layMain.BTN_GAIN:addTouchEventListener(tbBtn.gain)
	end
	-- 合成按钮
	if (tbBtn.compose) then
		_layMain.LAY_BTN2:setEnabled(true)
		_layMain.BTN_COMPOSE:setEnabled(true)
		_layMain.BTN_COMPOSE:addTouchEventListener(tbBtn.compose)
	end
	-- 装备按钮
	if (tbBtn.equip) then
		_layMain.LAY_BTN1:setEnabled(true)
		_layMain.BTN_SURE:setEnabled(true)
		-- 将本来的确认按钮改成装备按钮
		UIHelper.titleShadow( _layMain.BTN_SURE, _i18n[1601] )
		_layMain.BTN_SURE:addTouchEventListener(tbBtn.equip)
	end
	-- 关闭按钮
	_layMain.BTN_CLOSE:addTouchEventListener(tbBtn.close)
	-- 图标按钮
	_layMain.LAY_ITEM_ICON:addChild(tbInfo.icon)
	tbInfo.icon:setPosition(ccp(_layMain.LAY_ITEM_ICON:getContentSize().width/2, _layMain.LAY_ITEM_ICON:getContentSize().height/2))
	-- 名字
	_layMain.TFD_ITEM_NAME:setText(tbInfo.name)
	_layMain.TFD_ITEM_NAME:setColor(tbInfo.color)
	-- 属性值
	for i = 1,3 do
		local oneAttr = tbInfo.attr[i]
		local attrBg = _layMain.img_desc_bg
		local attrWidget = _fnGetWidget(attrBg, "LAY_ATTR" .. tostring(i))
		attrWidget.TFD_ATTR:setText(oneAttr.desc)
		attrWidget.TFD_ATTR_NUM:setText("+" .. tostring(oneAttr[2]))
	end
	-- 拥有数量
	_layMain.TFD_ITEM_NUM:setText(tostring(tbInfo.nowNum))

	return _layMain
end

