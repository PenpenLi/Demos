-- FileName: AdBattleSingleEventCtrl.lua
-- Author: liweidong
-- Date: 2015-04-11
-- Purpose: 非继承血量事件ctrl
--[[TODO List]]

module("AdBattleSingleEventCtrl", package.seeall)

require "script/module/adventure/AdBatlleEventModel"

-- UI控件引用变量 --
local layoutMain=nil
local mainLayout=nil
-- 模块局部变量 --
local eventInfoId=nil
local eventInfoData=nil
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["AdBattleSingleEventCtrl"] = nil
end

function moduleName()
    return "AdBattleSingleEventCtrl"
end

function initUI()
	mainLayout.img_bg:setScale(g_fScaleX)
	--描边
	UIHelper.labelNewStroke( mainLayout.TFD_TITLE, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayout.tfd_time, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayout.TFD_TIME_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayout.tfd_cost, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayout.TFD_COST_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayout.TFD_DESC, ccc3(0x28,0x00,0x00), 2 )
	mainLayout.img_desc_bg:setScale(g_fScaleX)
	
	local m_fnGetWidget=g_fnGetWidgetByName
	local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)
	local eventName = m_fnGetWidget(layoutMain, "TFD_TITLE")
	eventName:setText(eventDb.title)
	local eventDesc = m_fnGetWidget(layoutMain, "TFD_DESC")
	eventDesc:setText(eventDb.desc)
	local bossCost = m_fnGetWidget(layoutMain, "TFD_COST_NUM")
	bossCost:setText(eventDb.fightCost)
	local BossImg = m_fnGetWidget(layoutMain, "IMG_MODLE")
	BossImg:loadTexture("images/base/hero/body_img/"..eventDb.thingHeroImg)

	-- 概率掉落物品预览 fightRewardView
	local tbItem = {} -- {{btn = UIButton, sName = itemName}, ...}
	for i, itemId in ipairs(string.strsplit(eventDb.fightRewardView, "|")) do
		local item, itemData = {}, nil
		item.btn, itemData = ItemUtil.createBtnByTemplateId(itemId, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(itemId)
			end
		end)
		item.sName = itemData.name
		item.quality = itemData.quality
		tbItem[i] = item
	end

	local labBelly = m_fnGetWidget(layoutMain, "TFD_BELLY") -- 贝里数量
	labBelly:setText(eventDb.coin)
	local labExp = m_fnGetWidget(layoutMain, "TFD_EXP") -- 经验卡数量
	labExp:setText(eventDb.exp*UserModel.getHeroLevel())
	-- local _,nExpCard = string.match(eventDb.exp_card, "(.*)|(.*)")
	-- local labExpCard = m_fnGetWidget(layoutMain, "TFD_EXP_SHADOW") -- 经验卡数量
	-- labExpCard:setText(nExpCard)

	-- 物品图标 和 名称
	local itemCount = 0
	for i, itemIcon in ipairs(tbItem) do
		local layItemIcon = m_fnGetWidget(layoutMain, "LAY_ITEM_BG_" .. i)
		local szIcon = layItemIcon:getSize()
		itemIcon.btn:setPosition(ccp(szIcon.width/2, szIcon.height/2))
		layItemIcon:addChild(itemIcon.btn)
		-- 物品名称
		local labItemName = m_fnGetWidget(layoutMain, "TFD_ITEM_NAME_" .. i)
		labItemName:setText(itemIcon.sName)
		labItemName:setColor(g_QulityColor[itemIcon.quality])
		itemCount = i
	end
	-- 隐藏多余的物品图标layout和name
	for i = itemCount + 1, 3 do
		local layItemIcon = m_fnGetWidget(layoutMain, "LAY_ITEM_BG_" .. i)
		layItemIcon:setEnabled(false)
		local labItemName = m_fnGetWidget(layoutMain, "TFD_ITEM_NAME_" .. i)
		labItemName:setEnabled(false)
	end
