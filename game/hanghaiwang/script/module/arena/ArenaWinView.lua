-- FileName: ArenaWinView.lua
-- Author: huxiaozhou
-- Date: 2014-05-12
-- Purpose: 竞技场，比武，夺宝结算 胜利面板 显示模块
--[[TODO List]]

module("ArenaWinView", package.seeall)
require "script/module/public/EffectHelper"
require "db/DB_Level_up_exp"
-- UI控件引用变量 --
local public_win = "ui/public_win.json"
local m_mainWidget
local LAY_CARD1
local LAY_CARD2
local LAY_CARD3
local btnCardBack1
local btnCardBack2
local btnCardBack3

local TFD_ITEM1
local TFD_ITEM2
local TFD_ITEM3

local img_reward_namebg1
local img_reward_namebg2
local img_reward_namebg3

local bExist = false
m_tbData = nil
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_ntype
local m_tbBtnEvent
local isNpc
local isFlop
local BTN_FORMATION1 --对方阵容按钮
local BTN_REPLAY1  -- 重播按钮
local BTN_ROBAGAIN  --再抢一次
local BTN_DATA -- 战斗数据
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_animationPath = "images/effect/fanka"

local m_nFankaCount

local m_lueduo

local function init(...)
	m_mainWidget = nil
end

function destroy(...)
	package.loaded["ArenaWinView"] = nil
end

function moduleName()
	return "ArenaWinView"
end

