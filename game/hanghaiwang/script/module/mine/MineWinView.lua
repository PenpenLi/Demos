-- FileName: MineWinView.lua
-- Author: huxiaozhou
-- Date: 2015-06-01
-- Purpose: 抢矿胜利结算面板
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

MineWinView = class("MineWinView")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

function MineWinView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/resource_win.json")
	self.layMain:setName("resource_win")
end

function MineWinView:create(tbArgs)

	self.tbArgs = tbArgs

	local layMain = self.layMain

	local IMG_RAINBOW = m_fnGetWidget(layMain,"img_rainbow")
	local IMG_TITLE = m_fnGetWidget(layMain,"img_title")
	layMain.img_vsvg:setVisible(false)
	local shieldLayout = Layout:create() --屏蔽层 
	shieldLayout:setTouchEnabled(true)
	shieldLayout:setSize(g_winSize)
	layMain:addChild(shieldLayout)

	local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW, callback = function ( ... )
		layMain:setTouchEnabled(true)
		layMain:addTouchEventListener(self.tbArgs.onConfirm)
		palyBattleVsEffect(layMain.img_vsvg,layMain.img_vsvg.img_vs,function()
					shieldLayout:removeFromParent()
				end)
	end})

	local BTN_FORMATION = m_fnGetWidget(layMain,"BTN_FORMATION") 		--对方阵容按钮
	local BTN_AGAIN = m_fnGetWidget(layMain,"BTN_AGAIN")				-- 重播按钮
	-- local BTN_CONFIRM = m_fnGetWidget(layMain,"BTN_CONFIRM") 			--确定按钮
	local BTN_DATA = m_fnGetWidget(layMain,"BTN_DATA")                  --战斗数据
	local BTN_REPORT = m_fnGetWidget(layMain,"BTN_REPORT")  
	BTN_REPORT:addTouchEventListener(self.tbArgs.onReport1)
	if not self.tbArgs.uid then
		BTN_FORMATION:setGray(true)
		BTN_FORMATION:setTouchEnabled(false)
		BTN_DATA:setGray(true)
		BTN_DATA:setTouchEnabled(false)
		BTN_AGAIN:setGray(true)
		BTN_AGAIN:setTouchEnabled(false)
	end
	BTN_AGAIN:addTouchEventListener(self.tbArgs.onRepaly)
	-- BTN_CONFIRM:addTouchEventListener(self.tbArgs.onConfirm)
	BTN_DATA:addTouchEventListener(self.tbArgs.onBattleData)

	--zhangjunwu 2015-7-15 对方阵容修改为发送战报

	UIHelper.titleShadow(BTN_AGAIN,m_i18n[2229])
	-- UIHelper.titleShadow(BTN_CONFIRM,m_i18n[1029])
	UIHelper.titleShadow(BTN_DATA,m_i18n[2169])                         

	require "script/module/mine/MineMailData"
	-- if(tbArgs.type  ==  MineMailData.ReplayType.KTypeMineMail or tbArgs.type == MailData.ReplayType.KTypeMailBattle) then  
	-- 	--zhangjunwu 2015-7-15 修改为发送战报
	-- 	UIHelper.titleShadow(BTN_FORMATION,m_i18n[2164])
	-- 	BTN_FORMATION:addTouchEventListener(self.tbArgs.onReport)
	-- else
		--zhangjunwu 2015-7-15 对方阵容
		UIHelper.titleShadow(BTN_FORMATION,m_i18n[2231])
		BTN_FORMATION:addTouchEventListener(self.tbArgs.onFormation)
	-- end

	local TFD_NAME1  = m_fnGetWidget(layMain,"TFD_NAME1")
	local TFD_NAME2  = m_fnGetWidget(layMain,"TFD_NAME2")
	
	TFD_NAME1:setText(UserModel.getUserName())
		
	logger:debug("tbArgs.uname = %s", self.tbArgs.uname)
	TFD_NAME2:setText(self.tbArgs.uname)
	
	-- UIHelper.labelNewStroke(TFD_NAME2,ccc3(0x49,0x00,0x00)) -- 2016-3-11描边又注掉了
	-- UIHelper.labelNewStroke(TFD_NAME1,ccc3(0x49,0x00,0x00)) -- 2016-3-11描边又注掉了
	local node = UIHelper.createArmatureNode({
		filePath = "images/effect/worldboss/fadein_continue.ExportJson",
		animationName = "fadein_continue",
		loop = 1,
	})
	layMain.img_txt:addNode(node)
	return layMain
end

