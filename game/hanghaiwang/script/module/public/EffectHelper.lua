-- FileName: EffectHelper.lua
-- Author: zhangqi
-- Date: 2014-07-07
-- Purpose: 提供播放各种UI特效的方法
--[[TODO List]]

-- module("EffectHelper", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_effect = "images/effect"

UIEffect = class("UIEffect")

function UIEffect:Armature( ... )
	return self.mArmature
end

-------------- 强化特效 --------------
EffStrenth = class("EffStrenth", UIEffect)

function EffStrenth:ctor(tbInfo)
	self.mBoneIdx = 0 -- 强化等级数字bone的index
	local m_strenthen = "strenthen/tishengji"
	tbInfo.imagePath = m_effect .. m_strenthen .. "0.pvr"
	tbInfo.plistPath = m_effect .. m_strenthen .. "0.plist"
	tbInfo.filePath = m_effect .. m_strenthen .. ".ExportJson"

	tbInfo.fnMovementCall = function ( sender, MovementEventType )
		if (MovementEventType == START) then
		elseif (MovementEventType == COMPLETE) then
			self.mBone:removeDisplay(self.mBoneIdx)
		elseif (MovementEventType == LOOP_COMPLETE) then
		end
	end





	self.mArmature = UIHelper.createArmatureNode(tbInfo)
	self.mBone = self.mArmature:getBone("no9")
end

function EffStrenth:playWithData( tbData )
	local numFile = string.format("%s/digital/%d.png", m_effect, tbData.num)
	local ccSkin = CCSkin:create(numFile)
	ccSkin:setAnchorPoint(ccp(0.5, 0)) -- 设置锚点和强化动画的锚点一致
	self.mBone:addDisplay(ccSkin, self.mBoneIdx) -- 替换

	self.mArmature:getAnimation():play("tishengji", 0, -1, tbData.loop or -1)
end

-------------- add by zhaoqiangjun  创建套装的亮闪闪的框 --------------
EffLightCircle = class("EffLightCircle", UIEffect)
function EffLightCircle:ctor( quality )
	local res = {[1] = 1, [2] = 2, -- 占位
		[3] = {path = "green", anim = "guang2"}, [4] = {path = "blue", anim = "guang"},
		[5] = {path = "purple", anim = "guang3"}, [6] = {path = "orange", anim = "guang4"},
	}
	local mainPath = string.format("%s/suit_highlight/%s", m_effect, "guang")
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = res[quality].anim,
		loop = 1,
		bRetain = true,
	-- fnMovementCall = animationCallBack,
	})
	-- local animation = self.mArmature:getAnimation()
	-- local speed = animation:getSpeedScale()
	-- animation:setSpeedScale(speed*0.9)
end

--------------------------------------------------------
-- 首充礼包特效
EffFirstGift = class("EffFirstGift", UIEffect)
function EffFirstGift:ctor( quality )
	local mainPath = string.format("%s/firstgift/%s", m_effect, "guang_2")
	logger:debug("mainPath = %s",mainPath)
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = "guang_2",
		loop = 1,
		bRetain = true,
	})
end

-- 首充礼包特效
EffFirstGiftBtn = class("EffFirstGiftBtn", UIEffect)
function EffFirstGiftBtn:ctor(  )
	local mainPath = string.format("%s/firstgift/%s", m_effect, "first_recharge_btn")
	logger:debug("mainPath = %s",mainPath)
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = "first_recharge_btn",
		loop = 1,
		bRetain = true,
	})
end


------------   喝可乐特效 add by huxiaozhou  ---------
EffCoke = class("EffCoke", UIEffect)

function EffCoke:ctor(  )
	self.mArmature = UIHelper.createArmatureNode({
		filePath = m_effect .. "/coke/coke.ExportJson",
		animationName = "coke",
		loop = 0,
	})
	self.mArmature:setAnchorPoint(ccp(0.5,0))
end


