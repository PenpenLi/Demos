-- FileName: AdvQuestionCtrl.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 奇遇事件：海贼王问答控制模块
--[[TODO List]]

module("AdvQuestionCtrl", package.seeall)
require "script/module/adventure/AdvQuestionView"
require "script/network/RequestCenter"
local m_i18n = gi18n
-- UI控件引用变量 --

-- 模块局部变量 --

local tbArgs = {}
local answerId = 0
local sendAnswerId = 0
local tbEventData 

local m_eventId = 0 --服务器返回的id
local m_timeStr = "00:00:01" --时间剩最后一秒时候阻止发送协议
local m_timeStrEnd = "00:00:00"


local function init(...)
     answerId = 0
     tbEventData = {}
     m_eventId = 0
     sendAnswerId = 0
end

function destroy(...)
	package.loaded["MagicalQuestionCtrl"] = nil
end

function moduleName()
    return "MagicalQuestionCtrl"
end

-- -- 领取奖励请求回调
-- function fnSendGetRewardCallBack( cbFlag, dictData, bRet )
-- 	if(not bRet)then 
-- 		return 
-- 	end 

-- 	local tbReward = {}
-- 	local tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)

-- 	if (tonumber(tbEventData.answer)==1)then 
-- 		tbReward = tbInfo.questionReward
-- 	else 
-- 		tbReward = tbInfo.wrongReward
-- 	end 
	
-- 	LayerManager:begainRemoveUILoading() --删除屏蔽层
-- 	local tbReward = RewardUtil.parseRewards(tbReward,true) 
-- 	local layout = UIHelper.createRewardDlg(tbReward)
-- 	LayerManager.addLayoutNoScale(layout)

-- 	-- 更新按钮状态
-- 	AdvQuestionView.setButtonState(3)
-- 	AdventureModel.setEventCompleted(m_eventId)  --事件完成状态

-- end


--发送答案请求回调
function fnSendAnswerCallBack(cbFlag, dictData, bRet)
	if(not bRet)then 
		return 
	end 

	local tbReward = {}
	local strLabel = ""
	local tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)
	LayerManager:begainRemoveUILoading() --删除屏蔽层


	local function addRewardLayer( ... )
		local tbReward = {}
		local tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)
		tbReward = sendAnswerId==1 and tbInfo.questionReward or tbInfo.wrongReward 
		local tbReward = RewardUtil.parseRewards(tbReward,true) 
		local layout = UIHelper.createRewardDlg(tbReward)
		LayerManager.addLayoutNoScale(layout)
	end


	if (sendAnswerId== 1) then 
		tbReward = tbInfo.questionReward
		AdvQuestionView.addAnimation(addRewardLayer)  
	else
		addRewardLayer()

		tbReward = tbInfo.wrongReward
		local tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)  
		local tbstr = string.split(m_i18n[4370],"s")    -- "很遗憾，回答错误,正确答案是%s"  
		logger:debug(tbstr)
		local tbData = { 
			fontSize = 20,
			{str = tbstr[1],color = ccc3(0x57,0x1e,0x01)},
			{str = tbInfo.answerA,color = ccc3(0x00,0x62,0x0c)} ,
			{str = tbstr[2],color=ccc3(0x57,0x1e,0x01)}
		}

		require "script/module/public/ShowNotice"
		ShowNotice.showWithMoreLabel(tbData)
	end 


	-- 更新按钮状态
	AdventureModel.setEventCompleted(m_eventId)  --事件完成状态
	AdvQuestionView.setButtonState(2) 
end


tbArgs.onAnswer = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		
		if(AdvQuestionView.getCDTime() == m_timeStr or AdvQuestionView.getCDTime() == m_timeStrEnd )then 
			require "script/module/public/ShowNotice"
			ShowNotice.showShellInfo(m_i18n[4364])-- "船长，奇遇事件已结束"
			return
	    end 	

		if(answerId==0)then 
			ShowNotice.showShellInfo(m_i18n[4371])    --"请先选择答案！"
			return
		end 

		LayerManager:addUILoading() --添加屏蔽层
		sendAnswerId = tonumber(tbEventData.tbAnswerOrder[answerId])
		local params = CCArray:create()
		params:addObject(CCInteger:create(tonumber(m_eventId)))
		params:addObject(CCInteger:create(sendAnswerId))  --发送答案
		RequestCenter.exploreDoEvent(fnSendAnswerCallBack,params)
	end
end

tbArgs.onCheckBox = function ( sender, eventType )
	AudioHelper.playCommonEffect() 
	local tag = sender:getTag()
	if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
		answerId = tag 
	end 

	if (eventType == CHECKBOX_STATE_EVENT_UNSELECTED) then
		answerId = 0
	end
	AdvQuestionView.refreashCheckBox(answerId)
end


tbArgs.onCheckBoxLabel = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		local tag = sender:getTag()
		if ( tonumber(tag) == answerId) then 
			answerId = 0
		else 
			answerId = tag
		end 

		AdvQuestionView.refreashCheckBox(tag,true)
	end 
end


function updateCD( stime)
	AdvQuestionView.updateCD(stime)
end

-- 答案顺序随机取
function getRandomOrder( ... )
	math.randomseed(os.time())
	local data = {1,2,3}
	local tbAnswer = {}

	while(#data >0) do 
		local num = math.floor((math.random()*10000))
		num = math.mod(num,#data) + 1
		tbAnswer[#tbAnswer+1] = data[num]
		table.remove(data,num)
	end 

	return tbAnswer
end


function getRightAnwerId( ... )
	local id = 0
	for k,v in pairs(tbEventData.tbAnswerOrder) do 
		if (tonumber(v)==1) then 
			id = k
			break
		end 
	end 
	return id
end

-- 是否可答题  可以：返回true ，已经答过题或者已经领完奖：false
function isHaveAnswered( id )
	local tbData = AdventureModel.getEventItemById(id)
	if (not tbData.complete and tonumber(tbData.answer) == 0) then 
		return true
	end 
	return false
end

function create(id)
	init()
	m_eventId = id  
	tbEventData = AdventureModel.getEventItemById(id)

	if (not tbEventData.tbAnswerOrder) then 
		tbEventData.tbAnswerOrder = getRandomOrder()
	end 

	logger:debug(tbEventData.tbAnswerOrder)
	
	local  m_layMain = AdvQuestionView.create(tbArgs,tbEventData)
	return m_layMain
end