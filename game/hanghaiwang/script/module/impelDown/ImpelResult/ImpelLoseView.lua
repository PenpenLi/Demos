-- FileName: ImpelLoseView.lua
-- Author: LvNanchun
-- Date: 2015-09-10
-- Purpose: function description of module
--[[TODO List]]

ImpelLoseView = class("ImpelLoseView")

-- UI variable --
local _layMain

-- module local variable --
local _i18n = gi18n

function ImpelLoseView:moduleName()
    return "ImpelLoseView"
end

function ImpelLoseView:ctor(...)
	_layMain = g_fnLoadUI("ui/impel_down_lose.json")
end

function ImpelLoseView:create( prisonLevel )
	require "script/module/public/EffectHelper"

	AudioHelper.playMusic("audio/bgm/bai.mp3",false)

	EffBattleLose:new(_layMain,_layMain.IMG_TITLE)

	_layMain.LAY_FIT:setTouchEnabled(true)
	_layMain.LAY_FIT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState()
			ImpelDownMainModel.setCanRefreshView()
			LayerManager.removeLayout()
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		end
	end)
	-- 调整阵容
	_layMain.BTN_MINGJIANG:addTouchEventListener(function ( sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				if (BTUtil:getGuideState()) then
					ShowNotice.showShellInfo("请先完成新手引导")
				else
					ImpelDownMainModel.setNotCanRefreshView()
					EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	    			require "script/module/main/MainScene"
	            	MainScene.onFormation(nil, TOUCH_EVENT_ENDED)
	            end
			end
		end)
	-- 武将强化
	_layMain.BTN_WUJIANG:addTouchEventListener(function ( sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				if (BTUtil:getGuideState()) then
					ShowNotice.showShellInfo("请先完成新手引导")
				else
					ImpelDownMainModel.setNotCanRefreshView()
					EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
					require "script/module/partner/MainPartner"
	        		local layPartner = MainPartner.create()
	        		if (layPartner) then
	         			LayerManager.changeModule(layPartner, MainPartner.moduleName(),{1,3},true)
	         			PlayerPanel.addForPartnerStrength()
	         			require "script/module/main/MainScene"
	         			MainScene.changeMenuCircle(1)
					end
	            end
			end
		end)
	-- 装备强化
	_layMain.BTN_ZHUANGBEI:addTouchEventListener(function ( sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				if (BTUtil:getGuideState()) then
					ShowNotice.showShellInfo("请先完成新手引导")
				else
					ImpelDownMainModel.setNotCanRefreshView()
					require "script/module/equipment/MainEquipmentCtrl"
					EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
					local layEquipment = MainEquipmentCtrl.create()
					if layEquipment then
						LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3})
						PlayerPanel.addForPartnerStrength()
						require "script/module/main/MainScene"
						MainScene.changeMenuCircle(1)
					end
	            end
			end
		end)
	-- 查看攻略
	_layMain.BTN_STRATEGY:addTouchEventListener( function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState()
			ImpelDownMainModel.setNotCanRefreshView()
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			local fnOnStrategy = MainImpelDownCtrl.getBtnOnStrategy()
			fnOnStrategy(nil,TOUCH_EVENT_ENDED)
		end
	end )

	-- 发送战报按钮
	_layMain.BTN_REPORT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playSendReport()
			local nowLayerInfo = ImpelDownMainModel.getTowerDataByLevel( prisonLevel )
			local batttleName = nowLayerInfo.name
			local playerName = nowLayerInfo.layerName
			UIHelper.sendBattleReport(BattleState.getBattleBrid(),batttleName,playerName)
		end
	end)

	local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_close.ExportJson",
			animationName = "fadein_close",
			loop = 1,
		})
	_layMain.img_txt:addNode(armature)

	UIHelper.labelAddNewStroke(_layMain.TFD_TODO_TITLE, _i18n[1998], ccc3(0x49, 0x00, 0x00), 3)

	return _layMain
end

