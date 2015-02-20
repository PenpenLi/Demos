require 'zoo.animation.PropListItem'
require 'zoo.animation.SpringFestivalEffect'

SpringPropListItem = class(PropListItem)

function SpringPropListItem:ctor()
  self.direction = 1
  self.visible = true
  self.disabled = false
  self.usedTimes = 0
  self.maxUsetime = 0
  self.onTemporaryItemUsed = nil --function
  self.isTouchEnabled = true
  self.isExplodeing = false --正在播放使用动画
  self.timePropNum = 0 -- 限时道具数量
  self.timePropList = nil

  self.isOnceUsed =  false
end

function SpringPropListItem:create(index, pedicle, item, propListAnimation, iconSize)
    local ret = SpringPropListItem.new()
    ret:buildUI(index, pedicle, item, iconSize)
    ret.propListAnimation = propListAnimation
    return ret
end

function SpringPropListItem:setItemTouchEnabled( v )
  self.isTouchEnabled = v
end

function SpringPropListItem:dispose()
  if self.animateID then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.animateID) end
  self.animateID = nil
  self.propListAnimation = nil
end

function SpringPropListItem:buildUI(index, pedicle, item, iconSize)
    self.index = index
    self.pedicle = pedicle
    self.item = item

  local contentSize = item:getGroupBounds().size
  item:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
  
  local item_number = item:getChildByName("item_number")
  local item_numberPos = item_number:getPosition()
  self.labelOffsetX = item_numberPos.x
  self.labelOffsetY = item_numberPos.y
  item_number.offsetX = item_numberPos.x
  item_number:setAlignment(kCCTextAlignmentCenter)
  self.item_number = item_number

  self.beginRotation = item:getRotation()
  local itemPosition = item:getPosition()
  self.beginPosition = {x=itemPosition.x, y=itemPosition.y}

  pedicle:setVisible(false)
  item:setVisible(false)

  local bg_normal = item:getChildByName("bg_normal")
  local bg_selected = item:getChildByName("bg_selected")
  local icon_add = item:getChildByName("icon_add")
  local prop_disable_icon = item:getChildByName("prop_disable_icon")

  bg_normal:setVisible(false)

  local prop_disable_size = prop_disable_icon:getContentSize()
  local prop_disable_pos = prop_disable_icon:getPosition()
  prop_disable_icon:setVisible(false)
  prop_disable_icon:setCascadeOpacityEnabled(false)
  prop_disable_icon:setAnchorPoint(ccp(0.5, 0.5))

  item:getChildByName("t_bg_label"):setVisible(false)
  item:getChildByName("name_label"):setVisible(false)
  item:getChildByName("red_bg_label"):setVisible(false)
  item:getChildByName("time_limit_flag"):setVisible(false)

  local normalSize = bg_normal:getContentSize()
  local normalPos = bg_normal:getPosition()

  bg_selected:setVisible(false)
  icon_add:setVisible(false)

  self.iconSize = iconSize
  self.center = {x = self.iconSize.x + self.iconSize.width/2, y = self.iconSize.y - self.iconSize.height /2, r = normalSize.width/2}
end

function SpringPropListItem:getItemCenterPosition()
  local item = self.item
  local iconSize = self.iconSize
  local x = iconSize.x + iconSize.width/2
  local y = iconSize.y - iconSize.height/2
  local position = ccp(x, y)
  position = item:convertToWorldSpace(position)
  return item:getParent():convertToNodeSpace(position)
end

function SpringPropListItem:hide()
  self.visible = false
  
  self.pedicle:setVisible(false)

  self.item:setVisible(false)
  self.item:stopAllActions()
    
  self.prop = nil
  
  if self.icon then self.icon:removeFromParentAndCleanup(true) end
  self.icon = nil
  
  self.isAnimateHint = false
  self.isAnimating = false
  self.isHintMode = false
  self.isPlayShowAnimation = false
  self.darked = false
  self.focused = false
  if self.animateID then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.animateID) end
  self.animateID = nil

  if self.onHideCallback ~= nil then self.onHideCallback(self) end
end

function SpringPropListItem:updateItemNumber()

  local item = self.item
  local icon_add = item:getChildByName("icon_add")
  local bg_label = item:getChildByName("bg_label")  
  local t_bg_label = item:getChildByName("t_bg_label")
  local red_bg_label = item:getChildByName("red_bg_label")
  local timeLimitFlag = item:getChildByName("time_limit_flag")

  icon_add:setVisible(false)
  bg_label:setVisible(false)
  red_bg_label:setVisible(false)
  t_bg_label:setVisible(false)
  self.item_number:setVisible(false)
  timeLimitFlag:setVisible(false)

end

function SpringPropListItem:findItemID()
  return 9999
