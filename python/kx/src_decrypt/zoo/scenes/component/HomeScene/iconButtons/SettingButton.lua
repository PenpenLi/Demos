
SettingButton = class(IconButtonBase)

function SettingButton:init(...)

    self.ui = ResourceManager:sharedInstance():buildGroup("settingPanelButtonIcon")

    -- Init Base
    IconButtonBase.init(self, self.ui)

    self.wrapper:setTouchEnabled(true, 0, true)
end

function SettingButton:create()
    local instance = SettingButton.new()
    instance:init()
    return instance
end
