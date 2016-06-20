-- FileName: AwakeLoseView.lua
-- Author: LvNanchun
-- Date: 2015-11-17
-- Purpose: function description of module
--[[TODO List]]

AwakeLoseView = class("AwakeLoseView")

-- UI variable --

-- module local variable --
local _fnGetWidget = g_fnGetWidgetByName

function AwakeLoseView:moduleName()
    return "AwakeLoseView"
end

function AwakeLoseView:ctor(...)
	self._layMain = g_fnLoadUI("ui/dcopy_lose.json")
	-- 初始化一些控件的值
	self._layMain.TFD_TODO_TITLE:setText("提高战力")
	self._layMain.TFD_INFO:setText("您可通过以下路径提高战力：")
	self._layMain.TFD_ZHANDOULI_TXT:setText("当前战斗力：")
	self._layMain.TFD_ZHANDOULI_NUM:setText("0")

	-- 控制格式
	UIHelper.labelNewStroke( self._layMain.TFD_NAME, ccc3(0x00,0x00,0x00), 3 )
end

function AwakeLoseView:create( tbBtn, tbInfo )
	-- 据点名字
	self._layMain.TFD_NAME:setText(tostring(tbInfo.strongHoldName))
	-- 战斗力
	self._layMain.TFD_ZHANDOULI_NUM:setText(tostring(tbInfo.fightNum))
	-- 根据获取的星数设置星星亮
	for i = 1, 3 do
		local imgStar = _fnGetWidget(self._layMain.LAY_HARD3, "IMG_STAR3_" .. tostring(i))
		if (i > tbInfo.starNum) then
			imgStar:loadTexture("ui/star_big_ash.png")
		else
			imgStar:loadTexture("ui/star_big_win.png")
		end
	end

	EffBattleLose:new(self._layMain,self._layMain.IMG_TITLE_EFFECT)

	-- 装备强化
	self._layMain.BTN_ZHUANGBEI:addTouchEventListener(tbBtn.equip)
	-- 伙伴强化
	self._layMain.BTN_WUJIANG:addTouchEventListener(tbBtn.strength)
	-- 调整阵容
	self._layMain.BTN_MINGJIANG:addTouchEventListener(tbBtn.formation)
	-- 发送战报
	self._layMain.BTN_SET_REPORT:addTouchEventListener(tbBtn.onSendReport)
	-- 查看攻略
	self._layMain.BTN_REPORT:addTouchEventListener(tbBtn.onStrategy)

	self._layMain.LAY_MAIN:setTouchEnabled(true)
	-- 关闭
	self._layMain.LAY_MAIN:addTouchEventListener(tbBtn.close)
	-- 闪光的关闭界面提示
	local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_close.ExportJson",
			animationName = "fadein_close",
			loop = 1,
		})
	self._layMain.IMG_FADEIN_EFFECT:addNode(armature)

	UIHelper.registExitAndEnterCall( self._layMain,tbBtn.onExitCall,tbBtn.onEnterCall)

	return self._layMain
end

