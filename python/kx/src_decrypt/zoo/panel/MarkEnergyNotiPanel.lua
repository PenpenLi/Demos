require "zoo.panel.basePanel.BasePanel"

MarkEnergyNotiOncePanel = class(BasePanel)
function MarkEnergyNotiOncePanel:create(parent, finishCallback, boxPosition)
	local panel = MarkEnergyNotiOncePanel.new()
	panel:_init(parent, finishCallback, boxPosition)
	return panel
end

function MarkEnergyNotiOncePanel:_init(parent, finishCallback, boxPosition)
	self:loadRequiredResource(PanelConfigFiles.panel_mark_energy_notionce)

	local panel = self:buildInterfaceGroup("panelmarkenergynotionce")
	self:init(panel)
	self:setPositionForPopoutManager()
	local pPosition = parent:convertToNodeSpace(ccp(self:getPositionX(), self:getPositionY()))
	pPosition.y = pPosition.y + Director:sharedDirector():getWinSize().height
	self:setScale(1 / parent:getScale())
	self:setPositionXY(pPosition.x, pPosition.y)
	parent:addChild(self)

	local bg = panel:getChildByName("bg")
	local text = panel:getChildByName("text")
	local glow = panel:getChildByName("glow")
	local number = panel:getChildByName("number")
	local star = panel:getChildByName("star")
	local lightItem = panel:getChildByName("lightitem")
	local item = panel:getChildByName("item")
	local close = panel:getChildByName("close")

	local position = panel:convertToNodeSpace(ccp(0, -400))
	local recPosition = item:getPosition()
	recPosition = {x = recPosition.x, y = recPosition.y}
	item:setPositionY(position.y)
	star:setVisible(false)
	star:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
	bg:setOpacity(0)
	text:setString(Localization:getInstance():getText("mark.panel.noti.once.title", {n = '\n'}))
	text:setOpacity(0)
	glow:setVisible(false)
	number:setVisible(false)
	lightItem:setVisible(false)
	close:setVisible(false)
	position = panel:convertToNodeSpace(ccp(boxPosition.x, boxPosition.y))
	local size = lightItem:getContentSize()
	lightItem:setPositionXY(position.x - size.width / 2, position.y + size.height / 2)

	local scene = Director:sharedDirector():getRunningScene()
	local swallowTouchLayer
	if scene and not scene.isDisposed then
		swallowTouchLayer = LayerColor:create()
		local wSize = Director:sharedDirector():getWinSize()
		swallowTouchLayer:changeWidthAndHeight(wSize.width, wSize.height)
		swallowTouchLayer:setOpacity(0)
		swallowTouchLayer:setTouchEnabled(true, 0, true)
		scene:addChild(swallowTouchLayer)
	end

	local arr1 = CCArray:create()
	arr1:addObject(CCEaseBackOut:create(CCMoveTo:create(0.625, ccp(recPosition.x, recPosition.y))))
	arr1:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(0.12, ccp(0, -10)), CCScaleTo:create(0.12, 1, 0.9)))
	arr1:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(0.12, ccp(0, 20)), CCScaleTo:create(0.12, 1)))
	arr1:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(0.12, ccp(0, -12)), CCScaleTo:create(0.12, 1, 0.97)))
	arr1:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(0.08, ccp(0, 2)), CCScaleTo:create(0.08, 1)))
	arr1:addObject(CCDelayTime:create(2.3))
	local bSize = item:getContentSize()
	arr1:addObject(CCSpawn:createWithTwoActions(CCEaseBackIn:create(CCMoveTo:create(0.375,
		ccp(position.x - size.width / 2, position.y + size.height / 2))),
		CCScaleTo:create(0.375, size.width / bSize.width)))
	arr1:addObject(CCToggleVisibility:create())
	item:runAction(CCSequence:create(arr1))
	local arr2 = CCArray:create()
	arr2:addObject(CCDelayTime:create(0.5))
	arr2:addObject(CCFadeIn:create(0.3))
	arr2:addObject(CCDelayTime:create(2.3))
	arr2:addObject(CCFadeOut:create(0.2))
	bg:runAction(CCSequence:create(arr2))
	local arr3 = CCArray:create()
	arr3:addObject(CCDelayTime:create(0.5))
	arr3:addObject(CCFadeIn:create(0.3))
	arr3:addObject(CCDelayTime:create(2.3))
	arr3:addObject(CCFadeOut:create(0.2))
	text:runAction(CCSequence:create(arr3))
	local arr4 = CCArray:create()
	arr4:addObject(CCDelayTime:create(1))
	arr4:addObject(CCToggleVisibility:create())
	arr4:addObject(CCDelayTime:create(2.3))
	arr4:addObject(CCToggleVisibility:create())
	number:runAction(CCSequence:create(arr4))
	local arr5 = CCArray:create()
	arr5:addObject(CCDelayTime:create(0.9))
	arr5:addObject(CCToggleVisibility:create())
	arr5:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.6, 7), CCFadeOut:create(0.6)))
	star:runAction(CCSequence:create(arr5))
	local arr6 = CCArray:create()
	arr6:addObject(CCDelayTime:create(3.74))
	arr6:addObject(CCToggleVisibility:create())
	arr6:addObject(CCDelayTime:create(0.17))
	arr6:addObject(CCFadeOut:create(0.17))
	local function animFinish()
		if swallowTouchLayer and not swallowTouchLayer.isDisposed then
			swallowTouchLayer:removeFromParentAndCleanup(true)
		end
		if finishCallback then finishCallback() end
	end
	arr6:addObject(CCCallFunc:create(animFinish))
	lightItem:runAction(CCSequence:create(arr6))
