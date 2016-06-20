-- FileName: treaForgeView.lua
-- Author: menghao
-- Date: 2014-05-16
-- Purpose: 宝物强化view


module("treaForgeView", package.seeall)
require "script/module/config/AudioHelper"

-- UI控件引用变量 --
local m_UIMain

local m_btnColse
local m_btnForge
local m_btnAutoAdd

local m_tbTfdAddNum 		-- 闪烁的属性

local m_imgTreasure
local m_imgClassBG
local m_tfdName
local m_labnPinji
local m_tfdRefineLv

local m_tfdLv
local m_tfdLv2

local m_tfdBelly
local m_tfdExp

local m_tfdExpPercent
local m_imgBarBG
local m_loadExp

local _expGressAniStatus = 1
local _mainAniStatus = 1


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n
local m_i18nString = gi18nString
local runningScene = CCDirector:sharedDirector():getRunningScene()

local m_tbTreasureInfo
local m_tbSelectedTreaInfo

local m_armatureDa
local m_tbImgTreaCost
local m_imgArmInitPos


local function init(...)

end


function destroy(...)
	runningScene:removeChildByTag(1111)
	package.loaded["treaForgeView"] = nil

end


function moduleName()
	return "treaForgeView"
end


function guangzhen( img, strName,ZOrder )
	local armature
	if (strName == "da") then
		armature = g_attribManager:createGuangZhen_Da({
			loop = -1,
		})
	elseif (strName == "xiao") then
		armature = g_attribManager:createGuangZhen_Xiao({
			loop = -1,
		})
	elseif (strName == "xiao_wu") then
		armature = g_attribManager:createGuangZhen_XiaoWu({
			loop = -1,
		})
	elseif (strName == "xiao_wu2") then
		armature = g_attribManager:createGuangZhen_XiaoWu2({
			loop = -1,
		})
	end

	img:addNode(armature,ZOrder or 0)
	return armature
end


function showFade(addLevel, expPercent, tbAddNum, curLevel, curPercent)
	local barFade
	local tfdPercentFade

	local imgBarFilePath = "ui/hero_strengthen_progress_green.png"
	if addLevel > 0 then
		barFade = UIHelper.fadeInAndOutBar(100, 1, 1, 0, imgBarFilePath)
		tfdPercentFade = UIHelper.createBlinkLabel({
			fontSize = 18, strokeColor = ccc3(32,0,0),
			text1 = curPercent .. "%", color1 = ccc3(255,255,255),
			text2 = "100%", color2 = ccc3(255,255,255)
		})
		for i=1,#tbAddNum do
			local tfdFade = UIHelper.createBlinkLabel({text1 = "(+" .. tbAddNum[i] .. ")", color1 = ccc3( 0x00, 0x89, 0x00), fontName = g_sFontCuYuan,fontSize = 22})
			tfdFade:setAnchorPoint(0, 0.5)
			m_tbTfdAddNum[i]:addNode(tfdFade)
		end
		local labelLV = UIHelper.createBlinkLabel({text1 = "+" .. tostring(addLevel), color1 = ccc3(0x00,0xff,0x00),fontName = g_sFontCuYuan ,fontSize = 22})
		--local labelLV2 = UIHelper.createBlinkLabel({text1 = curLevel, fontSize = 22, text2 = tostring(curLevel + addLevel), color2 = ccc3(26,134,5)})
		local addSprite = UIHelper.fadeInAndOutImage("images/base/treas_frag/add_green.png", 1, 1)
		m_tfdLv:setText(curLevel)
		--m_tfdLv2:setText(" ")
		
		m_tfdlvadd:addNode(labelLV)
	
		
		--m_tfdLv2:addNode(labelLV2)
	else
		barFade = UIHelper.fadeInAndOutBar(expPercent, 1, 1, 0, imgBarFilePath)
		tfdPercentFade = UIHelper.createBlinkLabel({
			fontSize = 18, strokeColor = ccc3(32,0,0),
			text1 = curPercent .. "%", color1 = ccc3(255,255,0),
			text2 = expPercent .. "%", color2 = ccc3(255,255,0)
		})
		m_tfdLv:setText(curLevel)
		--m_tfdLv2:setText(curLevel)
	end
	local x, y = m_tfdExpPercent:getPosition()
	m_tfdExpPercent:setEnabled(false)
	tfdPercentFade:setPosition(ccp(x, y))
	tfdPercentFade:setAnchorPoint(ccp(1, 0.5))

	m_imgBarBG:addNode(tfdPercentFade, 10)
	m_imgBarBG:addNode(barFade)
	m_loadExp:setZOrder(2)
