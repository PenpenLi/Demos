

RecallItemPanel = class(BasePanel)

function RecallItemPanel:ctor()
	
end

function RecallItemPanel:init()
	self.itemsTable = RecallManager.getInstance():getRecallItems()
	self.iconTable = {}
	self.ui	= self:buildInterfaceGroup("RecallItemPanel") 
	BasePanel.init(self, self.ui)

	self.tips = self.ui:getChildByName("tips")
	self.tips:setString(Localization:getInstance():getText("recall_text_1", {}))

	self.itemMiddlePanel = self.ui:getChildByName("itemMiddlePanel")
	for i=1,3 do
		local bubbleRes = self.itemMiddlePanel:getChildByName("bubble"..i)
		local itemIcon = ResourceManager:sharedInstance():buildItemSprite(self.itemsTable[i])
		local iconPos = bubbleRes:getChildByName('icon')
	    iconPos:setVisible(false)
	    bubbleRes:addChildAt(itemIcon, iconPos:getZOrder())
	    itemIcon:setPosition(ccp(iconPos:getPositionX(), iconPos:getPositionY()))
	    table.insert(self.iconTable,itemIcon)
	end

	self.confirmBtn	= GroupButtonBase:create(self.ui:getChildByName("confirmButton"))
	self.confirmBtn:setString(Localization:getInstance():getText("button.ok", {}))

	local function onConfirmBtnTapped()
		self:onConfirmBtnTapped()
	end
	self.confirmBtn:addEventListener(DisplayEvents.kTouchTap, onConfirmBtnTapped)
end

function RecallItemPanel:onConfirmBtnTapped(event)
	self:showItemFlyAnimation()
end

function RecallItemPanel:setToScreenCenterHorizontal()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 636

	local deltaWidth = visibleSize.width - selfWidth
	local halfDeltaWidth = deltaWidth / 2
	local hCenterXInScreen = visibleOrigin.x + halfDeltaWidth

	local parent = self:getParent()
	assert(parent)

	local posXInParent	= parent:convertToNodeSpace(ccp(hCenterXInScreen, 0))
	self:setPositionX(posXInParent.x)
end

-- function RecallItemPanel:getVCenterInScreenY()
-- 	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
-- 	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
-- 	local selfHeight	= self:getGroupBounds().size.height

-- 	local deltaHeight	= visibleSize.height - selfHeight
-- 	local halfDeltaHeight	= deltaHeight / 2
-- 	return visibleOrigin.y + halfDeltaHeight + selfHeight - visibleSize.height/2 + selfHeight/2
-- end

function RecallItemPanel:showItemFlyAnimation()
	local scene = Director:sharedDirector():getRunningScene()	
	local currentLevel = UserManager:getInstance().user:getTopLevelId()
	local levelNode = HomeScene:sharedInstance().worldScene.levelToNode[currentLevel]
	local endToPos = nil
	if levelNode then
		endToPos = levelNode:getParent():convertToWorldSpace(levelNode:getPosition())
		endNodeSize = levelNode:getGroupBounds().size
		endToPos = ccp(endToPos.x,endToPos.y-endNodeSize.height/2)
	else
		-- PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
		self:removeSelf()
	end
	if endToPos then 
		self.ui:setVisible(false)
		for i,v in ipairs(self.iconTable) do
			local oriPos = v:getPosition()
			local finalPos = v:getParent():convertToWorldSpace(oriPos)
			local itemIcon = ResourceManager:sharedInstance():buildItemSprite(self.itemsTable[i])
			local iconSize = itemIcon:getContentSize()
			itemIcon:setScale(v:getParent():getScaleX())
			scene:addChild(itemIcon)
			itemIcon:setAnchorPoint(ccp(0.5,0.5))
			itemIcon:setPosition(ccp(finalPos.x+iconSize.width/2,finalPos.y-iconSize.height/2))
			v:setVisible(false)

			local function removeSelf()
				itemIcon:removeFromParentAndCleanup(true)
				if i==#self.iconTable then 
					-- PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
					self:removeSelf()
				end
			end
			local seqArr = CCArray:create()
			local spwanArr = CCArray:create()
			spwanArr:addObject(CCFadeOut:create(0.8))
			spwanArr:addObject(CCJumpTo:create(0.5, endToPos,100,1))
			spwanArr:addObject(CCScaleTo:create(0.5,0.5))
			seqArr:addObject(CCSpawn:create(spwanArr))
			seqArr:addObject(CCCallFunc:create(removeSelf))

			itemIcon:stopAllActions();
			itemIcon:runAction(CCSequence:create(seqArr)); 
		end
	else
		-- PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
		self:removeSelf()
	end

end

function RecallItemPanel:removeSelf()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
	if self.closeCallback then
		self.closeCallback()
	end
end

function RecallItemPanel:popout(closeCallback)
	print("RecallItemPanel:popout")
	self.closeCallback = closeCallback
	PopoutQueue.sharedInstance():push(self, false)
end

function RecallItemPanel:popoutShowTransition()
	self:setToScreenCenterVertical()
	self:setToScreenCenterHorizontal()
end

function RecallItemPanel:create()
	local panel = RecallItemPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.recall_ui)
	panel:init()
	return panel
end