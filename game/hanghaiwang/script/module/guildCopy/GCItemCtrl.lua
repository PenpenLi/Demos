-- FileName: GCItemCtrl.lua
-- Author: liweidong
-- Date: 2015-06-04
-- Purpose: 据点ctrl
--[[TODO List]]

module("GCItemCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCItemCtrl"] = nil
end

function moduleName()
    return "GCItemCtrl"
end

function create(id)
	require "script/module/guildCopy/GCItemView"
	return GCItemView.create(id)
end
--点击据点
function onBaseStrongHold(copyId,baseId)
	AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
	local state = GCItemModel.getStrongHoldStatus(copyId,baseId)
	--判断状态
	if (state==-1) then
		return
	end
	if (state==100) then
		ShowNotice.showShellInfo(m_i18n[5933]) --TODO
		return
	end
	--判断是否在攻打时间内
	local iscanAttack,beginTime,endTime = GCItemModel.getCopyAttackTimeInfo()
	if (not iscanAttack) then
		ShowNotice.showShellInfo(string.format(m_i18n[5934],beginTime,endTime)) --TODO
		return
	end
	if (GCItemModel.getAtackNum()<=0) then
		onAddTimes()
		return
	end
	require "script/module/guildCopy/GCBattleMonsterCtrl"
	local layout = GCBattleMonsterCtrl.create(copyId,baseId)
	LayerManager.addLayout(layout)
end
--布阵
function onBuzhen( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		--显示布阵界面。
		require "script/module/formation/Buzhen"
		Buzhen.createForCopy(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					-- demoBaseLay:setVisible(true)
					require "script/module/formation/Buzhen"
					Buzhen.fnCleanupFormation()
					LayerManager.removeLayout()
					AudioHelper.playBackEffect() --返回音效
				end
			end)
		GCItemView.hideView()
		AudioHelper.playCommonEffect()
	end
end
--点击增加次数
function onAddTimes()
	AudioHelper.playCommonEffect()
	if (GCItemModel.getAtackNum()>0) then
		ShowNotice.showShellInfo(m_i18n[5935]) --TODO
		return
	end
	require "script/module/guildCopy/CGBuyTimesView"
	LayerManager.addLayout(CGBuyTimesView.create())
end
--确认购买次数
function onConfirmBuyTime()
	if (GCItemModel.getAtackNum()>0) then
		ShowNotice.showShellInfo(m_i18n[5935]) --TODO
		AudioHelper.playCommonEffect()
		return
	end
	--购买次数返回
	local function onBuyCallBack(cbFlag, dictData, bRet)
		if(dictData.ret~=nil and dictData.err=="ok")then
			local needGold = GCItemModel.getBuyTimesGold()
			UserModel.addGoldNumber(-needGold)
			logger:debug("attack num:"..GCItemModel.getAtackNum())
			GCItemModel.addBattleTimes()
			logger:debug("attack num:"..GCItemModel.getAtackNum())
			LayerManager.removeLayout()
			GCItemView.updateAtackNum()  --更新UI
		end
	end
	
	if (GCItemModel.getBuyTimesRemainNum(id)<=0) then
		local tbParams = {sTitle = m_i18n[4014],sUnit = m_i18n[2621],sName = m_i18n[5936],nNowBuyNum=GCItemModel.getMaxBuyTimes(),nNextBuyNum=GCItemModel.getNextMaxBuyTimes(),}
		local layAlert = UIHelper.createVipBoxDlg(tbParams)
		LayerManager.addLayout(layAlert)
		AudioHelper.playCommonEffect()
		return
	end	
	local needGold = GCItemModel.getBuyTimesGold()
	if (needGold ~= nil) then
		if(UserModel.getGoldNumber() >= needGold ) then
			--访问购买接口
			RequestCenter.getGuildBuyAtkNum(onBuyCallBack)
			AudioHelper.playBtnEffect("buttonbuy.mp3")
		else
			local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			AudioHelper.playCommonEffect()
		end
	end
end
--点击返回按钮
function onBack()
	LayerManager.removeLayout()
	GuildCopyMapCtrl.onReloadMap()
end
--排行
function onEnterRank( copyId )
		AudioHelper.playCommonEffect()
		require "script/module/guildCopy/GuildCopyRankCtrl"
		GuildCopyRankCtrl.create(copyId)
end
--战利品队列
function onEnterRewardQuene( copyId )
		AudioHelper.playCommonEffect()
		require "script/module/guildCopy/GCRewardQueueCtrl"
		GCRewardQueueCtrl.create(copyId)
end