end

MarkGetEnergyNotiPanel = class(BasePanel)
function MarkGetEnergyNotiPanel:create(boxPosition, callback)
	local panel = MarkGetEnergyNotiPanel.new()
	panel:_init(boxPosition, callback)
	return panel
end

function MarkGetEnergyNotiPanel:_init(boxPosition, callback)
	self.callback = callback

	self:loadRequiredResource(PanelConfigFiles.panel_mark_energy_notionce)

	self.panel = self:buildInterfaceGroup("panelmarkenergynotionce")
	self:init(self.panel)
	self:setPositionForPopoutManager()

	self.bg = self.panel:getChildByName("bg")
	self.text = self.panel:getChildByName("text")
	self.glow = self.panel:getChildByName("glow")
	self.number = self.panel:getChildByName("number")
	self.star = self.panel:getChildByName("star")
	local lightItem = self.panel:getChildByName("lightitem")
	self.item = self.panel:getChildByName("item")
	self.close = self.panel:getChildByName("close")

	local recPosition = self.item:getPosition()
	recPosition = {x = recPosition.x, y = recPosition.y}
	self.size = lightItem:getContentSize()
	self.item:setScale(self.size.width / self.item:getContentSize().width)
	self.boxPosition = boxPosition
	self.star:setVisible(false)
	self.star:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
	self.bg:setOpacity(0)
	self.text:setString(Localization:getInstance():getText("mark.panel.noti.get.title", {n = '\n'}))
	self.text:setOpacity(0)
	self.close:setVisible(false)
	self.glow:setScale(0)
	self.number:setVisible(false)
	lightItem:setVisible(false)

	local arr1 = CCArray:create()
	arr1:addObject(CCSpawn:createWithTwoActions(CCMoveTo:create(0.4, ccp(recPosition.x, recPosition.y)),
		CCScaleTo:create(0.4, 1)))
	local function onReach()
		self.close:setTouchEnabled(true)
		self.allowBackKeyTap = true
	end
	arr1:addObject(CCCallFunc:create(onReach))
	arr1:addObject(CCDelayTime:create(3.1))
	local function onClose() self:onCloseBtnTapped() end
	arr1:addObject(CCCallFunc:create(onClose))
	self.item:runAction(CCSequence:create(arr1))
	local arr2 = CCArray:create()
	arr2:addObject(CCDelayTime:create(0.14))
	arr2:addObject(CCFadeIn:create(0.29))
	self.bg:runAction(CCSequence:create(arr2))
	local arr3 = CCArray:create()
	arr3:addObject(CCDelayTime:create(0.14))
	arr3:addObject(CCFadeIn:create(0.29))
	self.text:runAction(CCSequence:create(arr3))
	local arr4 = CCArray:create()
	arr4:addObject(CCDelayTime:create(0.5))
	arr4:addObject(CCToggleVisibility:create())
	self.close:runAction(CCSequence:create(arr4))
	local arr5 = CCArray:create()
	arr5:addObject(CCDelayTime:create(0.4))
	arr5:addObject(CCToggleVisibility:create())
	arr5:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.6, 7), CCFadeOut:create(0.6)))
	self.star:runAction(CCSequence:create(arr5))
	local arr6 = CCArray:create()
	arr6:addObject(CCDelayTime:create(0.4))
	arr6:addObject(CCScaleTo:create(0.12, 2))
	self.glow:runAction(CCRepeatForever:create(CCRotateBy:create(1, 120)))
	self.glow:runAction(CCSequence:create(arr6))
	local arr7 = CCArray:create()
	arr7:addObject(CCDelayTime:create(0.3))
	arr7:addObject(CCToggleVisibility:create())
	self.number:runAction(CCSequence:create(arr7))

	self.close:addEventListener(DisplayEvents.kTouchTap, onClose)