------------- 掠夺特效 add by huxiaozhou ------------
EffLueDuo = class("EffLueDuo", UIEffect)
function EffLueDuo:ctor( widget, endCallback)
	self.mBoneIdx = 0
	self.endCallback = endCallback
	self.mArmature = UIHelper.createArmatureNode({
		filePath = m_effect .. "/lueduo/lueduo1.ExportJson",
		fnMovementCall = function ( armature,movementType,movementID  )
			if (movementType == 0) then
			elseif (movementType == 1) then
				armature:removeFromParentAndCleanup(true)
			elseif (movementType == 2) then

			end
		end,
		fnFrameCall = function ( bone,frameEventName,originFrameIndex,currentFrameIndex )
			logger:debug("frameEventName : " .. frameEventName)
			logger:debug("originFrameIndex : " .. originFrameIndex)
			logger:debug("currentFrameIndex : " .. currentFrameIndex)
			if (frameEventName == "lueduo1_10") then
				local rmb = self:rmb()
				rmb:setScale(g_fScaleX)
				rmb:setPosition(ccp(g_winSize.width*.5,g_winSize.height*.5))
				widget:addNode(rmb)
			end
		end
	})
	self.mArmature:setAnchorPoint(ccp(0.5,0.5))
end

function EffLueDuo:rmb( )
	local armatureRmb = UIHelper.createArmatureNode({
		filePath = m_effect .. "/rmb/rmb.ExportJson",
		fnMovementCall = function ( armature,movementType,movementID  )
			if (movementType == 0) then
			elseif (movementType == 1) then
			-- armature:removeFromParentAndCleanup(true)
			-- self.endCallback()
			elseif (movementType == 2) then

			end
		end,
		animationName = "rmb"

	})
	return armatureRmb
end


function EffLueDuo:playWithNumber(nNumber)
	local labTTF = UIHelper.createStrokeTTF(tostring(nNumber),ccc3(255,255,255),nil,nil,36,g_sFontPangWa)
	self.mArmature:getBone("lueduo1_2"):addDisplay(labTTF, self.mBoneIdx) -- 替换 成要显示的label
	self.mArmature:getAnimation():play("lueduo1", 0, -1, 0)
end

