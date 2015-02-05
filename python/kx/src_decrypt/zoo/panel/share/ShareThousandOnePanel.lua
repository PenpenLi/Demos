require 'zoo.panel.share.ShareBasePanel'
ShareThousandOnePanel = class(ShareBasePanel)

function ShareThousandOnePanel:ctor()

end

function ShareThousandOnePanel:init()
	--初始化文案内容
	self.shareTitleName	= Localization:getInstance():getText(self.shareTitleKey,{num = self.shareRank})
	ShareBasePanel.init(self, self.shareType, self.shareTitleName)
	--加载动画资源
	SpriteUtil:addSpriteFramesWithFile("share/yanhua.plist", "share/yanhua.png")

	self:runPodiumAction()
	self:runAnimalAction()
	self:runNpcAction()
	self:runStarGroup3Action()
	self:runCircleLightAction()
	self:runFireworkAction()
	self:runStarParticle()
end

function ShareThousandOnePanel:runPodiumAction()
	local podium = self.ui:getChildByName("podium")
	if podium then 
		local podiumSize = podium:getContentSize()
		podium:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0),ccp(podiumSize.width/2, -podiumSize.height))
		podium:setOpacity(0)
		podium:setScale(0)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCScaleTo:create(0.15, 2))
		spwanArr:addObject(CCFadeTo:create(0.15, 255))
		podium:stopAllActions()
		podium:runAction(CCSpawn:create(spwanArr))
	end
end

function ShareThousandOnePanel:runAnimalAction()
	local animal1 = self.ui:getChildByName("animal1")
	if animal1 then 
		animal1:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))
		local animal1Pos = animal1:getPosition()
		animal1:setPosition(ccp(animal1Pos.x, animal1Pos.y+200))
		animal1:setOpacity(0)
		local sequenceArr = CCArray:create()
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCMoveBy:create(0.1, ccp(0, -200)))
		spwanArr:addObject(CCFadeTo:create(0.1, 255))
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		local scaleBy = CCScaleBy:create(0.1,1,0.8)
		sequenceArr:addObject(scaleBy) 
		sequenceArr:addObject(scaleBy:reverse())
		animal1:stopAllActions()
		animal1:runAction(CCSequence:create(sequenceArr))
	end

	local animal2 = self.ui:getChildByName("animal2")
	if animal2 then 
		animal2:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))
		local animal2Pos = animal2:getPosition()
		animal2:setPosition(ccp(animal2Pos.x, animal2Pos.y+150))
		animal2:setOpacity(0)
		local sequenceArr = CCArray:create()
		local spwanArr = CCArray:create()
		sequenceArr:addObject(CCDelayTime:create(0.1))
		spwanArr:addObject(CCMoveBy:create(0.1, ccp(0, -150)))
		spwanArr:addObject(CCFadeTo:create(0.1, 255))
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		local scaleBy = CCScaleBy:create(0.1,1,0.8)
		sequenceArr:addObject(scaleBy) 
		sequenceArr:addObject(scaleBy:reverse())
		animal2:stopAllActions()
		animal2:runAction(CCSequence:create(sequenceArr))
	end	
end

function ShareThousandOnePanel:runNpcAction()
	local npcUi = self.ui:getChildByName("npc")
	if npcUi then
		npcUi:setOpacity(0)
		local oriPos = npcUi:getPosition()
		npcUi:setPosition(ccp(oriPos.x, oriPos.y-120))
		local sequenceArr = CCArray:create()
		local delayTime = CCDelayTime:create(0.2)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.15, ccp(0, 120))))
		spwanArr:addObject(CCFadeTo:create(0.15, 255))
		sequenceArr:addObject(delayTime)
		sequenceArr:addObject(CCSpawn:create(spwanArr))

		npcUi:stopAllActions();
		npcUi:runAction(CCSequence:create(sequenceArr));
	end
end

function ShareThousandOnePanel:runStarGroup3Action()
	local starGroup3 = self.ui:getChildByName("starGroup3")
	if starGroup3 then 
		local starGroup3Table = {}
		for i=1,5 do
			local whiteStar = {}
			whiteStar.ui = starGroup3:getChildByName("star"..i)
			whiteStar.ui:setAnchorPointCenterWhileStayOrigianlPosition()
			whiteStar.ui:setOpacity(0)
			
			if i==1 then 
				whiteStar.delayTime = 0.2
				whiteStar.oriScale = whiteStar.ui:getScale()
				--whiteStar.
			elseif i==2 then 
				whiteStar.delayTime = 0.6
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==3 then 
				whiteStar.delayTime = 0.2
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==4 then 
				whiteStar.delayTime = 0.4
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==5 then
				whiteStar.delayTime = 0.6
				whiteStar.oriScale = whiteStar.ui:getScale()
			end
			whiteStar.ui:setScale(0)
			table.insert(starGroup3Table, whiteStar)
		end

		for i,v in ipairs(starGroup3Table) do
			local sequenceArr = CCArray:create()
			local delayTime = CCDelayTime:create(v.delayTime)
			local spwanArr1 = CCArray:create()
			local spwanArr2 = CCArray:create()
			local tempTime = 0.4
			spwanArr1:addObject(CCFadeTo:create(tempTime, 255))
			spwanArr1:addObject(CCScaleTo:create(tempTime, v.oriScale))
			spwanArr1:addObject(CCRotateBy:create(tempTime*3, 270))
			spwanArr2:addObject(CCFadeTo:create(tempTime, 0))
			spwanArr2:addObject(CCScaleTo:create(tempTime, 0))
			spwanArr2:addObject(CCRotateBy:create(tempTime*3, 270))

			sequenceArr:addObject(delayTime)
			sequenceArr:addObject(CCSpawn:create(spwanArr1))
			sequenceArr:addObject(CCSpawn:create(spwanArr2))
			
			v.ui:stopAllActions();
			v.ui:runAction(CCSequence:create(sequenceArr));
		end
	end
