
ForumButton = class(IconButtonBase)

function ForumButton:init(...)

    self.ui = ResourceManager:sharedInstance():buildGroup("forumButtonIcon")

    -- Init Base
    IconButtonBase.init(self, self.ui)

    self.wrapper:setTouchEnabled(true, 0, true)
end

function ForumButton:create()
    local instance = ForumButton.new()
    instance:init()
    return instance
end