--播放结算面板中的数值条奖励特效 liweidong
function palyPropertyEffect(tbWidgets,callback)
	local function playAction( i )
		if (i > #tbWidgets) then
			if (callback) then
				callback()
			end
			return
		end

		tbWidgets[i]:setVisible(true)
		tbWidgets[i]:setScaleY(0)

		local actionArr = CCArray:create()
		actionArr:addObject(CCScaleTo:create(10 / 60, 1, 1.6))
		actionArr:addObject(CCScaleTo:create(5 / 60, 1, 1))
		actionArr:addObject(CCCallFunc:create(function ( ... )
			playAction(i + 1)
		end))
		tbWidgets[i]:runAction(CCSequence:create(actionArr))
	end

	playAction(1)
end
--播放结算面板中的VS特效 liweidong
function palyBattleVsEffect(widget,vsImg,callback)
	widget:setVisible(true)
	widget:setScaleY(0)

	local actionArr = CCArray:create()
	actionArr:addObject(CCScaleTo:create(10 / 60, 1, 1.6))
	actionArr:addObject(CCScaleTo:create(5 / 60, 1, 1))
	actionArr:addObject(CCCallFunc:create(function ( ... )
		
	end))
	widget:runAction(CCSequence:create(actionArr))

	local newVs = vsImg:clone()
	vsImg:getParent():addChild(newVs)
	newVs:setOpacity(0)
	local vsActions = CCArray:create()
	vsActions:addObject(CCDelayTime:create(6/60))
	vsActions:addObject(CCFadeTo:create(4/60,100))
	vsActions:addObject(CCSpawn:createWithTwoActions(
	                                                            CCScaleTo:create(20/60, 1.3 ),
	                                                            CCFadeTo:create(20/60,10)
	                                                        ))
	vsActions:addObject(CCFadeTo:create(2/60,0))
	vsActions:addObject(CCCallFunc:create(function ( ... )
		if (callback) then
			callback()
		end
	end))
	local render = tolua.cast(newVs:getVirtualRenderer(), "CCNode")
	render:runAction(CCSequence:create(vsActions))
	-- vsImg:setVisible(false)
end

------------- 战斗结算面板成功特效 add by zhangjunwu 08-01------------
EffBattleWin = class("EffBattleWin", UIEffect)


-- local tbArgs = {imgTitle, imgRainBow, tbStars, starLv, callback}
function EffBattleWin:ctor(tbArgs)
	self.mBoneIdx = 0
	self.tbArmature = {}

	if (tbArgs.imgRainBow) then
		self.tbArmature.mRainBowArmature = UIHelper.createArmatureNode({
			filePath = m_effect .. "/worldboss/new_rainbow.ExportJson",
			animationName = "new_rainbow",
			loop = 1,
		})
		tbArgs.imgRainBow:addNode(self.tbArmature.mRainBowArmature)
	end
	AudioHelper.playSpecialEffect("texiao_zhandoushengli.mp3")
	if (tbArgs.imgTitle) then
		self.tbArmature.mLabelArmature = UIHelper.createArmatureNode({
			filePath = tbArgs.titleEffectType==1 and "images/effect/worldboss/fight_end.ExportJson" or  m_effect .. "/battle_result/shengli.ExportJson",
			animationName = tbArgs.titleEffectType==1 and "fight_end" or "shengli",
			loop = 0,
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "sheng_2_1" then
					
				end
				if (frameEventName == "1") then
					
					-- self:LabelCall(tbArgs.imgTitle)
					if (not tbArgs.tbStars) then
						if (tbArgs.callback) then
							tbArgs.callback()
						end
						return
					end
					local function playStar( index )
						if (index > tonumber(tbArgs.starLv)) then
							if (tbArgs.callback) then
								tbArgs.callback()
							end
							return
						end
						local armatureStar = UIHelper.createArmatureNode({
							filePath = m_effect .. "/battle_result/star_win.ExportJson",
							animationName = "star_win",
							loop = 0,
							bRetain = true,
							fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
								if (frameEventName == "next") then
									playStar(index + 1)
								end
							end
						})
						local x, y = tbArgs.tbStars[index]:getPosition()
						armatureStar:setPosition(ccp(x, y))
						local starParentNode = tbArgs.tbStars[index]:getParent()
						local starParentWidget = tolua.cast(starParentNode, "Widget")
						starParentWidget:addNode(armatureStar)
						AudioHelper.playSpecialEffect("zhaojiangxingji.mp3")
					end
					playStar(1)
				end
			end,

			fnMovementCall = function ( armature,movementType,movementID )
				if (movementType == 1) then
				end
			end
		})

		tbArgs.imgTitle:addNode(self.tbArmature.mLabelArmature)
		local armatureStar = UIHelper.createArmatureNode({
							filePath = m_effect .. "/battle_result/star_win.ExportJson",
							animationName = "star_win",
							loop = 0,
							bRetain = true
						})
	end
end

function EffBattleWin:LabelCall(imgTitle)
	self.tbArmature.mStarArmature = UIHelper.createArmatureNode({
		filePath = m_effect .. "/battle_result/sheng_3.ExportJson",
		animationName = "sheng_3",
		loop = -1,
		fnMovementCall = function ( armature,movementType,movementID  )
			if (movementType == START) then
			elseif (movementType == COMPLETE) then
			elseif (movementType == LOOP_COMPLETE) then

			end
		end
	})
	imgTitle:addNode(self.tbArmature.mStarArmature)
end

------------- 战斗结算面板失败特效 add by zhangjunwu  08-01------------
EffBattleLose = class("EffBattleLose", UIEffect)

function EffBattleLose:ctor(layMain,widget, callback)
	layMain:setScale(0.0)
	local actionTo1 = CCScaleTo:create(5 / 60, 1.6)
	local actionTo2 = CCScaleTo:create(5 / 60, 0.8)
	local actionTo3 = CCScaleTo:create(2 / 60, 1.0)
	local arr = CCArray:create()
	arr:addObject(actionTo1)
	arr:addObject(actionTo2)
	arr:addObject(actionTo3)


	arr:addObject(CCCallFunc:create(function ( ... )


			self.mLoseArmature = UIHelper.createArmatureNode({
				filePath = m_effect .. "/battle_result/bai.ExportJson",
				animationName = "bai",

				fnMovementCall = function ( armature,movementType,movementID )
						if (movementType == 1) then
							if (callback) then
								callback()
							end
						end
					end
			})
			widget:addNode(self.mLoseArmature)
			--震屏
			local dis = 5.0
			local time = 0.03
			local move1 = CCMoveBy:create(time, ccp(dis,dis))
			local move2 = CCMoveBy:create(time ,ccp(-dis,-dis))
			local move3 = CCMoveBy:create(time, ccp(-dis,dis))
			local move4 = CCMoveBy:create(time ,ccp(dis,-dis))
			local arr1 = CCArray:create()
			for i=1,2 do
				arr1:addObject(move1)
				arr1:addObject(move2)
				arr1:addObject(move3)
				arr1:addObject(move4)
				-- if (i == 2 and callback) then
				-- 	arr1:addObject(CCCallFunc:create(callback))
				-- end
			end
			layMain:runAction(CCSequence:create(arr1))
	end)
	)

	local  pSequence = CCSequence:create(arr)

	layMain:runAction(pSequence)
	AudioHelper.playSpecialEffect("texiao_zhandoushibai.mp3")
end

-------------- add by huxiaozhou 2014-11-22 --------------
EffGuide = class("EffGuide", UIEffect)
function EffGuide:ctor(  )
	local mainPath = m_effect .. "/guide/zhishi_2"
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = "zhishi_2",
		loop = 1,
	})

