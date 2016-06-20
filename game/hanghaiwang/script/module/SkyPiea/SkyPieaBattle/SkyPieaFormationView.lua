-- FileName: SkyPieaFormationView.lua
-- Author: menghao
-- Date: 2015-1-14
-- Purpose: 空岛阵容view


module("SkyPieaFormationView", package.seeall)


-- UI控件引用变量 --
local m_UIMain


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

local m_indexBegin
local m_indexEnded

local m_tbRecs
local m_tbLays
local m_tbImgFormations

local m_tbFormationInfo
local m_tbHeroInfo
local m_tbIsDead

local m_touchLayer
local m_sizeOfOneLay

local m_tbBuffInfo 			= nil 	 --可做用于武将的buff信息
local m_nBuffTimes 			= 0 	 --可做用于武将的buff的次数
local m_tbHerosSelected 	= {}     --此buff可以作用于的武将的hid集合

local m_tbRageBars 				-- 怒气条引用tb
local m_tbCurrHpBars 			-- 血条引用tb
local m_tbImageDead 			-- 死亡标志引用tb


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaFormationView"] = nil
end


function moduleName()
	return "SkyPieaFormationView"
end


function getRectI( i )
	local imgFormation = m_tbImgFormations[i]
	local pos = imgFormation:getWorldPosition()
	local size = imgFormation:getSize()
	local scaleX = imgFormation:getScaleX()
	local scaleY = imgFormation:getScaleY()
	local x = pos.x - size.width * scaleX * 0.5
	local y = pos.y - size.height * scaleY * 0.5
	m_tbRecs[i] = CCRectMake(x, y, size.width * scaleX, size.height * scaleY)
end


function getIndexByPos( pos )
	for i=1,9 do
		if (not m_tbRecs[i]) then
			getRectI(i)
		end
		if (m_tbRecs[i]:containsPoint(pos)) then
			return i
		end
	end
end


local function revertUI( index )
	moveWidget(m_tbLays[index], m_tbImgFormations[index])
end


local function swapUI( index1, index2 )
	m_tbIsDead[index1], m_tbIsDead[index2] = m_tbIsDead[index2], m_tbIsDead[index1]
	m_tbLays[index1], m_tbLays[index2] = m_tbLays[index2], m_tbLays[index1]
	moveWidget(m_tbLays[index1], m_tbImgFormations[index1])
	moveWidget(m_tbLays[index2], m_tbImgFormations[index2])
end


function changePos( index1, index2 )
	-- 上下交换时如果下面是死人或者有一个没有人不让换
	if (index1 > 6 and index2 <= 6 and (m_tbIsDead[index1] or m_tbFormationInfo[index1] <= 0 or m_tbFormationInfo[index2] <= 0)) then
		revertUI(index1)
		if (m_tbIsDead[index1]) then
			ShowNotice.showShellInfo(gi18n[5456])
		else
			ShowNotice.showShellInfo(gi18n[5310])
		end
		return
	end
	if (index2 > 6 and index1 <= 6 and (m_tbIsDead[index2] or m_tbFormationInfo[index1] <= 0 or m_tbFormationInfo[index2] <= 0)) then
		revertUI(index1)
		if (m_tbIsDead[index2]) then
			ShowNotice.showShellInfo(gi18n[5456])
		else
			ShowNotice.showShellInfo(gi18n[5310])
		end
		return
	end

	-- 如果在发奖或者已重置
	if (SkyPieaUtil.isShowRewardTimeAlert() == true) then
		revertUI(index1)
		return
	end

	-- 发请求的时候就要发交换后的，所以要在这里交换数据
	m_tbFormationInfo[index1], m_tbFormationInfo[index2] = m_tbFormationInfo[index2], m_tbFormationInfo[index1]
	if (not SkyPieaModel.getIsFormationLock()) then
		swapUI(index1, index2)
		return
	end

	-- 发请求
	local args = CCArray:create()
	local arrFormation = CCArray:create()
	local arrBench = CCArray:create()
	for i=1,9 do
		local hid = m_tbFormationInfo[i]
		if (i <= 6) then
			arrFormation:addObject(CCInteger:create(hid))
		else
			arrBench:addObject(CCInteger:create(hid))
		end
	end
	args:addObject(arrFormation)
	args:addObject(arrBench)
	require "script/network/RequestCenter"
	RequestCenter.skyPieaSetFormation(function ( cbFlag, dictData, bRet )
		if (dictData.err ~= "ok") then
			m_tbFormationInfo[index1], m_tbFormationInfo[index2] = m_tbFormationInfo[index2], m_tbFormationInfo[index1]
			revertUI(index1)
			ShowNotice.showShellInfo("setPassFormation 出错了")
			return
		end

		swapUI(index1, index2)
	end, args)
