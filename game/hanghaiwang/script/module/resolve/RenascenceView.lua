-- FileName: RenascenceView.lua
-- Author: menghao
-- Date: 2014-05-21
-- Purpose: 重生view


module("RenascenceView", package.seeall)


-- UI控件引用变量 --
local m_UIMain
local m_i18nString 					=  gi18nString
local m_tfdGoldNum
local m_btnIconBg
local m_btnDesc
local m_btnRenascence
local m_tfdName
local m_imgEffect


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

function showAnimation( callback )
	m_btnIconBg:setTouchEnabled(false)

	AudioHelper.playSpecialEffect("texiao_fj1_2.mp3")

	local function keyFrameFJ1_2CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "1") then
			addfj1Ani("fj1")
		end
	end

	local function keyFrameFJ1CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "2") then
			addfj1_1Ani("fj1_1")
			MainResolveView.doScaleShake()
		end
	end

	local function keyFrameFJ1_1CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "3") then
			addfj2Ani("fj1_1")
		elseif(frameEventName == "4") then

			performWithDelay(m_imgEffect, function ( ... )

					if(m_UIMain) then
						callback()
						removeUI()
						m_btnIconBg:setTouchEnabled(true)
					end
			end, 3 *  (1/ 60))
		end

	end

	function addfj1Ani()
		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj1" .. ".ExportJson",
			fnFrameCall = keyFrameFJ1CallBack
		}
		)

		--开始震屏
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		MainResolveView.startShake(runningScene,0.09,400)

		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(0,m_imgEffect:getSize().height / 2))
		fj1ni1:setScale(g_fScaleX)
		m_imgEffect:addNode(fj1ni1)
		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)
	end

	function addfj1_1Ani()
		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj1_1" .. ".ExportJson",
			fnFrameCall = keyFrameFJ1_1CallBack
		}
		)
		AudioHelper.playSpecialEffect("texiao_fj1_1.mp3")
		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(0,m_imgEffect:getSize().height / 2 + 60 ))
		-- fj1ni1:setScale(g_fScaleX)
		local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
		fj1ni1:setScale(fScale)
		m_imgEffect:addNode(fj1ni1)

		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)
	end

	function addfj2Ani()
		local fj1ni1 = UIHelper.createArmatureNode({
			filePath = m_animationPath  .. "fj2" .. ".ExportJson",
		}
		)
		fj1ni1:setAnchorPoint(ccp(0.5,0.5))
		fj1ni1:setPosition(ccp(m_UIMain:getSize().width / 2,m_UIMain:getSize().height / 2))
		m_UIMain:addNode(fj1ni1)
		fj1ni1:getAnimation():playWithIndex(0,-1,-1,0)
	end



	local armature1 = UIHelper.createArmatureNode({
		filePath = m_animationPath .. "fj1_2.ExportJson",
		animationName = "fj1_2",
		loop = 0,
		fnFrameCall = keyFrameFJ1_2CallBack,
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
				--删除震屏动画
				MainResolveView.stopShakeAction()
			end
		end,
	}
	)

	--local posX,positionY = MainResolveView.getGrayPos()
	--armature1:setPosition(ccp(posX,positionY))
	armature1:setAnchorPoint(ccp(0.5,0.5))
	armature1:setPosition(ccp(0,m_imgEffect:getSize().height / 2 + 60 ))
	-- armature1:setScale(g_fScaleX)
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	-- armature1:setScale(fScale)
	m_imgEffect:addNode(armature1)
end


function removeUI( ... )
	m_tfdName:setEnabled(false)
	m_btnIconBg:removeAllChildren()
	m_btnIconBg:removeAllNodes()

	m_tfdGoldNum:setText("0")
	m_btnRenascence:setEnabled(true)
	m_btnRenascence:removeAllNodes()
	
	m_imgEffect:removeAllNodes()
	m_imgEffect:addNode(MainResolveCtrl.getPlusSprite())
end


function updateUIForAdd( heroSprite, goldNum , name, quality)
	removeUI()
	m_tfdName:setEnabled(true)
	UIHelper.labelAddNewStroke(m_tfdName, name,ccc3(0x28,0x00,0x00)) -- 名字描边
	m_tfdName:setColor(g_QulityColor2[tonumber(quality)])
	
	heroSprite:setAnchorPoint(ccp(0.5,0))
	m_btnIconBg:addNode(heroSprite)
	m_tfdGoldNum:setText(goldNum)
	m_imgEffect:removeAllNodes()
	-- local armature = UIHelper.createArmatureNode({
	-- 	filePath = "images/effect/resolve/fj1_3.ExportJson",
	-- 	animationName = "fj1_3",
	-- })

	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/resolve/fj4.ExportJson",
		animationName = "fj4",
		loop = -1,
	})

	m_btnRenascence:addNode(armature4)
end


local function init(...)

end


function destroy(...)
	package.loaded["RenascenceView"] = nil
end


function moduleName()
	return "RenascenceView"
end


function create( tbEventListener )
	m_UIMain = g_fnLoadUI("ui/renascence_room.json")

	UIHelper.registExitAndEnterCall(m_UIMain,function ()
		MainResolveView.stopShakeAction()
	end)

	m_tfdGoldNum = m_fnGetWidget(m_UIMain, "TFD_GOLD_NUM")
	m_btnIconBg = m_fnGetWidget(m_UIMain, "BTN_ICON_BG")
	local img_border = m_fnGetWidget(m_UIMain, "img_border")
	m_btnDesc = m_fnGetWidget(m_UIMain, "BTN_DESC")
	m_btnRenascence = m_fnGetWidget(m_UIMain, "BTN_RENASCENCE")
	m_tfdName = m_fnGetWidget(m_UIMain, "TFD_ITEM_NAME")

	m_imgEffect = m_fnGetWidget(m_UIMain, "img_effect")

	m_tfdGoldNum:setText("0")


	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		animationName = "guangzheng_xiao_renwu" ,
		loop = -1,
	})

	m_imgEffect:addNode(MainResolveCtrl.getPlusSprite())

	img_border:setTouchEnabled(true)
	img_border:addTouchEventListener(tbEventListener.onIconBg)

	m_btnDesc:addTouchEventListener(tbEventListener.onDesc)
	m_btnRenascence:addTouchEventListener(tbEventListener.onRenascene)
	m_tfdName:setEnabled(false)

	UIHelper.titleShadow(m_btnRenascence, m_i18nString(2090," "))

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideRebornView"
	if (GuideModel.getGuideClass() == ksGuideReborn  and GuideRebornView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createRebornGuide(4,nil,function (  )
			GuideCtrl.removeGuide()
		end)
	end

	return m_UIMain
end

