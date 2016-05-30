require 'zoo.panel.share.ShareBasePanel'
SharePassFiveLevelPanel = class(ShareBasePanel)

function SharePassFiveLevelPanel:ctor()
	
end

function SharePassFiveLevelPanel:init()
	--初始化文案内容
	ShareBasePanel.init(self)

	self.shareMessage = Localization:getInstance():getText("show_off_wx_share_60")

	self:runNpcAction()
	self:runCircleLightAction()
	self:runStarParticle()
	self:runStarGroup3Action()
end

function SharePassFiveLevelPanel:getShareTitleName()
	return Localization:getInstance():getText(self.shareTitleKey)
end

function SharePassFiveLevelPanel:runNpcAction()
	local rocketUi = self.ui:getChildByName("rocket")
	if rocketUi then
		local oriPos = rocketUi:getPosition()
		rocketUi:setPosition(ccp(oriPos.x+180, oriPos.y-500))
		rocketUi:stopAllActions();
		rocketUi:runAction(CCEaseSineOut:create(CCMoveBy:create(0.3, ccp(-180, 500))));

		local rocketFireUi = rocketUi:getChildByName("rocket_fire")
		rocketFireUi:setAnchorPointCenterWhileStayOrigianlPosition(ccp(0.5, 1))
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCScaleTo:create(0.3, 1, 0.8))
		sequenceArr:addObject(CCScaleTo:create(0.3, 1, 1.2))
		rocketFireUi:runAction(CCRepeatForever:create(CCSequence:create(sequenceArr)))
	end
end

function SharePassFiveLevelPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-25,posAdjust.y+145))
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

function SharePassFiveLevelPanel:runStarGroup3Action()
	local starGroup3 = self.ui:getChildByName("starGroup3")
	if starGroup3 then 
		local starGroup3Table = {}
		for i=1,5 do
			local whiteStar = {}
			whiteStar.ui = starGroup3:getChildByName("star"..i)
			whiteStar.ui:setAnchorPointCenterWhileStayOrigianlPosition()
			whiteStar.ui:setOpacity(0)
			
			if i==1 then 
				whiteStar.delayTime = 0.5
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==2 then 
				whiteStar.delayTime = 0.9
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==3 then 
				whiteStar.delayTime = 0.5
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==4 then 
				whiteStar.delayTime = 0.7
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==5 then
				whiteStar.delayTime = 0.9
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

function SharePassFiveLevelPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(355,-450))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("rocket"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.4), CCCallFunc:create(addParticle)))
	end
end

function SharePassFiveLevelPanel:create(shareId)
	local panel = SharePassFiveLevelPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('SharePassFiveLevelPanel')
	panel.shareId = shareId
	panel:init()
	return panel
end