-- FileName: SkyPieaChooseView.lua
-- Author: menghao
-- Date: 2015-1-14
-- Purpose: 空岛选择对手view


module("SkyPieaChooseView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_tbLayHeros
local m_tbLayFormations

local m_i18n = gi18n
local m_i18nString = gi18nString
--1代表查看信息， 2代表查看阵容
local _nTabValue = 1

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local m_bShowPlayer


local function init(...)
	_nTabValue = 1
end


function destroy(...)
	package.loaded["SkyPieaChooseView"] = nil
end


function moduleName()
	return "SkyPieaChooseView"
end

function showPlayerInfoUI(_state)
	logger:debug(_state)
	local BTN_TAB_1 = m_fnGetWidget(m_UIMain, "BTN_TAB_1")
	local BTN_TAB_2 = m_fnGetWidget(m_UIMain, "BTN_TAB_2")

	BTN_TAB_1:setFocused(_state)
	BTN_TAB_2:setFocused(not _state)
	for i=1,3 do
		m_tbLayHeros[i]:setEnabled(_state)
		m_tbLayFormations[i]:setEnabled( not _state)
	end
end


function changeUI( _sender )
	if(_sender:getTag() == _nTabValue) then
		return 
	else 

	end

	m_bShowPlayer = not m_bShowPlayer
	local btnTab = m_fnGetWidget(m_UIMain, "BTN_TAB")
	if (m_bShowPlayer) then
		-- btnTab:setTitleText(gi18n[2918])
	else
		-- btnTab:setTitleText(gi18n[3652])
	end

	for i=1,3 do
		m_tbLayHeros[i]:setEnabled(m_bShowPlayer)
		m_tbLayFormations[i]:setEnabled(not m_bShowPlayer)
	end
end


function create( tbEvents, tbInfo )
	init()
	logger:debug(tbInfo)
	m_UIMain = g_fnLoadUI("ui/air_choose.json")

	m_bShowPlayer = true
	m_tbLayHeros = {}
	m_tbLayFormations = {}

	local tbBaseRewardInfo = SkyPieaModel.getBaseRewardInfo()
	logger:debug(tbBaseRewardInfo)

	local btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")
	local BTN_CLOSE = m_fnGetWidget(m_UIMain, "BTN_CLOSE")	

	local tfd_look_info 		= m_fnGetWidget(m_UIMain, "tfd_look_info")
	local tfd_look_formation	= m_fnGetWidget(m_UIMain, "tfd_look_formation")
	tfd_look_info:setText(m_i18nString(3652))
	tfd_look_formation:setText(m_i18nString(2918))


	local btnInfo = m_fnGetWidget(m_UIMain, "BTN_TAB")
	local BTN_TAB_1 = m_fnGetWidget(m_UIMain, "BTN_TAB_1")
	local BTN_TAB_2 = m_fnGetWidget(m_UIMain, "BTN_TAB_2")

	BTN_TAB_1:setFocused(true)
	-- UIHelper.titleShadow(btnTab, gi18n[2918])
	btnBack:addTouchEventListener(tbEvents.onBack)
	BTN_CLOSE:addTouchEventListener(tbEvents.onBack)
	UIHelper.titleShadow(BTN_CLOSE, gi18n[2821])

	BTN_TAB_1:addTouchEventListener(tbEvents.onTabPlay)
	BTN_TAB_2:addTouchEventListener(tbEvents.onTabInfo)


	local num = 0
	for k, tbPlayerInfo in pairs(tbInfo) do
		if (tonumber(tbPlayerInfo.attackBefore) == 1) then
			num = tonumber(k)
			local layerColor = CCLayerColor:create(ccc4(30,150,20,120), g_winSize.width, g_winSize.height)
			-- m_UIMain:addNode(layerColor, 9)
		end
	end

	logger:debug(num)
	-- 三个难度的阵容和信息,简单到困难
	for k, tbPlayerInfo in pairs(tbInfo) do
		local i = tonumber(k)
		local imgBG = m_fnGetWidget(m_UIMain, "img_bg_" .. i)

		local btnChallenge = m_fnGetWidget(imgBG, "BTN_CHALLENGE")
		local imgLock = m_fnGetWidget(m_UIMain, "img_lock_" .. i)
		if (num == i or num == 0) then
			imgLock:setEnabled(false)
			btnChallenge:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					require "script/module/SkyPiea/SkyPieaBattle/SkyPieaFormationCtrl"
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
					SkyPieaFormationCtrl.create(i)
				end
			end)
			imgBG:setZOrder(99)
		else
			btnChallenge:setTouchEnabled(false)
			imgLock:setZOrder(99)
			local bgSize = imgBG:getSize()
			local layerColor = CCLayerColor:create(ccc4(00,00,00,120), bgSize.width, bgSize.height)
			imgBG:addNode(layerColor, 9)
			layerColor:setPosition(ccp(-bgSize.width / 2,-bgSize.height / 2))
		end

		-- 玩家信息
		m_tbLayHeros[i] = m_fnGetWidget(imgBG, "lay_hero")
		m_tbLayHeros[i]:setVisible(true)

		local imgIconBG = m_fnGetWidget(imgBG, "img_face_bg")
		local imgIcon = m_fnGetWidget(imgBG, "img_face")
		local tfdFight = m_fnGetWidget(imgBG, "TFD_FIGHT")
		local tfdLv = m_fnGetWidget(imgBG, "TFD_LV")
		local tfdName = m_fnGetWidget(imgBG, "TFD_NAME")
		local TFD_BASE_NUM = m_fnGetWidget(imgBG, "TFD_BASE_NUM")
		local TFD_STAR_NUM = m_fnGetWidget(imgBG, "TFD_STAR_NUM")

		local heroLocalInfo
		local isNPC = false
		local oldHtid

		for k, tbHeroInfo in pairs(tbPlayerInfo.arrHero) do
			if (tbHeroInfo and not table.isEmpty(tbHeroInfo)) then
				oldHtid = tonumber(tbHeroInfo.htid)
			end
		end
		logger:debug(oldHtid)

		if (tonumber(tbPlayerInfo.uid) >= 11001 and tonumber(tbPlayerInfo.uid) <= 16000) then
			require "db/DB_Monsters"
			local htid = DB_Monsters.getDataById(oldHtid).htid
			require "db/DB_Monsters_tmpl"
			heroLocalInfo = DB_Monsters_tmpl.getDataById(htid)
			isNPC = true
		else
			heroLocalInfo = DB_Heroes.getDataById(oldHtid)
		end
        
        logger:debug(isNPC)

		local imgFile = "images/base/hero/head_icon/" .. heroLocalInfo.head_icon_id
		local bgFile = "images/base/potential/color_" .. heroLocalInfo.potential .. ".png"
		imgIconBG:loadTexture(bgFile)
		imgIcon:loadTexture(imgFile)
		local imgBorder = ImageView:create()
		imgBorder:loadTexture("images/base/potential/officer_" .. heroLocalInfo.potential .. ".png")
		imgIcon:addChild(imgBorder)

		require "script/module/arena/ArenaData"
		local npcName = ArenaData.getNpcName( tbPlayerInfo.uid, tbPlayerInfo.uid % 2 + 1 )

		tfdFight:setText(tbPlayerInfo.fightForce)
		

		if(isNPC == true)then
			-- TFD_LV_INFO:setText(m_i18nString(4366,UserModel.getHeroLevel()))
			tfdLv:setText("" .. UserModel.getHeroLevel())
		else
			-- TFD_LV_INFO:setText(m_i18nString(4366,tbPlayerInfo.level))
			tfdLv:setText("" .. tbPlayerInfo.level)
		end

		tfdName:setText(npcName)
		tfdName:setColor(UserModel.getPotentialColor()) -- zhangqi, 2015-07-28
		TFD_BASE_NUM:setText(tbBaseRewardInfo[i].base .. "")
		TFD_STAR_NUM:setText(tbBaseRewardInfo[i].star .. "")

		-- 玩家阵容
		local TFD_LV_INFO = m_fnGetWidget(imgBG, "TFD_LV_INFO")
		local TFD_NAME_INFO = m_fnGetWidget(imgBG, "TFD_NAME_INFO")

		logger:debug(npcName)
		logger:debug(tbPlayerInfo.name)
		if(isNPC == true)then
			TFD_LV_INFO:setText(m_i18nString(4366,UserModel.getHeroLevel()))
			tfdName:setText(npcName)
			TFD_NAME_INFO:setText(npcName)
		else
			TFD_LV_INFO:setText(m_i18nString(4366,tbPlayerInfo.level))
			tfdName:setText(tbPlayerInfo.name)
			TFD_NAME_INFO:setText(tbPlayerInfo.name)
		end

		-- TFD_NAME_INFO:setText(npcName)
		TFD_NAME_INFO:setColor(UserModel.getPotentialColor()) -- zhangqi, 2015-07-28
		m_tbLayFormations[i] = m_fnGetWidget(imgBG, "lay_formation")
		m_tbLayFormations[i]:setEnabled(false)

		local LSV_ICON  = m_fnGetWidget(imgBG, "LSV_ICON")
		local itemDef = LSV_ICON:getItem(0) -- 获取编辑器中的默认cell
		LSV_ICON:setItemModel(itemDef) -- 设置默认的cell
		LSV_ICON:removeAllItems()

		local tbArrHero = {}
		table.hcopy(tbPlayerInfo.arrHero, tbArrHero)
		
		for pos, tbHeroInfo in pairs (tbArrHero) do
			local j = tonumber(pos)
			if (table.isEmpty(tbHeroInfo)) then
				table.remove(tbArrHero,j)
			end
		end	
		
		logger:debug(tbArrHero)	
		-- 从上至下，从左到右，6个头像
		for pos, tbHeroInfo in pairs(tbArrHero) do
			LSV_ICON:pushBackDefaultItem()

			local j = tonumber(pos)
			local item = LSV_ICON:getItem(j-1)
			if (tbHeroInfo and not table.isEmpty(tbHeroInfo)) then
					local imgHeroBG = m_fnGetWidget(item, "img_hero_bg")
					local imgHero = m_fnGetWidget(item, "img_hero")

					local heroLocalInfo
					if (isNPC) then
						require "db/DB_Monsters"
						local htid = DB_Monsters.getDataById(tonumber(tbHeroInfo.htid)).htid
						require "db/DB_Monsters_tmpl"
						heroLocalInfo = DB_Monsters_tmpl.getDataById(htid)
					else
						heroLocalInfo = DB_Heroes.getDataById(tonumber(tbHeroInfo.htid))
					end
					local imgFile = "images/base/hero/head_icon/" .. heroLocalInfo.head_icon_id
					local bgFile = "images/base/potential/color_" .. heroLocalInfo.potential .. ".png"


					imgHeroBG:loadTexture(bgFile)
					imgHero:loadTexture(imgFile)
					local imgBorder = ImageView:create()
					imgBorder:loadTexture("images/base/potential/officer_" .. heroLocalInfo.potential .. ".png")
					imgHero:addChild(imgBorder)
			end
		end
	end

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideSkyPieaView"
	if (GuideModel.getGuideClass() == ksGuideSkypiea and GuideSkyPieaView.guideStep == 4) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createSkyPieaGuide(5, 0, function ( ... )
			GuideCtrl.removeGuide()
		end)
	end

	return m_UIMain
end