function updateUI(  )
	local TFD_NAME1 = m_fnGetWidget(m_mainWidget,"TFD_NAME1") --进攻者
	-- UIHelper.labelNewStroke(TFD_NAME1) -- 2016-3-11描边又注掉了

	local TFD_NAME2 = m_fnGetWidget(m_mainWidget,"TFD_NAME2") -- 防守者
	-- UIHelper.labelNewStroke(TFD_NAME2) -- 2016-3-11描边又注掉了
	local TFD_FIGHT1 = m_fnGetWidget(m_mainWidget,"TFD_FIGHT1") --进攻者战斗力
	local TFD_FIGHT2 = m_fnGetWidget(m_mainWidget,"TFD_FIGHT2") -- 防守者战斗力

	local LABN_FIGHT1 = m_fnGetWidget(m_mainWidget, "LABN_FIGHT1") --
	local LABN_FIGHT2 = m_fnGetWidget(m_mainWidget, "LABN_FIGHT2")

	local TFD_MONEY = m_fnGetWidget(m_mainWidget,"TFD_MONEY") -- 获得贝里
	local TFD_EXP  =   m_fnGetWidget(m_mainWidget,"TFD_EXP")	-- 经验

	local TFD_STAMINA = m_fnGetWidget(m_mainWidget,"TFD_STAMINA") --耐力减值
	local img_stamina = m_fnGetWidget(m_mainWidget, "img_stamina")

	local TFD_ARENA_TIMES = m_fnGetWidget(m_mainWidget, "TFD_ARENA_TIMES")
	local IMG_TIMES = m_fnGetWidget(m_mainWidget, "IMG_TIMES") 


	local LAY_ROBED = m_fnGetWidget(m_mainWidget,"LAY_ROBED") -- 夺宝抢到碎片
	local LAY_NOROB = m_fnGetWidget(m_mainWidget,"LAY_NOROB") -- 夺宝未抢到碎片
	local LAY_TREASURE_NAME = m_fnGetWidget(m_mainWidget,"TFD_TREASURE_NAME")  --宝物名字
	UIHelper.labelNewStroke(LAY_TREASURE_NAME)


	local TFD_DESC = m_fnGetWidget(m_mainWidget,"TFD_DESC") -- 中间描述文字
	UIHelper.labelNewStroke(TFD_DESC, ccc3(0x49, 0x00, 0x00), 3)
	local IMG_CARD1 = m_fnGetWidget(m_mainWidget,"IMG_CARD1") -- 翻牌卡牌1
	local IMG_CARD2 = m_fnGetWidget(m_mainWidget,"IMG_CARD2") -- 翻牌卡牌1
	local IMG_CARD3 = m_fnGetWidget(m_mainWidget,"IMG_CARD3") -- 翻牌卡牌1

	local LAY_PVP_BTNS = m_fnGetWidget(m_mainWidget,"LAY_PVP_BTNS") -- 非夺宝按钮
	local LAY_NOROBBTNS = m_fnGetWidget(m_mainWidget,"LAY_NOROBBTNS") -- 夺宝未躲到
	local LAY_NOROBBTNS_NPC =  m_fnGetWidget(m_mainWidget,"LAY_NOROBBTNS_NPC") -- 从npc夺宝未躲到

	local LAY_FANPAI = m_fnGetWidget(m_mainWidget,"LAY_FANPAI") --翻牌
	LAY_CARD1 =  m_fnGetWidget(LAY_FANPAI,"LAY_CARD1")
	LAY_CARD2 =  m_fnGetWidget(LAY_FANPAI,"LAY_CARD2")
	LAY_CARD3 =  m_fnGetWidget(LAY_FANPAI,"LAY_CARD3")

	TFD_ITEM1 = m_fnGetWidget(LAY_CARD1,"TFD_ITEM1")
	TFD_ITEM2 = m_fnGetWidget(LAY_CARD2,"TFD_ITEM2")
	TFD_ITEM3 = m_fnGetWidget(LAY_CARD3,"TFD_ITEM3")
	UIHelper.labelEffect(TFD_ITEM1)
	UIHelper.labelEffect(TFD_ITEM2)
	UIHelper.labelEffect(TFD_ITEM3)

	img_reward_namebg1 = m_fnGetWidget(LAY_CARD1,"img_reward_namebg1")
	img_reward_namebg2 = m_fnGetWidget(LAY_CARD2,"img_reward_namebg2")
	img_reward_namebg3 = m_fnGetWidget(LAY_CARD3,"img_reward_namebg3")

	img_reward_namebg1:setEnabled(false)
	img_reward_namebg2:setEnabled(false)
	img_reward_namebg3:setEnabled(false)


	if(m_ntype==1) then -- 竞技场
		logger:debug("now Type ====== 1")
		LAY_ROBED:setEnabled(false)
		LAY_NOROB:setEnabled(false)
		LAY_NOROBBTNS:removeFromParent()
		LAY_NOROBBTNS_NPC:removeFromParent()
		LAY_NOROB:removeFromParentAndCleanup(true)
		LAY_ROBED:removeFromParentAndCleanup(true)

		logger:debug(m_tbData)
		-- 判断是否是npc
		if(tonumber(m_tbData.challengeUid) >= 11001 and tonumber(m_tbData.challengeUid) <= 16000)then
			isNpc = true
		end
		-- tb.enemyData = enemyData
		-- tb.atk = atk
		-- tb.coin = coin
		-- tb.exp = exp
		-- tb.flopData = flopData
		-- tb.afterOKcallFun = afterOKcallFun
		-- 我方名字 战斗力
		require "script/module/arena/ArenaData"
		require "script/model/user/UserModel"

		TFD_NAME1:setText(UserModel.getUserName())
		TFD_FIGHT1:setText(UserModel.getFightForceValue())

		TFD_NAME1:setColor(UserModel.getPotentialColor({htid = UserModel.getAvatarHtid(), bright = true}))

		LAY_PVP_BTNS:setEnabled(true)
		BTN_FORMATION1 = m_fnGetWidget(m_mainWidget,"BTN_FORMATION1") --对方阵容按钮
		BTN_REPLAY1 = m_fnGetWidget(m_mainWidget,"BTN_REPLAY1")  -- 重播按钮
		BTN_DATA = m_fnGetWidget(m_mainWidget,"BTN_DATA") -- 战斗数据按钮
		BTN_FORMATION1:addTouchEventListener(m_tbBtnEvent.onFormation)
		BTN_FORMATION1:setTag(m_tbData.challengeUid)

		BTN_REPLAY1:addTouchEventListener(m_tbBtnEvent.onRepaly)
		BTN_DATA:addTouchEventListener(m_tbBtnEvent.onBattleData)


		UIHelper.titleShadow(BTN_FORMATION1,m_i18n[2231])
		UIHelper.titleShadow(BTN_REPLAY1,m_i18n[2229])
		-- UIHelper.titleShadow(BTN_DATA,m_i18n[2169])      

		BTN_FORMATION1:setGray(true)
		BTN_REPLAY1:setGray(true)
		BTN_DATA:setGray(true)

		BTN_FORMATION1:setTouchEnabled(false)
		BTN_REPLAY1:setTouchEnabled(false)
		BTN_DATA:setTouchEnabled(false)

		-- 敌方名字 战斗力
		require "script/module/arena/ArenaData"
		if(isNpc)then
			-- npc 性别
			BTN_FORMATION1:removeFromParent()
			BTN_FORMATION1 = nil
			local utid = tonumber(m_tbData.enemyData.utid)
			npc_name = ArenaData.getNpcName( tonumber(m_tbData.challengeUid), utid)
			TFD_NAME2:setText(npc_name)
		else
			TFD_NAME2:setText(m_tbData.enemyData.uname)



		end
		TFD_NAME2:setColor(UserModel.getPotentialColor({htid = m_tbData.enemyData.figure, bright = true}))
		-- 敌方战力
		TFD_FIGHT2:setText(m_tbData.atk.force)

		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
		LABN_FIGHT2:setStringValue(m_tbData.atk.force)

		TFD_MONEY:setText("+" .. m_tbData.coin)
		TFD_EXP:setText("+" .. m_tbData.exp)
		TFD_ARENA_TIMES:setText("+" .. m_tbData.prestige)
		TFD_STAMINA:setEnabled(false)
		img_stamina:setEnabled(false)

		IMG_CARD1:setEnabled(false)
		IMG_CARD2:setEnabled(false)
		IMG_CARD3:setEnabled(false)

		TFD_ITEM1:setText("")
		TFD_ITEM2:setText("")
		TFD_ITEM3:setText("")
		btnCardBack1 = Button:create()
		btnCardBack1:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD1:addChild(btnCardBack1)
		btnCardBack1:setPosition(ccp(IMG_CARD1:getPosition()))
		btnCardBack1:setTag(1)
		btnCardBack2 = Button:create()
		btnCardBack2:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD2:addChild(btnCardBack2)
		btnCardBack2:setPosition(ccp(IMG_CARD2:getPosition()))
		btnCardBack2:setTag(2)
		btnCardBack3 = Button:create()
		btnCardBack3:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD3:addChild(btnCardBack3)
		btnCardBack3:setPosition(ccp(IMG_CARD3:getPosition()))
		btnCardBack3:setTag(3)
		IMG_CARD1:removeFromParent()
		IMG_CARD2:removeFromParent()
		IMG_CARD3:removeFromParent()



		btnCardBack1:addTouchEventListener(doFlopCard)
		btnCardBack2:addTouchEventListener(doFlopCard)
		btnCardBack3:addTouchEventListener(doFlopCard)

	--夺宝
	else
		LAY_PVP_BTNS:removeFromParent()
		LAY_NOROBBTNS_NPC:setEnabled(false)
		LAY_NOROBBTNS:setEnabled(false)

		--是否抢到宝物
		local bIsGrabFrag = false
		if( m_tbData.fragmentName)then
			LAY_TREASURE_NAME:setText(m_tbData.fragmentName .. m_i18nString(2448))
			LAY_NOROB:setEnabled(false)
			LAY_NOROB:removeFromParentAndCleanup(true)
			LAY_ROBED:setEnabled(true)
			bIsGrabFrag = true


			require "script/module/grabTreasure/ShowGetCtrl"
			m_mainWidget:addChild(ShowGetCtrl.create(m_tbData.fragId, m_tbData.fragmentName .. m_i18nString(2448)), 100)	
		else
			LAY_ROBED:setEnabled(false)
			LAY_ROBED:removeFromParentAndCleanup(true)
			LAY_NOROB:setEnabled(true)
			bIsGrabFrag = false
		end

		--npc判断 0为不是 or 1为是
		logger:debug(m_tbData.enemyData.npc)
		if(tonumber(m_tbData.enemyData.npc) == 0)then
			LAY_NOROBBTNS_NPC:removeFromParentAndCleanup(true)
			LAY_NOROBBTNS:setEnabled(true)

			BTN_FORMATION1 = m_fnGetWidget(m_mainWidget,"BTN_FORMATION2") --对方阵容按钮
			BTN_REPLAY1 = m_fnGetWidget(m_mainWidget,"BTN_REPLAY2")  -- 重播按钮
			BTN_ROBAGAIN = m_fnGetWidget(m_mainWidget,"BTN_ROB_AGAIN1") -- 再抢一次按钮
			UIHelper.titleShadow(BTN_FORMATION1,m_i18n[2231])
			UIHelper.titleShadow(BTN_REPLAY1,m_i18n[2229])
			UIHelper.titleShadow(BTN_ROBAGAIN,m_i18n[2230])

			BTN_FORMATION1:addTouchEventListener(m_tbBtnEvent.onFormation)
			BTN_REPLAY1:addTouchEventListener(m_tbBtnEvent.onRepaly)

			BTN_FORMATION1:setGray(true)
			BTN_REPLAY1:setGray(true)
			BTN_ROBAGAIN:setGray(true)

			BTN_FORMATION1:setTouchEnabled(false)
			BTN_REPLAY1:setTouchEnabled(false)
			BTN_ROBAGAIN:setTouchEnabled(false)

			if(bIsGrabFrag == false)then
				BTN_ROBAGAIN:addTouchEventListener(m_tbBtnEvent.onRobAgain)
			else
				BTN_ROBAGAIN:setEnabled(false)
			end
			BTN_FORMATION1:setTag(tonumber(m_tbData.enemyData.uid))
		else
			LAY_NOROBBTNS:removeFromParentAndCleanup(true)
			LAY_NOROBBTNS_NPC:setEnabled(true)
			BTN_REPLAY1 = m_fnGetWidget(m_mainWidget,"BTN_REPLAY3")  -- 重播按钮
			BTN_ROBAGAIN = m_fnGetWidget(m_mainWidget,"BTN_ROB_AGAIN2") -- 再抢一次按钮

			UIHelper.titleShadow(BTN_REPLAY1,m_i18n[2229])
			UIHelper.titleShadow(BTN_ROBAGAIN,m_i18n[2230])

			BTN_REPLAY1:setGray(true)
			BTN_ROBAGAIN:setGray(true)

			BTN_REPLAY1:setTouchEnabled(false)
			BTN_ROBAGAIN:setTouchEnabled(false)

			BTN_REPLAY1:addTouchEventListener(m_tbBtnEvent.onRepaly)

			if(bIsGrabFrag == false)then
				BTN_ROBAGAIN:addTouchEventListener(m_tbBtnEvent.onRobAgain)
			else
				BTN_ROBAGAIN:setEnabled(false)
			end

		end

		--玩家战斗力 名字
		TFD_NAME1:setText(UserModel.getUserName())
		TFD_FIGHT1:setText(UserModel.getFightForceValue())


		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())

		-- 敌方战力,名字
		TFD_NAME2:setText(m_tbData.enemyData.uname)
		TFD_FIGHT2:setText(m_tbData.fightFrc)
		LABN_FIGHT2:setStringValue(m_tbData.fightFrc)

		TFD_MONEY:setText("+" .. m_tbData.coin)
		TFD_EXP:setText("+" .. m_tbData.exp)
		TFD_STAMINA:setText(tostring(m_tbData.costStamina))

		TFD_ARENA_TIMES:setEnabled(false)
		IMG_TIMES:setEnabled(false)
		
		IMG_CARD1:setEnabled(false)
		IMG_CARD2:setEnabled(false)
		IMG_CARD3:setEnabled(false)

		TFD_ITEM1:setText("")
		TFD_ITEM2:setText("")
		TFD_ITEM3:setText("")
		btnCardBack1 = Button:create()
		btnCardBack1:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD1:addChild(btnCardBack1)
		btnCardBack1:setPosition(ccp(IMG_CARD1:getPosition()))
		btnCardBack1:setTag(1)
		btnCardBack2 = Button:create()
		btnCardBack2:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD2:addChild(btnCardBack2)
		btnCardBack2:setPosition(ccp(IMG_CARD2:getPosition()))
		btnCardBack2:setTag(2)
		btnCardBack3 = Button:create()
		btnCardBack3:loadTextureNormal("ui/open_card_n.png")
		LAY_CARD3:addChild(btnCardBack3)
		btnCardBack3:setPosition(ccp(IMG_CARD3:getPosition()))
		btnCardBack3:setTag(3)
		IMG_CARD1:removeFromParent()
		IMG_CARD2:removeFromParent()
		IMG_CARD3:removeFromParent()

		btnCardBack1:addTouchEventListener(doFlopCard)
		btnCardBack2:addTouchEventListener(doFlopCard)
		btnCardBack3:addTouchEventListener(doFlopCard)
	end

	 -- 动画
        -- 缩放动画时间(跳动画)
        local scaleSecond = 0.05
        -- 延时时间(每张跳动的间隔时间)
        local scaleDelay = 0.5
        local seqArray = CCArray:create()
        seqArray:addObject(CCCallFunc:create(function ( ... )
            -- 中
            local actionArray = CCArray:create()
            actionArray:addObject(CCScaleTo:create(scaleSecond, 1.2))
            actionArray:addObject(CCScaleTo:create(scaleSecond, 1.0))
            local mid_cardAction = CCSequence:create(actionArray)
            btnCardBack2:runAction(mid_cardAction)            
        end))
        seqArray:addObject(CCDelayTime:create(scaleDelay))
        seqArray:addObject(CCCallFunc:create(function ( ... )
             -- 右
            local right_actionArray = CCArray:create()
            right_actionArray:addObject(CCScaleTo:create(scaleSecond, 1.2))
            right_actionArray:addObject(CCScaleTo:create(scaleSecond, 1.0))
            local right_cardAction = CCSequence:create(right_actionArray)
            btnCardBack3:runAction(right_cardAction)
        end))
        seqArray:addObject(CCDelayTime:create(scaleDelay))
        seqArray:addObject(CCCallFunc:create(function ( ... )
             -- 左
            local left_actionArray = CCArray:create()
            left_actionArray:addObject(CCScaleTo:create(scaleSecond, 1.2))
            left_actionArray:addObject(CCScaleTo:create(scaleSecond, 1.0))
            local right_cardAction = CCSequence:create(left_actionArray)
            btnCardBack1:runAction(right_cardAction)
        end))
        seqArray:addObject(CCDelayTime:create(scaleDelay))
        local seq = CCSequence:create(seqArray)
        LAY_CARD2:runAction(CCRepeatForever:create(seq))


