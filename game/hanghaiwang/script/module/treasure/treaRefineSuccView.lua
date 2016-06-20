-- FileName: treaRefineSuccView.lua
-- Author: menghao
-- Date: 2014-12-12
-- Purpose: 精炼成功界面view


module("treaRefineSuccView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_layMain
local m_layCard
local m_imgFrame
local m_imgArm
local m_tfdName
local m_labnPinji
local m_imgClass
local m_imgClassBG


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local effectId

local m_tbImgArrows
local m_tbTfdNums
local _tbTreaInfo 


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineSuccView"] = nil
end


function moduleName()
	return "treaRefineSuccView"
end


--卡牌效果
local function cardAnimation( ... )
	m_layCard:setAnchorPoint(ccp(0.5,0.5))
	m_layCard:setScale(0.0)

	local actionTo1 = CCScaleTo:create(5 / 60, 1.6)
	local actionTo2 = CCScaleTo:create(5 / 60, 0.8)
	local actionTo3 = CCScaleTo:create(2 / 60, 1.0)
	local actionTo4 = CCCallFunc:create(function ( ... )
		m_layMain:setTouchEnabled(true)
	end)
	local arr = CCArray:create()
	arr:addObject(actionTo1)
	arr:addObject(actionTo2)
	arr:addObject(actionTo3)
	arr:addObject(actionTo4)
	local  pSequence = CCSequence:create(arr)

	m_layCard:runAction(pSequence)
end



local function bgAnimation( ... )
	effectId = AudioHelper.playEffect("audio/effect/texiao_jinjie_guangmang.mp3",true)
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = "images/effect/jinjie2_guangmang/jinjie2_guangmang.ExportJson",
		animationName = "jinjie2_guangmang",
	})
	if (m_imgArm:getChildByTag(12222)) then
		m_imgArm:getChildByTag(12222):removeFromParentAndCleanup(true)
	end
	m_imgArm:addNode(m_arAni1,-1000,12222)
end


local function succedTextAnimation( ... )
	--AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
	AudioHelper.playEffect("audio/effect/texiao_zhandoushengli.mp3")
	local imgSucceed = g_fnGetWidgetByName(m_UIMain, "img_title")
	imgSucceed:loadTexture("")
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = "images/effect/jinglian_chenggong/jinglian_chenggong.ExportJson",
		animationName = "jinglian_chenggong",
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 0) then
			elseif (MovementEventType == 1) then
				EffNumUp:new(m_tbImgArrows, m_tbTfdNums)
			elseif (MovementEventType == 2) then

			end
		end,
	})
	if (imgSucceed:getChildByTag(12221)) then
		imgSucceed:getChildByTag(12221):removeFromParentAndCleanup(true)
	end
	imgSucceed:addNode(m_arAni1,1000,12221)
end


function create(tbTreaInfo)
	_tbTreaInfo = {}
	logger:debug({treasure_refine_succeed = tbTreaInfo})
	_tbTreaInfo = tbTreaInfo
	logger:debug({treasure_refine_succeed = _tbTreaInfo})

	m_UIMain= g_fnLoadUI("ui/treasure_refine_succeed.json")

	m_layMain = m_fnGetWidget(m_UIMain, "LAY_MAIN")
	local imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	-- local imgBG2 = m_fnGetWidget(m_UIMain, "img_bg2")
	imgBG:setScale(g_fScaleX)
	-- imgBG2:setScale(g_fScaleX)

	m_layMain:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (effectId ~= nil ) then
				SimpleAudioEngine:sharedEngine():stopEffect(effectId)
			end
			AudioHelper.playCloseEffect()

			LayerManager.removeLayout()

			LayerManager.removeLayout() -- 移除屏蔽层

			BagModel.setBagUpdateByType(BAG_TYPE_STR.treas) -- zhangqi, 2015-09-29

			local tBefore, tAfter = treaRefineCtrl.getTbForMaster()
			local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore, tAfter, 4)
			logger:debug({showString = showString})
			-- local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString, nil, function ( ... )
			-- 	-- EffNumUp:new(m_tbImgArrows, m_tbTfdNums)
			-- 	end)
			-- if (node) then
			-- 	runningScene:addChild(node, 99999)
			-- end
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			if (showString) then
				local armature = g_attribManager:createTreaRefineMasterEffect({
					level = tAfter[tonumber(4)],
					fnMovementCall = function ( sender, MovementEventType, frameEventName )
						if MovementEventType == 1 then
							sender:removeFromParentAndCleanup(true)
							local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString,nil,function ( ... )
								-- 移除战斗力提升动画
								MainFormationTools.removeFlyText()
								-- 战斗力提升动画、
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
				-- 移除战斗力提升动画
				MainFormationTools.removeFlyText()
				-- 战斗力提升动画、
				MainFormationTools.fnShowFightForceChangeAni()
			end
		end
	end)

	m_layCard = m_fnGetWidget(m_UIMain, "img_platform")
	m_imgArm = m_fnGetWidget(m_UIMain, "IMG_ARM")

	local imgTrea = ImageView:create()
	-- imgTrea:loadTexture(tbTreaInfo.icon_big)
	imgTrea:loadTexture("images/base/treas/big/" .. _tbTreaInfo.itemDesc.icon_big)

	m_imgArm:addChild(imgTrea)
	UIHelper.runFloatAction(imgTrea)

	-- local treaEvolveLv = tonumber(tbTreaInfo.treaData.va_item_text.treasureEvolve)
	local treaEvolveLv = tonumber(_tbTreaInfo.va_item_text.treasureEvolve)

	m_tbTfdNums = {}
	m_tbImgArrows = {}

	local img_line_bg1 = m_UIMain.img_line_bg1
	local tbTreaEvolveBeforeInfo = _tbTreaInfo.tbTreaEvolveBeforeInfo
	local tbTreaEvolveAffterInfo = _tbTreaInfo.tbTreaEvolveAffterInfo

	for i=1,3 do

		local layAtrr = img_line_bg1["LAY_ATTR" .. i]
		local attrName = layAtrr.TFD_ATTR
		local attrBeforeValue = layAtrr.TFD_ATTR_NUM
		local attrAffterValue = layAtrr.TFD_ATTR_NUM2
		local imgAffct = layAtrr.IMG_EFFECT

		m_tbImgArrows[i] = imgAffct
		m_tbTfdNums[i] = attrAffterValue

		local beforeAttrInfo = tbTreaEvolveBeforeInfo[i]
		local affterAttrInfo = tbTreaEvolveAffterInfo[i]


		if (not beforeAttrInfo) then
			layAtrr:setEnabled(false)
		else
			layAtrr:setEnabled(true)
			attrName:setText(beforeAttrInfo.name .. ":")
			attrBeforeValue:setText("+" .. beforeAttrInfo.num)
			attrAffterValue:setText("+" .. affterAttrInfo.num)
			attrAffterValue:setEnabled(false)
		end

	end

	bgAnimation()
	succedTextAnimation()
	cardAnimation()

	return m_UIMain
end

