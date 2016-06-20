-- FileName: ChanglageMonster.lua
-- Author: liweidong
-- Date: 2015-01-14
-- Purpose: 非贝利副本战斗前准备界面
--[[TODO List]]

module("ChanglageMonster", package.seeall)

-- UI控件引用变量 --
local layoutMain
-- 模块局部变量 --
local copyId=nil
local baseId=nil
local copyDifficult=nil

local function init(...)

end

function destroy(...)
	package.loaded["ChanglageMonster"] = nil
end

function moduleName()
    return "ChanglageMonster"
end
function getOneBattleCallback()
	--点击完成 刷新次数 和 UI
end
--返回copyId
function getCopyId()
	return copyId
end
--调用通用活动副本失败面板
function battleLose()
	local db=DB_Activitycopy.getDataById(copyId)
	require "script/module/copy/copyWin"
	if false then --(db.type==2) then
		copyWin.battalCopyType=2 --精英结算面板类型
	else
		copyWin.battalCopyType=3
	end
	require "script/module/copy/copyLose"
	local lose = copyLose.create( baseId, 1 )
	return lose
end
--调用通用活动副本胜利面板 -- bScored,tbReward__：得星（0，1，2，3），获得的奖励（table）
function battleWin(bScored,tbReward__)
	logger:debug("===============aCopy Win ")
	logger:debug(bScored)
	logger:debug(tbReward__)
	logger:debug("===============aCopy Win ")
	require "script/module/copy/copyWin"
	copyWin.battalCopyType=3 --结算面板类型
	copyWin.isHaveTreasure=false
	if (tbReward__.exp==nil) then
		tbReward__.exp=0
	end
	if (tbReward__.silver==nil) then
		tbReward__.silver=0
	end

	
	local db=DB_Activitycopy.getDataById(copyId)
	UserModel.addEnergyValue(-1*tonumber(db.attack_energy)) -- 减少体力
	MainCopyModel.subBattleTimes(copyId)  --减少活动副本战斗次数
	
	MainCopyCtrl.updateUI()  --更新UI
	if (db.type==2) then
		require "script/module/copyActivity/ShadowBattleWin"
		local win = ShadowBattleWin.create(copyId,copyDifficult,baseId,1,tbReward__)
		return win
	else
		local win = copyWin.create(baseId,1,bScored==nil and 0 or bScored.getscore, tbReward__)
		return win
	end
end
--更新UI
function updateUI()
	if (layoutMain==nil) then
		return
	end
	local remainTimes = g_fnGetWidgetByName(layoutMain, "TFD_TIMES_NUM")
	remainTimes:setText(MainCopyModel.getRemainAtackTimes(copyId))
end
function create(id,difficult)
	copyId=id
	copyDifficult=difficult
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		--副本标签
		local mainLayout = g_fnLoadUI("ui/acopy_fight.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(function(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				LayerManager.removeLayout()
				LayerManager.removeLayout()
			end
		end)

		local db=DB_Activitycopy.getDataById(id)
		local baseIds = lua_string_split(db.fort_ids, "|") 
		baseId=tonumber(baseIds[difficult])

		local function onBattle(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.playSpecialEffect("texiao_kapaizhuandong.mp3")
				AudioHelper.playCommonEffect() 
				LayerManager.removeLayout()
				require "script/battle/BattleModule"
				if (not MainCopyModel.activityIsOnTime(copyId)) then
					ShowNotice.showShellInfo(gi18n[4314]) --"今日没有该日常副本"
					return
				end
				ChanlageSelectHard.sendActivityBattle(copyId, baseId,difficult)
				--BattleModule.playActiveCopyBattle(copyId, baseId, 1,difficult, function() end, COPY_TYPE_EVENT)
			end
		end
		

		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_CHALLENGE")
		sureBtn:addTouchEventListener(onBattle)
		UIHelper.titleShadow(sureBtn)

		local remainTimes = g_fnGetWidgetByName(layoutMain, "TFD_TIMES_NUM")
		remainTimes:setText(MainCopyModel.getRemainAtackTimes(id))

		local needStrenght = g_fnGetWidgetByName(layoutMain, "TFD_POWER")
		needStrenght:setText(db.attack_energy) --"消耗体力："gi18n[4311]..

		--敌方阵容
		local htids=MainCopyModel.getBaseLastFront(baseId)
		for i=1,6 do
			local heroBg = g_fnGetWidgetByName(layoutMain, "LAY_MONSTER"..i)
			if (htids[i]~=0) then
				local icon = HeroUtil.createHeroIconBtnByHtid(htids[i],nil,
						function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
							if (eventType == TOUCH_EVENT_ENDED) then
								PublicInfoCtrl.createHeroInfoView(htids[i])
							end
						end)
				icon:setPosition(ccp(heroBg:getContentSize().width/2,heroBg:getContentSize().height/2))
				heroBg:addChild(icon)
			else
				heroBg:setEnabled(false)
			end
		end

		local function onBuzheng(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect() 
				require "script/module/formation/Buzhen"
				Buzhen.createForCopy(UIHelper.onClose)
			end
		end
		local buzhengBtn = g_fnGetWidgetByName(layoutMain, "BTN_BUZHEN")
		buzhengBtn:addTouchEventListener(onBuzheng)
		
	end
	LayerManager.addLayout(layoutMain)
end
