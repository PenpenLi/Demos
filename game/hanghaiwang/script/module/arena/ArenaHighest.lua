-- FileName: ArenaHighest.lua
-- Author: huxiaozhou
-- Date: 2014-12-15
-- Purpose: 王者对决 战斗结算面板
--[[TODO List]]
-- /


module("ArenaHighest", package.seeall)
require "script/battle/notification/EventBus"

local arena_highest_json = "ui/arena_highest.json"
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_mainWidget = nil

local  tbLoser = {}
local  tbWinner = {}
local  tbTotal = {}
local animationTime = 1.3

local tbBattleData = {}
local tbUid = {}


local function init(...)
	tbLoser = {}
	tbWinner = {}
	tbData = {}
end

function destroy(...)
	package.loaded["ArenaHighest"] = nil
end

function moduleName()
    return "ArenaHighest"
end

local function labStroke( label, strText )
	UIHelper.labelAddNewStroke(label, strText, ccc3(0x45,0x05,0x05))
	label:setText(strText)
end

-- 2016-02-22 yucong
-- 是否隐藏两个查看阵容按钮
-- 当从排行榜、竞技场的查看阵容里，点击切磋时，不显示查看阵容按钮，防止出现两个MainFormation，暂做记录，之后大改为[module => class] 
function isHideFormation( ... )
	local needHideModules = {"MainRankView", "ArenaCtrl"}
	local curModuleName = LayerManager.curModuleName()
	logger:debug("CurName:"..curModuleName)
	for k, moduleName in pairs(needHideModules) do
		if (curModuleName == moduleName) then
			return true
		end
	end
	return false
end

-- 加载UI
function loadUI(  )
	for i=1,6 do
		local imgLoser = m_fnGetWidget(m_mainWidget, "IMG_LOSER" .. i)
		table.insert(tbLoser, imgLoser)
	end

	for i=1,6 do
		local imgWinner = m_fnGetWidget(m_mainWidget, "IMG_WINNER" .. i)
		table.insert(tbWinner, imgWinner)
	end

	if (tbUid.battleData) then 
		local maskLay = CCLayerColor:create(ccc4(0,0,0,255))
		m_mainWidget.LAY_MAIN:addNode(maskLay)
		maskLay:setZOrder(-1)
	end

	if (tbUid.battleData) then
		m_mainWidget.img_title_txt:setVisible(false)
		m_mainWidget.img_title_txt2:setVisible(true)
	else
		m_mainWidget.img_title_txt:setVisible(true)
		m_mainWidget.img_title_txt2:setVisible(false)
	end


	if (tbUid.mInIt) then
		m_mainWidget.img_loser_title:setVisible(false)
		m_mainWidget.img_winner_title:setVisible(false)
		m_mainWidget.img_loser_title2:setVisible(true)
		m_mainWidget.img_winner_title2:setVisible(true)
	else
		m_mainWidget.img_loser_title:setVisible(true)
		m_mainWidget.img_winner_title:setVisible(true)
		m_mainWidget.img_loser_title2:setVisible(false)
		m_mainWidget.img_winner_title2:setVisible(false)
	end

	loadDataUI()
	bindingBtnFun()
end

local function setTouchEnabled(enable)
	local BTN_WINNER_FORMATION = m_fnGetWidget(m_mainWidget, "BTN_WINNER_FORMATION")
	local BTN_LOSER_FORMATION = m_fnGetWidget(m_mainWidget, "BTN_LOSER_FORMATION")
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	local BTN_RERUN = m_fnGetWidget(m_mainWidget, "BTN_RERUN")
	BTN_WINNER_FORMATION:setTouchEnabled(enable)
	BTN_LOSER_FORMATION:setTouchEnabled(enable)
	BTN_CLOSE:setTouchEnabled(enable)
	BTN_RERUN:setTouchEnabled(enable)
	-- 2016-02-22 yucong
	-- 防止出现两个阵容界面
	if (isHideFormation()) then
		BTN_WINNER_FORMATION:setVisible(false)
		BTN_WINNER_FORMATION:setTouchEnabled(false)
		BTN_LOSER_FORMATION:setVisible(false)
		BTN_LOSER_FORMATION:setTouchEnabled(false)
	end
end


