require 'zoo.animation.BossBee.BossBeeArmature'
require 'zoo.animation.BossBee.GamePlayRainbow'

local BossBeeController = class()

function BossBeeController:create(playUI, idleAnim, playCuteAnim, hitAnim, castAnim)
    local instance = BossBeeController.new()
    instance:init(playUI, idleAnim, playCuteAnim, hitAnim, castAnim)
    return instance
end

function BossBeeController:init(playUI, idleAnim, playCuteAnim, hitAnim, castAnim)
    self.playUI = playUI
    self.idleAnim = idleAnim
    self.playCuteAnim = playCuteAnim
    self.hitAnim = hitAnim
    self.castAnim = castAnim

    self.idlePause = false

    self.currentX = 0

    self.direction = 'right'

    local offset = 105 --px
    local speed = 50 -- pixels per second
    local interval = 120
    local leftX = playUI.bossLayer:convertToNodeSpace(playUI.rainbow:getMarkPositionInWorldSpaceByPercent(0)).x
    leftX = leftX - offset
    self.idleAnim:setPositionX(leftX)
    self.currentX = leftX
    local function timerCallback(dt)
        if not playUI or playUI.isDisposed then 
            self:dispose()
            return 
        end
        if self.idlePause then return end

        if playUI.rainbow:getCurrentPercent() < 0.15 then
            return
        end

        local rightX = playUI.bossLayer:convertToNodeSpace(playUI.rainbow:getCurrentMarkPositionInWorldSpace()).x
        rightX = rightX - offset

        -- self.currentX = rightX

        -- if self.currentX <= leftX and self.direction == 'left' then
        --     self.direction = 'right'
        -- elseif self.currentX >= rightX and self.direction == 'right' then
        --     self.direction = 'left'
        -- end
        if self.direction == 'right' then
            self.currentX = self.currentX + dt * speed
            if self.currentX > rightX then
                self.currentX = rightX
            end
        else
            self.currentX = self.currentX - dt * speed
            if self.currentX < leftX then
                self.currentX = leftX
            end
        end
        -- print(self.currentX, self.direction)
        self.idleAnim:setPositionX(self.currentX)
    end
    if self.schedId then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
    self.schedId = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerCallback, 1/interval, false)

    local cuteInterval = 20
    -- if __WIN32 then
    --     cuteInterval = 5 -- test
    -- end
    local function cuteTimerCallback()
        if not playUI or playUI.isDisposed then return end
        -- local rand = math.random(1, 100)
        -- if __WIN32 and false then
        --     if rand > 0 then
        --         self:playCute()
        --     end
        -- else
        -- if rand > 50 then
            self:playCute()
        -- end
        -- end
    end
    if self.cuteSchedId then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.cuteSchedId)
        self.cuteSchedId = nil
    end
    self.cuteSchedId = Director:sharedDirector():getScheduler():scheduleScriptFunc(cuteTimerCallback, cuteInterval, false)
end

function BossBeeController:dispose()
    -- print('dispose')
    if self.schedId then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedId)
        self.schedId = nil
    end
    if self.cuteSchedId then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.cuteSchedId)
        self.cuteSchedId = nil
    end
end

function BossBeeController:playHit(actionFinishCallback)
    -- print('playHit')
    if self.isPlayingHitAnim then return end
    if self.isPlayingCastAnim then return end
    self:resetAnim()
    self.isPlayingHitAnim = true
    self.idlePause = true

    local function finishCallback()
        self.isPlayingHitAnim = false
        self.idlePause = false
        self.idleAnim:setVisible(true)
        self.hitAnim:setVisible(false)
        if actionFinishCallback then
            actionFinishCallback()
        end
    end
    self.hitAnim.finishCallback = finishCallback
    self.idleAnim:setVisible(false)
    self.hitAnim:setVisible(true)
    self.hitAnim:playByIndex(0, 1)
    self.hitAnim:setPositionX(self.idleAnim:getPositionX())
end

