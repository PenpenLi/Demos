TileMagicLamp = class(CocosObject)



function TileMagicLamp:create(color, level)
    local node = TileMagicLamp.new(CCNode:create())
    node:init(color, level)
    return node
end

function TileMagicLamp:init(color, level)
    if not level then level = 4 end
    self.level = tonumber(level)
    if not color then color = AnimalTypeConfig.kRed end
    self.color = color
    if level == 0 then
        self:setLevel(1)
        self:setGrey()

    elseif level ~= 5 then
        self:setLevel(self.level)
        self:playLevel(self.level, 5)
    else
        self:setLevel(4)
        self:playBeforeCast()
    end
    self:setColor(color)
end

function TileMagicLamp:setLevel(level)
    if self.body then 
        self.body:removeFromParentAndCleanup(true)
    end
    if self.border then
        self.border:removeFromParentAndCleanup(true)
    end
    if self.stars then
        self.stars:removeFromParentAndCleanup(true)
    end
    self.stars = self:createStars()
    self.stars:setVisible(false)
    self.body = SpriteColorAdjust:createWithSpriteFrameName(string.format('magic_lamp_level_%d_0000', level))
    self.body:setAnchorPoint(ccp(0.5, 0.5))
    if level == 4 then
        self.border = SpriteColorAdjust:createWithSpriteFrameName(string.format('magic_lamp_level_%d_border_0000', level))
        self.border:setAnchorPoint(ccp(0.49, 0.565))
    else
        self.border = SpriteColorAdjust:createWithSpriteFrameName(string.format('magic_lamp_level_%d_0000', level))
        self.border:setVisible(false)
    end
    self:addChild(self.border)
    self:addChild(self.body)
    self:addChild(self.stars)
end

function TileMagicLamp:setGrey()
    local zOrder = self.body:getZOrder()
    if self.body then 
        self.body:removeFromParentAndCleanup(true)
        self.body = nil
    end
    self.body = SpriteColorAdjust:createWithSpriteFrameName('magic_lamp_greying_0000')
    self.body:setAnchorPoint(ccp(0.5, 0.5))
    self.border:setVisible(false)
    self.stars:setVisible(false)
    self:addChildAt(self.body, zOrder)
end

function TileMagicLamp:playLevel(level, delay)
    if not delay then delay = 0 end
    if not level then level = 1 end
    local function repeatFunc()
        local function callback()
            self.stars:setVisible(false)
        end
        if self.body then
            if level ~= 4 then
                local bodyAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_level_"..level.."_%04d", 0, 22), 1/20)
                self.body:play(bodyAnim, 0, 1, callback)
                self.body:setAnchorPoint(ccp(0.5, 0.5))
                self.border:setVisible(false)
                if level == 3 then
                    self.stars:setVisible(true)
                else
                    self.stars:setVisible(false)
                end
            else
                local bodyAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_level_"..level.."_%04d", 0, 30), 1/20)
                self.body:play(bodyAnim, 0, 1)
                self.body:setAnchorPoint(ccp(0.5, 0.5))
                self.border:setVisible(true)
                local borderAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_level_"..level.."_border_%04d", 0, 30), 1/20)
                self.border:play(borderAnim, 0, 1, callback)
                self.border:setAnchorPoint(ccp(0.49, 0.555))
                self.border:setVisible(true)
                self.stars:setVisible(true)
            end
        end

    end
    local function start()
        if self.body then
            self.body:runAction(
                    CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(repeatFunc), CCDelayTime:create(5)))
                )
        end
    end
    self.body:stopAllActions()
    self.border:stopAllActions()
    self.body:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCCallFunc:create(start)))
end

function TileMagicLamp:setColor(color)
    local value = {0,0,0,0}
    if color == AnimalTypeConfig.kBlue then value = {0,0,0,0}
    elseif color == AnimalTypeConfig.kGreen then value = {-0.41, 0.23, 0.0, 0.0}
    elseif color == AnimalTypeConfig.kOrange then value = {180/180, -49/100, -10/256, 25/100}
    elseif color == AnimalTypeConfig.kPurple then value = {0.368, 0.1, -0.08, 0}
    elseif color == AnimalTypeConfig.kRed then value = {0.9, 0.12, -0.2, 0}
    elseif color == AnimalTypeConfig.kYellow then value = {-0.86, 1, 0.27, 0.6}
    end
    self.body:adjustColor(value[1],value[2],value[3],value[4])
    self.body:applyAdjustColorShader()
    self.color = color
