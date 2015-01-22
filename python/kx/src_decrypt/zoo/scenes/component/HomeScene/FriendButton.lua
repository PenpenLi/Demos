require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

assert(not FriendButton)


FriendButton = class(IconButtonBase)

function FriendButton:init(...)
	assert(#{...} == 0)

	self.ui = ResourceManager:sharedInstance():buildGroup('friendButtonIcon')

	IconButtonBase.init(self, self.ui)

	self.ui:setTouchEnabled(true, 0, true)
	self.ui:setButtonMode(true)

end


function FriendButton:create(...)
	local instance = FriendButton.new()
	assert(instance)
	if instance then instance:init() end
	return instance
end