end


function moveWidget( layout, parent )
	layout:retain()
	layout:removeFromParent()
	parent:addChild(layout, 10)
	layout:release()
end


function onTouch( touchType , x , y)
	if ( touchType ==  "began" ) then
		-- 如果已经有选择的
		if (m_indexBegin) then
			return false
		end
		m_indexBegin = getIndexByPos(ccp(x, y))

		-- 没有点在某个格子上或者格子上没有人
		if (not m_indexBegin or m_tbFormationInfo[m_indexBegin] <= 0) then
			m_indexBegin = nil
			return false
		end

		moveWidget(m_tbLays[m_indexBegin], m_touchLayer)
		m_tbLays[m_indexBegin]:setPosition(ccp(x - m_sizeOfOneLay.width / 2, y - m_sizeOfOneLay.height / 2))
		return true
	elseif ( touchType ==  "moved" ) then
		m_tbLays[m_indexBegin]:setPosition(ccp(x - m_sizeOfOneLay.width / 2, y - m_sizeOfOneLay.height / 2))
	elseif (touchType == "ended" ) then
		m_indexEnded = getIndexByPos(ccp(x, y))
		if (m_indexEnded and Buzhen.isOpenedByPosition(m_indexEnded - 1) and (m_indexBegin ~= m_indexEnded)) then
			changePos(m_indexBegin, m_indexEnded)
		else
			revertUI(m_indexBegin)
		end
		m_indexEnded = nil
		m_indexBegin = nil
	end
end


--判断次buff是否已经作用于此伙伴了
local function isBuffEffectTwice(hid)
	for i,v in ipairs(m_tbHerosSelected) do
		if(tonumber(hid) == tonumber(v)) then
			ShowNotice.showShellInfo(m_i18nString(5478))  --"同一buff只可以作用于一个伙伴一次"
			return true
		end
	end

	return false
end


