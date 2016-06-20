-- FileName: MainSkyPieaView.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛主要场景显示器
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("MainSkyPieaView", package.seeall)

-- UI控件引用变量 --
local json = "ui/air_island_main.json"

local popLayer
local m_roleLuffy
local m_layFloorCopy1
local m_layFloorCopy2
local m_tbImgRole
local m_tbImgOppo


-- 模块局部变量 --
local m_mainWidget
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbEvent
local m_tbAffixItem			= {}

local m_nStartFloor
local m_nStandTime

local m_isPass


local function init(...)
	m_tbAffixItem			= nil
	m_tbAffixItem			= {}

	popLayer 				= nil

	m_tbImgRole = {}
	m_tbImgOppo = {}

	m_isPass = m_isPass or false
end


function destroy(...)
	package.loaded["MainSkyPieaView"] = nil
end


function moduleName()
	return "MainSkyPieaView"
end


function onTargetBTNTouch( sender, eventType)

	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("路飞，跑向敌人吧")
		sender:setScale(0.5)
	end

end


function afterPass( ... )
	local curBase = SkyPieaModel.getCurFloor()
	m_tbImgOppo[curBase - m_nStartFloor]:setEnabled(false)

	addUnTouchLayer()

	m_roleLuffy:getAnimation():play("jump", -1, -1, -1)
	AudioHelper.playSpecialEffect("texiao_shenmikongdao_lufeijump01.mp3")
end

--播放箱子，buff，敌人，黄金钟的特效 modife zhangjunwu
local function playTargetAni(tbfloorData,aniParent)

	aniParent:removeAllNodes()

	local aniPath = "images/effect/skypiea"

	if(tonumber(tbfloorData.type) == SkyPieaModel.EVENTTYPE.BATTLE_LAYER)then
		local monstType = tonumber(tbfloorData.monsterModel)   --根据次字段来判断使用那个特效

		local attAni = UIHelper.createArmatureNode({
			filePath =  aniPath .. "/sky_monster" .. monstType .. ".ExportJson",
			loop = -1
		})
		attAni:getAnimation():playWithIndex(0, -1, -1, -1)
		attAni:setAnchorPoint(ccp(0.5, 0))
		aniParent:addNode(attAni)
	elseif(tonumber(tbfloorData.type) == SkyPieaModel.EVENTTYPE.BOX_LAYER) then
		logger:debug(".BOX_LAYER")
		local boxAni = UIHelper.createArmatureNode({
			filePath =  aniPath .. "/sky_box.ExportJson",
			loop = -1
		})
		boxAni:setScaleX(-1)
		boxAni:getAnimation():playWithIndex(0, -1, -1, -1)


		local m_arAni2 = UIHelper.createArmatureNode({
			filePath = "images/effect/copy_box_1".."/".."copy_box_1"..".ExportJson",
			animationName = "copy_box",
			loop = -1,
		})

		boxAni:setAnchorPoint(ccp(0.5, 0.2))
		m_arAni2:setAnchorPoint(ccp(0.5, 0.2))
		aniParent:addNode(boxAni)
		aniParent:addNode(m_arAni2)

	elseif(tonumber(tbfloorData.type) == SkyPieaModel.EVENTTYPE.BUFF_LAYER) then
		logger:debug(".BUFF_LAYER")
		local buffAni = UIHelper.createArmatureNode({
			filePath =  aniPath .. "/sky_buff.ExportJson",
			loop = -1
		})
		buffAni:getAnimation():playWithIndex(0, -1, -1, -1)
		buffAni:setAnchorPoint(ccp(0.5, 0.3))
		aniParent:addNode(buffAni)

	elseif(tonumber(tbfloorData.type) == SkyPieaModel.EVENTTYPE.LAST_LAYER) then
		logger:debug(".LAST_LAYER")
		local clockAni = UIHelper.createArmatureNode({
			filePath =  aniPath .. "/bell.ExportJson",
			loop = -1
		})
		clockAni:getAnimation():playWithIndex(0, -1, -1, -1)
		clockAni:setAnchorPoint(ccp(0.5, 0.1))
		aniParent:addNode(clockAni)
	end

end

