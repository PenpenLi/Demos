-- FileName: WABattleLoseView.lua
-- Author: Xufei
-- Date: 2015-02-19
-- Purpose: function description of module
--[[TODO List]]

WABattleLoseView = class("WABattleLoseView")

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n

function WABattleLoseView:init(...)
	self.layMain = nil
	self.resultInfo = {}
end

function WABattleLoseView:destroy(...)
	package.loaded["WABattleLoseView"] = nil
end

function WABattleLoseView:moduleName()
    return "WABattleLoseView"
end

function WABattleLoseView:ctor(...)
	self:init()
	self.layMain = g_fnLoadUI("ui/fight_lose.json")
end

function WABattleLoseView:showAni( ... )
	EffBattleLose:new(self.layMain,self.layMain.IMG_TITLE)

	local aniFade = UIHelper.createArmatureNode({
		filePath = "images/effect/worldboss/fadein_close.ExportJson",
		animationName = "fadein_close",
		loop = 1,
	})
	self.layMain.IMG_FADEIN_EFFECT:addNode(aniFade)
end

function WABattleLoseView:showLoseView( ... )
	self.layMain.TFD_NAME1:setText("S."..self.resultInfo.myInfo.server_id
		.." "..self.resultInfo.myInfo.uname)
	self.layMain.TFD_NAME2:setText("S."..self.resultInfo.opInfo.server_id
		.." "..self.resultInfo.opInfo.uname)
	self.layMain.LABN_FIGHT1:setStringValue(self.resultInfo.myInfo.fight_force)
	self.layMain.LABN_FIGHT2:setStringValue(self.resultInfo.opInfo.fight_force)

	self.layMain.tfd_rank_desc:setText("排名降至最后一名")
	self.layMain.tfd_kill_num:setText(self.contiKill)

	self.layMain.LAY_GAIN:setVisible(false)
	self.layMain.img_gain_bg1:setVisible(false)

	if (self.isPassFight == 1) then
		self.layMain.BTN_REPLAY:loadTexturePressed("images/button/orange_2_n.png")
		self.layMain.BTN_REPLAY:setGray(self.isPassFight == 1)
		self.layMain.BTN_REPLAY:addTouchEventListener(function ( sender, eventType ) 
		end)

		self.layMain.BTN_DATA:setTouchEnabled(false)
		self.layMain.BTN_DATA:setVisible(false)
	end
end

function WABattleLoseView:create( tbArgs, isPassFight )
	logger:debug({opponentInfo_lose = opponent})
	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			self.layMain = nil
			self.resultInfo = {}
		end,
		function()
		end
	)

	self.isPassFight = isPassFight
	self.resultInfo.myInfo = tbArgs.myPlayer
	self.resultInfo.opInfo = tbArgs.oppoPlayer
	self.contiKill = tbArgs.preContiKill

	self.layMain.LAY_MAIN:setTouchEnabled(true)
	self.layMain.LAY_DESC:addTouchEventListener(WABattleLoseCtrl.getBtnFunByName("onClose"))
	self.layMain.LAY_MAIN:addTouchEventListener(WABattleLoseCtrl.getBtnFunByName("onClose"))

	self.layMain.BTN_FORMATION:addTouchEventListener(WABattleLoseCtrl.getBtnFunByName("onFormation"))
	self.layMain.BTN_REPLAY:addTouchEventListener(WABattleLoseCtrl.getBtnFunByName("onReplay"))
	self.layMain.BTN_DATA:addTouchEventListener(WABattleLoseCtrl.getBtnFunByName("onSeeData"))

	UIHelper.labelNewStroke( self.layMain.TFD_DESC, ccc3(0x49, 0x00, 0x00), 3 )
	UIHelper.labelNewStroke( self.layMain.TFD_NAME1 )
	UIHelper.labelNewStroke( self.layMain.TFD_NAME2 )
	UIHelper.titleShadow( self.layMain.BTN_REPLAY )
	UIHelper.titleShadow( self.layMain.BTN_FORMATION )

	self:showLoseView()
	self:showAni()
	return self.layMain
end
