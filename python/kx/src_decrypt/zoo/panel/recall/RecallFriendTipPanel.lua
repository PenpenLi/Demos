RecallFriendTipPanel = class(BasePanel)

function RecallFriendTipPanel:create(parentPanel)
	local panel = RecallFriendTipPanel.new()
	panel.recallParentPanel = parentPanel
	panel:loadRequiredResource(PanelConfigFiles.unlock_cloud_panel_new)
	panel:init()
	return panel
end

function RecallFriendTipPanel:init()
	self.ui	= self:buildInterfaceGroup("RecallFriendTipPanel") 
	BasePanel.init(self, self.ui)

	self.tipText = self.ui:getChildByName("tipText")
	local tip = Localization:getInstance():getText("recall_text_4", {})
	self.tipText:setString(tip) 
end

function RecallFriendTipPanel:popout()
	print("RecallFriendTipPanel:popout")
	local function hideSelf()
		if self.recallParentPanel then 
			self.recallParentPanel:showButtonAnimation()
		end
		PopoutManager:sharedInstance():removeWhileKeepBackground(self, true)
	end
	local function onAnimOver()
		local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
		local sequenceArr = CCArray:create()
		sequenceArr:addObject(CCEaseBounceOut:create(CCMoveBy:create(0.2, ccp(0, self.ui:getGroupBounds().size.height))))
		sequenceArr:addObject(CCDelayTime:create(5))
		sequenceArr:addObject(CCEaseElasticIn:create(CCMoveBy:create(0.8, ccp(0, -self.ui:getGroupBounds().size.height))))
		sequenceArr:addObject(CCCallFunc:create(hideSelf))

		self.ui:stopAllActions();
		self.ui:runAction(CCSequence:create(sequenceArr));
	end
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, onAnimOver)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
end

function RecallFriendTipPanel:getVCenterInParentY()
	local vCenterYInScreen	= self:getVCenterInScreenY()
	local parent = self:getParent()
	assert(parent)
	local posInParent = parent:convertToNodeSpace(ccp(0, vCenterYInScreen))
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	return posInParent.y-visibleSize.height/2-10
end

function RecallFriendTipPanel:getHCenterInParentX()
	local hCenterXInScreen = self:getHCenterInScreenX()
	local parent = self:getParent()
	assert(parent)
	local posInParent = parent:convertToNodeSpace(ccp(hCenterXInScreen, 0))

	return posInParent.x - 55
end