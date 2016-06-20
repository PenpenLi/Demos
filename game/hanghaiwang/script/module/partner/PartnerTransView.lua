-- FileName: PartnerTransView.lua
-- Author: sunyunpeng
-- Date: 2015-12-17
-- Purpose: function description of module
--[[TODO List]]

module("PartnerTransView", package.seeall)

-- UI控件引用变量 --
local _transInfo 
local _tbTFDBeforForceValue
local _tbTFDAFFTERForceValue
local _layTouch
local m_i18n = gi18n

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["PartnerTransView"] = nil
end

function moduleName()
    return "PartnerTransView"
end

--加通用描边字
function fnlabelNewStroke( widgetName )
    UIHelper.labelNewStroke(widgetName,ccc3(0x45,0x05,0x05))
end

-- 初始化背景
local function initBG( ... )
	_mainLayout = g_fnLoadUI("ui/partner_transfer.json")
	_mainLayout:setSize(g_winSize)

    local layBg = _mainLayout.img_partner_information_bg1
    layBg:setScale(g_winSize.width/640)

    local btnBack = _mainLayout.BTN_TRANSFER_CLOSE
    btnBack:addTouchEventListener(function ( sender,eventType )
    	if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playBackEffect()
    		PartnerTransCtrl.onBtnReturn()
    	end
    end)
    UIHelper.titleShadow(btnBack,m_i18n[1019])

end

-- 初始化英雄模型
function initHeroModel( ... )
    local transBeforHeroDB = _transInfo.transBeforHeroDB 
    local transAffterHeroDB = _transInfo.transAffterHeroDB 
	-- 进阶前的模型
    local transHeroLay =  _mainLayout.lay_hero_transfer_model

    local transBeforeModel = transHeroLay.LAY_BEFORE_HERO_BODY
    local beforeHeroBody = CCSprite:create("images/base/hero/body_img/" .. transBeforHeroDB.body_img_id)
    beforeHeroBody:setPosition(ccp(transBeforeModel:getContentSize().width/2,transBeforeModel:getContentSize().height/2))
    beforeHeroBody:setAnchorPoint(0.5,0)
    transBeforeModel:setAnchorPoint(0,0.5)
    transBeforeModel:addNode(beforeHeroBody)
    UIHelper.fnPlayHuxiAni(beforeHeroBody)
    
    -- 进阶后的模型
    local imgArrow = _mainLayout.img_arrow
    local transAffterModel = transHeroLay.LAY_AFTER_HERO_BODY
    if (not transAffterHeroDB) then
        transAffterModel:setEnabled(false)
        imgArrow:setEnabled(false)
        return
    end
    local affterHeroBody = CCSprite:create("images/base/hero/body_img/" .. transAffterHeroDB.body_img_id)
    affterHeroBody:setPosition(ccp(transAffterModel:getContentSize().width/2,transAffterModel:getContentSize().height/2))
    affterHeroBody:setAnchorPoint(0.5,0)
    transAffterModel:setAnchorPoint(0,0.5)
    transAffterModel:addNode(affterHeroBody)
    UIHelper.fnPlayHuxiAni(affterHeroBody)
end 