end


EffArrow = class("EffArrow", UIEffect)
function EffArrow:ctor(  )
	local mainPath = m_effect .. "/guide/arrow_tip"
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = "arrow_tip",
		loop = 1,
	})

end
------------ add by huxiaozhou 2015-02-09 ------------- 竞技场水特效
EffArenaWater = class("EffArenaWater", UIEffect)
function EffArenaWater:ctor( )
	local mainPath = m_effect .. "/arena/falls"
	logger:debug(mainPath)
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		animationName = "falls",
		loop = 1,
		bRetain = true,
	})

end

------- add by huxiaozhou 2015-02-10 ----------------- 竞技场中小船的特效
EffArenaBoat = class("EffArenaBoat", UIEffect)
function EffArenaBoat:ctor( )
	self.mBoneIdx = 0
	local mainPath = m_effect .. "/arena/ship"
	logger:debug(mainPath)
	self.mArmature = UIHelper.createArmatureNode({
		filePath = mainPath .. ".ExportJson",
		plistPath = mainPath .. "0.plist",
		imagePath = mainPath .. "0.png",
		bRetain = true,
	})
	self.mArmature:setAnchorPoint(ccp(0.5,0.5))
end

function EffArenaBoat:playWithBoat(sBoneName)
	logger:debug("sBoneName = %s", sBoneName)
	local ccSkin = CCSkin:create(sBoneName)
	self.mBone = self.mArmature:getBone("ship")
	self.mBone:addDisplay(ccSkin, self.mBoneIdx) -- 替换
	self.mArmature:getAnimation():play("ship", -1, -1, 1)

end


-- menghao 20150305 伙伴进阶和宝物精精炼属性提升的动画
EffNumUp = class("EffNumUp", UIEffect)

