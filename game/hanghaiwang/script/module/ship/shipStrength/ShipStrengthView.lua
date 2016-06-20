
-- FileName: ShipStrengthView.lua
-- Author: LvNanchun
-- Date: 2015-10-19
-- Purpose: function description of module
--[[TODO List]]

ShipStrengthView = class("ShipStrengthView")
require "script/module/ship/shipStrength/ShipStrengthModel"

-- UI variable --
local _layMain
local _tbTFDNum1
local _tbtfd1
local _tbTFDNum2
local _tbtfd2

-- module local variable --
local _gColor = g_QulityColor
local _gColor2 = g_QulityColor2
local _i18n = gi18n
local _SHIP_ANI_TAG = 512
local _STRE_ANI_TAG = 1000
local _WATER_ANI_TAG = 513
local _ICON_BTN_TAG = 999
local _fnGetWidget = g_fnGetWidgetByName

function ShipStrengthView:moduleName()
    return "ShipStrengthView"
end

--[[desc:封装全局的延迟方法，方便在CTRL里面调用
    arg1: timeLength时间长度，callBack回调事件
    return: 无
—]]
function ShipStrengthView:performWithDelay( timeLength, callBack )
	if (callBack) then
		performWithDelay(_layMain, callBack, timeLength or 1/60)
	end
end

function ShipStrengthView:ctor(...)
	_layMain = g_fnLoadUI("ui/ship_str.json")
	_tbTFDNum1 = {_layMain.TFD_HP_NUM,
					_layMain.TFD_WUGONG_NUM,
					_layMain.TFD_MOGONG_NUM,
					_layMain.TFD_WUFANG_NUM,
					_layMain.TFD_MOFANG_NUM
				}
	_tbtfd1 = {_layMain.img_info_bg1.tfd_hp,
				_layMain.img_info_bg1.tfd_wugong,
				_layMain.img_info_bg1.tfd_mogong,
				_layMain.img_info_bg1.tfd_wufang,
				_layMain.img_info_bg1.tfd_mofang,
				}
	_tbTFDNum2 = {_layMain.TFD_HP_NUM2,
					_layMain.TFD_WUGONG_NUM2,
					_layMain.TFD_MOGONG_NUM2,
					_layMain.TFD_WUFANG_NUM2,
					_layMain.TFD_MOFANG_NUM2
				}
	_tbtfd2 = {_layMain.img_info_bg2.tfd_hp,
				_layMain.img_info_bg2.tfd_wugong,
				_layMain.img_info_bg2.tfd_mogong,
				_layMain.img_info_bg2.tfd_wufang,
				_layMain.img_info_bg2.tfd_mofang,
				}
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function ShipStrengthView:addShieldLay(  )
	_layMain.BTN_STR:setTouchEnabled(false)
	_layMain.BTN_CLOSE:setTouchEnabled(false)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function ShipStrengthView:removeShieldLay(  )
	_layMain.BTN_STR:setTouchEnabled(true)
	_layMain.BTN_CLOSE:setTouchEnabled(true)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function ShipStrengthView:addStrengthAni( callBack )
	local m_arAni1 = UIHelper.createArmatureNode({
		imagePath = "images/effect/jinjie/jinjie10.png",
		plistPath = "images/effect/jinjie/jinjie10.plist",
		filePath = "images/effect/jinjie/jinjie1.ExportJson",
		animationName = "jinjie1",
		loop = 0,
		fnMovementCall = function ( sender, MovementEventType, movementID )
                if (MovementEventType == 1) then
                	sender:removeFromParentAndCleanup(true)
                    callBack()
                end
        end,
	})

	m_arAni1:setScale(g_fScaleX)

	if (_layMain.IMG_EFFECT:getChildByTag(_STRE_ANI_TAG)) then
		_layMain.IMG_EFFECT:getChildByTag(_STRE_ANI_TAG):removeFromParentAndCleanup(true)
	end
	_layMain.IMG_EFFECT:addNode(m_arAni1,99999,_STRE_ANI_TAG)
