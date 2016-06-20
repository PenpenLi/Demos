-- FileName: SpTreaRefineSucceed.lua 
-- Author: sunyunpeng
-- Date: 15-04-08 
-- Purpose: function description of module 

module("SpTreaRefineSucceed", package.seeall)
require "script/GlobalVars"
require "script/module/config/AudioHelper"
-- vars
local _mainLayout
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidgetByName = g_fnGetWidgetByName


--
local _specTreaInfo

--英雄进阶前数据
local labnPreHP
local labnPrePhyAttack
local labnPreMagicAttack
local labnPrePhyDefend
local labnPreMagicDefend

local _JianTous = {}
local _AttrAfterNums = {}
local layTouch



local strokeCor = ccc3( 0x43, 0x1c, 0x00)
--进阶伙伴数据
local m_tbTransferInfo
-- local imgCampTip

-- 初始化和析构
function init( ... )
    
end

function destroy( ... )
    package.loaded["PartnerBreakSucceed"] = nil
end

function moduleName()
    return "PartnerBreakSucceed"
end



local function fnCreateAni( pName , ploop , callback)
    local m_arAni1 = UIHelper.createArmatureNode({
        imagePath = "images/effect/"..pName.."/"..pName.."0.png",
        plistPath = "images/effect/"..pName.."/"..pName.."0.plist",
        filePath = "images/effect/"..pName.."/"..pName..".ExportJson",
        animationName = pName,
        loop = ploop or -1,
        fnMovementCall = callback or nil
    })
    return m_arAni1
end

local function bgAnimation( ... )
    --effectId =  AudioHelper.playEffect("audio/effect/texiao_jinjie_guangmang.mp3",true)
    local imgEffect = m_fnGetWidgetByName(partner_transfer_succeed, "lay_transfer_succeed_model")
    
    local waveNode = CCParticleSystemQuad:create("images/effect/jinjie_guangmang/guangxing.plist")
    waveNode:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))
    if (imgEffect:getChildByTag(transSucceedBgXing)) then
        imgEffect:getChildByTag(transSucceedBgXing):removeFromParentAndCleanup(true)
    end
    imgEffect:addNode(waveNode,-1000,transSucceedBgXing)

    local m_arAni1 = UIHelper.createArmatureNode({
            filePath = "images/effect/shop_recruit/zhao3.ExportJson",
            animationName = "zhao3",
            loop = -1
            }
        )
    -- local m_arAni1 = fnCreateAni("jinjie_guangmang")
    m_arAni1:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))
    if (imgEffect:getChildByTag(transSucceedBg)) then
        imgEffect:getChildByTag(transSucceedBg):removeFromParentAndCleanup(true)
    end
    imgEffect:addNode(m_arAni1,-1000,transSucceedBg)
end

