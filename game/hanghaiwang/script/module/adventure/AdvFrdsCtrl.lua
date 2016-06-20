-- FileName: AdvFrdsCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-04-03
-- Purpose: 奇遇事件：声名远播 控制
--[[TODO List]]

module("AdvFrdsCtrl", package.seeall)
require "script/module/adventure/AdvFrdsView"
require "script/module/adventure/AdventureModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_eventId = 0
local m_timeStr = "00:00:00"
local tbAdvFrdData 
local m_i18nString 					= gi18nString
local function init(...)

end

function destroy(...)
	package.loaded["AdvFrdsCtrl"] = nil
end

function moduleName()
    return "AdvFrdsCtrl"
end

function updateCD( stime )
	AdvFrdsView.updateCD(stime)
end

local function fnExploreOverCall( cbFlag, dictData, bRet )
	if(bRet)then
		AdvFrdsView.changeEtnEventBy(AdvFrdsView.BTN_TYPE.BTN_REWARDED)
		AdvFrdsView.showRewardDlg()
		AdventureModel.setEventCompleted(m_eventId)  --事件完成状态
	end
end


local function fnAddFrdFromAdvCall( cbFlag, dictData, bRet )
	if(bRet)then
		tbAdvFrdData.friend.status = 1
		ShowNotice.showShellInfo(gi18n[4334])--"邀请成功"
		-- ShowNotice.showShellInfo(m_i18nString(4343))-- todo 国际化
		-- AdvFrdsView.changeEtnEventBy(AdvFrdsView.BTN_TYPE.BTN_REWARD)

		AdvFrdsView.changeEtnEventBy(AdvFrdsView.BTN_TYPE.BTN_REWARDED)
		AdvFrdsView.showRewardDlg()
		AdventureModel.setEventCompleted(m_eventId)  --事件完成状态
		
	end
end

local function fnAddFrdFromNomalCall( cbFlag, dictData, bRet )
	if(bRet)then
		local dataRet = dictData.ret

		local function sendEventCall( ... )
			local params = CCArray:create()
			params:addObject(CCInteger:create(tonumber(m_eventId)))
			params:addObject(CCInteger:create(tonumber(0)))
			RequestCenter.exploreDoEvent(fnAddFrdFromAdvCall,params)
		end
		if(dataRet == "ok")then
			sendEventCall()
		elseif(dataRet == "isfriend")then
			-- fnAddFrdFromAdvCall(nil ,nil ,true)
			local str = m_i18nString(3664) --"对方已经是您的好友了！"
			ShowNotice.showShellInfo(str)
			sendEventCall()
			return
		elseif(dataRet == "applied")then
			sendEventCall()
			return
		else
			--如果自己好友满了，或者对方好友满了 ，则统一处理为可领奖
			-- fnAddFrdFromAdvCall(nil ,nil ,true)
			sendEventCall()
		end
	end
end

function create(id)
	m_eventId = id
	tbAdvFrdData = AdventureModel.getEventItemById(id)
	logger:debug(tbAdvFrdData)

	local tbEvent = {}

	tbEvent.onAddFrd = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect() 

			if(AdvFrdsView.getCDTime() == m_timeStr)then 
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(4364))-- todo 国际化 "船长，奇遇事件已结束"
				return
	   		 end 
			-- 参数
			local args = CCArray:create()
			args:addObject(CCInteger:create(tbAdvFrdData.friend.uid))
		    args:addObject(CCString:create(""))
		    RequestCenter.friend_applyFriend(fnAddFrdFromNomalCall, args)
		end
	end

	tbEvent.onReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect() 

			-- if(AdvFrdsView.getCDTime() == m_timeStr)then 
			-- 	require "script/module/public/ShowNotice"
			-- 	--"船长，奇遇事件已结束,奖励讲发到奖励中心"
			-- 	ShowNotice.showShellInfo(m_i18nString(4382))-- todo 国际化
			-- 	return
	  --  		end 

			-- local params = CCArray:create()
			-- params:addObject(CCInteger:create(tonumber(m_eventId)))
			-- params:addObject(CCInteger:create(tonumber(1)))
			-- RequestCenter.exploreDoEvent(fnExploreOverCall,params)
		end
	end

	local frdsView = AdvFrdsView.create(tbEvent,tbAdvFrdData)
	return frdsView
end
			