-- FileName: AdvQuestionView.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 奇遇事件：海贼王问答UI模块
--[[TODO List]]

module("AdvQuestionView", package.seeall)

-- UI控件引用变量 --
local m_layMain
-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local tbInfo = {}

local tfd_time = nil  --倒计时控件
local tbCheckBox = {}
local m_tbEventData = {}
local m_buttonState = 0  --按钮状态 1：确定 ，2:领奖  3:已领取
local m_i18n = gi18n

local tfd_answerA = nil
local tfd_answerB = nil
local tfd_answerC = nil

local nBtnefftag = 1235

local function init(...)
	tbCheckBox = {}
	tbInfo = {}
	m_tbEventData = {}
	m_buttonState = 0
end

function destroy(...)
	package.loaded["MagicalQuestionView"] = nil
end

function moduleName()
    return "MagicalQuestionView"
end

function initButton( tbEvent ,tbEventData)

	tbCheckBox[#tbCheckBox+1] = m_fnGetWidget(m_layMain,"CBX_A")
	tbCheckBox[#tbCheckBox+1] = m_fnGetWidget(m_layMain,"CBX_B")
	tbCheckBox[#tbCheckBox+1] = m_fnGetWidget(m_layMain,"CBX_C")

	for i=1,#tbCheckBox do 
		tbCheckBox[i]:setTag(i)
		tbCheckBox[i]:addEventListenerCheckBox(tbEvent.onCheckBox)
	end 

	local btn_Answer = m_fnGetWidget(m_layMain,"BTN_ANSWER")
	btn_Answer:addTouchEventListener(tbEvent.onAnswer)
	btn_Answer:setTouchEnabled(true)

	if (tbEventData.complete ) then  --事件已经完成
		setButtonState(2)
	else
		setButtonState(1)
	end 
end


function initLabel(tbArgs, tbEventData )
	--标题
	local tfd_title = m_fnGetWidget(m_layMain,"TFD_TITLE")
	tfd_title:setText(tbInfo.title)
	LabelStroke(tfd_title)

	--问题
	local tfd_question = m_fnGetWidget(m_layMain,"TFD_QUESTION")
	tfd_question:setText(tbInfo.questions)
	LabelStroke(tfd_question)

	local tbOrder = tbEventData.tbAnswerOrder
	local tb_answer = {
		tbInfo.answerA,
		tbInfo.answerB,
		tbInfo.answerC,
	}

	-- 答案A
	tfd_answerA:setText(tb_answer[tbOrder[1]])
	LabelStroke(tfd_answerA)
	tfd_answerA:setTag(1)
	tfd_answerA:addTouchEventListener(tbArgs.onCheckBoxLabel)
	tfd_answerA:setTouchEnabled(true)

	-- 答案B
	tfd_answerB:setText(tb_answer[tbOrder[2]])
	LabelStroke(tfd_answerB)
	tfd_answerB:setTag(2)
	tfd_answerB:addTouchEventListener(tbArgs.onCheckBoxLabel)
	tfd_answerB:setTouchEnabled(true)

	-- 答案C
	tfd_answerC:setText(tb_answer[tbOrder[3]])
	LabelStroke(tfd_answerC)
	tfd_answerC:setTag(3)
	tfd_answerC:addTouchEventListener(tbArgs.onCheckBoxLabel)
	tfd_answerC:setTouchEnabled(true)

	--奖励
	local tbReward = {}
	require "script/module/public/RewardUtil"
	tbReward[1] = RewardUtil.parseRewards(tbInfo.questionReward) --正确答案奖励
	tbReward[2] = RewardUtil.parseRewards(tbInfo.wrongReward)   --错误答案奖励 

	for i=1,2 do 
		local btn_item = m_fnGetWidget(m_layMain,"BTN_ITEM_BG_" .. i)
		local btn_item_name = m_layMain["tfd_item_name_" .. i]
		btn_item_name:setText(tbReward[i][1].name)
		btn_item_name:setColor(g_QulityColor[tbReward[i][1].quality])
		btn_item:addChild(tbReward[i][1].icon)
	end 
end


function updateCD(stime)
	if(tfd_time and stime)then 
		tfd_time:setText(stime)
	end 
end


-- index:选中的编号，isLabel：true代表点label响应
function refreashCheckBox( index,isLabel)
	if (isLabel) then 
		for i=1,#tbCheckBox do 
			if(i==tonumber(index))then 
				local state = tbCheckBox[i]:getSelectedState()
				tbCheckBox[i]:setSelectedState(not state)
			else 
				tbCheckBox[i]:setSelectedState(false)
			end 
		end 
	else 
		for i=1,#tbCheckBox do 
			if(i==tonumber(index))then 
				tbCheckBox[i]:setSelectedState(true)
			else 
				tbCheckBox[i]:setSelectedState(false)
			end 
		end 
	end 

end

--按钮状态 1：确定  2:已领取
function setButtonState( state )
	m_buttonState = state 
	local btn_Answer = m_fnGetWidget(m_layMain,"BTN_ANSWER")
	btn_Answer:removeNodeByTag(nBtnefftag)

	if (state==1) then 	
		btn_Answer:setTouchEnabled(true)
		UIHelper.titleShadow( btn_Answer, m_i18n[2629]) --"确定"
	elseif (state==2) then 
		UIHelper.titleShadow( btn_Answer, m_i18n[4372] )  --"已领取"
		btn_Answer:setBright(false)

		-- 选项
		for k,v in pairs(m_tbEventData.tbAnswerOrder)	do 
			if (tonumber(v)==tonumber(m_tbEventData.answer) )then 
				refreashCheckBox(k)
				break
			end 
		end 
		
		for i=1,#tbCheckBox do 
			tbCheckBox[i]:setTouchEnabled(false)
		end 
		btn_Answer:setTouchEnabled(false)
		tfd_answerA:setTouchEnabled(false)
		tfd_answerB:setTouchEnabled(false)
		tfd_answerC:setTouchEnabled(false)
	end 

end

function getButtonState( ... )
	return m_buttonState
end

function getCDTime( ... )
	return tfd_time:getStringValue()
end


-- label添加描边 2px，＃280000
function LabelStroke( label )
	UIHelper.labelNewStroke(label, ccc3(0x28,0,0),2)
end


-- "回答正确"特效
function addAnimation(callback )
	armature1 = UIHelper.createArmatureNode({
			filePath = "images/effect/drop_treasure/fall_box_txt_92/fall_box_txt_92.ExportJson",
			animationName = "fall_box_txt",
			loop = 0,
			fnMovementCall=function()
				armature1:removeFromParentAndCleanup(true)
				if (callback) then 
					callback()
				end 
			end
			}
		)

	for i=1,6 do
		local bone = armature1:getBone("fall_box_txt_" .. i)
		if (i==1 or i==6) then 
			bone:setOpacity(0)
		else 
			local ccskin = CCSkin:create("images/effect/drop_treasure/adventure/answer_txt_" .. (i-1) .. ".png")
			bone:addDisplay(ccskin,0)
		end 
	end 

	m_layMain:addNode(armature1)
	local size = m_layMain:getSize()
	armature1:setPosition(ccp(size.width/2,size.height/2))
end

-- 领奖按钮特效
-- function addButtonEff( node,tag )
-- 	local armature = UIHelper.createArmatureNode({
-- 			filePath = "images/effect/button_long/button_long.ExportJson",
-- 			animationName = "button_long",
-- 			}
-- 		)
-- 	node:removeNodeByTag(tag)
-- 	node:addNode(armature,1,tag)
-- end

function create(tbArgs,tbEventData)
	init()

	m_tbEventData = tbEventData

	logger:debug(tbEventData)
	--获取对应事件的本地数据
	tbInfo = DB_Exploration_things.getDataById(tbEventData.etid)

	m_layMain = g_fnLoadUI("ui/magical_thing_question.json")

	local img_bg = m_fnGetWidget(m_layMain,"img_bg")
	img_bg:setScale(g_fScaleX)

    tfd_time = m_fnGetWidget(m_layMain,"TFD_TIME_NUM")
	LabelStroke(tfd_time)

	local IMG_MODLE = m_fnGetWidget(m_layMain,"IMG_MODLE")  --人物形象
	IMG_MODLE:loadTexture("images/base/hero/body_img/" .. tbInfo.thingHeroImg)

    local label_time = m_fnGetWidget(m_layMain,"tfd_time")
    LabelStroke(label_time)

   	tfd_answerA = m_fnGetWidget(m_layMain,"TFD_ANSWER_A")
   	tfd_answerB = m_fnGetWidget(m_layMain,"TFD_ANSWER_B")
	tfd_answerC = m_fnGetWidget(m_layMain,"TFD_ANSWER_C")

	initLabel(tbArgs,tbEventData)

	initButton(tbArgs,tbEventData)
	return m_layMain
end




