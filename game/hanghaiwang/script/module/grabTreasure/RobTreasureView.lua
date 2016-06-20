-- FileName: RobTreasureView.lua
-- Author: zjw
-- Date: 2014-05-10
-- Purpose: 夺宝界面
--[[TODO List]]

module("RobTreasureView", package.seeall)
require "script/model/user/UserModel"
require "script/module/grabTreasure/TreasureService"
require "script/utils/TimeUtil"

-- UI控件引用变量 --
local m_robMainLayout				=nil
local m_labShielTime 				= nil -- 免战时间
local m_labShiel 					= nil --免战剩余 00：00：00
local m_labStamina                  = nil -- 耐力
local m_labFragName                 = nil -- 碎片名字
local m_labFreeWar                  = nil --免战描述
local m_btnRefresh                  = nil --换一批对手
local m_btnBack                     = nil --返回按钮
local TFD_GRAB_COST_ENDURANCE 		= nil --夺宝指针的数量

m_btnItemShop  = {btnItemShop1, btnItemShop2, btnItemShop3,btnItemShop4} -- 4个船只
m_btnItemShopBg  = {btnItemShopBg1, btnItemShopBg2, btnItemShopBg3,btnItemShopBg4} -- 4个船只背景

-- 模块局部变量 --
local m_tbInfo              		= nil	   				--按钮事件集合
local m_nFragid             		= nil					--要抢夺的宝物碎片的id
local m_tbFragInfo         			= nil					--宝物碎片信息
local m_fnGetWidget         		= g_fnGetWidgetByName
local m_i18nString 					= gi18nString

local tbUserInfo           			= nil 					--玩家的信息
local m_nCurUserLevel       		= nil     				-- 记录玩家当前的等级
local m_nStaminaMax         		= nil 					-- 耐力上限
local m_nCurStamina         		= nil          			--耐力值
local m_tbRobberData        		= nil                   --抢夺对手数据

local m_robJson             		= 	"ui/grab_list.json"
local TAG_AVATAR 					= 10000

local function init(...)
	m_nFragid = nil
	tbUserInfo = UserModel.getUserInfo()
	m_nCurUserLevel = UserModel.getHeroLevel()       -- 记录玩家当前的等级
	m_nStaminaMax = UserModel.getMaxStaminaNumber() -- 耐力上限
	m_nCurStamina = tbUserInfo.stamina             --耐力值
end

function destroy(...)
	package.loaded["RobTreasureView"] = nil
end

function moduleName()
	return "RobTreasureView"
end

--初始化widget
local function initWidget( ... )
	m_labShiel = m_fnGetWidget(m_robMainLayout,"tfd_avoid_txt") --免战剩余
	m_labShiel:setText(m_i18nString(2408))

	-- local gi18n_endurance_txt = m_fnGetWidget(m_robMainLayout,"tfd_endurance_txt")  --消耗
	-- UIHelper.labelEffect(gi18n_endurance_txt,m_i18nString(2409))

	-- local gi18n_rob_txt = m_fnGetWidget(m_robMainLayout,"tfd_grab_cost")  --拥有
	-- UIHelper.labelEffect(gi18n_rob_txt,m_i18nString(4306))

	-- local tfd_cost_num = m_fnGetWidget(m_robMainLayout,"tfd_cost_num")  --个或耐力
	-- UIHelper.labelEffect(tfd_cost_num,"个或耐力")

	-- local tfd_cost_endurance_num = m_fnGetWidget(m_robMainLayout,"tfd_cost_endurance_num")  --点
	-- UIHelper.labelEffect(tfd_cost_endurance_num,"点")

	m_labShielTime = m_fnGetWidget(m_robMainLayout,"TFD_AVOID_TIME")

	m_labFragName = m_fnGetWidget(m_robMainLayout,"TFD_TREASURE_NAME")
	m_labFreeWar  = m_fnGetWidget(m_robMainLayout,"lay_txt")

	m_btnRefresh = m_fnGetWidget(m_robMainLayout,"BTN_REFRESH")
	m_btnRefresh:addTouchEventListener(m_tbInfo.onRefresh)
	--UIHelper.titleShadow(m_btnRefresh,m_i18nString(2413))


	local tbParams = {
		filePath  = "images/effect/grabTreasure/refresh.ExportJson",

		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
			--  sender:removeFromParentAndCleanup(true)
			end
		end,

	}


	local effectNode = UIHelper.createArmatureNode(tbParams)

	m_btnRefresh:addNode(effectNode,-100,100);
	effectNode:getAnimation():play("refresh", -1, -1, 0)
	effectNode:getAnimation():gotoAndPlay(40)

	m_btnBack= m_fnGetWidget(m_robMainLayout,"BTN_BACK")
	m_btnBack:addTouchEventListener(m_tbInfo.onBack)
	UIHelper.titleShadow(m_btnBack,m_i18nString(1019))

