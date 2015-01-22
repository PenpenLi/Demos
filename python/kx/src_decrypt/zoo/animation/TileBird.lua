require "hecore.display.Director"
require "hecore.display.ParticleSystem"

kTileBirdAnimation = { kNormal = 1, kSelect = 2, kDestroy = 3 }
TileBird = class(CocosObject)

local kCharacterAnimationTime = 1/30
local kBirdContentSize = 65

function TileBird:toString()
	return string.format("TileBird [%s]", self.name and self.name or "nil");
end

function TileBird:create()
  local node = TileBird.new(CCNode:create()) 
	node.name = "TileBird"

  local effectSprite = Sprite:createWithSpriteFrameName("bird_effect0000")
  node.effectSprite = effectSprite
  node:addChild(effectSprite)

  local frames = SpriteUtil:buildFrames("bird_effect%04d", 0, 20)
  local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  effectSprite:play(animate)

  local mainSprite = Sprite:createWithSpriteFrameName("bird_normal0000")
  node.mainSprite = mainSprite
  node:addChild(mainSprite)

	return node
end

function TileBird:play(animation)
  if animation == kTileBirdAnimation.kNormal then self:playNormalAnimation()
  elseif animation == kTileBirdAnimation.kSelect then self:playSelectedAnimation()
  elseif animation == kTileBirdAnimation.kDestroy then self:playDestroyAnimation() end
end

function TileBird:playNormalAnimation()
  self.mainSprite:stopAllActions()
  self.mainSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bird_normal0000"))
end

function TileBird:playSelectedAnimation()
  if not self.mainSprite.refCocosObj then return end 
  self.mainSprite:stopAllActions()

  local context = self
  local function playAnim()
    local frames = SpriteUtil:buildFrames("bird_select%04d", 0, 24)
    local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
    context.mainSprite:play(animate, 0, 1)
  end

  local sequenceAction = CCSequence:createWithTwoActions(CCCallFunc:create(playAnim), CCDelayTime:create(2))
  self.mainSprite:runAction(CCRepeatForever:create(sequenceAction))
end

local function createBirdDestroyEffect()  
  local node = CocosObject:create()
  local galaxy = ParticleSystemQuad:create("particle/fast_galaxy.plist")
  galaxy:setAutoRemoveOnFinish(true)
  galaxy:setPosition(ccp(0,0))
  node:addChild(galaxy)

  local backSprite = Sprite:createWithSpriteFrameName("bird_galaxy0000")
  backSprite:setScale(0.35)
  backSprite:runAction(CCScaleTo:create(0.5, 1.1))
  backSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 50)))
  node:addChild(backSprite)

  local pop = ParticleSystemQuad:create("particle/star_pop.plist")
  pop:setAutoRemoveOnFinish(true)
  pop:setPosition(ccp(0,0))
  node:addChild(pop)

  local frontSprite = Sprite:createWithSpriteFrameName("bird_star0000")
  frontSprite:setScale(0.35)
  frontSprite:runAction(CCScaleTo:create(0.5, 1.3))
  frontSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 150)))
  node:addChild(frontSprite)

  local pointEffectSprite = Sprite:createWithSpriteFrameName("bird_effect_point0000")
  pointEffectSprite:setScale(1.2)
  pointEffectSprite:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("bird_effect_point%04d", 0, 10), kCharacterAnimationTime))
  node:addChild(pointEffectSprite)

  local function onAnimationFinished()
    if backSprite then backSprite:runAction(CCFadeOut:create(0.5)) end
    if frontSprite then frontSprite:runAction(CCFadeOut:create(0.5)) end
    if pointEffectSprite then
      pointEffectSprite:stopAllActions()
      pointEffectSprite:runAction(CCFadeOut:create(0.5))
    end
  end

  node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(onAnimationFinished)))
  return node
end

local function create2BirdDestroyEffect()  
  local node = CocosObject:create()
  local galaxy = ParticleSystemQuad:create("particle/fast_galaxy.plist")
  galaxy:setPosition(ccp(0,0))
  galaxy:setDuration(-1)
  node:addChild(galaxy)

  local backSprite = Sprite:createWithSpriteFrameName("bird_galaxy0000")
  backSprite:setScale(0.35)
  backSprite:runAction(CCScaleTo:create(0.5, 1.1))
  backSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 50)))
  node:addChild(backSprite)

  local pop = ParticleSystemQuad:create("particle/star_pop.plist")
  pop:setPosition(ccp(0,0))
  pop:setDuration(-1)
  node:addChild(pop)

  local frontSprite = Sprite:createWithSpriteFrameName("bird_star0000")
  frontSprite:setScale(0.35)
  frontSprite:runAction(CCScaleTo:create(0.5, 1.3))
  frontSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 150)))
  node:addChild(frontSprite)

  local pointEffectSprite = Sprite:createWithSpriteFrameName("bird_effect_point0000")
  pointEffectSprite:setScale(1.2)
  pointEffectSprite:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("bird_effect_point%04d", 0, 10), kCharacterAnimationTime))
  node:addChild(pointEffectSprite)

  node.finish = function ()
    if backSprite then backSprite:runAction(CCFadeOut:create(0.5)) end
    if frontSprite then frontSprite:runAction(CCFadeOut:create(0.5)) end
    if pointEffectSprite then
      pointEffectSprite:stopAllActions()
      pointEffectSprite:runAction(CCFadeOut:create(0.5))
    end
    pop:stopSystem()
    galaxy:stopSystem()
  end
  --node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(onAnimationFinished)))
  return node
