-- FileName: MainGrabTreasureView.lua
-- Author: menghao
-- Date: 2014-5-9
-- Purpose: 夺宝主界面view


module("MainGrabTreasureView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_layEasyInfo
local m_imgSmallBG
local m_imgUpLine
local m_imgBottomLine

local m_btnWind 			-- 按钮风
local m_btnThunder 			-- 按钮雷
local m_btnWater 			-- 按钮水
local m_btnFire 			-- 按钮火
local m_btnBack 			-- 按钮返回

local m_lsvTreasureList

local m_tfdAvoidTime 		-- 文本免战时间
local m_btnGrab 			-- 抢夺按钮
local m_btnSynthetic 		-- 合成按钮
local m_btnAvoidWar			-- 按钮免战

local m_pgvTreasure
local m_defaultPage
local m_layEffect
local m_btnTreasureModel 	-- 宝物模型
local m_tfdTreasureName 	-- 宝物名称
local m_tfdFragmentNum 		-- 碎片数量

local i18nAvoidTxt


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbInfo
local m_curItem

local GUIDE_TREA_ID = 5015016


function fuseAnimation( index, numNeed , callback)
	local page = m_pgvTreasure:getPage(index - 1)
	local btnModel = m_fnGetWidget(page, "BTN_TREASURE_MODEL")
	local layEffect3 = m_fnGetWidget(page, "lay_effect_3")
	local layFragment = m_fnGetWidget(page, "LAY_FRAGMENT_NUM" .. numNeed)

	local armature2 = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao2.ExportJson",
		animationName = "duobao2_1",
		loop = 0,

		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if frameEventName == "1" then
				callback()
			end
		end
	})
	AudioHelper.playSpecialEffect("texiao_duobao01.mp3")
	-- armature2:setAnchorPoint(ccp(0.5, 0.28))
	armature2:setPosition(ccp(0, btnModel:getSize().height / 2))
	layEffect3:addNode(armature2, 10, 10)

	for i=1,numNeed do
		local layFrag = m_fnGetWidget(page, "lay_fragment" .. numNeed .. i)
		local btnFrag = m_fnGetWidget(page, "BTN_ICON" .. numNeed .. i)

		local armature4 = UIHelper.createArmatureNode({
			filePath = "images/effect/grabTreasure/duobao4.ExportJson",
			loop = 0,
			animationName = "duobao4",
		})
		btnFrag:addNode(armature4, 9, 9)
	end
end


function updateAvoidTime( avoidTime )
	if tonumber(avoidTime) >= 1 then
		i18nAvoidTxt:setEnabled(true)
		m_tfdAvoidTime:setEnabled(true)
		UIHelper.labelEffect(m_tfdAvoidTime, TimeUtil.getTimeString(avoidTime))
	else
		i18nAvoidTxt:setEnabled(false)
		m_tfdAvoidTime:setEnabled(false)
	end
end


function grabOrSynthetic( flag )
	if (flag == 1) then
		m_btnSynthetic:setEnabled(true)
		m_btnGrab:setEnabled(false)
	else
		m_btnSynthetic:setEnabled(false)
		m_btnGrab:setEnabled(true)
	end
end


function getTreaIDs( ... )
	return m_tbInfo.treasureIds
end


