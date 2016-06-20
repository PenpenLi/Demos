-- FileName: NewUpgradeCtrl.lua
-- Author: Xufei
-- Date: 2015-07-22
-- Purpose: 升级面板改版 控制模块
--[[TODO List]]

module("NewUpgradeCtrl", package.seeall)
require "script/module/upgrade/NewUpgradeView"
require "script/module/upgrade/NewUpgrageModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local _noticeText = nil --传入提示信息，如果不为nil在升级面板跳转时提示本内容，并不跳转
local gi18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["NewUpgradeCtrl"] = nil
end

function moduleName()
    return "NewUpgradeCtrl"
end

--[[desc:功能简介
    arg1: noticeText 点击跳转按钮（去探索、夺宝等），需要显示的文字提示
    return: 是否有返回值，返回值说明  
—]]
function create(noticeText)
	_noticeText = noticeText
	-- NewUpgrageModel.setNoticeText(noticeText)

	--用户信息是否已发生变化
	UserModel.setInfoChanged(true)

	--幸运转盘拉取信息
	local function rouletteInfoCallBack( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug("roulettePrerequest")
			require "script/module/wonderfulActivity/roulette/RouletteModel"
			RouletteModel.setActivityInfo(dictData.ret)
		end
	end

	if (RouletteModel.bActivityOpen() and not RouletteModel.bRouletteLevelNotReached()) then
		RequestCenter.roulette_getTurntableInfo(rouletteInfoCallBack)
	end

	--升级后更新本地等级礼包的数据
	require "script/module/levelReward/LevelRewardCtrl"
	LevelRewardCtrl.updateForLVUp()
	--平台统计需求，游戏内部玩家等级信息
	if (Platform.isPlatform()) then
		local userInfo = UserModel.getUserInfo()
		Platform.sendInformationToPlatform(Platform.kRoleLevelInfo, userInfo.level)
	end
	--更新升级后的用户数据，包括体力和耐力
	NewUpgrageModel.addUpgradeRewards()

	local instanceView = NewUpgradeView:new()
	instanceView:create()
	--liweidong 升级时获取副本信息。
	-- logger:debug({CopyData=DataCache.getNormalCopyData().copy_list})
	-- getCopyData()

end
--升级时拉取副本
function getCopyData()
	--获取db所有id
	local function getCopyDbIds()
		local ids = {}
		for keys,val in pairs(DB_Copy.Copy) do
			local keyArr = lua_string_split(keys, "_")
			table.insert(ids,tonumber(keyArr[2]))
		end
		return ids
	end
	local ids = getCopyDbIds()
	for _,id in ipairs(ids) do
		local db = DB_Copy.getDataById(id)
		if (tonumber(db.limit_level)==UserModel.getHeroLevel()) then
			local curNetData = DataCache.getNormalCopyData().copy_list
			if (curNetData[tostring(db.id)]==nil) then
				-- 普通副本
				local function preGetNormalCopyCallback( cbFlag, dictData, bRet )
					if(bRet)then
						logger:debug("preGetNormalCopyCallback")
						DataCache.setNormalCopyData( dictData.ret )
					end
				end
				RequestCenter.getLastNormalCopyList(preGetNormalCopyCallback)
			end
			break
		end
	end
end
--点击确认按钮
function onClickConfirm( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
		LayerManager.removeLayout()
		AudioHelper.playCommonEffect()
		--如果是在探索过程中 点击升级面板的确定按钮时 发送离开和进入探索通知
		require "script/module/copy/ExplorMainCtrl"
		if (LayerManager.curModuleName() == ExplorMainCtrl.moduleName()) then
			SwitchCtrl.postBattleNotification(GlobalNotify.END_EXPLORE)
			SwitchCtrl.postBattleNotification(GlobalNotify.BEGIN_EXPLORE)
		end
	end
end
--[[desc: 获取引导前往按钮的逻辑
    arg1: 前往目的地的编号
    return: 前往按钮的函数
—]]
function getGotoBtnEvent(gotoId)
	local fnGotoBtnEvent = nil
	
	-- 1. 伙伴背包
	if (gotoId == 1) then
		fnGotoBtnEvent = function ()
			require "script/module/partner/MainPartner"
			if (MainPartner.moduleName() ~= LayerManager.curModuleName()) then
				local layPartner = MainPartner.create()
				if (layPartner) then
					LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3}, true)
					PlayerPanel.addForPartnerStrength()
				end
			end
		end
	end
	-- 2. 阵容界面
	if (gotoId == 2) then
		fnGotoBtnEvent = function ()
			require "script/module/switch/SwitchModel"
			if(not SwitchModel.getSwitchOpenState(ksSwitchFormation,true)) then
				return
			end
			require "script/module/formation/MainFormation"
			if (MainFormation.moduleName() ~= LayerManager.curModuleName()) then
				local layFormation = MainFormation.create(0)
				if (layFormation) then
					LayerManager.changeModule(layFormation, MainFormation.moduleName(), {1,3}, true)
				end
			end
		end
	end
	-- 3. 装备背包
	if (gotoId == 3) then
		fnGotoBtnEvent = function ()
			require "script/module/equipment/MainEquipmentCtrl"
			if (MainEquipmentCtrl.moduleName() ~= LayerManager.curModuleName()) then
				local layEquipment = MainEquipmentCtrl.create()
				if (layEquipment) then
					LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
					PlayerPanel.addForPartnerStrength()
				end
			end
		end
	end
	-- 4. 宝物背包
	if (gotoId == 4) then
		fnGotoBtnEvent = function ()
			require "script/module/treasure/MainTreaBagCtrl"
			if (not LayerManager.isRunningModule(MainTreaBagCtrl)) then
				MainTreaBagCtrl.create()
			end
		end
	end
	-- 5. 等级礼包界面
	if (gotoId == 5) then
		fnGotoBtnEvent = function ()
			require "script/module/wonderfulActivity/MainWonderfulActCtrl"
			if (MainWonderfulActCtrl.moduleName() ~= LayerManager.curModuleName()) then
				local act = MainWonderfulActCtrl.create("levelReward")
				LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
				LevelRewardCtrl.scrollToReward() -- zhangqi, 2015-11-26, 显示等级礼包后再滑动到对应的cell, 解决定位不准的问题
			end
		end
	end
	-- 6. 日常副本主界面
	if (gotoId == 6) then
		fnGotoBtnEvent = function ()
			require "script/module/copyActivity/MainCopyCtrl"
			if (MainCopyCtrl.moduleName() ~= LayerManager.curModuleName()) then
				require "script/module/switch/SwitchModel"
				if (SwitchModel.getSwitchOpenState(ksSwitchActivityCopy,true)) then
					MainCopyCtrl.create()
				end
			end
		end
	end
	-- 7. 竞技场主界面
	if (gotoId == 7) then
		fnGotoBtnEvent = function ()
			require "script/module/arena/MainArenaCtrl"  
			if (MainArenaCtrl.moduleName() ~= LayerManager.curModuleName()) then
				require "script/module/switch/SwitchModel"
				if(SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
				   MainArenaCtrl.create()
				end
			end
		end
	end
	-- 8. 世界BOSS主界面
	if (gotoId == 8) then
		fnGotoBtnEvent = function ()
			require "script/module/WorldBoss/MainWorldBossCtrl"
			if (MainWorldBossCtrl.moduleName() ~= LayerManager.curModuleName()) then
				require "script/module/switch/SwitchModel"
				if(not SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,true)) then
					return
				end
			end
			MainWorldBossCtrl.create(true)
		end
	end
	-- 9. 神秘空岛主界面
	if (gotoId == 9) then
		fnGotoBtnEvent = function ()
			require "script/module/SkyPiea/MainSkyPieaCtrl"
			if (MainSkyPieaCtrl.moduleName() ~= LayerManager.curModuleName()) then
				require "script/module/switch/SwitchModel"
				if(not SwitchModel.getSwitchOpenState(ksSwitchTower,true)) then
					return
				end
			end
			MainSkyPieaCtrl.create()
		end
	end
	-- 10. 主船主界面
	if (gotoId == 10) then
		fnGotoBtnEvent = function ()
			--AudioHelper.playMainUIEffect()
			if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , true )) then
				require "script/module/ship/ShipMainCtrl"
				ShipMainCtrl.create(nil, "main")
			end
		end
	end
	-- 11. 探索主界面
	if (gotoId == 11) then
		fnGotoBtnEvent = function ()
			require "script/module/copy/ExplorMainCtrl"
			if ( LayerManager.curModuleName() == ExplorMainCtrl.moduleName() ) then
				LayerManager.removeLayout()
				LayerManager.removeLayout()
				--AudioHelper.playCommonEffect()
				--发送离开和进入探索通知
				--SwitchCtrl.postBattleNotification(GlobalNotify.END_EXPLORE)			--临时注释掉，不要删
				--SwitchCtrl.postBattleNotification(GlobalNotify.BEGIN_EXPLORE)			--临时注释掉，不要删
			else
				require "script/module/switch/SwitchModel"
				if( not SwitchModel.getSwitchOpenState(ksSwitchExplore, true)) then
					return
				end
				require "script/module/copy/MainCopy"
				MainCopy.extraToExploreScene()
			end 		
		end
	end
	-- 12. 签到界面
	if (gotoId == 12) then
		fnGotoBtnEvent = function ()
			require "script/module/wonderfulActivity/MainWonderfulActCtrl"
			if (LayerManager.curModuleName() ~= MainWonderfulActCtrl.moduleName()) then
				local act = MainWonderfulActCtrl.create("registration")
				LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
			end
		end
	end
	-- 13. 分解屋界面
	if (gotoId == 13) then
		fnGotoBtnEvent = function ()

		    if (SwitchModel.getSwitchOpenState( ksSwitchResolve,true)) then
		        require "script/module/resolve/MainRecoveryCtrl"
		        local layResolve = MainRecoveryCtrl.create()
		        if (layResolve) then
		            LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
		            PlayerPanel.addForPublic()
		        end
		    end
		end
	end

	return fnGotoBtnEvent
