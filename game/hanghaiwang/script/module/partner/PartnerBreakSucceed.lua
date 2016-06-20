-- FileName: PartnerBreakSucceed.lua 
-- Author: wangming
-- Date: 15-04-08 
-- Purpose: function description of module 

module("PartnerBreakSucceed", package.seeall)
require "script/GlobalVars"
require "script/module/config/AudioHelper"
-- vars
local _tbBreakInfo


local partner_transfer_succeed
local m_i18n = gi18n
local mUILoad = g_fnLoadUI
local m_fnGetWidgetByName = g_fnGetWidgetByName

--英雄进阶前数据
local labnPreHP
local labnPrePhyAttack
local labnPreMagicAttack
local labnPrePhyDefend
local labnPreMagicDefend

	--英雄进阶后数据
local labnAfterHP
local labnAfterPhyAttack
local labnAfterMagicAttack
local labnAfterPhyDefend
local labnAfterMagicDefend

local imgHPRight
local imgPHYAttRight
local imgMagicAttRight
local imgPHYDenRight
local imgMagicDenRight
local layTouch

-- local imgCamp
local layHeroModel
local imgNewAwake  -- [新增潜能logo图片]
local labAwakeName --  新增潜能名字
local labAwakeInfo --  新增潜能描述
local labAwakeNameString = ""--  新增潜能名字
local labAwakeInfoString = ""--  新增潜能描述

local labAwakeLimit 
local tfdColor
local tfdScore
local tfdScoreNum

local effectId
--返回界面参数
local tbParamaTag
local transSucceedBg = 100
local transSucceedBgXing = 101
local transSucceedText = 102
local transSucceedTextGuang = 103

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

local function onBtnReturn(sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        LayerManager.removeLayout()
        if (effectId ~= nil ) then
            SimpleAudioEngine:sharedEngine():stopEffect(effectId)
        end
        require "script/module/partner/PartnerBreak"
        PartnerBreak.fnFreshYingziList()
        -- 移除战斗力提升动画
        MainFormationTools.removeFlyText()
        local sourceType = _tbBreakInfo.sourceType 
        local heroLocation = _tbBreakInfo.heroLocation

        if (sourceType == 2) then
            require "script/module/formation/MainFormation"
            logger:debug("wm-----numSrcLocation : " .. heroLocation)
            local layPartner = MainFormation.create(heroLocation)
            if (layPartner) then
                -- zhangqi, 不需要重新创建定制信息面板时指定true把以前的清理一下，避免更新人物属性导致找不到对象的问题
                LayerManager.changeModule(layPartner, MainFormation.moduleName(), {1,3}, true)
            end
        else
            require "script/module/partner/MainPartner"
            local layPartner = MainPartner.create()
            if (layPartner) then
                LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3})
                PlayerPanel.addForPartnerStrength()
            end
        end

    end
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

