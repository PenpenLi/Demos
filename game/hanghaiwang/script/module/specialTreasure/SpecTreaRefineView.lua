-- FileName: SpecTreaRefineView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("SpecTreaRefineView", package.seeall)

-- UI控件引用变量 --
local _mainLayout
local _layConsumClone
local _layConsumClonePosX
local _layConsumClonePosY

-- 模块局部变量 --
local _powerFragNum     -- 万能材料拥有数量
local _treaPageList
local _curPageNum 
local _powerTid = 720001
local _powerFragTid = 7200011
local _layConsumTag = 1111
local _flyTextTag = 2222


local _stockeColor = ccc3(0x45,0x05,0x05)
local _i18n = gi18n
local _i18nString = gi18nString
local _CallFn = nil
local _layConsumCloneCount = 0
local _treaInfo
local _btnCanTouch = true

local function init(...)

end

function destroy(...)
	package.loaded["SpecTreaRefineView"] = nil
end

function moduleName()
    return "SpecTreaRefineView"
end

function create(treaInfo)
	-- if (_layConsumClone) then
	-- 	_layConsumClone:release()
	-- end
	_btnCanTouch = true
	_layConsumClone = nil
	_treaInfo = treaInfo
	initBg()
	initPageView()
	initTreaModel()
	initTreaInfo()
	initMaterial()
	initFragment()

	-- 注册兑换监听事件
	UIHelper.registExitAndEnterCall(_mainLayout, function (  )
		GlobalNotify.removeObserver("SPECTREA_CHARGEOK", "SPECTREA_CHARGEOK")
		GlobalNotify.removeObserver("SPECTREA_CHARGELAYOUTCLOSE", "SPECTREA_CHARGELAYOUTCLOSE")
        LayerManager.resetPaomadeng()
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		local tipNode = runningScene:getChildByTag(1111)
		if (tipNode) then
			tipNode:stopAllActions()
			tipNode:removeFromParentAndCleanup(true)
		end
        if (_layConsumClone) then
			_layConsumClone:release()
		end
		SpecTreaRefineCtrl.removeOfflineObserver()
		MainFormationTools.removeFlyText()

	end, function (  )
		SpecTreaRefineCtrl.addOfflineObserver()
		GlobalNotify.addObserver("SPECTREA_CHARGEOK", chargeRefreshUI, nil, "SPECTREA_CHARGEOK")
		GlobalNotify.addObserver("SPECTREA_CHARGELAYOUTCLOSE", refrashBag, nil, "SPECTREA_CHARGELAYOUTCLOSE")
	end)

	return _mainLayout
end


function lableStroke( widgt )
	UIHelper.labelNewStroke(widgt,_stockeColor)
end

-- 兑换后刷新UI
function chargeRefreshUI(  )
	-- 宝物数量增加
	local costInfo = _treaInfo.costInfo
	local normalCost = costInfo.normalCost

	normalCost[2].haveNum = normalCost[2].haveNum + 1
	initMaterial()
	-- 万能材料数量减少
	_powerFragNum =  _powerFragNum - 1
	initFragment()
end

function setTreaInfo( treaInfo )
	_treaInfo = treaInfo
end

function setBtnStatus( canTouch )
	local pgvmain = _mainLayout.PGV_MAIN
	pgvmain:setTouchEnabled(canTouch)
	_btnCanTouch = canTouch
end


-- 兑换宝物后 刷新消耗材料 和pageview
function refrashBag(  )
	-- 兑换宝物后 查找添加的宝物信息
	SpecTreaRefineCtrl.onChangAfterQuick()

	initMaterial()
	initFragment()
end