end

--[[desc:点击夺宝按钮
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function shipBtnCall( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local btnTag = sender:getTag()
		local curRobberData = m_tbRobberData[btnTag]



		if( (UserModel.getStaminaNumber()-2)  < 0 )then
			require "script/module/arena/ArenaBuyCtrl"
			local buyView = ArenaBuyCtrl.createForArena()
			LayerManager.addLayout(buyView)
			return
		end

		require "script/module/grabTreasure/ConfirmRobCtrl"
		LayerManager.addLayout(ConfirmRobCtrl.create(curRobberData,m_tbFragInfo))
	end
end

--更新列表
function updateRobPlayerInfo()
	m_tbRobberData = TreasureData.getRobberList()
	logger:debug(m_tbRobberData)
	local robInfo = nil
	for i=1,table.count(m_tbRobberData) do

		robInfo = m_tbRobberData[i]

		local robItem = m_btnItemShopBg[i] --m_fnGetWidget(m_robMainLayout,"btn_ship_" .. i)
		robItem:setTag(i)
		robItem:addTouchEventListener(m_tbInfo.onFrag)

		local labRoberName = m_fnGetWidget(robItem,"TFD_PALYER_NAME_" .. i)   --name
		--labRoberName:setText(robInfo.uname)
		UIHelper.labelEffect(labRoberName,robInfo.uname)

		local roberNameColor = {}
		if(tonumber(robInfo.npc) == 1) then
			roberNameColor =  UserModel.getPotentialColor({htid = robInfo.squad[1],bright = true}) 
		else
			roberNameColor = UserModel.getPotentialColor({htid = robInfo.figure,bright = true}) 
		end
		labRoberName:setColor(roberNameColor)

		local labRoberRatio= m_fnGetWidget(robItem,"IMG_PROBABILITY_" .. i)   --概率
		--labRoberRatio:setText(robInfo.ratioDesc)
		--UIHelper.labelEffect(labRoberRatio,robInfo.ratioDesc)
		--概率颜色
		local imgRatio = TreasureUtil.getPercentImageByName(robInfo.ratioDesc)
		logger:debug(imgRatio)
		labRoberRatio:loadTexture(imgRatio)

		--w玩家等级
		local LABN_Level = m_fnGetWidget(robItem,"LABN_PALYER_LEVEL_" .. i)
		--UIHelper.labelAddStroke(labLevel,robInfo.level)
		LABN_Level:setStringValue(tonumber(robInfo.level))

		--船只模型
		local btnShip = m_btnItemShop[i] --  m_fnGetWidget(robItem,"BTN_SHIP_MODEL_" .. i)
		local imgPressPath,imgNomalPath = TreasureUtil.getShipImageByName(robInfo)
		logger:debug(imgPressPath)
		btnShip:loadTextureNormal(imgNomalPath)
		btnShip:loadTexturePressed(imgPressPath)
		btnShip:setScaleX(1)
		if(tonumber(robInfo.npc) == 1) then
			btnShip:setScaleX(-1)
		end


		btnShip:setTag(i)
		btnShip:addTouchEventListener(m_tbInfo.onFrag)
		--头像
		logger:debug(robInfo.squad[1])
		local heroIcon = nil
		-- 处理npc 的状态
		if(tonumber(robInfo.npc) == 1) then
			heroIcon = HeroUtil.createNPCHeroIconBtnByHtid(robInfo.hid)
		else
			local headIconSprite,heroInfo = HeroUtil.createHeroIconBtnByHtid(robInfo.figure)
			heroIcon = headIconSprite
		end

		local avatarBg = m_fnGetWidget(robItem,"IMG_ICON_BG_" .. i)
		avatarBg:removeAllChildren()
		if(heroIcon)then
			avatarBg:addChild(heroIcon,1,TAG_AVATAR)
		end
	end
end

local function setShieldLabVisible( bVis )
	m_labShielTime:setVisible(bVis)
	m_labShiel:setVisible(bVis)
end

--[[
    @des:       刷新免战时间定时器
]]
function updateShieldTime( ... )
	local shieldTimeString = TimeUtil.getTimeString(TreasureData.getHaveShieldTime())

	UIHelper.labelEffect(m_labShielTime,shieldTimeString)

	if(TreasureData.getHaveShieldTime() <= 0) then
		setShieldLabVisible(false)
	else
		setShieldLabVisible(true)
	end
end

--设置ui 控件的内容
local function setWidget(  )
	if(TreasureData.getHaveShieldTime() <= 0) then
		setShieldLabVisible(false)
	else
		setShieldLabVisible(true)
	end

	--顶部耐力设置
	UIHelper.labelEffect(m_labFragName,m_tbFragInfo.name .. m_i18nString(2448))  --碎片名称
	--底部无法抢夺时间说明
	local startTime , endTime = TreasureData.getShieldStartAndEndTime()

	local i18nLabEveryDay = m_fnGetWidget(m_labFreeWar,"tfd_everyday_txt")   --每天
	local LabStartTime = m_fnGetWidget(m_labFreeWar,"tfd_zero_txt")			--0点
	local i18nLabTo = m_fnGetWidget(m_labFreeWar,"tfd_until_txt")       	--到
	local LababEndTime = m_fnGetWidget(m_labFreeWar,"tfd_ten_txt")			--十点
	local i18nLabNoRob = m_fnGetWidget(m_labFreeWar,"tfd_noway_txt") 		--无法抢夺碎片

	i18nLabEveryDay:setText(m_i18nString(2410))
	UIHelper.labelEffect(i18nLabEveryDay,m_i18nString(2410))
	UIHelper.labelEffect(LabStartTime,startTime)
	UIHelper.labelEffect(i18nLabTo,m_i18nString(2411))
	UIHelper.labelEffect(LababEndTime,endTime)
	UIHelper.labelEffect(i18nLabNoRob,m_i18nString(2412))
end

--[[desc:更新耐力 --modife 修改为更新夺宝次数
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function updateStaminaLabel()
	logger:debug("开始更新耐力，那么m_robMainLayout是不是为nil呢？")
	logger:debug(m_robMainLayout)
	if(m_robMainLayout) then
	-- m_nCurStamina =  UserModel.getStaminaNumber()            --耐力值
	-- logger:debug(m_nCurStamina)
	-- --m_labStamina:setText(tostring(m_nCurStamina) .. "/" .. tostring(m_nStaminaMax))
	-- TFD_GRAB_COST_ENDURANCE:setText(tostring(TreasureData.nRobItemNum))
	end

end
--[[desc:--modife 修改为更新夺宝次数
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function updateRobItemLabel()
	if(m_robMainLayout) then
	-- TFD_GRAB_COST_ENDURANCE:setText(tostring(TreasureData.nRobItemNum))
	end
end

--[[desc:创建夺宝列表view
    arg1: 抢夺碎片id
    return: 返回view 
—]]
function create(tbInfo)
	init()

	m_robMainLayout = g_fnLoadUI(m_robJson)
	m_robMainLayout:setSize(g_winSize)

	m_tbInfo = tbInfo
	m_nFragid = tbInfo.fragId
	--碎片id
	m_tbFragInfo = TreasureData.getFragmentInfo(m_nFragid)      --碎片信息

	-- TFD_GRAB_COST_ENDURANCE 	= m_fnGetWidget(m_robMainLayout,"TFD_GRAB_COST_ENDURANCE")
	-- local itemNum = ItemUtil.getCacheItemNumBy(60020)

	-- TFD_GRAB_COST_ENDURANCE:setText(tostring(TreasureData.nRobItemNum))

	local IMG_GRAB_BG1 			= m_fnGetWidget(m_robMainLayout,"IMG_GRAB_BG1")
	IMG_GRAB_BG1:setScale(g_fScaleX)

	local lay_easy_information  = m_fnGetWidget(m_robMainLayout,"lay_easy_information")
	lay_easy_information:setSize(CCSizeMake(lay_easy_information:getSize().width * g_fScaleX, lay_easy_information:getSize().height * g_fScaleX))


	-- local img_small_bg 			= m_fnGetWidget(m_robMainLayout,"img_small_bg")
	-- img_small_bg:setScale(g_fScaleX)

	-- local img_chain 			= m_fnGetWidget(m_robMainLayout,"img_chain")
	-- img_chain:setScale(g_fScaleX)

	local img_bottom_menu_bg    = m_fnGetWidget(m_robMainLayout,"img_bottom_menu_bg")
	img_bottom_menu_bg:setScale(g_fScaleX)


	for i = 1, 4 do
		m_btnItemShopBg[i] = m_fnGetWidget(m_robMainLayout,"btn_ship_" .. i)
		m_btnItemShop[i] = m_fnGetWidget(m_robMainLayout,"BTN_SHIP_MODEL_" .. i)
	end

	--初始化控件
	initWidget()
	--给控件赋值
	setWidget()
	--设置免战时间
	setShieldLabVisible(false)
	--更新玩家列表
	updateRobPlayerInfo()
	--新手引导
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideRobView"
	if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createRobGuide(4)
	end

	return m_robMainLayout
end