--用来处理buff层的点击事件，包括回复血量，回复怒气，复活伙伴  --zhangjunwu
local function OnHeroCardBtn( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("tbEvent.OnHeroCardBtn")
		local index = sender:getTag()

		local hid = tostring(m_tbFormationInfo[sender:getTag()])
		local buffType = m_tbBuffInfo.buffType

		--回复血量
		if(tonumber(buffType) == SkyPieaModel.BUFFTYPE.RECOVER_HP_BUFF)then
			logger:debug(tonumber(m_tbHeroInfo[hid].currHp))
			logger:debug(isBuffEffectTwice(hid))

			local curPercent = m_tbHeroInfo[hid].currHp / SkyPieaModel.getPercentBase() * 100

			if(tonumber(m_tbHeroInfo[hid].currHp) == 0) then
				ShowNotice.showShellInfo(m_i18nString(5443))  --5443] = "该伙伴已死亡，无法恢复血量",
				return
			end

			if(m_nBuffTimes >= m_tbBuffInfo.buffEffectCount) then
				ShowNotice.showShellInfo(m_i18nString(5444))  --[5444] = "恢复次数已用完",

			elseif(tonumber(curPercent) >= 100) then
				ShowNotice.showShellInfo(m_i18nString(5445))  --	[5445] = "该伙伴为满血状态，无法恢复血量",

			elseif(isBuffEffectTwice(hid) == false) then
				local nowPercent = m_tbHeroInfo[hid].currHp / SkyPieaModel.getPercentBase() * 100 + m_tbBuffInfo.recoveHp
				local curPercent = nowPercent  > 100 and 100 or nowPercent
				m_tbCurrHpBars[index]:setPercent(curPercent)
				m_tbHeroInfo[hid].currHp = curPercent * SkyPieaModel.getPercentBase() / 100

				SkyPieaModel.setHeroInfo(m_tbHeroInfo)
				table.insert(m_tbHerosSelected,hid)
				m_nBuffTimes = m_nBuffTimes + 1

				ShowNotice.showShellInfo(m_tbBuffInfo.des)
			end
			--回复怒气
		elseif(buffType == SkyPieaModel.BUFFTYPE.RECOVER_RAGE_BUFF)then
			if(tonumber(m_tbHeroInfo[hid].currHp)== 0) then
				ShowNotice.showShellInfo(m_i18nString(5446))  		--[5446] = "该伙伴已死亡，无法恢复怒气",
				return
			end

			if(m_nBuffTimes >= m_tbBuffInfo.buffEffectCount) then
				ShowNotice.showShellInfo(m_i18nString(5444))  		----[5444] = "恢复次数已用完",

			elseif(isBuffEffectTwice(hid) == false) then
				ShowNotice.showShellInfo(m_tbBuffInfo.des)

				m_tbHeroInfo[hid].currRage = m_tbHeroInfo[hid].currRage + m_tbBuffInfo.recoveRage
				SkyPieaModel.setHeroInfo(m_tbHeroInfo)
				--更新
				m_tbRageBars[index]:setValue(m_tbHeroInfo[hid].currRage)

				table.insert(m_tbHerosSelected,hid)
				m_nBuffTimes = m_nBuffTimes + 1
			end
			--复活一个武将并且回复血量
		elseif(buffType == SkyPieaModel.BUFFTYPE.REBORN_BUFF)then
			if(m_nBuffTimes >= m_tbBuffInfo.buffEffectCount) then
				ShowNotice.showShellInfo(m_i18nString(5447))   	--[5447] = "复活次数已用完，无法复活更多伙伴",
			else
				if(tonumber(m_tbHeroInfo[hid].currHp) > 0) then

					ShowNotice.showShellInfo(m_i18nString(5448))  --[5448] = "该伙伴未死亡",
				else
					ShowNotice.showShellInfo(m_tbBuffInfo.des)

					--更新血条
					local loadHp = m_fnGetWidget(sender, "LOAD_PROGRESS") -- 血条

					local nowPercent = m_tbHeroInfo[hid].currHp / SkyPieaModel.getPercentBase() * 100 + m_tbBuffInfo.rebornRecoveHP
					local curPercent = nowPercent  > 100 and 100 or nowPercent
					m_tbCurrHpBars[index]:setPercent(curPercent)
					m_tbHeroInfo[hid].currHp = curPercent * SkyPieaModel.getPercentBase() / 100
					m_tbImageDead[index]:setEnabled(false)
					SkyPieaModel.setHeroInfo(m_tbHeroInfo)
					table.insert(m_tbHerosSelected,hid)
					m_nBuffTimes = m_nBuffTimes + 1
				end
			end
		end
	end
end