end
function SpringPropListItem:getDefaultItemID()
  return 9999
end

function SpringPropListItem:getItemNumber()
  return 0
end

function SpringPropListItem:getTotalItemNumber()
  return 0
end

function SpringPropListItem:getDisplayItemNumber()
  return 0
end

function SpringPropListItem:getPropMeta()
  return {}
end

function SpringPropListItem:isTemporaryMode()
  return false
end

function SpringPropListItem:updateTimePropNum()
end

function SpringPropListItem:useTimeProp()
end

function SpringPropListItem:updateTimeProps()
end

function SpringPropListItem:getTimePropNum()
  return 0
end

function SpringPropListItem:setTimeProps(props)
end

function SpringPropListItem:isAddMoveProp()
  return false
end

function SpringPropListItem:setTemporaryMode(v)
end

function SpringPropListItem:hintTemporaryMode()
end

function SpringPropListItem:useWithType(itemId, propType)
end

function SpringPropListItem:show(delayTime, newIcon, initDisable)
  self.visible = true
  self.isPlayShowAnimation = true
  
    local delay = delayTime + self.index * 0.1
    local pedicle = self.pedicle
    local item = self.item
  local bg_normal = item:getChildByName("bg_normal")
  local bg_label = item:getChildByName("bg_label")
  local icon_add = item:getChildByName("icon_add")

  local prop = self.prop
  local itemId = prop and prop.itemId or 0
  local meta = self:getPropMeta()
  self.itemName = Localization:getInstance():getText("prop.name."..itemId)
  item:getChildByName("name_label"):setString(self.itemName)
  self.maxUsetime = meta.maxUsetime or 0

  -- self.maxUsetime = 1000000

  if self.isUnlimited == true then self.maxUsetime = 4294967295 end
  self:setTemporaryMode(self:isTemporaryMode())
  self:updateItemNumber()

  self.item_number:stopAllActions()
  self.item_number:setOpacity(255)

  bg_label:stopAllActions()
  bg_label:setOpacity(255)

  icon_add:stopAllActions()
  icon_add:setOpacity(255)

  bg_normal:stopAllActions()
  bg_normal:setScale(1)
  bg_normal:setRotation(0)
  bg_normal:setOpacity(255)

  if newIcon then
    pedicle:stopAllActions()
    pedicle:setOpacity(0)
    pedicle:setVisible(true)
    pedicle:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delay), CCFadeIn:create(0.1)))
  end

  local function onAnimationFinished()
    self.isPlayShowAnimation = false
  end
  local animationTime = 0.15 + math.random()*0.15
  local startAngle = (30 + math.random()*30) * -self.direction
  local scaleTo = CCScaleTo:create(animationTime, 1.1)
  local rotatTo = CCRotateTo:create(animationTime * 10, self.beginRotation)
  local array = CCArray:create()
  array:addObject(CCDelayTime:create(delay))
  array:addObject(CCShow:create())
  array:addObject(CCEaseSineOut:create(scaleTo))
  array:addObject(CCEaseQuarticBackOut:create(CCScaleTo:create(animationTime, 1), 33, -106, 126, -67, 15))
  array:addObject(CCCallFunc:create(onAnimationFinished))

  item:stopAllActions()
  item:setVisible(false)
  item:setScale(0)
  item:setRotation(startAngle)
  item:setPosition(ccp(self.beginPosition.x, self.beginPosition.y))
  item:runAction(CCSequence:create(array))
  item:runAction(CCEaseElasticOut:create(rotatTo))

  self.startAngle = self.beginRotation

  if newIcon then
    if self.icon then self.icon:removeFromParentAndCleanup(true) end
    local icon = self:buildItemIcon()
    if icon then
        icon:setCascadeOpacityEnabled(true)
        icon:setCascadeColorEnabled(true)
        icon:setPosition(ccp(self.iconSize.x + 40, self.iconSize.y - 37))
        item:addChildAt(icon, 4)
      if initDisable then
        item:setOpacity(130)
        self.disabled = true
        self.reasonType = 1
      end
    end
    self.icon = icon
  else
    local icon = self.icon
    if icon then
      icon:stopAllActions() -- If some times icon hide, can fix by stopAllActions
      icon:setVisible(true)
      icon:setOpacity(255)
      icon:setPosition(ccp(self.iconSize.x + self.iconSize.width/2, self.iconSize.y - self.iconSize.height/2))
    end    
  end
end

function SpringPropListItem:isItemRequireConfirm()
    return false
end

function SpringPropListItem:isTempItem(itemId)
  return false
end

function SpringPropListItem:isTimeItem( itemId )
  return false
end

function SpringPropListItem:verifyItemId( itemId )
  return false
end