end


function updateFightLabel ()
	local LABN_FIGHT1 = m_fnGetWidget(m_mainWidget, "LABN_FIGHT1")
	LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
end

-- 点击翻牌
function doFlopCard(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		-- if (isFlop==true) then
		-- 	ShowNotice.showShellInfo("已经翻过牌了，这是提示 暂时先加上")
		-- 	return
		-- end
		LAY_CARD2:stopAllActions()
		isFlop = true
		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideRobView"
		if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 5) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createRobGuide(6)
		end
		logger:debug("tbBtnEvent.doFlopCard")
		local btnItem,name,quality = fnGetIconByData(m_tbData.flopData.real)
		btnItem:retain()


		if (m_tbData.flopData.real.rob~=nil) then
			performWithDelay(m_mainWidget,function ( ... )

				m_mainWidget:addNode(m_lueduo)
				m_lueduo:release()
			end, 0.2)
			
		end
	
		btnCardBack1:setTouchEnabled(false)
		btnCardBack2:setTouchEnabled(false)
		btnCardBack3:setTouchEnabled(false)


		if(sender:getTag() == 1) then
			btnCardBack1:setEnabled(false)
			addFanka1Animation(LAY_CARD1,btnItem,true)
			-- addFanKa2Animation(LAY_CARD1)
			btnItem:setPosition(ccp(LAY_CARD1:getContentSize().width*.5,LAY_CARD1:getContentSize().height*.5))
			-- LAY_CARD1:addChild(btnItem)
			-- fanka1Animation:addChild(btnItem)
			TFD_ITEM1:setText(name)
			local color =  g_QulityColor[tonumber(quality)]
			if(color ~= nil) then
				TFD_ITEM1:setColor(color)
			end

			img_reward_namebg1:setEnabled(true)

		elseif(sender:getTag() == 2) then
			btnCardBack2:setEnabled(false)

			addFanka1Animation(LAY_CARD2,btnItem,true)
			-- addFanKa2Animation(LAY_CARD2)
			btnItem:setPosition(ccp(LAY_CARD2:getContentSize().width*.5,LAY_CARD2:getContentSize().height*.5))
			-- LAY_CARD2:addChild(btnItem)
			-- fanka1Animation:addChild(btnItem)
			TFD_ITEM2:setText(name)
			local color =  g_QulityColor[tonumber(quality)]
			if(color ~= nil) then
				TFD_ITEM2:setColor(color)
			end
			img_reward_namebg2:setEnabled(true)
		else
			btnCardBack3:setEnabled(false)
			addFanka1Animation(LAY_CARD3,btnItem,true)
			-- addFanKa2Animation(LAY_CARD3)
			btnItem:setPosition(ccp(LAY_CARD3:getContentSize().width*.5,LAY_CARD3:getContentSize().height*.5))
			-- LAY_CARD3:addChild(btnItem)
			-- fanka1Animation:addChild(btnItem)
			TFD_ITEM3:setText(name)
			local color =  g_QulityColor[tonumber(quality)]
			if(color ~= nil) then
				TFD_ITEM3:setColor(color)
			end
			img_reward_namebg3:setEnabled(true)
		end

		local actions1 = CCArray:create()
		actions1:addObject(CCDelayTime:create(0.2))
		actions1:addObject(CCCallFuncN:create(delayAction))
		sender:runAction(CCSequence:create(actions1))

	end
