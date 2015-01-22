RecallLevelTipPanel = class(BasePanel)

function RecallLevelTipPanel:create(parentPanel)
	local panel = RecallLevelTipPanel.new()
	panel.recallParentPanel = parentPanel
	panel:loadRequiredResource(PanelConfigFiles.unlock_cloud_panel_new)
	panel:init()
	return panel
end

function RecallLevelTipPanel:init()
	self.ui	= self:buildInterfaceGroup("RecallLevelTipPanel") 
	BasePanel.init(self, self.ui)

	self.tipText = self.ui:getChildByName("tipText")
	local tip = Localization:getInstance():getText("recall_text_3", {})
	self.tipText:setString(tip) 
end

function RecallLevelTipPanel:popout()
	print("RecallLevelTipPanel:popout")
	local function hideSelf()
		if self.recallParentPanel then 
			self.recallParentPanel:showButtonAnimation()
		end
		PopoutManager:sharedInstance():removeWhileKeepBackground(self, true)
	end
	local function onAnimOver()
		local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
		local sequenceArr = CCArray:create()
		local panelSize = self.ui:getGroupBounds().size
		sequenceArr:addObject(CCEaseBounceOut:create(CCMoveBy:create(0.5, ccp(panelSize.width*1.5, 0))))
		sequenceArr:addObject(CCDelayTime:create(5))
		sequenceArr:addObject(CCCallFunc:create(hideSelf))

		self.ui:stopAllActions();
		self.ui:runAction(CCSequence:create(sequenceArr));
	end
	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, onAnimOver)
	self:setToScreenCenterHorizontal()
	self:setToScreenCenterVertical()
end

function RecallLevelTipPanel:getHCenterInParentX()
	local hCenterXInScreen = self:getHCenterInScreenX()
	local parent = self:getParent()
	assert(parent)
	local posInParent = parent:convertToNodeSpace(ccp(hCenterXInScreen, 0))
	local panelSize = self.ui:getGroupBounds().size
	return posInParent.x - panelSize.width*1.5 - 20
end
