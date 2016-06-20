-- FileName: GCDistriPeopleCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-06-05
-- Purpose: 工会副本战利品分配成员Ctrl

module("GCDistriPeopleCtrl", package.seeall)

require "script/module/guildCopy/GCDistriPeopleView"
local m_i18n 		= gi18n
-- UI控件引用变量 --

-- 模块局部变量 --

local _tbEvent = {}
local _tbAllRanksInfo   	 = {}

local function init(...)

end

function destroy(...)
	package.loaded["GCDistriPeopleCtrl"] = nil
end

function moduleName()
    return "GCDistriPeopleCtrl"
end

_tbEvent.onDistribution = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then 
		AudioHelper.playInfoEffect()
		
		local nDistributeNum = GuildCopyModel.getRewardDistributeNum() or 0

		if(nDistributeNum > 0) then
			ShowNotice.showShellInfo(m_i18n[5923])
			return 
		end

		local nIndex = sender:getTag()
		local queue = _tbAllRanksInfo.queue  --物品的队列
		local queueInfo = queue[nIndex]
		logger:debug(queueInfo)
		local  uid = queueInfo.uid
		local _type = _tbAllRanksInfo.rewardType
		local subType = _tbAllRanksInfo.subType
		local copyId = _tbAllRanksInfo.copyId


		logger:debug(uid)
		logger:debug(subType)
		logger:debug(_type)
		logger:debug(copyId)
		local subArg = CCArray:create()
		subArg:addObject(CCInteger:create(copyId))
		subArg:addObject(CCString:create(_type))
		subArg:addObject(CCInteger:create(subType))
		subArg:addObject(CCInteger:create(uid))
		RequestCenter.guildCopy_leaderDistribute(function ( cbFlag, dictData, bRet )
			logger:debug(dictData)
			logger:debug(dictData.ret.res)
			if(dictData.ret.res == "fail") then
				ShowNotice.showShellInfo(m_i18n[5924]) ---"此玩家已不在公会，分配失败"
				LayerManager:removeLayout()
				GCDistributionCtrl.updateRewardListView(uid,copyId)
				return 
			end
			if (bRet) then 
				ShowNotice.showShellInfo(m_i18n[5925]) ---"恭喜您分配成功"
				LayerManager:removeLayout()
				GCDistributionCtrl.updateRewardListView(uid,copyId)
			end 
		end,subArg)

		
	end 
end


function create(tbRanksInfo)	
	_tbAllRanksInfo = tbRanksInfo
	local memberListView = GCDistriPeopleView.create(_tbEvent,tbRanksInfo)
	LayerManager.addLayout(memberListView)
end