local function fnStartNumAni(  )

    AudioHelper.playEffect("audio/effect/texiao_jinjie_shuzi.mp3")

    for i=1,#_JianTous do
        local pJiantou = _JianTous[i]
        if(pJiantou) then
            local pArr = CCArray:create()
            if(i ~= 1) then
                pArr:addObject(CCDelayTime:create(0.05*(i-1)))
            end
            pArr:addObject(CCCallFuncN:create(function()
                pJiantou:addNode(fnCreateAni("jinjie_zhizhen"))
                if(_AttrAfterNums[i]) then
                    _AttrAfterNums[i]:setVisible(true)
                    local pAni = fnCreateAni("jinjie_shuzi")
                    pAni:setPositionX(_AttrAfterNums[i]:getContentSize().width*0.5)
                    _AttrAfterNums[i]:addNode(pAni)
                end
            end))
            if(i == #_JianTous) then
                -- 战斗提升动画
                pArr:addObject(CCCallFuncN:create(function ( ... )
                    MainFormationTools.fnShowFightForceChangeAni()
                end))
                pArr:addObject(CCDelayTime:create(1))
                pArr:addObject(CCCallFuncN:create(function ( ... )
                    layTouch:setTouchEnabled(true)
                end))
            end
            pJiantou:runAction(CCSequence:create(pArr))
        end
    end
end

-- 播放潜能信息电报特效
-- 再间隔8帧   开始打字 打字的节奏为 每个字出现时间为4帧 再出现下一个
local function fnCreateAwakeInfoAni( ... )
    logger:debug({_succeedspecTreaInfo=_specTreaInfo})
    
    local labAwakeInfoString = _specTreaInfo.treaLelUpAwaken
    if (not labAwakeInfoString) then
        fnStartNumAni()
        return
    end

    local labAwakeInfo = _mainLayout.TFD_AWAKE_DESC
    -- 由于CCttflable 和 UIlable 字体描边后颜色对不上 所以fontSize 由22改为22.5 ，strokeSize由2 改为2.5 ，fontColor 由ccc3(0xff,0x8d,0x2c)改为 ccc3(240,66,0) 
    local ttfArg = {}
    ttfArg.fontName = g_sFontCuYuan
    ttfArg.fontSize = 22
    ttfArg.bShadow = true
    ttfArg.strokeColor = ccc3(0x28,0x00,0x00)

    ttfArg.strokeSize = 2
    ttfArg.fontColor = ccc3(0xff,0x8d,0x2c)

    UIHelper.typingEffect( labAwakeInfo,labAwakeInfoString,2 ,ttfArg,fnStartNumAni)
end 

-- 播放潜能名字特效
-- 再间隔5帧 透明度由0~100 出现 大小为130% 停留5帧 再变回到 100% 时间为 5帧
local function fnCreateAwakeNameAni( ... )
    local labAwakeName = _mainLayout.TFD_TRANSFER_AWAKE
    local actionArray = CCArray:create()
    actionArray:addObject(CCCallFuncN:create(function ( sender )
        labAwakeName:setText(labAwakeNameString)
        labAwakeName:setScale(1.3)
        labAwakeName:setVisible(true)
    end))
    actionArray:addObject(CCDelayTime:create(5/60))
    actionArray:addObject(CCScaleTo:create(5/60,1))
    actionArray:addObject(CCDelayTime:create(8/60))
    actionArray:addObject(CCCallFuncN:create(function ( sender )
        fnCreateAwakeInfoAni() -- 播放潜能信息电报特效
    end))

    local seq = CCSequence:create(actionArray)
    labAwakeName:runAction(seq)

end 



local function fnSetLabel( label , num , isNotShow)
    label:setText(num)
    UIHelper.labelNewStroke(label, strokeCor,2)
    if(isNotShow) then
        label:setVisible(false)
    end
end


function onBtnReturn( sender,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        -- 移除战斗力提升动画
        MainFormationTools.removeFlyText()
        -- LayerManager.removeLayout()
        SpecTreaRefineView.setBtnStatus(true)
        LayerManager.removeLayout()
    end
end


function initBg( ... )

    _mainLayout = g_fnLoadUI("ui/special_advance_succeed.json")
    -- _mainLayout:setSize(g_winSize)

    local layBg = m_fnGetWidgetByName(_mainLayout, "img_partner_information_bg1")
    layBg:setScale(g_fScaleX)

    layTouch = Layout:create()
    layTouch:setSize(CCSizeMake(layBg:getSize().width * g_fScaleX ,layBg:getSize().height * g_fScaleX) )
    layTouch:setTouchEnabled(false)
    layTouch:addTouchEventListener(onBtnReturn)
    _mainLayout:addChild(layTouch)

    ---  
    local imgEffect = _mainLayout.lay_transfer_succeed_model
    local waveNode = CCParticleSystemQuad:create("images/effect/jinjie_guangmang/guangxing.plist")
    waveNode:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))

    imgEffect:addNode(waveNode,-1000)

    local m_arAni1 = UIHelper.createArmatureNode({
            filePath = "images/effect/shop_recruit/zhao3.ExportJson",
            animationName = "zhao3",
            loop = -1
            }
        )
    m_arAni1:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))

    imgEffect:addNode(m_arAni1,-1000)

end


-- 播放突破成功特效 新增特效 2015.07.25 
--【新增潜能】 由左（-15）滑向向右（0）  透明度由0~100 出现  时间长为15帧
local function fnCreateLogAni( ... )
    local actionArray = CCArray:create()
    -- 控件节点 和节点中得 getVirtualRenderer 运动方向是反的。。。。
    actionArray:addObject(
                    CCSpawn:createWithTwoActions(
                                                    CCMoveBy:create(15/60, ccp(15, 0)),
                                                    CCFadeIn:create(15/60)
                                                )
                   )
    actionArray:addObject(CCDelayTime:create(5/60))
    actionArray:addObject(CCCallFuncN:create(function ( sender )
        fnCreateAwakeNameAni(  ) -- 播放新增潜能名字动画
    end))
    local imgNewAwake = _mainLayout.img_awake_ability
    local imgNewAwakePic = imgNewAwake:getVirtualRenderer()
    local seq = CCSequence:create(actionArray)
    imgNewAwakePic:runAction(seq)
end 