end

function ShareThousandOnePanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-55,posAdjust.y+65))
		bg:setOpacity(0)
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCDelayTime:create(0.3))
		sequenceArr:addObject(CCFadeTo:create(0.1, 255))

		bg:stopAllActions()
		bg:runAction(CCSequence:create(sequenceArr))
		bg:runAction((CCRepeatForever:create(CCRotateBy:create(0.1, 6))))

		local light = circleLightUi:getChildByName("bg1")
		light:setAnchorPointCenterWhileStayOrigianlPosition()
		light:setOpacity(0)
		local sequenceArr1 = CCArray:create()
		sequenceArr1:addObject(CCDelayTime:create(0.3))
		local function fadeCallBack()
			light:setOpacity(50)
		end
		sequenceArr1:addObject(CCCallFunc:create(fadeCallBack))
		sequenceArr1:addObject(CCScaleTo:create(0.7, 4.5))
		light:stopAllActions()
		light:runAction(CCSequence:create(sequenceArr1))

		local circle = circleLightUi:getChildByName("bg2")
		circle:setAnchorPointCenterWhileStayOrigianlPosition()
		circle:setOpacity(0)
		local sequenceArr2 = CCArray:create()
		sequenceArr2:addObject(CCDelayTime:create(0.3))
		local function fadeCallBack()
			circle:setOpacity(255)
		end
		sequenceArr2:addObject(CCCallFunc:create(fadeCallBack))
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCScaleTo:create(0.5, 4.5))
		spwanArr:addObject(CCFadeOut:create(0.5))
		sequenceArr2:addObject(CCSpawn:create(spwanArr))
		circle:stopAllActions()
		circle:runAction(CCSequence:create(sequenceArr2))
	end
end

function ShareThousandOnePanel:runFireworkAction()
	local fireworkTable = {}
	local timerId = nil 
	for i=1,5 do
		local firework = SpriteColorAdjust:createWithSpriteFrameName("yanhua_0000.png")
		firework:setAnchorPoint(ccp(0.5, 0.5))
		if i==1 then 
			--firework:setColor(ccc3(200, 200, 0))
			firework:setPosition(ccp(10,-230))
			firework:setScale(1.5)
		elseif i==2 then 
			firework:setPosition(ccp(70,-100))
			firework:setScale(1.5)
		elseif i==3 then 
			firework:setPosition(ccp(200,-60))
			firework:setScale(1.5)
		elseif i==4 then 
			firework:setPosition(ccp(360,-110))
			firework:setScale(1.3)
		elseif i==5 then 
			firework:setPosition(ccp(290,-190))
			firework:setScale(2.5)
		end
		table.insert(fireworkTable, firework)
	end
	local fireworkIndex = 1
	local function playFireWork()
		if fireworkIndex>5 then 
			if timerId then 
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timerId)
			end
			timerId = nil
			return
		end
		local firework = fireworkTable[fireworkIndex]
		self.ui:addChild(firework)
		firework:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("yanhua_%04d.png", 0, 41), 1/20), 0, 1, nil, true)
		fireworkIndex = fireworkIndex + 1
	end
	timerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(playFireWork,0.1,false);
end

function ShareThousandOnePanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(385,-375))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("npc"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addParticle)))
	end
end

function ShareThousandOnePanel:dispose()
	ShareBasePanel.dispose(self)
	SpriteUtil:removeLoadedPlist("share/yanhua.plist")
	if _G.__use_small_res then
 		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua@2x.plist")
 	else
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua.plist")
	end
end

function ShareThousandOnePanel:create(shareId, shareType, shareImageUrl, shareTitleKey)
	local shareRank = ShareManager:getShareData(ShareManager.ConditionType.ALL_SCORE_RANK)
	if not shareRank then 
		print("error=====================ShareThousandOnePanel.shareRank is null")
		return nil 
	end
	local panel = ShareThousandOnePanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('ShareThousandOnePanel')
	panel.shareId = shareId
	panel.shareType = shareType
	panel.shareImageUrl = shareImageUrl
	panel.shareTitleKey = shareTitleKey
	panel.shareRank = shareRank
	panel:init()
	return panel
end