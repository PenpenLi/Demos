-- FileName: ArenaLoseView.lua
-- Author: huxiaozhou
-- Date: 2014-05-12
-- Purpose: 竞技场,比武，夺宝 失败显示模块
--[[TODO List]]

module("ArenaLoseView", package.seeall)
require "script/module/public/EffectHelper"
require "db/DB_Level_up_exp"
m_tbData = nil
-- UI控件引用变量 --
local public_lose = "ui/public_lose.json"
local m_mainWidget

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_ntype
local m_tbBtnEvent
local isNpc
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["ArenaLoseView"] = nil
end

function moduleName()
	return "ArenaLoseView"
end

function updateUI(  )
	local TFD_NAME1 = m_fnGetWidget(m_mainWidget,"TFD_NAME1") --进攻者
	local TFD_NAME2 = m_fnGetWidget(m_mainWidget,"TFD_NAME2") -- 防守者
	-- UIHelper.labelNewStroke(TFD_NAME1) -- 2016-3-11描边又注掉了
	-- UIHelper.labelNewStroke(TFD_NAME2) -- 2016-3-11描边又注掉了
	local TFD_FIGHT1 = m_fnGetWidget(m_mainWidget,"TFD_FIGHT1") --进攻者战斗力
	local TFD_FIGHT2 = m_fnGetWidget(m_mainWidget,"TFD_FIGHT2") -- 防守者战斗力
	local LABN_FIGHT1 = m_fnGetWidget(m_mainWidget,"LABN_FIGHT1")
	local LABN_FIGHT2 = m_fnGetWidget(m_mainWidget,"LABN_FIGHT2")

	local TFD_MONEY = m_fnGetWidget(m_mainWidget,"TFD_MONEY") -- 获得贝里
	local TFD_EXP  =   m_fnGetWidget(m_mainWidget,"TFD_EXP")	-- 经验
	local TFD_STAMINA = m_fnGetWidget(m_mainWidget,"TFD_STAMINA") --耐力减值
	local img_stamina = m_fnGetWidget(m_mainWidget, "img_stamina")

	local TFD_ARENA_TIMES = m_fnGetWidget(m_mainWidget, "TFD_ARENA_TIMES")
	local IMG_TIMES = m_fnGetWidget(m_mainWidget, "IMG_TIMES") 
	local TFD_INFO = m_fnGetWidget(m_mainWidget,"TFD_INFO")

	TFD_INFO:setText(m_i18n[1996])
	local BTN_WUJIANG = m_fnGetWidget(m_mainWidget,"BTN_WUJIANG") --武将强化按钮
	local BTN_ZHUANGBEI = m_fnGetWidget(m_mainWidget,"BTN_ZHUANGBEI") -- 装备强化按钮
	local BTN_MINGJIANG = m_fnGetWidget(m_mainWidget,"BTN_MINGJIANG") -- 名将培养
	-- local BTN_PET = m_fnGetWidget(m_mainWidget,"BTN_PET") -- 宠物喂养

	BTN_WUJIANG:addTouchEventListener(m_tbBtnEvent.onPartner)
	BTN_ZHUANGBEI:addTouchEventListener(m_tbBtnEvent.onEquip)
	-- BTN_MINGJIANG:addTouchEventListener(m_tbBtnEvent.onTrainstar)
	-- BTN_PET:addTouchEventListener(m_tbBtnEvent.onTrainPet)
	BTN_MINGJIANG:addTouchEventListener(m_tbBtnEvent.onGoToFormation)

	local LAY_PVPBTNS = m_fnGetWidget(m_mainWidget,"LAY_PVP_BTNS") -- 竞技场 pvp
	local LAY_ROBBTNS = m_fnGetWidget(m_mainWidget,"LAY_ROBBTNS") -- 打劫 pvp

	local LAY_PVPBTNS_NPC = m_fnGetWidget(m_mainWidget,"LAY_PVPBTNS_NPC") -- 竞技场NPC
	local LAY_ROBBTNS_NPC = m_fnGetWidget(m_mainWidget,"LAY_ROBBTNS_NPC") --打劫 NPC


	if(m_ntype==1) then -- 竞技场
		logger:debug("now Type ====== 1")
		logger:debug(m_tbData)
		-- 判断是否是npc
		if(tonumber(m_tbData.challengeUid) >= 11001 and tonumber(m_tbData.challengeUid) <= 16000)then
			isNpc = true
		end
		if (isNpc) then -- 如果是NPC 则把无关的按钮Lay 移除
			LAY_PVPBTNS:removeFromParent()
			LAY_ROBBTNS:removeFromParent()
			LAY_ROBBTNS_NPC:removeFromParent()

			local BTN_REPLAY3 = m_fnGetWidget(LAY_PVPBTNS_NPC,"BTN_REPLAY3") -- 重播

			UIHelper.titleShadow(BTN_REPLAY3, m_i18n[2229])

			BTN_REPLAY3:addTouchEventListener(m_tbBtnEvent.onRepaly)
		else
			LAY_PVPBTNS_NPC:removeFromParent()
			LAY_ROBBTNS:removeFromParent()
			LAY_ROBBTNS_NPC:removeFromParent()

			local BTN_FORMATION1 = m_fnGetWidget(LAY_PVPBTNS,"BTN_FORMATION1") -- 对方阵容
			local BTN_REPLAY1 =  m_fnGetWidget(LAY_PVPBTNS,"BTN_REPLAY1") -- 重播
			local BTN_DATA = m_fnGetWidget(LAY_PVPBTNS,"BTN_DATA") -- 战斗数据

			UIHelper.titleShadow(BTN_FORMATION1, m_i18n[2231])
			UIHelper.titleShadow(BTN_REPLAY1, m_i18n[2229])
			-- UIHelper.titleShadow(BTN_DATA,m_i18n[2169])            


			BTN_FORMATION1:addTouchEventListener(m_tbBtnEvent.onFormation)
			BTN_FORMATION1:setTag(m_tbData.challengeUid)
			BTN_REPLAY1:addTouchEventListener(m_tbBtnEvent.onRepaly)
			BTN_DATA:addTouchEventListener(m_tbBtnEvent.onBattleData)
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
		-- TFD_FIGHT1:setText(UserModel.getFightForceValue())
		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
		-- 敌方名字 战斗力
		require "script/module/arena/ArenaData"
		if(isNpc)then
			-- npc 性别
			local utid = tonumber(m_tbData.enemyData.utid)
			npc_name = ArenaData.getNpcName( tonumber(m_tbData.challengeUid), utid)
			TFD_NAME2:setText(npc_name)
		else
			TFD_NAME2:setText(m_tbData.enemyData.uname)
		end

		TFD_NAME1:setColor(UserModel.getPotentialColor({htid = UserModel.getAvatarHtid(), bright = true}))
		TFD_NAME2:setColor(UserModel.getPotentialColor({htid = m_tbData.enemyData.figure, bright = true}))
		-- 敌方战力
		-- TFD_FIGHT2:setText(m_tbData.atk.force)
		LABN_FIGHT2:setStringValue(m_tbData.atk.force)
		TFD_MONEY:setText(m_tbData.coin)
		TFD_EXP:setText(m_tbData.exp)
		TFD_ARENA_TIMES:setText("+" .. m_tbData.prestige)
		TFD_STAMINA:setEnabled(false)
		img_stamina:setEnabled(false)
	else
		LAY_PVPBTNS:removeFromParent()
		LAY_PVPBTNS_NPC:removeFromParent()
		--npc判断 0为不是 or 1为是
		if(tonumber(m_tbData.enemyData.npc) == 0)then
			LAY_ROBBTNS_NPC:setEnabled(false)
			LAY_ROBBTNS_NPC:removeFromParent()
			local BTN_FORMATION2 = m_fnGetWidget(m_mainWidget,"BTN_FORMATION2") --对方阵容按钮
			local BTN_REPLAY2 = m_fnGetWidget(m_mainWidget,"BTN_REPLAY2")  -- 重播按钮
			local BTN_ROB_AGAIN1 = m_fnGetWidget(m_mainWidget,"BTN_ROBAGAIN1") -- 再抢一次按钮

			UIHelper.titleShadow(BTN_REPLAY2, m_i18n[2229])
			UIHelper.titleShadow(BTN_FORMATION2, m_i18n[2231])
			UIHelper.titleShadow(BTN_ROB_AGAIN1, m_i18n[2230])

			BTN_FORMATION2:addTouchEventListener(m_tbBtnEvent.onFormation)
			--logger:debug(m_tbData.enemyData.uid))
			BTN_FORMATION2:setTag(tonumber(m_tbData.enemyData.uid))

			BTN_REPLAY2:addTouchEventListener(m_tbBtnEvent.onRepaly)
			BTN_ROB_AGAIN1:addTouchEventListener(m_tbBtnEvent.onRobAgain)
		else
			LAY_ROBBTNS:setEnabled(false)
			LAY_ROBBTNS:removeFromParent()
			local BTN_REPLAY3 = m_fnGetWidget(m_mainWidget,"BTN_REPLAY4")  -- 重播按钮
			local BTN_ROB_AGAIN2 = m_fnGetWidget(m_mainWidget,"BTN_ROBAGAIN2") -- 再抢一次按钮

			UIHelper.titleShadow(BTN_REPLAY3, m_i18n[2229])
			UIHelper.titleShadow(BTN_ROB_AGAIN2, m_i18n[2230])

			BTN_REPLAY3:addTouchEventListener(m_tbBtnEvent.onRepaly)
			BTN_ROB_AGAIN2:addTouchEventListener(m_tbBtnEvent.onRobAgain)
		end
		require "script/model/user/UserModel"

		TFD_NAME1:setText(UserModel.getUserName())
		-- TFD_FIGHT1:setText(UserModel.getFightForceValue())
		LABN_FIGHT1:setStringValue(UserModel.getFightForceValue())
		-- 敌方战力,名字
		TFD_NAME2:setText(m_tbData.enemyData.uname)
		-- TFD_FIGHT2:setText(m_tbData.fightFrc)
		LABN_FIGHT2:setStringValue(m_tbData.fightFrc)
		TFD_MONEY:setText(m_tbData.coin)
		TFD_EXP:setText(m_tbData.exp)
		--TFD_STAMINA:setText("-2")
		TFD_STAMINA:setText(tostring(m_tbData.costStamina))
		
		TFD_ARENA_TIMES:setEnabled(false)
		IMG_TIMES:setEnabled(false)
	end