-- 初始化背景图片
function initBg( ... )
	_mainLayout = g_fnLoadUI("ui/special_advance.json")
	local imgBg = _mainLayout.IMG_BG
	imgBg:setScale(g_fScaleX)
	-- 返回按键
	local btnBack = _mainLayout.BTN_CLOSE
	btnBack:addTouchEventListener(function (  sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			local formerModuleName = SpecTreaRefineCtrl.formerModuleName()
			if (formerModuleName ==  "SBListCtrl" ) then
				require "script/module/specialBag/SBListCtrl"
				SBListCtrl:create()
				MainScene.updateBgLightOfMenu()
			elseif (formerModuleName ==  "MainFormation") then
				local numSrcLocation = _treaInfo.page
				local layPartner = MainFormation.create(numSrcLocation - 1)
       			 if (layPartner) then
           			LayerManager.changeModule(layPartner, MainFormation.moduleName(), {1,3}, true)
        		end
			elseif (formerModuleName ==  "MainPartner") then
				local layPartner = MainPartner.create()
        		if (layPartner) then
	         		LayerManager.changeModule(layPartner, MainPartner.moduleName(),{1,3},true)
	         		PlayerPanel.addForPartnerStrength()
	         		require "script/module/main/MainScene"
					MainScene.changeMenuCircle(1)
				end
			end
	 	end
	end)


	local function arrowBlink( arrow )
		local actionArr = CCArray:create()
		local imgRrrow = arrow:getVirtualRenderer()

		actionArr:addObject(CCFadeTo:create( 0.8,255 * 0.35))
		actionArr:addObject(CCFadeTo:create( 0.8,255))

		local sequence = CCSequence:create(actionArr)
		local action = CCRepeatForever:create(sequence)
		imgRrrow:runAction( action)
	end


	local imgArrowLeft = _mainLayout.img_arrow_left
	local imgArrowRight = _mainLayout.img_arrow_right

	arrowBlink(imgArrowLeft)
	arrowBlink(imgArrowRight)
end

-- 初始化pageView
function initPageView( ... )
	local pgvmain = _mainLayout.PGV_MAIN
	local layPage = pgvmain:getPage(0)
	local pageLayClone = layPage:clone()
	_treaPageList = SpecTreaRefineCtrl.getTreaPageViewList()


	pgvmain:removeAllPages()

	local treaIndex,allNum = SpecTreaRefineCtrl.getTreaIndex() 
	for i,v in ipairs(_treaPageList) do
		local layPageItem = pageLayClone:clone()
		local imgSpecial = layPageItem.IMG_SPECIAL
		-- imgSpecial:loadTexture(v)
		EffTreaForge:new():bigTreaEff(imgSpecial)
		EffTreaForge:new():lizi(imgSpecial)

		pgvmain:addWidgetToPage(layPageItem, i, true)
		if (i == treaIndex - 1) then
			imgSpecial:loadTexture(v)
		elseif (i == treaIndex )  then 
			imgSpecial:loadTexture(v)
		elseif (i == treaIndex + 1) then
			imgSpecial:loadTexture(v)
		end
	end
    pgvmain:initToPage(treaIndex - 1)
    _curPageNum = treaIndex - 1
    	-- 翻页功能
	pgvmain:addEventListenerPageView(function ( sender, eventType )
		if (eventType == PAGEVIEW_EVENT_TURNING) then
			local  curPage= pgvmain:getCurPageIndex()
	    	local  pagAllNum = pgvmain:getPages():count()

			if (  curPage > _curPageNum and (curPage ~= pagAllNum - 1)) then
				local layPage = pgvmain:getPage( curPage + 1)
				local imgSpecial = layPage.IMG_SPECIAL
				imgSpecial:loadTexture(_treaPageList[ curPage + 2])
			elseif (  curPage < _curPageNum and curPage ~= 0) then
				local layPage = pgvmain:getPage(curPage - 1)
				local imgSpecial = layPage.IMG_SPECIAL
				imgSpecial:loadTexture(_treaPageList[curPage])
			end
			_curPageNum =  curPage
			local treaInfo = SpecTreaRefineCtrl.initTreaInfo(curPage + 1)
			_treaInfo = treaInfo
			--  重置页面信息
			resetAllMes()
		end
	end)
end

-- 删除 和增加页面 的操作(暂时不用)
function refreshPagview( removedIndex,addTreaInfo )
	if (removedIndex) then
		table.sort( 
					removedIndex, function ( a,b ) return tonumber(a) > tonumber(b)  end 
				  )

		local pgvmain = _mainLayout.PGV_MAIN
	    local beforpagNUm = pgvmain:getPages():count()

		_treaPageList = SpecTreaRefineCtrl.getTreaPageViewList()
		local treaIndex,allNum = SpecTreaRefineCtrl.getTreaIndex() 

		for i,v in ipairs(removedIndex) do
			local PageIndex = v
			pgvmain:removePageAtIndex(tonumber(PageIndex - 1))
		end

		local pagNum = pgvmain:getPages():count()

		-- 当前页面
		if (   treaIndex >= 1 and treaIndex <= pagNum+ 1 ) then
			local layPage = pgvmain:getPage(treaIndex -1 )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex])
		end
		
	    pgvmain:scrollToPage (treaIndex - 1)

		--- 后一界面
		if (  treaIndex <= pagNum  ) then
			local layPage = pgvmain:getPage(treaIndex )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex + 1])
		end
		-- 前一界面
		if (  treaIndex >= 2 ) then
			local layPage = pgvmain:getPage(treaIndex -2 )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex - 1])
		end


	elseif (addTreaInfo and #addTreaInfo > 0) then

		local pgvmain = _mainLayout.PGV_MAIN
	    local beforpagNUm = pgvmain:getPages():count()

		local layPage = pgvmain:getPage(0)
		local pageLayClone = layPage:clone()

		_treaPageList = SpecTreaRefineCtrl.getTreaPageViewList()
		for i,v in ipairs(addTreaInfo) do
			local layPageItem = pageLayClone:clone()
			local imgSpecial = layPageItem.IMG_SPECIAL
			imgSpecial:loadTexture(v.imagePath)
			local addIndex = tonumber(v.index) - 1

			local  newPage = Layout:create()
			newPage:setSize(pgvmain:getSize())
			layPageItem:setPosition(ccp(0,0 ))
            newPage:addChild(layPageItem)
            pgvmain:insertPage(newPage,addIndex)
		end

	    local beforpagNUm = pgvmain:getPages():count()
		local treaIndex,allNum = SpecTreaRefineCtrl.getTreaIndex() 
    	-- pgvmain:initToPage(treaIndex - 1)

		-- 当前页面
		if (   treaIndex >= 1 and treaIndex <= pagNum+ 1 ) then
			local layPage = pgvmain:getPage(treaIndex -1 )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex])
		end

		--- 后一界面
		if (  treaIndex <= pagNum  ) then
			local layPage = pgvmain:getPage(treaIndex )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex + 1])
		end
		-- 前一界面
		if (  treaIndex >= 2 ) then
			local layPage = pgvmain:getPage(treaIndex -2 )
			local imgSpecial = layPage.IMG_SPECIAL
			imgSpecial:loadTexture(_treaPageList[treaIndex - 1])
		end

	    pgvmain:scrollToPage (treaIndex - 1)

	end