local function succedTextAnimation( noLogoAnimate )
    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
    local imgSucceed = _mainLayout.img_transfer_succeed
    imgSucceed:loadTexture("")
    local m_arAni1 = UIHelper.createArmatureNode({
        filePath = "images/effect/jinjie_chenggong/jinjie_chenggong.ExportJson",
        animationName = "jinjie_chenggong",
        loop = -1,
        fnMovementCall = function ( ... )
            if(movementType == EVT_COMPLETE) then
                m_arAni1:removeFromParentAndCleanup(true)
            end
        end,
        fnFrameCall = function( bone,frameEventName,originFrameIndex,currentFrameIndex )
            if(frameEventName == "1") then
               
            end
        end,
    })
    imgSucceed:addNode(m_arAni1,1000)

    if (noLogoAnimate) then
        performWithDelay(imgSucceed,function()
            fnStartNumAni()
        end,50/60)
    else
        performWithDelay(imgSucceed,function()
            fnCreateLogAni()
        end,50/60)
    end
end

function initModel( noLogoAnimate )
    local treaDB = _specTreaInfo.treaDB
    ---
    local laySucceedModel = _mainLayout.lay_transfer_succeed_model

    local layTreaModel = laySucceedModel.LAY_HERO_MODEL
    local imgNewAwake = laySucceedModel.img_awake_ability
    local labAwakeName = laySucceedModel.TFD_TRANSFER_AWAKE
    UIHelper.labelNewStroke(labAwakeName,ccc3(0xea,0x32,0x00),3)

    local labAwakeInfo = laySucceedModel.TFD_AWAKE_DESC

    local treaSprite  = CCSprite:create("images/base/exclusive/big/" ..  treaDB.icon_big)
    treaSprite:setPosition(ccp(layTreaModel:getContentSize().width/2,layTreaModel:getContentSize().height/2))
    treaSprite:setAnchorPoint(0.5,0)
    layTreaModel:setAnchorPoint(0,0.5)
    layTreaModel:addNode(treaSprite)

    local arr = CCArray:create()
    arr:addObject(CCScaleTo:create(1, 1.02))
    arr:addObject(CCScaleTo:create(1, 1.0))
    local  pSequence = CCSequence:create(arr)
    treaSprite:runAction(CCRepeatForever:create(pSequence))

    if (not noLogoAnimate) then
        -- 新增潜能logo图片由左（-15）滑向向右（0）  透明度由0~100 的初始状态
        imgNewAwake:runAction(CCPlace:create(ccp(imgNewAwake:getPositionX() - 15 ,imgNewAwake:getPositionY())))
        imgNewAwake:setOpacity(0)

        labAwakeInfo:setText("                                       ")
        labAwakeName:setText("")

        if (_specTreaInfo.awakeName) then
            labAwakeName:setText(_specTreaInfo.awakeName)
        else
            labAwakeName:setText(m_i18n[1093])
        end

    else
        labAwakeName:setText(" ")
        if (((tonumber(_specTreaInfo.refineLevel)  + 1) ==  tonumber(_specTreaInfo.thresholdLel))) then
            logger:debug("labAwakeName _specTreaInfo")
            if (_specTreaInfo.awakeName) then
                logger:debug(_specTreaInfo.awakeName)
                labAwakeName:setText(_specTreaInfo.awakeName)
            end
            local labAwakeInfoString = _specTreaInfo.treaLelUpAwaken
            logger:debug(labAwakeInfoString)
            labAwakeInfo:setText(labAwakeInfoString)
            UIHelper.labelNewStroke(labAwakeInfo,ccc3(0x28,0x00,0x00),2)
        else
            labAwakeName:setText(m_i18n[1093])
            labAwakeInfo:setText("      ")
        end
    end

    performWithDelay(_mainLayout,function()
        succedTextAnimation(noLogoAnimate)
    end,0.5)

end


