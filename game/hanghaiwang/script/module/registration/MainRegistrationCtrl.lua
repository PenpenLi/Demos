-- FileName: MainRegistrationCtrl.lua
-- Author: lizy
-- Date: 2014-04-00
-- Purpose: 每日签到
--[[TODO List]]

module("MainRegistrationCtrl", package.seeall)

-- UI控件引用变量 --

require "script/module/registration/MainRegistrationView"
require "script/network/RequestCenter"
require "script/module/registration/MainRegistrationData"
require "db/i18n"

-- 模块局部变量 --

local m_todayReward
local m_today 


local function init(...)
end

function destroy(...)
	package.loaded["MainRegistrationCtrl"] = nil
end

function moduleName()
    return "MainRegistrationCtrl"
end

function create(...)
    getSignInfo()
end

function resetView( ... )
	if (not SwitchModel.getSwitchOpenState(ksSwitchSignIn)) then
		return
	end
	local function getInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			if (not table.isEmpty(dictData.ret)) then 
				DataCache.setNorSignCurInfo(dictData.ret)
				local signInfo = dictData.ret.reward_num
				freshRegistrationData(signInfo)
				require "script/module/wonderfulActivity/MainWonderfulActCtrl"
				if(MainRegistrationView.getMainLay()) then
					m_todayReward = nil
					m_today = nil
					logger:debug("wm----resetView")
					MainRegistrationView.freshAll()
					MainRegistrationView.setContentOffset1()
				elseif(LayerManager.curModuleName() == MainWonderfulActCtrl.moduleName()) then
				  	require "script/module/wonderfulActivity/WonderfulActModel"
				  	local pShow = fnCheckRegistrationTip()		
			  	  	WonderfulActModel.tbBtnActList.registration:setVisible(pShow)
				end
			end  
		end 
	end
	RequestCenter.sign_getNormalInfo(getInfoCallback , nil ) 
end

function createView( ... )
	if(not MainRegistrationView.getMainLay()) then
		local layout = MainRegistrationView.create()  
		MainWonderfulActCtrl.addLayChild(layout)   
		-- LayerManager.addLayout(layout)
		logger:debug("wm----createView")
	else
		MainRegistrationView.freshAll()
		logger:debug("wm----resetView")
	end

	MainRegistrationView.setContentOffset1()
end

local function onDlgClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		
		LayerManager.removeLayout()
		 
	end
end

function freshRegistrationData( signInfo )
	if(not signInfo) then
		local signInfo = #(DataCache.getNorSignCurInfo().va_normalsign)
	end

	MainRegistrationData.setSignInfo(signInfo)
	MainRegistrationData.setSignNum(signInfo)
	MainRegistrationData.setSignInNum(DataCache.getNorSignCurInfo().sign_num)		
end

function getSignInfo_callback( cbFlag, dictData, bRet )
	if (bRet) then 
		if (not table.isEmpty(dictData.ret)) then 
			DataCache.setNorSignCurInfo(dictData.ret)
			local signInfo = dictData.ret.reward_num
			freshRegistrationData(signInfo)
			createView()
		end 
	end 
end

-- 获取签到的信息
function getSignInfo( ... )
  	if (not DataCache.getNorSignCurInfo() or DataCache.getNorSignCurInfo().va_normalsign == nil ) then 
	    RequestCenter.sign_getNormalInfo(getSignInfo_callback , nil )
	else 
	 	freshRegistrationData()		 
		createView()
	end  
end


--获取配置里当天的奖励。配置天数可能小于当月天数。
function fnGetTodayReward( ... )
	local pToday = MainRegistrationView.compareTime()
	local pDay = math.modf((tonumber(m_today) or 0)/1000000)
	local pDay2 = math.modf((tonumber(pToday) or 0)/1000000)

	if(pDay == pDay2 and m_todayReward) then
		return m_todayReward
	end
	m_today = pToday

	local signInfo = DataCache.getNorSignCurInfo()
	if(not signInfo) then
		return nil
	end

	local signs = DB_Sign.getDataById(1) 
    local special_awards

	local id = MainRegistrationView.getSignIdFromStart()
    signs = DB_Sign.getDataById(id) 

    local special_awards = signs.special_awards
    local special = string.split(special_awards,",")  
    local daysReward = signs.days_reward
    local daysRewardArr = string.split(daysReward, ",") 
    local pSignNum = tonumber(signInfo.sign_num) or -1
    for i=1,#daysRewardArr do
		local reward = string.split(daysRewardArr[i],"|")  
		if(pSignNum == tonumber(reward[1])) then
			m_todayReward = reward
			return m_todayReward
		end
    end
    return nil
end


function fnCheckRegistrationTip( ... )
	require "script/model/DataCache"

	if (not SwitchModel.getSwitchOpenState(ksSwitchSignIn)) then
		return  false
	end

	local signInfo = DataCache.getNorSignCurInfo()
	if(not signInfo) then
		return false
	end 

	local function refreashRedTip( ... )
		local pReward = fnGetTodayReward()
		if(not pReward ) then
			return false
		end

		-- 配置天数和当月天数不同
		if(tonumber(signInfo.sign_num) > tonumber(signInfo.reward_num)) then
			return true
		end

		local pBei = tonumber(pReward[4]) or 0
		if(pBei <= 0) then
			return false
		end
		local pLast = tonumber(signInfo.last_vip) or 0
		local pL = tonumber(pReward[3]) or 0
		local mVip =  tonumber(UserModel.getVipLevel()) or 0

		local isGetVip = pL > pLast and pL <= mVip
		if(isGetVip) then
			return true
		end
		return false
	end

	local ret = refreashRedTip()
	return ret
end
