-- FileName: AwakeDecomposeView.lua
-- Author: LvNanchun
-- Date: 2015-11-19
-- Purpose: 觉醒物品分解界面提示框
--[[TODO List]]

AwakeDecomposeView = class("AwakeDecomposeView")

-- UI variable --

-- module local variable --
local _i18n = gi18n

function AwakeDecomposeView:moduleName()
    return "AwakeDecomposeView"
end

function AwakeDecomposeView:ctor(...)
	self._layMain = g_fnLoadUI("ui/awake_equip_decompose.json")
	-- 初始化一些控件的值
	self._layMain.tfd_can:setText(_i18n[7415] .. ":")
	self._layMain.tfd_awake:setText(_i18n[7416] .. ":")
end

--[[desc:设置中央的数字的值
    arg1: 数字
    return: 无  
—]]
function AwakeDecomposeView:setDisplayNum( num )
	self._layMain.TFD_CHOOSE_NUM:setText(tostring(num or 0))
end

--[[desc:设置下方结晶数量
    arg1: 数量
    return: 无
—]]
function AwakeDecomposeView:setCoinNum( num )
	self._layMain.TFD_AWAKE_COIN_NUM:setText(tostring(num or 0))
end

function AwakeDecomposeView:create( tbBtn, tbInfo )
	-- 装备名字设置
	self._layMain.TFD_NAME:setText(tbInfo.name)
	self._layMain.TFD_NAME:setColor(tbInfo.color)
	-- 可回收个数
	self._layMain.TFD_PLAYER_CHOOSE_BUY_NUM:setText(tostring(tbInfo.num) .. _i18n[1422])
	-- 物品图标
	local itemIcon = ItemUtil.createBtnByTemplateId(tbInfo.tid, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			-- 点击icon打开信息面板
			AwakeItemInfoCtrl.create( tbInfo.tid, "bag" )
		end
	end)
	self._layMain.LAY_ICON:addChild(itemIcon)
	itemIcon:setPosition(ccp(self._layMain.LAY_ICON:getSize().width/2, self._layMain.LAY_ICON:getSize().height/2))


	-- 绑定按钮事件
	-- 关闭按钮
	self._layMain.BTN_CLOSE:addTouchEventListener(tbBtn.close)
	-- 确认按钮
	self._layMain.BTN_DECOMPOSE:addTouchEventListener(tbBtn.sure)
	-- 减号
	self._layMain.BTN_REDUCE:addTouchEventListener(tbBtn.sub)
	-- 减10
	self._layMain.BTN_REDUCE_TEN:addTouchEventListener(tbBtn.subTen)
	-- 加号
	self._layMain.BTN_ADD:addTouchEventListener(tbBtn.add)
	-- 加10
	self._layMain.BTN_ADD_TEN:addTouchEventListener(tbBtn.addTen)

	-- 加进入离开通知接收到回调刷新背包
	UIHelper.registExitAndEnterCall(self._layMain, function ( )		
		GlobalNotify.removeObserver( GlobalNotify.BAG_PUSH_CALL, "AWAKE_BAG")
    end , function ( )
    	GlobalNotify.addObserver(GlobalNotify.BAG_PUSH_CALL, tbInfo.fnRefresh, nil, "AWAKE_BAG" )
    end)

	return self._layMain
end