end

function MarkGetEnergyNotiPanel:popout()
	PopoutManager:sharedInstance():add(self, false, false)
	local position = self.panel:convertToNodeSpace(ccp(self.boxPosition.x, self.boxPosition.y))
	self.item:setPositionXY(position.x - self.size.width / 2, position.y - self.size.height / 2)
end

function MarkGetEnergyNotiPanel:onCloseBtnTapped()
	if not self.allowBackKeyTap then return end
	self.allowBackKeyTap = false
	local scene = HomeScene:sharedInstance()
	local energyButton = scene.energyButton
	if not energyButton or energyButton.isDisposed then
		PopoutManager:sharedInstance():remove(self)
		return
	end
	local toPos = energyButton:getFlyToPosition()
	local rToPos = self.panel:convertToNodeSpace(ccp(toPos.x, toPos.y))
	local arr1 = CCArray:create()
	arr1:addObject(CCSpawn:createWithTwoActions(CCEaseBackIn:create(CCMoveTo:create(1,
		ccp(rToPos.x - self.size.width, rToPos.y + self.size.height))),
		CCScaleTo:create(1, self.size.width / self.item:getContentSize().width)))
	local function onAllOver()
		PopoutManager:sharedInstance():remove(self)
		local scene = HomeScene:sharedInstance()
		if scene and not scene.isDisposed then
			scene:checkDataChange()
			local button = scene.energyButton
			if button and not button.isDisposed then
				button:updateView()
			end
		end
		if self.callback then self.callback() end
	end
	arr1:addObject(CCCallFunc:create(onAllOver))
	self.item:runAction(CCSequence:create(arr1))
	self.bg:runAction(CCFadeOut:create(0.25))
	self.text:runAction(CCFadeOut:create(0.25))
	self.glow:runAction(CCToggleVisibility:create())
	self.number:runAction(CCFadeOut:create(0.25))
	self.close:setVisible(false)
	self.star:setVisible(false)
end

MarkRemindRemarkAnim = class(Layer)
function MarkRemindRemarkAnim:create(position, require, reward)
	local anim = MarkRemindRemarkAnim.new()
	anim:_init(position, require, reward)
	return anim
end

function MarkRemindRemarkAnim:_init(position, require, reward)
	self:initLayer()
	local panel = ResourceManager:sharedInstance():buildGroup("guide_info_panelM")
	local text = panel:getChildByName("text")
	text:setString(Localization:getInstance():getText("mark.panel.noti.remark.text",
		{need = require, reward = reward, n = '\n'}))
	panel:setPositionXY(-900, 0)
	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(0.3))
	arr:addObject(CCEaseBackOut:create(CCMoveTo:create(0.2, ccp(60, 0))))
	panel:runAction(CCSequence:create(arr))
	local anim = CommonSkeletonAnimation:createTutorialMoveIn2()
	local arr2 = CCArray:create()
	arr2:addObject(CCDelayTime:create(2.2))
	local function stopAnim() anim:stop() end
	arr2:addObject(CCCallFunc:create(stopAnim))
	anim:runAction(CCSequence:create(arr2))
	anim:setPositionXY(-50, 125)
	anim:setScaleX(-1)

	self:setPositionXY(position.x + 40, position.y - 20)
	self:addChild(panel)
	self:addChild(anim)
end

function MarkRemindRemarkAnim:popout()
	local scene = Director:sharedDirector():getRunningScene()
	if scene and not scene.isDisposed then scene:addChild(self)
	else self:dispose() end
end

function MarkRemindRemarkAnim:clear()
	local arr = CCArray:create()
	arr:addObject(CCMoveBy:create(0.3, ccp(-1000, 0)))
	local function onAllOver() self:removeFromParentAndCleanup(true) end
	arr:addObject(CCCallFunc:create(onAllOver))
	self:stopAllActions()
	self:runAction(CCSequence:create(arr))
end