end

--[[desc:刷新界面
    arg1: 刷新需要的参数
    return: 无  
—]]
function ShipStrengthView:resetView( tbStrengthInfo )
	_layMain.TFD_LV1:setText(tbStrengthInfo.nowInfo.name .. "　LV." .. tostring(tbStrengthInfo.strengthLevel))
	_layMain.TFD_LV1:setColor(_gColor2[tbStrengthInfo.nowInfo.quality])
	UIHelper.labelNewStroke(_layMain.TFD_LV1, ccc3(0x28, 0x00, 0x00), 2)
	for i = 1,5 do
		_tbTFDNum1[i]:setText(tostring(tbStrengthInfo.nowInfo[i]))
		UIHelper.labelNewStroke(_tbTFDNum1[i], ccc3(0x45, 0x05, 0x05), 2)
		UIHelper.labelAddNewStroke(_tbtfd1[i], tbStrengthInfo.nowInfo.attrName[i], ccc3(0x45, 0x05, 0x05), 2)
	end

	-- 删除之前的图标，避免之后隐藏起来还会按到按钮
	local preButton = _layMain.lay_item_1:getChildByTag(_ICON_BTN_TAG)
	if (preButton) then
		preButton:removeFromParentAndCleanup(true)
	end

	-- 判断是否到达等级上限
	if not (tbStrengthInfo.isMax) then
		_layMain.TFD_LV2:setText(tbStrengthInfo.nextInfo.name .. "　LV." .. tostring(tbStrengthInfo.strengthLevel + 1))
		_layMain.TFD_LV2:setColor(_gColor2[tbStrengthInfo.nextInfo.quality])
		UIHelper.labelNewStroke(_layMain.TFD_LV2, ccc3(0x28, 0x00, 0x00), 2)

		for i = 1,5 do
			_tbTFDNum2[i]:setText(tostring(tbStrengthInfo.nextInfo[i]))
			UIHelper.labelNewStroke(_tbTFDNum2[i], ccc3(0x45, 0x05, 0x05), 2)
			UIHelper.labelAddNewStroke(_tbtfd2[i], tbStrengthInfo.nowInfo.attrName[i], ccc3(0x45, 0x05, 0x05), 2)
			local arrowWidget = _fnGetWidget(_layMain, "img_arrow"..tostring(i))
			arrowWidget:setVisible(tbStrengthInfo.nextInfo[i] > tbStrengthInfo.nowInfo[i])
		end
		-- 若有觉醒信息就显示觉醒信息
		if (tbStrengthInfo.nextInfo.awakeInfo) then
			_layMain.img_gift_bg:setVisible(true)
			_layMain.TFD_ACTIVATE_GIFT:setText(_i18n[1145])
			_layMain.TFD_GIFT_NAME:setText(tbStrengthInfo.nextInfo.awakeInfo.name)
			_layMain.TFD_GIFT_DESC:setText(tbStrengthInfo.nextInfo.awakeInfo.desc)
			UIHelper.labelNewStroke(_layMain.TFD_ACTIVATE_GIFT, ccc3(0x45, 0x05, 0x05), 2)
			UIHelper.labelNewStroke(_layMain.TFD_GIFT_NAME, ccc3(0x45, 0x05, 0x05), 2)
			UIHelper.labelNewStroke(_layMain.TFD_GIFT_DESC, ccc3(0x45, 0x05, 0x05), 2)
		else
			_layMain.img_gift_bg:setVisible(false)
		end

		-- 若配置需要的数量为0，不显示名字图标数量
		if (tbStrengthInfo.itemFree) then
			_layMain.lay_item_1:setVisible(false)
			_layMain.TFD_CONSUME_NAME:setVisible(false)
			_layMain.lay_item_num:setVisible(false)
		else
			_layMain.lay_item_1:setVisible(true)
			_layMain.TFD_CONSUME_NAME:setVisible(true)
			_layMain.lay_item_num:setVisible(true)

			_layMain.lay_item_1:addChild(tbStrengthInfo.strengthItemInfo.button, 1, _ICON_BTN_TAG)
			tbStrengthInfo.strengthItemInfo.button:setPosition(ccp(_layMain.lay_item_1:getContentSize().width/2, _layMain.lay_item_1:getContentSize().height/2))
			tbStrengthInfo.strengthItemInfo.button:setTouchEnabled(true)
			tbStrengthInfo.strengthItemInfo.button:addTouchEventListener(tbStrengthInfo.strengthItemInfo.fnIconBtn)
			
			_layMain.TFD_CONSUME_NAME:setText(tbStrengthInfo.strengthItemInfo.item.name)
			_layMain.TFD_CONSUME_NAME:setColor(_gColor[tbStrengthInfo.strengthItemInfo.item.quality])
			_layMain.TFD_NUM_LEFT:setText(tostring(tbStrengthInfo.strengthItemInfo.itemHaveNum))
			_layMain.TFD_NUM_RIGHT:setText(tostring(tbStrengthInfo.strengthItemInfo.itemNeedNum))
		end

		-- 若强化不需要贝里则不现实贝里图标和数字
		if (tbStrengthInfo.bellyFree) then
			_layMain.img_belly:setVisible(false)
			_layMain.TFD_BELLY_NUM:setVisible(false)
		else
			_layMain.img_belly:setVisible(true)
			_layMain.TFD_BELLY_NUM:setVisible(true)
			_layMain.TFD_BELLY_NUM:setText(tostring(tbStrengthInfo.strengthItemInfo.belly))
		end
		-- 判断物品数量是否满足要求
		if (tbStrengthInfo.isEnough) then
			_layMain.TFD_NUM_LEFT:setColor(ccc3(0x00, 0x8a, 0x00))
			_layMain.BTN_STR:setTouchEnabled(true)
			_layMain.BTN_STR:setGray(false)
		else
			_layMain.TFD_NUM_LEFT:setColor(ccc3(0xd8, 0x14, 0x00))
			_layMain.BTN_STR:setGray(true)
		end
	else
		_layMain.lay_item_1:setVisible(false)
		_layMain.img_belly:setVisible(false)
		_layMain.TFD_BELLY_NUM:setVisible(false)
		_layMain.TFD_CONSUME_NAME:setVisible(false)
		_layMain.lay_item_num:setVisible(false)
		_layMain.img_info_bg2:setVisible(false)
		_layMain.img_arrow_main:setVisible(false)
		_layMain.BTN_STR:setGray(true)
	end

	_layMain.BTN_STR:addTouchEventListener(tbStrengthInfo.fnStrBtn)