end


function delayAction(sender)
	btnCardBack1:setEnabled(false)
	btnCardBack2:setEnabled(false)
	btnCardBack3:setEnabled(false)
	local tag = sender:getTag()
	if(tag==1)then
		local btnItem,name,quality = fnGetIconByData(m_tbData.flopData.show1)
		btnItem:setPosition(ccp(LAY_CARD2:getContentSize().width*.5,LAY_CARD2:getContentSize().height*.5))
		-- LAY_CARD2:addChild(btnItem)
		btnItem:retain()
		addFanka1Animation(LAY_CARD2,btnItem)
		TFD_ITEM2:setText(name)
		local color =  g_QulityColor[tonumber(quality)]
		if(color ~= nil) then
			TFD_ITEM2:setColor(color)
		end
		img_reward_namebg2:setEnabled(true)

		local btnItem1 ,name1,quality1= fnGetIconByData(m_tbData.flopData.show2)
		btnItem1:setPosition(ccp(LAY_CARD3:getContentSize().width*.5,LAY_CARD3:getContentSize().height*.5))
		-- LAY_CARD3:addChild(btnItem1)
		btnItem1:retain()
		addFanka1Animation(LAY_CARD3,btnItem1)
		TFD_ITEM3:setText(name1)

		local color1 =  g_QulityColor[tonumber(quality1)]
		if(color1 ~= nil) then
			TFD_ITEM3:setColor(color1)
		end
		img_reward_namebg3:setEnabled(true)

	elseif (tag==2) then
		local btnItem,name,quality = fnGetIconByData(m_tbData.flopData.show1)
		btnItem:setPosition(ccp(LAY_CARD1:getContentSize().width*.5,LAY_CARD1:getContentSize().height*.5))
		-- LAY_CARD1:addChild(btnItem)
		TFD_ITEM1:setText(name)

		local color =  g_QulityColor[tonumber(quality)]
		if(color ~= nil) then
			TFD_ITEM1:setColor(color)
		end
		img_reward_namebg1:setEnabled(true)
		local btnItem1,name1,quality1 = fnGetIconByData(m_tbData.flopData.show2)
		btnItem1:setPosition(ccp(LAY_CARD3:getContentSize().width*.5,LAY_CARD3:getContentSize().height*.5))
		-- LAY_CARD3:addChild(btnItem1)
		TFD_ITEM3:setText(name1)

		btnItem:retain()
		addFanka1Animation(LAY_CARD1,btnItem)
		btnItem1:retain()
		addFanka1Animation(LAY_CARD3,btnItem1)

		local color1 =  g_QulityColor[tonumber(quality1)]
		if(color1~= nil) then
			TFD_ITEM3:setColor(color1)
		end
		img_reward_namebg3:setEnabled(true)

	else
		local btnItem,name,quality = fnGetIconByData(m_tbData.flopData.show1)
		btnItem:setPosition(ccp(LAY_CARD2:getContentSize().width*.5,LAY_CARD2:getContentSize().height*.5))
		-- LAY_CARD2:addChild(btnItem)
		-- TFD_ITEM2:setText(name)


		local color =  g_QulityColor[tonumber(quality)]
		if(color ~= nil) then
			TFD_ITEM1:setColor(color)
		end
		img_reward_namebg1:setEnabled(true)
		local btnItem1,name1,quality1= fnGetIconByData(m_tbData.flopData.show2)
		btnItem1:setPosition(ccp(LAY_CARD1:getContentSize().width*.5,LAY_CARD1:getContentSize().height*.5))
		-- LAY_CARD1:addChild(btnItem1)
		TFD_ITEM1:setText(name)
		TFD_ITEM2:setText(name1)
		img_reward_namebg2:setEnabled(true)
		btnItem:retain()
		addFanka1Animation(LAY_CARD1,btnItem)
		btnItem1:retain()
		addFanka1Animation(LAY_CARD2,btnItem1)

		local color1 =  g_QulityColor[tonumber(quality1)]
		if(color1 ~= nil) then
			TFD_ITEM2:setColor(color1)
		end

	end

	if (BTN_FORMATION1 ~= nil) then
		BTN_FORMATION1:setGray(false)
		BTN_FORMATION1:setTouchEnabled(true)
	end
	if (BTN_REPLAY1 ~= nil) then
		BTN_REPLAY1:setTouchEnabled(true)
		BTN_REPLAY1:setGray(false)
	end

	if (BTN_ROBAGAIN ~= nil) then
		BTN_ROBAGAIN:setTouchEnabled(true)
		BTN_ROBAGAIN:setGray(false)
	end

	if (BTN_DATA ~= nil) then
		BTN_DATA:setTouchEnabled(true)
		BTN_DATA:setGray(false)
	end

	m_mainWidget:setTouchEnabled(true)
	m_mainWidget:addTouchEventListener(m_tbBtnEvent.onConfirm)