-- 初始化基础面板
-- 初始化进阶后属性界面lay
local function initProperty( ... )
    local beforeForceValue = _transInfo.beforeForceValue 
    local affterForceValue = _transInfo.affterForceValue 

    local propertyLay = _mainLayout.lay_hero_transfer_property

    ---------------------------------汉字部分-----------------------------
    local tbAttrName = {m_i18n[1047],m_i18n[1048],m_i18n[1049],m_i18n[1050],m_i18n[1051]}

    local tbtfdAttrBeforeName = {"tfd_hero_before_hp_txt","tfd_hero_before_phy_attack_txt","tfd_hero_before_magic_attack_txt",
							"tfd_hero_before_phy_defend_txt","tfd_hero_before_magic_defend_txt"}

    --进阶区前
    for i=1,5 do
		local tfdBeforeTxt = propertyLay[tbtfdAttrBeforeName[i]]
    	tfdBeforeTxt:setText(tbAttrName[i])  
    	fnlabelNewStroke(tfdBeforeTxt)
	end

    local tbBeforForceValue = {beforeForceValue.life,beforeForceValue.physicalAttack,beforeForceValue.magicAttack,beforeForceValue.physicalDefend,beforeForceValue.magicDefend}
    
    _tbTFDBeforForceValue = {"TFD_HERO_BEFORE_HP","TFD_HERO_BEFORE_PHY_ATTACK","TFD_HERO_BEFORE_MAGIC_ATTACK",
                                "TFD_HERO_BEFORE_PHY_DEFEND", "TFD_HERO_BEFORE_MAGIC_DEFEND"} 

    -------------------------------- 战斗力数值部分 ---------------------------------------
    for i=1,5 do
        local tfdBeforeTxt = propertyLay[_tbTFDBeforForceValue[i]]

        tfdBeforeTxt:setText(tbBeforForceValue[i])

        tfdBeforeTxt:setColor(ccc3(0x0f,0xe8,0x0c))

        fnlabelNewStroke(tfdBeforeTxt)
    end
    ------------------------------  进阶等级部分---------------------------
    local transBeforHeroDB = _transInfo.transBeforHeroDB 
    local transAffterHeroDB = _transInfo.transAffterHeroDB 
    --名字
    local transHeroBeforeName =propertyLay.TFD_HREO_BEFORE_NAME
    transHeroBeforeName:setText(transBeforHeroDB.name .. "+" .. _transInfo.heroInfo.evolve_level)
    transHeroBeforeName:setColor(g_QulityColor2[transBeforHeroDB.star_lv])
    UIHelper.labelNewStroke(transHeroBeforeName , ccc3( 0x28 , 0x00 , 0x00))  
    ------------------------------------------------------------------------------------------
    if (not affterForceValue) then
        propertyLay.img_info_bg_after:setEnabled(false)
        propertyLay.img_lv_info:setEnabled(false)
        return
    end
    -- --------------------------------------------------进阶后-----------------------------------------
    --需要等级
    local tfdlv = propertyLay.tfd_lv
    tfdlv:setText(m_i18n[1160])  -- 解锁天赋 需要等级
    fnlabelNewStroke(tfdlv)  
    local tfdNowlv = propertyLay.TFD_NOW_LV
    tfdNowlv:setText(tonumber(_transInfo.heroInfo.level))
    fnlabelNewStroke(tfdNowlv)
    local tfdlvslant = propertyLay.tfd_lv_slant
    fnlabelNewStroke(tfdlvslant)
    local tfdNeddLv = propertyLay.TFD_NEED_LV
    tfdNeddLv:setText(tonumber(_transInfo.translimitLevel))
    fnlabelNewStroke(tfdNeddLv)

    if(tonumber(_transInfo.translimitLevel) > tonumber(_transInfo.heroInfo.level)) then
        tfdNowlv:setColor(ccc3(0xff,0x00,0x00))
    else
        tfdNowlv:setColor(ccc3(0x0f,0xe8,0x0c))
    end

    local tbtfdAttrAfterName = {"tfd_hero_after_hp_txt","tfd_hero_after_phy_attack_txt","tfd_hero_after_magic_attack_txt",
                                "tfd_hero_after_phy_defend_txt","tfd_hero_after_magic_defend_txt"}
    for i=1,5 do
        local tfdAffterTxt = propertyLay[tbtfdAttrAfterName[i]]
        tfdAffterTxt:setText(tbAttrName[i]) 
        fnlabelNewStroke(tfdAffterTxt)
    end

	-------------------------------- 战斗力数值部分 ---------------------------------------
    local tbAffterForceValue = {affterForceValue.life,affterForceValue.physicalAttack,affterForceValue.magicAttack,affterForceValue.physicalDefend,affterForceValue.magicDefend}
    _tbTFDAFFTERForceValue = {"TFD_HERO_AFTER_HP","TFD_HERO_AFTER_PHY_ATTACK","TFD_HERO_AFTER_MAGIC_ATTACK",
                                "TFD_HERO_AFTER_PHY_DEFEND","TFD_HERO_AFTER_MAGIC_DEFEND"}
    for i=1,5 do
        local tfdAffterTxt = propertyLay[_tbTFDAFFTERForceValue[i]]
        tfdAffterTxt:setText(tbAffterForceValue[i])
        tfdAffterTxt:setColor(ccc3(0x0f,0xe8,0x0c))
        fnlabelNewStroke(tfdAffterTxt)
    end

	------------------------------  进阶等级部分---------------------------
    local breakGiftLay = propertyLay.img_hero_info_bottom
    local breakGift = propertyLay.tfd_awake_ability
    local breakName = propertyLay.TFD_AWAKE_NAME
    --名字
    local transHeroAffterName =propertyLay.TFD_HREO_AFTER_NAME
    transHeroAffterName:setText(transAffterHeroDB.name .. "+" .. _transInfo.heroInfo.evolve_level + 1)
    transHeroAffterName:setColor(g_QulityColor2[transAffterHeroDB.star_lv])
    UIHelper.labelNewStroke(transHeroAffterName , ccc3( 0x28 , 0x00 , 0x00))  
    -- 解锁名izi
    breakGift:setText(m_i18n[1145])
    UIHelper.labelNewStroke(breakGift , ccc3( 0x45 , 0x05 , 0x05))
    breakName:setText(_transInfo.awakeName or m_i18n[1093])
    -- 重新刷新LSV里面的CELL信息
    local layLsvMain = propertyLay.LSV_DESC
    local refCell = layLsvMain:getItem(0)
    local layDescCellCopy = refCell:clone()
    local breakGiftDesc = layDescCellCopy.TFD_AWAKE_DESC

    local sAttr = _transInfo.awakeDes or ""
    if ( sAttr ~= "" ) then
        local sizeInfo = breakGiftDesc:getSize()
        local labAttr = UIHelper.createUILabel( sAttr, g_sFontPangWa, 22, ccc3(0xff,0xea,0x00))
        labAttr:ignoreContentAdaptWithSize(false)
        labAttr:setSize(CCSizeMake(sizeInfo.width * 0.85, 0))
        local rSize = labAttr:getVirtualRenderer():getContentSize()

        breakGiftDesc:setSize(CCSizeMake(sizeInfo.width,rSize.height * 1.2 ))
        layDescCellCopy:setSize(CCSizeMake(sizeInfo.width,rSize.height * 1.2))
        fnlabelNewStroke(breakGiftDesc)
    end
    breakGiftDesc:setText(sAttr)
    layLsvMain:removeAllItems()
    layLsvMain:pushBackCustomItem(layDescCellCopy)