end



-- 更新贝里和经验显示
function updateSliverAndExpDisplay( expNum, sliverNum )
	m_tfdExp:setText(tostring(expNum))
	m_tfdBelly:setText(tostring(sliverNum))
end


-- 强化完成后移除选择上的宝物图片,还有重新选择宝物后
function removeSelectedUI( ... )
	for i=1,5 do
		local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)
		local imgArm = m_fnGetWidget(imgCost, "IMG_ARM1")
		local imgChoose = m_fnGetWidget(imgCost, "IMG_CHOOSE")

		imgCost:removeAllNodes()
		--imgArm:removeAllChildren()
		imgArm:loadTexture("ui/transfer_arrow_right.png")
		imgChoose:setEnabled(true)
	end
	m_tfdBelly:setText(0)
	m_tfdExp:setText(0)

	-- 移除渐隐渐现效果
	for i=1,2 do
		m_tbTfdAddNum[i]:removeAllNodes()
	end
	m_imgBarBG:removeAllNodes()

	m_tfdlvadd:removeAllNodes()

end


-- 更新UI在添加宝物时
function updateUIForAddTreas( tbTreaInfo )

	m_tbSelectedTreaInfo = tbTreaInfo
	removeSelectedUI()
	for i=1,#m_tbSelectedTreaInfo do
		local imgFilePath = "images/base/treas/big/" .. tbTreaInfo[i].itemDesc.icon_big

		local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)
		local imgArm = m_fnGetWidget(imgCost, "IMG_ARM1")
		local imgChoose = m_fnGetWidget(imgCost, "IMG_CHOOSE")

		imgArm:loadTexture(imgFilePath)
		m_tbImgTreaCost[i] = imgArm
		imgChoose:setEnabled(false)

		imgArm:stopAllActions()
		imgArm:setPosition(m_imgArmInitPos[i])
		EffTreaForge:new():smallTreaEff(imgArm)
		guangzhen(imgCost, "xiao")
	end
	for i = #m_tbSelectedTreaInfo + 1, 5 do
		local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)
		guangzhen(imgCost, "xiao_wu")
	end
end


