-- FileName: PartnerStrenView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("PartnerStrenView", package.seeall)

-- UI控件引用变量 --
local _mainLayout

-- 模块局部变量 --
local _heroInfo
local _heroIndex
local _allHeros
local _allNum
local _addInfo
--添加飞行文字 和飘动战斗力 返回的删除函数
local _stopAllaniFn

local spriteScale = 0.65
local m_i18n = gi18n
local _curPageNum
local m_i18nString = gi18nString
local _tbTfdAttrName -- 生命
local _tbTfdAttrNumName -- 生命数值 1222
local _tbTfdAttrAddNumName -- 增加多少生命 +1222
-- 所有动画播放状态
local _allAniOver = 1
local _flyTextAniOver = 1
local _blueProgressAniOver = 1
local _levleTextAniOver = 1
local _blueTimerTag = 333



local function init(...)

end

function destroy(...)
	package.loaded["PartnerStrenView"] = nil
end

function moduleName()
    return "PartnerStrenView"
end

function create(  )

    _heroInfo = {}
    _stopAllaniFn = nil
	local heroInfo = PartnerStrenCtrl.getHeroInfo()
    _heroInfo = table.hcopy(heroInfo,_heroInfo)
    _allHeros = PartnerStrenCtrl.getAllHero()
    _heroIndex,_allNum = PartnerStrenCtrl.getHeroIndex() 

	initBG()
    initMiddleInfo()
	initNameLelInfo()
	initAttrInfo()
	initPageViewStatus()
    guildeLine()
    -- offLineReConect()
	return _mainLayout
end

-- 设置按钮
-- 1 强化按钮 2 自动添加按钮
function setBtnTouchEnable( btnTag,canTouch )
    if (btnTag == "onStren") then
        local btnStrengthen = _mainLayout.BTN_STRENGTHEN 
        btnStrengthen:setTouchEnabled( canTouch)
    elseif (btnTag ==  "auotoAdd") then
        local btnStrengthenAutoAdd = _mainLayout.BTN_STRENGTHEN_AUTOADD
        btnStrengthenAutoAdd:setTouchEnabled(canTouch)
    end
end

-- 断线重连
function offLineReConect( ... )
    UIHelper.registExitAndEnterCall(
        _mainLayout,
        function ( ... )
            PartnerStrenCtrl.removeOfflineObserver()
        end,
        function (...)
            GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
                PartnerStrenCtrl.addOfflineObserver()
            end, 
            nil, moduleName() .. "_RemoveUILoading")
            logger:debug("registEnterCall PartnerStrenView")
        end
    )
end


function guildeLine( ... )
   require "script/module/guide/GuideModel"
    require "script/module/guide/GuideFiveLevelGiftView"
    if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 10) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createkFiveLevelGiftGuide(11,0)
    end

    require "script/module/guide/GuideCopy2BoxView"
    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 14) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopy2BoxGuide(15)
    end

    require "script/module/guide/GuideFormationView"
    if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 3) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createFormationGuide(4)
    end

end

-- 获取动画是否播放完毕
function getLayoutAniOverStatus( ... )
    return _allAniOver
end

-- 设置pageView的触摸状态
function resetPageViewStatus( ... )
    local heroPageView = _mainLayout.PGV_HERO
    heroPageView:setTouchEnabled(true)
end

-- 判断pageView是否在滑动
function getPageViewIsScrolling( ... )
    local heroPageView = _mainLayout.PGV_HERO
    if (heroPageView:isAutoScrolling()) then
        return true
    else
        return false
    end
end

-- 重新设置基本信息
function reSetHeroInfo(  )
    local heroInfo = PartnerStrenCtrl.getHeroInfo()
    _heroInfo = table.hcopy(heroInfo,_heroInfo)
end

--
function resettstopAllaniFn( ... )
    _stopAllaniFn = nil
end

-- 重置页面
function resetAllMes( ... )
    MainFormationTools.removeFlyText()
    if (_stopAllaniFn) then
        _stopAllaniFn()
    end
    initNameLelInfo()
    initAttrInfo()
    initPageViewStatus()
    PartnerStrenCtrl.resetShadowStatus()
end

-- 初始化背景图片
function initBG(  )
    _mainLayout = g_fnLoadUI("ui/partner_card_strengthen.json")
    _mainLayout:setSize(g_winSize)
    local pBG = _mainLayout.img_bg
    pBG:setZOrder(-1)
    if(g_winSize.width ~= 640) then
        local pSize = pBG:getContentSize()
        local pBili = g_winSize.width/640
        pBG:setScale(pBili)
    end
    -- zhangjunwu, 2014-10-24, 注册UI被remove的回调，判断是否有过至少一次强化成功，来判断是否需要更新伙伴界面的数据
    --如果直接点击了 主船等按钮，则无法调用返回按钮的回条
    UIHelper.registExitAndEnterCall(_mainLayout, function ( ... )
        MainFormationTools.removeFlyText()
        -- MainPartner.refreshYingZiListView()
        UIHelper.removeArmatureFileCache()   --  释放动画缓存
        GlobalNotify.removeObserver("SHADOWSLELECT_OK", "SHADOWSLELECT_OK")
        PartnerStrenCtrl.removeOfflineObserver()
    end,function (  )
        GlobalNotify.addObserver("SHADOWSLELECT_OK", function ( shadowList )
                                    PartnerStrenCtrl.shadowChooseReturn(shadowList)
                                    end, nil, "SHADOWSLELECT_OK")
        GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
                                    PartnerStrenCtrl.addOfflineObserver()
                                end, nil, moduleName() .. "_RemoveUILoading")

    end)