local function moveFloor( ... )
	local curBase = SkyPieaModel.getCurFloor()
	local offsetY = 1136 * g_fScaleX / 3

	local move = CCMoveBy:create(0.5, ccp(0, -offsetY))
	local callfunc = CCCallFunc:create(function ( ... )
		if (tonumber(curBase) >= m_nStartFloor + 3) then
			m_nStartFloor = curBase + 0
			m_layFloorCopy1:setPosition(ccp(0, 1136 * g_fScaleX))
			m_tbImgRole[1], m_tbImgRole[2], m_tbImgRole[3] = m_tbImgRole[4], m_tbImgRole[5], m_tbImgRole[6]
			m_tbImgOppo[1], m_tbImgOppo[2], m_tbImgOppo[3] = m_tbImgOppo[4], m_tbImgOppo[5], m_tbImgOppo[6]
			m_layFloorCopy1, m_layFloorCopy2 = m_layFloorCopy2, m_layFloorCopy1
			m_layFloorCopy1:setZOrder(0)
			m_layFloorCopy2:setZOrder(-1)
			m_roleLuffy:setZOrder(1)
			for i=1,3 do
				local layFloor = m_fnGetWidget(m_layFloorCopy2, "lay_floor_" .. i)

				local imgRole = m_fnGetWidget(layFloor, "img_role")
				local imgOpponent = m_fnGetWidget(layFloor, "img_opponent")
				local tfdSkyPieaNum = m_fnGetWidget(layFloor, "TFD_SKY_PIEA_NUM")
				local imgSkyLayer = m_fnGetWidget(layFloor, "img_sky_layer")

				m_tbImgRole[i + 3] = imgRole
				m_tbImgOppo[i + 3] = imgOpponent

				imgRole:setEnabled(false)
				imgOpponent:setEnabled(true)
				if (m_nStartFloor + i + 2 <= table.count(DB_Sky_piea_floor.Sky_piea_floor)) then
					local tbFloorInfo = DB_Sky_piea_floor.getDataById(m_nStartFloor + i + 2)
					local nTypeFloor = tonumber(tbFloorInfo.type)
					playTargetAni(tbFloorInfo,imgOpponent)

					-- if (tbFloorInfo.monsterModel) then
					-- 	imgOpponent:loadTexture("images/skypiea/" .. tbFloorInfo.monsterModel .. ".png")
					-- 	local  boxAni = playGoldBoxAni()
					-- 	imgOpponent:addNode(boxAni)
					-- else
					-- 	imgOpponent:loadTexture("images/skypiea/" .. "equip_2" .. ".png")
					-- 	local  clockAni = playClockAni()
					-- 	imgOpponent:addNode(clockAni)
					-- end
					tfdSkyPieaNum:setText(m_nStartFloor + i + 2)
					if (tonumber(tbFloorInfo.type) == SkyPieaModel.EVENTTYPE.LAST_LAYER) then
						tfdSkyPieaNum:setText(gi18n[5460])
						imgSkyLayer:setEnabled(false)
					end
				else
					layFloor:setEnabled(false)

				end
			end
		end
	end)

	local sequence = CCSequence:createWithTwoActions(move, callfunc)
	m_layFloorCopy1:runAction(CCMoveBy:create(0.5, ccp(0, -offsetY)))
	m_roleLuffy:runAction(CCMoveBy:create(0.5, ccp(0, -offsetY)))
	m_layFloorCopy2:runAction(sequence)
end


function luffyWin( ... )
	m_isPass = true
	m_roleLuffy:getAnimation():play("win", -1, -1, -1)
	local curBase = SkyPieaModel.getCurFloor()
	local pos = m_tbImgOppo[curBase - m_nStartFloor + 1]:getWorldPosition()
	m_roleLuffy:setPosition(ccp(pos.x, pos.y + 30))
	local layout = m_fnGetWidget(m_mainWidget, "lay_floor")
	layout:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			ShowNotice.showShellInfo(gi18n[5459])
		end
	end)
end


function runToTarget(callBack)
	addUnTouchLayer()

	m_roleLuffy:getAnimation():play("run", -1, -1, -1)

	local curBase = SkyPieaModel.getCurFloor()
	local pos = m_tbImgOppo[curBase - m_nStartFloor + 1]:getWorldPosition()
	local actionArray = CCArray:create()
	actionArray:addObject(CCMoveTo:create(1.5, ccp(pos.x, pos.y + 30)))
	actionArray:addObject(CCCallFunc:create(function ( ... )
		m_roleLuffy:getAnimation():play("stand", -1, -1, -1)
	end))
	m_roleLuffy:runAction(CCSequence:create(actionArray))
	local nMeetType = SkyPieaModel.getFloorType()
	if (nMeetType ~= SkyPieaModel.EVENTTYPE.LAST_LAYER) then
		performWithDelay(m_mainWidget, callBack, 1.1)
	else
		performWithDelay(m_mainWidget, callBack, 1.6)
	end