end

function ShipStrengthView:create( tbInfo )
	_layMain.IMG_SKY:setScaleX(g_fScaleX)
	_layMain.IMG_SKY:setScaleY(g_fScaleY)

	local imgShip = _layMain.img_ship
	local tbShipPos = ccp(imgShip:getPositionX(),imgShip:getPositionY())
	local tbShipAnchor = ccp(imgShip:getAnchorPoint().x,imgShip:getAnchorPoint().y)
	-- 设置tag为512方便之后删除
	UIHelper.addShipAnimation(_layMain.LAY_NOSCV, ShipStrengthModel.getShipAniNumber(), tbShipPos, tbShipAnchor, nil, _SHIP_ANI_TAG, _WATER_ANI_TAG)
	imgShip:setVisible(false)
	-- 刷新信息面板和材料面板的信息

	-- 背景运动的计时器
	local fnRemoveSchedule

	UIHelper.registExitAndEnterCall(_layMain, 
		function ()
			fnRemoveSchedule()
		end, function ()
			fnRemoveSchedule = GlobalScheduler.scheduleFunc( ShipMainCtrl.getBgUpdateFun( _layMain ), 0 )
		end)

	_layMain.BTN_CLOSE:addTouchEventListener(tbInfo.fnCloseBtn)
	return _layMain
end

