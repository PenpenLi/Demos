-- FileName: PartnerInfoView.lua
-- Author: sunyunpeng
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
--
require "script/module/public/MReleaseUtil"
PartnerInfoView = class("PartnerInfoView")
-- _UIMain.LSV_CONTENT:updateSizeAndPosition()

-- UI控件引用变量 --

-- 模块局部变量 --

function PartnerInfoView:moduleName( ... )
    return "PartnerInfoView"
end


function PartnerInfoView:initAllVariable( ... )
    self.biggerScale = 0.92
    self.smalllerScale = 0.92
    self.color_stroke = ccc3( 0x28, 0x00, 0x00)
    self.color_normal = ccc3( 0x7f, 0x5f, 0x20)
    self.color_get = ccc3( 0x01, 0x8a, 0x00)
    self.color_red = ccc3( 0xff, 0x3c, 0x00)
    self.textSize = 22
    self.cellPaddingLeft = 8
    self.cellPacingH = 10 --竖间距
    self.deviation = 0    --偏移量
    self.refreshBase = function ( ... ) end
    self.refreshBond = function ( ... ) end
    self.noMesHeight =  200
    -- pageViewType  --1 自己阵容 2 别人阵容 -- 3 默认一页自己英雄 4 默认一页 英雄碎片
end


-- 初始化背景
function PartnerInfoView:ctor( mainType )
    self:initAllVariable()
    self.mainType = mainType
    LayerManager.hideAllLayout(PartnerInfoView:moduleName())
    if (mainType == 2) then
        self.mainLayout = g_fnLoadUI("ui/partner_information_2.json")

    else
        self.mainLayout = g_fnLoadUI("ui/partner_information.json")
    end
    local mainLayout = self.mainLayout

    for i=1,5 do
        local layBg = mainLayout["img_partner_information_bg" .. i]
        layBg:setScale(g_fScaleX)
    end
    
    local imgBg = mainLayout.img_bg
    local imgBarBg= mainLayout.img_partner_information_bottom_bg
    imgBarBg:setScale(g_fScaleX)

    mainLayout.img_name_bg:setScaleX(g_fScaleX)
    local lsvParterInfo = mainLayout.LSV_PARTNER_INFORMATION
    local lsvParterInfoSize = lsvParterInfo:getContentSize()

    -- local lsvParterInfoPos = lsvParterInfo:getPositionPercent()
    -- lsvParterInfo:setPositionPercent(ccp(lsvParterInfoPos.x - self.deviationX * ( 1 - 10),lsvParterInfoPos.y + self.deviationY * ( 1 -1)))
    ----------------------------------------------------------------------------------------------------
    LayerManager.setPaomadeng(mainLayout)
    UIHelper.registExitAndEnterCall(mainLayout, function ( ... )
         -- 重新设置跑马灯
        LayerManager.resetPaomadeng()
        -- GlobalNotify.removeObserver(SpecialConst.MSG_LOAD_SPECIAL_SUCCESS, self:moduleName())
        -- GlobalNotify.removeObserver(SpecialConst.MSG_SPECIAL_SELECT_CLOSED, self:moduleName())
        LayerManager.remuseAllLayoutVisible(self:moduleName())
        if(self.effectId)then -- zhangqi, 2016-01-14, 未通过监修紧急注释
            AudioHelper.stopEffect(self.effectId)
            self.effectId = nil
        end
        UIHelper.removeArmatureFileCache()

    end,function ( ... )
        -- GlobalNotify.addObserver(SpecialConst.MSG_LOAD_SPECIAL_SUCCESS, fnLoadSpecialOK, false, self:moduleName())
        -- GlobalNotify.addObserver(SpecialConst.MSG_SPECIAL_SELECT_CLOSED, fnSpecialSelectClose, false, self:moduleName())
    end)

    -- 返回按键
    local btnBack = mainLayout.BTN_PARTNER_INFORMATION1
    local m_i18n = gi18n
    UIHelper.titleShadow(btnBack,m_i18n[1019])
    btnBack:addTouchEventListener(function (  sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playBackEffect()
            LayerManager.removeLayout(mainLayout)
            MReleaseUtil.releaseObj(self:moduleName(),"cellClone")
        end
    end)

end

function PartnerInfoView:palyHeroSound( ... )
    local heroDB = self.heroInfo.heroDB
    logger:debug("palyHeroSound")
    -- 先停止
    AudioHelper.stopAllEffects()
    self.effectId = nil
    -- 再播放
    if (heroDB.debut_word) then
        self.effectId = AudioHelper.playEffect("audio/heroeffect/" .. heroDB.debut_word ..".mp3")
    end
end


function PartnerInfoView:create( heroDataModle )

    self.heroDataModle = heroDataModle
    self.heroInfo = heroDataModle:getModleData()
    self:palyHeroSound()
    self:initHeader()
    -- listView部分
    self:initCenter( 1 )
    -- 地栏按钮
    self:initFooter()
    -- 重新拉取羁绊信息
    self:reGetJibanMes()
    self:guildLine()

    return self.mainLayout

end


--[[desc:直接跳转到羁绊的部分显示，create完后调用即可
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function PartnerInfoView:fnShowInitCell(heroDataModle,showTag)
    if (showTag == 2) then
        self.showJuexing = true
    end    
    self.heroDataModle = heroDataModle
    self.heroInfo = heroDataModle:getModleData()
    self:palyHeroSound()
    self:initHeader()
    -- listView部分
    self:initCenter(2)
    -- 地栏按钮
    self:initFooter()
    -- 重新拉取羁绊信息
    self:reGetJibanMes()

    return self.mainLayout
end


function PartnerInfoView:guildLine( ... )
    local heroInfo = self.heroInfo
    require "script/module/guide/GuideModel"
    local lsvParterInfo = self.mainLayout.LSV_PARTNER_INFORMATION
    local BaseLay = lsvParterInfo:getItem(0)
    -- local btn_strengthen = self.mainLayout.BTN_STRENGTHEN
    local btn_strengthen = BaseLay.BTN_STRENGTHEN

    -- local scene = CCDirector:sharedDirector():getRunningScene()
    performWithDelay(self.mainLayout, function(...)
        local pos = btn_strengthen:getWorldPosition()
        self:addFormationGuide(pos)
        self:addFiveGiftGuide(pos)
        self:addCopy2BoxGuide(pos)
    end, 0.05)

    -- local btn_transfer = self.mainLayout.BTN_TRANSFER
    local btn_transfer = BaseLay.BTN_TRANSFER
    performWithDelay(self.mainLayout, function(...)
        local pos = btn_transfer:getWorldPosition()
        self:addCopyBoxGuide(pos)
    end, 0.05)
   
end

function PartnerInfoView:reGetJibanMes( ... )
    local heroInfo = self.heroInfo
    local pageViewType = heroInfo.pageViewType 
    local layoutStyle = self.heroInfo.layoutStyle

    local hid =  heroInfo.hid
    -- 阵容上的不用重新拉数据了 layoutStyle =5
    if (pageViewType == 1 or pageViewType == 3) then
        -- 拉取伙伴的羁绊数据
        local htid = heroInfo.htid
        local modelId = HeroModel.getHeroModelId(htid)

        -- 缓存没有当前伙伴的羁绊信息时，拉取
        if (not BondData.isBondCache(modelId)) then
            if (hid) then
                logger:debug("清除战斗力")
                HeroFightUtil.clearForceCacheWithHid(tonumber(hid))
            end
            logger:debug("拉取羁绊数据")
            BondRequst.getArrUnionByHero(modelId, function ( ... )
                local refreshBase = self.refreshBase
                if (refreshBase) then
                    refreshBase()
                end
                local refreshBond = self.refreshBond
                if (refreshBond) then
                    refreshBond()
                end
            end)
        end
    end

end

function PartnerInfoView:getReAddFn( ... )
    return self.fnReAddLayer
end

function PartnerInfoView:getfnAffterLoadLayer( ... )
    return self.fnAffterLoadLayer
end

function PartnerInfoView:resetChoseReCallFn( ... )
    self.fnReAddLayer = nil
    self.fnAffterLoadLayer = nil
end


function PartnerInfoView:initHeader( ... )
    self:initModelPageView()  -- 模型pageView
    self:initPageViewStatus() -- pageView 状态
    self:initHeaderMes()         -- 资质信息 
end


-- 重置页面信息
function PartnerInfoView:resetAllMes( ... )
    if (self.effectId) then
        AudioHelper.stopEffect(self.effectId)
        self.effectId = nil
    end

    self:initHeaderMes()
    self:initPageViewStatus() -- pageView 状态
    -- listView部分
    local mainType = self.mainType
    self:initCenter(self.mainType)
end


function PartnerInfoView:initModelPageView( ... )
    local mainLayout = self.mainLayout
    local heroDataModle = self.heroDataModle

    local curModuleName = LayerManager.curModuleName()
    local tbheroModelPageView = heroDataModle:getheroModelPageView()

    local btnArrowLeft = self.mainLayout.BTN_ARROW_L
    local btnArrowRight = self.mainLayout.BTN_ARROW_R

    local pgvHeroModel = self.mainLayout.PGV_HERO_MODEL

    local pageLayClone = pgvHeroModel:getPage(0)
    -- local pageLayClone = layPage:clone()

    pgvHeroModel:removeAllPages()
    local heroIndex,allNum = heroDataModle:getHeroIndex()

    for i,v in ipairs(tbheroModelPageView) do
        local layPageItem = pageLayClone:clone()
        pgvHeroModel:addWidgetToPage(layPageItem, i, true)
        local function loadPageCell( ... )
            local heroDB = v
            local imgHero = layPageItem.LAY_CARD_MODEL
            local heroSprite  = CCSprite:create("images/base/hero/body_img/" .. heroDB.halflen_img_id )
            local heroQuality 
            if (heroDB.heroQuality) then
                heroQuality = heroDB.heroQuality
            else
                heroQuality = heroDB.quality
            end
            if (tonumber(heroQuality) <  13 ) then
                heroSprite:setScale(self.smalllerScale)
            else
                heroSprite:setScale(self.biggerScale)
            end

            heroSprite:setPosition(ccp(imgHero:getContentSize().width/2,imgHero:getContentSize().height/2  ) )  
            heroSprite:setAnchorPoint(0.5,0.23)

            imgHero:addNode(heroSprite)
            UIHelper.fnPlayHuxiAni(heroSprite)
        end
        if (i==tonumber(heroIndex)) then
            loadPageCell()
        else
            performWithDelayFrame(self.mainLayout,loadPageCell,3)
        end
    end

     
    pgvHeroModel:initToPage(heroIndex - 1)
    self.curPage = heroIndex - 1
        -- 翻页功能
    pgvHeroModel:addEventListenerPageView(function ( sender, eventType )
    if (eventType == PAGEVIEW_EVENT_TURNING) then
        local curPage = pgvHeroModel:getCurPageIndex()
            if (self.curPage ~= curPage) then
                -- btnArrowLeft:setTouchEnabled(true)
                -- btnArrowRight:setTouchEnabled(true)
                self.resetMES = true
                heroDataModle:initHeroInfo(curPage + 1)
                self.heroInfo = heroDataModle:getModleData()
                --  重置页面信息
                self:resetAllMes()
            end
            self.curPage = curPage
        end
    end)
end

-- 初始化翻页功能
function PartnerInfoView:initPageViewStatus( ... )
    local heroDataModle = self.heroDataModle 
    local heroIndex,allNum = heroDataModle:getHeroIndex() 

    -- 模型图片
    local mainLayout = self.mainLayout

    local btnArrowLeft = mainLayout.BTN_ARROW_L
    local btnArrowRight = mainLayout.BTN_ARROW_R

    local pgvHeroModel = self.mainLayout.PGV_HERO_MODEL

    if (heroIndex == 1) then
        btnArrowLeft:setEnabled(false)
        btnArrowRight:setEnabled(true)
    end
    if (heroIndex ==  allNum) then
        btnArrowLeft:setEnabled(true)
        btnArrowRight:setEnabled(false)
    end
    if (heroIndex == 1 and heroIndex ==  allNum ) then
        btnArrowLeft:setEnabled(false)
        btnArrowRight:setEnabled(false)
    end
    if (heroIndex > 1 and heroIndex <  allNum ) then
        btnArrowLeft:setEnabled(true)
        btnArrowRight:setEnabled(true)
    end


    btnArrowLeft:addTouchEventListener(function ( sender, eventType  )
            if (eventType == TOUCH_EVENT_ENDED) then
                pgvHeroModel:scrollToPage(heroIndex - 1 - 1)
            end
        end) 

    btnArrowRight:addTouchEventListener(function ( sender, eventType  )
        if (eventType == TOUCH_EVENT_ENDED) then
            pgvHeroModel:scrollToPage(heroIndex )
        end
    end) 
end

function PartnerInfoView:initHeaderMes( ... )
    local heroInfo = self.heroInfo
    local heroDB = heroInfo.heroDB
    --- 资质背景图片
    local mainLayout = self.mainLayout
    local pQuailty = tonumber(heroDB.star_lv) or 3
    local pColor = g_QulityColor2[pQuailty]
    local imgStar = mainLayout.IMG_STAR
    local pImgFile = string.format("images/common/hero_star/star_%d.png", pQuailty)
    imgStar:loadTexture(pImgFile)
    -- 资质文字
    local tfdHeroPotentialTxt = imgStar.tfd_hero_potential_txt
    local m_i18n = gi18n
    tfdHeroPotentialTxt:setText(m_i18n[1003])
    tfdHeroPotentialTxt:setColor(g_QulityColor3[pQuailty])
    -- 资质数字
    local tfdHeroPotential = imgStar.TFD_HERO_POTENTIAL
    tfdHeroPotential:setText(heroDB.heroQuality)
    tfdHeroPotential:setColor(g_QulityColor3[pQuailty])

    -- 掉落按钮
    local btnBack = mainLayout.BTN_DROP
    local layoutStyle = self.heroInfo.layoutStyle
    if (layoutStyle == 1 or layoutStyle == 3) then
        btnBack:setEnabled(true)
        btnBack:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.onBtnGet(self.heroInfo)
            end
        end )
        local BtnChange = UIHelper.chagneGuildTOOk(btnBack,true)  -- 检查是否应该改为确定
        if (BtnChange) then
            btnBack:setEnabled(false)
        end
    else
        btnBack:setEnabled(false)
    end
end


function PartnerInfoView:initCenter( mainLayoutType  )

    local heroDB = self.heroInfo.heroDB
    -- listView  banner
    -- 名字
    local mainLayout = self.mainLayout
    local imgNameBg = mainLayout.img_name_bg
    local tfdHeroName = imgNameBg.TFD_HREO_NAME
    local pColor = g_QulityColor2[tonumber(heroDB.star_lv)]
    tfdHeroName:setText(heroDB.name)
    tfdHeroName:setColor(pColor)
    UIHelper.labelNewStroke(tfdHeroName, self.color_stroke)
    UIHelper.labelShadow(tfdHeroName)

    -- 进阶等级
    local tfdHeroAdvancedNum = imgNameBg.TFD_HERO_ADVANCED_NUM
    local transLevel = self.heroInfo.transLevel
    if (transLevel ==nil or tonumber(transLevel) <= 0) then
        tfdHeroAdvancedNum:setVisible(false)
    else
        tfdHeroAdvancedNum:setVisible(true)
        tfdHeroAdvancedNum:setText("(+"..transLevel ..")")
        tfdHeroAdvancedNum:setColor(pColor)
        UIHelper.labelNewStroke(tfdHeroAdvancedNum, self.color_stroke)
        UIHelper.labelShadow(tfdHeroAdvancedNum)
    end
    -- listview部分
    local tbLayH  = self:initVisionLayCell(mainLayoutType)

    performWithDelayFrame(mainLayout,function ( ... )
        self:initNOVisonLayCell(mainLayoutType)
    end,0.1)
end


function PartnerInfoView:retainVisonCell(mainLayoutType )
    local mainLayout = self.mainLayout
    local lsvParterInfo = mainLayout.LSV_PARTNER_INFORMATION

    local cellRetaind = false
    local reatainGroup = MReleaseUtil.getRetainNOReleaseObjGroup(self:moduleName(),"cellClone")
    local reatainCellNums = 0
    for k,v in pairs(reatainGroup or {}) do
        reatainCellNums = reatainCellNums + 1
    end
    if (reatainCellNums > 0) then
        cellRetaind = true
    end

    if (mainLayoutType == 2 and not cellRetaind) then
        local layHeroSkillClone = lsvParterInfo.LAY_HERO_SKILL
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layHeroSkillClone,"layHeroSkill")
        -- 羁绊lay
        local layheroBondClone = mainLayout.LAY_HERO_BOND
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layheroBondClone,"layheroBond")
    elseif (mainLayoutType == 1 and not cellRetaind) then
         --基础信息lay
        local layBaseInfoClone = lsvParterInfo.lay_partner_card_information
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layBaseInfoClone,"layBaseInfo")
        -- 技能 lay
        local layHeroSkillClone = lsvParterInfo.LAY_HERO_SKILL
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layHeroSkillClone,"layHeroSkill")
    else
        return
    end