end


function backLufei( ... )
	local curBase = SkyPieaModel.getCurFloor()
	local pos = m_tbImgRole[curBase - m_nStartFloor + 1]:getWorldPosition()
	m_roleLuffy:setPosition(pos)
end


function setFloorUI()
	local layout = m_fnGetWidget(m_mainWidget, "lay_floor")
	layout:addTouchEventListener(m_tbEvent.onStartClimb)

	m_layFloorCopy1 = m_fnGetWidget(m_mainWidget, "lay_floor_copy")
	m_layFloorCopy2 = m_layFloorCopy1:clone()
	m_layFloorCopy1:setPositionType(POSITION_ABSOLUTE)
	m_layFloorCopy2:setPositionType(POSITION_ABSOLUTE)
	m_layFloorCopy2:setPosition(ccp(0, 1136 * g_fScaleX))
	m_layFloorCopy2:setZOrder(-1)
	layout:addChild(m_layFloorCopy2)

	m_layFloorCopy1:setScale(g_fScaleX)
	m_layFloorCopy2:setScale(g_fScaleX)

	-- 流云效果
	local imgCloud1 = m_fnGetWidget(m_layFloorCopy1, "img_cloud_1")
	local imgCloud2 = m_fnGetWidget(m_layFloorCopy1, "img_cloud_2")
	local imgCloud3 = m_fnGetWidget(m_layFloorCopy1, "img_cloud_3")
	local imgCloud4 = m_fnGetWidget(m_layFloorCopy2, "img_cloud_1")
	local imgCloud5 = m_fnGetWidget(m_layFloorCopy2, "img_cloud_2")
	local imgCloud6 = m_fnGetWidget(m_layFloorCopy2, "img_cloud_3")

	local function cloudMove( img )
		img:setZOrder(9)
		if (img:getPositionX() > 640 + 200) then
			img:setPositionX(- 200)
		else
			img:setPositionX(img:getPositionX() + 640 / 40 / 30)
		end
	end

	schedule(m_mainWidget, function ( ... )
		cloudMove(imgCloud1)
		cloudMove(imgCloud2)
		cloudMove(imgCloud3)
		cloudMove(imgCloud4)
		cloudMove(imgCloud5)
		cloudMove(imgCloud6)
	end, 0.0000000001)

	m_nStartFloor = tonumber(SkyPieaModel.getCurFloor())
	m_nStandTime = 0

	for i=1,6 do
		local layFloor
		if (i <= 3) then
			layFloor = m_fnGetWidget(m_layFloorCopy1, "lay_floor_" .. i)
		else
			layFloor = m_fnGetWidget(m_layFloorCopy2, "lay_floor_" .. i - 3)
		end
		layFloor:setTouchEnabled(false)

		local imgRole = m_fnGetWidget(layFloor, "img_role")
		local imgOpponent = m_fnGetWidget(layFloor, "img_opponent")
		local tfdSkyPieaNum = m_fnGetWidget(layFloor, "TFD_SKY_PIEA_NUM")
		local imgSkyLayer = m_fnGetWidget(layFloor, "img_sky_layer")

		m_tbImgRole[i] = imgRole
		m_tbImgOppo[i] = imgOpponent

		imgRole:setEnabled(false)
		if (m_nStartFloor + i - 1 <= table.count(DB_Sky_piea_floor.Sky_piea_floor)) then
			local tbFloorInfo = DB_Sky_piea_floor.getDataById(m_nStartFloor + i - 1)
			local nTypeFloor = tonumber(tbFloorInfo.type)
			playTargetAni(tbFloorInfo,imgOpponent)
			-- if (tbFloorInfo.monsterModel) then
			-- 	imgOpponent:loadTexture("images/skypiea/" .. tbFloorInfo.monsterModel .. ".png")
			-- 	local  boxAni = playGoldBoxAni()
			-- 	imgOpponent:addNode(boxAni)
			-- else
			-- 	imgOpponent:loadTexture("images/skypiea/" .. "equip_2" .. ".png")
			-- 	local  clockAni = playClockAni()
			-- 	imgOpponent:addNode(clockAni)
			-- end
			tfdSkyPieaNum:setText(m_nStartFloor + i - 1)
			UIHelper.labelNewStroke(tfdSkyPieaNum)
			if (tonumber(tbFloorInfo.type) == SkyPieaModel.EVENTTYPE.LAST_LAYER) then
				tfdSkyPieaNum:setText(gi18n[5460])
				imgSkyLayer:setEnabled(false)
			end
		else
			layFloor:setEnabled(false)
		end
	end

	local nLoopStand

	m_roleLuffy = UIHelper.createArmatureNode({
		filePath = "images/effect/skypiea/lufei.ExportJson",
		animationName = "stand",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
				if (frameEventName == "jump") then
					sender:getAnimation():play("stand", -1, -1, -1)
					local x, y = sender:getPosition()
					sender:setPosition(ccp(x + 118, y + 241))
					removeUnTouchLayer()
				end
				if (frameEventName ~= "stand") then
					m_nStandTime = 0
				end
			elseif (MovementEventType == 0) then
				if (frameEventName == "jump") then
					moveFloor()
				end
				if (frameEventName == "run") then
					math.randomseed(os.clock())
					local i = math.random(1, 3)
					logger:debug(i)
					AudioHelper.playSpecialEffect("texiao_shenmikongdao_lufeirun0" .. i .. ".mp3")
				end
			elseif (MovementEventType == 2) then
				if (frameEventName == "stand") then
					m_nStandTime = m_nStandTime + 1
					if (m_nStandTime > 5) then
						sender:getAnimation():play("sleep", -1, -1, -1)
					end
				else
					m_nStandTime = 0
					if (frameEventName == "run") then
						math.randomseed(os.clock())
						local i = math.random(1, 3)
						logger:debug(i)
						AudioHelper.playSpecialEffect("texiao_shenmikongdao_lufeirun0" .. i .. ".mp3")
					end
				end
			end
		end
	})

	m_roleLuffy:setAnchorPoint(ccp(0.5, 0.5))
	local pos = m_tbImgRole[1]:getWorldPosition()
	m_roleLuffy:setPosition(ccp(pos.x, pos.y))
	-- m_roleLuffy:getAnimation():setSpeedScale(0.1)
	layout:addNode(m_roleLuffy)
	logger:debug({m_isPass = m_isPass})
	if (m_isPass) then
		luffyWin()
	end