end


-- menghao 用来判断有没有升级 modified by huxiaozhou  20141230
local function ifLevelUp( ... )
	local tbUserInfo = UserModel.getUserInfo()


	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local bLvUp = (nExpNum + m_tbData.exp) >= nLevelUpExp; -- 获得经验后是否升级
	UserModel.addExpValue(m_tbData.exp, "arena and rob")

	logger:debug("m_tbData.exp = %s", m_tbData.exp)

	logger:debug("bLvUp = %s" ,bLvUp )
	-- bLvUp = true -- debug
	if bLvUp then
		local filePath1 = "images/effect/shengji/sj.ExportJson"
		local filePath2 = "images/effect/shengji/sj2.ExportJson"
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(filePath1)
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(filePath2)
	end
	return bLvUp
end

local function postLevelUpNoti( bLvUp )
	if bLvUp then
		require "script/module/public/GlobalNotify"
		local str = nil
		if m_tbData.rise and tonumber(m_tbData.rise.gold) >0 then
			str = m_i18nString(2258, m_tbData.rise.gold)
		end
		GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,str)
		updateFightLabel()
	end
end

-- 动画
function addLueDuoAnimation( number )
	local animationLueDuo = EffLueDuo:new(m_mainWidget)
	animationLueDuo:playWithNumber(number)
	local animationLueDuo1 = animationLueDuo:Armature()
	animationLueDuo1:setScale(g_fScaleX)
	animationLueDuo1:setPositionX(g_winSize.width*0.5)
	-- m_mainWidget:addNode(animationLueDuo1)
	animationLueDuo1:retain()
	return animationLueDuo1