end

function TileBird:stop2BirdDestroyAnimation()
  local effectLayer = self.effectLayer
  local function onStartFadeOut() effectLayer:finish() end
  local function onAnimationFinished() self:removeFromParentAndCleanup(true) end
  local effectArray = CCArray:create()
  effectArray:addObject(CCEaseSineOut:create(CCScaleTo:create(0.5, 4))) 
  effectArray:addObject(CCCallFunc:create(onStartFadeOut))
  effectArray:addObject(CCScaleTo:create(0.5, 1))
  
  effectLayer:runAction(CCSequence:create(effectArray))
end

function TileBird:play2BirdDestroyAnimation()
  self.effectSprite:stopAllActions()
  self.effectSprite:setVisible(false)
  self.mainSprite:stopAllActions()
  self.mainSprite:setVisible(false)

  local effectLayer = create2BirdDestroyEffect()
  
  local effectArray = CCArray:create()
  effectArray:addObject(CCScaleTo:create(0.5, 1.5))
  effectArray:addObject(CCScaleTo:create(0.5, 0.8))
 
  effectLayer:setScale(0.5)
  effectLayer:runAction(CCSequence:create(effectArray))
  self:addChild(effectLayer)
  self.effectLayer = effectLayer

  local frontSprite = Sprite:createWithSpriteFrameName("bird_destroy0000")
  local function onBirdAnimationFinished()
    if frontSprite then
      frontSprite:stopAllActions()
      frontSprite:runAction(CCFadeOut:create(0.5))
    end
  end
  frontSprite:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("bird_destroy%04d", 0, 20), kCharacterAnimationTime), 0 , 1, onBirdAnimationFinished)
  self:addChild(frontSprite)
end

function TileBird:play2BirdExplodeAnimation(explodePositionList)
  local effectLayer = CocosObject:create()
  local function onStartExplode()
    for i, position in ipairs(explodePositionList) do
      position = effectLayer:convertToNodeSpace(position)
      effectLayer:addChild(Firebolt:create(ccp(0,0), position, 0.5))
    end
  end
  local effectArray = CCArray:create()
  effectArray:addObject(CCDelayTime:create(0.0))
  effectArray:addObject(CCCallFunc:create(onStartExplode))
  effectLayer:runAction(CCSequence:create(effectArray))
  effectLayer:setScale(0.5)
  return effectLayer
end

function TileBird:playDestroyAnimation_old()
  self.effectSprite:stopAllActions()
  self.effectSprite:setVisible(false)

  self.mainSprite:stopAllActions()
  self.mainSprite:setVisible(false)

  self:addChild(createBirdDestroyEffect())

  local frontSprite = Sprite:createWithSpriteFrameName("bird_destroy0000")
  local function onBirdAnimationFinished()
    if frontSprite then
      frontSprite:stopAllActions()
      frontSprite:runAction(CCFadeOut:create(0.5))
    end
  end
  frontSprite:play(SpriteUtil:buildAnimate(SpriteUtil:buildFrames("bird_destroy%04d", 0, 20), kCharacterAnimationTime), 0 , 1, onBirdAnimationFinished)
  self:addChild(frontSprite)

  local function onAnimationFinished()
    self:stopAllActions()
    self:dp(Event.new(Events.kComplete, kTileBirdAnimation.kDestroy, self))
  end
  self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2), CCCallFunc:create(onAnimationFinished)))
end

function TileBird:buildAndRunDestroyAction(actionTarget)
  if actionTarget then
    local position = self:getPosition()
    local radius = kBirdContentSize*2 + kBirdContentSize * 0.5    ----去掉了随机函数，影响最后结果
    local action = CCEaseSineInOut:create(HELens3D:create(0.8, CCSizeMake(15,10), ccp(position.x, position.y), radius))

    local function onAnimationFinished()
      if actionTarget and actionTarget.refCocosObj then
        actionTarget:setGrid(nil)
      end
    end

    actionTarget:stopAllActions()
    actionTarget:runAction(CCSequence:createWithTwoActions(action, CCCallFunc:create(onAnimationFinished)))
  end
end