end
--更新UI
function updateUI()
	local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)
	--local bloodLoad = g_fnGetWidgetByName(layoutMain, "LOAD_PROGRESS")
	if (eventInfoData.boss) then
		local nPercent,resetStatus=getBloodAndResetStatus()
		--bloodLoad:setPercent((nPercent > 100) and 100 or nPercent)
		local fightBtn = g_fnGetWidgetByName(layoutMain, "BTN_FIGHT")
		if (resetStatus) then
			UIHelper.titleShadow(fightBtn, m_i18n[4377]) --TODO "重置"
			layoutMain.IMG_ALREADY:setVisible(true)
			UIHelper.setWidgetGray(layoutMain.IMG_MODLE,true)
			if (eventInfoData.complete) then
				UIHelper.setWidgetGray(fightBtn,true)
				UIHelper.titleShadow(fightBtn, m_i18n[4381]) --TODO "无重置次数"
			end
			-- AdventureModel.setEventRedCompleted(eventInfoId) --去掉红点
			if (eventDb.beaten_img) then
				layoutMain.IMG_MODLE:loadTexture("images/base/hero/body_img/"..eventDb.beaten_img)
			end
		else
			UIHelper.titleShadow(fightBtn, m_i18n[4378]) --TODO"发起挑战"
			layoutMain.IMG_ALREADY:setVisible(false)
			UIHelper.setWidgetGray(layoutMain.IMG_MODLE,false)
			-- AdventureModel.setEventRedNotCompleted(eventInfoId) --显示红点
			if (eventDb.beaten_img) then
				layoutMain.IMG_MODLE:loadTexture("images/base/hero/body_img/"..eventDb.thingHeroImg)
			end
		end
	end
end
--判断当前数据是否需要重置
function getBloodAndResetStatus()
	local nPercent=0
	local resetStatus=true
	if (tonumber(eventInfoData.boss.currHp)==tonumber(eventInfoData.boss.maxHp) and tonumber(eventInfoData.boss.maxHp)==0) then
		nPercent = 100
		resetStatus=false
	else
		nPercent = eventInfoData.boss.currHp/eventInfoData.boss.maxHp*100
		if (tonumber(eventInfoData.boss.currHp)<=0) then
			resetStatus=true
		else
			resetStatus=false
		end
	end
	return nPercent,resetStatus
end
--战斗模块回调方法
function onBattleResult(data)
	if (data.atk.appraisal=="F") then
		return battleLose()
	else
		return battleWin(data)
	end
	updateUI()
end
--调用通用活动副本失败面板
function battleLose()
	local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)
	require "script/module/copy/copyWin"
	copyWin.battalCopyType=4--结算面板类型
	require "script/module/copy/copyLose"
	local lose = copyLose.create( eventDb.Stronghold, 1 )
	return lose
end
--调用通用活动副本胜利面板 ,tbReward__：获得的奖励（table）
function battleWin(tbReward__)
	if (AdBatlleEventModel.getBuyTimesRemainNum(eventInfoData)<=0) then
		AdventureModel.setEventCompleted(eventInfoId)
	end
	require "script/module/copy/copyWin"
	copyWin.battalCopyType=4 --结算面板类型
	copyWin.isHaveTreasure=false

	local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)

	--组合数据，服务器返回数据和copyWin不统一
	if (tbReward__.exp==nil) then
		tbReward__.exp=eventDb.exp*UserModel.getHeroLevel()
	end
	if (UserModel.hasReachedMaxLevel()) then
		tbReward__.exp=0
	end

	if (tbReward__.silver==nil) then
		tbReward__.silver=eventDb.coin
	end
	local tbRewardItem = {}
	if (tbReward__.item) then
		for id,val in pairs(tbReward__.item) do
			local item = {item_template_id=id,item_num=tonumber(val)}
			table.insert(tbRewardItem,item)
		end
	end
	if (tbReward__.treasureFrag) then
		for id,val in pairs(tbReward__.treasureFrag) do
			local item = {item_template_id=id,item_num=tonumber(val)}
			table.insert(tbRewardItem,item)
		end
	end
	if (tbReward__.heroFrag) then
		for id,val in pairs(tbReward__.heroFrag) do
			local item = {item_template_id=id,item_num=tonumber(val)}
			table.insert(tbRewardItem,item)
		end
	end
	local tbRewardHero = {}
	if (tbReward__.hero) then
		for id,val in pairs(tbReward__.hero) do
			local item = {htid=id,item_num=tonumber(val)}
			table.insert(tbRewardHero,item)
		end
	end
	tbReward__.item=tbRewardItem
	tbReward__.hero=tbRewardHero

	UserModel.addEnergyValue(-1*tonumber(eventDb.fightCost)) -- 减少体力
	updateUI()  --更新UI

	local win = copyWin.create(eventDb.Stronghold,1,0, tbReward__)
	return win