end


-- 初始化主UI里面的可见的laycell
function PartnerInfoView:initVisionLayCell( mainLayoutType )
    local tbLayH = {}
    local mainLayout = self.mainLayout

    local lsvParterInfo = mainLayout.LSV_PARTNER_INFORMATION
    self:retainVisonCell(mainLayoutType)
    lsvParterInfo:removeAllItems()

    if (mainLayoutType == 2) then
         -- 技能 lay
        if (not self.layHeroSkillClone) then
           self.layHeroSkillClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layHeroSkill")
        end

        -- 羁绊lay
        if (not self.layheroBondClone) then
            self.layheroBondClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layheroBond")
        end


        local layHeroSkill = self.layHeroSkillClone:clone()

        local HeroSkillH = self:fnGetSkillInfo(lsvParterInfo,layHeroSkill)

        table.insert(tbLayH,HeroSkillH)

        local layheroBond = self.layheroBondClone:clone()
        local HeroBondH ,refreshBond= self:fnGetheroBondInfo(lsvParterInfo,layheroBond)

        table.insert(tbLayH,HeroBondH)

        self.refreshBond = refreshBond

        lsvParterInfo:visit()
        lsvParterInfo:setContentOffset(CCPointMake(0,  0 ))

    else
        --基础信息lay
        if (not self.layBaseInfoClone) then
           self.layBaseInfoClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layBaseInfo")
        end
        local layBaseInfo = self.layBaseInfoClone:clone()
        -- 技能 lay
        if (not self.layHeroSkillClone) then
           self.layHeroSkillClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layHeroSkill")
        end
        local layHeroSkill = self.layHeroSkillClone:clone()

        local BaseInfoH,refreshBase = self:fnGetBaseInfo(lsvParterInfo,layBaseInfo)
        table.insert(tbLayH,BaseInfoH)

        self.refreshBase = refreshBase

        local HeroSkillH = self:fnGetSkillInfo(lsvParterInfo,layHeroSkill)
        table.insert(tbLayH,HeroSkillH)

        local lisvSizeH = lsvParterInfo:getSize().height
        local lisvContainerH = lsvParterInfo:getInnerContainerSize().height

        if (lisvSizeH == lisvContainerH) then
            lsvParterInfo:setContentOffset(CCPointMake( 0,  -100 ))
        else
            lsvParterInfo:setContentOffset(CCPointMake( 0,  lisvSizeH - lisvContainerH ))
        end
    end

    return tbLayH
end


