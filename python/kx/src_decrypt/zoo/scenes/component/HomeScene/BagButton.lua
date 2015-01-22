require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

assert(not BagButton)


BagButton = class(IconButtonBase)

function BagButton:init(...)
	assert(#{...} == 0)

	self.ui = ResourceManager:sharedInstance():buildGroup('bagButtonIcon')

	IconButtonBase.init(self, self.ui)

	self.ui:setTouchEnabled(true)
	self.ui:setButtonMode(true)

end


function BagButton:create(...)
	local instance = BagButton.new()
	assert(instance)
	if instance then instance:init() end
	return instance
end

function BagButton:getFlyToPosition()
	local pos = self:getPosition()
	return ccp(pos.x, pos.y)
end

function BagButton:getFlyToSize()
	local size = self:getGroupBounds().size
	size.width, size.height = size.width / 2, size.height / 2
	return size
end

function BagButton:playHighlightAnim()
	self:stopAllActions()
	self:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.1, 1.5), CCScaleTo:create(0.4, 1)))
end