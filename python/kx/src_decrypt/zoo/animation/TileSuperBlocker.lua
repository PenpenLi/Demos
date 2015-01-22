TileSuperBlocker = class(CocosObject)

function TileSuperBlocker:create()
    local instance = TileSuperBlocker.new(CCNode:create())
    instance:init()
    instance.name = "SuperBlocker"
    return instance
end

function TileSuperBlocker:init()
    self.sprite = Sprite:createWithSpriteFrameName("super_blocker_0000")
    self:addChild(self.sprite)
end
