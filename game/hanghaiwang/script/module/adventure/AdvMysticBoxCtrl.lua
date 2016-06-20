-- FileName: AdvMysticBoxCtrl.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 奇遇事件：神秘宝箱控制模块
--[[TODO List]]

module("AdvMysticBoxCtrl", package.seeall)
require "script/module/adventure/AdvMysticBoxView"
require "script/network/RequestCenter"
require "script/utils/LuaUtil"
local m_i18n = gi18n
-- UI控件引用变量 --

-- 模块局部变量 --

local m_eventId = 0  --用于更新事件完成的id、
local m_timeStr = "00:00:01"
local m_timeStrEnd = "00:00:00"
local tbArgs = {}
local boxPrice = {}

local function init(...)
	m_eventId = 0
	boxPrice = {}
end

function destroy(...)
	package.loaded["AdvMysticBoxCtrl"] = nil
end

function moduleName()
    return "AdvMysticBoxCtrl"
end

-- 开启宝箱 服务器返回的宝箱id为： 0 1 2 AdvMysticBoxView中设置的三个宝箱tag为0，1，2
tbArgs.onOpenBox = function (sender, eventType)
	
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")
		if(AdvMysticBoxView.getCDTime() == m_timeStr or AdvMysticBoxView.getCDTime() == m_timeStrEnd)then 
			require "script/module/public/ShowNotice"
			ShowNotice.showShellInfo(m_i18n[4364])-- "船长，奇遇事件已结束"
			return
	    end 

	    local openedNum = table.count(tbEventData.box) --当前已经打开的数目
		local tag = sender:getTag()

		local function fnRequestCallBack(cbFlag, dictData, bRet)
			if (not bRet) then 
				return false
			end

			-- if (openedNum == 0) then 
			-- 	AdventureModel.setEventRedCompleted(m_eventId) --去掉红点
			-- end 

			if (openedNum>0) then 
				UserModel.addGoldNumber(-boxPrice[openedNum]) --扣除开箱子需要的金币
			end 

			LayerManager:begainRemoveUILoading() --删除屏蔽层
			local tbReward = ItemDropUtil.getAdvDropItem(dictData.ret,true) 
			local dlg = UIHelper.createRewardDlg(tbReward)
			LayerManager.addLayoutNoScale(dlg)

			AdvMysticBoxView.refreashBoxState(tag+1)
			-- 更新DataCache ，神秘宝箱事件box内容
			table.insert(tbEventData.box,tag)
			openedNum = openedNum + 1

			if(openedNum==3)then 
				AdventureModel.setEventCompleted(m_eventId)  --事件完成状态
			end
		end


		--免费宝箱 发给服务器的id＝0，
		if(openedNum==0)then 
			LayerManager:addUILoading() --添加屏蔽层
			local params = CCArray:create()
			params:addObject(CCInteger:create(tonumber(m_eventId)))
			params:addObject(CCInteger:create(tonumber(openedNum)))
			RequestCenter.exploreDoEvent(fnRequestCallBack,params)
		else 
			-- todo 国际化
			local  str = string.format(m_i18n[4373], tonumber(boxPrice[openedNum]) )   --"开启宝箱需要花费%d金币,是否开启?"
			local layout = UIHelper.createCommonDlg( str, nil, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()

					if (UserModel.getGoldNumber() < tonumber(boxPrice[openedNum]) ) then
						LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
						return
					end
					
					LayerManager:addUILoading() --添加屏蔽层
					local params = CCArray:create()
					params:addObject(CCInteger:create(tonumber(m_eventId)))
					params:addObject(CCInteger:create(tonumber(openedNum)))
					RequestCenter.exploreDoEvent(fnRequestCallBack,params)
				end
			end, 2, nil )
			LayerManager.addLayout(layout)
		end 
	end
end

-- 是否已经有打开过的宝箱
function isOpenBox( eventid )
	local tbData = AdventureModel.getEventItemById(eventid)
	local num = table.count(tbData.box) --当前已经打开的数目
	if (num > 0) then 
		return false
	end 

	return true
end


function updateCD( stime )
	AdvMysticBoxView.updateCD(stime)
end

function create(id)
	init()

	m_eventId = id
	tbEventData = AdventureModel.getEventItemById(id)

	-- 开箱子需要的金币
	local tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)
    boxPrice = lua_string_split(tbInfo.boxPrice,"|")

	logger:debug("奇遇数据")
	logger:debug(tbEventData)
	logger:debug(boxPrice)

	local m_layMain = AdvMysticBoxView.create(tbEventData,tbArgs)
	return m_layMain
end