function showAnimation( lv, attrText, callback)
	AudioHelper.playEffect("audio/effect/texiao_baowu_qianghua.mp3")

	_mainAniStatus = 0
	_expGressAniStatus = 0
    for i = 1, 5 do
		local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)
		guangzhen(imgCost, "xiao_wu2")
	end

	-- 属性的变化
	local function showAttrChangeAnimation()
		require "script/utils/LevelUpUtil"
		LevelUpUtil.showFlyText(attrText, function ( ... )
			-- if (m_tbTreasureInfo.treaData.equip_hid and tonumber(m_tbTreasureInfo.treaData.equip_hid)>0) then
			if (m_tbTreasureInfo.equip_hid and tonumber(m_tbTreasureInfo.equip_hid)>0) then
				local tBefore, tAfter = treaForgeCtrl.getTbForMaster()
				local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore, tAfter, 3)
				if (showString) then
					AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
					local armature = g_attribManager:createTreaStrMasterEffect({
						level = tAfter[tonumber(3)],
						fnMovementCall = function ( sender, MovementEventType, frameEventName )
							if MovementEventType == 1 then
								sender:removeFromParentAndCleanup(true)
								local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString,nil,function ( ... )
									-- 战斗力提升动画、
									MainFormationTools.removeFlyText()
									MainFormationTools.fnShowFightForceChangeAni()
								end)
								if (node) then
									runningScene:addChild(node, 99999)
								end
							end
						end,
					})
					armature:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
					runningScene:addChild(armature)
				else
					-- 战斗力提升动画、
					MainFormationTools.removeFlyText()
					MainFormationTools.fnShowFightForceChangeAni()
				end
			end
		end,nil,nil)
	end

	local function removeSelf( sender, MovementEventType, frameEventName )
		if MovementEventType == 1 then
			sender:removeFromParentAndCleanup(true)
			
		end
	end

	-- 强化成功显示等级动画
	local function showForgeLevel( ... )
		if (lv <= 0) then
			return
		end
		AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
		-- AudioHelper.playEffect("audio/effect/texiao_tishengXji.mp3")
		local armature = g_attribManager:createAddLevelEffect({
			level = lv,
			fnMovementCall = removeSelf,
		})
		
		armature:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2 + 100))
		m_UIMain:addNode(armature)
	end

	-- 强化成功动画
	local function showSuccess( ... )
		AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
		local armature = g_attribManager:createStrenOKEffect({
			fnMovementCall = removeSelf,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				showForgeLevel()
				showAttrChangeAnimation()
				updateUIForAddTreas({})
			end
		})

		armature:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2 + 200))
		m_UIMain:addNode(armature)
	end

	local tbPos1 = {ccp(-25,6), ccp(-19,18), ccp(0,28), ccp(25,27), ccp(34,13)}
	local tbPos2 = {ccp(256,-57), ccp(145,-144), ccp(0,-179), ccp(-151,-143), ccp(-194,-59)}

	m_armatureDa:getAnimation():pause()
	local imgTreaMain = m_fnGetWidget(m_UIMain, "IMG_MAGIC_TREASURE_MAIN")

	-- 强化动画，第二个参数为第46帧的事件
	local treaSprite = m_imgTreasure:getNodeByTag(4444)

	local function frameEvent1(  )
		local nowTreaPosY = treaSprite:getPositionY()
		local UpDistance = 75 - nowTreaPosY

		for i = 1, 5 do
			local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)
			guangzhen(imgCost, "xiao_wu2")
		end
		local actionArr = CCArray:create()

		actionArr:addObject(CCCallFunc:create(function ( ... )
			local zhao3 = UIHelper.createArmatureNode({
				filePath = "images/effect/shop_recruit/zhao3.ExportJson",
				animationName = "zhao3",
				bRetain = true,
				loop = 0,
				fnMovementCall = function ( sender, MovementEventType, movementID )
                    if(MovementEventType == 1) then
                        sender:removeFromParentAndCleanup(true)
                    end
                end,
			})
			local treaSpriteSize = treaSprite:getContentSize()
			zhao3:setPosition(ccp(0.5* treaSpriteSize.width,0.5 * treaSpriteSize.height))
			zhao3:setTag(3333)
			zhao3:setScale(0.8)
			treaSprite:removeChildByTag(3333,true)
			treaSprite:addChild(zhao3,-99999) 
		end))

		actionArr:addObject(
			CCSpawn:createWithTwoActions(
				CCScaleTo:create(5 / 60, 1.20),
				CCMoveBy:create(5 / 60, ccp(0, UpDistance))
			)
		)

		treaSprite:stopAllActions()
		treaSprite:runAction(CCSequence:create(actionArr))

	end

	local function frameEvent2( ... )
		showSuccess()
	end

	local function frameEvent3( ... )
		local actionArr = CCArray:create()

		local  qhying= UIHelper.createArmatureNode({
			filePath = "images/effect/hero_qh/qh_xing/qh_xing.ExportJson",
			animationName = "qh_xing",
			bRetain = true,
			loop = 0
			})
		imgTreaMain:addNode(qhying,99999) 
		-- actionArr:addObject(
		-- 	CCDelayTime:create(30/60)
		-- )

		-- actionArr:addObject(
		-- 	CCCallFunc:create(function ( ... )
		-- 		treaSprite:removeChildByTag(3333,true)
		-- 	end)
		-- 	)
		actionArr:addObject(
			CCSpawn:createWithTwoActions(
				CCScaleTo:create(3 / 60, 0.9),
				CCMoveBy:create(3 / 60, ccp(0, -75))
			)
		)
        actionArr:addObject(CCScaleTo:create(1/5, 1))

		actionArr:addObject(CCCallFunc:create(function ( ... )
			_mainAniStatus = 1
			m_armatureDa:getAnimation():resume()
			EffTreaForge:new():bigTreaEff(treaSprite)
			callback()
			if (_expGressAniStatus == 1) then
				LayerManager.removeLayout()
			end
		end))
		actionArr:addObject(CCDelayTime:create(0.1))

		treaSprite:stopAllActions()
		treaSprite:runAction(CCSequence:create(actionArr))
	end 

	for i=1,#m_tbSelectedTreaInfo do
		local actionArr = CCArray:create()
		local initPosX = m_tbImgTreaCost[i]:getPositionX()
		local initPosY = m_tbImgTreaCost[i]:getPositionY()

		actionArr:addObject(CCMoveBy:create(15 / 60, tbPos1[i]))
		actionArr:addObject(CCMoveBy:create(8 / 60, tbPos2[i]))
		actionArr:addObject(CCCallFunc:create(function ( ... )
			m_tbImgTreaCost[i]:loadTexture("ui/transfer_arrow_right.png")
			m_tbImgTreaCost[i]:setPosition(ccp(initPosX,initPosY))
		end))

		m_tbImgTreaCost[i]:runAction(CCSequence:create(actionArr))
	end

	local actionArr = CCArray:create()
	actionArr:addObject(CCDelayTime:create(13 / 60))
	actionArr:addObject(CCCallFunc:create(function ( ... )
		EffTreaForge:new():qianghuaHechengDa(imgTreaMain,frameEvent1,frameEvent2,frameEvent3)
	end))

	imgTreaMain:runAction( CCSequence:create(actionArr))