end

function create(_type,tbData,tbBtnEvent)
	isNpc = false
	logger:debug(tbData)
	m_ntype = _type
	m_tbBtnEvent = tbBtnEvent
	m_tbData = tbData
	m_mainWidget = g_fnLoadUI(public_lose)
	m_mainWidget:setSize(g_winSize)
	updateUI()

	-- menghao 升级判断
	local function checkLevelUp( ... )
		logger:debug("checkLevelUp")
		local tbUserInfo = UserModel.getUserInfo()

		local tUpExp = DB_Level_up_exp.getDataById(2)
		local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
		local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
		local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
		local bLvUp = (nExpNum + m_tbData.exp) >= nLevelUpExp; -- 获得经验后是否升级


		logger:debug("nExpNum == %s" , nExpNum)
		logger:debug("m_tbData.exp == %s", m_tbData.exp)
		logger:debug("bLvUp == %s" , bLvUp)
		UserModel.addExpValue(m_tbData.exp, "arena and rob")
		if bLvUp then
			require "script/module/public/GlobalNotify"
			GlobalNotify.postNotify(GlobalNotify.LEVEL_UP)
		end
	end

	--特效
	m_mainWidget.img_vsvg:setVisible(false)
	m_mainWidget.img_gain_bg:setVisible(false)
	local shieldLayout = Layout:create() --屏蔽层 
	shieldLayout:setTouchEnabled(true)
	shieldLayout:setSize(g_winSize)
	m_mainWidget:addChild(shieldLayout)
	local propertyLable = {m_mainWidget.img_gain_bg}
	local IMG_TITLE = m_fnGetWidget(m_mainWidget,"IMG_TITLE")
	EffBattleLose:new(m_mainWidget,IMG_TITLE, function()
			palyBattleVsEffect(m_mainWidget.img_vsvg,m_mainWidget.img_vsvg.img_vs,function()
					palyPropertyEffect(propertyLable,function()
							checkLevelUp()
							shieldLayout:removeFromParent()
						end)
				end)
		end
		)

	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playMusic("audio/bgm/bai.mp3",false)
	m_mainWidget:setTouchEnabled(true)
	m_mainWidget:addTouchEventListener(m_tbBtnEvent.onConfirm)

	m_mainWidget.IMG_FADEIN_EFFECT:loadTexture("ui/2x2.png")
	local node = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
	m_mainWidget.IMG_FADEIN_EFFECT:addNode(node)
	m_mainWidget:setName("public_lose")
	local BTN_REPORT = m_fnGetWidget(m_mainWidget,"BTN_REPORT")  
	BTN_REPORT:addTouchEventListener(m_tbBtnEvent.onReport)
	return m_mainWidget
end

