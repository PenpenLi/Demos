TileMagicTile = class(CocosObject)

function TileMagicTile:create(level)
    local instance = TileMagicTile.new(CCNode:create())
    instance:init(level)
    return instance
end

function TileMagicTile:init(level)
    -- print('TileMagicTile:init(level)', level)
    if not self.bg then
        self.bg = Sprite:createWithSpriteFrameName('magic_tile_normal_0000')
    end
    self.bg:setAnchorPoint(ccp(1/6, 3/4))
    if level == 1 then
        self.sprite = Sprite:createWithSpriteFrameName('magic_tile_red_0000')
    else
        self.sprite = Sprite:createWithSpriteFrameName('magic_tile_yellow_0000')
    end
    self.sprite:setAnchorPoint(ccp(1/6 + 0.02, 3/4 - 0.025))
    self.sprite:setScale(0.98)
    self:addChild(self.bg)
    self:addChild(self.sprite)
    self:playAnim()
end

function TileMagicTile:changeColor(color)
    if color == 'red' then
        self.sprite:removeFromParentAndCleanup(true)
        self:init(1)
    end
end

function TileMagicTile:playAnim()
    local a = CCArray:create()
    a:addObject(CCFadeOut:create(0.5))
    a:addObject(CCDelayTime:create(0.5))
    a:addObject(CCFadeIn:create(0.5))
    a:addObject(CCDelayTime:create(0.5))
    self.sprite:runAction(CCRepeatForever:create(CCSequence:create(a)))
end
