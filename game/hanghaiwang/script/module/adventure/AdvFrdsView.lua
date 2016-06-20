-- FileName: AdvFrdsView.lua
-- Author: zhangjunwu
-- Date: 2015-04-00
-- Purpose: 奇遇事件：声名远播 界面模块

module("AdvFrdsView", package.seeall)

-- UI控件引用变量 --
local m_UIMain 		= nil 
local m_BTN_BUY 	= nil 
local TFD_TIME_NUM 
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString  = gi18nString
local m_tbAddFrdInfo = {}
local m_tbEvent
local rewardInfo = {}

local nBtnEffecyTag = 1235
BTN_TYPE = {
	BTN_ADD    		= 1,
	BTN_REWARD       = 2,
	BTN_REWARDED      = 3,
}
local function init(...)

end

function destroy(...)
	package.loaded["AdvFrdsView"] = nil
end

function moduleName()
    return "AdvFrdsView"
end


-- 领奖按钮特效
local function addButtonEff( node )
	--特效资源已被删除，相关代码也注释掉
	-- local armature = UIHelper.createArmatureNode({
	-- 		filePath = "images/effect/button_long/button_long.ExportJson",
	-- 		animationName = "button_long",
	-- 		}
	-- 	)
	-- node:removeNodeByTag(nBtnEffecyTag)
	-- node:addNode(armature,1,nBtnEffecyTag)
end

function changeEtnEventBy( _state )
	--加好友
	if(_state == BTN_TYPE.BTN_ADD) then
		m_BTN_BUY:addTouchEventListener(m_tbEvent.onAddFrd)
		UIHelper.titleShadow(m_BTN_BUY, m_i18nString(4357)) --"给他面子"
	--领取奖励
	elseif(_state == BTN_TYPE.BTN_REWARD) then
		m_BTN_BUY:addTouchEventListener(m_tbEvent.onReward)
		UIHelper.titleShadow(m_BTN_BUY, m_i18nString(1315)) --"领取奖励"
		addButtonEff(m_BTN_BUY)
	--已领取
	elseif(_state == BTN_TYPE.BTN_REWARDED) then
		m_BTN_BUY:removeNodeByTag(nBtnEffecyTag)
		UIHelper.titleShadow(m_BTN_BUY,m_i18nString(4372)) --"已领取"
		m_BTN_BUY:setBright(false)
		m_BTN_BUY:setTouchEnabled(false)
		
	end

end


function getCDTime()
	return TFD_TIME_NUM:getStringValue()
end

function showRewardDlg()
	local tbInfo = RewardUtil.parseRewardsByTb(rewardInfo,true)
	local rewardVipDlg = UIHelper.createRewardDlg(tbInfo, nil, true)
	LayerManager.addLayoutNoScale(rewardVipDlg)
end

function updateCD(stime)
    TFD_TIME_NUM:setText(stime)
end

local function setFrdInfo(  )
	local TFD_LEVEL 	= m_fnGetWidget(m_UIMain,"TFD_LEVEL")
	local TFD_NAME 		= m_fnGetWidget(m_UIMain,"TFD_NAME")
	local img_icon_bg 	= m_fnGetWidget(m_UIMain,"img_icon_bg")

	TFD_NAME:setText(m_tbAddFrdInfo.uname)
	TFD_NAME:setColor(UserModel.getPotentialColor({htid = m_tbAddFrdInfo.figure})) -- zhangqi, 2015-07-28
	TFD_LEVEL:setText("Lv." .. m_tbAddFrdInfo.level)

	local playIcon = HeroUtil.createHeroIconBtnByHtid(tonumber(m_tbAddFrdInfo.figure))
	logger:debug(playIcon)
	-- playIcon:setPosition(ccp(img_icon_bg:getSize().width / 2, img_icon_bg:getSize().height / 2))
	img_icon_bg:addChild(playIcon)
end


function create(tbEvent,tbAdvFrdData)
	rewardInfo= nil 
	rewardInfo = {}
	m_tbEvent = tbEvent
	m_UIMain = g_fnLoadUI("ui/magical_thing_friend.json")
	m_UIMain:setSize(g_winSize)
	local img_bg = m_fnGetWidget(m_UIMain,"img_bg")
	img_bg:setScale(g_fScaleX)	

	local img_desc_bg = m_fnGetWidget(m_UIMain,"img_desc_bg")
	img_desc_bg:setScale(g_fScaleX)

	m_tbAddFrdInfo = tbAdvFrdData.friend
	local tbInfo = DB_Exploration_things.getDataById(tbAdvFrdData.etid)


	local IMG_MODLE = m_fnGetWidget(m_UIMain,"IMG_MODLE")
	IMG_MODLE:loadTexture("images/base/hero/body_img/".. tbInfo.thingHeroImg)

	TFD_TIME_NUM 	= m_fnGetWidget(m_UIMain,"TFD_TIME_NUM")
	UIHelper.labelNewStroke(TFD_TIME_NUM)

	local tfd_title = m_fnGetWidget(m_UIMain,"TFD_TITLE")
	tfd_title:setText(tbInfo.title)
	UIHelper.labelNewStroke(tfd_title)


	local tfd_des = m_fnGetWidget(m_UIMain,"TFD_DESC")
	tfd_des:setText(tbInfo.desc)
	UIHelper.labelNewStroke(tfd_des)

	-- local tfd_reward = m_fnGetWidget(m_UIMain,"tfd_reward")  --获得奖励
	local tfd_time = m_fnGetWidget(m_UIMain,"tfd_time") 	--剩余时间
	UIHelper.labelNewStroke(tfd_time)

	local TFD_REWARD_NAME = m_fnGetWidget(m_UIMain,"TFD_REWARD_NAME") 	--奖励道具名称
	local TFD_REWARD_NUM = m_fnGetWidget(m_UIMain,"TFD_REWARD_NUM") 	--奖励道具个数

	UIHelper.labelNewStroke(tfd_title, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_des, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_time, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(tfd_des, ccc3(0x28,0,0),2)

	UIHelper.labelNewStroke(TFD_REWARD_NAME, ccc3(0x65,0,0),2)
	UIHelper.labelNewStroke(TFD_REWARD_NUM, ccc3(0x65,0,0),2)

	require "script/module/public/RewardUtil"
	local rewardStr  = tbInfo.addFriendReward
	rewardInfo  = RewardUtil.getItemsDataByStr(rewardStr)
	logger:debug(rewardInfo) 
	TFD_REWARD_NAME:setText(rewardInfo[1].name)
	TFD_REWARD_NUM:setText("X" .. rewardInfo[1].num)

	setFrdInfo()

	m_BTN_BUY = m_fnGetWidget(m_UIMain,"BTN_BUY")
	UIHelper.titleShadow(m_BTN_BUY)
	logger:debug(tbAdvFrdData.complete)
	logger:debug(tbAdvFrdData)

	if(tbAdvFrdData.complete) then
		changeEtnEventBy(BTN_TYPE.BTN_REWARDED)
	elseif(tonumber(m_tbAddFrdInfo.status) == 0) then
		changeEtnEventBy(BTN_TYPE.BTN_ADD)
	elseif(tonumber(m_tbAddFrdInfo.status) == 1) then
		changeEtnEventBy(BTN_TYPE.BTN_REWARD)
	end
	return m_UIMain
end
