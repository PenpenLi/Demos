require 'zoo.panel.share.ShareBasePanel'
ShareFinalPassLevelPanel = class(ShareBasePanel)

function ShareFinalPassLevelPanel:ctor()

end

function ShareFinalPassLevelPanel:init()
	--初始化文案内容
	self.shareTitleName	= Localization:getInstance():getText(self.shareTitleKey)
	ShareBasePanel.init(self, self.shareType, self.shareTitleName)

	self.shareMessage = Localization:getInstance():getText("show_off_wx_share_70")
	--加载动画资源
	SpriteUtil:addSpriteFramesWithFile("share/yanhua.plist", "share/yanhua.png")

	self:runCloudAction()
	self:runNpcAction()
	self:runCircleLightAction()
	self:runFireworkAction()
	self:runStarParticle()
end

function ShareFinalPassLevelPanel:runCloudAction()
	local cloud = self.ui:getChildByName("cloud")
	if cloud then 
		local podiumSize = cloud:getContentSize()
		cloud:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0),ccp(podiumSize.width/2, -podiumSize.height))
		cloud:setOpacity(0)
		cloud:setScale(1)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCScaleTo:create(0.1, 2))
		spwanArr:addObject(CCFadeTo:create(0.1, 255))
		cloud:stopAllActions()
		cloud:runAction(CCSpawn:create(spwanArr))
	end
end

function ShareFinalPassLevelPanel:runNpcAction()
	local npcUi = self.ui:getChildByName("npc")
	if npcUi then
		npcUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))
		npcUi:setFlipX(true)
		npcUi:setRotation(-15)
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

function ShareFinalPassLevelPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-45,posAdjust.y+145))
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

function ShareFinalPassLevelPanel:runFireworkAction()
	local fireworkTable = {}
	local timerId = nil 
	for i=1,5 do
		local firework = SpriteColorAdjust:createWithSpriteFrameName("yanhua_0000.png")
		firework:setAnchorPoint(ccp(0.5, 0.5))
		if i==1 then 
			--firework:setColor(ccc3(200, 200, 0))
			firework:setPosition(ccp(10,-250))
			firework:setScale(1.5)
		elseif i==2 then 
			firework:setPosition(ccp(70,-130))
			firework:setScale(1.5)
		elseif i==3 then 
			firework:setPosition(ccp(200,-100))
			firework:setScale(1.5)
		elseif i==4 then 
			firework:setPosition(ccp(360,-140))
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

function ShareFinalPassLevelPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(375,-455))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("npc"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addParticle)))
	end
end

function ShareFinalPassLevelPanel:dispose()
	ShareBasePanel.dispose(self)
	SpriteUtil:removeLoadedPlist("share/yanhua.plist")
	if _G.__use_small_res then
 		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua@2x.plist")
 	else
		CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("share/yanhua.plist")
	end
end

function ShareFinalPassLevelPanel:create(shareId, shareType, shareLink, shareTitleKey)
	local panel = ShareFinalPassLevelPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('ShareFinalPassLevelPanel')
	panel.shareId = shareId
	panel.shareType = shareType
	panel.shareLink = shareLink
	panel.shareTitleKey = shareTitleKey
	panel:init()
	return panel
end