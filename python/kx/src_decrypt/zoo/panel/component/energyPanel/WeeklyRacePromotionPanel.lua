
WeeklyRacePromotionPanel = class(BasePanel)

function WeeklyRacePromotionPanel:create(okPressCallback)
	local panel = WeeklyRacePromotionPanel.new()
	panel:init(okPressCallback)
	return panel
end

function WeeklyRacePromotionPanel:init(okPressCallback)
	self:loadRequiredResource(PanelConfigFiles.weekly_race_promotion_panel)
	local ui = self:buildInterfaceGroup("WeeklyRacePromotionPanel/weeklyrace")
	BasePanel.init(self, ui)

	local pic = ui:getChildByName("pic")
	local touch = Layer:create()
	touch:ignoreAnchorPointForPosition(false)
	touch:setAnchorPoint(ccp(0, 1))
	touch:setContentSize(pic:getContentSize())
	touch:setPositionXY(pic:getPositionX(), pic:getPositionY())
	touch:setTouchEnabled(true)
	touch:addEventListener(DisplayEvents.kTouchTap, function()
			print("TOUCH!!!!")
			if okPressCallback then okPressCallback() end
		end)
	ui:addChild(touch)
end

function WeeklyRacePromotionPanel:popout(parent, topY)
	parent:addChildAt(self, 0)
	self:calcPosition(parent, topY)
	self:playFadeInAnim(function() self.allowBackKeyTap = true end)
end

function WeeklyRacePromotionPanel:remove()
	local function onFinish()
		if self and not self.isDisposed then
			self:removeFromParentAndCleanup(true)
		end
	end
	self.allowBackKeyTap = false
	self:playFadeOutAnim(onFinish)
end

function WeeklyRacePromotionPanel:calcPosition(parent, topY)
	local pPos = parent:getPosition()
	local pSize = parent:getGroupBounds().size
	local pScale = parent:getScaleX()

	self:setPositionXY((pSize.width - self:getGroupBounds().size.width) / 2 / pScale, topY + 110)
end

function WeeklyRacePromotionPanel:playFadeInAnim(finishCallback)
	local childList = {}
	self:getVisibleChildrenList(childList)
	for i, v in ipairs(childList) do
		v:setOpacity(0)
		v:runAction(CCFadeIn:create(0.3))
	end
	self:runAction(CCSequence:createWithTwoActions(CCEaseBackOut:create(CCMoveBy:create(0.5, ccp(0, -300))), CCCallFunc:create(function()
			if finishCallback then finishCallback() end
		end)))
end

function WeeklyRacePromotionPanel:playFadeOutAnim(finishCallback)
	local childList = {}
	self:getVisibleChildrenList(childList)
	for i, v in ipairs(childList) do
		v:runAction(CCFadeOut:create(0.1))
	end
	self:runAction(CCSequence:createWithTwoActions(CCEaseBackOut:create(CCMoveBy:create(0.3, ccp(0, 600))), CCCallFunc:create(function()
			if finishCallback then finishCallback() end
		end)))
end

function WeeklyRacePromotionPanel:onCloseBtnTapped()
	if self.energyPanel then self.energyPanel:onCloseBtnTapped() end
end