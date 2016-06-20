-- FileName: MainGrabTreaCtrl.lua
-- Author: menghao
-- Date: 2014-12-26
-- Purpose: 改版后的夺宝主界面ctrl


module("MainGrabTreaCtrl", package.seeall)


require "script/module/grabTreasure/MainGrabTreaView"
require "script/module/grabTreasure/TreasureService"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["MainGrabTreaCtrl"] = nil
end


function moduleName()
	return "MainGrabTreaCtrl"
end


function setTouchEnabled(enable)
	MainGrabTreaView.setTouchEnabled(enable)
end


function onAvoid( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		require "script/module/grabTreasure/AvoidWarCtrl"
		AudioHelper.playCommonEffect()
		LayerManager.addLayout(AvoidWarCtrl.create())
	end
end


function create( treaTid )
	-- 先判断功能有没有开启
	if (not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure, true)) then
		return
	end

	local getCallfunc = function ( ... )
		local tbEvents = { onReward = onReward, onAvoid = onAvoid }
		TreasureData.setRobItemNum()
		local layMain = MainGrabTreaView.create( tbEvents, treaTid)

		--结算面板 确定 之后 防止会有 夺宝玩家选择界面的残留问题
		--删除战斗场景 或者副本战斗升级界面，去竞技，防止界面跳转的时候 有副本界面的残留
		if(BattleState.isPlaying() == true) then
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
			SwitchCtrl.postBattleNotification("END_BATTLE")
			AudioHelper.playMainMusic()
		end

		LayerManager.addUILoading()
		LayerManager.changeModule(layMain, MainGrabTreaView.moduleName(), {1, 3}, true)
		PlayerPanel.addForActivity()
	end

	-- 获取碎片信息
	TreasureService.getSeizerInfo( getCallfunc )
end