end



-- 重置页面信息
function resetAllMes( treaInfo )
	if (treaInfo) then
		_treaInfo = treaInfo
	end
	-- setBtnStatus(true)
	-- 重置模型数据
	initTreaModel()
	-- 重置属性信息
	initTreaInfo()
	-- 重置材料面板
	initMaterial()
	-- 重置碎片信息
	initFragment()
end

--
function setTreaInfo( treaInfo )
	_treaInfo = treaInfo
end


-- 初始化属性区域数据
function initTreaInfo(  )
	local attrBg1 = _mainLayout.img_attr_bg
	initAttr(attrBg1,_treaInfo.refineBeforeAttr)
	local attrBg2 = _mainLayout.img_attr_bg2
	initAttr(attrBg2,_treaInfo.refineAfterAttr)
end

-- 初始化宝物模型 和 翻页功能
function initTreaModel( ... )
	local treaIndex,allNum = SpecTreaRefineCtrl.getTreaIndex() 
	-- 模型图片
	local treaDB = _treaInfo.treaDB
	local pgvmain = _mainLayout.PGV_MAIN

	-- 将要解锁的觉醒
	local imgAdvanceAbility = _mainLayout.IMG_ADVANCE_ABILITY

	-- 将要解锁的觉醒
	local tfdAbility = _mainLayout.TFD_ABILITY
	if (_treaInfo.treaLelUpAwakenDes) then
		imgAdvanceAbility:setEnabled(true)
		tfdAbility:setEnabled(true)

		lableStroke(tfdAbility)
		tfdAbility:setText("")
		tfdAbility:setText(_treaInfo.treaLelUpAwakenDes)
	else
		imgAdvanceAbility:setEnabled(false)
		tfdAbility:setEnabled(false)
	end
	
	local imgArrowLeft = _mainLayout.img_arrow_left
	local imgArrowRight = _mainLayout.img_arrow_right	
	if (treaIndex == 1) then
		imgArrowLeft:setVisible(false)
		imgArrowRight:setVisible(true)
	end
	if (treaIndex ==  allNum) then
		imgArrowLeft:setVisible(true)
		imgArrowRight:setVisible(false)
	end
	if (treaIndex == 1 and treaIndex ==  allNum ) then
		imgArrowLeft:setVisible(false)
		imgArrowRight:setVisible(false)
	end
	if (treaIndex > 1 and treaIndex <  allNum ) then
		imgArrowLeft:setVisible(true)
		imgArrowRight:setVisible(true)
	end
