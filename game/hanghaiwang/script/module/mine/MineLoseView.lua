-- FileName: MineLoseView.lua
-- Author: huxiaozhou
-- Date: 2015-06-08
-- Purpose: 抢矿胜利结算面板
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

MineLoseView = class("MineLoseView")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

function MineLoseView:ctor()
	self.layMain = g_fnLoadUI("ui/resource_lose.json")
	self.layMain:setName("resource_lose")
end

function MineLoseView:create(tEvent, tbArgs)

	local layMain = self.layMain

	local tbBtnEvent = tEvent

	local BTN_WUJIANG = m_fnGetWidget(layMain,"BTN_WUJIANG") --武将强化按钮
	local BTN_ZHUANGBEI = m_fnGetWidget(layMain,"BTN_ZHUANGBEI") -- 装备强化按钮
	local BTN_MINGJIANG = m_fnGetWidget(layMain,"BTN_MINGJIANG") 

	local BTN_FORMATION = m_fnGetWidget(layMain,"BTN_FORMATION") --对方阵容按钮   2015-7-14对方阵容修改为发送战报
	local BTN_REPLAY = m_fnGetWidget(layMain,"BTN_REPLAY") -- 重播按钮
	-- local BTN_CONFIRM = m_fnGetWidget(layMain,"BTN_CONFIRM") -- 确定按钮
	local BTN_DATA = m_fnGetWidget(layMain,"BTN_DATA") -- 战斗数据按钮

	local BTN_REPORT = m_fnGetWidget(layMain,"BTN_REPORT")  
	BTN_REPORT:addTouchEventListener(tbBtnEvent.onReport1)

	local labTitle = layMain.TFD_TODO_TITLE
	labTitle:setText(m_i18n[1998])
	UIHelper.labelNewStroke(labTitle, ccc3(0x49, 0x00, 0x00), 3)

	BTN_WUJIANG:addTouchEventListener(tbBtnEvent.onPartner)
	BTN_ZHUANGBEI:addTouchEventListener(tbBtnEvent.onEquip)
	BTN_MINGJIANG:addTouchEventListener(tbBtnEvent.onTrainstar)

	-- BTN_FORMATION:addTouchEventListener(tbBtnEvent.onReport)
	BTN_REPLAY:addTouchEventListener(tbBtnEvent.onRepaly)
	-- BTN_CONFIRM:addTouchEventListener(tbBtnEvent.onConfirm)
	BTN_DATA:addTouchEventListener(tbBtnEvent.onBattleData)
	
	if not tbArgs.uid then
		BTN_FORMATION:setGray(true)
		BTN_FORMATION:setTouchEnabled(false)
		BTN_DATA:setGray(true)
		BTN_DATA:setTouchEnabled(false)
	end

	-- UIHelper.titleShadow(BTN_FORMATION,m_i18n[2164])
	UIHelper.titleShadow(BTN_REPLAY,m_i18n[2229])
	-- UIHelper.titleShadow(BTN_CONFIRM,m_i18n[1029])
	UIHelper.titleShadow(BTN_DATA,m_i18n[2169])                       

	require "script/module/mine/MineMailData"
	-- if(tbArgs.type  ==  MineMailData.ReplayType.KTypeMineMail or tbArgs.type == MailData.ReplayType.KTypeMailBattle) then  
	-- 	--zhangjunwu 2015-7-15 修改为发送战报
	-- 	UIHelper.titleShadow(BTN_FORMATION,m_i18n[2164])
	-- 	BTN_FORMATION:addTouchEventListener(tbBtnEvent.onReport)
	-- else
		--zhangjunwu 2015-7-15 对方阵容
		UIHelper.titleShadow(BTN_FORMATION,m_i18n[2231])
		BTN_FORMATION:addTouchEventListener(tbBtnEvent.onFormation)
	-- end

	-- local TFD_INFO = m_fnGetWidget(layMain,"TFD_INFO") --船长加油哦
	-- TFD_INFO:setText(m_i18nString(1346,""))
	-- UIHelper.labelShadow(TFD_INFO, CCSizeMake(4, -4))
 --    UIHelper.labelStroke(TFD_INFO, nil, 1)

 	layMain.tfd_txt:setText(m_i18n[1996])
	local TFD_NAME1  = m_fnGetWidget(layMain,"TFD_NAME1")
	local TFD_NAME2  = m_fnGetWidget(layMain,"TFD_NAME2")

	TFD_NAME1:setText(UserModel.getUserName())
	TFD_NAME2:setText(tbArgs.uname)

	-- UIHelper.labelNewStroke(TFD_NAME2,ccc3(0x49,0x00,0x00)) -- 2016-3-11描边又注掉了
	-- UIHelper.labelNewStroke(TFD_NAME1,ccc3(0x49,0x00,0x00)) -- 2016-3-11描边又注掉了
    --特效
    local IMG_BG = m_fnGetWidget(layMain,"IMG_BG")
	local IMG_TITLE = m_fnGetWidget(layMain,"IMG_TITLE")
	layMain.img_vsvg_1:setVisible(false)
	local shieldLayout = Layout:create() --屏蔽层 
	shieldLayout:setTouchEnabled(true)
	shieldLayout:setSize(g_winSize)
	layMain:addChild(shieldLayout)
	EffBattleLose:new(IMG_BG,IMG_TITLE,  function ( ... )
		layMain:setTouchEnabled(true)
		layMain:addTouchEventListener(tbBtnEvent.onConfirm)
		palyBattleVsEffect(layMain.img_vsvg_1,layMain.img_vsvg_1.img_vs,function()
					shieldLayout:removeFromParent()
				end)
	end)
	local node = UIHelper.createArmatureNode({
		filePath = "images/effect/worldboss/fadein_continue.ExportJson",
		animationName = "fadein_continue",
		loop = 1,
	})
	layMain.img_txt:addNode(node)
	return layMain
end