function SpringPropListItem:confirm(itemId, usedPositionGlobal)
end

function SpringPropListItem:playMaxUsedAnimation(tipDesc)
end
function SpringPropListItem:use()

    local function localCallback()
        self.propListAnimation.springItemCallback()
    end

    local function playMusic()
      GamePlayMusicPlayer:playEffect(GameMusicType.kFirework)
    end

    if self.percent >= 1 then
        setTimeOut(playMusic, 0.1)
        
        SpringFestivalEffect:playFireworkAnimation(localCallback)
        self:setPercent(0, true)
        self:stopHint()
        self:playGolden(false)
        return true
    end
    CommonTip:showTip(Localization:getInstance():getText("activity.GuoQing.mainPanel.tip.13"), "negative")
    return false
end

function SpringPropListItem:shake()
  local animationTimeA, animationTimeB = 0.05, 0.02
  local array = CCArray:create()
  array:addObject(CCRotateBy:create(animationTimeA, -4))
  array:addObject(CCRotateBy:create(animationTimeA*2, 8))
  array:addObject(CCRotateBy:create(animationTimeA, -4))
  array:addObject(CCRotateBy:create(animationTimeB, -2))
  array:addObject(CCRotateBy:create(animationTimeB, 2))
  self.item:setRotation(self.startAngle)
  self.item:runAction(CCSequence:create(array))
end

function SpringPropListItem:windover(delayTime)
  local item = self.item
  if not item or item.isDisposed then return end

  delayTime = delayTime or 0
  local animationTimeA, animationTimeB = 0.2, 0.3
  local array = CCArray:create()
  array:addObject(CCDelayTime:create(delayTime))
  array:addObject(CCRotateTo:create(animationTimeA, -3))
  array:addObject(CCRotateTo:create(animationTimeA * 2, 3))
  array:addObject(CCRotateTo:create(animationTimeA * 1.5, -2))
  array:addObject(CCRotateTo:create(animationTimeA, 2))
  array:addObject(CCRotateTo:create(animationTimeB, -1))
  array:addObject(CCRotateTo:create(animationTimeB, 1))
  array:addObject(CCRotateTo:create(animationTimeB, 0))
  
  self.item:setRotation(self.startAngle)
  self.item:stopActionByTag(10250)

  local windAction = CCSequence:create(array)
  windAction:setTag(10250)
  self.item:runAction(windAction)
end

function SpringPropListItem:focus( enabled, confirm )
end

function SpringPropListItem:lock(v)

end

function SpringPropListItem:stopHint()
    self.isAnimateHint = false
    self.isHintMode = false
  self.item:stopAllActions()
  self.item:setScale(1)
end

function SpringPropListItem:hint(delayTime)
  local context = self
  local item = context.item
  if context.isAnimateHint then 
    print("warning: hint animation is already playing.")
    return 
  end
  context.isAnimateHint = true
  context.isHintMode = true

  local function onHintCallback()
    if not PublishActUtil:isGroundPublish() then 
      local item = context.item
      if item and item.refCocosObj then
        local sequence = CCArray:create()
        sequence:addObject(CCScaleTo:create(0.12, 1.05, 0.6))
        sequence:addObject(CCScaleTo:create(0.24, 0.7, 1.05))
        sequence:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.25, 1), CCEaseBackOut:create(CCMoveBy:create(0.25, ccp(0, 10)))))
        sequence:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.25, 1.05, 1), CCMoveBy:create(0.25, ccp(0, -10))))
        sequence:addObject(CCScaleTo:create(0.1, 1.05, 0.7))
        sequence:addObject(CCScaleTo:create(0.1, 1))
        sequence:addObject(CCDelayTime:create(0.5))
        --item:stopAllActions()
        item:setPosition(ccp(context.beginPosition.x, context.beginPosition.y))
        item:runAction(CCRepeatForever:create(CCSequence:create(sequence)))
      end
    end
  end

  item:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onHintCallback)))
end

function SpringPropListItem:tmpAnimation(delayTime)
end

function SpringPropListItem:pushPropAnimation(delayTime)
  local context = self
  local item = context.item
  if context.isAnimateHint then 
    print("warning: hint animation is already playing.")
    return 
  end
  context.isAnimateHint = true
  context.isHintMode = true

  local function onHintCallback()
    if not PublishActUtil:isGroundPublish() then 
      local item = context.item
      if item and item.refCocosObj then
        local arr = CCArray:create()
        arr:addObject(CCScaleTo:create(0.6, 0.96, 1.1))
        arr:addObject(CCScaleTo:create(0.6, 0.98, 0.85))
        arr:addObject(CCScaleTo:create(0.6, 0.99, 1.1))
        arr:addObject(CCScaleTo:create(0.6, 1, 0.85))
        arr:addObject(CCScaleTo:create(0.6, 0.99, 1.1))
        arr:addObject(CCScaleTo:create(0.6, 0.98, 0.85))
        local action = CCRepeatForever:create(CCSequence:create(arr))
        item:setPosition(ccp(context.beginPosition.x, context.beginPosition.y))
        item:runAction(action)
      end
    end
  end
  self.hint = self.pushPropAnimation
  item:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onHintCallback)))