function BossBeeController:playCute(actionFinishCallback)
    -- print('playCute')
    if self.isPlayingHitAnim then return end
    if self.isPlayingCastAnim then return end
    if self.isPlayingCuteAnim then return end
    self.isPlayingCuteAnim = true
    self.idlePause = true

    local function finishCallback()
        self.isPlayingCuteAnim = false
        self.idlePause = false
        self.idleAnim:setVisible(true)
        self.playCuteAnim:setVisible(false)
        if actionFinishCallback then
            actionFinishCallback()
        end
    end
    self.playCuteAnim.finishCallback = finishCallback
    self.idleAnim:setVisible(false)
    self.playCuteAnim:setVisible(true)
    self.playCuteAnim:playByIndex(0, 1)
    self.playCuteAnim:setPositionX(self.idleAnim:getPositionX())
end

function BossBeeController:playCast(actionFinishCallback)
    -- print('playCast')
    if self.isPlayingCastAnim then return end
    self:resetAnim()
    self.isPlayingCastAnim = true
    self.idlePause = true

    local function finishCallback()
        self.isPlayingCastAnim = false
        self.idlePause = false
        self.idleAnim:setVisible(true)
        self.castAnim:setVisible(false)
    end
    self.castAnim.finishCallback = finishCallback
    local function castEventCallback()
        if actionFinishCallback then
            actionFinishCallback()
        end
    end
    if actionFinishCallback then
        self.playUI:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(7/24), CCCallFunc:create(castEventCallback)))
    end
    self.idleAnim:setVisible(false)
    self.castAnim:setVisible(true)
    self.castAnim:playByIndex(0, 1)
    self.castAnim:setPositionX(self.idleAnim:getPositionX())
end

function BossBeeController:resetAnim()
    if self.isPlayingCuteAnim then
        self.isPlayingCuteAnim = false
        self.playCuteAnim:setVisible(false)
        self.playCuteAnim.finishCallback = nil
    end
    if self.isPlayingCastAnim then
        self.isPlayingCastAnim = false
        self.castAnim:setVisible(false)
        self.castAnim.finishCallback = nil
    end
    if self.isPlayingHitAnim then
        self.isPlayingHitAnim = false
        self.hitAnim:setVisible(false)
        self.hitAnim.finishCallback = nil
    end
    self.idlePause = false
    self.idleAnim:setVisible(true)
end




local MAX_SPINE_PERCENT = 0.98
local RAINBOW_SHOW_HIDE_DURATION = 0.5
local RAINBOW_SHOW_HIDE_Y = 50


-- 给GamePlaySceneUI加上新功能
GamePlaySceneDecorator = class()

