-- FileName: BellyChanlage.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("BellyChanlage", package.seeall)

-- UI控件引用变量 --
local layoutMain=nil
-- 模块局部变量 --
local copyId = nil 
local baseId = nil

local function init(...)

end

function destroy(...)
	package.loaded["BellyChanlage"] = nil
end

function moduleName()
    return "BellyChanlage"
end
--get baseId 据点id
function getBaseId()
	return baseId
end
--[[desc:调用贝利战斗胜利结算面板
    arg1: hurt,belly ：总伤害值，获得贝利
    return: nil
—]]
function battleWin(hurt,belly)
	require "script/module/copyActivity/BellyBattleWin"
	local win = BellyBattleWin.create(copyId,hurt,belly)
	return win
end
function sureBattle(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		LayerManager.removeLayout()
		require "script/battle/BattleModule"
		BattleModule.playActiveCopyBattle(copyId, baseId, 1, 1, function() end, COPY_TYPE_EVENT_BELLT)
		--BellyBattleWin.create(copyId,1000,1000)
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
function create(id)
	copyId=id
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
		local mainLayout = g_fnLoadUI("ui/acopy_belly_reward.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_CHALLENGE")
		sureBtn:addTouchEventListener(sureBattle)
		UIHelper.titleShadow(sureBtn)
		--初始化贝利奖励
		local db=DB_Activitycopy.getDataById(id)

		local db=DB_Activitycopy.getDataById(id)
		local baseIds = lua_string_split(db.fort_ids, "|") 
		baseId=tonumber(baseIds[1])


		local remainTimes = g_fnGetWidgetByName(layoutMain, "TFD_TIMES_NUM")
		remainTimes:setText(MainCopyModel.getRemainAtackTimes(id))

		local needStrenght = g_fnGetWidgetByName(layoutMain, "TFD_POWER")
		needStrenght:setText(db.attack_energy) --"消耗体力："gi18n[4311]..

		local function onBuzheng(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect() 
				require "script/module/formation/Buzhen"
				Buzhen.createForCopy(UIHelper.onClose)
			end
		end
		local buzhengBtn = g_fnGetWidgetByName(layoutMain, "BTN_BUZHEN")
		buzhengBtn:addTouchEventListener(onBuzheng)
		mainLayout.IMG_MONSTER:loadTexture("images/base/hero/body_img/"..db.image_big)
		
		
	end
	LayerManager.addLayout(layoutMain)
end