function PartnerInfoView:retainNoVisonCell( mainLayoutType )

    local cellRetaind = false
    local reatainGroup = MReleaseUtil.getRetainNOReleaseObjGroup(self:moduleName(),"cellClone")
    local reatainCellNums = 0
    for k,v in pairs(reatainGroup) do
        reatainCellNums = reatainCellNums + 1
    end
    if (reatainCellNums > 2) then
        cellRetaind = true
    end

    local mainListLayout
    if (mainLayoutType == 1 and not cellRetaind) then
        mainListLayout = g_fnLoadUI("ui/partner_list.json")

    elseif (mainLayoutType == 2 and not cellRetaind) then
        mainListLayout = g_fnLoadUI("ui/partner_list_2.json")
    else
        return
    end


    if (mainLayoutType == 2 ) then
        --基础信息lay
        local layBaseInfoClone = mainListLayout.lay_partner_card_information
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layBaseInfoClone,"layBaseInfo")
    end

    --宝物信息lay
    if (not self.layTreaClone) then
        local layTreaClone = mainListLayout.LAY_TREASURE
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layTreaClone,"layTrea")
    end

    if (mainLayoutType == 1) then
        -- 羁绊lay
        local layheroBondClone = mainListLayout.LAY_HERO_BOND
        MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layheroBondClone,"layheroBond")
    end

    -- 潜能lay
    local layHeroInBornClone = mainListLayout.LAY_HERO_INBORN
    MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layHeroInBornClone,"layHeroInBorn")

    -- 觉醒lay
    local layHeroAwake = mainListLayout.LAY_HERO_AWAKE
    MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layHeroAwake,"layHero")

    -- 恶魔果实lay
    local layDemonFruitClone = mainListLayout.LAY_DEMON_FRUIT
    MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layDemonFruitClone,"layDemonFruit")

    -- 简介 lay
    local layHeroProfileClone = mainListLayout.LAY_HERO_PROFILE
    MReleaseUtil.insertRetainNOReleaseObj(self:moduleName(),"cellClone",layHeroProfileClone,"layHeroProfile")
end


function PartnerInfoView:initNOVisonLayCell( mainLayoutType )
    local mainLayout = self.mainLayout
    local lsvParterInfo = mainLayout.LSV_PARTNER_INFORMATION

    self:retainNoVisonCell(mainLayoutType)

    if (mainLayoutType == 2 and not self.layBaseInfoClone) then
        --基础信息lay
        self.layBaseInfoClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layBaseInfo")
    end

    --宝物信息lay
    if (not self.layTreaClone) then
        self.layTreaClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layTrea")
    end

    if (mainLayoutType == 1) then
        -- 羁绊lay
        if (not self.layheroBondClone) then
            self.layheroBondClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layheroBond")
        end
    end

    -- 潜能lay
    if (not self.layHeroInBornClone) then
        self.layHeroInBornClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layHeroInBorn")
    end

    -- 觉醒lay
    if (not self.layHeroAwake) then
        self.layHeroAwake = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layHero")
    end

    -- 恶魔果实lay
    if (not self.layDemonFruitClone) then
       self.layDemonFruitClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layDemonFruit")
    end

    -- 简介 lay
    if (not self.layHeroProfileClone)  then
        self.layHeroProfileClone = MReleaseUtil.getRetainNOReleaseObj(self:moduleName(),"cellClone","layHeroProfile")
    end

    --------------------------------------------------------
    --------------------------------------------------------
    local tbPushFn = {}

    if (mainLayoutType == 1) then
        local function pushHeroBond( index )
            local layheroBond = self.layheroBondClone:clone()
            local HeroBondH ,refreshBond= self:fnGetheroBondInfo(lsvParterInfo,layheroBond)
            self.refreshBond = refreshBond
            return true
        end
        table.insert( tbPushFn,pushHeroBond)
    end

    local function pushTreaInfo( index )
        local layTrea = self.layTreaClone:clone()
        local TreaH = self:fnGetTreaInfo(lsvParterInfo,layTrea)
        return true
    end 
    table.insert( tbPushFn,pushTreaInfo)
    
    local function pushHeroInBorn( index )
        local layHeroInBorn = self.layHeroInBornClone:clone()
        local HeroInBornH = self:fnGetHeroInBorn(lsvParterInfo,layHeroInBorn)
        return true
    end
    table.insert( tbPushFn,pushHeroInBorn)

    local function pushHeroAwak( index )
        local layHeroAwake = self.layHeroAwake:clone()
        local HeroAwakeH,fnGetwakeBtnPos = self:fnGetHeroAwake(lsvParterInfo,layHeroAwake)
        self.fnGetwakeBtnPos = fnGetwakeBtnPos
        return true
    end 
    table.insert( tbPushFn,pushHeroAwak)

    function pushDemonFruit( index )
        local layDemonFruit = self.layDemonFruitClone:clone()
        local DemonFruitH = self:fnGetDemonFruit(lsvParterInfo,layDemonFruit)
        return true
    end
    table.insert( tbPushFn,pushDemonFruit)

    local function pushHeroProfile( index )
        local layHeroProfile = self.layHeroProfileClone:clone()
        local HeroProfileH = self:fnGetHeroProfile(lsvParterInfo,layHeroProfile)
        return true
    end 
    table.insert( tbPushFn,pushHeroProfile)

    if (mainLayoutType == 2) then
        local function pushBaseInfo(  )
            local layBaseInfo = self.layBaseInfoClone:clone()
            local BaseInfoH,refreshBase = self:fnGetBaseInfo(lsvParterInfo,layBaseInfo,0)
            self.refreshBase = refreshBase

            if (mainLayoutType == 2) then
                local offset = 0
                local getItemsMargin = lsvParterInfo:getItemsMargin()
                local allItemNums = lsvParterInfo:getItems()

                local initCellIndex = 4
                if (self.showJuexing) then
                    initCellIndex = 7
                end

                for i = initCellIndex ,allItemNums:count()  do
                    local item = allItemNums:objectAtIndex(i - 1)
                    local itemH = item:getSize().height
                    offset = offset + itemH + getItemsMargin
                end
                
                lsvParterInfo:visit()
                lsvParterInfo:setJumpOffset(CCPointMake(0,    -offset ))
            end
        end 
        table.insert( tbPushFn,pushBaseInfo)

    end

    local function delayPushlayCell( index )
        local pushFn = tbPushFn[index]
        if (pushFn and pushFn()) then
            performWithDelayFrame(self.mainLayout,function ( ... )
                local pushFn = tbPushFn[index + 1]
                if (pushFn and pushFn()) then
                    delayPushlayCell(index + 2)
                else
                    if (self.showJuexing) then
                        local fnGetwakeBtnPos = self.fnGetwakeBtnPos
                        if (fnGetwakeBtnPos) then
                            local awakebtnPos = fnGetwakeBtnPos()
                            self:addAwakeGuide(awakebtnPos)
                        end
                    end
                    return
                end
            end,1)
        else
            return
        end
    end
    delayPushlayCell(1)
end

-- 适配Cell
function PartnerInfoView:resetCellSize( layCell )
    local layCellSize = layCell:getSize()
    layCell:setSize(CCSizeMake( layCellSize.width * g_fScaleX,layCellSize.height * g_fScaleX))
end