-----创建永久的鸟爆炸背景特效-----
function TileBird:createBirdDestroyEffectForever(scaleTo)
  scaleTo = scaleTo or 2

  local node = CocosObject:create()
  node.name = "TileBird"
  -----------------------------------------galaxy------------------------------------
  local galaxy = ParticleSystemQuad:create("particle/fast_galaxy.plist")
  galaxy:setAutoRemoveOnFinish(true)
  galaxy:setPosition(ccp(0,0))
  node:addChild(galaxy)
  -----------------------------------------backSprite--------------------------------
  local backSprite = Sprite:createWithSpriteFrameName("bird_galaxy0000")
  backSprite:setScale(0.35)
  backSprite.name = "backSprite";
  local function onBackBeginAnimation()
    if backSprite then
      backSprite:stopAllActions()
      backSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 50)))
    end
  end 
  local backBeginAction = CCSpawn:createWithTwoActions(CCScaleTo:create(0.5, 1.5), CCRotateTo:create(0.5, 50))
  backSprite:runAction(CCSequence:createWithTwoActions(backBeginAction, CCCallFunc:create(onBackBeginAnimation)))
  node:addChild(backSprite)
  -----------------------------------------pop---------------------------------------
  local pop = ParticleSystemQuad:create("particle/star_pop.plist")
  pop:setAutoRemoveOnFinish(true)
  pop:setPosition(ccp(0,0))
  node:addChild(pop)
  -----------------------------------------frontSprite-------------------------------
  local frontSprite = Sprite:createWithSpriteFrameName("bird_star0000")
  frontSprite:setScale(0.35)
  local function onFrontBeginAnimation()
    if frontSprite then
      frontSprite:stopAllActions()
      frontSprite:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 150)))
    end
  end
  local frontBeginAction = CCSpawn:createWithTwoActions(CCScaleTo:create(0.5, 1.6), CCRotateTo:create(0.5, 150))
  frontSprite:runAction(CCSequence:createWithTwoActions(frontBeginAction, CCCallFunc:create(onFrontBeginAnimation)))
  node:addChild(frontSprite)
  ----------------------------------------pointEffectSprite---------------------------
  local pointEffectSprite = Sprite:createWithSpriteFrameName("bird_effect_point0000")
  pointEffectSprite:setScale(1.8)
  local animate = SpriteUtil:buildAnimate(SpriteUtil:buildFrames("bird_effect_point%04d", 0, 10), kCharacterAnimationTime)
  pointEffectSprite:play(animate)
  node:addChild(pointEffectSprite)

  local effectArray = CCArray:create()
  effectArray:addObject(CCDelayTime:create(0.4))
  effectArray:addObject(CCEaseSineOut:create(CCScaleTo:create(0.7, scaleTo)))
  effectArray:addObject(CCDelayTime:create(0.9))
  effectArray:addObject(CCEaseSineIn:create(CCScaleTo:create(0.3, 0)))
 
  node:setScale(0.5)
  node:runAction(CCSequence:create(effectArray))

  return node
end

-----消除永久的鸟爆炸特效-------
function TileBird:deleteBirdDestroyEffect(effectnode)
    local theNode = effectnode
    local backSprite = effectnode:getChildByName("backSprite");
    local frontSprite = effectnode:getChildByName("frontSprite");
    local pointEffectSprite = effectnode:getChildByName("pointEffectSprite");

    if backSprite then 
      backSprite:stopAllActions()
      backSprite:runAction(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCRotateBy:create(0.5,50)))
    end
    if frontSprite then
      frontSprite:stopAllActions()
      frontSprite:runAction(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCRotateBy:create(0.5,150)))
    end
    if pointEffectSprite then
      pointEffectSprite:stopAllActions()
      pointEffectSprite:runAction(CCFadeOut:create(0.5))
    end

    local function onAnimationFinished()
      theNode:removeFromParentAndCleanup(true);        ----将自己从父节点删除
    end
    effectnode:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(onAnimationFinished)))
end

--------消除鸟的动画------------
function TileBird:playDestroyAnimation()
  self.effectSprite:stopAllActions()
  self.effectSprite:setVisible(false)

  self.mainSprite:stopAllActions()
  self.mainSprite:setVisible(false)

  local frontSprite = Sprite:createWithSpriteFrameName("bird_destroy0000")
  local frames = SpriteUtil:buildFrames("bird_destroy%04d", 0, 20)

  local function onBirdAnimationFinished()
    if frontSprite then
      frontSprite:stopAllActions()
      frontSprite:runAction(CCFadeOut:create(0.5))
    end
  end

  local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  frontSprite:play(animate, 0 , 1, onBirdAnimationFinished)
  self:addChild(frontSprite)

  local function onAnimationFinished()
    self:stopAllActions()
    self:dp(Event.new(Events.kComplete, kTileBirdAnimation.kDestroy, self))
    self:removeFromParentAndCleanup(true)
  end
  self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2), CCCallFunc:create(onAnimationFinished)))
end