end



function addFanka1Animation( open_card, btnItem,isClick)
	if (m_nFankaCount==0 and isClick == true)then
		LayerManager.addLayoutNoScale(Layout:create())
	end
	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			m_nFankaCount = m_nFankaCount + 1
			logger:debug("动画没播放完啦～～～～～")
		
			if (isClick == true )then
				addFanKa2Animation(open_card)
			end
			open_card:addChild(btnItem,3)
			btnItem:release()

			if (m_nFankaCount >= 3) then
				PreRequest.setIsCanShowAchieveTip(true) -- add by huxiaozhou 20141126
				-- menghao 如果没有掠夺则在这里判断是否升级
				LayerManager.removeLayout() -- 关闭屏蔽层
			end
		end
	end
	local  fanka1Animation = UIHelper.createArmatureNode({
		filePath =m_animationPath .. "/fanka_01.ExportJson",
		animationName = "fanka_01",
		loop = 0,
		fnMovementCall = animationCallBack,
	})
	AudioHelper.playEffect("audio/effect/texiao_fanpai.mp3")
	fanka1Animation:setPosition(open_card:getSize().width/2, open_card:getSize().height / 2)
	open_card:addNode(fanka1Animation,2)
end

function addFanKa2Animation( open_card )
	local  fanka2Animation = UIHelper.createArmatureNode({
		filePath =m_animationPath .. "/fanka_02.ExportJson",
		animationName = "fanka_02",
		loop = 1,
	})
	fanka2Animation:setPosition(open_card:getSize().width/2, open_card:getSize().height / 2)
	open_card:addNode(fanka2Animation)
