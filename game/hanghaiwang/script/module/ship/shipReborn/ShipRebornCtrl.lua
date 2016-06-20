-- FileName: ShipRebornCtrl.lua
-- Author: Xufei
-- Date: 2015-10-22
-- Purpose: 主船重生 控制
--[[TODO List]]

module("ShipRebornCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _fnRefreshMainView = nil

function btnEventClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()

		LayerManager.removeLayout()
	end
end

function btnEventOk( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		local shipId = ShipRebornModel.getShipId()
		local numBelly, strReward = ShipRebornModel.getStrengthenCost()
		local tbRewardData = RewardUtil.getItemsDataByStr(strReward)
		local function shipRebornCallback( cbFlag, dictData, bRet )
			if (bRet) then
			 	if(dictData.ret == "ok") then
			 		local shipInfo = ShipData.getShipInfoById(shipId)
			 		UserModel.addGoldNumber(-tonumber(shipInfo.reborn_gold))
			 		local numBelly = ShipRebornModel.getStrengthenCost()
			 		UserModel.addSilverNumber(tonumber(numBelly))
			 		local tbReward = RewardUtil.parseRewards(strReward)
			 		local layRewardInfo = UIHelper.createGetRewardInfoDlg(nil, tbReward, function ( ... )
			 			LayerManager.removeLayout()	-- 删除奖励提示框
			 			LayerManager.removeLayout()	-- 删除奖励预览面板，回到主界面
				 		ShipData.setShipStrengthLevel(shipId, true)
				 		_fnRefreshMainView( shipId )
			 		end)
			 	end
			end
		end
		local tbArgs = Network.argsHandler(shipId)
		-- 判断背包是否已满
		for k,v in pairs(tbRewardData) do
			if (tonumber(v.tid) ~= 0 and ItemUtil.bagIsFullWithTid(v.tid, true)) then
				return
			end
		end
		RequestCenter.mainship_reborn(shipRebornCallback, tbArgs)
	end
end

local function init(...)

end

function destroy(...)
	package.loaded["ShipRebornCtrl"] = nil
end

function moduleName()
    return "ShipRebornCtrl"
end

function create( shipId, shipLv, fnRefreshMainView )
	_fnRefreshMainView = fnRefreshMainView
	require "script/module/ship/shipReborn/ShipRebornModel"
	ShipRebornModel.setShipInfo(shipId, shipLv)

	require "script/module/ship/shipReborn/ShipRebornView"
	local viewInstance = ShipRebornView:new()
	local mainRebornView = viewInstance:create()
	LayerManager.addLayout(mainRebornView)
end