local function refreshPageView( isShowGuideUI )
	local tbTreasureIds = m_tbInfo.treasureIds
	if (#tbTreasureIds == 0) then
		m_pgvTreasure:setEnabled(false)
	else
		m_pgvTreasure:setEnabled(true)
	end
	for i=1,#tbTreasureIds do
		local tbTreasureInfo = DB_Item_treasure.getDataById(tbTreasureIds[i])
		local imgFilePath = "images/base/treas/big/" .. tbTreasureInfo.icon_big
		local fragments = TreasureData.getTreasureFragments(tbTreasureIds[i])
		local numNeedSum = 0
		local numHaveSum = 0

		for k,v in pairs(fragments) do
			local itemArr = string.split(v, "|")
			local fragmentID = itemArr[1]
			local numNeed = tonumber(itemArr[2])
			numNeedSum = numNeedSum + numNeed
			local numHave = TreasureData.getFragmentNum(fragmentID)

			-- 如果在引导状态而且碎片是GUIDE_TREA_ID 			20150520已经不需要了
			-- if (isShowGuideUI and tonumber(fragmentID) == GUIDE_TREA_ID) then
			-- 	numHave = 2
			-- end

			if (numHave < numNeed) then
				numHaveSum = numHaveSum + numHave
			else
				numHaveSum = numHaveSum + numHave
			end
		end

		local page = tolua.cast(m_defaultPage:clone(), "Layout")
		m_pgvTreasure:removePageAtIndex(i - 1)
		local btnTreasureModel = m_fnGetWidget(page, "BTN_TREASURE_MODEL")
		local tfdTreasureName = m_fnGetWidget(page, "TFD_TREASURE_NAME")
		local tfdFragmentNumTxt = m_fnGetWidget(page, "tfd_fragment_num_txt")
		local tfdFragmentNum = m_fnGetWidget(page, "TFD_FRAGMENT_NUM")

		btnTreasureModel:loadTextureNormal(imgFilePath)
		btnTreasureModel:loadTexturePressed(imgFilePath)
		btnTreasureModel:addTouchEventListener(m_tbInfo.onTreasureModel)

		local acitonArray = CCArray:create()
		acitonArray:addObject(CCMoveBy:create(2, ccp(0, 10)))
		acitonArray:addObject(CCMoveBy:create(2, ccp(0, -10)))
		btnTreasureModel:runAction(CCRepeatForever:create(CCSequence:create(acitonArray)))

		local layModel = m_fnGetWidget(page, "lay_treasure_model")

		UIHelper.labelNewStroke(tfdTreasureName,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelEffect(tfdTreasureName, tbTreasureInfo.name)
		tfdTreasureName:setColor(g_QulityColor2[tbTreasureInfo.quality])

		UIHelper.labelEffect(tfdFragmentNumTxt, m_i18n[2420])
		UIHelper.labelEffect(tfdFragmentNum, numHaveSum .. "/" .. numNeedSum)
		UIHelper.labelNewStroke(tfdFragmentNumTxt,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(tfdFragmentNum,ccc3(0x28,0x00,0x00), 2)

		local layFrag3 = m_fnGetWidget(page, "LAY_FRAGMENT_NUM3")
		local layFrag6 = m_fnGetWidget(page, "LAY_FRAGMENT_NUM6")
		layFrag3:setEnabled(false)
		layFrag6:setEnabled(false)

		local m_layFragment = m_fnGetWidget(page, "LAY_FRAGMENT_NUM" .. numNeedSum)
		m_layFragment:setEnabled(true)
		local kk = 1
		for k,v in pairs(fragments) do
			local itemArr = string.split(v, "|")
			local fragmentID = itemArr[1]
			local numNeed = tonumber(itemArr[2])
			local numHave = TreasureData.getFragmentNum(fragmentID)

			-- 如果在引导状态而且碎片是GUIDE_TREA_ID
			-- if (isShowGuideUI and tonumber(fragmentID) == GUIDE_TREA_ID) then
			-- 	numHave = 2
			-- end

			local iData = ItemUtil.getItemById(fragmentID)
			iData.numHas = numHaveSum
			iData.numNeed = numNeedSum
			for j=kk,numNeed+kk-1 do
				local ii = numNeed + kk - j
				local btnIconF = m_fnGetWidget(m_layFragment, "BTN_ICON" .. numNeedSum .. ii)
				local imgIconF = m_fnGetWidget(m_layFragment, "IMG_ICON_BG" .. numNeedSum .. ii)
				btnIconF:loadTextureNormal(iData.imgFullPath)
				btnIconF:loadTexturePressed(iData.imgFullPath)

				btnIconF:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playInfoEffect()
						LayerManager.addLayout(FragmentInfoCtrl.create(iData))
					end
				end)
				imgIconF:loadTexture("images/others/treasure_fragment_" .. iData.quality .. ".png")
				if (numNeed == 1 and numHave== 0) or (j <= numNeed - numHave) then
					btnIconF:setGray(true)
					imgIconF:loadTexture("images/others/treasure_fragment_ash.png")
					imgIconF:setZOrder(10)
				else
					local armatureFrag = UIHelper.createArmatureNode({
						filePath = "images/effect/grabTreasure/duobao1_2.ExportJson",
						animationName = "duobao1_2",
					})
					btnIconF:addNode(armatureFrag)
				end
			end
			kk = kk + numNeed
		end

		m_pgvTreasure:insertPage(page, i - 1)
	end
	local k = #tbTreasureIds
	while (m_pgvTreasure:getPage(k) and k~= 0) do
		m_pgvTreasure:removePageAtIndex(k)
	end
end


function changeHighlight( nIndex )
	if m_curItem then
		m_curItem:removeChildByTag(10, true)
	end
	local imgHighlight = ImageView:create()
	imgHighlight:loadTexture("images/base/potential/equip_h.png")
	local item = m_lsvTreasureList:getItem(nIndex - 1)
	if (not item) then
		return
	end
	local flag = (m_curItem == item:getChildByTag(123))
	m_curItem = item:getChildByTag(123)
	m_curItem:addChild(imgHighlight, 1, 10)


	local lsvWidth = m_lsvTreasureList:getViewSize().width  				--listview的size宽度
	local lsvInnerWidth = m_lsvTreasureList:getInnerContainerSize().width   --innerSize的size宽度

	local curOffset = m_lsvTreasureList:getHContentOffset() 				--横向左边未显示的宽度
	local oneItemWidth = item:getSize().width + m_lsvTreasureList:getItemsMargin() --每个item的宽度

	local offSetLeft = (nIndex - 1) * oneItemWidth      	--需要高亮的item在最左边的时候的偏移
	local offSetRight = (nIndex * oneItemWidth - lsvWidth)  --需要高亮的item在最有边的时候的偏移

	local numL = math.ceil(-curOffset / oneItemWidth) + 1   --当前完整显示的最左边的index
	local numR = math.floor((-curOffset + lsvWidth + m_lsvTreasureList:getItemsMargin()) / oneItemWidth)

	if (lsvInnerWidth > lsvWidth) then
		if (nIndex < numL) then
			m_lsvTreasureList:setContentOffset(ccp(-offSetLeft, 0), false)
		end
		if (nIndex > numR) then
			m_lsvTreasureList:setContentOffset(ccp(-offSetRight, 0), false)
		end
	end

	if not flag then
	-- m_pgvTreasure:scrollToPage(nIndex - 1)
	end
end


-- 切换宝物类型时更新UI
function updateUIByIDs( tbTreasureIds, nType, isShowGuideUI )
	m_curItem = nil
	-- local btns = {m_btnWind, m_btnThunder, m_btnWater, m_btnFire}
	-- for i=1,4 do
	-- 	btns[i]:setFocused(i == nType)
	-- end
	m_tbInfo.treasureIds = tbTreasureIds
	if (table.isEmpty(tbTreasureIds)) then
		grabOrSynthetic(2)
		m_btnGrab:addTouchEventListener(
			function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(m_i18n[2462])
				end
			end
		)
	end
	---[[
	table.sort( m_tbInfo.treasureIds, function ( ID1, ID2 )
		local quality1 = DB_Item_treasure.getDataById(ID1).quality
		local quality2 = DB_Item_treasure.getDataById(ID2).quality
		-- if isShowGuideUI then
		-- 	if ID1 == GUIDE_TREA_ID then
		-- 		return true
		-- 	end
		-- 	if ID2 == GUIDE_TREA_ID then
		-- 		return false
		-- 	end
		-- end
		return (quality1 == quality2) and (ID1 < ID2) or (quality1 > quality2)
	end )
	--]]
	tbTreasureIds = m_tbInfo.treasureIds
	m_lsvTreasureList:removeAllItems()
	for i=1,#tbTreasureIds do
		m_lsvTreasureList:pushBackDefaultItem()
	end
	for i=1,#tbTreasureIds do
		local item = m_lsvTreasureList:getItem(i - 1)
		local btnIcon = m_fnGetWidget(item, "BTN_TREASURE_BG")
		local spriteTreasureIcon = ItemUtil.createBtnByTemplateId(tbTreasureIds[i])
		local posX = btnIcon:getPositionX()
		local posY = btnIcon:getPositionY()
		item:removeAllChildrenWithCleanup(true)
		spriteTreasureIcon:setPosition(ccp(posX, posY))
		spriteTreasureIcon:setTouchEnabled(true)
		local function onTouch( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				m_pgvTreasure:scrollToPage(i - 1)
			end
		end
		spriteTreasureIcon:addTouchEventListener(onTouch)
		item:addChild(spriteTreasureIcon, 1, 123)
	end

	refreshPageView(isShowGuideUI)
end


function adjustPGV( index )
	index = index or 0
	m_pgvTreasure:scrollToPage(index)
end


-- 初始化UI
local function initUI( ... )
	-- about enemy
	local btnEnemy = m_fnGetWidget(m_UIMain, "BTN_ENEMY")
	local imgTips = m_fnGetWidget(m_UIMain, "img_tips")
	local labnRedNum = m_fnGetWidget(m_UIMain, "LABN_RED_NUM")
	UIHelper.titleShadow(btnEnemy, "仇人") -- TODO mh
	btnEnemy:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/grabTreasure/GrabEnemyListCtrl"
			GrabEnemyListCtrl.create()
		end
	end)
	local nEnemyNum = TreasureData.getEnemyNum()
	if (nEnemyNum > 0) then
		labnRedNum:setStringValue(nEnemyNum)
	else
		imgTips:setEnabled(false)
	end

	-- 获取各控件
	-- m_btnWind = m_fnGetWidget(m_UIMain, "BTN_WIND")
	-- m_btnThunder = m_fnGetWidget(m_UIMain, "BTN_THUNDER")
	-- m_btnWater = m_fnGetWidget(m_UIMain, "BTN_WATER")
	-- m_btnFire = m_fnGetWidget(m_UIMain, "BTN_FIRE")
	m_btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")

	m_lsvTreasureList = m_fnGetWidget(m_UIMain, "LSV_TREASURE_LIST")

	m_tfdAvoidTime = m_fnGetWidget(m_UIMain, "TFD_AVOID_TIME")
	m_btnAvoidWar = m_fnGetWidget(m_UIMain, "BTN_AVOID_WAR")
	m_btnGrab = m_fnGetWidget(m_UIMain, "BTN_GRAB")
	m_btnSynthetic = m_fnGetWidget(m_UIMain, "BTN_SYNTHETIC")

	m_btnTreasureModel = m_fnGetWidget(m_UIMain, "BTN_TREASURE_MODEL")
	m_tfdTreasureName = m_fnGetWidget(m_UIMain, "TFD_TREASURE_NAME")
	m_tfdFragmentNumTxt = m_fnGetWidget(m_UIMain, "tfd_fragment_num_txt")
	m_tfdFragmentNum = m_fnGetWidget(m_UIMain, "TFD_FRAGMENT_NUM")

	m_layEffect = m_fnGetWidget(m_UIMain, "lay_effect")

	m_layEasyInfo = m_fnGetWidget(m_UIMain, "lay_easy_information")
	-- m_imgSmallBG = m_fnGetWidget(m_UIMain, "img_small_bg")
	m_imgUpLine = m_fnGetWidget(m_UIMain, "img_up_line")
	m_imgBottomLine = m_fnGetWidget(m_UIMain, "img_bottom_line")

	m_layEasyInfo:setSize(CCSizeMake(m_layEasyInfo:getSize().width * g_fScaleX, m_layEasyInfo:getSize().height * g_fScaleX))
	-- m_imgSmallBG:setScale(g_fScaleX)
	m_imgUpLine:setScale(g_fScaleX)
	m_imgBottomLine:setScale(g_fScaleX)

	-- 控件事件
	-- m_btnWind:addTouchEventListener(m_tbInfo.onWind)
	-- m_btnThunder:addTouchEventListener(m_tbInfo.onThunder)
	-- m_btnWater:addTouchEventListener(m_tbInfo.onWater)
	-- m_btnFire:addTouchEventListener(m_tbInfo.onFire)
	m_btnBack:addTouchEventListener(m_tbInfo.onBack)

	-- UIHelper.titleShadow(m_btnWind, m_i18n[2415])
	-- UIHelper.titleShadow(m_btnThunder, m_i18n[2416])
	-- UIHelper.titleShadow(m_btnWater, m_i18n[2417])
	-- UIHelper.titleShadow(m_btnFire, m_i18n[2418])
	UIHelper.titleShadow(m_btnBack, m_i18n[1019])

	m_btnAvoidWar:addTouchEventListener(m_tbInfo.onAvoidWar)
	m_btnGrab:addTouchEventListener(m_tbInfo.onGrab)
	m_btnSynthetic:addTouchEventListener(m_tbInfo.onSynthetic)
	UIHelper.titleShadow(m_btnGrab, m_i18n[2419])
	UIHelper.titleShadow(m_btnSynthetic, m_i18n[1604])

	m_lsvTreasureList:setBounceEnabled(true)
	m_lsvTreasureList:setTouchEnabled(true)

	m_pgvTreasure = m_fnGetWidget(m_UIMain, "PGV_TREASURE")
	local layPage = m_fnGetWidget(m_pgvTreasure, "lay_treasure")
	m_defaultPage = layPage:clone()
	m_defaultPage:retain()
	layPage:removeFromParent()

	m_pgvTreasure:addEventListenerPageView(m_tbInfo.pageViewEvent)

	-- 宝物相关UI
	local itemTreasure = m_lsvTreasureList:getItem(0)
	m_lsvTreasureList:setItemModel(itemTreasure)

	-- 免战时间
	i18nAvoidTxt = m_fnGetWidget(m_UIMain, "tfd_avoid_txt")
	UIHelper.labelEffect(i18nAvoidTxt, m_i18n[2408])

	-- 座台上的特效
	local imgBG = m_fnGetWidget(m_UIMain, "img_grab_treasure_bg")
	local armatureModel = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao1_1.ExportJson",
		animationName = "duobao1_1",
	})
	armatureModel:setScaleX(g_fScaleX)
	armatureModel:setScaleY(g_fScaleY)
	local tSize = m_layEffect:getSize()
	imgBG:addNode(armatureModel)

	local layEffect1 = m_fnGetWidget(m_UIMain, "lay_effect_1")
	local armatureFor1 = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao1.ExportJson",
		animationName = "duobao1",
	})
	layEffect1:addNode(armatureFor1)

	local layEffect2 = m_fnGetWidget(m_UIMain, "lay_effect_2")
	local armatureFor2 = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao1.ExportJson",
		animationName = "duobao1",
	})
	layEffect2:addNode(armatureFor2)

	-- 合成按钮上的动画
	local armature3 = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao3.ExportJson",
		animationName = "duobao3",
	})
	local armature31 = UIHelper.createArmatureNode({
		filePath = "images/effect/grabTreasure/duobao3_1.ExportJson",
		animationName = "duobao3_1",
	})
	m_btnSynthetic:addNode(armature3)
	m_btnSynthetic:addNode(armature31)
end


-- 初始化
local function init(...)
	m_curItem = nil
	initUI()
end


-- 销毁
function destroy(...)
	package.loaded["MainGrabTreasureView"] = nil
end


-- 模块名
function moduleName()
	return "MainGrabTreasureView"
end


function create( tbInfo )
	m_UIMain = g_fnLoadUI("ui/grab_treasure.json")

	m_tbInfo = tbInfo
	init()
	UIHelper.registExitAndEnterCall(m_UIMain, function ( ... )
		m_defaultPage:release()
	end)
	if (GuideModel.getGuideClass() == ksGuideRobTreasure and GuideRobView.guideStep == 2) then
		local scene = CCDirector:sharedDirector():getRunningScene()
		performWithDelay(scene, function(...)
			require "script/module/guide/GuideModel"
			require "script/module/guide/GuideRobView"
			require "script/module/guide/GuideCtrl"
			local pos = m_btnGrab:convertToWorldSpace(ccp(0,0))
			GuideCtrl.createRobGuide(3,0,pos)
		end, 0.05)
	end


	return m_UIMain
end