end


function upPointAndStarNum( )
	local tfdStarNum = m_fnGetWidget(m_mainWidget, "TFD_STAR_NUM")
	local i18ntfd_history = m_fnGetWidget(m_mainWidget, "tfd_history") --历史最高：
	local tfd_history_num = m_fnGetWidget(m_mainWidget, "tfd_history_num")
	local i18ntfd_now = m_fnGetWidget(m_mainWidget, "tfd_now") -- 本次积分：
	local tfd_now_num = m_fnGetWidget(m_mainWidget, "tfd_now_num")
	tfdStarNum:setText("X" .. SkyPieaModel.getStarNum())
	UIHelper.labelNewStroke(tfdStarNum)
	i18ntfd_history:setText(gi18n[5528])
	tfd_history_num:setText(SkyPieaModel.getHistoryPoint())
	i18ntfd_now:setText(gi18n[5529])
	tfd_now_num:setText(SkyPieaModel.getPoint())
end


--[[
	@desc: 加载初始化UI
—]]
function loadUI(  )
	-- 获取控件
	upPointAndStarNum()

	local btnBack = m_fnGetWidget(m_mainWidget, "BTN_BACK")
	local btnHelp = m_fnGetWidget(m_mainWidget, "BTN_HELP")
	local btnShop = m_fnGetWidget(m_mainWidget, "BTN_SHOP")
	local btnRank = m_fnGetWidget(m_mainWidget, "BTN_RANK")
	local btnConch = m_fnGetWidget(m_mainWidget, "BTN_CONCH")

	-- 按钮添加阴影
	UIHelper.titleShadow(btnBack, gi18n[1019])

	-- 注册按钮事件
	btnBack:addTouchEventListener(m_tbEvent.onBack)
	btnHelp:addTouchEventListener(m_tbEvent.onHelp)
	btnShop:addTouchEventListener(m_tbEvent.onShop)
	btnRank:addTouchEventListener(m_tbEvent.onRank)
	btnConch:addTouchEventListener(m_tbEvent.onConch)

	-- 闪电动画
	local imgBG = m_fnGetWidget(m_mainWidget, "img_bg")
	imgBG:setScale(g_fScaleX)
	local armature = UIHelper.createArmatureNode({
		filePath = "images/effect/skypiea/sky_piea.ExportJson",
		animationName = "sky_piea",
	})
	imgBG:addNode(armature)
end


