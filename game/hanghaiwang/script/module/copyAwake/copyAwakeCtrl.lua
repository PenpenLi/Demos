-- FileName: copyAwakeCtrl.lua
-- Author: liweidong
-- Date: 2015-11-16
-- Purpose: 觉醒副本控制器
--[[TODO List]]

module("copyAwakeCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeCtrl"] = nil
end

function moduleName()
    return "copyAwakeCtrl"
end
--进入副本地图
function create(...)
	if (not SwitchModel.getSwitchOpenState(ksSwitchSignIn,true)) then
		return
	end
	copyAwakeModel.getMapEnterenceInfo(true) --刷新地图数据
	local layout = copyAwakeMapView.create()
	LayerManager.changeModule(layout, copyAwakeMapView.moduleName(), {3}, true)
	PlayerPanel.addForCopy()
	copyAwakeMapView.updateScvPostion()
end

--切换到普通副本地图
function toCopyMap()
	MainCopy.destroy()
	LayerManager.changeModule(Layout:create(), "ExploreAndCopyChange", {}, true)
	local layCopy = MainCopy.create()
	if (layCopy) then
		LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
		PlayerPanel.addForCopy()
		MainCopy.updateBGSize()
		MainCopy.setFogLayer()
		MainCopy.normalCopyAction("images/copy/ncopy/into_nor_copy.png")
	end
end
--去获取引导某个入口某个据点
function enterCopyAndBase(copyId,baseId,callBack)
	local baseStatus = copyAwakeModel.getStrongHoldStatus(copyId,baseId)
	if (baseStatus==-1) then
		return --据点不可攻打 无法进入
	end
	onClickEnterence(copyId,callBack)
	onClickBase(copyId,baseId)
end
--点击入口
function onClickEnterence(copyId,callBack)
	local item =  copyAwakeBaseView.create(copyId,callBack)
	LayerManager.addLayoutNoScale(item)
	copyAwakeBaseView.setScrollViewPos()
end
--点击灰色入口
function onClickGrayEnterence(copyId)
	ShowNotice.showShellInfo(copyAwakeModel.getCanNotEnterCopyReason(copyId))
end
--据点界面点击返回
function onBaseHoldBack(callBack)
	LayerManager.removeLayout()
	if (callBack) then
		callBack()
		return
	end
	logger:debug("enter update map")
	copyAwakeModel.getMapEnterenceInfo(true) --刷新地图数据
	copyAwakeMapView.updateUI()
end
--点击据点
function onClickBase(copyId,baseId)
	local layout = copyAwakeMonsterView.create(copyId,baseId)
	LayerManager.addLayout(layout)
end
--点击宝箱按钮
function onclickRewardBox(copyId,boxId)
	local layout = copyAwakeRewardView.create(copyId,boxId)
	LayerManager.addLayout(layout)
end
--点击据点界面的布阵
function onBuzheng()
	logger:debug("enter buzheng")
	Buzhen.createForCopy(function()
			Buzhen.fnCleanupFormation()
			LayerManager.removeLayout()
			AudioHelper.playCloseEffect() --关闭音效
		end)
end
--重置战斗次数
local function fnNoBattleNum( copyId,baseId )
	local onRestTime = function ( sender, eventType )
		AudioHelper.playCommonEffect() 
		if (eventType == TOUCH_EVENT_ENDED) then
			local attkNum,allNum = copyAwakeModel.getHoldAttackInfo(copyId,baseId)
			if (attkNum <= 0) then
				--金币重置挑战次数
				local costGold = copyAwakeModel.getResetHoldNeedGold(copyId,baseId)
				local userInfo = UserModel.getUserInfo()
				if(UserModel.getGoldNumber() >= costGold)then
					local args = Network.argsHandler(tonumber(copyId),tonumber(baseId))
					RequestCenter.awakeCopy_resetAtkNum(function( cbFlag, dictData, bRet )
							if(dictData.err == "ok")then
								UserModel.addGoldNumber(-costGold)
								copyAwakeModel.resetHoldAttackNum(copyId,baseId)
								copyAwakeModel.addHaveResetHoldTimes(copyId,baseId)
								copyAwakeMonsterView.updateUI()
								LayerManager.removeLayout()
								ShowNotice.showShellInfo(gi18n[1944])
							end
						end, args)
				else
					-- ShowNotice.showShellInfo(gi18n[1336])
					local noGoldAlert = UIHelper.createNoGoldAlertDlg()
					LayerManager.addLayout(noGoldAlert)
				end
			else
				LayerManager.removeLayout()
			end
		end
	end
	local layTip = g_fnLoadUI("ui/copy_buytimes.json")
	layTip.tfd_can:setText(m_i18n[1376]) -- 2015-10-09
	layTip.TFD_TIP_CONFIRM:setText(m_i18n[1335])
	local costGold = copyAwakeModel.getResetHoldNeedGold(copyId,baseId)
	layTip.TFD_TIP_INFO:setText(costGold)
	layTip.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	layTip.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
	UIHelper.titleShadow(layTip.BTN_CANCEL)
	layTip.BTN_ENSURE:addTouchEventListener(onRestTime)
	UIHelper.titleShadow(layTip.BTN_ENSURE)
	LayerManager.addLayout(layTip)

