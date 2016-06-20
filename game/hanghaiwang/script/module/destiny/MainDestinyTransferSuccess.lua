-- FileName: MainDestinyTransferSuccess.lua
-- Author: lizy
-- Date: 2014-04-00
-- Purpose: 天命模块进阶成功特效界面
--[[TODO List]]

module("MainDestinyTransferSuccess", package.seeall)
require "script/module/config/AudioHelper"
-- UI控件引用变量 --

-- 模块局部变量 --
-- vars
local m_layMain

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

--箭头
local imgHPRight
local imgPHYAttRight
local imgMagicAttRight
local imgPHYDenRight 
local imgMagicDenRight 

local transSucceedBg = 100
local transSucceedText = 101
local effectId


--进阶伙伴数据
local m_tbTransferInfo

local function init(...)

end

function destroy(...)
	package.loaded["MainDestinyTransferSuccess"] = nil
end

function moduleName()
	return "MainDestinyTransferSuccess"
end

local function onBtnReturn(sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		print("button touched")
		--AudioHelper.setEffect(false)
		if (effectId ~= nil ) then
			SimpleAudioEngine:sharedEngine():stopEffect(effectId)
		end
		LayerManager.removeLayout()
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

--箭头和突破后属性特效
local function fnStartNumAni( sender, MovementEventType, movementID )
    if (MovementEventType == 1) then
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
                pJiantou:runAction(CCSequence:create(pArr))
            end
        end
    end
end

--[[desc:功能简介
	“进阶成功” 特效  待替换  yangna 2015.2.13
—]]
local function succedTextAnimation( ... )
	AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
	local imgSucceed = g_fnGetWidgetByName(m_layMain, "img_transfer_succeed")
	imgSucceed:loadTexture("")

	-- local m_arAni1 = fnCreateAni("jinjie2_chenggong",nil,fnStartNumAni)
	local m_arAni1 = UIHelper.createArmatureNode({
			filePath = "images/effect/ship/chuan_shengji.ExportJson",
			animationName = "chuan_shengji",
			loop = -1,
			fnMovementCall = fnStartNumAni,
	})

	if (imgSucceed:getChildByTag(transSucceedText)) then
		imgSucceed:getChildByTag(transSucceedText):removeFromParentAndCleanup(true)
	end
	imgSucceed:addNode(m_arAni1,1000,transSucceedText)
end

-- 背景特效 新版本
local function addBgEffect( ... )
	effectId = AudioHelper.playEffect("audio/effect/texiao_jinjie_guangmang.mp3",true)
	local armature3 = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao3.ExportJson",
		animationName = "zhao3",
	})
	
	local img_effect = g_fnGetWidgetByName(m_layMain, "IMG_EFFECT")
	if (img_effect:getChildByTag(transSucceedBg)) then 
		imgEffect:getChildByTag(transSucceedBg):removeFromParentAndCleanup(true)
	end 
	img_effect:addNode(armature3,-1,transSucceedBg) 
end

local function createSuccedAction( ... )
	addBgEffect()

	performWithDelay(m_layMain,function()
        succedTextAnimation()
    end,0.5)
end


--[[desc:label更新内容
    label：
    text：更新的内容
    isVisible:设置label是否可见
    return: 是否有返回值，返回值说明  
—]]
local function fnSetLabel(label,text,isVisible)
	label:setText(text)
	label:setVisible(isVisible)
end 

--属性数值更新
local function updateTransferInfo( ... )
	fnSetLabel(labnPreHP,m_tbTransferInfo[1].life,true)
	fnSetLabel(labnPrePhyAttack,m_tbTransferInfo[1].phyAttack,true)
	fnSetLabel(labnPreMagicAttack,m_tbTransferInfo[1].magicAttack,true)
	fnSetLabel(labnPrePhyDefend,m_tbTransferInfo[1].phyDefned,true)
	fnSetLabel(labnPreMagicDefend,m_tbTransferInfo[1].magicDefend,true)

	fnSetLabel(labnAfterHP,m_tbTransferInfo[2].life,false)
	fnSetLabel(labnAfterPhyAttack,m_tbTransferInfo[2].phyAttack,false)
	fnSetLabel(labnAfterMagicAttack,m_tbTransferInfo[2].magicAttack,false)
	fnSetLabel(labnAfterPhyDefend,m_tbTransferInfo[2].phyDefned,false)
	fnSetLabel(labnAfterMagicDefend,m_tbTransferInfo[2].magicDefend,false)
end


function create( transferInfo)

	m_tbTransferInfo = transferInfo
	m_layMain = g_fnLoadUI("ui/ship_succeed.json")

	--进阶前英雄数据
	labnPreHP = g_fnGetWidgetByName(m_layMain, "TFD_BEFORE_HP")         --生命
	labnPrePhyAttack = g_fnGetWidgetByName(m_layMain, "TFD_BEFORE_PHY_ATTACK") 
	labnPreMagicAttack = g_fnGetWidgetByName(m_layMain, "TFD_BEFORE_MAGIC_ATTACK")
	labnPrePhyDefend = g_fnGetWidgetByName(m_layMain, "TFD_BEFORE_PHY_DENFEND") 
	labnPreMagicDefend = g_fnGetWidgetByName(m_layMain, "TFD_BEFORE_MAGIC_DENFEND")

	--进阶后英雄数
	labnAfterHP = g_fnGetWidgetByName(m_layMain, "TFD_AFTER_HP") 
	labnAfterPhyAttack = g_fnGetWidgetByName(m_layMain, "TFD_AFTER_PHY_ATTACK")
	labnAfterMagicAttack = g_fnGetWidgetByName(m_layMain, "TFD_AFTER_MAGIC_ATTACK")
	labnAfterPhyDefend = g_fnGetWidgetByName(m_layMain, "TFD_AFTER_PHY_DENFEND")
	labnAfterMagicDefend = g_fnGetWidgetByName(m_layMain, "TFD_AFTER_MAGIC_DENFEND")

	--箭头
	imgHPRight = g_fnGetWidgetByName(m_layMain, "IMG_HP_ARROW_RIGHT")
	imgPHYAttRight = g_fnGetWidgetByName(m_layMain, "IMG_PHY_ATTACK_ARROW_RIGHT")
	imgMagicAttRight = g_fnGetWidgetByName(m_layMain, "IMG_MAGIC_ATTACK_ARROW_RIGHT")
	imgPHYDenRight = g_fnGetWidgetByName(m_layMain, "IMG_PHY_DENFEND_ARROW_RIGHT")
	imgMagicDenRight = g_fnGetWidgetByName(m_layMain, "IMG_MAGIC_DENFEND_ARROW_RIGHT")

	--主船名字
	local imgGainShip = g_fnGetWidgetByName(m_layMain, "IMG_GAIN_SHIP")
	imgGainShip:loadTexture(m_tbTransferInfo[2].gainShipImg )

	local layTouch = Layout:create()
	layTouch:setSize(g_winSize)
	layTouch:setTouchEnabled(true)
	layTouch:addTouchEventListener(onBtnReturn)
	m_layMain:addChild(layTouch)

	updateTransferInfo()
	createSuccedAction()

	return m_layMain
end