-- 绑定按钮事件
function bindingBtnFun( )
	local BTN_WINNER_FORMATION = m_fnGetWidget(m_mainWidget, "BTN_WINNER_FORMATION")
	local BTN_LOSER_FORMATION = m_fnGetWidget(m_mainWidget, "BTN_LOSER_FORMATION")
	local BTN_CLOSE = m_fnGetWidget(m_mainWidget, "BTN_CLOSE")
	local BTN_RERUN = m_fnGetWidget(m_mainWidget, "BTN_RERUN")

	UIHelper.titleShadow(BTN_WINNER_FORMATION, m_i18n[2918])
	UIHelper.titleShadow(BTN_LOSER_FORMATION, m_i18n[2918])

	UIHelper.titleShadow(BTN_CLOSE, m_i18n[1019])
	UIHelper.titleShadow(BTN_RERUN, m_i18n[2229])



	if (tbUid.attack_isplayer==false) then   --modify by yangna 2016.2.23 兼容分享战报
		BTN_WINNER_FORMATION:setTouchEnabled(false)
		BTN_WINNER_FORMATION:setGray(true)
	else 
		BTN_WINNER_FORMATION:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				require "script/module/formation/FormationCtrl"
				if tbUid.attacker_server_id then -- 跨服查看对方阵容
					WAService.getFighterDetail(tbUid.attacker_server_id, tbUid.attacker_pid, FormationCtrl.loadDiffServerFormation)
				else
					FormationCtrl.loadFormationWithUid(tbUid.attack_uid)
				end
			end	
		end)
	end 


	if (tbUid.defend_isplayer==false) then       --modify by yangna 2016.2.23 兼容分享战报
		BTN_LOSER_FORMATION:setTouchEnabled(false)
		BTN_LOSER_FORMATION:setGray(true)
	else 
		if ((tbUid.defend_armyId == nil) or (tbUid.defend_armyId == "0")) then
			BTN_LOSER_FORMATION:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/formation/FormationCtrl"

					if tbUid.defender_server_id then -- 跨服查看对方阵容
						WAService.getFighterDetail(tbUid.defender_server_id, tbUid.defender_pid, FormationCtrl.loadDiffServerFormation)
					else
						FormationCtrl.loadFormationWithUid(tbUid.defend_uid)
					end
				end	
			end)
		else
			BTN_LOSER_FORMATION:setEnabled(false)
		end
	end 



	BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState() 
			AudioHelper.playBackEffect()
			if (tbUid.battleData) then
				LayerManager.removeLayout()
			else
				EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			end
			AudioHelper.playMainMusic()
			-- AudioHelper.playSceneMusic("fight_easy.mp3")
		end	
	end)
	BTN_RERUN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (tbUid.battleData) then
				LayerManager.removeLayout()
			end
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD)
		end	
	end)
end