end

function onHeroIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("onHeroIcon")
		require "script/module/public/PublicInfoCtrl"
		local goods = tbGoodsData[sender:getTag()]
		PublicInfoCtrl.createHeroInfoView(goods.tid)
	end
end

function onItemIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("onItemIcon")
		require "script/module/public/PublicInfoCtrl"
		logger:debug(userData)
		local tbF = getFlopDataById(sender:getTag())
		if(type(tbF) == "table") then
			PublicInfoCtrl.createItemInfoViewByTid(tbF.id,tbF.num)
		end
	end
end



function fnGetIconByData( data )
	logger:debug(data)
	for k,v in pairs(data) do
		if(k == "item")then
			local btnItem ,tbItem= ItemUtil.createBtnByTemplateIdAndNumber(v.id,v.num,onItemIcon)
			btnItem:setTag(v.id)
			return btnItem,tbItem.name,tbItem.quality
		elseif(k == "treasFrag")then
			local btnItem ,tbItem= ItemUtil.createBtnByTemplateIdAndNumber(v.id,v.num,onItemIcon)
			btnItem:setTag(v.id)
			return btnItem ,tbItem.name,tbItem.quality
		elseif(k == "silver")then
			local btnItem = ItemUtil.getSiliverIconByNum(v)
			return btnItem ,m_i18n[1520],2
		elseif(k == "gold")then
			local btnItem = ItemUtil.getGoldIconByNum(v)
			return btnItem, m_i18n[2220],5
		elseif(k == "soul")then
			local btnItem = ItemUtil.getSoulIconByNum(v)
			local _name = m_i18n[1087]
			return btnItem,_name,4
		elseif(k == "hero")then
			local btnItem,heroInfo= HeroUtil.createHeroIconBtnByHtid(v)
			return btnItem,heroInfo.name,heroInfo.quality
		end
	end

	if(data.rob~=nil) then
		local btnItem = ImageView:create()
		local iconImgV  = ImageView:create()
		iconImgV:loadTexture("images/common/rob_belly.png")
		local iconBorder = ImageView:create()
		iconBorder:loadTexture("images/base/potential/equip_4.png")
		btnItem:addChild(iconImgV)
		btnItem:addChild(iconBorder)
		btnItem:loadTexture("images/base/potential/color_4.png")
		return btnItem, m_i18n[2238], 4
	end
