-- FileName: AchieveCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-11-11
-- Purpose: function description of module
-- 成就界面显示控制器



module("AchieveCtrl", package.seeall)

require "script/module/achieve/AchieveView"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["AchieveCtrl"] = nil
end

function moduleName()
    return "AchieveCtrl"
end

function create( )

	-- 按钮事件
	local tbBtnEvent = {}
	-- 按钮
	tbBtnEvent.onAction= function ( sender, eventType)
	    if (eventType == TOUCH_EVENT_ENDED) then
	    	local sender = tolua.cast(sender, "Button")
 			logger:debug("tbBtnEvent.onAction : sender:getTag = " .. sender:getTag())
 			AudioHelper.playCommonEffect()
 			local tbDataItem = AchieveModel.getAchieveInfoById(sender:getTag())
				local args = Network.argsHandler(tbDataItem.child_type, tbDataItem.id)
					local function dataCallBack(cbFlag, dictData, bRet )
							local tbRewardsData = RewardUtil.parseRewards(tbDataItem.achie_reward, true)
							local alert = UIHelper.createGetRewardInfoDlg(m_i18n[3341],tbRewardsData)
							LayerManager.addLayout(alert)
							AchieveModel.changeSortAchieveById(tbDataItem.id, 2)
							MainAchieveView.updateRedPoint()
							AchieveView.reLoadUI()
					end
					local rewardTids = AchieveModel.getRewrdItems(tbDataItem.achie_reward)
					if(not table.isEmpty(rewardTids) and ItemUtil.bagIsFullWithTids(rewardTids,true)) then
						return
					end

					RequestCenter.getRewardAchie(dataCallBack,args)

		end
	end
	local view = AchieveView.create(tbBtnEvent)
	return view
end