end

-- 初始化属性信息
function initAttr( attrBg,attrInfo )
	if (not attrInfo ) then
		attrBg:setEnabled(false)
		local arrImag = _mainLayout.IMG_ARROW
		arrImag:setEnabled(false)
		return
	else
		attrBg:setEnabled(true)
		local arrImag = _mainLayout.IMG_ARROW
		arrImag:setEnabled(true)
	end

	local treaDB = _treaInfo.treaDB
	-- 宝物名称
	local layName = attrBg.TFD_SPECIAL_NAME
	UIHelper.labelNewStroke(layName,ccc3(0x28,0x00,0x00))
	layName:setText(treaDB.name .. "+" .. attrInfo[1].refineLevel .. "")

	--  属性
	for i=1,5 do
		local WidgtName = "TFD_ATTR_NAME" .. i
		local WidgtNum = "TFD_ATTR_NUM" .. i

		local attrItemInfo = attrInfo[i]
		local tfdAttrName = attrBg[WidgtName]
		lableStroke(tfdAttrName)

		tfdAttrName:setText(attrItemInfo.name)
		local tfdAttrNum = attrBg[WidgtNum]
		lableStroke(tfdAttrNum)

		tfdAttrNum:setText("+" .. attrItemInfo.value)
	end
	
end