end


function TileMagicLamp:playBeforeCast()
    self.body:stopAllActions()
    local bodyAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_before_casting_%04d", 0, 13), 1/20)
    local borderAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_before_casting_border_%04d", 0, 13), 1/20)
    self.body:play(bodyAnim, 0, 0, function () self.stars:setVisible(false) end)
    self.border:stopAllActions()
    self.border:setAnchorPoint(ccp(0.49, 0.555))
    self.border:play(borderAnim, 0, 0)
    self.stars:setVisible(true)
    self.border:setVisible(true)
end

function TileMagicLamp:playCasting()
    self.body:stopAllActions()
    self.body:setAnchorPoint(ccp(0.5, 0.34))
    local bodyAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_casting_%04d", 0, 28), 1/20)
    local borderAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_casting_border_%04d", 0, 28), 1/20)
    self.light = SpriteColorAdjust:createWithSpriteFrameName("magic_lamp_casting_light_0000")
    local lightAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_casting_light_%04d", 0, 14), 1/20)
    self.light:play(lightAnim, 0, 1, function () if self.light then self.light:removeFromParentAndCleanup(true) end end)
    self:addChild(self.light)
    self.body:play(bodyAnim, 0, 1, function () self:setGrey() end)
    self.border:stopAllActions()
    self.border:setAnchorPoint(ccp(0.49, 0.397))
    self.border:play(borderAnim, 0, 0)
    self.stars:setVisible(false)
    self.border:setVisible(true)
end

function TileMagicLamp:createStars()
    local es_spx = {-33, -27, -18, -4, 13, 26, 29}
    local es_spy = {-26, 21, -30, -28, 30, -20, 10}

    local es_epx = {-33, -27, -18, -4, 13, 26, 29}
    local es_epy = {-2, 33, -25, -21, 34, 1, 33}

    local es_delay = {0, 0.08, 0.21, 0.13, 0.28, 0.25, 0.19}
    local es_sc = {0.22, 0.25, 0.33, 0.42, 0.36, 0.4, 0.31}
    local node = Sprite:createEmpty()
    for i=1,#es_spx do
        local effectStar_C = Sprite:createWithSpriteFrameName("Wrap_Effect_Star.png");
        effectStar_C:setPosition(ccp(es_spx[i], es_spy[i]));
        effectStar_C:setScale(es_sc[i]);
        node:addChild(effectStar_C);

        local function onTimeout()
            local delayAction = CCDelayTime:create(es_delay[i]);                        ----等待
            local showAction = CCFadeTo:create(0.2, 200 + i * i);                       ----显示
            local movetoAction = CCMoveTo:create(0.5, ccp(es_epx[i], (es_epy[i] + es_spy[i]) / 2));         ----移动
            local sp1 = CCSpawn:createWithTwoActions(showAction, movetoAction); 

            local delayAction2 = CCDelayTime:create(0.1);                       ----等待
            local showAction2 = CCFadeTo:create(0.3, 0);                        ----显示
            local movetoAction2 = CCMoveTo:create(0.4, ccp(es_epx[i], es_epy[i]));          ----移动
            local sq1 = CCSequence:createWithTwoActions(delayAction2, showAction2);
            local sp2 = CCSpawn:createWithTwoActions(sq1, movetoAction2);

            local movetoAction3 = CCMoveTo:create(0.01, ccp(es_spx[i], es_spy[i]));

            local arr = CCArray:create();
            arr:addObject(delayAction)
            arr:addObject(sp1)
            arr:addObject(sp2)
            arr:addObject(movetoAction3);
            effectStar_C:stopAllActions()
            effectStar_C:runAction(CCRepeatForever:create(CCSequence:create(arr)))
        end

        delayTime = delayTime or 0
        effectStar_C:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onTimeout)))
    end
    return node
end

function TileMagicLamp:playReinit(color, callback)
    self:setColor(color)
    self.stars:setVisible(false)
    self.body:stopAllActions()
    self.body:setAnchorPoint(ccp(0.5, 0.5))
    local bodyAnim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("magic_lamp_greying_%04d", 0, 10), 1/20)
    self.body:play(bodyAnim, 0, 1, function () self:playLevel(1, 0) self:setColor(color) if callback then callback() end end)
    self.border:stopAllActions()
    self.border:setVisible(false)
end