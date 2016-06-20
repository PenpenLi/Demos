-- FileName: PartnerTransSucceed.lua
-- Author: sunyunpeng
-- Date: 2015-12-18
-- Purpose: function description of module
--[[TODO List]]

module("PartnerTransSucceed", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _succeedInfo = {}
local _mainLayout
local m_i18n = gi18n
local m_i18nString = gi18nString
local strokeCor = ccc3( 0x28, 0x00, 0x00)
local _tbTFDAttrBeforeValue
local _tbTFDAttrAffterValue
local _tbArrow
local _shieldTouchLayout

local function init(...)

end

function destroy(...)
	package.loaded["PartnerTransSucceed"] = nil
end

function moduleName()
    return "PartnerTransSucceed"
end

-- 快速描边
local function lableStroke( widget )
      UIHelper.labelNewStroke(widget, strokeCor,2)
end 

local function onBtnReturn( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
        LayerManager.removeLayout()
        -- 移除战斗力提升动画
        MainFormationTools.removeFlyText()
        logger:debug("button touched")
     --------------------------- new guide begin -------------------------------------
         require "script/module/guide/GuideModel"
         require "script/module/guide/GuidePartnerAdvView"
         if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 3) then  
            require "script/module/guide/GuideCtrl"
            GuideCtrl.createPartnerAdvGuide(4)   
        end

        require "script/module/guide/GuideCopyBoxView"
        if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 8) then
            require "script/module/guide/GuideCtrl"
            GuideCtrl.createCopyBoxGuide(9)
        end
    ---------------------------- new guide end --------------------------------------
    end

end 

local function initBg( ... )
	_mainLayout = g_fnLoadUI("ui/partner_transfer_succeed.json")
	_mainLayout:setSize(g_winSize)

	local layBg = _mainLayout.img_partner_information_bg1
	layBg:setScale(g_winSize.width/640)

    _shieldTouchLayout = Layout:create()
    _shieldTouchLayout:setSize(g_winSize)
    _shieldTouchLayout:setTouchEnabled(false)
    _shieldTouchLayout:addTouchEventListener(onBtnReturn)
    _mainLayout:addChild(_shieldTouchLayout)

    require "script/module/guide/GuideModel"
     require "script/module/guide/GuidePartnerAdvView"
     if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 3) then  
        require "script/module/guide/GuideCtrl"
    end

end 

function fnCreateAni( pName , ploop , callback)
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
   