local function fnStartNumAni( sender, MovementEventType, movementID )
    --if (MovementEventType == 1) then
        AudioHelper.playEffect("audio/effect/texiao_jinjie_shuzi.mp3")
        local pJianTous = {imgHPRight,imgPHYAttRight,imgMagicAttRight,imgPHYDenRight,imgMagicDenRight}
        local pNums = {labnAfterHP,labnAfterPhyAttack,labnAfterMagicAttack,labnAfterPhyDefend,labnAfterMagicDefend}

        for i=1,#pJianTous do
            local pJiantou = pJianTous[i]
            if(pJiantou) then
                local pArr = CCArray:create()
                if(i ~= 1) then
                    pArr:addObject(CCDelayTime:create(0.05*(i-1)))
                end
                pArr:addObject(CCCallFuncN:create(function()
                    pJiantou:addNode(fnCreateAni("jinjie_zhizhen"))
                    if(pNums[i]) then
                        pNums[i]:setVisible(true)
                        local pAni = fnCreateAni("jinjie_shuzi")
                        pAni:setPositionX(pNums[i]:getContentSize().width*0.5)
                        pNums[i]:addNode(pAni)
                    end
                end))
                if(i == #pJianTous) then
                    pArr:addObject(CCDelayTime:create(1))
                    pArr:addObject(CCCallFuncN:create(function ( ... )
                        layTouch:setTouchEnabled(true)
                    end))
                    -- 战斗力提升动画
                    MainFormationTools.fnShowFightForceChangeAni()
                end
                pJiantou:runAction(CCSequence:create(pArr))
            end
        end
    --end
end

-- 播放潜能信息电报特效
-- 再间隔8帧   开始打字 打字的节奏为 每个字出现时间为4帧 再出现下一个
local function fnCreateAwakeInfoAni( ... )
    -- labAwakeInfo:setColor(ccc3(0xff,0x8d,0x2c))
    -- labAwakeInfo:setText("                                                                                                               怒气攻击时")
    -- 由于CCttflable 和 UIlable 字体描边后颜色对不上 所以fontSize 由22改为22.5 ，strokeSize由2 改为2.5 ，fontColor 由ccc3(0xff,0x8d,0x2c)改为 ccc3(240,66,0) 
    local ttfArg = {}
    ttfArg.fontName = g_sFontCuYuan
    ttfArg.fontSize = 22
    ttfArg.bShadow = true
    ttfArg.strokeColor = ccc3(0x28,0x00,0x00)

    ttfArg.strokeSize = 2
    ttfArg.fontColor = ccc3(0xff,0x8d,0x2c)
    --ttfArg.fontColor = ccc3(240,66,0) 
    logger:debug({fnCreateAwakeInfoAni = _tbBreakInfo })
    logger:debug({fnCreateAwakeInfoAni = _tbBreakInfo.awakeDes })

    if (labAwakeInfoString) then
        UIHelper.typingEffect( labAwakeInfo,labAwakeInfoString,2 ,ttfArg,fnStartNumAni)
    else
        fnStartNumAni()
    end
end 

-- 播放潜能名字特效
-- 再间隔5帧 透明度由0~100 出现 大小为130% 停留5帧 再变回到 100% 时间为 5帧
local function fnCreateAwakeNameAni( ... )
    local actionArray = CCArray:create()
    actionArray:addObject(CCCallFuncN:create(function ( sender )
        labAwakeName:setText(labAwakeNameString or m_i18n[1093])
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
    local imgNewAwakePic = imgNewAwake:getVirtualRenderer()
    local seq = CCSequence:create(actionArray)
    imgNewAwakePic:runAction(seq)
end 

local function succedTextAnimation( ... )
    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
    local imgSucceed = m_fnGetWidgetByName(partner_transfer_succeed, "img_transfer_succeed")
    imgSucceed:loadTexture("")
    -- local m_arAni1 = fnCreateAni("jinjie_chenggong" , 0 , fnStartNumAni)
    -- if (imgSucceed:getChildByTag(transSucceedText)) then
    --     imgSucceed:getChildByTag(transSucceedText):removeFromParentAndCleanup(true)
    -- end
    -- imgSucceed:addNode(m_arAni1,1000,transSucceedText)
    local m_arAni1 = UIHelper.createArmatureNode({
        filePath = "images/effect/partner_break/break_tupochenggong/break_tupochenggong.ExportJson",
        animationName = "break_tupochenggong",
        loop = 0,
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
    imgSucceed:addNode(m_arAni1,1000,transSucceedText)

    performWithDelay(imgSucceed,function()
        fnCreateLogAni()
    end,50/60)

    --fnStartNumAni()
    -- local m_arAni2 = fnCreateAni("jinjie_faguang" )
    -- if (imgSucceed:getChildByTag(transSucceedTextGuang)) then
    --     imgSucceed:getChildByTag(transSucceedTextGuang):removeFromParentAndCleanup(true)
    -- end
    -- imgSucceed:addNode(m_arAni2, 1001,transSucceedTextGuang)
end

local function headIconAnimation( ... )
    -- imgTransferSucceedIcon:setScale(0.0)

    local actionTo1 = CCScaleTo:create(5 / 60, 1.6)
    local actionTo2 = CCScaleTo:create(5 / 60, 0.8)
    local actionTo3 = CCScaleTo:create(2 / 60, 1.0)
    local arr = CCArray:create()
    arr:addObject(actionTo1)
    arr:addObject(actionTo2)
    arr:addObject(actionTo3)
    local  pSequence = CCSequence:create(arr)
    -- imgTransferSucceedIcon:runAction(pSequence)
end

local function createSuccedAction( ... )
    --headIconAnimation()
    bgAnimation()

    performWithDelay(partner_transfer_succeed,function()
        succedTextAnimation()
    end,0.5)
end

local function fnSetLabel( label , num , isNotShow)
    label:setText(num)
    UIHelper.labelNewStroke(label, strokeCor,2)
    if(isNotShow) then
        label:setVisible(false)
    end
end

local function updateTransferInfo( ... )

    local beforeForceValue = _tbBreakInfo.beforeForceValue 
    local affterForceValue = _tbBreakInfo.affterForceValue

    local beforeHeroDb = _tbBreakInfo.breakBeforHeroDB 
    local affterHeroDB = _tbBreakInfo.breakAffterHeroDB

    fnSetLabel(labnPreHP , beforeForceValue.life)
    fnSetLabel(labnPrePhyAttack , beforeForceValue.physicalAttack)
    fnSetLabel(labnPreMagicAttack , beforeForceValue.magicAttack)
    fnSetLabel(labnPrePhyDefend , beforeForceValue.physicalDefend)
    fnSetLabel(labnPreMagicDefend , beforeForceValue.magicDefend)

    fnSetLabel(labnAfterHP , affterForceValue.life , true)
    fnSetLabel(labnAfterPhyAttack , affterForceValue.physicalAttack , true)
    fnSetLabel(labnAfterMagicAttack , affterForceValue.magicAttack , true)
    fnSetLabel(labnAfterPhyDefend , affterForceValue.physicalDefend , true)
    fnSetLabel(labnAfterMagicDefend , affterForceValue.magicDefend , true)

       
    labAwakeName:setText("")

    labAwakeNameString = _tbBreakInfo.awakeName
    labAwakeInfoString = _tbBreakInfo.awakeDes 

    local pColor = g_QulityColor2[affterHeroDB.star_lv]
    tfdScore:setColor(pColor)
    tfdScore:setText(m_i18n[1003])
    tfdScoreNum:setColor(pColor)
    tfdScoreNum:setText(affterHeroDB.heroQuality or 1)

      
    -- local heroSprite  = CCSprite:create(affterHeroDB.file)
    local heroSprite  = CCSprite:create("images/base/hero/body_img/" .. affterHeroDB.body_img_id)
    heroSprite:setPosition(ccp(layHeroModel:getContentSize().width/2,layHeroModel:getContentSize().height/2))
    heroSprite:setAnchorPoint(0.5,0)
    layHeroModel:setAnchorPoint(0,0.5)
    layHeroModel:addNode(heroSprite)

    local arr = CCArray:create()
    arr:addObject(CCScaleTo:create(1, 1.02))
    arr:addObject(CCScaleTo:create(1, 1.0))
    local  pSequence = CCSequence:create(arr)
    heroSprite:runAction(CCRepeatForever:create(pSequence))

end

local function createSuccess( ... )
    partner_transfer_succeed = mUILoad("ui/break_succeed.json")
    if (partner_transfer_succeed) then
        partner_transfer_succeed:setSize(g_winSize)

        if(g_winSize.width ~= 640) then
            local layBg = m_fnGetWidgetByName(partner_transfer_succeed, "img_partner_information_bg1")
            layBg:setScale(g_winSize.width/640)
            -- for i=1,3 do
            --     local layBg = m_fnGetWidgetByName(partner_transfer_succeed, "img_partner_information_bg" .. i)
            --     layBg:setScale(g_winSize.width/640)
            -- end
        end
    end

    local tfd_hp = m_fnGetWidgetByName(partner_transfer_succeed, "tfd_hp")
    UIHelper.labelNewStroke(tfd_hp, strokeCor,2)
    tfd_hp:setText(m_i18n[1047])
    local tfd_phy_attack = m_fnGetWidgetByName(partner_transfer_succeed, "tfd_phy_attack")
    UIHelper.labelNewStroke(tfd_phy_attack, strokeCor,2)
    tfd_phy_attack:setText(m_i18n[1048])
    local tfd_magic_attck = m_fnGetWidgetByName(partner_transfer_succeed, "tfd_magic_attck")
    UIHelper.labelNewStroke(tfd_magic_attck, strokeCor,2)
    tfd_magic_attck:setText(m_i18n[1049])
    local tfd_phy_denfend = m_fnGetWidgetByName(partner_transfer_succeed, "tfd_phy_denfend")
    UIHelper.labelNewStroke(tfd_phy_denfend, strokeCor,2)
    tfd_phy_denfend:setText(m_i18n[1050])
    local tfd_magic_denfend = m_fnGetWidgetByName(partner_transfer_succeed, "tfd_magic_denfend")
    UIHelper.labelNewStroke(tfd_magic_denfend, strokeCor,2)
    tfd_magic_denfend:setText(m_i18n[1051])


    --进阶前英雄数据
    labnPreHP = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_BEFORE_HP")
    labnPrePhyAttack = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_BEFORE_PHY_ATTACK")
    labnPreMagicAttack = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_BEFORE_MAGIC_ATTACK")
    labnPrePhyDefend = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_BEFORE_PHY_DENFEND")
    labnPreMagicDefend = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_BEFORE_MAGIC_DENFEND")

    --进阶后英雄数据
    labnAfterHP = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_AFTER_HP")
    labnAfterPhyAttack = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_AFTER_PHY_ATTACK")
    labnAfterMagicAttack = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_AFTER_MAGIC_ATTACK")
    labnAfterPhyDefend = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_AFTER_PHY_DENFEND")
    labnAfterMagicDefend = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_AFTER_MAGIC_DENFEND")

    --往右剪头图标
    imgHPRight = m_fnGetWidgetByName(partner_transfer_succeed, "IMG_HP_ARROW_RIGHT")
    imgPHYAttRight = m_fnGetWidgetByName(partner_transfer_succeed, "IMG_PHY_ATTACK_ARROW_RIGHT")
    imgMagicAttRight = m_fnGetWidgetByName(partner_transfer_succeed, "IMG_MAGIC_ATTACK_ARROW_RIGHT")
    imgPHYDenRight = m_fnGetWidgetByName(partner_transfer_succeed, "IMG_PHY_DENFEND_ARROW_RIGHT")
    imgMagicDenRight = m_fnGetWidgetByName(partner_transfer_succeed, "IMG_MAGIC_DENFEND_ARROW_RIGHT")
    

    layHeroModel = m_fnGetWidgetByName(partner_transfer_succeed, "LAY_HERO_MODEL")
    imgNewAwake = m_fnGetWidgetByName(partner_transfer_succeed, "img_new_awake")
    labAwakeName = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_ABILITY_NAME")
    labAwakeInfo = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_ABILITY_INFO")
    -- 新增潜能logo图片由左（-15）滑向向右（0）  透明度由0~100 的初始状态
    imgNewAwake:runAction(CCPlace:create(ccp(imgNewAwake:getPositionX() - 15 ,imgNewAwake:getPositionY())))
    imgNewAwake:setOpacity(0)


    labAwakeInfo:setText("")
    labAwakeName:setText("")

    UIHelper.labelNewStroke(labAwakeInfo)
    UIHelper.labelNewStroke(labAwakeName,ccc3(0xea,0x32,0x00),3)

    --labAwakeLimit = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_ABILITY_LIMIT")
    --tfdColor = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_COLOR")
    tfdScore = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_SCORE")
    tfdScoreNum = m_fnGetWidgetByName(partner_transfer_succeed, "TFD_SCORE_NUM")

    layTouch = Layout:create()
    layTouch:setSize(g_winSize)
    layTouch:setTouchEnabled(false)
    layTouch:addTouchEventListener(onBtnReturn)
    partner_transfer_succeed:addChild(layTouch)

    updateTransferInfo()
    createSuccedAction()

    LayerManager.addLayout(partner_transfer_succeed,nil,nil,nil,true)
end


function create( breakInfo)

    _tbBreakInfo = breakInfo
    -- local pLay = Layout:create()
    -- pLay:setSize(g_winSize)
    -- performWithDelay(pLay,function()
        createSuccess()
        -- end,0.01)
    -- return pLay
end
