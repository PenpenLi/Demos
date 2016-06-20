-- FileName: WABattleWinView.lua
-- Author: Xufei
-- Date: 2015-02-19
-- Purpose: function description of module
--[[TODO List]]

WABattleWinView = class("WABattleWinView")

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n

function WABattleWinView:init(...)
	self.layMain = nil
	self.resultInfo = {}
end

function WABattleWinView:destroy(...)
	package.loaded["WABattleWinView"] = nil
end

function WABattleWinView:moduleName()
    return "WABattleWinView"
end

function WABattleWinView:ctor(...)
	self:init()
	self.layMain = g_fnLoadUI("ui/fight_win.json")
end

function WABattleWinView:setReward( ... )
	local configData = WorldArenaModel.getworldArenaConfig()
	local fightReward = RewardUtil.getItemsDataByStr(configData.fight_reward)
	local streakReward = lua_string_split(configData.streak_reward, ";")
	local contiKill = self.contiKill
	local contiReward = {}
	for k,v in ipairs(streakReward) do
		local indexContiNum = lua_string_split(v, ",")[1]
		if ((tonumber(contiKill)<=tonumber(indexContiNum)) or (tonumber(k) == #streakReward)) then
			local firstCommaPos = string.find(v, ",")
			if (firstCommaPos) then
				local strReward = string.sub(v, firstCommaPos+1,-1)
				contiReward = RewardUtil.getItemsDataByStr(strReward)
			end
			break
		end
	end

	logger:debug({fight_reward_print = fightReward,
			streak_reward_print = contiReward})
	local bellyRewardNum = 0
	for k,v in ipairs(fightReward) do
		if (v.type == "silver") then
			bellyRewardNum = bellyRewardNum+tonumber(v.num) 
		end
	end
	for k,v in ipairs(contiReward) do
		if (v.type == "silver") then
			bellyRewardNum = bellyRewardNum+tonumber(v.num) 
		end
	end
	logger:debug({print_reward_belly_num = bellyRewardNum})
	self.layMain.TFD_MONEY:setText(bellyRewardNum)
	UserModel.addSilverNumber(bellyRewardNum)
end

function WABattleWinView:showAni( ... )
	EffBattleWin:new({imgTitle = self.layMain.IMG_TITLE, imgRainBow = self.layMain.IMG_RAINBOW , callback=function ( ... )
		palyBattleVsEffect(self.layMain.img_vsvg,self.layMain.img_vsvg.img_vs,function()
			palyPropertyEffect({self.layMain.img_gain_bg1},function()
				
			end)
		end)
	end})

	local aniFade = UIHelper.createArmatureNode({
		filePath = "images/effect/worldboss/fadein_close.ExportJson",
		animationName = "fadein_close",
		loop = 1,
	})
	self.layMain.IMG_FADEIN_EFFECT:addNode(aniFade)
end

function WABattleWinView:showWinView( ... )
	self.layMain.TFD_NAME1:setText("S."..self.resultInfo.myInfo.server_id
		.." "..self.resultInfo.myInfo.uname)
	self.layMain.TFD_NAME2:setText("S."..self.resultInfo.opInfo.server_id
		.." "..self.resultInfo.opInfo.uname)
	self.layMain.LABN_FIGHT1:setStringValue(self.resultInfo.myInfo.fight_force)
	self.layMain.LABN_FIGHT2:setStringValue(self.resultInfo.opInfo.fight_force)

	self.layMain.img_vsvg:setVisible(false)
	self.layMain.img_gain_bg1:setVisible(false)

	self.layMain.img_exp:setVisible(false)
	self.layMain.TFD_EXP:setVisible(false)

	self.upgradeNum = tonumber(self.resultInfo.myInfo.rank)-tonumber(self.resultInfo.opInfo.rank)
	if (self.upgradeNum<0) then
		logger:debug({upgradeNum = self.upgradeNum})
		self.upgradeNum = 0
		self.layMain.tfd_rankup_num:setText(self.upgradeNum)
		self.layMain.tfd_rank_num:setText(tonumber(self.resultInfo.myInfo.rank))
	else
		logger:debug({upgradeNum = self.upgradeNum})
		self.layMain.tfd_rankup_num:setText(self.upgradeNum)
		self.layMain.tfd_rank_num:setText(tonumber(self.resultInfo.opInfo.rank))
	end
	self.layMain.tfd_kill_num:setText(self.contiKill)	

	if (self.isPassFight == 1) then
		self.layMain.BTN_REPLAY:loadTexturePressed("images/button/orange_2_n.png")
		self.layMain.BTN_REPLAY:setGray(self.isPassFight == 1)
		self.layMain.BTN_REPLAY:addTouchEventListener(function ( sender, eventType ) 
		end)

		self.layMain.BTN_DATA:setTouchEnabled(false)
		self.layMain.BTN_DATA:setVisible(false)
	end
end

function WABattleWinView:create( tbArgs, isPassFight )
	logger:debug({tbArgs_win_wabattle = tbArgs})
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
	self.reward = tbArgs.reward
	logger:debug({print_rewrad_table = self.reward})
	self.contiKill = tbArgs.contiKill

	self.layMain.LAY_MAIN:setTouchEnabled(true)
	self.layMain.LAY_DESC:addTouchEventListener(WABattleWinCtrl.getBtnFunByName("onClose"))
	self.layMain.LAY_MAIN:addTouchEventListener(WABattleWinCtrl.getBtnFunByName("onClose"))

	self.layMain.BTN_FORMATION:addTouchEventListener(WABattleWinCtrl.getBtnFunByName("onFormation"))
	self.layMain.BTN_REPLAY:addTouchEventListener(WABattleWinCtrl.getBtnFunByName("onReplay"))
	self.layMain.BTN_DATA:addTouchEventListener(WABattleWinCtrl.getBtnFunByName("onSeeData"))

	UIHelper.labelNewStroke( self.layMain.TFD_DESC, ccc3(0x49, 0x00, 0x00), 3 )
	UIHelper.labelNewStroke( self.layMain.TFD_NAME1 )
	UIHelper.labelNewStroke( self.layMain.TFD_NAME2 )
	UIHelper.titleShadow( self.layMain.BTN_REPLAY )
	UIHelper.titleShadow( self.layMain.BTN_FORMATION )

	self:setReward()
	self:showWinView()	
	self:showAni()
	return self.layMain
end
