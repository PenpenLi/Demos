-- FileName: GCBattleMonsterCtrl.lua
-- Author: liweidong
-- Date: 2014-06-08
-- Purpose: 开始挑战ctrl
--[[TODO List]]

module("GCBattleMonsterCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _copyId = nil
local _baseId = nil
local _battleResultData = nil
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCBattleMonsterCtrl"] = nil
end

function moduleName()
    return "GCBattleMonsterCtrl"
end

function create(copyId,baseId)
	require "script/module/guildCopy/GCBattleMonsterView"
	return GCBattleMonsterView.create(copyId,baseId)
end
--战斗模块回调方法
function onBattleResult(data)
	return battleWin(_copyId,_baseId,data)
end
--应用程序行为  进入结算面板
function battleWin(copyId,baseId,data)
	GCItemModel.subBattleTimes()
	local baseItemInfo = DB_Stronghold.getDataById(_baseId)
	UserModel.addSilverNumber(baseItemInfo.coin_simple) --贝利
	UserModel.addEnergyValue(-1*tonumber(baseItemInfo.cost_energy_simple)) -- 减少体力
	--增加贡献度
	GuildDataModel.addSigleDonate(baseItemInfo.reward_vital) --攻打贡献度
	if (_battleResultData.kill=="true") then
		GuildDataModel.addSigleDonate(baseItemInfo.kill_vital) --击杀贡献度
	end
	local nAddExp = baseItemInfo.exp_simple*UserModel.getHeroLevel()
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local nNewExpNum = (nExpNum + nAddExp)%nLevelUpExp -- 得到当前显示的经验值分子
	local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp -- 获得经验后是否升级

	UserModel.addExpValue(nAddExp,"dobattle")
	require "script/module/guildCopy/GCBattleWinView"
	local winLayout = GCBattleWinView.create(copyId,baseId,_battleResultData)

	if (bLvUp) then
		performWithDelay(winLayout,function()
					require "script/module/public/GlobalNotify"
					GlobalNotify.postNotify(GlobalNotify.LEVEL_UP)
				end,
				0.01)
	end
	return winLayout
end
--点击战斗按钮
function onBattle(copyId,baseId)
	_copyId = copyId
	_baseId = baseId
	AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
	-- 检查背包是否已满 
	if (ItemUtil.isBagFull(true)) then
		return
	end
	local tbUserInfo = UserModel.getUserInfo()
	local baseItemInfo = DB_Stronghold.getDataById(baseId)
	-- 检查体力是否足够
	if (tonumber(tbUserInfo.execution) < tonumber(baseItemInfo.cost_energy_simple)) then
		require "script/module/copy/copyUsePills"
		LayerManager.addLayout(copyUsePills.create())
		return
	end
	local battleNetCallback = function(cbFlag, dictData, bRet)
		logger:debug(cbFlag)
		logger:debug(dictData)
		logger:debug(bRet)

		if (bRet) then
			LayerManager.removeLayout()
			local data = dictData.ret
			_battleResultData = data
			local guildCopyInfo = DataCache.getGuildCopyData()
			guildCopyInfo["".._copyId]=data.gcInfo
			if (data.res=="ok") then
				require "script/battle/BattleModule"
				BattleModule.playGuideCopyBattle(_baseId,1,data.fightStr,function() end,data)
			else
				DataCache.setInBattleStatus(false)
				GCItemView.updateUI()
				if (data.res=="closed") then
					ShowNotice.showShellInfo(m_i18n[5946]) 
				elseif (data.res=="baseiderr") then
					ShowNotice.showShellInfo(m_i18n[5947]) --TODO
				elseif (data.res == "notinguild") then
					ShowNotice.showShellInfo(m_i18n[5948]) --TODO
				elseif (data.res=="fail") then
					
				end
			end
		end 
	end
	local arg = Network.argsHandler(tonumber(copyId),tonumber(_baseId))
  	RequestCenter.getGuildAtkCopy(battleNetCallback,arg)
  	DataCache.setInBattleStatus(true)
  	
end
--点击结算面板上的继续
function onResultContinue()
	local reward = _battleResultData.guildReward or {}
	logger:debug("reward:")
	logger:debug(reward)
	if (table.count(reward)>=1) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
		
		local pTable = {}
		for k,v in pairs(reward) do
			local data = {type = v[1],id = v[2],num = v[3]}
			table.insert(pTable,data)
		end
		local pRanks = RewardUtil.getItemsDataByTb(pTable)
		local tbItems = RewardUtil.parseRewardsByTb(pRanks)

		require "script/module/WorldBoss/WorldBossRewardView"
		local rewardLayout = WorldBossRewardView.create(tbItems,onResultConfirm)
		LayerManager.addLayoutNoScale(rewardLayout)
	else
		onResultConfirm()
	end
end
--点击结算面板上的确认按钮
function onResultConfirm()
	DataCache.setInBattleStatus(false)
	GCItemView.updateUI()
	require ("script/battle/notification/EventBus")
	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	AudioHelper.playCloseEffect()
	AudioHelper.playMainMusic()
end