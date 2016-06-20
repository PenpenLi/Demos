TileMagicTile = class(CocosObject)

function TileMagicTile:create(level)
    local instance = TileMagicTile.new(CCNode:create())
    instance:init(level)
    return instance
end

function TileMagicTile:init(level)
    self.level = level
    if not self.bg then
        self.bg = Sprite:createWithSpriteFrameName('magic_tile_bg_layer_0000')
        self.bg:setScale(0.98)
        local mask = Sprite:createWithSpriteFrameName('magic_tile_mask_layer_0000')
        mask:setAnchorPoint(ccp(0, 1))
        self.rainBow1 = Sprite:createWithSpriteFrameName('magic_tile_rainbow_layer_0000')
        self.rainBow1:setAnchorPoint(ccp(0, 1))
        self.rainBow2 = Sprite:createWithSpriteFrameName('magic_tile_rainbow_layer_0000')
        self.rainBow2:setAnchorPoint(ccp(0, 1))
        -- self.rainBow1:setVisible(false)
        -- self.rainBow2:setVisible(false)
        self.wave = Sprite:createWithSpriteFrameName('magic_tile_wave_layer_0000')
        self.wave:setAnchorPoint(ccp(0, 1))
        self.top = Sprite:createWithSpriteFrameName('magic_tile_top_layer_0000')
        self.top:setAnchorPoint(ccp(0, 1))
        self.top:setScale(1.005)
        self.clipping = ClippingNode.new(CCClippingNode:create(mask.refCocosObj))
        self.clipping:setAlphaThreshold(0.1)
        self.clipping:setInverted(false)
        self.clipping:setContentSize(CCSizeMake(211, 140))
        self.clipping:setPositionX(-35)
        self.clipping:setPositionY(35)
        self.clipping:addChild(self.wave)
        self.clipping:addChild(self.rainBow1)
        self.clipping:addChild(self.rainBow2)
        self.clipping:addChild(self.top)
        self.clipping:setAnchorPoint(ccp(0, 0))
        self.clipping:ignoreAnchorPointForPosition(true)
        -- self.clipping:setScale(0.95)
        -- local test = LayerColor:create()
        -- test:setContentSize(CCSizeMake(10, 10))
        -- self:addChild(test)

        local function initBubbles()
            -- local test = LayerColor:create()
            -- test:setContentSize(CCSizeMake(3,3))
            -- test:setPosition(ccp(10, -10))
            -- self.clipping:addChild(test)

            for i = 1, 10 do
                local bubble = Sprite:createWithSpriteFrameName('magic_tile_bubble_0000')
                local pos = ccp(math.random(10, 200), math.random(10, 100) - 140)
                self.clipping:addChild(bubble)
                bubble:setPosition(pos)
                local arr = CCArray:create()
                arr:addObject(CCMoveBy:create(1, ccp(0, 30)))
                arr:addObject(CCSequence:createWithTwoActions(CCSequence:createWithTwoActions(CCFadeIn:create(0.2), CCDelayTime:create(0.3)), CCFadeOut:create(0.3)))
                local spawn = CCSpawn:create(arr)
                local arr2 = CCArray:create()
                arr2:addObject(CCPlace:create(pos))
                arr2:addObject(spawn)
                arr2:addObject(CCDelayTime:create(math.random(2, 10) / 10))
                bubble:runAction(CCRepeatForever:create(CCSequence:create(arr2)))
                self.clipping:addChild(bubble)
            end
        end
        initBubbles()


        self.rainBow1:setPosition(ccp(-117, 83))
        local arr = CCArray:create()
        arr:addObject(CCMoveTo:create(74/30, ccp(-59, -49)))
        arr:addObject(CCPlace:create(ccp(-150, 204)))
        arr:addObject(CCMoveTo:create(22/30, ccp(-115, 100)))
        arr:addObject(CCMoveTo:create(24/30, ccp(-103, 84)))
        arr:addObject(CCPlace:create(ccp(-117, 83)))
        self.rainBow1:runAction(CCRepeatForever:create(CCSequence:create(arr)))


        self.rainBow2:setRotation(20)
        self.rainBow2:setPosition(ccp(-121, -25))
        local arr = CCArray:create()
        arr:addObject(CCMoveTo:create(120/30, ccp(52, 236)))
        arr:addObject(CCSequence:createWithTwoActions(CCDelayTime:create(80/30), CCFadeTo:create(40/30, 0.28*255)))
        self.rainBow2:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCSpawn:create(arr), CCPlace:create(ccp(-121, -25)))))

        self.wave:setPosition(ccp(0, 0))
        self.wave:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(60/30, ccp(-238, 0)), CCPlace:create(ccp(0, 0)))))
       
        self.bg:setPosition(ccp(72, -35))
        self:addChild(self.bg)
        self:addChild(self.clipping)
    end

    if level == 1 or __WIN32 then
        self.sprite = Sprite:createWithSpriteFrameName('magic_tile_dragonboat_highlight')
        -- self.sprite:setScale(1.01)
        self.sprite:setPosition(ccp(71, -35))
        self:addChild(self.sprite)
    end
    self:playAnim()
end

function TileMagicTile:hideBG(callback)
    local function runAction(ui)
        ui:runAction(CCFadeOut:create(0.5))
    end
    runAction(self.bg)
    runAction(self.rainBow1)
    runAction(self.rainBow2)
    runAction(self.wave)
    runAction(self.top)
    if self.sprite then
        runAction(self.sprite)
    end
    local function localCallback()
        if callback then
            callback()
        end
    end
    self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(localCallback)))
end

function TileMagicTile:changeColor(color)
    if color == 'red' then
        if self.sprite then self.sprite:removeFromParentAndCleanup(true) end
        self:init(1)
    end
end

function TileMagicTile:playAnim()
    if self.level == 1 or __WIN32 then
        local a = CCArray:create()
        a:addObject(CCFadeOut:create(0.5))
        a:addObject(CCDelayTime:create(0.5))
        a:addObject(CCFadeIn:create(0.5))
        a:addObject(CCDelayTime:create(0.5))
        self.sprite:runAction(CCRepeatForever:create(CCSequence:create(a)))
    -- else
    --     self.bg:stopAllActions()
    --     local seq = CCArray:create()
    --     seq:addObject(CCScaleTo:create(0.8, 1.01, 1))
    --     seq:addObject(CCScaleTo:create(0.8, 1, 1.01))
    --     self.bg:runAction(CCRepeatForever:create(CCSequence:create(seq)))
    end
end

function TileMagicTile:createWaterAnim()
    local sprite = Sprite:createWithSpriteFrameName("magic_tile_water_0000")
    local frames = SpriteUtil:buildFrames("magic_tile_water_%04d", 0, 30)
    local anim = CCRepeatForever:create(SpriteUtil:buildAnimate(frames, 1/18))
    sprite:runAction(anim)
    return sprite
end