function upUIByInfo(i, hid)
	local imgFormation
	if (i <= 6) then
		imgFormation =  m_fnGetWidget(m_UIMain, "IMG_ZHENXING" .. i)
	else
		imgFormation =  m_fnGetWidget(m_UIMain, "IMG_TIBU" .. i - 6)
	end
	m_tbImgFormations[i] = imgFormation

	-- 解锁相关
	if (i == 1 or i > 6) then
		local imgLock = m_fnGetWidget(imgFormation, "IMG_ZHENXING_LOCK")
		local tfdJikaiqi = m_fnGetWidget(imgFormation, "TFD_JIKAIQI")
		local tfdJikaiqiNum = m_fnGetWidget(imgFormation, "TFD_JIKAIQI_LV")

		require "script/module/formation/Buzhen"
		local isOpen, openLv = Buzhen.isOpenedByPosition(i - 1)
		logger:debug(isOpen)
		logger:debug(openLv)
		logger:debug(i)
		if (isOpen) then
			imgLock:setEnabled(false)
			imgLock:setVisible(false)
		else
			tfdJikaiqi:setText(gi18n[5531])
			tfdJikaiqiNum:setText(openLv)
		end
	end

	local layTotal = m_fnGetWidget(imgFormation, "LAY_TOTAL") 	-- 层，用于拖动
	m_tbLays[i] = layTotal
	m_sizeOfOneLay = layTotal:getSize()

	m_tbIsDead[i] = false
	if (hid and tonumber(hid) > 0) then
		-- 伙伴信息
		local heroInfo = HeroModel.getHeroByHid(hid)

		local dbHero = DB_Heroes.getDataById(tonumber(heroInfo.htid))
		local heroOffset = db_hero_offset_util.getHeroImgOffset(dbHero.action_module_id)
		local heroImgFile = "images/base/hero/action_module/" .. dbHero.action_module_id
		local star_lv = dbHero.star_lv 

		local heroBGImgFile = "images/battle/card/card_raw_" .. star_lv .. ".png"

		logger:debug(heroOffset)

		-- 伙伴背影图
		local layHero = m_fnGetWidget(imgFormation, "lay_hero")
		-- -- require "script/battle/BattleLayer"
		-- local card = BattleLayer.createBattleCard(hid)
		-- layHero:addChild(card)
		if (m_tbBuffInfo) then 		-- 如果是来自buff层
			layHero:setTouchEnabled(false)
			layTotal:setTouchEnabled(false)
			imgFormation:setTag(i)
			imgFormation:setEnabled(true)
			imgFormation:setTouchEnabled(true)
			imgFormation:addTouchEventListener(OnHeroCardBtn)
		end

		local shadowSprint = ImageView:create()
		shadowSprint:loadTexture("images/battle/card/" .. "card_shadow.png")
		shadowSprint:setPosition(ccp(layHero:getSize().width / 2, layHero:getSize().height / 2 - 1))
		layHero:addChild(shadowSprint)
		shadowSprint:setScaleX(1.05)


		local imgHeroBG = ImageView:create()
		imgHeroBG:loadTexture(heroBGImgFile)
		imgHeroBG:setPosition(ccp(layHero:getSize().width / 2, layHero:getSize().height / 2))
		layHero:addChild(imgHeroBG)



		-- 伙伴形象图
		local imgHero = ImageView:create()
		imgHero:loadTexture(heroImgFile)
		imgHero:setAnchorPoint(ccp(0.5, 0))
		imgHero:setPosition(ccp(0, heroOffset[2] - 50))
		imgHeroBG:addChild(imgHero)


		-- 怒气条
		require "script/battle/BATTLE_CLASS_NAME"
		require "script/battle/BATTLE_CONST"
		require "script/battle/ObjectTool"
		require "script/battle/BattleURLManager"
		require "script/battle/BSTree/BattleNodeFactory"
		require "script/battle/data/db_shareTextureList_util"
		local rageBar = require(BATTLE_CLASS_NAME.BattleHeroRageBar).new(false)
		rageBar.psize = imgFormation:getContentSize()
		rageBar:setPosition(imgFormation:getContentSize().width * -0.397, imgFormation:getContentSize().height * -0.396)
		imgHeroBG:addNode(rageBar)
		m_tbRageBars[i] = rageBar

		-- 血条和死亡标志
		local loadHp = m_fnGetWidget(imgFormation, "LOAD_PROGRESS") -- 血条
		local imgDead = m_fnGetWidget(imgFormation, "IMG_DEAD") 	-- 已死亡标志
		m_tbCurrHpBars[i] = loadHp
		m_tbImageDead[i] = imgDead

		if (m_tbHeroInfo) then
			local currHp = tonumber(m_tbHeroInfo[tostring(hid)].currHp)
			local currRage = tonumber(m_tbHeroInfo[tostring(hid)].currRage)
			loadHp:setPercent(currHp / SkyPieaModel.getPercentBase() * 100)
			if (currHp > 0) then
				imgDead:setEnabled(false)
			else
				m_tbIsDead[i] = true
			end
			rageBar:setValue(currRage)
		else
			local currRage = (tonumber(heroInfo.evolve_level) >= 6) and 5 or 2
			loadHp:setPercent(100)
			rageBar:setValue(currRage)
			imgDead:setEnabled(false)
		end
		imgDead:setZOrder(9)

		-- 伙伴其他信息
		local tfdLv = m_fnGetWidget(imgFormation, "tfd_level") 		-- 等级
		local tfdLvNum = m_fnGetWidget(imgFormation, "TFD_LV") 		-- 等级
		local labnAdd = m_fnGetWidget(imgFormation, "LABN_ADD") 	-- 进阶等级
		local tfdName = m_fnGetWidget(imgFormation, "TFD_NAME") 	-- 伙伴名

		tfdLv:setText("Lv.")
		tfdLvNum:setText(heroInfo.level)
		labnAdd:setStringValue(heroInfo.evolve_level)
		tfdName:setText(dbHero.name)
		tfdName:setColor(g_QulityColor[tonumber(dbHero.star_lv)])
	else
		layTotal:setEnabled(false)
	end
