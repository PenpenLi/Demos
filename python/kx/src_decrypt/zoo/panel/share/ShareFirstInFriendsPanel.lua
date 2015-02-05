require 'zoo.panel.share.ShareBasePanel'

ShareFirstInFriendsPanel = class(ShareBasePanel)

function ShareFirstInFriendsPanel:ctor()
	
end

function ShareFirstInFriendsPanel:init()
	--初始化文案内容
	self.shareTitleName	= Localization:getInstance():getText(self.shareTitleKey,{})
	ShareBasePanel.init(self, self.shareType, self.shareTitleName)

	self:runNpcAction()
	self:runCrownAction()
	self:runCircleLightAction()
	self:runStarParticle()
	self:runStarGroup3Action()
	self:runPaperGroupAction(self.ui:getChildByName("paperGroup1"))
	self:runPaperGroupAction(self.ui:getChildByName("paperGroup2"))
end

function ShareFirstInFriendsPanel:runNpcAction()
	local npcUi = self.ui:getChildByName("npc")
	if npcUi then
		npcUi:setOpacity(0)
		local oriPos = npcUi:getPosition()
		npcUi:setPosition(ccp(oriPos.x, oriPos.y-400))
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(0, 400))))
		spwanArr:addObject(CCFadeTo:create(0.2, 255))

		npcUi:stopAllActions();
		npcUi:runAction(CCSpawn:create(spwanArr));
	end
end

function ShareFirstInFriendsPanel:runCrownAction()
	local crownUi = self.ui:getChildByName("crown")
	if crownUi then 
		crownUi:setOpacity(0)
		crownUi:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0))

		local oriPos = crownUi:getPosition()
		crownUi:setPosition(ccp(oriPos.x, oriPos.y+200))
		local sequenceArr = CCArray:create()
		local delayTime = CCDelayTime:create(0.2)
		local spwanArr = CCArray:create()
		spwanArr:addObject(CCEaseBackOut:create(CCMoveBy:create(0.15, ccp(0, -200))))
		spwanArr:addObject(CCFadeTo:create(0.15, 255))
		sequenceArr:addObject(delayTime)
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		local rotate = CCRotateBy:create(0.1,-10)
		sequenceArr:addObject(rotate)
		sequenceArr:addObject(rotate:reverse())
		crownUi:stopAllActions();
		crownUi:runAction(CCSequence:create(sequenceArr));
	end
end

function ShareFirstInFriendsPanel:runCircleLightAction()
	local circleLightUi = self.ui:getChildByName("circleLightBg")
	if circleLightUi then 
		parentUiPos = circleLightUi:getPosition()
		local bg = circleLightUi:getChildByName("bg")
		local posAdjust = circleLightUi:getPosition()
		bg:setAnchorPointCenterWhileStayOrigianlPosition(ccp(posAdjust.x-30,posAdjust.y+180))
		bg:setOpacity(0)
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCDelayTime:create(0.2))
		sequenceArr:addObject(CCFadeTo:create(0.1, 255))

		bg:stopAllActions()
		bg:runAction(CCSequence:create(sequenceArr))
		bg:runAction(CCRepeatForever:create(CCRotateBy:create(0.1, 6)))

		local light = circleLightUi:getChildByName("bg1")
		light:setAnchorPointCenterWhileStayOrigianlPosition()
		light:setOpacity(0)
		local sequenceArr1 = CCArray:create()
		sequenceArr1:addObject(CCDelayTime:create(0.2))
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
		sequenceArr2:addObject(CCDelayTime:create(0.2))
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

function ShareFirstInFriendsPanel:runStarGroup3Action()
	local starGroup3 = self.ui:getChildByName("starGroup3")
	if starGroup3 then 
		local starGroup3Table = {}
		for i=1,4 do
			local whiteStar = {}
			whiteStar.ui = starGroup3:getChildByName("star"..i)
			whiteStar.ui:setAnchorPointCenterWhileStayOrigianlPosition()
			whiteStar.ui:setOpacity(0)
			
			if i==1 then 
				whiteStar.delayTime = 0.3
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==2 then 
				whiteStar.delayTime = 0.7
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==3 then 
				whiteStar.delayTime = 0.3
				whiteStar.oriScale = whiteStar.ui:getScale()
			elseif i==4 then 
				whiteStar.delayTime = 0.5
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

function ShareFirstInFriendsPanel:runPaperGroupAction(paperGroupUi)
	if paperGroupUi then 
		local paperGroup = {}
		math.randomseed(os.time())
		for i=1,5 do
			local paper = {}
			paper.ui = paperGroupUi:getChildByName("paper"..i)
			paper.ui:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
			if i==1 then 
				paper.xDelta = 200
			elseif i==2 then 
				paper.xDelta = 100
			elseif i==3 then 
				paper.xDelta = 50
			elseif i==4 then 
				paper.xDelta = -100
			elseif i==5 then 
				paper.xDelta = -200
			end
			paper.yDelta = math.random(-220,-300)
			paper.height = math.random(30,50)
			paper.time = math.random(14,18)/10
			paper.ui:setOpacity(0)
			table.insert(paperGroup, paper)
		end

		for i,v in ipairs(paperGroup) do
			local sequenceArr = CCArray:create()
			local delayTime = CCDelayTime:create(v.delayTime)
			local spwanArr = CCArray:create()
			local tempTime = 0.4
			local fromPostion = v.ui:getPosition()
			--spwanArr:addObject(CCFadeTo:create(1.5, 0))
			local bezierConfig = ccBezierConfig:new()
			bezierConfig.controlPoint_1 = ccp(fromPostion.x +  v.xDelta/4, fromPostion.y +  v.height*8)
			bezierConfig.controlPoint_2 = ccp(fromPostion.x +  v.xDelta/2, fromPostion.y +  v.height*5)
			bezierConfig.endPosition = ccp(v.xDelta, v.yDelta)
			local bezierAction_1 = CCBezierTo:create(v.time, bezierConfig)

			spwanArr:addObject(bezierAction_1)
			sequenceArr:addObject(delayTime)
			sequenceArr:addObject(CCFadeTo:create(0, 255))
			sequenceArr:addObject(CCSpawn:create(spwanArr))
			local function hidePaper()
				v.ui:setVisible(false)
			end
			sequenceArr:addObject(CCCallFunc:create(hidePaper))
			
			v.ui:stopAllActions();
			v.ui:runAction(CCSequence:create(sequenceArr));
			v.ui:runAction(CCRepeatForever:create(CCRotateBy:create(0.1, 30)))
		end
	end
end

function ShareFirstInFriendsPanel:runStarParticle()
	if not _G.__use_low_effect then
		local function addParticle()
			local particle = ParticleSystemQuad:create("share/star1.plist")
			particle:setPosition(ccp(352,-495))
			local childIndex = self.ui:getChildIndex(self.ui:getChildByName("npc"))
			self.ui:addChildAt(particle, childIndex)	
		end 
		self.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(addParticle)))
	end
end

function ShareFirstInFriendsPanel:create(shareId, shareType, shareImageUrl, shareTitleKey)
	local panel = ShareFirstInFriendsPanel.new()
	panel:loadRequiredResource("ui/NewSharePanel.json")
	panel.ui = panel:buildInterfaceGroup('ShareFirstInFriendsPanel')
	panel.shareId = shareId
	panel.shareType = shareType
	panel.shareImageUrl = shareImageUrl
	panel.shareTitleKey = shareTitleKey
	panel:init()
	return panel
end