local function fnStartNumAni( sender, MovementEventType, movementID )
    if (MovementEventType == 1) then
        AudioHelper.playEffect("audio/effect/texiao_jinjie_shuzi.mp3")
        for i=1,6 do 
            local pJiantou = _mainLayout[_tbArrow[i]]
            if(pJiantou) then
                local pArr = CCArray:create()
                if(i ~= 1) then
                    pArr:addObject(CCDelayTime:create(0.05*(i-1)))
                end
                pArr:addObject(CCCallFuncN:create(function()
                    pJiantou:addNode(fnCreateAni("jinjie_zhizhen"))
                    local tfdAffterAttr = _mainLayout[_tbTFDAttrAffterValue[i]]
                    if(tfdAffterAttr) then
                        tfdAffterAttr:setVisible(true)
                        local pAni = fnCreateAni("jinjie_shuzi")
                        pAni:setPositionX(tfdAffterAttr:getContentSize().width*0.5)
                        tfdAffterAttr:addNode(pAni)
                    end
                end))
                if(i == #_tbArrow) then
                    pArr:addObject(CCDelayTime:create(1))
                    pArr:addObject(CCCallFuncN:create(function()
                    _shieldTouchLayout:setTouchEnabled(true)
                    -- 战斗力提升动画
                    MainFormationTools.fnShowFightForceChangeAni()
                end))
                end
                pJiantou:runAction(CCSequence:create(pArr))
            end
        end
    end
end


-- 开始播放成功动画
local function initSucceedAni( ... )
	AudioHelper.playEffect("audio/effect/texiao_zhandoushengli.mp3")
    local imgSucceed = _mainLayout.img_transfer_succeed
    imgSucceed:loadTexture("")
    local m_arAni1 = fnCreateAni("jinjie_chenggong" , 0 , fnStartNumAni)
    imgSucceed:removeAllNodes()

    imgSucceed:addNode(m_arAni1)
    local m_arAni2 = fnCreateAni("jinjie_faguang" )
    imgSucceed:addNode(m_arAni2)

end 


-- 初始化属性部分
local function initLayProperty( ... )
	local layTransferProperty = _mainLayout.lay_transfer_property
	local beforeForceValue = _succeedInfo.beforeForceValue 
    local affterForceValue = _succeedInfo.affterForceValue 
    ---------------------------------汉字部分-----------------------------
    local tbAttrName = {m_i18n[1112],m_i18n[1047],m_i18n[1048],m_i18n[1049],m_i18n[1050],m_i18n[1051]}
	local tbTFDattrName = {"tfd_level", "tfd_hp","tfd_phy_attack","tfd_magic_attck","tfd_phy_denfend","tfd_magic_denfend"}
	
	for i=1,6 do
		local tfdAttrName = layTransferProperty[tbTFDattrName[i]]
		tfdAttrName:setText(tbAttrName[i])
    	lableStroke(tfdAttrName)
	end
	-------------------------------- 战斗力数值部分 ---------------------------------------
	local beforeEvolveLel = tonumber(_succeedInfo.heroInfo.evolve_level)
	local affterEvolveLel = beforeEvolveLel + 1

	local tbBeforForceValue = {beforeEvolveLel,beforeForceValue.life,beforeForceValue.physicalAttack,beforeForceValue.magicAttack,beforeForceValue.physicalDefend,beforeForceValue.magicDefend}
	local tbAffterForceValue = {affterEvolveLel,affterForceValue.life,affterForceValue.physicalAttack,affterForceValue.magicAttack,affterForceValue.physicalDefend,affterForceValue.magicDefend}

	_tbTFDAttrBeforeValue = {"TFD_BEFORE_LEVEL","TFD_BEFORE_HP","TFD_BEFORE_PHY_ATTACK",
									"TFD_BEFORE_MAGIC_ATTACK","TFD_BEFORE_PHY_DENFEND","TFD_BEFORE_MAGIC_DENFEND"}

	_tbTFDAttrAffterValue = {"TFD_AFTER_LEVEL","TFD_AFTER_HP", "TFD_AFTER_PHY_ATTACK",
								"TFD_AFTER_MAGIC_ATTACK","TFD_AFTER_PHY_DENFEND","TFD_AFTER_MAGIC_DENFEND"}
	
	for i=1,6 do
		local tfdBeforeTxt = layTransferProperty[_tbTFDAttrBeforeValue[i]]
		local tfdAffterTxt = layTransferProperty[_tbTFDAttrAffterValue[i]]

    	tfdBeforeTxt:setText(tbBeforForceValue[i])
    	tfdAffterTxt:setText(tbAffterForceValue[i])

    	lableStroke(tfdBeforeTxt)
    	lableStroke(tfdAffterTxt)

    	tfdAffterTxt:setVisible(false)

	end
	----------------------------- 箭头 ---------------------------------------------------
	_tbArrow = {"IMG_LEVEL_ARROW_RIGHT","IMG_HP_ARROW_RIGHT","IMG_PHY_ATTACK_ARROW_RIGHT",
						"IMG_MAGIC_ATTACK_ARROW_RIGHT","IMG_PHY_DENFEND_ARROW_RIGHT","IMG_MAGIC_DENFEND_ARROW_RIGHT"}
end 

local function bgAnimation( ... )
    local imgEffect = _mainLayout.lay_transfer_succeed_model
    local waveNode = CCParticleSystemQuad:create("images/effect/jinjie_guangmang/guangxing.plist")
    waveNode:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))
    imgEffect:removeAllNodes()

    imgEffect:addNode(waveNode)
    local m_arAni1 = UIHelper.createArmatureNode({
            filePath = "images/effect/shop_recruit/zhao3.ExportJson",
            animationName = "zhao3",
            loop = -1
            }
        )
    m_arAni1:setPosition(ccp(imgEffect:getContentSize().width / 2,imgEffect:getContentSize().height / 2))
    imgEffect:addNode(m_arAni1)
end


function initModel(  )
   	local transAffterHeroDB = _succeedInfo.transAffterHeroDB 
   	------
    layHeroModel = _mainLayout.LAY_HERO_MODEL

	local heroSprite  = CCSprite:create("images/base/hero/body_img/" .. transAffterHeroDB.body_img_id)
    heroSprite:setPosition(ccp(layHeroModel:getContentSize().width/2,layHeroModel:getContentSize().height/2))
    heroSprite:setAnchorPoint(0.5,0)
    layHeroModel:setAnchorPoint(0,0.5)
    layHeroModel:addNode(heroSprite)

    local arr = CCArray:create()
    arr:addObject(CCScaleTo:create(1, 1.02))
    arr:addObject(CCScaleTo:create(1, 1.0))
    local  pSequence = CCSequence:create(arr)
    heroSprite:runAction(CCRepeatForever:create(pSequence))

   	-- 新增潜能logo图片由左（-15）滑向向右（0）  透明度由0~100 的初始状态
    local labAwakeName = _mainLayout.TFD_TRANSFER_AWAKE
    labAwakeName:setText(_succeedInfo.awakeName or m_i18n[1093])

    UIHelper.labelNewStroke(labAwakeName,ccc3(0xea,0x32,0x00),3)

    local labAwakeDesc = _mainLayout.TFD_AWAKE_DESC
    labAwakeDesc:setText(_succeedInfo.awakeDes or "")
    UIHelper.labelNewStroke(labAwakeDesc,ccc3(0x28,0x00,0x00),2)

    performWithDelay(_mainLayout,function()
        initSucceedAni()
    end,0.5)

end

function create( succeedInfo )
	_succeedInfo = succeedInfo
    logger:debug({_succeedInfo=succeedInfo})
    initBg()
    initModel(  )
    initLayProperty()
    -- initSucceedAni()
    LayerManager.addLayout(_mainLayout)
end