end
--发起挑战返回数据
function onBattleCallBack( cbFlag, dictData, bRet )
	if(dictData.ret~=nil and dictData.err=="ok")then
		logger:debug("fight return:")
		logger:debug(dictData)
		local data = dictData.ret.atk
		AdBatlleEventModel.setBossBlood(eventInfoData,data.currHp,data.maxHp)
		AdBatlleEventModel.setBattleType(2)
		-- updateUI()
		local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)
		logger:debug(eventDb.Stronghold)
		require "script/battle/BattleModule"
		BattleModule.playAdventure( eventDb.Stronghold,1,data.fightRet,function() end,dictData.ret)
		--onBattleResult(dictData.ret)
	end
end
--重置挑战返回数据
function onResetCallBack( cbFlag, dictData, bRet )
	if(dictData.ret~=nil and dictData.err=="ok")then
		logger:debug("fight return:")
		logger:debug(dictData)
		UserModel.addGoldNumber(-AdBatlleEventModel.getBuyTimesGold(eventInfoData)) -- 成功扣金币
		AdBatlleEventModel.resetBattle(eventInfoData)
		updateUI()
	end
end
--发起挑战或重置
function onclickFight( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	local remainTime,_=AdventureModel.getRemainTimeSec(eventInfoId)
	if (remainTime<=0) then
		ShowNotice.showShellInfo(m_i18n[4364]) --"船长，奇遇事件已结束"
		return
	end
	local _,resetStatus=getBloodAndResetStatus()
	--重置次数
	if (resetStatus) then
		if (AdBatlleEventModel.getBuyTimesRemainNum(eventInfoData)<=0) then
			-- ShowNotice.showShellInfo(m_i18n[4376]) --"重置次数已达上限") --TODO
			return
		end
		local needGold=AdBatlleEventModel.getBuyTimesGold(eventInfoData)
		local layout = UIHelper.createCommonDlg( string.format(m_i18n[4368],needGold), nil, function ( sender, eventType ) --"花费 金币"..needGold .." 是重置战斗"
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
					if (UserModel.getGoldNumber() < needGold ) then
						LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
						return
					end
					local tbRpcArgs = {tonumber(eventInfoId),1}
					RequestCenter.exploreDoEvent(onResetCallBack, Network.argsHandlerOfTable(tbRpcArgs))
				end
			end, 2, nil )
		LayerManager.addLayout(layout)
		return
	end
	--判断体力
	local eventDb=DB_Exploration_things.getDataById(eventInfoData.etid)
	if (UserModel.getEnergyValue()<tonumber(eventDb.fightCost)) then
		require "script/module/copy/copyUsePills"
		LayerManager.addLayout(copyUsePills.create())
		return
	end
	local tbRpcArgs = {tonumber(eventInfoId),0}
	RequestCenter.exploreDoEvent(onBattleCallBack, Network.argsHandlerOfTable(tbRpcArgs))
end

--id事件id 不是db中的事件id，是由服务器返回的id 返回一个Layout
function create(id)
	eventInfoId=id
	eventInfoData=AdventureModel.getEventItemById(eventInfoId)
	--主背景UI
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			)
		mainLayout = g_fnLoadUI("ui/magical_thing_hero_nor.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local fightBtn = g_fnGetWidgetByName(layoutMain, "BTN_FIGHT")
		fightBtn:addTouchEventListener(onclickFight)
		initUI()
		updateCD() --初始化时刷新一次时间
		updateUI()
	end
	return layoutMain
end
--用于刷新过期时间，供主界面调用
function updateCD()
	local tiemNum = g_fnGetWidgetByName(layoutMain,"TFD_TIME_NUM")
	local _,timeStr=AdventureModel.getRemainTimeSec(eventInfoId)
	tiemNum:setText(timeStr)
end