
FcButton = class(IconButtonBase)

function FcButton:init(...)
    assert(#{...} == 0)

    self.ui = ResourceManager:sharedInstance():buildGroup("fcButtonIcon")
    for k, v in pairs(self.ui.list) do
        print(v.name)
    end

    -- Init Base
    IconButtonBase.init(self, self.ui)

    self.wrapper:setTouchEnabled(true, 0, true)
end

function FcButton:create()
    local instance = FcButton.new()
    instance:init()
    return instance
end