end

function getFlopDataById( _id )
	logger:debug(_id)
	logger:debug(m_tbData.flopData)
	for k,v in pairs(m_tbData.flopData) do
		if (type(v) == "table") then
			for key,value in pairs(v) do
				if (tonumber(value.id) == _id) then
					logger:debug(value)
					return value
				end
			end
		end
	end
	return nil
end

function create(_type,tbEvent,_tbData)
	init()
	m_nFankaCount = 0
	isNpc = false
	isFlop = false
	m_ntype = _type
	m_tbBtnEvent = tbEvent
	m_tbData = _tbData
	m_mainWidget = g_fnLoadUI(public_win)
	m_mainWidget:setSize(g_winSize)
	logger:debug(_tbData)

	BTN_FORMATION1 = nil--对方阵容按钮
	BTN_REPLAY1 = nil  -- 重播按钮
	BTN_ROBAGAIN = nil --再抢一次按钮
	BTN_DATA = nil -- 战斗数据按钮
	updateUI()

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideRobView"
	if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 4) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createRobGuide(5)
	end

	--特效
	local IMG_RAINBOW = m_fnGetWidget(m_mainWidget,"IMG_RAINBOW")
	local IMG_TITLE = m_fnGetWidget(m_mainWidget,"IMG_TITLE")
	


	if (m_tbData.flopData.real.rob~=nil) then
		m_lueduo = addLueDuoAnimation(m_tbData.flopData.real.rob)
	end
	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)
	
	local bUp = ifLevelUp()
	local layout = Layout:create()
	layout:setTouchEnabled(true)
	layout:setSize(CCSizeMake(g_winSize.width, g_winSize.height))
	m_mainWidget:addChild(layout, 999999)
	if not bUp then
		layout:removeFromParent()
		layout = nil
	end
	m_mainWidget.img_vsvg:setVisible(false)
	m_mainWidget.img_gain_bg:setVisible(false)
	local shieldLayout = Layout:create() --屏蔽层 
	shieldLayout:setTouchEnabled(true)
	shieldLayout:setSize(g_winSize)
	m_mainWidget:addChild(shieldLayout)
	local propertyLable = {m_mainWidget.img_gain_bg}
	local winEff = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW, callback = function ( ... )
			palyBattleVsEffect(m_mainWidget.img_vsvg,m_mainWidget.img_vsvg.img_vs,function()
					palyPropertyEffect(propertyLable,function()
							shieldLayout:removeFromParent()
						end)
				end)
			--涉及到升级屏蔽层 这里不动，我另外增加一个屏蔽层 liweidong
			if bUp then
				layout:removeFromParent()
				layout = nil
				postLevelUpNoti(bUp)
			end
		end })

	local node = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
	m_mainWidget.IMG_FADEIN_EFFECT:addNode(node)

	UIHelper.registExitAndEnterCall(m_mainWidget, function ( ... )
		bExist = false
		AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
	end, function ( ... )
		bExist = true
	end)

	local BTN_REPORT = m_fnGetWidget(m_mainWidget,"BTN_REPORT")  
	BTN_REPORT:addTouchEventListener(m_tbBtnEvent.onReport)

	m_mainWidget:setName("public_win")
	return m_mainWidget
end

function getViewExist( ... )
	return bExist
end