end

function SpringPropListItem:playIncreaseAnimation()

end
function SpringPropListItem:increaseItemNumber( itemId, itemNum )
end

function SpringPropListItem:updateTemporaryItemNumber( itemId, itemNum )
end
function SpringPropListItem:increateTemporaryItemNumber( itemId, itemNum )
end

function SpringPropListItem:explode( animationTime, usedPositionGlobal )
end

function SpringPropListItem:bubble(delayTime)

end

function SpringPropListItem:hitTest( position )
  local isTouchDisaable = self.darked or self.isPlayShowAnimation or not self.isTouchEnabled 
    if isTouchDisaable then return false end

    local center = self.center
    position = self.item:convertToNodeSpace(position)
    local dx = position.x - center.x
    local dy = position.y - center.y
    return (dx * dx + dy * dy) < center.r * center.r
end

function SpringPropListItem:setDisableReason(reasonType)
end

function SpringPropListItem:setEnable()
end

function SpringPropListItem:enableUnlimited(enable)
    self.isUnlimited = true
end

function SpringPropListItem:buildItemIcon()

    local container = Sprite:createEmpty()
    local item_gold = Sprite:createWithSpriteFrameName('item_gold')
    local item_grey = Sprite:createWithSpriteFrameName('item_empty')
    local item_full = Sprite:createWithSpriteFrameName('item_anim_0000')
    local rect = {size = {width = 140, height = 140}}
    local clipping = ClippingNode:create(rect)
    -- local clipping = Layer:create(rect)
    -- clipping:setContentSize(CCSizeMake(140, 140))

    container:addChild(item_grey)
    clipping:addChild(item_full)
    local layer = Layer:create()
    layer:setContentSize(CCSizeMake(rect.size.width, rect.size.height))
    layer:ignoreAnchorPointForPosition(false)
    layer:setAnchorPoint(ccp(0.5, 0.5))
    layer:addChild(clipping)
    container:addChild(layer)
    container:addChild(item_gold)
    item_full:setAnchorPoint(ccp(0, 0))
    self.clipping = clipping
    self.item_gold = item_gold
    self.item_full = item_full
    item_gold:setOpacity(0)
    container:setScale(1)

    local anim = SpriteUtil:buildAnimate(SpriteUtil:buildFrames('item_anim_%04d', 0, 20), 1/20)
    item_full:play(anim, 0, 0)

    self:setPercent(0, false)
    return container
end

function SpringPropListItem:setPercent(percent, playAnim)
    if percent > 1 then percent = 1 end
    if percent < 0 then percent = 0 end
    -- print('percent', percent)

    -- 这一段是为了让percent很低和很高时不至于不明显
    if percent == 1/SpringFireworkTotal and percent ~= 1 then
        percent = 1.6/SpringFireworkTotal
    elseif percent == (SpringFireworkTotal - 3)/SpringFireworkTotal then
        percent = (SpringFireworkTotal - 3.5)/SpringFireworkTotal
    elseif percent == (SpringFireworkTotal - 2)/SpringFireworkTotal then
        percent = (SpringFireworkTotal - 3)/SpringFireworkTotal
    elseif percent == (SpringFireworkTotal - 1)/SpringFireworkTotal then
        percent = (SpringFireworkTotal - 2.5)/SpringFireworkTotal
    end

    local length = 130
    local y = ( 1- percent) * length

    if not playAnim then
        self.item_full:setPositionY(y)
        self.clipping:setPositionY(-y)
    else
        self.item_full:stopActionByTag(123)
        self.clipping:stopAllActions()
        local action1 = CCMoveTo:create(0.5, ccp(0, y))
        action1:setTag(123)
        self.item_full:runAction(action1)
        self.clipping:runAction(CCMoveTo:create(0.5, ccp(0, -y)))
    end
    self.percent = percent
    
    if self.percent >= 1 then
      self:playGolden(true)
      self:pushPropAnimation(0)
    else
      self:windover(0)
    end

end

function SpringPropListItem:playGolden(enable)
  if enable then
    local action = CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeIn:create(0.6), CCFadeOut:create(0.6)))
    self.item_gold:runAction(action)
  else
    self.item_gold:stopAllActions()
    self.item_gold:runAction(CCFadeOut:create(0.3))
  end
end