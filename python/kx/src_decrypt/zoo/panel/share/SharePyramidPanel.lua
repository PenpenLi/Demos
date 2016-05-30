require 'zoo.panel.share.ShareBasePanel'
SharePyramidPanel = class(ShareBasePanel)

function SharePyramidPanel:ctor()

end

function SharePyramidPanel:init()
	--初始化文案内容
	ShareBasePanel.init(self)

	self:runPyramidAction()
	self:runNpcAction()
	self:runCircleLightAction()
	self:runStarParticle()
end

function SharePyramidPanel:getShareTitleName()
	local highestLevel =  MetaManager.getInstance():getMaxNormalLevelByLevelArea()
	return Localization:getInstance():getText(self.shareTitleKey,{num = highestLevel})
end

function SharePyramidPanel:runPyramidAction()
	local pyramid = self.ui:getChildByName("pyramid")
	if pyramid then 
		local pyramidSize = pyramid:getContentSize()
		pyramid:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0),ccp(pyramidSize.width/2, -pyramidSize.height))

		pyramid:setOpacity(0)
		pyramid:setScale(1)
		local spwanArr1 = CCArray:create()
		spwanArr1:addObject(CCScaleTo:create(0.1, 2))
		spwanArr1:addObject(CCFadeTo:create(0.1, 255))
		spwanArr1:addObject(CCMoveBy:create(0.1,ccp(0, 50)))

		local spwanArr2 = CCArray:create()
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCRotateBy:create(0.1,-15))
		sequenceArr:addObject(CCRotateBy:create(0.1,25))
		sequenceArr:addObject(CCRotateBy:create(0.1,-10))
		spwanArr2:addObject(CCSequence:create(sequenceArr))
		spwanArr2:addObject(CCMoveBy:create(0.1,ccp(0, -50)))

		local sequenceArr2 = CCArray:create()
		sequenceArr2:addObject(CCSpawn:create(spwanArr1))
		sequenceArr2:addObject(CCSpawn:create(spwanArr2))

		pyramid:stopAllActions()
		pyramid:runAction(CCSequence:create(sequenceArr2))
	end
end

function SharePyramidPanel:runNpcAction()
	local npcUi = self.ui:getChildByName("npc")
	if npcUi then
		npcUi:setOpacity(0)
		npcUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))

		local oriPos = npcUi:getPosition()
		npcUi:setPosition(ccp(oriPos.x, oriPos.y+200))
		local sequenceArr = CCArray:create()
		local delayTime = CCDelayTime:create(0.3)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.15, ccp(0, -200))))
		spwanArr:addObject(CCFadeTo:create(0.15, 255))
		sequenceArr:addObject(delayTime)
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		local rotate = CCRotateBy:create(0.1,-10)
		sequenceArr:addObject(rotate)
		sequenceArr:addObject(rotate:reverse())
		npcUi:stopAllActions();
		npcUi:runAction(CCSequence:create(sequenceArr));
	end
end

function SharePyramidPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(posAdjust)
		bg:setOpacity(0)
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCDelayTime:create(0.4))
		sequenceArr:addObject(CCFadeTo:create(0.1, 255))

		bg:stopAllActions()
		bg:runAction(CCSequence:create(sequenceArr))
		bg:runAction((CCRepeatForever:create(CCRotateBy:create(0.1, 6))))

		local light = circleLightUi:getChildByName("bg1")
		light:setAnchorPointCenterWhileStayOrigianlPosition()
		light:setOpacity(0)
		local sequenceArr1 = CCArray:create()
		sequenceArr1:addObject(CCDelayTime:create(0.4))
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
		sequenceArr2:addObject(CCDelayTime:create(0.4))
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

function SharePyramidPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(335,-360))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("npc"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.4), CCCallFunc:create(addParticle)))
	end
end

function SharePyramidPanel:create(shareId)
	local panel = SharePyramidPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('SharePyramidPanel')
	panel.shareId = shareId
	panel:init()
	return panel
end