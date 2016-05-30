require 'zoo.panel.share.ShareBasePanel'
ShareTrophyPanel = class(ShareBasePanel)

function ShareTrophyPanel:ctor()

end

local function getFirstAndLastLevel(currentLevel)
	local firstLevel = 1
	local lastLevel = 15
	if currentLevel then 
		if currentLevel%15 == 0 then
			firstLevel = currentLevel - 15
			lastLevel = currentLevel
		else
			firstLevel = currentLevel - (currentLevel%15)
			lastLevel = firstLevel + 15
		end
		firstLevel = firstLevel + 1
	end
	return firstLevel, lastLevel
end

function ShareTrophyPanel:init()
	--初始化文案内容
	ShareBasePanel.init(self)

	self:runTrophyAction()
	self:runCircleLightAction()
	self:runStarParticle()
	self:runStar2Particle()
	self:runStarGroup3Action()
end

function ShareTrophyPanel:getShareTitleName()
	local level = self.achiManager:getData(self.achiManager.LEVEL)
	local firstLevel, lastLevel = getFirstAndLastLevel(level)
	local isNewBranchUnlock = self.achiManager:getData( self.achiManager.UNLOCK_HIDEN_LEVEL)

	if isNewBranchUnlock then
		self.shareTitleKey = self.config.shareTitle1
	end

	return Localization:getInstance():getText(self.shareTitleKey,{num = firstLevel, num1= lastLevel})
end

function ShareTrophyPanel:runTrophyAction()
	local trophyUi = self.ui:getChildByName("trophy")
	if trophyUi then
		trophyUi:setOpacity(0)
		trophyUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))

		local oriPos = trophyUi:getPosition()
		trophyUi:setPosition(ccp(oriPos.x, oriPos.y+200))
		local sequenceArr = CCArray:create()
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCMoveBy:create(0.1, ccp(0, -200)))
		spwanArr:addObject(CCFadeTo:create(0.1, 255))
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		sequenceArr:addObject(CCScaleTo:create(0.1,1,0.8)) 
		sequenceArr:addObject(CCScaleTo:create(0.1,1,1.1))
		sequenceArr:addObject(CCScaleTo:create(0.1,1,1))
		trophyUi:stopAllActions()
		trophyUi:runAction(CCSequence:create(sequenceArr))
	end
end

function ShareTrophyPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-40,posAdjust.y+120))
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

function ShareTrophyPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(370,-440))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("trophy"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addParticle)))
	end
end

function ShareTrophyPanel:runStar2Particle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star2.plist")
			particle:setPosition(ccp(370,-440))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("trophy"))
			self.ui:addChildAt(particle, childIndex)
			self.particle = particle
		end

		local function removeParticle()
			if self.particle and not self.particle.isDisposed then
				self.particle:removeFromParentAndCleanup(true)
				self.particle:dispose()
				self.particle = nil
			end
		end

		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.2))
		arr:addObject(CCCallFunc:create(addParticle))
		arr:addObject(CCDelayTime:create(1.0))
		arr:addObject(CCCallFunc:create(removeParticle))

		self.ui:runAction(CCSequence:create(arr))
	end
end

function ShareTrophyPanel:runStarGroup3Action()
	local starGroup3 = self.ui:getChildByName("starGroup3")
	if starGroup3 then 
		local starGroup3Table = {}
		for i=1,8 do
			local whiteStar = {}
			whiteStar.ui = starGroup3:getChildByName("star"..i)
			whiteStar.ui:setAnchorPointCenterWhileStayOrigianlPosition()
			whiteStar.ui:setOpacity(0)
			
			if i==1 then 
				whiteStar.delayTime = 0.4
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==2 then 
				whiteStar.delayTime = 0.8
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==3 then 
				whiteStar.delayTime = 0.4
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==4 then 
				whiteStar.delayTime = 0.6
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==5 then
				whiteStar.delayTime = 0.8
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==6 then 
				whiteStar.delayTime = 0.5
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==7 then 
				whiteStar.delayTime = 0.9
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==8 then
				whiteStar.delayTime = 0.7
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

function ShareTrophyPanel:create(shareId)
	local panel = ShareTrophyPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('ShareTrophyPanel')
	panel.shareId = shareId
	panel:init()
	return panel
end