-- 往UI中填充数据
function loadDataUI(  )
	local team1Count = table.count(tbBattleData.team1)
	logger:debug("team1Count = %s", team1Count)
	setTouchEnabled(false)
	local schedulCount = 0
	for i,widgetWinner in ipairs(tbWinner or {}) do
		if i <= team1Count then
			local team1Usr = tbBattleData.team1[i]
			local htid = team1Usr.htid
			local heroInfo = HeroUtil.getHeroLocalInfoByHtid(htid)
			local bgFile = "images/base/potential/officer_" .. heroInfo.potential .. ".png"

			local  IMG_WINNER_BAR = m_fnGetWidget(widgetWinner, "IMG_WINNER" .. i .. "_BAR") 
			local IMG_WINNER_TREAT = m_fnGetWidget(widgetWinner, "IMG_WINNER" .. i .. "_TREAT")


			local IMG_WINNER_PHOTO = m_fnGetWidget(widgetWinner, "IMG_WINNER" .. i .. "_PHOTO")
			widgetWinner:loadTexture(bgFile)
			IMG_WINNER_PHOTO:loadTexture(HeroUtil.getHeroIconImgByHTID(htid))



			local LOAD_WINNER = m_fnGetWidget(widgetWinner, "LOAD_WINNER" .. i)

			LOAD_WINNER:setPercent(0)

			

			local TFD_WINNER = m_fnGetWidget(widgetWinner, "TFD_WINNER" .. i) -- 2015-09-28
			labStroke(TFD_WINNER, team1Usr.reduceHP)
			local schedulId = nil
			local number = 0
			local function updateLabnWinner(  )
				local team1ReduceHp = tonumber(team1Usr.reduceHP)
				if(number ~= nil and number < team1ReduceHp)then
					number = number + math.ceil(team1ReduceHp/animationTime/30)
					local nPercent = number / tbTotal.teamReduceHP * 100
					LOAD_WINNER:setPercent((nPercent > 100) and 100 or nPercent)
				else
					logger:debug("schedulId = %s", schedulId)
					if schedulId ~= nil then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulId)
						schdulId = nil
						schedulCount = schedulCount - 1
						if schedulCount == 0 then
							setTouchEnabled(true)
						end
					end

					local nPercent = team1Usr.reduceHP / tbTotal.teamReduceHP * 100
					LOAD_WINNER:setPercent((nPercent > 100) and 100 or nPercent)
				end
			end

			if tonumber(team1Usr.reduceHP) == 0 then
				IMG_WINNER_BAR:removeFromParent()
			else
				schedulCount = schedulCount + 1
				schedulId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLabnWinner,1/60, false)
			end


			local LOAD_WINNER_TREAT = m_fnGetWidget(widgetWinner, "LOAD_WINNER" .. i .. "_TREAT")

			local nPercent = team1Usr.addHP / tbTotal.teamReduceHP * 100
			LOAD_WINNER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)

			local TFD_WINNER_TREAT = m_fnGetWidget(widgetWinner, "TFD_WINNER".. i .. "_TREAT") -- 2015-09-28
			labStroke(TFD_WINNER_TREAT, team1Usr.addHP)

			local schedulIdAdd = nil
			local number = 0
			local function updateLabnWinnerAdd(  )
				local team1AddHp = tonumber(team1Usr.addHP)
				if(number ~= nil and number < team1AddHp)then
					number = number + math.ceil(team1AddHp/animationTime/30)
					local nPercent = number / tbTotal.teamReduceHP * 100
					LOAD_WINNER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)
				else
					logger:debug("schedulIdAdd = %s", schedulIdAdd)
					if schedulIdAdd ~= nil then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulIdAdd)
						schedulIdAdd = nil
						schedulCount = schedulCount - 1
						if schedulCount == 0 then
							setTouchEnabled(true)
						end
					end

					local nPercent = team1Usr.addHP / tbTotal.teamReduceHP * 100
					LOAD_WINNER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)
				end
			end

			if tonumber(team1Usr.addHP) == 0 then
				IMG_WINNER_TREAT:removeFromParent()
			else
				schedulCount = schedulCount + 1
				schedulIdAdd = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLabnWinnerAdd,1/60, false)
			end

		else
			widgetWinner:removeFromParent()
		end
	end

	local team2Count = table.count(tbBattleData.team2)

	for i,widgetLoser in ipairs(tbLoser or {}) do
		if i<= team2Count then
			local team2Usr = tbBattleData.team2[i]
			local htid = team2Usr.htid
			local heroInfo = HeroUtil.getHeroLocalInfoByHtid(htid)
			local bgFile = "images/base/potential/officer_" .. heroInfo.potential .. ".png"
			local IMG_LOSER_PHOTO = m_fnGetWidget(widgetLoser, "IMG_LOSER" .. i .. "_PHOTO")
			widgetLoser:loadTexture(bgFile)
			IMG_LOSER_PHOTO:loadTexture(HeroUtil.getHeroIconImgByHTID(htid))

			local LOAD_LOSER = m_fnGetWidget(widgetLoser, "LOAD_LOSER" .. i)

			local nPercent = team2Usr.reduceHP / tbTotal.teamReduceHP * 100
			LOAD_LOSER:setPercent((nPercent > 100) and 100 or nPercent)



			local TFD_LOSER = m_fnGetWidget(widgetLoser, "TFD_LOSER" .. i) -- 2015-09-28
			labStroke(TFD_LOSER, team2Usr.reduceHP) 
			local LOAD_LOSER_TREAT = m_fnGetWidget(widgetLoser, "LOAD_LOSER" .. i .. "_TREAT")

			local nPercent = team2Usr.addHP / tbTotal.teamReduceHP * 100
			LOAD_LOSER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)

			local TFD_LOSER_TREAT = m_fnGetWidget(widgetLoser, "TFD_LOSER".. i .. "_TREAT") -- 2015-09-28
			labStroke(TFD_LOSER_TREAT, team2Usr.addHP) 

			local  IMG_LOSER_BAR = m_fnGetWidget(widgetLoser, "IMG_LOSER" .. i .. "_BAR") 
			local IMG_LOSER_TREAT = m_fnGetWidget(widgetLoser, "IMG_LOSER" .. i .. "_TREAT")
			
			
			
			if tonumber(team2Usr.addHP) == 0 then
				IMG_LOSER_TREAT:removeFromParent()
			end

			local schedulId = nil
			local number = 0
			local function updateLabnLoser(  )
				local team2ReduceHp = tonumber(team2Usr.reduceHP)
				if(number ~= nil and number < team2ReduceHp)then
					number = number + math.ceil(team2ReduceHp/animationTime/30)

					local nPercent = number / tbTotal.teamReduceHP * 100
					LOAD_LOSER:setPercent((nPercent > 100) and 100 or nPercent)
				else
					logger:debug("schedulId = %s", schedulId)
					if schedulId ~= nil then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulId)
						schdulId = nil
						schedulCount = schedulCount - 1
						if schedulCount == 0 then
							setTouchEnabled(true)
						end
					end

					local nPercent = team2Usr.reduceHP / tbTotal.teamReduceHP * 100
					LOAD_LOSER:setPercent((nPercent > 100) and 100 or nPercent)
				end
			end

			if tonumber(team2Usr.reduceHP) == 0 then
				IMG_LOSER_BAR:removeFromParent()
			else
				schedulId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLabnLoser,1/60, false)
				schedulCount = schedulCount + 1
			end


			local schedulIdAdd = nil
			local number = 0
			local function updateLabnLoserAdd(  )
				local team2AddHp = tonumber(team2Usr.addHP)
				if(number ~= nil and number < team2AddHp)then
					number = number + math.ceil(team2AddHp/animationTime/30)
					local nPercent = number / tbTotal.teamReduceHP * 100
					LOAD_LOSER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)
				else
					logger:debug("schedulIdAdd = %s", schedulIdAdd)
					if schedulIdAdd ~= nil then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(schedulIdAdd)
						schedulIdAdd = nil
						schedulCount = schedulCount - 1
						if schedulCount == 0 then
							setTouchEnabled(true)
						end
					end

					local nPercent = team2Usr.addHP / tbTotal.teamReduceHP * 100
					LOAD_LOSER_TREAT:setPercent((nPercent > 100) and 100 or nPercent)
				end
			end

			if tonumber(team2Usr.addHP) == 0 then
				IMG_LOSER_TREAT:removeFromParent()
			else
				schedulIdAdd = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLabnLoserAdd,1/60, false)
				schedulCount = schedulCount + 1
			end

		else
			widgetLoser:removeFromParent()
		end
	end

	-- modify by yangna  2016.3.7  (存在交战双方英雄输出都是0，只船炮有输出情况)
	if (schedulCount == 0) then 
		setTouchEnabled(true)
	end 
