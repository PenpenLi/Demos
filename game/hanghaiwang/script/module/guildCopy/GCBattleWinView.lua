-- FileName: GCBattleWinView.lua
-- Author: liweidong
-- Date: 2015-06-11
-- Purpose: 战斗胜利结算面板
--[[TODO List]]

module("GCBattleWinView", package.seeall)

-- UI控件引用变量 --
local _layoutMain
-- 模块局部变量 --
local _copyId = nil
local _baseId = nil
local _baseItemInfo = nil --据点信息
local _battleData = nil --战斗结果返回信息
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCBattleWinView"] = nil
end

function moduleName()
    return "GCBattleWinView"
end

function setUIStyleAndI18n(base)
	base.tfd_reward_title:setText(m_i18n[5949])
	base.LAY_UNION_COPY.tfd_attack:setText(m_i18n[5950])
	base.LAY_UNION_COPY.tfd_belly:setText(m_i18n[1373])
	base.LAY_UNION_COPY.tfd_exp:setText(m_i18n[1053])
	base.LAY_UNION_COPY.tfd_contribution:setText(m_i18n[5951])
	base.LAY_UNION_COPY.tfd_kill:setText(m_i18n[5952])

	UIHelper.labelNewStroke(base.tfd_reward_title, ccc3(0x49, 0x00, 0x00), 3)
end
function initUI()
	_layoutMain = g_fnLoadUI("ui/attack_win.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				AudioHelper.resetAudioState() 
				_layoutMain=nil
			end,
			function()
			end
		) 

	setUIStyleAndI18n(_layoutMain)
	_layoutMain.LAY_BOSS:setVisible(false)
	-- _layoutMain.TFD_NAME:setText(_baseItemInfo.name)
	local exp = _baseItemInfo.exp_simple*UserModel.getHeroLevel()
	local userLevel = UserModel.getUserInfo().level
	local maxUserLevel = UserModel.getUserMaxLevel()
	if(tonumber(userLevel) >= maxUserLevel) then
		exp = 0
	end
	_layoutMain.LAY_UNION_COPY.TFD_EXP_NUM:setText(exp)
	_layoutMain.LAY_UNION_COPY.TFD_BELLY_NUM:setText(_baseItemInfo.coin_simple)
	_layoutMain.LAY_UNION_COPY.TFD_ATTACK_NUM:setText(_battleData.hpDmg) --伤害值
	local state = GCItemModel.getStrongHoldStatus(_copyId,_baseId)
	_layoutMain.LAY_UNION_COPY.TFD_PROGRESS:setText(state.."%")
	_layoutMain.LAY_UNION_COPY.LOAD_PROGRESS:setPercent(state)
	_layoutMain.LAY_UNION_COPY.TFD_CONTRIBUTION_NUM:setText(_baseItemInfo.reward_vital)
	_layoutMain.LAY_UNION_COPY.TFD_KILL_NUM:setText(_baseItemInfo.kill_vital)
	-- _layoutMain.LAY_UNION_COPY.TFD_ZHANDOULI_NUM:setText(UserModel.getFightForceValue())
	
	
	if (not(_battleData.kill=="true")) then
		_layoutMain.LAY_UNION_COPY.TFD_KILL_NUM:setVisible(false)
		_layoutMain.LAY_UNION_COPY.tfd_kill:setVisible(false)
	end
	_layoutMain:setTouchEnabled(true)
	_layoutMain:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				GCBattleMonsterCtrl.onResultContinue()
			end
		end)
	--特效
	-- 背景光特效
	local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/new_rainbow.ExportJson",
			animationName = "new_rainbow",
			loop = 1,
		})
	armature:setPosition(ccp(_layoutMain.img_effect:getSize().width/2, _layoutMain.img_effect:getSize().height/2))
	_layoutMain.img_effect:addNode(armature, 1)

	-- 触摸文字特效
	local rewardData = _battleData.guildReward or {}
	local armName = "fadein_close"
	if (table.count(rewardData)>=1) then
		armName = "fadein_continue"
	end
	local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/" ..armName .. ".ExportJson",
			animationName = armName,
			loop = 1,
		})
	-- armature2:setAnchorPoint(ccp(layRoot.IMG_EFFECT_TIP:getAnchorPoint().x, layRoot.IMG_EFFECT_TIP:getAnchorPoint().y))
	armature2:setPosition(ccp(_layoutMain.IMG_EFFECT_TIP:getSize().width/2 , _layoutMain.IMG_EFFECT_TIP:getSize().height/2))
	_layoutMain.IMG_EFFECT_TIP:addNode(armature2)


	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.1))
	actions:addObject(CCCallFuncN:create(function ( ... )
		local armature3 = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fight_end.ExportJson",
			animationName = "fight_end",
		})
		armature3:setAnchorPoint(ccp(0.5, 0.5))
		armature3:setPosition(ccp(_layoutMain.img_title:getSize().width/2 , _layoutMain.img_title:getSize().height/2))
		_layoutMain.img_title:addNode(armature3, 10)
	end))
	_layoutMain:runAction(CCSequence:create(actions))

	--发送战报
	_layoutMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playSendReport()
				local modName,baseName
				local baseDb = DB_Stronghold.getDataById(_baseId)
				local copyDb=DB_Legion_newcopy.getDataById(_copyId)
				modName = m_i18n[7810] .. copyDb.name --"日常副本"
				baseName = baseDb.name
				UIHelper.sendBattleReport(BattleState.getBattleBrid(),modName,baseName)
			end)

	return _layoutMain
end
function create(copyId,baseId,data)
	_battleData = data
	_baseId=baseId
	_copyId=copyId
	_baseItemInfo = DB_Stronghold.getDataById(_baseId)
	return initUI()
end