function PartnerInfoView:fnGetBaseInfo( lsvParterInfo,layBaseInfo,insertIndex )
    local m_i18n = gi18n
    local layH = layBaseInfo:getContentSize().height
    local heroInfo = self.heroInfo
    --
    local heroDB =  heroInfo.heroDB
    local pageViewType = heroInfo.pageViewType
    local layoutStyle = heroInfo.layoutStyle 
    --
    local slevel = lua_string_split(heroInfo.strengthenLevel, "/")[1]

    local args = { htid = heroInfo.htid , hid = heroInfo.hid , db_hero = heroInfo.heroDB, evolve_level =heroInfo.transLevel or 0,level = tonumber(slevel) or 0}

    local baseValues = {}
    if (pageViewType == 1 or pageViewType == 3) then  -- 自己阵容 自己英雄
        if (heroInfo.hid and tonumber(heroInfo.hid) ~= 0) then
            if (heroInfo.readOnly) then
                baseValues  = HeroFightUtil.getNewAllForceValues(args,nil,nil,nil,true) 
            else
                baseValues  = HeroFightUtil.getAllForceValuesByHid(heroInfo.hid)
            end
        else
            baseValues  = HeroFightUtil.getNewAllForceValues(args,nil,nil,nil,true) 
        end 
    elseif (pageViewType == 2) then  -- 别人阵容 
        local tempBaseValues= heroInfo.heroValue
        baseValues.life = tempBaseValues.max_hp
        baseValues.physicalAttack = tempBaseValues.physical_atk
        baseValues.magicAttack = tempBaseValues.magical_atk
        baseValues.physicalDefend = tempBaseValues.physical_def
        baseValues.magicDefend = tempBaseValues.magical_def
        baseValues.speed = tempBaseValues.speed
    else   -- 英雄碎片
        baseValues  = HeroFightUtil.getNewAllForceValues(args,nil,nil,nil,true) 
    end
    --titile
    local tfdBaseAttribut = layBaseInfo.tfd_base_attribute
    tfdBaseAttribut:setText(m_i18n[1113])
    PartnerInfoCtrl.fnlabelNewStroke(tfdBaseAttribut)

    -- 等级
    local strengthenLevel = heroInfo.strengthenLevel
    local tfdLevelTxt = layBaseInfo.tfd_hero_level_txt
    tfdLevelTxt:setText(m_i18n[1067])
    local tfdHeroLevel = layBaseInfo.TFD_HERO_LEVEL
    tfdHeroLevel:setText(strengthenLevel)
    -- 生命
    local tfdHeroHp = layBaseInfo.tfd_hero_hp
    tfdHeroHp:setText(m_i18n[1047])
    local tfdHeroHpNum = layBaseInfo.TFD_HERO_HP_NUM
    tfdHeroHpNum:setText(baseValues.life)

    -- 物理攻击
    local tfdHeroPhyAtt = layBaseInfo.tfd_hero_phy_attack
    tfdHeroPhyAtt:setText(m_i18n[1048])
    local tfdHeroPhyAttackNum = layBaseInfo.TFD_HERO_PHY_ATTACK_NUM
    tfdHeroPhyAttackNum:setText(baseValues.physicalAttack)

    -- 魔法攻击
    local tfdHeroMagAtt = layBaseInfo.tfd_hero_magic_attack
    tfdHeroMagAtt:setText(m_i18n[1049])
    local tfdHeroMagicAttackNum = layBaseInfo.TFD_HERO_MAGIC_ATTACK_NUM
    tfdHeroMagicAttackNum:setText(baseValues.magicAttack)

    -- 物理防御
    local tfdHeroPhyDenf = layBaseInfo.tfd_hero_phy_denfend
    tfdHeroPhyDenf:setText(m_i18n[1050])
    local tfdHeroPhyDefendNum = layBaseInfo.TFD_HERO_PHY_DEFEND_NUM
    tfdHeroPhyDefendNum:setText(baseValues.physicalDefend)

    -- 魔法防御
    local tfdHeroMagDenf = layBaseInfo.tfd_hero_magic_denfend
    tfdHeroMagDenf:setText(m_i18n[1051])
    local tfdHeroMagicDefendNum = layBaseInfo.TFD_HERO_MAGIC_DEFEND_NUM  
    tfdHeroMagicDefendNum:setText(baseValues.magicDefend)

    -- 速度
    local tfdHeroVelocity = layBaseInfo.tfd_hero_velocity
    tfdHeroVelocity:setText(m_i18n[5309])         
    local tfdHeroSpeedNum      =  layBaseInfo.TFD_HERO_VELOCITY_NUM
    tfdHeroSpeedNum:setText(baseValues.speed)

    -- 突破
    local btnBreak = layBaseInfo.BTN_BREAKTHROUGH
    UIHelper.titleShadow(btnBreak,m_i18n[1110])
    if (heroDB.break_id and (layoutStyle == 1 or layoutStyle == 2  or layoutStyle == 5)) then
        btnBreak:addTouchEventListener(
            function ( sender,eventType )
                if (eventType ==  TOUCH_EVENT_ENDED) then
                    AudioHelper.playCommonEffect()
                    PartnerInfoCtrl.OnBreak(self.heroInfo)
                end
            end)
    else
        btnBreak:setEnabled(false)

    end

    -- 进阶
    local btnTrans = layBaseInfo.BTN_TRANSFER
    UIHelper.titleShadow(btnTrans,m_i18n[1005])
    if (layoutStyle == 1 or layoutStyle == 2  or layoutStyle == 5) then
        btnTrans:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.OnTrans(self.heroInfo)
            end
        end)
        local IMG_RED = btnTrans.IMG_RED
        if (heroInfo.hid and tonumber(heroInfo.hid) ~= 0 and HeroPublicUtil.isOnFmtByHid(heroInfo.hid)) then
            if (PartnerTransUtil.checkPartnerCanTransByHid(heroInfo.hid)) then
                IMG_RED:removeAllNodes()
                IMG_RED:addNode(UIHelper.createRedTipAnimination())
            else
                IMG_RED:removeAllNodes()
            end
        end
    else
        btnTrans:setEnabled(false)
    end

    -- 强化
    local btnStrength = layBaseInfo.BTN_STRENGTHEN
    UIHelper.titleShadow(btnStrength,m_i18n[1007])
    if (layoutStyle == 1 or layoutStyle == 2  or layoutStyle == 5) then
        btnStrength:addTouchEventListener( function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED ) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.OnStrength(self.heroInfo)
            end
        end)
    else
        btnStrength:setEnabled(false)
    end
    if (not insertIndex ) then
        lsvParterInfo:pushBackCustomItem(layBaseInfo)
    else
        lsvParterInfo:insertCustomItem(layBaseInfo,insertIndex)
    end

    self:resetCellSize(layBaseInfo)

    return layH,function ( ... )
        if (heroInfo.hid and tonumber(heroInfo.hid) ~= 0) then
            if (heroInfo.readOnly) then
                baseValues  = HeroFightUtil.getNewAllForceValues(args,nil,nil,nil,true) 
            else
                baseValues  = HeroFightUtil.getAllForceValuesByHid(heroInfo.hid)
            end
        else
            baseValues  = HeroFightUtil.getNewAllForceValues(args,nil,nil,nil,true) 
        end 

        if (not layBaseInfo) then
            return
        end
        
        -- 生命
        local tfdHeroHpNum = layBaseInfo.TFD_HERO_HP_NUM
        -- 避免翻页太快，或者退出界面 延时刷新 找不到控件  -- 线上报错
        if (not tfdHeroHpNum) then
            return
        end
        tfdHeroHpNum:setText(baseValues.life)

        -- 物理攻击
        local tfdHeroPhyAttackNum = layBaseInfo.TFD_HERO_PHY_ATTACK_NUM
        tfdHeroPhyAttackNum:setText(baseValues.physicalAttack)

        -- 魔法攻击
        local tfdHeroMagicAttackNum = layBaseInfo.TFD_HERO_MAGIC_ATTACK_NUM
        tfdHeroMagicAttackNum:setText(baseValues.magicAttack)

        -- 物理防御
        local tfdHeroPhyDefendNum = layBaseInfo.TFD_HERO_PHY_DEFEND_NUM
        tfdHeroPhyDefendNum:setText(baseValues.physicalDefend)

        -- 魔法防御
        local tfdHeroMagicDefendNum = layBaseInfo.TFD_HERO_MAGIC_DEFEND_NUM  
        tfdHeroMagicDefendNum:setText(baseValues.magicDefend)

        -- 速度
        local tfdHeroSpeedNum   =  layBaseInfo.TFD_HERO_VELOCITY_NUM
        tfdHeroSpeedNum:setText(baseValues.speed)

    end
end

-- UIlable自适应高度
-- return tfdBeforeSizeWidth 之前的宽度 tfdBeforeSizeHeight 高度 affterSizeHeight变化后的高度
function PartnerInfoView:labelScaleChangedWithStr( UIlableWidet,textInfo )
    local tfdBeforeSize = UIlableWidet:getContentSize()
    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

    -- UIlableWidet:ignoreContentAdaptWithSize(false)
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
    UIlableWidet:setText(textInfo)
    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))

    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

end



function PartnerInfoView:fnGetSkillInfo( lsvParterInfo,layHeroSkill )
    local m_i18n = gi18n
    local layHeroSkillSize = layHeroSkill:getContentSize()
    local layHeroSkillSizeHeight= layHeroSkillSize.height
    local heroInfo = self.heroInfo
    local heroDB = heroInfo.heroDB

    local strengthenLevel = lua_string_split(heroInfo.strengthenLevel, "/")[1]
    local evolveLevel =heroInfo.transLevel or 0
    local strengthenLevel = tonumber(strengthenLevel) or 0

    --titile
    require "db/skill"
    local tfdSkillTitle = layHeroSkill.tfd_hero_skill_title
    PartnerInfoCtrl.fnlabelNewStroke(tfdSkillTitle)
    tfdSkillTitle:setText(m_i18n[1114])
    local oneLineCanHold = 60

    -- 普通技能
    local nNddH = 0
    if (heroDB.normal_attack) then
        heroHasSkill = true
        local skilNorDB = skill.getDataById(heroDB.normal_attack)

        local imgBgNomralSkill = layHeroSkill.img_skill_normal
        imgBgNomralSkill:loadTexture("images/hero/skill/"..skilNorDB.skill_icon)

        local tfdNDes = layHeroSkill.TFD_N_DESC
        local tfdNDesSize = layHeroSkill:getContentSize()
        local tfdNDesSizeHeight = tfdNDesSize.height

        local tfdNDesBeforeSizeWidth, tfdNDesBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr(tfdNDes,skilNorDB.des)
        nNddH =  affterSizeHeight - tfdNDesBeforeSizeHeight
        -- layNomralSkill:setSize(CCSizeMake(layNomralSkillSize.width,tfdNDesSizeHeight + nNddH))
    end


    -- 怒气 
    local nAddH = 0
    if (heroDB.rage_skill_attack) then
        heroHasSkill = true
        local skilAngerDB = skill.getDataById(heroDB.rage_skill_attack)

        local imgBgAngerSkill = layHeroSkill.img_skill_anger
        imgBgAngerSkill:loadTexture("images/hero/skill/"..skilAngerDB.skill_icon)

        local tfdADes = layHeroSkill.TFD_A_DESC
        local tfdADesSize = tfdADes:getContentSize()
        local tfdADesSizeHeight = tfdADesSize.height

        local tfdADesBeforeSizeWidth, tfdADesBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr(tfdADes,skilAngerDB.des)
        nAddH =  affterSizeHeight - tfdADesBeforeSizeHeight
        -- layAngerSkill:setSize(CCSizeMake(layAngerSkillSize.width,tfdADesSizeHeight + nAddH))

    end

    local layHeroSkillSize =  CCSizeMake(layHeroSkillSize.width,layHeroSkillSizeHeight + nAddH + nNddH )
    layHeroSkill:setSize(layHeroSkillSize)
    lsvParterInfo:pushBackCustomItem(layHeroSkill)

    self:resetCellSize(layHeroSkill)

    return layH
end

