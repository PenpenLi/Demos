require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

CDKeyButton = class(IconButtonBase)

function CDKeyButton:create(...)
	local newCDKeyButton = CDKeyButton.new()
	newCDKeyButton:init()
	return newCDKeyButton
end

function CDKeyButton:init(...)
	self.ui	= ResourceManager:sharedInstance():buildGroup("exchangeIcon")

	IconButtonBase.init(self, self.ui)

end