end


function create( onStartFight ,tbBuffInfo)
	-- 一些数据
	m_tbBuffInfo = tbBuffInfo
	m_nBuffTimes 		= 0
	m_tbHerosSelected 	= {}

	m_tbRageBars = {}
	m_tbCurrHpBars = {}
	m_tbImageDead = {}

	m_tbFormationInfo = SkyPieaModel.getFormationInfo()
	m_tbHeroInfo = SkyPieaModel.getHeroInfo()

	m_tbIsDead = {}
	m_tbRecs = {}
	m_tbLays = {}
	m_tbImgFormations = {}

	m_UIMain = g_fnLoadUI("ui/air_formation.json")

	-- 三个按钮
	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	local btnStart = m_fnGetWidget(m_UIMain, "BTN_START")
	UIHelper.titleShadow(btnStart, gi18n[5530])

	if(tbBuffInfo) then
		btnStart:addTouchEventListener(function (sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				tbBuffInfo.fnDealBuff(m_tbHerosSelected)
			end
		end)

		btnClose:addTouchEventListener(function (sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				tbBuffInfo.fnDealBuff(m_tbHerosSelected)
			end
		end)
		UIHelper.titleShadow(btnStart, m_i18nString(2920))
	else
		btnStart:addTouchEventListener(onStartFight)
		btnClose:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCloseEffect()
				MainSkyPieaView.backLufei()
				LayerManager.removeLayout()
			end
		end)

		m_touchLayer = CCLayer:create()
		m_touchLayer:setTouchMode(kCCTouchesOneByOne)
		m_touchLayer:registerScriptTouchHandler(onTouch, false, -127, false)
		performWithDelay(m_touchLayer, function ( ... )
			m_touchLayer:setTouchEnabled(true)
		end, 0.25)
		m_touchLayer:setPosition(ccp(0,0))
		m_UIMain:addNode(m_touchLayer)
	end

	local tfdNow = m_fnGetWidget(m_UIMain, "tfd_formation")
	local tfdBench = m_fnGetWidget(m_UIMain, "tfd_bench")

	-- 伙伴形象，1-6为阵容上的，7-9为替补
	for pos, hid in pairs(m_tbFormationInfo) do
		logger:debug(pos)
		upUIByInfo(pos, hid)
	end

	return m_UIMain
end