function EffNumUp:ctor( tbImgJiantous, tbTfdNums )
	local function createAni( pName , ploop , callback)
		local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/" .. pName .. "/" .. pName .. ".ExportJson",
			animationName = pName,
			loop = ploop or -1,
			fnMovementCall = callback or nil
		})
		return armature
	end

	for i=1,#tbTfdNums do
		local tfdNum = tbTfdNums[i]
		local imgJiantou = tbImgJiantous[i]

		if (tfdNum) then
			local actionArr = CCArray:create()
			actionArr:addObject(CCDelayTime:create(0.1 * i))
			actionArr:addObject(CCCallFunc:create(function ( ... )
				if (imgJiantou) then
					imgJiantou:addNode(createAni("jinjie_zhizhen"))
				end

				tfdNum:setEnabled(true)
				local ani = createAni("jinjie_shuzi")
				ani:setPositionX(tfdNum:getContentSize().width * 0.5)
				tfdNum:addNode(ani)
			end))

			tfdNum:runAction(CCSequence:create(actionArr))
		end
	end
end


-- menghao 2015-03-06  宝物强化和精炼相关动画效果
EffTreaForge = class("EffTreaForge", UIEffect)

function EffTreaForge:ctor( ... )

end

function EffTreaForge:bigTreaEff( imgTreaBig )
	local actionArr1 = CCArray:create()
	actionArr1:addObject(CCMoveBy:create(1.5, ccp(0, 10)))
	actionArr1:addObject(CCMoveBy:create(1.5, ccp(0, -10)))
	local sequence1 = CCSequence:create(actionArr1)

	local actionArr2 = CCArray:create()
	actionArr2:addObject(CCScaleTo:create(1.5, 1.06))
	actionArr2:addObject(CCScaleTo:create(1.5, 1))
	local sequence2 = CCSequence:create(actionArr2)

	imgTreaBig:runAction(CCRepeatForever:create(sequence1))
	imgTreaBig:runAction(CCRepeatForever:create(sequence2))
end

function EffTreaForge:smallTreaEff( imgTreaSmall )
	local actionArr1 = CCArray:create()
	actionArr1:addObject(CCMoveBy:create(0.75, ccp(0, 10)))
	actionArr1:addObject(CCMoveBy:create(0.75, ccp(0, -10)))
	local sequence1 = CCSequence:create(actionArr1)

	imgTreaSmall:runAction(CCRepeatForever:create(sequence1))
end

function EffTreaForge:guangzhen( img, bValue )
	local str = bValue and "guangzheng_xiao" or "guangzheng_xiao_wu"
	local armature = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_guangquan/qh2_guangquan.ExportJson",
		animationName = "guangzheng_xiao",
	})

	img:addNode(armature)
end

function EffTreaForge:qianghua( img, callback )
	local armature = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_qianghua/qh2_qianghua.ExportJson",
		animationName = "qh2_qianghua",
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if (frameEventName == "1") then
				callback()
			end
		end
	})

	img:addNode(armature,99999)
end

local function fnGetAniName( str )
	local qhAniPath = "images/effect/hero_qh"
    return  string.format("%s/%s/%s.ExportJson",qhAniPath,str,str)
end


function EffTreaForge:qianghuaHechengDa( img, callback1,callback2,callback3 )
	local armature = UIHelper.createArmatureNode({
		filePath = fnGetAniName("qh_hecheng_da"),
        animationName = "qh_hecheng_da",
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if (frameEventName == "1") then
				callback1()
			end
			if (frameEventName == "2") then
				callback2()
			end
			if (frameEventName == "3") then
				callback3()
			end
		end
	})
	img:addNode(armature,99999)
end

function EffTreaForge:lizi( img )
	local lizi = CCParticleSystemQuad:create("images/effect/hero_transfer/qh2_lizi.plist")
	lizi:setAutoRemoveOnFinish(true)

	img:addNode(lizi)
end



------------- 震屏特效 add by zhangjunwu  11-20------------
ShakeSenceEff = class("ShakeSenceEff", UIEffect)
local runningScene = CCDirector:sharedDirector():getRunningScene()
local kTalkShakeTag = 100
function ShakeSenceEff:ctor(node,delta,times)
	local m_originalPosX,m_originalPosY = node:getPosition()
    if(node:getActionByTag(kTalkShakeTag)==nil)then
        local action = self:shakeFunc(node,self:doShake(),delta,times,m_originalPosX,m_originalPosY)
        action:setTag(kTalkShakeTag)
    end