end
--点击去xx跳转到其他模块按钮
function onGotoOtherModule(jumpId)
	--liweidong 如果当前升级有引导，则点击跳转弹出提示先完成引导
	local  userInfo = UserModel.getUserInfo()
	local userLevelArr = {tostring(userInfo.level)}
	require "db/DB_Normal_config"
	local guildConfig = DB_Normal_config.getDataById(1)
	local levelArr = lua_string_split(guildConfig.newplayer_lv, "|")

	local isInArenaOrGrab=false --当前是否在夺宝或竞技场
	require "script/module/copy/ExplorMainCtrl"
	require "script/module/arena/MainArenaCtrl"
	require "script/module/grabTreasure/MainGrabTreasureCtrl"
	if (LayerManager.curModuleName() == MainArenaCtrl.moduleName() or LayerManager.curModuleName() == MainGrabTreasureView.moduleName()) then
		require "script/module/arena/ArenaWinCtrl"
		if ArenaWinCtrl.winViewExist() then
			isInArenaOrGrab=true
		end
	end
	--当前是否在影子副本胜利结算面板
	require "script/module/copyActivity/ShadowBattleWin"
	local isInShadowWinLayout = ShadowBattleWin.isShow()

	local isHaveGuild = table.include(levelArr,userLevelArr) or isInArenaOrGrab or isInShadowWinLayout--记录是否有引导
	if (isHaveGuild) then
		if (isInArenaOrGrab) then
			ShowNotice.showShellInfo(gi18n[4385]) --TODO
		elseif (isInShadowWinLayout) then
			ShowNotice.showShellInfo(gi18n[4384]) --TODO
		else
			ShowNotice.showShellInfo(gi18n[1371])
		end
		return
	end
	if (_noticeText) then --天降宝物
		ShowNotice.showShellInfo(_noticeText)
	end
	require "script/battle/BattleState"
	if(BattleState.isPlaying() or DataCache.getInBattleStatus()) then --战斗中 和 自己添加的战斗中
		LayerManager.removeLayout()
		LayerManager.removeLayout()
		DataCache.setInBattleStatus(false) -- 设置自己记录的战斗中状态
		require ("script/battle/notification/EventBus")
		require "script/module/copy/battleMonster"
		battleMonster.setShowTalkInfoStauts(false)
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		battleMonster.setShowTalkInfoStauts(true)
	end
	getGotoBtnEvent(jumpId)()
end