--[[
	@desc: 创建显示的主界面UI
    @param 	tbEvent  type: table
    @return: m_mainWidget  type: userdata layout
—]]
function create(tbEvent)

	init()

	m_tbEvent = tbEvent
	m_mainWidget = g_fnLoadUI(json)
	loadUI()

	setFloorUI()
	--设置buff信息
	setBuffUI()

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideSkyPieaView"
	if (GuideModel.getGuideClass() == ksGuideSkypiea and GuideSkyPieaView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createSkyPieaGuide(3,0, function ( ... )
			GuideCtrl.createSkyPieaGuide(4)
		end)
	end


	UIHelper.registExitAndEnterCall(m_mainWidget, onExitCall, onEnterCall)
	UIHelper.registExitAndEnterCall(m_mainWidget, function ( ... )
		SkyPieaModel.cleanSkyFloorData()
	end)

	return m_mainWidget
end


local function removeAffixItem()
	for i,v in ipairs(m_tbAffixItem) do
		v:removeFromParentAndCleanup(true)
	end

	m_tbAffixItem			= nil
	m_tbAffixItem			= {}
end



--设置此次爬塔的buff加成信息界面
function setBuffUI()
	local buffAddedInfo = SkyPieaModel.getBuffInfoBought()
	logger:debug(buffAddedInfo)

	--用来存放buff属性的icon图片，来判断俩属性是否需要砍掉一个
	local tbAttrImage = {}

	local function isImageExist( _iconImg )
		for i,v in ipairs(tbAttrImage) do
			if(v == _iconImg) then
				return true
			end
		end
		return false
	end

	for i=1,4 do

		local img_buff_bg 		= m_fnGetWidget(m_mainWidget,"img_buff_bg_" .. i)
		local IMG_OWN_ICON 			= m_fnGetWidget(img_buff_bg,"IMG_OWN_ICON") 						--buff图片
		local IMG_OWN_DESC 				= m_fnGetWidget(img_buff_bg,"IMG_OWN_DESC") 					--buff的名字
		local TFD_OWN_DESC_NUM 		= m_fnGetWidget(img_buff_bg,"TFD_OWN_DESC_NUM") 					--buff的值

		IMG_OWN_ICON:setEnabled(false)
		IMG_OWN_DESC:setEnabled(false)
		TFD_OWN_DESC_NUM:setEnabled(false)

	end

	local buffCount = 1

	for k,v in pairs(buffAddedInfo) do
		local tb_DBAffixeInfo = SkyPieaUtil.getOwnBuffDataByAffixId(tonumber(k))
		if(isImageExist(tb_DBAffixeInfo.smallIconImg) == true) then
			logger:debug("同类buff已经存在")
		else

			local img_buff_bg 				= m_fnGetWidget(m_mainWidget,"img_buff_bg_" .. buffCount)
			local IMG_OWN_ICON 				= m_fnGetWidget(img_buff_bg,"IMG_OWN_ICON") 						--buff图片
			local IMG_OWN_DESC 				= m_fnGetWidget(img_buff_bg,"IMG_OWN_DESC") 						--buff的名字
			local TFD_OWN_DESC_NUM 			= m_fnGetWidget(img_buff_bg,"TFD_OWN_DESC_NUM") 					--buff的值

			logger:debug(tb_DBAffixeInfo)
			IMG_OWN_ICON:setEnabled(true)
			IMG_OWN_DESC:setEnabled(true)
			TFD_OWN_DESC_NUM:setEnabled(true)

			IMG_OWN_ICON:loadTexture(tb_DBAffixeInfo.smallIconImg)
			IMG_OWN_DESC:loadTexture(tb_DBAffixeInfo.smallNameImg)
			TFD_OWN_DESC_NUM:setText("+" .. v/SkyPieaModel.BUFF_RATIO .. "%")
			buffCount = buffCount + 1
			table.insert(tbAttrImage,tb_DBAffixeInfo.smallIconImg)
		end
	end
end


function addUnTouchLayer(  )
	--增加屏蔽，
	if(popLayer == nil) then
		popLayer = OneTouchGroup:create()
		popLayer:setTouchPriority(g_tbTouchPriority.explore)
		CCDirector:sharedDirector():getRunningScene():addChild(popLayer)
	end
end

function removeUnTouchLayer(  )
	--删除屏蔽层
	logger:debug("enter remove key Explore==========")
	if (popLayer) then
		popLayer:removeFromParentAndCleanup(true)
		popLayer=nil
	end
end