function initLayProperty( ... )
    local layproperty = _mainLayout.lay_transfer_property

    local tfdLevel = layproperty.tfd_level
    UIHelper.labelNewStroke(tfdLevel, strokeCor,2)
    tfdLevel:setText(m_i18n[1618] .. ":")

    local tbAttrBeforeNum =  _specTreaInfo.refineBeforeAttr

    local tfdHp = layproperty.tfd_hp
    UIHelper.labelNewStroke(tfdHp, strokeCor,2)
    -- tfdHp:setText(m_i18n[1047])
    tfdHp:setText( tbAttrBeforeNum[1].name .. ":")

    local tfdPhyAttack = layproperty.tfd_phy_attack
    UIHelper.labelNewStroke(tfdPhyAttack, strokeCor,2)
    -- tfdPhyAttack:setText(m_i18n[1048])
    tfdPhyAttack:setText(tbAttrBeforeNum[2].name .. ":")

    local tfdMagicAttck = layproperty.tfd_magic_attck
    UIHelper.labelNewStroke(tfdMagicAttck, strokeCor,2)
    -- tfdMagicAttck:setText(m_i18n[1049])
    tfdMagicAttck:setText(tbAttrBeforeNum[3].name .. ":")

    local tfdPhyDenfend = layproperty.tfd_phy_denfend
    UIHelper.labelNewStroke(tfdPhyDenfend, strokeCor,2)
    -- tfdPhyDenfend:setText(m_i18n[1050])
    tfdPhyDenfend:setText(tbAttrBeforeNum[4].name .. ":")

    local tfdMagicDenfend = layproperty.tfd_magic_denfend
    UIHelper.labelNewStroke(tfdMagicDenfend, strokeCor,2)
    -- tfdMagicDenfend:setText(m_i18n[1051])
    tfdMagicDenfend:setText(tbAttrBeforeNum[5].name .. ":")

    --进阶前英雄数据
    local labnPreLel = layproperty.TFD_BEFORE_LEVEL
    fnSetLabel(labnPreLel , _specTreaInfo.refineLevel .. m_i18n[6933] )

    local labnPreHP = layproperty.TFD_BEFORE_HP
    fnSetLabel(labnPreHP , tbAttrBeforeNum[1].value)

    local labnPrePhyAttack = layproperty.TFD_BEFORE_PHY_ATTACK
    fnSetLabel(labnPrePhyAttack , tbAttrBeforeNum[2].value)

    local labnPreMagicAttack = layproperty.TFD_BEFORE_MAGIC_ATTACK
    fnSetLabel(labnPreMagicAttack , tbAttrBeforeNum[3].value)

    local labnPrePhyDefend = layproperty.TFD_BEFORE_PHY_DENFEND
    fnSetLabel(labnPrePhyDefend , tbAttrBeforeNum[4].value)

    local labnPreMagicDefend = layproperty.TFD_BEFORE_MAGIC_DENFEND
    fnSetLabel(labnPreMagicDefend , tbAttrBeforeNum[5].value)
    ----------------------------------------------------------
    local tbAttrAfterNum =  _specTreaInfo.refineAfterAttr

    --进阶后英雄数据
    local labnAfterLel = layproperty.TFD_AFTER_LEVEL
    fnSetLabel(labnAfterLel , (_specTreaInfo.refineLevel + 1) .. m_i18n[6933], true)
    table.insert(_AttrAfterNums,labnAfterLel)

    local labnAfterHP = layproperty.TFD_AFTER_HP
    fnSetLabel(labnAfterHP , tbAttrAfterNum[1].value  , true)
    table.insert(_AttrAfterNums,labnAfterHP)

    local labnAfterPhyAttack = layproperty.TFD_AFTER_PHY_ATTACK
    fnSetLabel(labnAfterPhyAttack , tbAttrAfterNum[2].value , true)
    table.insert(_AttrAfterNums,labnAfterPhyAttack)

    local labnAfterMagicAttack = layproperty.TFD_AFTER_MAGIC_ATTACK
    fnSetLabel(labnAfterMagicAttack , tbAttrAfterNum[3].value , true)
    table.insert(_AttrAfterNums,labnAfterMagicAttack)

    local labnAfterPhyDefend = layproperty.TFD_AFTER_PHY_DENFEND
    fnSetLabel(labnAfterPhyDefend , tbAttrAfterNum[4].value , true)
    table.insert(_AttrAfterNums,labnAfterPhyDefend)

    local labnAfterMagicDefend = layproperty.TFD_AFTER_MAGIC_DENFEND
    fnSetLabel(labnAfterMagicDefend , tbAttrAfterNum[5].value ,true)
    table.insert(_AttrAfterNums,labnAfterMagicDefend)


    --往右剪头图标
    local imgLelRight = layproperty.IMG_LEVEL_ARROW_RIGHT
    table.insert(_JianTous,imgLelRight)
    local imgHPRight = layproperty.IMG_HP_ARROW_RIGHT 
    table.insert(_JianTous,imgHPRight)
    local imgPHYAttRight = layproperty.IMG_PHY_ATTACK_ARROW_RIGHT
    table.insert(_JianTous,imgPHYAttRight)
    local imgMagicAttRight = layproperty.IMG_MAGIC_ATTACK_ARROW_RIGHT
    table.insert(_JianTous,imgMagicAttRight)
    local imgPHYDenRight = layproperty.IMG_PHY_DENFEND_ARROW_RIGHT
    table.insert(_JianTous,imgPHYDenRight)
    local imgMagicDenRight = layproperty.IMG_MAGIC_DENFEND_ARROW_RIGHT
    table.insert(_JianTous,imgMagicDenRight)

end


function create( specTreaInfo)
    _specTreaInfo = specTreaInfo
    _JianTous = {}
    _AttrAfterNums = {}

    logger:debug({_succeedspecTreaInfo=_specTreaInfo})

    initBg()
    local noLogoAnimate = true
    initModel( noLogoAnimate )
    initLayProperty()

    LayerManager.addLayout(_mainLayout)
end