end


-- 进阶材料界面
function initMaterial( refreshCostInfo )
    if (refreshCostInfo) then
        _transInfo.costInfo = refreshCostInfo
    end
    local costInfo = _transInfo.costInfo 
    local costlay = _mainLayout.img_cost_bg

    if (not costInfo) then
        costlay.img_cost_title:setEnabled(false)
        return
    end
    local tfdcost = _mainLayout.tfd_cost
    tfdcost:setText(m_i18n[1147])
    --UIHelper.labelNewStroke(tfdcost, ccc3(0x28,0x0e,0x04))
    
    for i=1,2 do
        local btnlay = costlay["BTN_TRANSFER_CONSUME_ICON_BG_".. i]
        local itemlay = costlay["lay_item_" .. i] 
        if(i <= #costInfo) then
            btnlay:setVisible(true)
            itemlay:setVisible(true)

            local tips = btnlay.IMG_TIPS
            local tdfConsumeName = itemlay.TFD_CONSUME_NAME
            --UIHelper.labelNewStroke(tdfConsumeName, ccc3(0x28,0x00,0x00))
            local itemNum = itemlay.lay_item_num

            local itemInfo = ItemUtil.getItemById(costInfo[i].itemTid)
            tdfConsumeName:setText(itemInfo.name)
            tdfConsumeName:setColor(g_QulityColor[itemInfo.quality])
            --mUI.labelShadow(tdfConsumeName)

            btnlay:loadTextureNormal(itemInfo.bg)
            btnlay:loadTexturePressed(itemInfo.bg)

            local imgTransferConsumeIcon = btnlay.IMG_TRANSFER_CONSUME_ICON
            imgTransferConsumeIcon:loadTexture(itemInfo.imgFullPath)

            local imgTransferBorder = btnlay.IMG_UP_BG
            imgTransferBorder:loadTexture(itemInfo.borderFullPath)

            local nNeedCount = costInfo[i].needNum
            local nRealCount = costInfo[i].haveNum
           
            local tfdNumLeft = itemlay.TFD_NUM_LEFT
            local tfdNumRight = itemlay.TFD_NUM_RIGHT

            if( nNeedCount > nRealCount) then
                tfdNumLeft:setColor(ccc3(0xD8,0x14,0x00))
            else
                tfdNumLeft:setColor(ccc3(0x00,0x8A,0x00))
            end

            tfdNumLeft:setText(nRealCount)
            tfdNumRight:setText(nNeedCount)
            --显示影子标志
            if (itemInfo.isHeroFragment) then
                tips:setVisible(true)

            else
                tips:setVisible(false)
            end

            btnlay:addTouchEventListener(function ( sender ,eventType )  
                if eventType == TOUCH_EVENT_ENDED then
                    local itemTid = costInfo[i].itemTid
                    local itemInfo = ItemUtil.getItemById(itemTid)
                    if (itemInfo.isNormal) then
                        local dropCallfn =  function ( ... )
                            logger:debug("createItemDropInfoViewByTid")
                            local costInfo = PartnerTransCtrl.initMaterial()
                            _transInfo.costInfo = costInfo
                            initMaterial()
                        end
                        PublicInfoCtrl.createItemDropInfoViewByTid(60002,dropCallfn)  -- 进阶石不足引导界面

                    elseif(itemInfo.isHeroFragment) then
                        require "script/module/public/DropUtil"
                        require "script/module/public/FragmentDrop"
                        local curModuleName = LayerManager.curModuleName()
                        local returnInfo = {}

                        local fragmentDrop = FragmentDrop:new()
                        local dropCallfn =  function ( ... )
                            local costInfo = PartnerTransCtrl.initMaterial()
                            _transInfo.costInfo = costInfo
                            initMaterial()
                        end
                        PublicInfoCtrl.createItemDropInfoViewByTid(itemTid,dropCallfn)  -- 进阶石不足引导界面
                    end
                end
            end)
        else
            btnlay:setVisible(false)
            itemlay:setVisible(false)
        end
    end
end

function initBtn( ... )
	-- 进阶按钮
	local btnTransferStar = _mainLayout.BTN_TRANSFER_STAR
    btnTransferStar:addTouchEventListener(function (sender,eventType )
    	if (eventType == TOUCH_EVENT_ENDED) then
            -- 音效
            AudioHelper.playCommonEffect()
    		PartnerTransCtrl.onBtnTransferStart()
    	end
    end)
    UIHelper.titleShadow(btnTransferStar,m_i18n[1039])
    -- 贝里
    local tfdTransferBellyNum = _mainLayout.TFD_TRANSFER_BELLY_NUM
    tfdTransferBellyNum:setText(_transInfo.costCoin or 0)

end

function transferAnimation( succeedInfo )
    local layEffect = _mainLayout.lay_effect
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
                    LayerManager.removeLayout()
                    require "script/module/partner/PartnerTransSucceed"
                    PartnerTransSucceed.create( succeedInfo )
                end
        end,
    })
    m_arAni1:setPosition(layEffect:getContentSize().height * 0.5,layEffect:getContentSize().width * 0.5)
    layEffect:removeAllNodes()
    layEffect:addNode(m_arAni1)

end

--重置界面内容
function refreshLayer( newTransInfo )
    _transInfo = newTransInfo
    initHeroModel()
    initProperty()
    initMaterial()
    initBtn()
end

--新手引导
function guidLine( ... )
     --------------------------- new guide begin -------------------------------------
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuidePartnerAdvView"
    if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 2) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createPartnerAdvGuide(3,0)   
    end

    if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 4) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createPartnerAdvGuide(5,0)   
    end

    require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 7) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopyBoxGuide(8)
    end
    ---------------------------- new guide end --------------------------------------
end


function create( transInfo )
	_transInfo = transInfo
	initBG()
	initHeroModel()
	initProperty()
	initMaterial()
	initBtn()

	LayerManager.setPaomadeng(_mainLayout, 0)
	UIHelper.registExitAndEnterCall(_mainLayout, function ( ... )
		LayerManager.resetPaomadeng()
    end,function (  )
        --线上报错 背包推送回来时，页面不在导致报错
        PreRequest.removeBagDataChangedDelete()
    end)
    guidLine()
	return _mainLayout
end