function PartnerInfoView:fnGetTreaInfo(  lsvParterInfo,layTrea )
    local m_i18n = gi18n
    local m_i18nString = gi18nString

    local heroInfo = self.heroInfo
    local externHeroInfo = heroInfo.externHeroInfo

    local layTreaSize = layTrea:getContentSize()
    local hid = heroInfo.hid
    local htid = heroInfo.heroDB.id
    local pageViewType = heroInfo.pageViewType
    local layoutStyle = heroInfo.layoutStyle 

    local treasureIdFeild  = DB_Heroes.getDataById(htid).treaureId 

    -- title
    local tfdTreasureTitle = layTrea.tfd_treasure_title
    PartnerInfoCtrl.fnlabelNewStroke(tfdTreasureTitle)
    tfdTreasureTitle:setText(m_i18n[1115]) 
    -- 
    local laytreaDes =  layTrea.LAY_TREASURE_DESCRIBE
    local layNoTrea =  layTrea.lay_no_trea
    local layBtnTrea =  layTrea.lay_treasure_btn
    -- 先判断是否有专属宝物
    if (treasureIdFeild) then
        laytreaDes:setEnabled(true)
        layNoTrea:setEnabled(false)
    else
        laytreaDes:setEnabled(false)
        layBtnTrea:setEnabled(false)
        layNoTrea:setEnabled(true)
        layNoTrea.tfd_no_trea:setText(m_i18n[1173])  -- 没有专属宝物
        layTrea:setSize(CCSizeMake(layTreaSize.width,self.noMesHeight))
        lsvParterInfo:pushBackCustomItem(layTrea)
        self:resetCellSize(layTrea)
        return layH
    end
    -- 初始化宝物信息
    local addH = 0
    local treasureIdTb = lua_string_split(treasureIdFeild,"|")
    local treasureInfo = DB_Item_exclusive.getDataById(treasureIdTb[1])

    local treasureIconBg = layTrea.btn_treasure_bg
   
    
    local layTreaTxt = layTrea.LAY_TREASURE_TXT
    local labelColor,isHave ,heroInfoDetail,isActive
    local activeLimitLel = tonumber(treasureIdTb[3])

    if (pageViewType == 1 or pageViewType == 3) then
        require "script/module/partner/PartnerModle"
        labelColor,isHave ,heroInfoDetail,isActive= PartnerModle.getTreaDes(treasureIdTb[1],hid,activeLimitLel)
    elseif (pageViewType == 2) then
        labelColor,isHave ,heroInfoDetail,isActive= FormationUtil.isBattleExclusiveHave(hid,externHeroInfo,activeLimitLel)
    else
        labelColor = self.color_normal 
        isHave = false
        isActive = false
    end

    local icon = ItemUtil.createBtnByTemplateId(treasureIdTb[1],
                function ( sender, eventType )  -- 宝物图标按钮事件
                    if (eventType == TOUCH_EVENT_ENDED) then
                        AudioHelper.playInfoEffect()
                        local specTreaLel = 0
                        local specTreaItemId = nil
                        if (heroInfoDetail) then

                            local exclusiveDetail =  heroInfoDetail.equip and heroInfoDetail.equip.exclusive or heroInfoDetail.equipInfo.exclusive 
                            local exclusiveInfo = exclusiveDetail[SpecialConst.SPECIAL_POS]
                            if (exclusiveInfo and  exclusiveInfo.va_item_text) then
                                specTreaLel = exclusiveInfo.va_item_text.exclusiveEvolve and  tonumber(exclusiveInfo.va_item_text.exclusiveEvolve)
                                specTreaItemId =  exclusiveInfo.item_id and tonumber(exclusiveInfo.item_id)
                            end
                        end
                        SpecTreaInfoCtrl.create(treasureIdTb[1],specTreaLel,specTreaItemId)
                    end
                end) 
    treasureIconBg:addChild(icon)

    -- 宝物名字
    local  treasureName = layTrea.TFD_TREASURE_NAME
    local  strTRreasureName =  treasureInfo.name 
    local strTRreasureName2 = ""
    if not isActive  then 
    -- " (装备宝物"..treasureInfo.name .."可解锁)"
        local pppstr = m_i18nString(6952,treasureIdTb[3])
        strTRreasureName2 = pppstr
    end

    treasureName:setText(strTRreasureName .. strTRreasureName2)
    treasureName:setColor(labelColor)

    -- 宝物描述
    local awakeDes = FormationSpecialModel.getAwakeDes(tonumber(treasureIdTb[1]))

    local tfdTreaTxt = layTrea.TFD_TREASURE_TXT
    local tfdTxtWidth,tfdTxtHeight,tfdTxtAffterHeight  = self:labelScaleChangedWithStr(tfdTreaTxt,awakeDes)
    addH = tfdTxtAffterHeight - tfdTxtHeight
    --  按钮事件
    local btnGet = layTrea.BTN_GO_GET
    local tfdRefineLimitDes = layTrea.TFD_STRENGTHEN_DESC
    local btnLoad = layTrea.BTN_LOAD
    UIHelper.titleShadow(btnLoad,m_i18n[1601])
    local btnRefine = layTrea.BTN_SPECIAL_STRENGTHEN
    UIHelper.titleShadow(btnRefine,m_i18n[1005])

    require "script/module/specialTreasure/FormationSpecialModel"
    -- 判断按钮
    local specTreaStat,stateInfo

    local btnCallTouch = (layoutStyle == 1 or layoutStyle == 2 or layoutStyle == 5)
    if (btnCallTouch) then
        specTreaStat,stateInfo = FormationSpecialModel.getSpecTreaOnHeroStat(htid,hid)
    end

    btnGet:setEnabled(specTreaStat == 0 and btnCallTouch)
    btnRefine:setEnabled(specTreaStat == 1 and btnCallTouch)
    tfdRefineLimitDes:setText(specTreaStat == 1 and stateInfo .. m_i18n[6932] or " ")
    tfdRefineLimitDes:setEnabled(not (specTreaStat == 1 and btnCallTouch))
    btnLoad:setEnabled(specTreaStat == 2 and btnCallTouch)

    -- 专属宝物获取
    local function OnGetSpecTrea( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/specialTreasure/SpecTreaDrop"
            local specTreaDrop = SpecTreaDrop:new()
            local specTreaDropLayer = specTreaDrop:create(stateInfo,htid)
            LayerManager.addLayout(specTreaDropLayer)
        end 
    end
    btnGet:addTouchEventListener(OnGetSpecTrea)
    btnLoad:addTouchEventListener(function ( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/specialTreasure/AddSpecialTreaCtrl"
            MReleaseUtil.insertRetainObj(self:moduleName(),"mainLayout",self.mainLayout)
            LayerManager.removeLayout(2)
            -- 选择列表点击返回后回调
            self.fnReAddLayer = function ( ... )
                LayerManager.hideAllLayout(self:moduleName())
                LayerManager.addLayoutNoScale(self.mainLayout)
                LayerManager.setPaomadeng(self.mainLayout)
                MReleaseUtil.releaseObj(self:moduleName(),"mainLayout")

            end
            -- 选择列表点击装备后回调
            self.fnAffterLoadLayer = function ( ... )
                LayerManager.resetPaomadeng()
                MReleaseUtil.releaseObj(self:moduleName(),"mainLayout")
            end

            local layer = AddSpecialTreaCtrl.create(hid,self)
            LayerManager.addLayoutNoScale(layer, LayerManager.getRootLayout())
        end
    end)

    local function OnRefine( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            local curModuleName = LayerManager.curModuleName()
            require "script/module/specialTreasure/SpecTreaRefineCtrl"
            local exclusiveInfo =  heroInfoDetail.equip.exclusive
            local specTreaItemId = exclusiveInfo[SpecialConst.SPECIAL_POS].item_id

            local layer = SpecTreaRefineCtrl.create(specTreaItemId)
            LayerManager.addLayoutNoScale(layer)
        end
    end 

    local deleteH = 0
    if (not btnCallTouch) then
        local btnGetSzie = btnGet:getContentSize()
        local btnGetSizeHeight = btnGetSzie.height
        deleteH = deleteH + btnGetSizeHeight
    end
    -- local layTreaNewHeight = layTrea:getContentSize().height + addH
    layTrea:setSize(CCSizeMake(layTreaSize.width,layTreaSize.height + addH - deleteH))
    btnRefine:addTouchEventListener(OnRefine)
    lsvParterInfo:pushBackCustomItem(layTrea)

    self:resetCellSize(layTrea)

    return layH
end


function PartnerInfoView:fnGetheroBondInfo( lsvParterInfo,layHeroBond)

    local m_i18n = gi18n
    local layHeroBondSize = layHeroBond:getContentSize()
    local layHeroBondSizeHeight = layHeroBondSize.height

    local layBondText1 = layHeroBond["LAY_BOND_TXT" .. 1]
    local layBondTextSize = layBondText1:getContentSize()
    local layBondTextSizeHeight = layBondTextSize.height

    local heroInfo = self.heroInfo
    local heroDB = heroInfo.heroDB
    local pageViewType = heroInfo.pageViewType 
    local layoutStyle = heroInfo.layoutStyle 
    local btnCanTouch = layoutStyle == 1 or layoutStyle == 2 or layoutStyle == 5

    local hid = heroInfo.hid or 0
    local htid = heroInfo.heroDB.id
    local heroValue = heroInfo.heroValue

    --title
    local tfdBondTitle = layHeroBond.tfd_hero_bond_title
    PartnerInfoCtrl.fnlabelNewStroke(tfdBondTitle)
    tfdBondTitle:setText(m_i18n[1116])
    -- 先判断是否有羁绊
    local btnBond = layHeroBond.BTN_BOND
    UIHelper.titleShadow(btnBond,m_i18n[5303])

    local linkGroup = heroDB.link_group1    --羁绊组ID
    local layNoBond = layHeroBond.lay_no_bond
    if (not linkGroup) then
        layNoBond:setEnabled(true)
        btnBond:setEnabled(false)
        layNoBond.tfd_no_bond:setText(m_i18n[1174])  -- 没有羁绊
        local deleteH = 0
        for i=1 ,7 do
            local layBondText = layHeroBond["LAY_BOND_TXT" .. i]
            layBondText:removeFromParentAndCleanup(true)
            deleteH = deleteH + layBondTextSizeHeight
        end

        layHeroBond:setSize(CCSizeMake(layHeroBondSize.width,self.noMesHeight))
        lsvParterInfo:pushBackCustomItem(layHeroBond)
        self:resetCellSize(layHeroBond)

        return layH
    else
        layNoBond:setEnabled(false)
    end

    if (btnCanTouch) then
        btnBond:setEnabled(true)
    else
        btnBond:setEnabled(false)
    end

    -- 属性加成
    
    local addTextH = 0 --每行增加的高度

    local bondRedPoint = layHeroBond.IMG_RED
    bondRedPoint:addNode(UIHelper.createRedTipAnimination())
    local bBondOpen = false

    local linkGroupArr = lua_string_split(linkGroup, ",")
    require "db/DB_Union_profit"
    require "script/module/formation/FormationUtil"

    local tbunionlabel = {}
    local tblabelDown = {}
    local tblabAngerText = {}
    local tbnAngwidth = {}
    local tbunionProfitNum = {}

    --------------------------------------------------技能名称种类-----------------
    local tbLableNameInfo = {}
    for i,v in ipairs(linkGroupArr) do
        local heroUnionDB = DB_Union_profit.getDataById(v)
        local unionArributeIds = heroUnionDB.union_arribute_ids
        if (not tbLableNameInfo[unionArributeIds]) then
            tbLableNameInfo[unionArributeIds] = {}
            tbLableNameInfo[unionArributeIds].nums = 1
        else
            tbLableNameInfo[unionArributeIds].nums = tbLableNameInfo[unionArributeIds].nums + 1
        end
    end
    -----------------------------------------------------------------------------

    for i =#linkGroupArr, 1,-1  do
        -- 根据羁绊ID获取羁绊实例
        local v = linkGroupArr[i]
        -- local layHeroBondTxt = layHeroBondTxtClone:clone()
        local heroUnionDB = DB_Union_profit.getDataById(v)
   
        -- 检查某个羁绊是否开启
        local openUnion = false
        local colorTitle
        local colorDesc
        local pStrings = {}
        local pColors = {}
        if ( pageViewType == 1 or pageViewType == 3) then  -- 查看自己的伙伴
            openUnion , pStrings , pColors , tBond = FormationUtil.isUnionActive(v, hid, htid)
            if ((tBond.state == BondManager.BOND_REACHED) and (not bBondOpen)) then
                bBondOpen = true
            end
        else  -- 查看自己的伙伴碎片,和别人阵容
            local curHeroData  = {}
            curHeroData.htid = htid
            if (heroValue) then
                curHeroData.equipInfo = heroValue.equipInfo or {}
            else
                curHeroData.equipInfo =  {}
            end
            local heroBook = {}
            openUnion , pStrings , pColors = FormationUtil.isBattleUnionActive(v, hid, curHeroData, heroInfo.externHeroInfo)
        end

        -- 根据检查结果显示不同的颜色
        local colorTitle =  openUnion and self.color_get or self.color_normal
        local colorDesc = openUnion and self.color_get or self.color_normal
        -- 显示技能的名称index
        local unionArributeIds = heroUnionDB.union_arribute_ids
        local LableNameIndex = "Ⅰ"
        if (tonumber(tbLableNameInfo[unionArributeIds].nums) == 1 ) then
            LableNameIndex =  "Ⅰ" 
        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 2) then
            LableNameIndex = "Ⅱ" 
        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 3 ) then
            LableNameIndex = "Ⅲ"
        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 4) then
            LableNameIndex =  "Ⅳ" 
        end
        local LableName = heroUnionDB.union_arribute_type .. LableNameIndex
        tbLableNameInfo[unionArributeIds].nums =  tbLableNameInfo[unionArributeIds].nums - 1

        local layBondText = layHeroBond["LAY_BOND_TXT" .. i]

        local unionlabel = layBondText.TFD_BOND_1
        unionlabel:setText("【" .. LableName .. "】")
        unionlabel:setColor(colorTitle)
        table.insert(tbunionlabel,unionlabel)

   
        -- 羁绊增强数值table
        local unionProfitNums = string.split(heroUnionDB.union_arribute_nums , ",") 
        -- 品质table
        local unionProfitQualitys = string.split(heroUnionDB.quality , ",")
        local unionProfitQualityIndex
        for k,v in pairs(unionProfitQualitys) do
            if ( tonumber(v) == tonumber(heroDB.heroQuality) ) then 
                unionProfitQualityIndex = k
            end
        end

        local unionProfitNum = tonumber(string.split(unionProfitNums[unionProfitQualityIndex],"|")[1] or 0)/100
        table.insert(tbunionProfitNum,unionProfitNum)
        if heroUnionDB.union_arribute_desc == nil then
            heroUnionDB.union_arribute_desc = " "
        end

        if(not pStrings or #pStrings == 0 ) then
            -- 装备羁绊
            local unionInfoTb = lua_string_split(heroUnionDB.union_arribute_desc , ",")

            local unionlabel2 = layBondText.TFD_BOND_2
            unionlabel2:setText(unionInfoTb[1] .. unionProfitNum .. "%，")

            local unionlabel3 = layBondText.TFD_BOND_3
            unionlabel3:setText(unionInfoTb[2])

            unionlabel2:setColor(colorDesc)
            unionlabel3:setColor(colorDesc)

        else
            -- 伙伴羁绊
            local union_arribute_desc = lua_string_split(heroUnionDB.union_arribute_desc , ",")[1]
            local unionArributeDesc = string.gsub(union_arribute_desc,"+","+" .. tostring(unionProfitNum) .. "%%，")
            local unionlabel2 = layBondText.TFD_BOND_2
            unionlabel2:setText(unionArributeDesc .. m_i18n[2237])
            unionlabel2:setColor(colorDesc)

            local unionlabel3 = layBondText.TFD_BOND_3
            unionlabel3:setText("  ")
            local pCol = {}
            local pStr = pStrings[1] 
            if(pColors[1]) then
                local pC = self.color_get
                table.insert(pCol,{color = pC,font=g_sFontCuYuan,size=self.textSize})
            else
                local pC = colorDesc
                table.insert(pCol,{color = pC,font=g_sFontCuYuan,size=self.textSize})
            end

            for i=2 , #pStrings do
                pStr = UIHelper.concatString({pStr,"、"})
                table.insert(pCol,{color = colorDesc,font=g_sFontCuYuan,size=self.textSize})

                pStr = UIHelper.concatString({pStr,pStrings[i]})
                local pC = colorDesc
                if(pColors[i]) then
                    pC = self.color_get
                end
                table.insert(pCol,{color = pC,font=g_sFontCuYuan,size=self.textSize})
            end

            local richStr =  pStr

            local textInfo = {
            richStr, pCol
            }

            local richText = BTRichText.create(textInfo, nil)
            richText:setSize(CCSizeMake(1000,0))
            local unionlabel3Size = unionlabel3:getContentSize()
            richText:setPosition(ccp( -unionlabel3Size.width * 0.5 ,unionlabel3Size.height * 0.5))
            richText:setTag(333)
            unionlabel3:addChild(richText)

        end
    end

    bondRedPoint:setVisible(bBondOpen)

    btnBond:addTouchEventListener(function ( sender,eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            PartnerInfoCtrl.onBtnPartnerBond(self.heroInfo)
        end
    end )

    local deleteH = 0
    if (#linkGroupArr < 7) then
        for i=#linkGroupArr + 1,7 do
            local layBondText = layHeroBond["LAY_BOND_TXT" .. i]
            layBondText:removeFromParentAndCleanup(true)
            deleteH = deleteH + layBondTextSizeHeight
        end
    end
    if (not btnCanTouch) then
        local btnBondSize = btnBond:getContentSize()
        local btnBondSizeHeight = btnBondSize.height
        deleteH = deleteH + btnBondSizeHeight
    end

    layHeroBond:setSize(CCSizeMake(layHeroBondSize.width,layHeroBondSizeHeight - deleteH))
    lsvParterInfo:pushBackCustomItem(layHeroBond)
    self:resetCellSize(layHeroBond)

    return newlayH,function ( ... )
        local bBondOpen = false
        for i,v in ipairs(linkGroupArr) do
            local heroUnionDB = DB_Union_profit.getDataById(v)
            local openUnion , pStrings , pColors , tBond = FormationUtil.isUnionActive(v, hid, htid)
            if ((tBond.state == BondManager.BOND_REACHED) and (not bBondOpen)) then
                bBondOpen = true
            end
            -- 根据检查结果显示不同的颜色
            local colorTitle =  openUnion and self.color_get or self.color_normal
            local colorDesc = openUnion and self.color_get or self.color_normal

            local layBondText = layHeroBond["LAY_BOND_TXT" .. i]
            if (not layBondText) then
                return
            end
            local unionlabel = layBondText.TFD_BOND_1
            local unionlabel2 = layBondText.TFD_BOND_2
            local unionlabel3 = layBondText.TFD_BOND_3

            unionlabel:setColor(colorTitle)
            unionlabel2:setColor(colorDesc)

            if(not pStrings or #pStrings == 0 ) then
                unionlabel3:setColor(colorDesc)
            else
                unionlabel3:getChildByTag(333):setColor(colorDesc)
            end 

            bondRedPoint:setVisible(bBondOpen)
        end
    end
        
end

function PartnerInfoView:fnGetHeroInBorn( lsvParterInfo,layHeroInBorn )
    local m_i18n = gi18n

    local layHeroInBornSize = layHeroInBorn:getContentSize()
    local layInbonText1 = layHeroInBorn["LAY_INBORN_TXT" .. 1]
    local layInbonTextSize = layInbonText1:getContentSize()
    local layInbonTextSizeHeihgt = layInbonTextSize.height

    local heroDB = self.heroInfo.heroDB
    local transLevel = self.heroInfo.transLevel
    local heroDataModle = self.heroDataModle
    local tAwakes = self.heroInfo.heroAwakes
    -- title
    local tfdInbornTitle = layHeroInBorn.tfd_hero_inborn_title
    tfdInbornTitle:setText(m_i18n[1117])
    PartnerInfoCtrl.fnlabelNewStroke(tfdInbornTitle)
    -- 先判断是否有潜能
    local layNoInborn = layHeroInBorn.lay_no_inborn
    if (#tAwakes == 0 ) then
        layNoInborn:setEnabled(true)
        layNoInborn.tfd_no_inborn:setText(m_i18n[1176])  -- 没有潜能

        local deleltH = 0
        for i= 1,14 do
            local layInbonText = layHeroInBorn["LAY_INBORN_TXT" .. i]
            layInbonText:removeFromParentAndCleanup(true)
            deleltH = deleltH + layInbonTextSize.height
        end
        layHeroInBorn:setSize(CCSizeMake(layHeroInBornSize.width,self.noMesHeight ))
        lsvParterInfo:pushBackCustomItem(layHeroInBorn)
        self:resetCellSize(layHeroInBorn)

        return layH
    else
        layNoInborn:setEnabled(false)
    end
    -- 初始化潜能信息
    local titleH = layHeroInBorn.img_hero_inborn_title:getContentSize().height
    local addH = 0

    for i=#tAwakes, 1 , -1 do
        local layInbonText = layHeroInBorn["LAY_INBORN_TXT" .. i]
        local layInbonTextSize = layInbonText:getContentSize()
        -- local layHeroInbornTxt = layHeroInbornTxtClone:clone()
        local v = tAwakes[i]
        local data = DB_Awake_ability.getDataById(v.id)
        local labelColor01 = self.color_red
        local labelColor02 = self.color_get
        
        local bLowLevel=false
        local bLowerEvolveLevel=false
        if transLevel == nil then
            bLowLevel = true
        elseif tonumber(transLevel) < v.level then
            bLowLevel = true
        end
        if transLevel == nil then
            bLowerEvolveLevel = true
        elseif not bLowLevel and tonumber(transLevel) < v.evolve_level then
            bLowerEvolveLevel = true
        end
        if bLowLevel or bLowerEvolveLevel then
            labelColor01 = self.color_normal
            labelColor02 = self.color_normal
        end

        local tfdInbonName = layInbonText.TFD_INBORN_1
        tfdInbonName:setText(data.name)
        tfdInbonName:setColor(labelColor01)

        local inbondText = data.des or ""
        local tfdInbonText = layInbonText.TFD_INBORN_2
        if bLowLevel and v.level > 0 then
            --"("..m_i18n[1001]..v.level.."级解锁)"
            local pppstr = string.format(m_i18n[1712],m_i18n[1001]..v.level)
            inbondText =  inbondText .. pppstr
        elseif bLowerEvolveLevel then
            --"(进阶+"..v.evolve_level.."级解锁)"
            local pppstr = string.format(m_i18n[1712],m_i18n[1005].."+"..v.evolve_level)
            inbondText = inbondText.. pppstr
        end
        -- tfdInbonText:setText(inbondText)
        local  tfdInbonTextWidth,tfdInbonTextHeight,tfdInbonTextAffterHight = self:labelScaleChangedWithStr(tfdInbonText,inbondText)
        local perCellAddH = tfdInbonTextAffterHight - tfdInbonTextHeight
        addH = addH + perCellAddH
        tfdInbonText:setColor(labelColor02)

        layInbonText:setSize(CCSizeMake(layInbonTextSize.width,layInbonTextSize.height + perCellAddH))
    end

    local deleltH = 0
    for i= #tAwakes + 1,14 do
        local layInbonText = layHeroInBorn["LAY_INBORN_TXT" .. i]
        layInbonText:removeFromParentAndCleanup(true)
        deleltH = deleltH + layInbonTextSizeHeihgt
    end
    
    layHeroInBorn:setSize(CCSizeMake(layHeroInBornSize.width,layHeroInBornSize.height + addH - deleltH ))
    lsvParterInfo:pushBackCustomItem(layHeroInBorn)
    self:resetCellSize(layHeroInBorn)

    return newlayH

end


function PartnerInfoView:fnGetHeroAwake( lsvParterInfo,layHeroAwake )
    local m_i18n = gi18n
    local m_i18nString = gi18nString
    local layoutStyle = self.heroInfo.layoutStyle 
    local externHeroInfo = self.heroInfo.externHeroInfo

    local layHeroAwakeSize = layHeroAwake:getContentSize()
    local layHeroAwakeSizeHeight = layHeroAwakeSize.height

    local disillusionQuality = self.heroInfo.heroDB.disillusion_quality
    local disillusionQualityDes = self.heroInfo.heroDB.disillusion_quality_des

    local layHeroAwakeTxt = layHeroAwake["LAY_AWAKE_TXT" .. 1]
    local layHeroAwakeTxtSize = layHeroAwakeTxt:getContentSize()
    local layHeroAwakeTxtSizeHeight = layHeroAwakeTxtSize.height

    local awakeAttr = self.heroInfo.awake or {level = "0",star_lv = "0"}


    if (not disillusionQuality or not disillusionQualityDes) then
        return 0
    end

    local awakeLv = DB_Switch.getDataById(ksSwitchAwake or 40).level
    local curUserLel = externHeroInfo and tonumber(externHeroInfo.level) or tonumber(UserModel.getHeroLevel())
    logger:debug({curUserLel = curUserLel})
    logger:debug({curUserLel_awakeLv = awakeLv})
    logger:debug({curUserLel_canAwake = canAwake})

    if (curUserLel < tonumber(awakeLv)) then
        return 0
    end

    -- local TbDisillusion =  string.split(disillusionQuality , ",")
    -- local allDisillusion = {}
    -- for i,v in ipairs(TbDisillusion or {}) do
    --     local disillusion = string.split(v , "|")
    --     if (not allDisillusion[disillusion[1]]) then
    --         allDisillusion[disillusion[1]] = {}
    --     end
    --     table.insert(allDisillusion[disillusion[1]],v)
    -- end

    local TbDisillusionDes =  string.split(disillusionQualityDes , ",")

    -- title
    local tfdHeroAwakeTitle     = layHeroAwake.tfd_hero_inborn_title
    PartnerInfoCtrl.fnlabelNewStroke(tfdHeroAwakeTitle)
    tfdHeroAwakeTitle:setText(m_i18n[7404])
    -- 觉醒等级
    local tfdAwakeLv = layHeroAwake.TFD_AWAKE_LV
    tfdAwakeLv:setText(m_i18n[7402])
    local tfdAwakeLvNum = layHeroAwake.TFD_AWAKE_LV_NUM
    tfdAwakeLvNum:setText(gi18nString(7403,awakeAttr.star_lv,awakeAttr.level))

    -- 觉醒能力
    local imagHeroAwake = layHeroAwake.IMG_HERO_AWAKE
    local imagHeroAwakeSize = imagHeroAwake:getSize()

    local addH = 0

    for i = #TbDisillusionDes,1,-1  do
        -- local layHeroAwakeTxt = layHeroAwakeTxtClone:clone()
        local layHeroAwakeTxt = layHeroAwake["LAY_AWAKE_TXT" .. i]
        -- 根据检查结果显示不同的颜色
        local textColor =  (tonumber(awakeAttr.star_lv) >= i )  and self.color_get or self.color_normal

        -- local awakelabel = CCLabelTTF:create(m_i18n[7404] .. i, g_sFontCuYuan, self.textSize)
        local awakelabel = layHeroAwakeTxt.TFD_AWAKE_1
        awakelabel:setText("【" ..  m_i18n[7404] .. i .. "】")
        awakelabel:setColor(textColor)

        -- 觉醒增强数值table
        -- local tbAwakeInfos = string.split(TbDisillusion[i] , "|") 
        local tbDisillusionDesInfos = string.split(TbDisillusionDes[i] , "|") 
        -- 装备羁绊
        local awakelabelDes = layHeroAwakeTxt.TFD_AWAKE_2
        -- local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(tbAwakeInfos[3]),tonumber(tbAwakeInfos[4]))
        local limitInfo =  (tonumber(awakeAttr.star_lv) >= i ) and " "  or  "(" .. m_i18nString(7405,i) .. ")"
        local awakeinfo = tbDisillusionDesInfos[2] .. limitInfo
        -- lableAwakeText = LuaCCLabel.createMultiLineLabel({text= awakeinfo,fontname=g_sFontCuYuan,fontsize=self.textSize, width=nAngwidth, color=textColor, alignment=kCCTextAlignmentLeft})
        -- lableAwakeText:setPosition(ccp(namePos.x,namePos.y + labelDown:getContentSize().height*0.5))
        local tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr( awakelabelDes,awakeinfo )
        addH = addH +  affterSizeHeight -   tfdBeforeSizeHeight 
        awakelabelDes:setColor(textColor)
    end

    local deleltH = 0
    for i=#TbDisillusionDes + 1,5 do
        local layHeroAwakeTxt = layHeroAwake["LAY_AWAKE_TXT" .. i]
        layHeroAwakeTxt:removeFromParentAndCleanup(true)
        deleltH = deleltH + layHeroAwakeTxtSizeHeight
    end

    -- 觉醒按钮
    local btnAwake = layHeroAwake.BTN_AWAKE
    local btnAwakeSize = btnAwake:getContentSize()
    local btnAwakeSizeHeight = btnAwakeSize.height
    UIHelper.titleShadow(btnAwake,m_i18n[7401])

   

    if (layoutStyle == 1 or layoutStyle == 2  or layoutStyle == 5) then
        btnAwake:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.OnAwake(self.heroInfo)
            end
        end)
        local hid = self.heroInfo.hid 

        if (hid and tonumber(hid) > 0) then
            local canAwake = MainAwakeModel.isCanAwakeByHid( hid )
            if (canAwake) then
                local bondRedPoint = btnAwake.IMG_RED
                bondRedPoint:removeAllNodes()
                bondRedPoint:addNode(UIHelper.createRedTipAnimination())
            end
        end
    else
        btnAwake:setEnabled(false)
        deleltH = deleltH +  btnAwakeSizeHeight
    end
    --
    local tfdNoAwake = layHeroAwake.tfd_no_awake
    tfdNoAwake:setEnabled(false)

    layHeroAwake:setSize(CCSizeMake(layHeroAwakeSize.width,layHeroAwakeSizeHeight + addH - deleltH))
    lsvParterInfo:pushBackCustomItem(layHeroAwake)
    self:resetCellSize(layHeroAwake)


    return newlayH,function ( ... )
        local btnAwakePos = btnAwake:getWorldPosition()
        return btnAwakePos
    end
end

function PartnerInfoView:fnGetDemonFruit( lsvParterInfo,layDemonFruit )
    local m_i18n = gi18n
    local m_i18nString = gi18nString

    local layDemonFruitSize  = layDemonFruit:getContentSize()
    local layAttrTex = layDemonFruit["LAY_ATTRIBUTES_" .. 1]
    local layAttrTexSize = layAttrTex:getContentSize()

    local heroDB = self.heroInfo.heroDB
    -- title
    local tfdFruitTitle     = layDemonFruit.tfd_demon_fruit_title
    PartnerInfoCtrl.fnlabelNewStroke(tfdFruitTitle)
    tfdFruitTitle:setText(m_i18n[1103])
    -- 
    local evilfruitId  = heroDB.devilfruit_id
    local addH = 0
    -- 先判断是否有恶魔果实
    local layFruitFruitTxt = layDemonFruit.LAY_DEMON_FRUIT_TXT
    local layBfruitAffix = layDemonFruit.LAY_FRUIT_AFFIX
    local layNoFruit = layDemonFruit.lay_no_fruit

    if (evilfruitId) then
        layFruitFruitTxt:setEnabled(true)
        layNoFruit:setEnabled(false)
    else
        layFruitFruitTxt:setEnabled(false)
        layBfruitAffix:setEnabled(false)
        layNoFruit:setEnabled(true)
        layNoFruit.tfd_no_fruit:setText(m_i18n[1175])  -- 没有恶魔果实
        layDemonFruit:setSize(CCSizeMake(layDemonFruitSize.width,self.noMesHeight))
        lsvParterInfo:pushBackCustomItem(layDemonFruit)
        self:resetCellSize(layDemonFruit)
        return layH
    end
    -- 初始化恶魔果实部分
    local allCellsHeight = 0
    local tempStr_      = lua_string_split(evilfruitId,"|")
    local fruitInfo     = DB_Item_devilfruit.getDataById(tempStr_[2])
    -- 名字 描述部分
    local layFruitFruitDescribe = layDemonFruit.LAY_DEMON_FRUIT_TXT
    --  高度
    -- 
    local tfdFruitName   = layFruitFruitDescribe.TFD_FRUIT_NAME
    local fruitIconBg   = layFruitFruitDescribe.img_fruit_bg
    local imgFruitIcon  = layFruitFruitDescribe.img_fruit
    local layFruitFruitDesTxt  = layFruitFruitDescribe.LAY_FRUIT_DESCRIBE_TXT
    fruitIconBg:loadTexture("images/base/potential/color_".. fruitInfo.quality.. ".png")
    imgFruitIcon:loadTexture("images/base/props/" .. fruitInfo.icon_small)
    local imgBorder = ImageView:create()
    imgBorder:loadTexture("images/base/potential/equip_".. fruitInfo.quality.. ".png")
    imgFruitIcon:addChild(imgBorder)
    --添加 恶魔果实的描述 文字 
    local labDesc = layDemonFruit.TFD_FRUIT_DESC
    local desWidth,desHeight,desAffterHeight = self:labelScaleChangedWithStr(labDesc,fruitInfo.desc)
    addH = desAffterHeight - desHeight
    labDesc:setColor(self.color_normal)
    
    tfdFruitName:setText("[" .. fruitInfo.name .. "]")
    tfdFruitName:setColor(self.color_normal)
  
    -- 属性描述部分
    local awakeInfo     = DB_Awake_ability.getDataById(fruitInfo.awake_ability_ID)

    local attributIds   = lua_string_split(awakeInfo.attri_ids,",")
    local attributValues= lua_string_split(awakeInfo.attri_values,",")

    local layBfruitAffixSize = layBfruitAffix:getSize()

    for i = 1, #attributIds  do
        local layAttrTex = layDemonFruit["LAY_ATTRIBUTES_" .. i]
        local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(attributIds[i],attributValues[i])

        local tfdAttributsTxt = layAttrTex.TFD_ATTRIBUTES_TXT1
        local tfdAttributsNum = layAttrTex.TFD_ATTRIBUTES_NUM1
        tfdAttributsTxt:setText(affixInfo.displayName ..":")
        tfdAttributsNum:setText(displayNum)
    end
    local deleltH = 0
    for i= #attributIds + 1,6 do
        local layAttrTex = layDemonFruit["LAY_ATTRIBUTES_" .. i]
        deleltH = deleltH + layAttrTexSize.height
        layAttrTex:removeFromParentAndCleanup(true)
    end
    layDemonFruit:setSize(CCSizeMake(layDemonFruitSize.width,layDemonFruitSize.height + addH - deleltH))

    lsvParterInfo:pushBackCustomItem(layDemonFruit)
    self:resetCellSize(layDemonFruit)

    return newlayH
end


function PartnerInfoView:fnGetHeroProfile( lsvParterInfo,layHeroProfile )
    local m_i18n = gi18n
    --
    local heroDB = self.heroInfo.heroDB
    -- title
    local tfdProfileTitle = layHeroProfile.tfd_hero_profile_title
    local titleH = layHeroProfile.img_hero_profile_title:getContentSize().height
    tfdProfileTitle:setText(m_i18n[1118])
    PartnerInfoCtrl.fnlabelNewStroke(tfdProfileTitle)
    -- 简介
    local tfdHeroProfile = layHeroProfile.TFD_HERO_PROFILE_TXT
    local profileTxtWidth,profileTxtHeight,profileTxtAffterHeight = self:labelScaleChangedWithStr(tfdHeroProfile,heroDB.desc)
    tfdHeroProfile:setColor(self.color_normal)
    --
    local addH = profileTxtAffterHeight - profileTxtHeight
    -- addH = addH > 0 and addH + 5 or 0
    local layHeroProfileSize = layHeroProfile:getSize()
    layHeroProfile:setSize(CCSizeMake(layHeroProfileSize.width,layHeroProfileSize.height + addH))
    lsvParterInfo:pushBackCustomItem(layHeroProfile)
    self:resetCellSize(layHeroProfile)

    return layheight
end


function PartnerInfoView:initFooter( ... )
    local m_i18n = gi18n
    local layoutStyle = self.heroInfo.layoutStyle
    local layBtn = self.mainLayout.lay_partner_information_bottom
    layBtn:setEnabled(false)
    local btnChange = layBtn.BTN_2_1
    local btnReload = layBtn.BTN_2_2
    local btnOk = layBtn.BTN_1_1

    btnChange:setEnabled(false)
    btnReload:setEnabled(false)

    if (layoutStyle == 1 or layoutStyle == 3) then
        btnOk:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.onBtnGet(self.heroInfo)
            end
        end )
        -- btnOk:setTitleText(m_i18n[1098])   --获取途径
        local BtnChange = UIHelper.chagneGuildTOOk(btnOk)  -- 检查是否应该改为确定
        if (not BtnChange) then
            UIHelper.titleShadow(btnOk,m_i18n[1098])
        end

    elseif  (layoutStyle == 2 or layoutStyle == 4) then
        btnOk:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED)  then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.onBtnClose()
            end
        end )
        -- btnOk:setTitleText(m_i18n[1029])  -- 确定
        UIHelper.titleShadow(btnOk,m_i18n[1029])

    elseif (layoutStyle == 5) then
        btnOk:addTouchEventListener(function ( sender,eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect()
                PartnerInfoCtrl.onBtnChangeHeroBattle(self.heroInfo)
            end
        end )
        -- btnOk:setTitleText(m_i18n[1082])  -- 更换伙伴
        UIHelper.titleShadow(btnOk,m_i18n[1082])
    end

end



------------------------ new hand guide-------------------------------------
function PartnerInfoView:addFormationGuide(pos)
    require "script/module/guide/GuideFormationView"
    if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 2) then
        self.mainLayout.LSV_PARTNER_INFORMATION:setTouchEnabled(false)
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createFormationGuide(3,pos)
    end
end

function PartnerInfoView:addFiveGiftGuide( pos )
    require "script/module/guide/GuideFiveLevelGiftView"
    if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 9) then  
        self.mainLayout.LSV_PARTNER_INFORMATION:setTouchEnabled(false)
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createkFiveLevelGiftGuide(10, 0, pos)
    end
end

function PartnerInfoView:addCopy2BoxGuide( pos )
    require "script/module/guide/GuideCopy2BoxView"
    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 13) then
        self.mainLayout.LSV_PARTNER_INFORMATION:setTouchEnabled(false)
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopy2BoxGuide(14, 0, pos)
    end
end

function PartnerInfoView:addCopyBoxGuide( pos )
    require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 6) then
        self.mainLayout.LSV_PARTNER_INFORMATION:setTouchEnabled(false)
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopyBoxGuide(7,0,pos)
    end
end

function PartnerInfoView:addAwakeGuide( pos )
    require "script/module/guide/GuideAwakeView"
   if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 2) then
        self.mainLayout.LSV_PARTNER_INFORMATION:setTouchEnabled(false)
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAwakeGuide(3,0,pos)
    end
end











