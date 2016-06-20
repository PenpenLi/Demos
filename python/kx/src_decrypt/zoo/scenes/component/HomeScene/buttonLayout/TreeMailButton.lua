TreeMailButton = class(BaseUI)

function TreeMailButton:ctor()
	
end

function TreeMailButton:init()
	self.ui	= ResourceManager:sharedInstance():buildGroup("treeMailBtn")
	BaseUI.init(self, self.ui)

	self.wrapper = self.ui:getChildByName("mail")
	self.wrapper:setTouchEnabled(true, 0, true)

	self.numDot = self.ui:getChildByName("num_dot")
	self.numberLabel = self.ui:getChildByName("num")
	self.labelPos = self.numberLabel:getPositionY()
	self.fontSize = self.numberLabel:getFontSize()

	self:updateView()

	self:playMoveAction()
end

function TreeMailButton:initDengchaoBtn()
	self.panelConfigFile = 'flash/scenes/homeScene/dengchao_energy_icon.json'
	self.builder = InterfaceBuilder:createWithContentsOfFile(self.panelConfigFile)
	self.ui	= self.builder:buildGroup("treeMailBtn_HuoguoHero")
	BaseUI.init(self, self.ui)

	self.wrapper = self.ui:getChildByName("mail")
	self.wrapper:setTouchEnabled(true, 0, true)

	self.numDot = self.ui:getChildByName("num_dot")
	self.numberLabel = self.ui:getChildByName("num")
	self.labelPos = self.numberLabel:getPositionY()
	self.fontSize = self.numberLabel:getFontSize()

	self.tip = self.ui:getChildByName('tip')
	self.baihe = self.ui:getChildByName('baihe')
	self.baihe_hand = self.ui:getChildByName('baihe_hand')
	self.chenkun = self.ui:getChildByName('chenkun')
	self.chenkun_hand = self.ui:getChildByName('chenkun_hand')

	self.tip:setVisible(false)

	self.isDengchaoMode = true
	self:showDengchao(false)

	self:updateView()

	self:playMoveAction()
end

function TreeMailButton:showDengchao(show)
	if not self.isDengchaoMode then return end
	self.dengchaoShown = show
	self.baihe:setVisible(show)
	self.baihe_hand:setVisible(show)
	self.chenkun:setVisible(show)
	self.chenkun_hand:setVisible(show)
end

function TreeMailButton:playDengchaoAnim(callback)
	if not self.isDengchaoMode then return end
	if self.dengchaoShown == true then return end
	self.dengchaoShown = true
	local function localCallback()
		if callback then callback() end
	end
	self.tip:setVisible(true)
	self.tip:setAnchorPointWhileStayOriginalPosition(ccp(1, 0))
	self.tip:setScale(0)
	self.tip:setOpacity(0)
	local time = 0.3

	self.tip:stopAllActions()
	self.baihe:stopAllActions()
	self.baihe_hand:stopAllActions()
	self.chenkun:stopAllActions()
	self.chenkun_hand:stopAllActions()

	self.chenkun:setVisible(true)
	self.baihe:setVisible(true)
	self.baihe_hand:setVisible(true)
	self.chenkun_hand:setVisible(true)

	self.chenkun:setOpacity(0)
	self.baihe:setOpacity(0)
	self.baihe_hand:setOpacity(0)
	self.chenkun_hand:setOpacity(0)

	self.baihe:runAction(CCFadeIn:create(time))
	self.baihe_hand:runAction(CCFadeIn:create(time))
	self.chenkun:runAction(CCFadeIn:create(time))
	self.chenkun_hand:runAction(CCFadeIn:create(time))	

	local arr = CCArray:create()
	arr:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(time, 1), CCFadeIn:create(time)))
	arr:addObject(CCDelayTime:create(5))
	arr:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(time, 0), CCFadeOut:create(time)))
	arr:addObject(CCCallFunc:create(localCallback))
	self.tip:runAction(CCSequence:create(arr))
end

function TreeMailButton:playDengchaoFadeOutAnim(callback)
	if self.dengchaoShown ~= true then return end
	if not self.isDengchaoMode then return end
	self.dengchaoShown = false
	local function localCallback()
		if callback then callback() end
	end
	local time = 0.3
	self.tip:stopAllActions()
	self.baihe:stopAllActions()
	self.baihe_hand:stopAllActions()
	self.chenkun:stopAllActions()
	self.chenkun_hand:stopAllActions()

	self.tip:runAction(CCSpawn:createWithTwoActions(CCScaleTo:create(time, 0), CCFadeOut:create(time)))
	self.baihe:runAction(CCFadeOut:create(time))
	self.baihe_hand:runAction(CCFadeOut:create(time))
	self.chenkun_hand:runAction(CCFadeOut:create(time))
	self.chenkun:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(time), CCCallFunc:create(localCallback)))
end

function TreeMailButton:updateView()
	local requestNumber = UserManager:getInstance().requestNum
	if requestNumber > 99 then
		self.numberLabel:setPositionY(self.labelPos - 4)
		self.numberLabel:setFontSize(self.fontSize - 8)
		self.numberLabel:setString("99+")
	else
		self.numberLabel:setPositionY(self.labelPos)
		self.numberLabel:setFontSize(self.fontSize)
		self.numberLabel:setString(requestNumber)
	end

	if requestNumber > 0 then
		self.numDot:setVisible(true)
		self.numberLabel:setVisible(true)
	else
		self.numDot:setVisible(false)
		self.numberLabel:setVisible(false)
	end
end

function TreeMailButton:playMoveAction()
	local seqArr = CCArray:create()
	seqArr:addObject(CCDelayTime:create(2))
	seqArr:addObject(CCRotateBy:create(0.5, -8))
	seqArr:addObject(CCRotateBy:create(0.875, 14))
	seqArr:addObject(CCRotateBy:create(0.875, -14))
	seqArr:addObject(CCRotateBy:create(0.5, 8))
	seqArr:addObject(CCDelayTime:create(3))
	self:stopAllActions()
	self:runAction(CCRepeatForever:create(CCSequence:create(seqArr)))
end

function TreeMailButton:create(isDengchaoBtn)
	local btn = TreeMailButton.new()
	if isDengchaoBtn then
		btn:initDengchaoBtn()
	else
		btn:init()
	end
	return btn
end

function TreeMailButton:dispose()
	if self.panelConfigFile then
		InterfaceBuilder:unloadAsset(self.panelConfigFile)
		self.panelConfigFile = nil
	end
	BaseUI.dispose(self)
end