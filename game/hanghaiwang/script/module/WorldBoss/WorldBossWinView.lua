-- FileName: WorldBossWinView.lua
-- Author: wangming
-- Date: 2015-02-04
-- Purpose: 世界Boss胜利面板
--[[TODO List]]

-- module("WorldBossWinView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_worldBossModel = WorldBossModel
WorldBossWinView = class("WorldBossWinView")

function WorldBossWinView:ctor()
	self.layMain = g_fnLoadUI("ui/world_boss_win.json")
end

function WorldBossWinView:create()
	local layRoot = self.layMain
	local dbBoss = m_worldBossModel.getActvieBossDb()
	local bossInfo = m_worldBossModel.getBossOverInfo()
	--bossInfo = getTestData_bossInfo()
	logger:debug({dbBoss = dbBoss})
	logger:debug({bossInfo = bossInfo})

	local tfd_kill = m_fnGetWidget(layRoot, "tfd_kill") -- 已被击杀
	tfd_kill:setText(m_i18n[6026] .. dbBoss.name .. m_i18n[6029])
	local tfd_not_kill = m_fnGetWidget(layRoot, "tfd_not_kill") -- 未被击杀
	tfd_not_kill:setText(m_i18n[6026] .. dbBoss.name .. m_i18n[6030])
	local pBool = (tonumber(bossInfo.boss_dead) == 1)
	tfd_kill:setVisible(pBool)
	tfd_not_kill:setVisible(not pBool)

	local tfd_killer = m_fnGetWidget(layRoot, "tfd_killer") -- 击杀者
	tfd_killer:setText(m_i18n[6031])
	local TFD_KILLER_NAME = m_fnGetWidget(layRoot, "TFD_KILLER_NAME") -- 击杀者名字
	local pname = bossInfo.uname == "" and m_i18n[1093] or bossInfo.uname
	TFD_KILLER_NAME:setText(pname or m_i18n[1093])

	local tfd_info = m_fnGetWidget(layRoot, "tfd_info") -- 您的战况
	UIHelper.labelNewStroke(tfd_info, ccc3(0x49, 0x00, 0x00), 3)
	tfd_info:setText(m_i18n[6032])
	local tfd_dps = m_fnGetWidget(layRoot, "tfd_dps") -- 总伤害
	tfd_dps:setText(m_i18n[6015])
	local TFD_DPS_NUM = m_fnGetWidget(layRoot, "TFD_DPS_NUM") -- 总伤害
	TFD_DPS_NUM:setText(bossInfo.attack_hp)
	
	local tfd_rank = m_fnGetWidget(layRoot, "tfd_rank") -- 排名
	tfd_rank:setText(gi18nString(6016, " "))
	local TFD_RANK_NUM = m_fnGetWidget(layRoot, "TFD_RANK_NUM") -- 排名
	local pNum = tonumber(bossInfo.rank) or m_i18n[1093]
	pNum = pNum == 0 and m_i18n[1093] or pNum
	TFD_RANK_NUM:setText(tostring(pNum))

	local tfd_reward = m_fnGetWidget(layRoot, "tfd_reward") -- 获得奖励
	UIHelper.labelNewStroke(tfd_reward, ccc3(0x49, 0x00, 0x00), 3)
	tfd_reward:setText(m_i18n[3739])
	local tfd_belly = m_fnGetWidget(layRoot, "tfd_belly") -- 贝利
	tfd_belly:setText(m_i18n[1520])
	local tfd_prestige = m_fnGetWidget(layRoot, "tfd_prestige") -- 声望
	tfd_prestige:setText(m_i18n[1921])
	local TFD_BELLY_NUM = m_fnGetWidget(layRoot, "TFD_BELLY_NUM") -- 贝利数
	local TFD_PRESTIGE_NUM = m_fnGetWidget(layRoot, "TFD_PRESTIGE_NUM") -- 声望数

	local pBellyNum = 0
	local pPrestigeNum = 0

	local pkills = nil
	local pRanks = nil
	
	if(not table.isEmpty(bossInfo.reward_rank)) then
		local pTable = {}
		for k,v in pairs(bossInfo.reward_rank) do
			local data = {type = v[1],id = v[2],num = v[3]}
			table.insert(pTable,data)
		end
		pRanks = RewardUtil.getItemsDataByTb(pTable)
	else
		pRanks = {}
	end
	if(not table.isEmpty(bossInfo.reward_kill)) then
		local pTable = {}
		for k,v in pairs(bossInfo.reward_kill) do
			local data = {type = v[1],id = v[2],num = v[3]}
			table.insert(pTable,data)
		end
		pkills = RewardUtil.getItemsDataByTb(pTable)
	end
	logger:debug({pRanks = pRanks})
	logger:debug({pkills = pkills})
	for k,v in pairs(pkills or {}) do
		local pHave = false
		for key,value in pairs(pRanks) do
			if (tonumber(v.tid) == 0) then
				if (v.type == value.type) then
					pRanks[k].num = pRanks[k].num + v.num
					pHave = true
				end
			elseif(v.tid == value.tid) then
				pRanks[k].num = pRanks[k].num + v.num
				pHave = true
			end
		end
		if(not pHave) then
			table.insert(pRanks , pkills[k])
		end
	end
	logger:debug({pRanks = pRanks})
	--pRanks = getTestData_rankInfo()
	for k,v in pairs(pRanks or {}) do
		if(v.type == "silver") then
			pBellyNum = pBellyNum + v.num
		end
		if(v.type == "prestige") then
			pPrestigeNum = pPrestigeNum + v.num
		end
	end

	-- 有、无奖励的两种判断
	local isHaveReward = false
	local callback = nil
	if (pRanks ~= nil and table.isEmpty(pRanks) == false) then
		isHaveReward = true
		callback = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
				local tbItems = RewardUtil.parseRewardsByTb(pRanks)
				require "script/module/WorldBoss/WorldBossRewardView"
				LayerManager.addLayoutNoScale(WorldBossRewardView.create(tbItems))
			end
		end
	else
		callback = MainWorldBossCtrl.fnCloseBossWin
	end
	layRoot.img_fadein_close:setVisible(false)
	layRoot.img_fadein_next:setVisible(false)

	-- 点击任意
	layRoot.LAY_MAIN:setTouchEnabled(true)
	layRoot.LAY_MAIN:addTouchEventListener(callback)
	
	-- 奖励数值
	TFD_BELLY_NUM:setText(pBellyNum)
	TFD_PRESTIGE_NUM:setText(pPrestigeNum)

	-- 背景光特效
	layRoot.img_effect:setVisible(false)
	local armature = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("new_rainbow.ExportJson"),
			animationName = "new_rainbow",
			loop = 1,
		})
	armature:setPosition(ccp(layRoot.img_effect:getPositionX(), layRoot.img_effect:getPositionY()))
	layRoot.LAY_MAIN:addNode(armature, 1)

	-- 触摸文字特效
	local tFiles
	if (isHaveReward) then
		tFiles = {
			file = WorldBossModel.getEffectPath("fadein_continue.ExportJson"), 
			aniName = "fadein_continue",
		}
	else
		tFiles = {
			file = WorldBossModel.getEffectPath("fadein_close.ExportJson"), 
			aniName = "fadein_close",
		}
	end
	local armature2 = UIHelper.createArmatureNode({
			filePath = tFiles.file,
			animationName = tFiles.aniName,
			loop = 1,
		})
	armature2:setAnchorPoint(ccp(layRoot.img_fadein_close:getAnchorPoint().x, layRoot.img_fadein_close:getAnchorPoint().y))
	armature2:setPosition(ccp(layRoot.img_fadein_close:getPositionX(), layRoot.img_fadein_close:getPositionY()))
	layRoot:addNode(armature2)
	-- 闪烁动作
	-- local action = WorldBossModel.getBlinkAction()
	-- armature2:runAction(action)

	-- 战斗结束特效
	layRoot.img_title:setVisible(false)
	local actions = CCArray:create()
	actions:addObject(CCDelayTime:create(0.1))
	actions:addObject(CCCallFuncN:create(function ( ... )
		local armature3 = UIHelper.createArmatureNode({
			filePath = WorldBossModel.getEffectPath("boss_reward.ExportJson"),
			animationName = "boss_reward",
		})
		armature3:setAnchorPoint(ccp(0.5, 0.5))
		armature3:setPosition(ccp(layRoot.img_title:getPositionX(), layRoot.img_title:getPositionY() + layRoot.img_title:getContentSize().height/2))
		layRoot.LAY_MAIN.IMG_title_bg:addNode(armature3, 10)
	end))
	layRoot:runAction(CCSequence:create(actions))

	-- local LSV_MAIN = m_fnGetWidget(layRoot, "LSV_MAIN") -- 物品列表
	-- local lay_item = m_fnGetWidget(layRoot, "TFD_BELLY_NUM") -- 获得物品

	-- for k,v in pairs(pRanks) do
	-- 	if(v.type == "silver" or v.type == "prestige") then
	-- 		pRanks[k] = {}
	-- 	end
	-- end
	-- require "script/module/public/RewardUtil"
	-- local tbItems = RewardUtil.parseRewardsByTb(pRanks)
	-- if (not table.isEmpty(tbItems)) then
	-- 	local nIdx, cell = -1, nil
	-- 	LSV_MAIN:setTouchEnabled(true)
	-- 	for k, good in ipairs(tbItems) do
	-- 		LSV_MAIN:pushBackDefaultItem()
	-- 		nIdx = nIdx + 1
	-- 		cell = LSV_MAIN:getItem(nIdx)  -- cell 索引从 0 开始

	-- 		local imgGood = m_fnGetWidget(cell, "img_item")
	-- 		imgGood:addChild(good.icon)

	-- 		local labName = m_fnGetWidget(cell, "TFD_ITEM_NAME")
	-- 		labName:setText(good.name)
	-- 		labName:setColor(g_QulityColor2[good.quality])
	-- 	end
	-- else
	-- 	LSV_MAIN:setVisible(false)
	-- end

	m_worldBossModel.setBossOverInfo(nil)

	AudioHelper.playEffect("audio/effect/texiao_shengliwindow.mp3")
	
	return self.layMain
end