end

function initNameLelInfo( ... )
	-- 名字
	local heroDB = _heroInfo.heroDB
    local tfdHeroName = _mainLayout.TFD_HERO_NAME
    tfdHeroName:setText(heroDB.name)
    tfdHeroName:setColor(g_QulityColor2[tonumber(heroDB.star_lv)])
    -- 强化等级
    tfdAddNum = _mainLayout.TFD_ADD_NUM
    tfdAddNum:setText("+" .. _heroInfo.evolve_level)
    tfdAddNum:setColor(g_QulityColor2[tonumber(heroDB.star_lv)])

    imgHeroType = _mainLayout.IMG_HERO_TYPE
    imgHeroType:setEnabled(false)

    -- 返回建
    local btnStrengthenBack = _mainLayout.BTN_STRENGTHEN_BACK
    btnStrengthenBack:addTouchEventListener(function ( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playBackEffect()
            PartnerStrenCtrl.onBack(_heroIndex)
        end
    end)
    UIHelper.titleShadow(btnStrengthenBack,m_i18n[1019])

end

-- 基础属性
function initAttrInfo( ... )
	local forceValue = _heroInfo.forceValue
    --属性
    _tbTfdAttrName = {"tfd_strengthen_hp","tfd_strengthen_phy_attack","tfd_strengthen_magic_attack",
                    "tfd_strengthen_phy_denfend","tfd_strengthen_magic_denfend"}


    _tbTfdAttrNumName = {"TFD_STRENGTHEN_HP_NUM" , "TFD_STRENGTHEN_PHY_ATTACK_NUM" , "TFD_STRENGTHEN_MAGIC_ATTACK_NUM"
                    , "TFD_STRENGTHEN_PHY_DENFEND_NUM" , "TFD_STRENGTHEN_MAGIC_DENFEND_NUM"}

    _tbTfdAttrAddNumName = {"TFD_HP_ADD" , "TFD_PHY_ATTACK_ADD" , "TFD_MAGIC_ATTACK_ADD"
                    , "TFD_PHY_DENFEND_ADD" , "TFD_MAGIC_DENFEND_ADD"}

    local tbName = {m_i18n[1047],m_i18n[1048],m_i18n[1049],m_i18n[1050],m_i18n[1051]}
    local tbTfdAttrVaule =  {forceValue.life,forceValue.physicalAttack,forceValue.magicAttack,forceValue.physicalDefend,forceValue.magicDefend}
 
    for i=1, 5 do
        local tfdAttrName = _mainLayout[_tbTfdAttrName[i]]
        tfdAttrName:setText(tbName[i])

        local tfdAttrNum = _mainLayout[_tbTfdAttrNumName[i]]
        tfdAttrNum:stopAllActions()
        tfdAttrNum:setScale(1)
        tfdAttrNum:setText(tbTfdAttrVaule[i])

        local tfdAttrAddNum = _mainLayout[_tbTfdAttrAddNumName[i]]
        tfdAttrAddNum:setText("")
    end

    -- 经验蓝条
    local loadStrengthenBlueBar = _mainLayout.LOAD_STRENGTHEN_BULE_BAR
    local buleTimer = UIHelper.fnGetProgress("ui/new_pro_blue.png")
    buleTimer:setTag(_blueTimerTag)
    loadStrengthenBlueBar:removeAllNodes()
    loadStrengthenBlueBar:addNode(buleTimer)
    loadStrengthenBlueBar:setPercent(0)

    local bluePersent = _heroInfo.bluePersent
    buleTimer:setPercentage(bluePersent)
 
    -- -- 经验绿条
    local loadStrengthenGreenBar = _mainLayout.LOAD_STRENGTHEN_GREEN_BAR
    local gressSprite = loadStrengthenGreenBar:getVirtualRenderer()
    gressSprite:stopAllActions()
    -- UIHelper.fadeInAndOutUI(gressSprite,1,1,0)
    local greenPersent = _heroInfo.greenPersent
    loadStrengthenGreenBar:setPercent(greenPersent)

    --消耗贝利、获得经验
    local tfdBellyNum = _mainLayout.TFD_CARD_STRENGTHEN_BELLY_CONSUME_NUM
    tfdBellyNum:setText("0")

    local tfdStrengthenExpNum = _mainLayout.TFD_CARD_STRENGTHEN_EXP_NUM
    tfdStrengthenExpNum:setText("0")
    UIHelper.labelNewStroke(tfdStrengthenExpNum,ccc3(0x8e,0x46,0x00))
    UIHelper.labelShadow(tfdStrengthenExpNum,CCSizeMake(2,-2))

    local tfdCardStrengthenExp = _mainLayout.tfd_card_strengthen_exp
    tfdCardStrengthenExp:setText(m_i18n[1053])
    UIHelper.labelNewStroke(tfdCardStrengthenExp,ccc3(0x8e,0x46,0x00))
    UIHelper.labelShadow(tfdCardStrengthenExp,CCSizeMake(2,-2))

    local tfdLevel = _mainLayout.tfd_strengthen_level
    tfdLevel:stopAllActions()
    tfdLevel:setScale(1)
    tfdLevel:setText(_heroInfo.level)
    tfdLevel:setFontSize(24)
    tfdLevel:setColor(ccc3(0xff,0xff,0xff))
    tfdLevel:setFontName(g_sFontCuYuan)
    UIHelper.labelNewStroke(tfdLevel , ccc3( 0xd6 , 0x0c , 0x06))

    local tfdAddLevel = _mainLayout.TFD_ADD_LV
    tfdAddLevel:setText("")
   
    --强化按钮 
    local btnStrengthen = _mainLayout.BTN_STRENGTHEN 
    btnStrengthen:addTouchEventListener(function ( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            if(getPageViewIsScrolling()) then
                return
            end
            AudioHelper.playCommonEffect()
    	    PartnerStrenCtrl.onStren()
        end
    end)
    UIHelper.titleShadow(btnStrengthen,m_i18nString(1159," "))
    --自动添加按钮
    local btnStrengthenAutoAdd = _mainLayout.BTN_STRENGTHEN_AUTOADD
    btnStrengthenAutoAdd:addTouchEventListener(function ( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            if(getPageViewIsScrolling()) then
                return
            end
    	    PartnerStrenCtrl.onAutoAdd()
        end
    end)
	
end

-- 初始化pageView状态
function initPageViewStatus( ... )
	-- 模型图片
	local pgvmain = _mainLayout.PGV_HERO
	
	local imgArrowLeft = _mainLayout.IMG_ARROW_LEFT
	local imgArrowRight = _mainLayout.IMG_ARROW_RIGHT	
	if (_heroIndex == 1) then
		imgArrowLeft:setVisible(false)
		imgArrowRight:setVisible(true)
	end
	if (_heroIndex ==  _allNum) then
		imgArrowLeft:setVisible(true)
		imgArrowRight:setVisible(false)
	end
	if (_heroIndex == 1 and _heroIndex ==  _allNum ) then
		imgArrowLeft:setVisible(false)
		imgArrowRight:setVisible(false)
	end
	if (_heroIndex > 1 and _heroIndex <  _allNum ) then
		imgArrowLeft:setVisible(true)
		imgArrowRight:setVisible(true)
	end
end


local function fnGetAniName( str )
	local qhAniPath = "images/effect/hero_qh"
    return  string.format("%s/%s/%s.ExportJson",qhAniPath,str,str)
end


-- 加光阵特效
local guangZhenAniTag = 7777
local function fnAddBaseAni( model , modelIndex, mainModel)
    local nIndex = tonumber(modelIndex)
    local aniY = -model:getSize().height*0.06
    local aniX = 0
    local pName = "qh_guangzheng_xiao"
    local addAniModel
    if(nIndex == 0) then  -- 主英雄模型位置
        addAniModel = mainModel
        pName = "qh_guangzheng_da"
        aniX = model:getSize().width*0.5
        aniY = 140
    else                   -- 其他影子模型位置
        addAniModel = model
    end

    local guangZhenAni = UIHelper.createArmatureNode({
        filePath =  fnGetAniName("qh_guangzheng"),
        animationName = pName,
        bRetain =  true,
    })
    guangZhenAni:setPosition(ccp(aniX, aniY))
    addAniModel:removeNodeByTag(guangZhenAniTag)
    guangZhenAni:setTag(guangZhenAniTag)
    addAniModel:addNode(guangZhenAni,10, 2)
end


--[[desc:刷新Consume位置
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
    aniStatus:动画状态 默认nil 为初始状态 1 为添加了影子状态 2 去掉影子状态
    strenghAfter:是否是点击强化后刷新
—]]
local selectAniTag = 5555
local shadowSpriteTag = 6666
local function initConSume( _index,consumeInfo,strenAfter )

    local pConsume = _mainLayout["BTN_CARD_STRENGTHEN_CONSUME_ICON" .. _index]
    local pConsumeAdd = _mainLayout["IMG_CARD_STRENGTHEN_CONSUME_ADD" .. _index]
    local pImgCost = _mainLayout["IMG_COST_" .. _index]
    local pImgCostModel = _mainLayout["IMG_COST_MODEL_" .. _index]
    local pTfdNum = _mainLayout["TFD_NUM_" .. _index]
    local pImagShadow = _mainLayout["IMG_SHADOW_" .. _index]
    local pBtnX = _mainLayout["BTN_X_" .. _index]
  
    pImgCost:setVisible(false)
    pImgCostModel:setVisible(false)
    pTfdNum:setVisible(false)
    pImagShadow:setVisible(false)
    pConsumeAdd:setVisible(false)
   	pBtnX:setEnabled(false)
    -- 加默认选择影子特效 
    if (not strenAfter) then
        pImgCost:setVisible(true)
        local selectAni = UIHelper.createArmatureNode({
            filePath =  fnGetAniName("qh2_guangzheng"),
            -- animationName = strenAfter  and "guangzheng_xiao_wu2"  or "guangzheng_xiao_renwu",
            animationName =  "guangzheng_xiao_renwu",
            bRetain =  true,
        })

        selectAni:setPosition(ccp(pConsumeAdd:getPositionX(), pConsumeAdd:getPositionY() - 60))

        pConsume:removeAllNodes()
        pImgCostModel:removeAllNodes()

        selectAni:setTag(selectAniTag)
        pConsume:addNode(selectAni)
    end
    -- 加影子模型
    if (consumeInfo) then
        pImgCost:setVisible(false)
        pImgCostModel:setVisible(true)
        pTfdNum:setVisible(true)

        pTfdNum:setText(m_i18n[1332] .. consumeInfo.useNums)
        UIHelper.labelNewStroke(pTfdNum , ccc3( 0x20 , 0x00 , 0x00))

        local shadowSprite = CCSprite:create(consumeInfo.body_img)
        shadowSprite:setPosition(ccp(0,250))
        local arr = CCArray:create()
        local pTime1 = 10/60
        local pMov1 = CCMoveTo:create(pTime1, ccp(shadowSprite:getPositionX(),shadowSprite:getPositionY() - 300))
        arr:addObject(pMov1)
        local pTime2 = 5/60
        local pMov2 = CCMoveTo:create(pTime1, ccp(shadowSprite:getPositionX(),shadowSprite:getPositionY() - 250))
        arr:addObject(pMov2)
        shadowSprite:runAction(CCSequence:create(arr))

        local pSize = pImgCostModel:getContentSize()
        shadowSprite:setAnchorPoint(0.5,0)

        pImgCostModel:removeAllNodes()
        pConsume:removeAllNodes()

        shadowSprite:setTag(shadowSpriteTag)
        pImgCostModel:addNode(shadowSprite)
        -- 加特效
        fnAddBaseAni(pConsume,_index)
    end
    -- 去掉影子模型
    if (strenAfter == 2) then
        pImgCost:setVisible(false)
        pConsume:removeNodeByTag(selectAniTag)
        pImgCostModel:removeNodeByTag(shadowSpriteTag)
    end
      
end

--[[desc:初始化pageView
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function initMiddleInfo( ... )
    local layEffect = _mainLayout.LAY_EFFECT
    local layEffect1 = _mainLayout.LAY_EFFECT_1

    local heroPageView = _mainLayout.PGV_HERO
    local pageLayClone = _mainLayout.lay_pgv
	heroPageView:removeAllPages()

    local function addHeroSprite( widget,heroInfo )
    	local heroModleChild = widget:getNodeByTag(4)
    	if (heroModleChild) then
    		return
    	end
    	local heroDB = heroInfo.heroDB 
    	local heroSprite = CCSprite:create("images/base/hero/body_img/" .. heroDB.body_img_id)
        heroSprite:setPosition(ccp(widget:getContentSize().width/2,0))
        heroSprite:setAnchorPoint(0.5,0)
        heroSprite:setScale(spriteScale)
        heroSprite:setTag(4)
        -- widget:removeAllNodes()
        widget:addNode(heroSprite)
        UIHelper.fnPlayHuxiAni(heroSprite)
    end

	for i,v in ipairs(_allHeros ) do
		local layPageItem = pageLayClone:clone()
		local layCardBody = layPageItem.LAY_CARD_BODY
		heroPageView:addWidgetToPage(layPageItem, i, true)

		if (i == _heroIndex - 1) then
			addHeroSprite(layCardBody,v)
		elseif (i == _heroIndex )  then 
			addHeroSprite(layCardBody,v)
		elseif (i == _heroIndex + 1) then
			addHeroSprite(layCardBody,v)
		end
	end
    heroPageView:initToPage(_heroIndex - 1)
    _curPageNum = _heroIndex - 1
    	-- 翻页功能
	heroPageView:addEventListenerPageView(function ( sender, eventType )
		if (eventType == PAGEVIEW_EVENT_TURNING) then

			local  curPage= heroPageView:getCurPageIndex()
			if (_curPageNum == curPage) then
				return
			end
	    	local  pagAllNum = heroPageView:getPages():count()
			if (  curPage > _curPageNum and (curPage ~= pagAllNum - 1)) then
				local layPageItem = heroPageView:getPage( curPage + 1)
				local layCardBody = layPageItem.LAY_CARD_BODY
                local perLoadheroInfo = _allHeros[ curPage + 2 ]
				addHeroSprite(layCardBody,perLoadheroInfo)
			elseif (  curPage < _curPageNum and curPage ~= 0) then
				local layPageItem = heroPageView:getPage(curPage - 1)
				local layCardBody = layPageItem.LAY_CARD_BODY
                local perLoadheroInfo = _allHeros[ curPage ]
				addHeroSprite(layCardBody,perLoadheroInfo)
			end
			_curPageNum =  curPage
            local curheroInfo = _allHeros[curPage + 1]
			local heroInfo = PartnerStrenCtrl.initHeroInfo(curheroInfo.hid)
            _heroIndex = curPage + 1
            _heroInfo = {}
			_heroInfo = table.hcopy(heroInfo,_heroInfo) 
			--  重置页面信息
			resetAllMes()
		end
	end)

    layEffect:removeAllNodes()
    layEffect1:removeAllNodes()
    fnAddBaseAni(layEffect,0,layEffect1)

    -- 初始化消耗部分
    for i=1,5 do
    	initConSume(i)
    end
    -- 选择影子按钮
    local function selectShadow( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            PartnerStrenCtrl.onSlectShadow()
        end
    end 

    for i=1,5 do
        local btnShadowSelect = _mainLayout["BTN_UNLESS_" .. i]
        btnShadowSelect:addTouchEventListener(selectShadow)
    end
end

--addMethod 添加方式  1 自动添加 2 手动添加 0 默认方式
function setAddAttrInfo( addInfo,addMethod )
    _addInfo = {}
    _addInfo = table.hcopy(addInfo,_addInfo)
	-- 属性部分提升
    local addforceValue = _addInfo.forceValue
	local beforeforceValue = _heroInfo.forceValue

    for i=1, 5 do
        local tfdAttrAddNum = _mainLayout[_tbTfdAttrAddNumName[i]]
        tfdAttrAddNum:removeAllNodes()
    end

    if (addforceValue) then
        local tbTfdAfterVaule =  {addforceValue.life,addforceValue.physicalAttack,addforceValue.magicAttack,addforceValue.physicalDefend,addforceValue.magicDefend}
        local tbTfdBrforeVaule =  {beforeforceValue.life,beforeforceValue.physicalAttack,beforeforceValue.magicAttack,beforeforceValue.physicalDefend,beforeforceValue.magicDefend}
	    for i=1, 5 do
	        local tfdAttrAddNum = _mainLayout[_tbTfdAttrAddNumName[i]]
	        local addNum = tonumber(tbTfdAfterVaule[i]) - tonumber(tbTfdBrforeVaule[i])
            local pTex = "+" .. addNum
            local pNode = UIHelper.createBlinkLabel({
                fontSize = pFontSize, 
                fontName = g_sFontCuYuan,
                text1 = pTex,
                color1 = ccc3(0x00,0x89,0x00),
            })
            pNode:setAnchorPoint(ccp(0,0.5))
            tfdAttrAddNum:removeAllNodes()
            tfdAttrAddNum:addNode(pNode)
	    end
    end

	-- 强化等级部分提升
    local tfdAddLevel = _mainLayout.TFD_ADD_LV
    tfdAddLevel:removeAllNodes()

	local addLel = tonumber(_addInfo.level or 0) - tonumber(_heroInfo.level)
    if (_addInfo.level and tonumber(addLel)>0) then
        logger:debug({setAddAttrInfo_addLel = addLel})
        local tfdAddLevelBlink = UIHelper.createBlinkLabel({
            fontSize = 24, 
            fontName = g_sFontCuYuan,
            text1 = "+" .. addLel,
            strokeColor = ccc3(0xd6,0x0c,0x06),
            color1 = ccc3(0x00,0xff,0x00),
        })
        tfdAddLevelBlink:setAnchorPoint(ccp(0,0.5))
        tfdAddLevel:removeAllNodes()
        tfdAddLevel:addNode(tfdAddLevelBlink)
    end

    -- 经验绿条
    local greenShowPersent =  tonumber(_addInfo.greenShowPersent or 0)
    local loadStrengthenGreenBar = _mainLayout.LOAD_STRENGTHEN_GREEN_BAR
    local gressSprite = loadStrengthenGreenBar:getVirtualRenderer()
    gressSprite:stopAllActions()
    UIHelper.fadeInAndOutUI(gressSprite,1,1,0)
    loadStrengthenGreenBar:setPercent(0)
    if (greenShowPersent > 0) then
        loadStrengthenGreenBar:setPercent(greenShowPersent)
    end

    local tfdStrengthenExpNum = _mainLayout.TFD_CARD_STRENGTHEN_EXP_NUM
    tfdStrengthenExpNum:setText(0)
    if (_addInfo.totalExp and tonumber(_addInfo.totalExp)> 0) then
        tfdStrengthenExpNum:setText(_addInfo.totalExp)
    end

	-- 需要贝里部分
    local tfdBeiliNum = _mainLayout.TFD_CARD_STRENGTHEN_BELLY_CONSUME_NUM
    local totalBelly=  _addInfo.totalBelly
    tfdBeiliNum:setText(0)
    if (totalBelly and totalBelly > 0) then
        tfdBeiliNum:setText(totalBelly)
    end 
    -- 消耗影子部分
    local atuoAddShadowList = _addInfo.tbSelectShadow
    logger:debug({atuoAddShadowList = atuoAddShadowList})
    for i=1,5 do
        initConSume(i)
    end
    for i,v in ipairs(atuoAddShadowList or {}) do
        if (v.checkIsSelected) then
            initConSume(i,v)
        end
    end
    PartnerStrenCtrl.setAddShadowType(addMethod or 0)
end

-- 获取当前page页里的LAY_CARD_BODY
function getCurPageView( ... )
    local curPageViewIndex = _mainLayout.PGV_HERO:getCurPageIndex()
    local curPageView = _mainLayout.PGV_HERO:getPage(curPageViewIndex)
    local layCardBody = curPageView.LAY_CARD_BODY
    return layCardBody
end

-- 获取飞行数字
function fnGetFlyAtrr( ... )
    local affterForceValue = _addInfo.forceValue
    local beforeForceValue = _heroInfo.forceValue

    local flyAtrr = {}

    for i=1,5 do
        local flyTextInfo = {}
        if(i == 1) then
            flyTextInfo.endNum = tonumber(affterForceValue.life)  
            flyTextInfo.num = tonumber(affterForceValue.life) - tonumber(beforeForceValue.life)
        elseif(i == 2) then
            flyTextInfo.endNum = tonumber(affterForceValue.physicalAttack) 
            flyTextInfo.num = tonumber(affterForceValue.physicalAttack) - tonumber(beforeForceValue.physicalAttack)
        elseif(i == 3) then
            flyTextInfo.endNum = tonumber(affterForceValue.magicAttack)
            flyTextInfo.num = tonumber(affterForceValue.magicAttack) - tonumber(beforeForceValue.magicAttack)
        elseif(i == 4) then
            flyTextInfo.endNum = tonumber(affterForceValue.physicalDefend)
            flyTextInfo.num = tonumber(affterForceValue.physicalDefend) - tonumber(beforeForceValue.physicalDefend)
        elseif(i == 5) then
            flyTextInfo.endNum = tonumber(affterForceValue.magicDefend)
            flyTextInfo.num = tonumber(affterForceValue.magicDefend) - tonumber(beforeForceValue.magicDefend)
        end

        flyTextInfo.txt = m_i18n[1068 + (i-1)]
        table.insert(flyAtrr, flyTextInfo) 
    end
    return flyAtrr
end

-- 强化成功显示等级动画(提升多少级动画)
function addLevlelUpAnimation( ... )
    local m_layEffect = _mainLayout.LAY_EFFECT
    local affterLv = _addInfo.level or _heroInfo.level
    local addlevel = affterLv - _heroInfo.level

    local img_effect_2  = _mainLayout.img_effect_2
    local TishengeffectPosX = img_effect_2:getPositionX()
    local TishengeffectPosY = img_effect_2:getPositionY()

    if(addlevel <= 0) then
        return
    end
    local function animation4CallBack( armature,movementType,movementID )
        if  movementType == EVT_COMPLETE then
            levelUpOver = true
            armature:removeFromParentAndCleanup(true)
            require "script/module/guide/GuideFiveLevelGiftView"
            if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 12) then  
                LayerManager.removeLayout()
                require "script/module/guide/GuideCtrl"
                GuideCtrl.createkFiveLevelGiftGuide(13,0)
            end 

            require "script/module/guide/GuideCopy2BoxView"
            if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 16) then
                  LayerManager.removeLayout()
                require "script/module/guide/GuideCtrl"
                GuideCtrl.createCopy2BoxGuide(17)
            end

            require "script/module/guide/GuideFormationView"
            if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 5) then
                LayerManager.removeLayout()
                require "script/module/guide/GuideCtrl"
                GuideCtrl.createFormationGuide(6)
            end
        end
    end
    local armature =  g_attribManager:createAddLevelEffect({
        level = addlevel,
        fnMovementCall = animation4CallBack,
    })
    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
    
    local pos = ccp(m_layEffect:getPositionX(),m_layEffect:getPositionY())
    local ppos = m_layEffect:getParent():convertToWorldSpace(pos)
    local pSize = m_layEffect:getSize()
    local showpos = ccp(ppos.x+pSize.width*0.5, ppos.y+pSize.height*0)
    armature:setPosition(ccp(TishengeffectPosX,TishengeffectPosY))
    local pBG = _mainLayout.img_card_strengthen_consume_bg
    pBG:addNode(armature,100)

end
-- 强化成功 -tfdAttr 强化成功动画 回调加 飘字动画
local qinagHuaChengGongAniTag = 4444
function addFlyTextAnimation(  )
    local tfdAttr = {}
    for i=1,5 do
        local tfdAttrNum = _mainLayout[_tbTfdAttrNumName[i]]
        table.insert(tfdAttr,tfdAttrNum)
    end

    local m_flyattr = fnGetFlyAtrr()
    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
    local m_layEffect = _mainLayout.LAY_EFFECT
    -- 强化成功动画
    local qinagHuaChengGongAni = g_attribManager:createStrenOKEffect({
        fnMovementCall = function ( sender, MovementEventType, movementID )
            if(MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
                end
            end,
        fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
            local pos = ccp(m_layEffect:getPositionX(),m_layEffect:getPositionY())
            local ppos = m_layEffect:getParent():convertToWorldSpace(pos)
            local pSize = m_layEffect:getSize()
            local showpos = ccp(ppos.x+pSize.width*0.5, ppos.y+pSize.height*0.5)
            require "script/module/formation/MainFormationTools"
            local runningScene = CCDirector:sharedDirector():getRunningScene()

            local isShowFightAnimte = HeroPublicUtil.isOnFmtByHid(_heroInfo.hid)
            logger:debug({isShowFightAnimte = isShowFightAnimte})
            function changAutoAddStatus( ... )
                -- 重置影子添加状态 可以正常添加影子
                PartnerStrenCtrl.setAddShadowType(0)
                resettstopAllaniFn()
            end
            local  tipNode = CCNode:create()
            _mainLayout:addNode(tipNode,999999999)
            logger:debug("showFlyPartnerCardStrengthText")
            _stopAllaniFn =  LevelUpUtil.showFlyPartnerCardStrengthText(tipNode,m_flyattr,function ( ... )
                -- 战斗力提升动画、
                MainFormationTools.removeFlyText()
                MainFormationTools.fnShowFightForceChangeAni()
            end,showpos,tfdAttr,isShowFightAnimte,changAutoAddStatus)
            addLevlelUpAnimation()
        end
    })
    
    local img_effect_1  = _mainLayout.img_effect_1
    local chengGongEffectPosX = img_effect_1:getPositionX()
    local chengGongEffectPosY = img_effect_1:getPositionY()

    qinagHuaChengGongAni:setPosition(ccp(chengGongEffectPosX,chengGongEffectPosY))
    local pBG = _mainLayout.img_card_strengthen_consume_bg
    qinagHuaChengGongAni:setTag(qinagHuaChengGongAniTag)
    pBG:removeNodeByTag(qinagHuaChengGongAniTag)
    pBG:addNode(qinagHuaChengGongAni,100)
end


--主强化关键帧处理
local aniShakeNode1 = nil
local aniShakeNode2 = nil
local guangzhaoTag = 3333
local xingTag = 4444
local function fnMainHeChengKeyFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
    local layCardStrengthenBody = getCurPageView()
    if(frameEventName == "1") then
        local img_bg = _mainLayout.img_bg
        local pBG = _mainLayout.img_card_strengthen_consume_bg

        local shakePointTable = {{0,0,2},{0,15,2},{0,15,0},{10,0,2},{0,-15,4},{0,0,0}}
        aniShakeNode1 = ShakeSenceEffNorandom:new(img_bg,shakePointTable)
        aniShakeNode2 = ShakeSenceEffNorandom:new(pBG,shakePointTable)

        local cardSp = layCardStrengthenBody:getNodeByTag(4)
        if(not cardSp) then
            return
        end
        cardSp:stopAllActions()

        local arr = CCArray:create()

        local pTime1 = 5/60
        local pSc = CCScaleTo:create(pTime1, spriteScale * 1.1)
        local pMov = CCMoveTo:create(pTime1, ccp(cardSp:getPositionX(),cardSp:getPositionY() + 40))

        local pRemoveEffect = CCCallFuncN:create(function ( ... )
            
        end)
        local pSpan = CCSpawn:createWithTwoActions(pSc,pRemoveEffect)
        arr:addObject(pSpan)
        arr:addObject(CCCallFuncN:create(function ( ... )
            local m_zhaoAni = UIHelper.createArmatureNode({
                filePath = "images/effect/shop_recruit/zhao3.ExportJson",
                animationName = "zhao3",
                loop = 0,
                bRetain =  true,
                fnMovementCall = function ( sender, MovementEventType, movementID )
                    if(MovementEventType == 1) then
                        sender:removeFromParentAndCleanup(true)
                    end
                end,

            })
            cardSp:removeChildByTag(guangzhaoTag,true)
            m_zhaoAni:setTag(guangzhaoTag)
            m_zhaoAni:setScale(m_zhaoAni:getScale() / spriteScale * 0.8)
            local cardSpSize = cardSp:getContentSize()
            m_zhaoAni:setPosition(ccp(m_zhaoAni:getPositionX() + cardSpSize.width * 0.5  ,m_zhaoAni:getPositionY()+cardSpSize.height*0.5 + 50))
            cardSp:addChild(m_zhaoAni,-1)

        end))
       
        cardSp:runAction(CCSequence:create(arr))
    elseif(frameEventName == "2") then
        --强化成功
        logger:debug({_addInfo = _addInfo})
        logger:debug({_heroInfo = _heroInfo})

        local forceValue = _addInfo.forceValue
        local pNow = tonumber(_heroInfo.bluePersent)
        local pLv = tonumber(_addInfo.level)
        local pNext = tonumber(_addInfo.blueShowPersent)
        local function changLevelNumStatus( ... )
            PartnerStrenCtrl.setAddShadowType(0)
        end
        if (forceValue) then
            addFlyTextAnimation()     -- 添加飞行数字动画
            local tfdLevel = _mainLayout.tfd_strengthen_level
            LevelUpUtil.fnPlayOneNumNoRandomChangeAni( tfdLevel ,_heroInfo.level ,pLv - _heroInfo.level,changLevelNumStatus)   -- 等级数字跳动动画
        else
        end
        local loadStrengthenBlueBar = _mainLayout.LOAD_STRENGTHEN_BULE_BAR:getNodeByTag(_blueTimerTag)
        local loadStrengthenGreenBar = _mainLayout.LOAD_STRENGTHEN_GREEN_BAR
        loadStrengthenGreenBar:setPercent(0)

        PartnerStrenCtrl.blueProgressChangeAni(loadStrengthenBlueBar,pLv - _heroInfo.level,pNow,pNext,function( ... )
        end,0)
    elseif(frameEventName == "3") then
        local arr = CCArray:create()
        local cardSp = layCardStrengthenBody:getNodeByTag(4)
        if(not cardSp) then
            return
        end
        arr:addObject(CCCallFuncN:create(function ( ... )
            -- cardSp:getParent():removeNodeByTag(guangzhaoAnimateTag)
        end))
        local pTime1 = 1/20
        local pSc1 = CCScaleTo:create(pTime1,  spriteScale * 0.9)
        local pMov = CCMoveTo:create(pTime1, ccp(cardSp:getPositionX(),cardSp:getPositionY()))
        local pSpan = CCSpawn:createWithTwoActions(pSc1,pMov)

        local pTime2 = 1/5
        local pSc2 = CCScaleTo:create(pTime2, spriteScale)
        arr:addObject(pSpan)
        arr:addObject(pSc2)
        arr:addObject(CCCallFuncN:create(function ( ... )
            UIHelper.fnPlayHuxiAni(cardSp)
            -- resetAllMes()--  设置成false 是因为要在飞行的文字动画完成后  再更改属性显示
            for i=1,5 do
                initConSume(i)
            end
            if (not forceValue) then
                PartnerStrenCtrl.setAddShadowType(0)
            end
            local dataRefreshStatus = PartnerStrenCtrl.getBagShadowRrfreshStatus()
            if (dataRefreshStatus == 0) then
                local heroPageView = _mainLayout.PGV_HERO
                heroPageView:setTouchEnabled(true)
            end
        end)) 
        cardSp:runAction(CCSequence:create(arr))

        local m_arAni1 = UIHelper.createArmatureNode({
            filePath = fnGetAniName("qh_xing"),
            animationName = "qh_xing",
            loop = 0,
            bRetain =  true,
            fnMovementCall = function ( sender, MovementEventType, movementID )
                if(MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
                end
            end,
        })
        local pSize = layCardStrengthenBody:getSize()
        local pPos = ccp(pSize.width*0.5,pSize.height*0.23)
        m_arAni1:setPosition(pPos)
        m_arAni1:setTag(xingTag)
        layCardStrengthenBody:removeNodeByTag(xingTag)
        layCardStrengthenBody:addNode(m_arAni1,10)
    end
end

local liuguangTag = 1111
local heChengDaTag = 2222

--四周小光柱关键帧处理
local function fnHeChengXKeyFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
    local layCardStrengthenBody = getCurPageView()
    local selectShadowList = PartnerStrenCtrl.getSelectShadowList()
    local selectNum = #selectShadowList
    if(frameEventName == "1") then
        --播放流光
        for i=1,selectNum do
            local liuguangAni = UIHelper.createArmatureNode({
            filePath = fnGetAniName("qh_liuguang"),
            animationName = string.format("%s%d","qh_liuguang",i),
            loop = 0,
            bRetain =  true,
            fnMovementCall = function ( sender, MovementEventType, movementID )
                if(MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
                end
            end,
            })
            local pSize = layCardStrengthenBody:getSize()
            local pPos = ccp(pSize.width*0.5,pSize.height*0.57)
            liuguangAni:setPosition(pPos)
            liuguangAni:setTag(liuguangTag)
            layCardStrengthenBody:removeNodeByTag(liuguangTag + i)
            layCardStrengthenBody:addNode(liuguangAni,-1)
        end
        --播放主光柱
    elseif(frameEventName == "2") then
        for i=1,5 do
            initConSume(i,nil,2)
        end

        local pSize = layCardStrengthenBody:getSize()
        local pPos = ccp(pSize.width*0.5,25)
        local heChengDaAni = UIHelper.createArmatureNode({
            filePath = fnGetAniName("qh_hecheng_da"),
            animationName = "qh_hecheng_da",
            loop = 0,
            bRetain =  true,
            fnFrameCall = fnMainHeChengKeyFrameCallBack,
            fnMovementCall = function ( sender, MovementEventType, movementID )
                if(MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
                end
            end,
        })
        heChengDaAni:setPosition(pPos)
        heChengDaAni:setTag(heChengDaTag)
        layCardStrengthenBody:removeNodeByTag(heChengDaTag)
        layCardStrengthenBody:addNode(heChengDaAni)
    end
end

--添加四周的小光柱
function createForgeLight( btnCard ,mainAnimate)
    local layCardStrengthenBody = getCurPageView()
    local visibleSize = btnCard:getContentSize()
    local m_arAni1 = UIHelper.createArmatureNode({
        filePath = fnGetAniName("qh_hecheng_xiao"),
        animationName = "qh_hecheng_xiao",
        loop = 0,
        bRetain =  true,
        fnFrameCall = mainAnimate and fnHeChengXKeyFrameCallBack,
        fnMovementCall = function ( sender, MovementEventType, movementID )
            if(MovementEventType == 1) then
                sender:removeFromParentAndCleanup(true)
                -- 动画播放完毕
            end
        end,
    })
    m_arAni1:setAnchorPoint(ccp(0.5,0.23))
    local pSize = layCardStrengthenBody:getSize()
    local pPos = ccp(pSize.width*0,-13)
    m_arAni1:setPosition(pPos)
    btnCard:removeAllNodes()
    btnCard:addNode(m_arAni1)
end

--强化后的动画特效
function playForgeEffect()
    local heroPageView = _mainLayout.PGV_HERO
    heroPageView:setTouchEnabled(false)
    -- 隐藏增加的属性显示
    for i=1,5 do
        local tfdAddNum = _mainLayout[_tbTfdAttrAddNumName[i]]
        tfdAddNum:removeAllNodes()
    end
    local tfdAddLel = _mainLayout.TFD_ADD_LV
    tfdAddLel:removeAllNodes()

    local tfdAddExpNum = _mainLayout.TFD_CARD_STRENGTHEN_EXP_NUM
    tfdAddExpNum:setText("0")
    ---------------------------------
    local shadowList = PartnerStrenCtrl.getSelectShadowList()
    AudioHelper.playEffect("audio/effect/texiao_baowu_qianghua.mp3")
    for i=1,#shadowList do
        local pConsume = _mainLayout["BTN_CARD_STRENGTHEN_CONSUME_ICON" .. i]
        if ( i == 1) then
            createForgeLight(pConsume,true)
        else
            createForgeLight(pConsume)
        end
    end 
end