end

--[[
tbData = {
	team1 = {
		htid = {
				reduceHP  = num
				addHP = num
			
			},
		htid = {
				reduceHP  = num
				addHP = num
			
			},
		htid = {
				reduceHP  = num
				addHP = num
			
			},
	},
	team2 = {

	},
}
--]]

-- tbData = {
-- 	team1 = {
-- 		[10076] = {
-- 			reduceHP = -12340
-- 			addHP = 3900
-- 		},
-- 		[20201] = {
-- 			reduceHP = - 12340
-- 			addHP = 3900
-- 		},
-- 		[10133] = {
-- 			reduceHP = -12340
-- 			addHP = 3900
-- 		},
-- 		[10001] = {
-- 			reduceHP = -12340
-- 			addHP = 3900
-- 		},
-- 		[10033] = {
-- 			reduceHP = -12340
-- 			addHP = 3900
-- 		},
-- 	},
-- }

--  临时用得 准备数据 用
function preData( data )

	
	local team1 = {}
	

	for k,v in pairs(data.team1) do
		team1[k] = {}
		team1[k].reduceHP = -v.reduceHP
		team1[k].addHP = v.addHP
		team1[k].htid = k
	end

	local team2 = {}
	for k,v in pairs(data.team2) do
		team2[k] = {}
		team2[k].reduceHP = -v.reduceHP
		team2[k].addHP = v.addHP
		team2[k].htid = k
	end

	tbBattleData.team1 = {}
	for k,v in pairs(team1) do
		if tonumber(k) ~= nil then
			table.insert(tbBattleData.team1, v)
		end
		
	end

	tbBattleData.team2 = {}
	for k,v in pairs(team2) do
		if tonumber(k) ~= nil then
			table.insert(tbBattleData.team2, v)
		end
	end

	tbTotal = {}
	tbTotal.teamReduceHP = maxHp()
end


function maxHp(  )
	local maxReduceHp = 0
	for i,v in ipairs(tbBattleData.team1) do
		maxReduceHp = math.max(maxReduceHp, v.reduceHP)
	end

	for i,v in ipairs(tbBattleData.team2) do
		maxReduceHp = math.max(maxReduceHp, v.reduceHP)
	end
	return maxReduceHp
end

function create( tbBattleInfo, tbUserInfo)
	logger:debug(tbBattleInfo)
	tbUid = tbUserInfo
	init()
	preData(tbBattleInfo)
	--tbBattleData = tbData
	m_mainWidget = g_fnLoadUI(arena_highest_json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	return m_mainWidget
end