end


-- 初始化UI或强化后更新信息
function updateUIByTreaInfo( tbTreasureInfo, addLv )
	m_tbImgTreaCost = {}
	m_tbTreasureInfo = tbTreasureInfo
	-- 宝物信息部分
	--m_tfdLv2:setText(tbTreasureInfo.level)
	--属性
	local tbProperty = m_tbTreasureInfo.property
	for i=1,2 do
		local tfdAttr
		local tfdNum
		if i <= 3 then
			tfdAttr = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. i)
			tfdNum = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. i .. "_NUM")
		else
			tfdAttr = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. (i + 5))
			tfdNum = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. (i + 5) .. "_NUM")
		end

		if (i <= #tbProperty) then
			tfdAttr:setText(tbProperty[i].name)
			tfdNum:setText("+" .. tbProperty[i].value)
		else
			tfdAttr:setVisible(false)
			tfdNum:setVisible(false)
		end
	end
	--解锁技能
	local TFD_ABILITY = m_UIMain.TFD_ABILITY  -- 
	local IMG_ABILITY = m_UIMain.IMG_ABILITY  --

	local forgeUnlock = m_tbTreasureInfo.forgeUnlock 
	local curLevel = tonumber(tbTreasureInfo.va_item_text.treasureLevel)

	local initunLockLevel = 0

	local forgeUnlockTb = {}
	

	for i,v in ipairs(forgeUnlock or {}) do
		local unLockLevel = tonumber(v.unLockLevel)
		if (unLockLevel ~= 0) then
			initunLockLevel = initunLockLevel == 0 and unLockLevel
			table.insert(forgeUnlockTb,v)
		end
	end

	local desStrTb = {}
	local desStrLel = {}


	-- if (#forgeUnlockTb == 0) then
	-- 	return
	-- end

	for i,v in ipairs(forgeUnlockTb or {}) do
		local unLockLevel = tonumber(v.unLockLevel)

		if (not desStrTb[unLockLevel]) then
			desStrTb[unLockLevel] = {}
		end
		table.insert(desStrTb[unLockLevel], v)
	end

	for k,v in pairs(desStrTb) do
		table.insert(desStrLel, k)
	end

    table.sort(
    			desStrLel, function (a,b) return tonumber(a) < tonumber(b) end
        	   )

	local desString = ""

	for k,v in pairs(desStrLel or {}) do
		if (tonumber(curLevel) < tonumber(v)) then
			local tempDesTB = desStrTb[v]
			for i,tempDesInfo in ipairs(tempDesTB or {}) do
				local displayName = tempDesInfo.baseInfo.displayName
				local displayNum = tempDesInfo.displayNum

				if (i > 1) then
					desString = desString .. ","
				end
				desString = desString .. displayName .. "+" .. displayNum 
			end
			desString = desString .. "(" .. m_i18nString(1141,v)   .. ")"
			break
		end
	end

	if (desString and desString ~= "" ) then
		IMG_ABILITY:setEnabled(true)
		TFD_ABILITY:setEnabled(true)
		TFD_ABILITY:setText(desString )
	else
		IMG_ABILITY:setEnabled(false)
		TFD_ABILITY:setEnabled(false)
	end


	--解锁属性
	local tbExtPro = treaInfoModel.fnGetUnlockInfo(tbTreasureInfo.itemDesc.id) -- tbTreasureInfo.ext_active
	for k=1,5 do
		local i = k
		if (k >= 3) then
			i = k + 4
		end
		local tfdAttr = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. i + 4)
		local tfdNum = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. i + 4 .. "_NUM")
		local tfdNeed = m_fnGetWidget(m_UIMain,"TFD_ATTR" .. i + 4 .. "_NEED")

		if ( k <= #tbExtPro) then
			tfdAttr:setText(tbExtPro[k].name)
			tfdNum:setText("+" .. tbExtPro[k].value)
			tfdNeed:setText(gi18nString(1712, tbExtPro[k].openLv))

			local openColor1 = ccc3( 0xff, 0xea, 0x00 )
			local openColor2 = ccc3( 0xff, 0xff, 0xff )
			local closeColor = ccc3( 0x97, 0x97, 0x97 )

			if (tbExtPro[k].isOpen) then
				tfdAttr:setColor(openColor1)
				tfdNum:setColor(openColor2)
				tfdNeed:setColor(openColor2)
			else
				tfdAttr:setColor(closeColor)
				tfdNum:setColor(closeColor)
				tfdNeed:setColor(closeColor)
			end
		else
			tfdAttr:setVisible(false)
			tfdNum:setVisible(false)
			tfdNeed:setVisible(false)
		end
	end

	local nPercent = tbTreasureInfo.expPercent > 100 and 100 or tbTreasureInfo.expPercent
	m_tfdExpPercent:setText(nPercent .. "%")
	UIHelper.labelNewStroke(m_tfdExpPercent , ccc3( 0x59 , 0x1f, 0x00))

	-- 进度条动画，放在这里
	local oldPercent = m_loadExp:getPercent()
	if (addLv) then
		local advanceLv = addLv
		local function loadBarAction( num )
			local actionArr = CCArray:create()
			actionArr:addObject(CCDelayTime:create(0.0001))
			actionArr:addObject(CCCallFunc:create(function ( ... )
				if (num >= nPercent and advanceLv == 0) then
					m_loadExp:setPercent(nPercent)
					--m_tfdLv:setText(tbTreasureInfo.level)
					m_tfdExpPercent:setEnabled(true)
					_expGressAniStatus = 1
					if (_mainAniStatus == 1) then
						LayerManager.removeLayout()
					end
					return
				end
				if (num) > 100 then
					m_loadExp:setPercent(100)
					advanceLv = advanceLv - 1
					local oldLv = m_tfdLv:getStringValue()
					--m_tfdLv:setText(oldLv + 1)

					loadBarAction(0)
				else
					m_loadExp:setPercent(num)
					loadBarAction(num + addLv * 3 + 6)
				end
			end))

			m_loadExp:runAction(CCSequence:create(actionArr))


		end

		loadBarAction(oldPercent)
		if (tonumber(addLv) ~= 0) then
			-- LevelUpUtil.fnPlayOneNumNoRandomChangeAni(m_tfdLv,tbTreasureInfo.level - addLv,addLv)
			LevelUpUtil.fnPlayOneNumNoRandomChangeAni(m_tfdLv,tbTreasureInfo.va_item_text.treasureLevel - addLv,addLv)

		end
		
	else
		m_loadExp:setPercent(nPercent)
		-- m_tfdLv:setText(tbTreasureInfo.level)
		m_tfdLv:setText(tbTreasureInfo.va_item_text.treasureLevel)
		m_tfdExpPercent:setEnabled(true)
	end
end



-- 预先加载动画缓存
local function preLoadAnimate(  )
    UIHelper.createArmatureNode({
        filePath = "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
        bRetain =  true
     })

    UIHelper.createArmatureNode({
        filePath = "images/effect/forge/qh3_3/qh3_3.ExportJson",
        bRetain =  true
    })

    -- UIHelper.createArmatureNode({
    --     filePath = "images/effect/forge/qh3/qh3.ExportJson",
    --     bRetain =  true
    -- })

    UIHelper.createArmatureNode({
        filePath = "images/effect/hero_qh/qh_xing/qh_xing.ExportJson",
        bRetain =  true
    })

    UIHelper.createArmatureNode({
        filePath = "images/effect/shop_recruit/zhao3.ExportJson",
        bRetain =  true
     })
end 


function create(tbTreasureInfo, srcType, tbEventListener)
	_expGressAniStatus = 1
	_mainAniStatus = 1

	m_tbSelectedTreaInfo = nil
	m_tbTreasureInfo = tbTreasureInfo
	m_tbImgTreaCost = {}
	m_imgArmInitPos = {}

	m_UIMain = g_fnLoadUI("ui/treasure_strengthen.json")

	local layTest = m_fnGetWidget(m_UIMain, "LAY_TEST")
	local sizeTest = layTest:getSize()
	layTest:setSize(CCSizeMake(sizeTest.width * g_fScaleX, sizeTest.height * g_fScaleX))

	local imgBG = m_fnGetWidget(m_UIMain, "IMG_BG")
	imgBG:setScale(g_fScaleX)

	-- 获取各控件
	m_btnColse = m_fnGetWidget(m_UIMain,"BTN_CLOSE")
	m_btnForge = m_fnGetWidget(m_UIMain, "BTN_STRENGTHEN")
	m_btnAutoAdd = m_fnGetWidget(m_UIMain, "BTN_AUTOADD")

	for i=1,5 do
		local imgCost = m_fnGetWidget(m_UIMain, "img_cost" .. i)

		local imgArm = m_fnGetWidget(imgCost, "IMG_ARM1")
		local imgChoose = m_fnGetWidget(imgCost, "IMG_CHOOSE")
		imgArm:setZOrder(33)
		local imgArmInitPosX = imgArm:getPositionX()
		local imgArmInitPosY = imgArm:getPositionY()

		table.insert(m_imgArmInitPos,ccp(imgArmInitPosX,imgArmInitPosY))

		imgCost:setTouchEnabled(true)
		imgCost:addTouchEventListener(tbEventListener.onChoose)

		guangzhen(imgCost, "xiao_wu")
	end

	m_tbTfdAddNum = {}
	for i=1,2 do
		if i <= 3 then
			m_tbTfdAddNum[i] = m_fnGetWidget(m_UIMain, "TFD_ATTR".. i .. "_NUM_AFTER")
		else
			m_tbTfdAddNum[i] = m_fnGetWidget(m_UIMain, "TFD_ATTR".. (i + 5) .. "_NUM_AFTER")
		end
		m_tbTfdAddNum[i]:setText("")
	end

	m_imgTreasure = m_fnGetWidget(m_UIMain, "IMG_ARM")
	m_imgClassBG = m_fnGetWidget(m_UIMain, "IMG_CLASS_BG")
	m_tfdName = m_fnGetWidget(m_UIMain, "TFD_NAME1")
	m_labnPinji = m_fnGetWidget(m_UIMain, "LABN_PINJI")

	m_tfdRefineLv = m_fnGetWidget(m_UIMain, "TFD_REFINE_LV")

	m_tfdLv = m_fnGetWidget(m_UIMain, "TFD_LV")
    UIHelper.labelNewStroke(m_tfdLv , ccc3( 0xd6 , 0x0c , 0x06))

    m_tfdlvadd = m_fnGetWidget(m_UIMain, "TFD_LV_ADD")
    m_tfdlvadd:setText("")

    --UIHelper.labelNewStroke(m_tfdlvadd , ccc3( 0xd6 , 0x0c , 0x06))

	--m_tfdLv2 = m_fnGetWidget(m_UIMain, "TFD_LV2")

	m_tfdBelly = m_fnGetWidget(m_UIMain, "TFD_BELLY")
	m_tfdExp = m_fnGetWidget(m_UIMain, "TFD_GAIN_EXP")
	UIHelper.labelNewStroke(m_tfdExp , ccc3( 0x59 , 0x1f , 0x00))

	m_tfdExpPercent = m_fnGetWidget(m_UIMain, "tfd_exp_percent")
	m_imgBarBG = m_fnGetWidget(m_UIMain, "img_barbg")
	m_loadExp = m_fnGetWidget(m_UIMain, "LOAD_EXP")
	local loadExpGreen = m_fnGetWidget(m_UIMain, "LOAD_EXP_EFFECT")
	loadExpGreen:setEnabled(false)

	-- 控件事件
	m_btnColse:addTouchEventListener(tbEventListener.onClose)
	m_btnForge:addTouchEventListener(tbEventListener.onForge)
	m_btnAutoAdd:addTouchEventListener(tbEventListener.onAutoAdd)

	-- 根据实际信息改变控件
	-- 宝物图片部分
	local tbTreasureDbInfo = m_tbTreasureInfo.itemDesc
	-- m_imgTreasure:loadTexture(tbTreasureInfo.icon_big)
	-- m_imgTreasure:loadTexture("images/base/treas/big/" ..tbTreasureDbInfo.icon_big)
	local treaSprite = CCSprite:create("images/base/treas/big/" ..tbTreasureDbInfo.icon_big)
	m_imgTreasure:addNode(treaSprite)
	treaSprite:setTag(4444)

	EffTreaForge:new():bigTreaEff(treaSprite)

	local imgTreaMain = m_fnGetWidget(m_UIMain, "IMG_MAGIC_TREASURE_MAIN")
	m_armatureDa = guangzhen(imgTreaMain, "da")
	EffTreaForge:new():lizi(m_imgTreasure)


	if (tbTreasureDbInfo.isExpTreasure) then
		m_imgClassBG:loadTexture("images/item/equipinfo/card/trea_type_0.png")
	else
		local n = (tonumber(tbTreasureDbInfo.type) == 0) and 3 or tbTreasureDbInfo.type
		m_imgClassBG:loadTexture("images/item/equipinfo/card/trea_type_" .. n .. ".png")
	end
	m_tfdName:setText(tbTreasureDbInfo.name)
	m_tfdName:setColor(g_QulityColor2[tonumber(tbTreasureDbInfo.quality)])
	UIHelper.labelNewStroke(m_tfdName)
	m_labnPinji:setStringValue(tbTreasureDbInfo.base_score)

	-- if (tbTreasureInfo.treaEvolve[1].lv) then
	-- 	m_tfdRefineLv:setText("+" .. tbTreasureInfo.treaEvolve[1].lv)
	-- else
	if (tbTreasureInfo.va_item_text.treasureEvolve) then
		m_tfdRefineLv:setText("+" .. tbTreasureInfo.va_item_text.treasureEvolve)
	else
		m_tfdRefineLv:setEnabled(false)
	end
	UIHelper.labelNewStroke(m_tfdRefineLv)

	local tmp = tonumber(tbTreasureDbInfo.quality)
	for i = tmp + 1, 5 do
		local imgStar = m_fnGetWidget(m_UIMain, "IMG_STAR_" .. i)
		imgStar:setEnabled(false)
	end

	-- 国际化文本
	UIHelper.titleShadow(m_btnColse, mi18n[1019])
	UIHelper.titleShadow(m_btnForge, mi18n[1054])
	UIHelper.titleShadow(m_btnAutoAdd, mi18n[1055])

	local labelExp = m_fnGetWidget(m_UIMain, "tfd_exp")
	UIHelper.labelNewStroke(labelExp , ccc3( 0x59 , 0x1f, 0x00))
	local labelAttr = m_fnGetWidget(m_UIMain, "tfd_attr")
	local labelAttrT = m_fnGetWidget(m_UIMain, "tfd_attr_title")

	local layConsume = m_fnGetWidget(m_UIMain, "LAY_CONSUME")
	local labelBelly = m_fnGetWidget(layConsume, "tfd_belly")
	local labelGetExp = m_fnGetWidget(layConsume, "tfd_exp")

	UIHelper.labelAddStroke(labelExp, mi18n[1725])
	UIHelper.labelAddStroke(labelAttr, mi18n[1633])
	UIHelper.labelAddStroke(labelAttrT, mi18n[1708])

	labelBelly:setText(mi18n[1619])
	labelGetExp:setText(mi18n[1053])

	m_tfdBelly:setText(0)
	m_tfdExp:setText(0)

	-- 宝物信息部分
	m_tbTreasureInfo.property = treaInfoModel.fnGetTreaProperty(tbTreasureDbInfo.id,m_tbTreasureInfo.va_item_text.treasureLevel)
	updateUIByTreaInfo(m_tbTreasureInfo)

	preLoadAnimate()
	logger:debug("registExitAndEnterCall")


	return m_UIMain
end

