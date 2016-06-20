-- FileName: AdvSingleBoxCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-04-03
-- Purpose: 奇遇事件：奇遇宝箱 控制
--[[TODO List]]

module("AdvSingleBoxCtrl", package.seeall)
require "script/module/adventure/AdvSingleBoxView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_timeStr = "00:00:00"
local m_eventId = 0
local m_i18nString  = gi18nString
local function init(...)

end

function destroy(...)
	package.loaded["AdvSingleBoxCtrl"] = nil
end

function moduleName()
    return "AdvSingleBoxCtrl"
end

function updateCD( stime )
	AdvSingleBoxView.updateCD(stime)
end

local function fnExploreOverCall( cbFlag, dictData, bRet )
	if(bRet)then
		-- AdvFrdsView.changeEtnEventBy(AdvFrdsView.BTN_TYPE.BTN_REWARDED)
		-- AdvFrdsView.showRewardDlg()
		local tbReward = ItemDropUtil.getAdvDropItem(dictData.ret,true) 
		ItemDropUtil.refreshUserInfo(tbReward) -- 同步更新贝里、金币的缓存
		local dlg = UIHelper.createRewardDlg(tbReward)
		LayerManager.addLayoutNoScale(dlg)

		AdventureModel.setEventCompleted(m_eventId)  	--事件完成状态
		AdvSingleBoxView.setBtnEvent(m_eventId)  		--设置按钮状态
	end
end

function create(id)
	local tbEvent = {}
	m_eventId = id
	tbEvent.onOpenBox = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			-- AudioHelper.playCommonEffect() 
			AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")
			local remainTime = AdventureModel.getRemainTimeSec(id)
			if(remainTime == 0)then 
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(4364))-- todo 国际化"船长，奇遇事件已结束"
				return
	   		end 	

	   		if(AdvSingleBoxView.getCDTime() ~= m_timeStr)then 
				require "script/module/public/ShowNotice"
				ShowNotice.showShellInfo(m_i18nString(4380))-- todo 船长，开启宝箱还需要一些时间，过段时间再看看吧！
				return
	   		end 

			local params = CCArray:create()
			params:addObject(CCInteger:create(tonumber(m_eventId)))
			RequestCenter.exploreDoEvent(fnExploreOverCall,params)
		end
	end

	local tbAdvBoxData = AdventureModel.getEventItemById(id)
	logger:debug(tbAdvBoxData)
	local signleBoxView = AdvSingleBoxView.create(tbEvent,tbAdvBoxData)
	return signleBoxView
end

-- 是否已经有打开过的宝箱
function isOpenBox( eventid )
	logger:debug("adventure data id :" .. eventid)
	local tbAdvBoxData = AdventureModel.getEventItemById(eventid)
	local tbInfo = DB_Exploration_things.getDataById(tbAdvBoxData.etid)

	local timeStr,isFinish,remainTime=TimeUtil.expireTimeString(tonumber(tbAdvBoxData.time),tonumber(tbInfo.qiyuTime))
	if (isFinish) then
		remainTime=0
	end
	if (remainTime==0) then
		return true
	end
	return false
end			