end
--点击挑战界面的战斗
function onClickBattle(copyId,baseId)
	local attkNum,allNum = copyAwakeModel.getHoldAttackInfo(copyId,baseId)
	if (attkNum<=0) then --无挑战次数
		fnNoBattleNum(copyId,baseId)
		return
	end
	--计算消耗体力
	local nCurAtkNum = 1 --attkNum > 10 and 10 or attkNum
	-- if (nCurAtkNum<=0) then
	-- 	if (allNum>10) then
	-- 		nCurAtkNum = 10
	-- 	else
	-- 		nCurAtkNum = allNum
	-- 	end
	-- end
	local baseItemInfo = DB_Stronghold.getDataById(baseId)
	local nCostEnergy = baseItemInfo.cost_energy_simple
	local tbUserInfo = UserModel.getUserInfo()
	-- 检查体力是否足够
	if (tonumber(tbUserInfo.execution) < (nCurAtkNum * nCostEnergy)) then
		LayerManager.addLayout(copyUsePills.create())
		return
	end
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		return
	end
	LayerManager.removeLayout()
	BattleModule.playAwakeCopyBattle(copyId,baseId,function()
			logger:debug("onbattle call back")
			-- UserModel.addEnergyValue(-1*nCostEnergy) -- 减少体力 不能在这里写，会引导战斗失败扣除体力的问题
			copyAwakeBaseView.updateUI()
			if (copyAwakeModel.isOpenNewCopyStaus() and copyAwakeModel.getStrongHoldInx(copyId,baseId)~=1) then
				copyAwakeBaseView.showClearanceTip(copyAwakeModel.getCurEnterenceId())
			end
		end)
end
--点击扫荡按钮
function onTenAttack(copyId,baseId)
	-- 判断等级限制
	if (UserModel.getHeroLevel() < 20) then --25级扫荡
		ShowNotice.showShellInfo(gi18n[1370])
		return
	end
	local baseStar = copyAwakeModel.getHoldStarNumber(copyId,baseId)
	if (tonumber(baseStar)<3) then  --未通关时(baseStaus < 3) 改为未获得三星 (tonumber(baseStar)>=3)
		ShowNotice.showShellInfo(gi18n[1942])
		return
	end
	
	local attkNum,allNum = copyAwakeModel.getHoldAttackInfo(copyId,baseId)
	if (attkNum<=0) then --无挑战次数
		fnNoBattleNum(copyId,baseId)
		return
	end
	--计算消耗体力
	local nCurAtkNum = attkNum > 10 and 10 or attkNum
	if (nCurAtkNum<=0) then
		if (allNum>10) then
			nCurAtkNum = 10
		else
			nCurAtkNum = allNum
		end
	end
	local baseItemInfo = DB_Stronghold.getDataById(baseId)
	local nCostEnergy = baseItemInfo.cost_energy_simple
	local tbUserInfo = UserModel.getUserInfo()
	-- 检查体力是否足够
	if (tonumber(tbUserInfo.execution) < (nCurAtkNum * nCostEnergy)) then
		LayerManager.addLayout(copyUsePills.create())
		return
	end
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		return
	end
	LayerManager.removeLayout() 

	-- require "script/module/switch/SwitchCtrl"
	-- SwitchCtrl.postBattleNotification("BEGIN_BATTLE")

	local args = Network.argsHandler(copyId,baseId,nCurAtkNum)
	RequestCenter.awakeCopy_sweep(function ( cbFlag, dictData, bRet )
			logger:debug(dictData)
			if (bRet) then
				copyAwakeModel.subHoldAttackNum(copyId,baseId,nCurAtkNum)
				local dlg = fightMore.create(baseId, 1, dictData.ret)
				-- local sc  = UIHelper.getAutoReleaseScheduler(dlg, fnCdNoBattle)
				-- table.insert(tbScheduler, sc)
				LayerManager.addLayout(dlg)
				-- --logger:debug("有没有升级")
				-- logger:debug(fightMore.isLevelUp())
				if (fightMore.isLevelUp()) then
					require "script/module/public/GlobalNotify"
					GlobalNotify.postNotify(GlobalNotify.LEVEL_UP)
				end
			end
		end,args)
end
--点击领取奖励按钮
function onGetBoxReward(copyId,boxId)
	--判断背包是否已满
	local function getRewardCallback( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok") then
			return
		end
		LayerManager.removeLayout()
		copyAwakeModel.setCopyRewardStatusById(copyId,boxId)
		local treasureData = dictData.ret
		logger:debug("copy reward data:")
		logger:debug(treasureData)
		showRewardDialog(copyId,boxId)
		copyAwakeBaseView.updateCopyBaseInfo()
	end
	local args = Network.argsHandler( tonumber(copyId),tonumber(boxId))
	RequestCenter.awakeCopy_fetchStarBoxReward(getRewardCallback,args)
end
--显示获得的奖励
function showRewardDialog(copyId,boxId)
	local tbCopyInfo = DB_Disillusion_copy.getDataById(copyId)
	local tbGoodsTmp
	if (boxId == 3) then
		tbGoodsTmp = tbCopyInfo["pt_box"]
	elseif (boxId == 2) then
		tbGoodsTmp = tbCopyInfo["au_box"]
	else
		tbGoodsTmp = tbCopyInfo["ag_box"]
	end

	local items = RewardUtil.parseRewards(tbGoodsTmp,true)
	
	local brow = UIHelper.createGetRewardInfoDlg(gi18n[1312], items)
	LayerManager.addLayout(brow)
end