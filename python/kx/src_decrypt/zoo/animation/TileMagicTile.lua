TileMagicTile = class(CocosObject)

function TileMagicTile:create(level)
    local instance = TileMagicTile.new(CCNode:create())
    instance:init(level)
    return instance
end

function TileMagicTile:init(level)
    -- print('TileMagicTile:init(level)', level)
    self.level = level
    if not self.bg then
        self.bg = Sprite:createWithSpriteFrameName('magic_tile_dragonboat_normal')
        -- self.bg:setAnchorPoint(ccp(1/6 + 0.02, 3/4 - 0.025))
        self.bg:setPosition(ccp(70, -35))
        self:addChild(self.bg)
    end
    -- if level == 1 then
    --     self.sprite = Sprite:createWithSpriteFrameName('magic_tile_red_0000')
    -- else
    --     self.sprite = Sprite:createWithSpriteFrameName('magic_tile_yellow_0000')
    -- end
    if level == 1 then
        self.sprite = Sprite:createWithSpriteFrameName('magic_tile_dragonboat_highlight')
        -- self.sprite:setAnchorPoint(ccp(1/6 + 0.02, 3/4 - 0.025))
        self.sprite:setPosition(ccp(70, -35))
        self:addChild(self.sprite)
    end
    -- self.sprite:setAnchorPoint(ccp(1/6 + 0.02, 3/4 - 0.025))
    -- self.sprite:setScale(0.98)
    self:playAnim()
end

function TileMagicTile:changeColor(color)
    if color == 'red' then
        if self.sprite then self.sprite:removeFromParentAndCleanup(true) end
        self:init(1)
    end
end

function TileMagicTile:playAnim()
    if self.level == 1 then
        self.bg:setScale(1)
        self.bg:stopAllActions()
        local a = CCArray:create()
        a:addObject(CCFadeOut:create(0.5))
        a:addObject(CCDelayTime:create(0.5))
        a:addObject(CCFadeIn:create(0.5))
        a:addObject(CCDelayTime:create(0.5))
        self.sprite:runAction(CCRepeatForever:create(CCSequence:create(a)))
    else
        self.bg:stopAllActions()
        local seq = CCArray:create()
        seq:addObject(CCScaleTo:create(0.6, 1.02, 1))
        seq:addObject(CCScaleTo:create(0.6, 1, 1.02))
        self.bg:runAction(CCRepeatForever:create(CCSequence:create(seq)))
    end
end

function TileMagicTile:createWaterAnim()
    local sprite = Sprite:createWithSpriteFrameName("magic_tile_water_0000")
    local frames = SpriteUtil:buildFrames("magic_tile_water_%04d", 0, 30)
    local anim = CCRepeatForever:create(SpriteUtil:buildAnimate(frames, 1/24))
    sprite:runAction(anim)
    return sprite
end