function GamePlaySceneDecorator:decoSceneForBossBee(gamePlaySceneInstance)
    FrameLoader:loadArmature('skeleton/bee_animation', 'bee_animation', 'bee_animation')
    -- print('gamePlaySceneInstance.gameBoardView:getScaleX()', gamePlaySceneInstance.gameBoardView:getGroupBounds().size.width)
    local rainbow = GamePlayRainbow:create()
    gamePlaySceneInstance.bossLowerLayer:addChild(rainbow)
    gamePlaySceneInstance.rainbow = rainbow
    local scale = 0.87 * gamePlaySceneInstance.gameBoardView:getScaleX()*gamePlaySceneInstance.gamePlayScene:getScaleX()
    -- local scale = 1
    rainbow:setScale(scale)
    local pos = gamePlaySceneInstance.bossLowerLayer:convertToNodeSpace(gamePlaySceneInstance.gameBoardLogic:getGameItemPosInView(2.5, 0.3))
    -- if __WIN32  then
    --     pos = gamePlaySceneInstance.bossLowerLayer:convertToNodeSpace(gamePlaySceneInstance.gameBoardLogic:getGameItemPosInView(2.5, 0.3))
    -- end
    rainbow:setPositionY(pos.y)
    rainbow:setPositionX(pos.x)


    -- 开场隐藏彩虹
    rainbow:setPositionY(rainbow:getPositionY() - 50)
    rainbow:setVisible(false)

    -- if __WIN32 then
    --     rainbow:setPercent(1)
    --     local test = LayerColor:create()
    --     test:setColor(ccc3(255,0,0))
    --     test:setContentSize(CCSizeMake(3, 3))
    --     gamePlaySceneInstance.bossLowerLayer:addChild(test)
    --     test:setPosition(ccp(rainbow:getPositionX(), rainbow:getPositionY()))
    --     -- rainbow:setPercentInstant(0.99) -- test
    -- end

    local decoCloud = rainbow:buildDecoCloud()
    gamePlaySceneInstance.bossLayer:addChild(decoCloud)
    gamePlaySceneInstance.decoCloud = decoCloud
    decoCloud:setScaleX(gamePlaySceneInstance.gameBoardView:getScaleX())
    local pos2 = gamePlaySceneInstance.bossLayer:convertToNodeSpace(gamePlaySceneInstance.gameBoardLogic:getGameItemPosInView(1.9, 0))
    decoCloud:setPosition(pos2)

    local island = BossBeeArmature:createCastleAnimation()
    gamePlaySceneInstance.bossLowerLayer:addChild(island)
    gamePlaySceneInstance.island = island
    island:setScale(scale*0.88)
    island:setPosition(gamePlaySceneInstance.bossLowerLayer:convertToNodeSpace(gamePlaySceneInstance.gameBoardLogic:getGameItemPosInView(-1, 7)))

    -- 加上一些函数
    gamePlaySceneInstance.setRainbowPercent = function (instance, percent)
        if instance.rainbow and not instance.rainbow.isDisposed then
            instance.rainbow:setPercent(percent)
        end
    end

    gamePlaySceneInstance.playBossFlyUp = function (instance, worldPos, finishCallback)

        local comeOut = nil -- declare

        local landingAnim
        local flyupAnim = BossBeeArmature:createFlyupAnimation()
        local comeOutAnim
        local mask = LayerColor:create()
        mask:setContentSize(CCSizeMake((9*GamePlayConfig_Tile_Width+GamePlayConfig_Tile_BorderWidth*2)*instance.gameBoardView:getScaleX(), (7*GamePlayConfig_Tile_Height+GamePlayConfig_Tile_BorderWidth*2)*instance.gameBoardView:getScaleY()))
        mask:setOpacity(0)
        mask:runAction(CCFadeTo:create(0.2, 125))
        instance.bossLayer:addChild(mask)
        local pos = instance.gameBoardLogic:getGameItemPosInView(9.5, 0.5)
        pos.x = pos.x - 5
        pos.y = pos.y - 5
        mask:setPosition(pos)
        local function landingCallback()
            -- print('landingCallback')
            if mask then 
                mask:removeFromParentAndCleanup(true) 
                mask = nil 
            end
            local idlePos = ccp(landingAnim:getPositionX(), landingAnim:getPositionY())
            if landingAnim then
                landingAnim:removeFromParentAndCleanup(true)
                landingAnim = nil
            end
            local idleAnim = BossBeeArmature:createIdleAnimation()
            instance.bossLayer:addChild(idleAnim)
            idleAnim:setPosition(idlePos)
            instance.idleAnim = idleAnim
            if finishCallback then
                finishCallback()
            end
        end
        -- 避免卡顿感
        landingAnim = BossBeeArmature:createLandingAnimation(landingCallback)
        instance.bossLayer:addChild(landingAnim)
        landingAnim:update(0.001)
        landingAnim:pause()
        landingAnim:setVisible(false)

        local function comeOutCallback()
            if comeOutAnim then
                comeOutAnim:removeFromParentAndCleanup(true)
                comeOutAnim = nil
            end
            
            flyupAnim:update(0.001)
            local flyDuration = 0.6 
            local interval = 80
            local count = 0
            local schedId = nil

            local function flyupCallback()
                -- print('flyupCallback')
                local pos = ccp(flyupAnim:getPositionX(), flyupAnim:getPositionY())
                flyupAnim:removeFromParentAndCleanup(true)
                flyupAnim = nil
                landingAnim:resume()
                landingAnim:setVisible(true)
                landingAnim:setPosition(ccp(pos.x - 60, pos.y + 80))
            end

            local function update()
                if not instance or instance.isDisposed then return end

                local percent = count / (flyDuration * interval) * MAX_SPINE_PERCENT
                local function easeOut(percent)
                    local x =  percent * math.pi * 0.5 - 0.5 * math.pi
                    return math.sin(x) + 1
                end

                -- local function easeOut2(percent)
                --     -- TODO
                --     local function transition (t, b, c, d) 
                --         t = t/d
                --         local ts = t*t
                --         local tc = ts*t
                --         return b+c*(0.6*tc*ts + -1.3*ts*ts + 1.8*tc + -0.4*ts + 0.3*t)
                --     end
                --     return transition(count / (flyDuration*interval), 0, 1, flyDuration)
                -- end

                -- percent = easeOut(percent)
                -- print('count', count, 'percent', percent)

                local position, angle = instance.rainbow:getBossPathPositionAngle(percent)
                local nodePosition = instance.bossLayer:convertToNodeSpace(instance.rainbow:convertToWorldSpace(position))
                flyupAnim:setPosition(nodePosition)
                -- CardinalSpine在曲线的头部计算不够连续
                if percent < 0.1 then
                    position, angle = instance.rainbow:getBossPathPositionAngle(0.1)
                end
                flyupAnim:setRotation(angle+90)


                -- test
                -- if __WIN32 then
                --     local scene = Director:sharedDirector():getRunningScene()
                --     local test = LayerColor:create()
                --     test:setContentSize(CCSizeMake(1, 1)) 
                --     scene:addChild(test)
                --     test:setPosition(instance.rainbow:convertToWorldSpace(position))

                --     local test2 = LayerColor:create()
                --     test2:setColor(ccc3(255, 0, 0))
                --     test2:setContentSize(CCSizeMake(1, 1)) 
                --     scene:addChild(test2)
                --     test2:setPositionY(test:getPositionY())
                --     test2:setPositionX(angle + 300)

                -- end

                if count >= flyDuration * interval then
                    Director:sharedDirector():getScheduler():unscheduleScriptEntry(schedId)
                    schedId = nil
                    if flyupCallback then
                        flyupCallback()
                    end
                else
                    count = count + 1
                end
            end
            schedId = Director:sharedDirector():getScheduler():scheduleScriptFunc(update, 1/interval, false)
            instance.bossLayer:addChild(flyupAnim)
            update()
            -- Director:sharedDirector():getScheduler():setTimeScale(0.2)
        end

        comeOutAnim = BossBeeArmature:createComeOutAnimation(comeOutCallback)
        instance.bossLayer:addChild(comeOutAnim)
        comeOutAnim:setPosition(instance.bossLayer:convertToNodeSpace(worldPos))
        instance.rainbow:runAction(CCSequence:createWithTwoActions(CCShow:create(), CCMoveBy:create(RAINBOW_SHOW_HIDE_DURATION, ccp(0, RAINBOW_SHOW_HIDE_Y))))
    end

    gamePlaySceneInstance.initBossBee = function (instance)
        if not instance.idleAnim then
            instance.idleAnim = BossBeeArmature:createIdleAnimation()
            instance.bossLayer:addChild(instance.idleAnim)
            local pos = instance.rainbow:getMarkPositionInWorldSpaceByPercent(MAX_SPINE_PERCENT)
            instance.idleAnim:setPosition(ccp(pos.x - 60, pos.y + 80))
        end
        if not instance.playCuteAnim then
            instance.playCuteAnim = BossBeeArmature:createPlayCuteAnimation()
            instance.bossLayer:addChild(instance.playCuteAnim)
            instance.playCuteAnim:setPosition(ccp(instance.idleAnim:getPositionX(), instance.idleAnim:getPositionY()))
            instance.playCuteAnim:setVisible(false)
        end
        if not instance.hitAnim then
            instance.hitAnim = BossBeeArmature:createHitAnimation()
            instance.bossLayer:addChild(instance.hitAnim)
            instance.hitAnim:setPosition(ccp(instance.idleAnim:getPositionX(), instance.idleAnim:getPositionY()))
            instance.hitAnim:setVisible(false)
        end
        if not instance.castAnim then
            instance.castAnim = BossBeeArmature:createCastAnimation()
            instance.bossLayer:addChild(instance.castAnim)
            instance.castAnim:setPosition(ccp(instance.idleAnim:getPositionX(), instance.idleAnim:getPositionY()))
            instance.castAnim:setVisible(false)
        end
        instance.bossBeeController = BossBeeController:create(instance, instance.idleAnim, instance.playCuteAnim, instance.hitAnim, instance.castAnim)

    end

    gamePlaySceneInstance.flyHitParticle = function (instance, isHitAnimation, startPos, endPos, finishCallback, callbackParas)
        local function createFollowStarParticle(angle)
            local node = CocosObject:create()
            local sprite = Sprite:createWithSpriteFrameName('falling_star_rainbow0000')
            sprite:setAnchorPoint(ccp(0.5, 0.2))
            local particle_tail = ParticleSystemQuad:create("particle/boss_bee_tail.plist")
            particle_tail:setAutoRemoveOnFinish(true)
            particle_tail:setPosition(ccp(0, -35))
            node:addChild(particle_tail)
            node:addChild(sprite)
            sprite:setPosition(ccp(0, -35))
            sprite:setRotation(angle)
            node.sprite = sprite
            particle_tail:setTotalParticles(math.floor(particle_tail:getTotalParticles()/3))

            if __use_small_res then
                particle_tail:setTotalParticles(math.floor(particle_tail:getTotalParticles()/3))
            end
            
            return node
        end

        local scene = Director:sharedDirector():getRunningScene()

        local direction = (math.random(1, 10) / 10 > 0.5 and 1 or -1) 
        local offsetx = math.random(2, 3) / 10 * math.abs(endPos.y - startPos.y) * direction
        local percent = math.random(4, 6) / 10
        local controlPoint = ccp(startPos.x + (endPos.x - startPos.x)*percent + offsetx, startPos.y + (endPos.y - startPos.y)*percent)
        local points = CCPointArray:create(3)
        points:addControlPoint(startPos)
        points:addControlPoint(ccp(endPos.x, endPos.y))

        local kRad3Ang = -180/3.1415926
        local dx = endPos.x - startPos.x
        local dy = endPos.y - startPos.y
        local distance = dx * dx + dy * dy
        local angle = math.atan2(dy, dx) * kRad3Ang - 90
        local visibleSize   = CCDirector:sharedDirector():getVisibleSize()
        local visibleHeight = visibleSize.height
        local duration = 1.5*math.sqrt(distance)/visibleHeight
        if not isHitAnimation then
            duration = duration * 0.6
        end
        local halfTime = duration * 0.5
        local fadeIn = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime * 1.5, 2, 1.3), CCFadeIn:create(halfTime))
        local fadeOut = CCSpawn:createWithTwoActions(CCScaleTo:create(halfTime * 0.5, 0), CCFadeOut:create(halfTime * 0.5))
        local particleNode = createFollowStarParticle(angle)
        particleNode.sprite:setScale(0)
        particleNode.sprite:setOpacity(0)
        particleNode.sprite:runAction(CCSequence:createWithTwoActions(fadeIn, fadeOut))
        
        local move_action =CCEaseSineOut:create(CCCardinalSplineTo:create(duration, points, 0))
        local actions = CCArray:create()
        if isHitAnimation then
            actions:addObject(CCDelayTime:create(math.random(1, 20)/60))
        end
        actions:addObject(move_action)
        actions:addObject(CCCallFunc:create(
                function() 
                    if finishCallback then
                        finishCallback(callbackParas)
                    end
                    particleNode:removeFromParentAndCleanup(true)
                end))
        particleNode:runAction(CCSequence:create(actions))
        scene:addChild(particleNode)

        

    end

    gamePlaySceneInstance.bossBeeDie = function (instance, finishCallback)
        

        local function islandAnimFinish()


            if instance.idleAnim then
                local function removeIdleAnim()
                    -- Director:sharedDirector():getScheduler():setTimeScale(0.2)
                    instance.idleAnim:removeFromParentAndCleanup(true)
                    instance.idleAnim = nil

                    setTimeOut(function () GamePlayMusicPlayer:playEffect(GameMusicType.kHalloweenBeeDie2) end, 0.2)
                    

                    local cloudAnim = BossBeeArmature:createBigActionCloudAnimation()
                    local beeBigActionAnim = BossBeeArmature:createBigActionBeeAnimation()
                    local scene = Director:sharedDirector():getRunningScene()
                    local mask = LayerColor:create()
                    mask:setContentSize(CCSizeMake(960, 1280))
                    mask:setTouchEnabled(true, 0, true)
                    mask:setOpacity(0)
                    mask:runAction(CCFadeTo:create(0.3, 200))
                    scene:addChild(mask)
                    scene:addChild(beeBigActionAnim)
                    scene:addChild(cloudAnim)

                    instance.rainbow:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(RAINBOW_SHOW_HIDE_DURATION, ccp(0, -RAINBOW_SHOW_HIDE_Y)), CCCallFunc:create(
                    function ()  
                        instance.rainbow:setPercent(0)
                        instance.rainbow:setVisible(false)
                    end
                    )))

                    cloudAnim:setPosition(scene:convertToNodeSpace(instance.gameBoardLogic:getGameItemPosInView(9.5, 1)))
                    local scale = 0.87 * instance.gameBoardView:getScaleX()*instance.gamePlayScene:getScaleX()
                    cloudAnim:setScale(scale)
                    local test = LayerColor:create()
                    test:setContentSize(CCSizeMake(3, 3))
                    test:setColor(ccc3(255,0,0))
                    scene:addChild(test)
                    test:setPosition(cloudAnim:getPosition())


                    beeBigActionAnim:setPosition(scene:convertToNodeSpace(instance.gameBoardLogic:getGameItemPosInView(-1, 5)))
                    beeBigActionAnim:setPositionX(beeBigActionAnim:getPositionX() - 63)
                    beeBigActionAnim:setAnimationScale(0.9)
                    -- local test2 = LayerColor:create()
                    -- test2:setContentSize(CCSizeMake(3, 3))
                    -- test2:setColor(ccc3(0,255,0))
                    -- scene:addChild(test2)
                    -- test2:setPosition(beeBigActionAnim:getPosition())

                    local function allFinishCallback()
                        if cloudAnim then 
                            cloudAnim:removeFromParentAndCleanup(true)
                            cloudAnim = nil
                        end
                        if beeBigActionAnim then
                            beeBigActionAnim:removeFromParentAndCleanup(true)
                            beeBigActionAnim = nil
                        end
                        local function remove()
                            if mask then
                                mask:removeFromParentAndCleanup(true)
                                mask = nil
                            end
                        end
                        mask:runAction(CCSequence:createWithTwoActions(CCFadeTo:create(0.3, 0), CCCallFunc:create(remove)))
                        if finishCallback then
                            finishCallback()
                        end
                    end
                    cloudAnim.finishCallback = allFinishCallback

                end
                instance.bossBeeController:resetAnim()
                instance.idleAnim:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.5), CCCallFunc:create(removeIdleAnim)))
                if instance.playCuteAnim then
                    instance.playCuteAnim:removeFromParentAndCleanup(true)
                    instance.playCuteAnim = nil
                end
                if instance.hitAnim then
                    instance.hitAnim:removeFromParentAndCleanup(true)
                    instance.hitAnim = nil
                end
                if instance.castAnim then
                    instance.castAnim:removeFromParentAndCleanup(true)
                    instance.castAnim = nil
                end
                if instance.bossBeeController then
                    instance.bossBeeController:dispose()
                    instance.bossBeeController = nil
                end
            end
        end
        islandAnimFinish()
        -- instance.island.finishCallback = islandAnimFinish
        -- instance.island:playByIndex(0, 1)

        -- setTimeOut(function () GamePlayMusicPlayer:playEffect(GameMusicType.kHalloweenBeeDie1) end, 0.3)
        
    end

    local oldDispose = gamePlaySceneInstance.dispose
    gamePlaySceneInstance.dispose = function (instance)
          if instance.playCuteAnim then
            instance.playCuteAnim:removeFromParentAndCleanup(true)
            instance.playCuteAnim = nil
        end
        if instance.hitAnim then
            instance.hitAnim:removeFromParentAndCleanup(true)
            instance.hitAnim = nil
        end
        if instance.castAnim then
            instance.castAnim:removeFromParentAndCleanup(true)
            instance.castAnim = nil
        end
        if instance.idleAnim then
            instance.idleAnim:removeFromParentAndCleanup(true)
            instance.idleAnim = nil
        end
        if instance.island then
            instance.island:removeFromParentAndCleanup(true)
            instance.island = nil
        end
        oldDispose(instance)

        -- ArmatureFactory:remove('bee_animation', 'bee_animation')
    end


    return gamePlaySceneInstance
end