--  初始化消耗材料
function initMaterial( ... )
	--  材料部分
	local costInfo = _treaInfo.costInfo
	local consumBg = _mainLayout.img_consume_bg
	if (not _layConsumClone) then
		_layConsumClone = _mainLayout.img_bg
		_layConsumClonePosX = _layConsumClone:getPositionX()
		_layConsumClonePosY = _layConsumClone:getPositionY()
		_layConsumClone:retain()
		_layConsumClone:removeFromParentAndCleanup(true)
	end
	consumBg:removeChildByTag(_layConsumTag,true)
	local layConsum = _layConsumClone:clone()
	layConsum:setPosition(ccp(_layConsumClonePosX,_layConsumClonePosY))
	layConsum:setTag(_layConsumTag)
	consumBg:addChild(layConsum)

	if (not costInfo ) then
		logger:debug("initMaterial  not have")
		layConsum:setEnabled(false)
	else
		logger:debug("initMaterial  have")
		layConsum:setEnabled(true)
	end

	local treaDB = _treaInfo.treaDB
	-- 
	for i=1,2 do
		local latItem = layConsum["LAY_ITEM_ALL"..i]
		latItem:setEnabled(false)
	end

	-- 消耗物品
	local imgBg = layConsum.img_bg
	local normalCost = {}
	if (costInfo) then
		normalCost = costInfo.normalCost
		logger:debug({normalCost=normalCost})
	end
	for i,v in ipairs(normalCost) do
		---
		local latItem = layConsum["LAY_ITEM_ALL"..i]
		latItem:setEnabled(true)
		--
		local tempItem = v
		-- 物品图标
		local stuffTid = tonumber(tempItem.tid)
		local fragType = ItemUtil.getItemTypeByTid(stuffTid)
		local btnlay = ItemUtil.createBtnByTemplateId(stuffTid,function ( sender,eventType )
			if (eventType ==  TOUCH_EVENT_ENDED) then
				if (not _btnCanTouch) then
					return
				end

				local frgTid
				if (fragType.isNormal) then
					frgTid = stuffTid
				elseif (fragType.isSpeTreasure) then
					local specTreaInfo = DB_Item_exclusive.getDataById(stuffTid)
					local fragTb = lua_string_split(specTreaInfo.fragment, "|")
					frgTid = tonumber(fragTb[1])
				end
				local dropcallfn = function ( ... )
					logger:debug("onChangAfterQuick")
					SpecTreaRefineCtrl.onChangAfterQuick()
					initMaterial()
					initFragment()
				end

				PublicInfoCtrl.createItemDropInfoViewByTid(frgTid,dropcallfn)
			end
		end)
		local layItem = layConsum["LAY_ITEM" .. i]
		layItem:removeAllChildrenWithCleanup(true)
		local btnlaySize = btnlay:getSize()
		btnlay:setPosition(ccp(btnlaySize.width * 0.5,btnlaySize.height * 0.5))
		layItem:addChild(btnlay)
		-- 名字
		local itemInfo = ItemUtil.getItemById(stuffTid)
		local tfdName = layConsum["TFD_ITEM_NAME" .. i]
		tfdName:setText(itemInfo.name)
		tfdName:setColor(g_QulityColor[itemInfo.quality])
		-- 数量
		local layItemfit = layConsum["LAY_ITEM_FIT" .. i]
		local tfdNumLeft = layItemfit.TFD_NUM_LEFT
		-- tfdNumLeft:setMaxLength(tfdNumLeft:getMaxLength() * (math.ceil(tempItem.haveNum/10) + 1))
		tfdNumLeft:setText(tempItem.haveNum)
		tfdNumLeft:setColor(tempItem.haveNum >= tempItem.needNum and ccc3(0x00,0x8a,0x00)  or ccc3(0xd8,0x13,0x00))

		
		local tfdSlant = layItemfit.tfd_slant
		tfdSlant:setText("/")
		local tfdNumRight = layItemfit.TFD_NUM_RIGHT
		tfdNumRight:setText(tempItem.needNum)
	end

	-- 按钮部分
	local btnAdvance =  _mainLayout.BTN_ADVANCE
	UIHelper.titleShadow(btnAdvance,_i18n[1005])  -- 进阶
	btnAdvance:addTouchEventListener(function ( sender,eventType )
		if (eventType ==  TOUCH_EVENT_ENDED) then
			if (not _btnCanTouch) then
				return
			end
			AudioHelper.playCommonEffect()
			SpecTreaRefineCtrl.onRefine()
		end
	end)

	local tfdConsumNum = _mainLayout.TFD_CONSUME_NUM
	if (costInfo) then
		tfdConsumNum:setText(costInfo.silverCost)
	else
		tfdConsumNum:setText(0)
	end
end

