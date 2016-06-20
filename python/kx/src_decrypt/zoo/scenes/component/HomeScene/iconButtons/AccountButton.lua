
AccountButton = class(IconButtonBase)

function AccountButton:init(...)

    self.ui = ResourceManager:sharedInstance():buildGroup("accountButtonIcon")

    -- Init Base
    IconButtonBase.init(self, self.ui)

    self.wrapper:setTouchEnabled(true, 0, true)

    local dotTipVisible = false
    if not BindPhoneGuideLogic:hasPersonalGuidePlayed() then
        dotTipVisible = true
    end
    self.ui:getChildByName('dot'):setVisible(dotTipVisible)
end

function AccountButton:create()
    local instance = AccountButton.new()
    instance:init()
    return instance
end
