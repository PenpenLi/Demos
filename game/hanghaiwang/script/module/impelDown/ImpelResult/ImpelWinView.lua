-- FileName: ImpelWinView.lua
-- Author: LvNanchun
-- Date: 2015-09-10
-- Purpose: function description of module
--[[TODO List]]

ImpelWinView = class("ImpelWinView")

-- UI variable --
local _layMain

-- module local variable --
local _i18n = gi18n
local _prisonInfo		-- 装备结晶物品信息
local _tbRewardInfo		-- 奖励信息
local tbNames = {"win_drop_black/white", "win_drop_black/white", "win_drop_green", "win_drop_blue", "win_drop_purple", "win_drop_orange"}

function ImpelWinView:moduleName()
    return "ImpelWinView"
end

function ImpelWinView:ctor(...)
	_layMain = g_fnLoadUI("ui/impel_down_win.json")
end

function ImpelWinView:create( prisonLevel )
	require "script/module/public/EffectHelper"

	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)

	_layMain.img_belly_bg:setVisible(false)
--	_layMain.img_prison_bg:setVisible(false)

	_layMain.TFD_BELLY_NUM:setText("0")

	_tbRewardInfo = ImpelDownMainModel.getTowerDataByLevel(prisonLevel)

	_prisonInfo = ItemUtil.getItemById(60031)
	logger:debug({_prisonInfo = _prisonInfo})

	_layMain.tfd_prison:setText(_prisonInfo.name)
	_layMain.tfd_prison:setColor(g_QulityColor2[tonumber(_prisonInfo.quality)])
	_layMain.tfd_prison:setVisible(false)

	-- 装备结晶特效
	local function addPrisonAni()
		local x, y = _layMain.img_prison_bg:getPosition()
		-- 创建翻牌特效
		local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/battle_result/win_drop.ExportJson",
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if (frameEventName == "1") then
					_layMain.tfd_prison:setVisible(true)
					if (_prisonInfo.quality) then
						local armatureLight = UIHelper.createArmatureNode({
							filePath = "images/effect/battle_result/win_drop.ExportJson",
							animationName = tbNames[tonumber(_prisonInfo.quality)],
							bRetain = true,
						})
						armatureLight:setPosition(ccp(x, y))
						_layMain.LAY_FIT:addNode(armatureLight, -1, -1)
					end
				end
			end,

			fnMovementCall = function ( sender, MovementEventType, frameEventName)
				if (MovementEventType == 1) then
					sender:removeFromParentAndCleanup(true)
					local prisonIcon = ItemUtil.createBtnByTemplateIdAndNumber(_prisonInfo.id, tonumber(_tbRewardInfo.prison))
					_layMain.img_prison_bg:setEnabled(true)
					_layMain.img_prison_bg:addChild(prisonIcon, 999, 999)
					_layMain.LAY_FIT:setTouchEnabled(true)
				end
			end,
			bRetain = true,
		})

		local prisonIcon = ItemUtil.createBtnByTemplateIdAndNumber(_prisonInfo.id, tonumber(_tbRewardInfo.prison))
		armature:getBone("win_drop_3"):addDisplay(prisonIcon, 0)
		armature:setPosition(ccp(x, y))
		_layMain.LAY_FIT:addNode(armature)

		AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
		armature:getAnimation():play("win_drop", -1, -1, 0)
	end

	-- 贝里数字翻滚动作
	local function changeToNum( num , widget )
		if (num and widget) then
			local actionArray = CCArray:create()
			for i = 1,60 do 
				actionArray:addObject(CCCallFuncN:create(function ( ... )
					widget:setText(tostring(math.floor(i/60*num)))
				end))
				actionArray:addObject(CCDelayTime:create(1/120))
			end
			actionArray:addObject(CCCallFuncN:create(function ( ... )
				addPrisonAni()
			end))
			return CCSequence:create(actionArray)
		end
	end

	EffBattleWin:new({imgTitle = _layMain.IMG_TITLE, imgRainBow = _layMain.IMG_RAINBOW , callback=function ( ... )
		palyPropertyEffect({_layMain.img_belly_bg},function ( ... )
			local action2 = changeToNum( tonumber(_tbRewardInfo.belly) , _layMain.TFD_BELLY_NUM )
			if (action2) then
				_layMain:runAction(action2)
			end
		end)
	end})

	_layMain.LAY_FIT:setTouchEnabled(false)
	_layMain.LAY_FIT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState() 
			LayerManager.removeLayout()
			ImpelDownMainModel.setCanRefreshView()
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		end
	end)

	-- 发送战报按钮
	_layMain.BTN_REPORT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			AudioHelper.playSendReport()
			local nowLayerInfo = ImpelDownMainModel.getTowerDataByLevel( prisonLevel )
			local batttleName = nowLayerInfo.name
			local playerName = nowLayerInfo.layerName
			UIHelper.sendBattleReport(BattleState.getBattleBrid(),batttleName,playerName)
		end
	end)

	_layMain.tfd_belly:setText(_i18n[6017])
	_layMain.tfd_reward:setText(_i18n[3739])

	local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_close.ExportJson",
			animationName = "fadein_close",
			loop = 1,
		})
	_layMain.img_txt:addNode(armature)

	require "script/module/public/UIHelper"
	UIHelper.labelNewStroke(_layMain.tfd_reward , ccc3(0x80 , 0x00 , 0x00) , 3)
	
	UserModel.addImpelDownNum(tonumber(_tbRewardInfo.prison))
	UserModel.addSilverNumber(tonumber(_tbRewardInfo.belly))
	return _layMain
end