end

function ShakeSenceEff:stopShakeAction(  )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getActionByTag(kTalkShakeTag)) then
		runningScene:stopActionByTag(kTalkShakeTag)
	end
	runningScene:setPosition(ccp(0,0))
end

--<< 对话震屏
function ShakeSenceEff:shakeFunc(node, callback, delay,times,posx,posy)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
    local delay = CCDelayTime:create(delay)
    local callfunc = CCCallFuncN:create( function ( ... ) self:doShake() end )


    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    local repeatAct = CCRepeat:create(sequence,times)
    local callfunc1 = CCCallFuncN:create(function (  )
    	runningScene:setPosition(ccp(posx,posy))
    end)
    local seq = CCSequence:createWithTwoActions(repeatAct, callfunc1)
    logger:debug(runningScene)
    runningScene:runAction(seq)
    return seq
end

function ShakeSenceEff:doShake()
    math.randomseed(os.time())
    local shakeY = math.floor(math.random()*3+1)*CCDirector:sharedDirector():getWinSize().height*0.0013
    if(runningScene:getPositionY()>=0) then
        shakeY = -shakeY
    end
    runningScene:setPosition(0,shakeY)
end
-------------------------
------------- 震屏特效 add by 孙云鹏  11-20------------
ShakeSenceEffNorandom = class("ShakeSenceEffNorandom", UIEffect)
local NorandomShakeTag = 101
--nSizeHeight 振幅高度
function ShakeSenceEffNorandom:ctor(node,noRandomPointArray)
	self.shakeRandomNode = node
	local m_originalPosX,m_originalPosY = node:getPosition()
	self.originalPosX = m_originalPosX
	self.originalPosY = m_originalPosY

    if(node:getActionByTag(NorandomShakeTag)==nil)then
    	logger:debug({noRandomPointArray = noRandomPointArray})
        local action = self:norandomShakeFunc(node,noRandomPointArray)
        action:setTag(kTalkShakeTag)
    end
end


function ShakeSenceEffNorandom:stopNorandomShakeAction(  )
	local shakeRandomNode = self.shakeRandomNode
	if (shakeRandomNode:getActionByTag(NorandomShakeTag)) then
		shakeRandomNode:stopActionByTag(NorandomShakeTag)
	end
	shakeRandomNode:setPosition(ccp(self.originalPosX,self.originalPosY))
end

--<< 震屏
function ShakeSenceEffNorandom:norandomShakeFunc(node,noRandomPointArray)
	local shakeRandomNode = self.shakeRandomNode
    local arr = CCArray:create()


    logger:debug({ShakeSenceEffNorandom = noRandomPointArray})
    for k,v in pairs(noRandomPointArray) do
    	logger:debug({noRandomPointArray = v})
    	local callfunc = CCCallFuncN:create( function ( ... ) self:doNorandomShake(v) end )
    	arr:addObject(callfunc)
    	local delay = CCDelayTime:create(v[3]/60)
    	arr:addObject(delay)
    end

    local sequence = CCSequence:create(arr)
    logger:debug(shakeRandomNode)
    shakeRandomNode:runAction(sequence)
    return sequence
end

function ShakeSenceEffNorandom:doNorandomShake(noRandomPoint)
	local m_originalPosX = self.originalPosX 
	local m_originalPosY = self.originalPosY

	local shakeRandomNode = self.shakeRandomNode

	local shakeX = m_originalPosX + noRandomPoint[1] or 0 
	local shakeY = m_originalPosY + noRandomPoint[2] or 0

    logger:debug({shakeX = shakeX})
    logger:debug({shakeY = shakeY})

    shakeRandomNode:setPosition(ccp(shakeX,shakeY))
end