-- 飘属性字
function showFloatText( showFight )
	local treaAttrB = _treaInfo.refineBeforeAttr 
	local treaAttrA = _treaInfo.refineAfterAttr 
	if (not treaAttrA) then
		return
	end

	local tParam = {}
	-- table.insert(tParam,{txt=_i18n[6954], num = -1, displayNumType = 4, color=ccc3(0x00,0xff,0x06)})
	for i,v in ipairs(treaAttrB) do
		local textInfo = {}
		textInfo.txt = v.name
		-- 线上报错
		textInfo.num = tonumber(treaAttrA[i].realNum or 0) -  tonumber(treaAttrB[i].realNum or 0)
		table.insert(tParam,textInfo)
	end
	local title = {{txt=_i18n[6954], num = -1, displayNumType = 4, color=ccc3(0x00,0xff,0x06)}}
	require "script/utils/LevelUpUtil"
	LevelUpUtil.showFlyText(tParam,function ( ... )
		setBtnStatus(true)
		if (showFight) then
			MainFormationTools.removeFlyText()
	     	MainFormationTools.fnShowFightForceChangeAni()
	    end
	end,nil,nil,nil,nil,title)

end


-- 万能材料转化部分
function initFragment(  )
	-- 万能材料数量
	_powerFragNum = _treaInfo.powerFragNum
	
	local layFragment  = _mainLayout.LAY_FRAGMENT
	local costInfo = _treaInfo.costInfo
	if (not costInfo) then
		layFragment:setEnabled(false)
		return
	end
	local normalCost = costInfo.normalCost
	if (#normalCost < 2) then
		layFragment:setEnabled(false)
		return
	else
		layFragment:setEnabled(true)
	end
	--
	local layFragInfo  = layFragment.tfd_frag_info
	layFragInfo:setText(_i18n[6927])
	lableStroke(layFragInfo)

	local tfdFragmentNum = layFragment.TFD_FRAG_NUM
	lableStroke(tfdFragmentNum)
	logger:debug({initFragment_powerFragNum = _powerFragNum})
	tfdFragmentNum:setText(_powerFragNum)
	-- 转化按钮
	local btnChange = layFragment.BTN_CHANGE
	UIHelper.titleShadow(btnChange,_i18n[6948])  -- 转化
	local refineLevel = _treaInfo.refineLevel
	if (not costInfo) then
		btnChange:setEnabled(false)
		return
	else
		btnChange:setEnabled(true)
	end
	btnChange:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (not _btnCanTouch) then
				return
			end

			AudioHelper.playCommonEffect()
			if (_powerFragNum == 0) then
				require "script/module/public/FragmentDrop"
				local fragmentDrop = FragmentDrop:new()
				local dropcallfn = function ( ... )
					logger:debug("onChangAfterQuick")
					SpecTreaRefineCtrl.onChangAfterQuick()
					initMaterial()
					initFragment()
				end
				local fragmentDroplayout = fragmentDrop:create(_powerFragTid,dropcallfn)
				LayerManager.addLayout(fragmentDroplayout)
	         	ShowNotice.showShellInfo(_i18n[6940])
			else
				require "script/module/specialTreasure/SpecTreaChange"
				local layout = SpecTreaChange.create(normalCost[2].tid,normalCost[2].haveNum,normalCost[2].needNum)
				LayerManager.addLayout(layout)
			end
		end
	end)
end


----------------------------------------------------特效-----------------------------------------
------------------------------------------------------------------------------------------------
function refineAnimation( callFn )
	local imgEffectLight = _mainLayout.IMG_EFFECT_LIGHT
    --处理动画
    AudioHelper.playEffect("audio/effect/texiao_jinjie1.mp3")
    local m_arAni1 = UIHelper.createArmatureNode({
        imagePath = "images/effect/jinjie/jinjie10.png",
        plistPath = "images/effect/jinjie/jinjie10.plist",
        filePath = "images/effect/jinjie/jinjie1.ExportJson",
        animationName = "jinjie1",
        loop = 0,
        fnMovementCall = function ( sender, MovementEventType, movementID )
                if (MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
 					callFn()
                end
        end,
    })
    m_arAni1:setPosition(imgEffectLight:getContentSize().height * 0.5,imgEffectLight:getContentSize().width * 0.5)
    imgEffectLight:removeAllNodes()
    imgEffectLight:addNode(m_arAni1)

end










