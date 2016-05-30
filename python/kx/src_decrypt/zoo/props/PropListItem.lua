require "hecore.display.Director"
require "zoo.props.PropItemAnimator"

PropListItem = class(EventDispatcher)

function PropListItem:ctor()
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

  self.animator = PropItemAnimator:create(self)
end

function PropListItem:create(index, pedicle, item, propListAnimation)
	local ret = PropListItem.new()
	ret:buildUI(index, pedicle, item)
	ret.propListAnimation = propListAnimation
  ret.controller = propListAnimation.controller
	return ret
end

function PropListItem:setItemTouchEnabled( v )
  self.isTouchEnabled = v
end

function PropListItem:dispose()
  if self.animateID then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.animateID) end
  self.animateID = nil
  self.propListAnimation = nil
end

function PropListItem:buildUI(index, pedicle, item)
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

  local prop_disable_size = prop_disable_icon:getContentSize()
  local prop_disable_pos = prop_disable_icon:getPosition()
  prop_disable_icon:setVisible(false)
  prop_disable_icon:setCascadeOpacityEnabled(false)
  prop_disable_icon:setAnchorPoint(ccp(0.5, 0.5))
  prop_disable_icon:setPosition(ccp(prop_disable_pos.x + prop_disable_size.width/2, prop_disable_pos.y - prop_disable_size.height/2))

  item:getChildByName("t_bg_label"):setVisible(false)
  item:getChildByName("name_label"):setVisible(false)
  item:getChildByName("red_bg_label"):setVisible(false)
  item:getChildByName("time_limit_flag"):setVisible(false)
  item:getChildByName("free_flag"):setVisible(false)

  local normalSize = bg_normal:getContentSize()
  local normalPos = bg_normal:getPosition()
  bg_normal:setAnchorPoint(ccp(0.5, 0.5))
  bg_normal:setPosition(ccp(normalPos.x + normalSize.width/2, normalPos.y - normalSize.height/2))

  bg_selected:setVisible(false)
  icon_add:setVisible(false)

  self:initIconSize()

  self.center = {x = self.iconSize.x + self.iconSize.width/2, y = self.iconSize.y - self.iconSize.height /2, r = normalSize.width/2}

  local sprite = CCSprite:createWithSpriteFrameName("prop_bubble10000")
  local batch = SpriteBatchNode:createWithTexture(sprite:getTexture())
  item:addChild(batch)
  self.batch = batch
end

function PropListItem:initIconSize()
  local content = self.item:getChildByName("content")
  local contentPos = content:getPosition()
  local contentSize = content:getContentSize()
  local contentScale = content:getScale()
  self.iconSize = {x = contentPos.x, y = contentPos.y, width = contentSize.width*contentScale, height = contentSize.height*contentScale}
  content:removeFromParentAndCleanup(true)
end

function PropListItem:getItemCenterPosition()
  local item = self.item
  local iconSize = self.iconSize
  local x = iconSize.x + iconSize.width/2
  local y = iconSize.y - iconSize.height/2
  local position = ccp(x, y)
  if self.isPlayShowAnimation then -- show动画时是从scale0开始的,转换后的位置不正确,直接计算
    local itemPos = item:getPosition()
    position = ccp(itemPos.x + x, itemPos.y + y)
    position = item:getParent():convertToWorldSpace(position)
  else
    position = item:convertToWorldSpace(position)
  end
  return position
  -- return item:getParent():convertToNodeSpace(position)
end

function PropListItem:hide()
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

function PropListItem:updateItemNumber()
  local prop = self.prop
  if self.item.isDisposed then
      return
  end
  local itemNum = self.prop:getTotalItemNumber()
  self.item_number.offsetX = self.labelOffsetX
  local displayNum = self.prop:getDisplayItemNumber()
  if displayNum > 99 then
    self.item_number.offsetX = self.labelOffsetX+5
    self.item_number:setString("99+")
    self.item_number:setScale(0.8)
    self.item_number:setPositionY(self.labelOffsetY-3)
  else
    self.item_number:setString(tostring(displayNum))
    self.item_number:setScale(1)
    self.item_number:setPositionY(self.labelOffsetY)
  end

  local item = self.item
  local icon_add = item:getChildByName("icon_add")
  local bg_label = item:getChildByName("bg_label")  
  local t_bg_label = item:getChildByName("t_bg_label")
  local red_bg_label = item:getChildByName("red_bg_label")
  local timeLimitFlag = item:getChildByName("time_limit_flag")
  local freeFlag = item:getChildByName("free_flag")

  icon_add:setVisible(false)
  bg_label:setVisible(false)
  red_bg_label:setVisible(false)
  t_bg_label:setVisible(false)
  self.item_number:setVisible(false)
  timeLimitFlag:setVisible(false)
  freeFlag:setVisible(false)

  if itemNum < 1 then
  	icon_add:setVisible(true)
    t_bg_label:stopAllActions()
  else
    if self.prop:isTemporaryMode() then
      t_bg_label:setVisible(true)
      freeFlag:setVisible(true)
    elseif self.prop:getTimePropNum() > 0 then
      red_bg_label:setVisible(true)
      timeLimitFlag:setVisible(true)
    else
      bg_label:setVisible(true)
    end
    self.item_number:setVisible(true)
  end

  if self.prop:isMaxUsed() then
    if not self.disabled then self:lock(true) end
  end
end

function PropListItem:getDefaultItemID()
    return self.prop:getDefaultItemID()
end

function PropListItem:setPropItemData(propItemData, isUnlimited)
  self.prop = propItemData
  self.prop:initTimeProps()

  self.prop:enableUnlimited(isUnlimited)
end

function PropListItem:isAddMoveProp()
  --推送召回功能 三免费道具打关卡需求 10057 临时魔力扫把
  return self.prop and self.prop:isAddMoveProp(self.propListAnimation.levelId) 
end

function PropListItem:setTemporaryMode(v)
  local item = self.item
  local itemNum = self.prop:getTotalItemNumber()
  if itemNum > 0 then
    local t_bg_label = item:getChildByName("t_bg_label")
    local bg_label = item:getChildByName("bg_label")
    local red_bg_label = item:getChildByName("red_bg_label")
    t_bg_label:setVisible(v)
    t_bg_label:stopAllActions()
    bg_label:setVisible(not v)
    red_bg_label:setVisible(not v)
    if v and self.disabled then self:lock(false) end
    if v then t_bg_label:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCTintTo:create(0.8, 220,220,220), CCTintTo:create(0.8, 255,255,255)))) end
  end   
end

function PropListItem:hintTemporaryMode()
  if self.prop:isTemporaryMode() and not self.isHintMode then
    self.isHintMode = true
  end
end

function PropListItem:useWithType(itemId, propType)
  assert(type(itemId)=="number")
  assert(type(propType) == "number")

  local tempItem = self.prop:useWithType(itemId, propType)
  if tempItem then 
      self:_updateTemporaryMode() 
  end

  self:updateItemNumber()
end

function PropListItem:show(delayTime, newIcon, initDisable)
  self.visible = true
  self.isPlayShowAnimation = true
  
	local delay = delayTime + self.index * 0.1
	local item = self.item
  local bg_normal = item:getChildByName("bg_normal")
  local bg_label = item:getChildByName("bg_label")
  local icon_add = item:getChildByName("icon_add")

  local prop = self.prop
  assert(prop, "prop should not be nil!!!!!!!")
  local itemId = prop and prop.itemId or 0

  self.itemName = Localization:getInstance():getText("prop.name."..itemId)
  item:getChildByName("name_label"):setString(self.itemName)

  self:setTemporaryMode(self.prop:isTemporaryMode())
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

  self.startAngle = self.beginRotation

  self.animator:show(newIcon)

  if newIcon then
    if self.icon then self.icon:removeFromParentAndCleanup(true) end
    local icon = PropListAnimation:createIcon(itemId)
    if icon then
    	icon:setCascadeOpacityEnabled(true)
  		icon:setCascadeColorEnabled(true)
    	icon:setPosition(ccp(self.iconSize.x + self.iconSize.width/2, self.iconSize.y - self.iconSize.height/2))
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

function PropListItem:isItemRequireConfirm()
    return self.prop:isItemRequireConfirm()
end

function PropListItem:verifyItemId( itemId )
    return self.prop:verifyItemId(itemId)
end

function PropListItem:confirm(itemId, usedPositionGlobal)
	local prop = self.prop
	if not prop then return end

	self.isAnimating = true

	local function onClearAnimate()
		self.isAnimating = false
		if self.animateID then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.animateID) end
		self.animateID = nil
	end
	self.animateID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onClearAnimate,1,false);

  local isTemporaryMode = self.prop:confirm(itemId, self.propListAnimation.levelId)
  if isTemporaryMode then
    self:_updateTemporaryMode()  	
  end

	self:updateItemNumber()

	self:bubble(0.3)
	self:explode(0.4, usedPositionGlobal)
end

function PropListItem:playMaxUsedAnimation(tipDesc)
  self.animator:shake()
  self.animator:playMaxUsedAnimation(tipDesc)
end

function PropListItem:use()
	local prop = self.prop
  local meta = self.prop:getPropMeta()
  if not prop or not meta then return false end
  
	--avoid use prop multy times
	if self.isAnimating then return false end

	if not prop or self.prop:getTotalItemNumber() < 1 then 
		    self.animator:shake()
		    if self.controller.buyPropCallback then
			    self.controller:callBuyPropCallback(prop.itemId)
		    end

		return false
	end
 
  if self.prop:isMaxUsed() then
    local tip = Localization:getInstance():getText("prop.disabled.tip2", {num=self.prop.maxUsetime})
    self:playMaxUsedAnimation(tip)
    return false
  elseif self.reasonType then
    if self.reasonType == 1 then
      local tip = Localization:getInstance():getText("prop.disabled.tip3", {num=self.prop.maxUsetime})
      self:playMaxUsedAnimation(tip)
    elseif self.reasonType == 2 then
      local tip = Localization:getInstance():getText("prop.disabled.tip4", {num=self.prop.maxUsetime})
      self:playMaxUsedAnimation(tip)
    elseif self.reasonType == 3 then
      local tip = Localization:getInstance():getText("prop.disabled.tip6")
      self:playMaxUsedAnimation(tip)
    elseif self.reasonType == 4 then
      local tip = Localization:getInstance():getText("prop.disabled.tip7")
      self:playMaxUsedAnimation(tip)
    end 
    return false
  end

  local usePropType = self.prop:getPropType()

	-- Use Prop Callback
	if self.controller.usePropCallback then

		local itemId 		= self.prop:findItemID()		
		local isRequireConfirm	= self.prop:isItemRequireConfirm()

    print("use prop:", itemId, usePropType, isRequireConfirm)
		return self.controller:callUsePropCallback(self, itemId, usePropType, isRequireConfirm)
	end
  return true
end

function PropListItem:focus( enabled, confirm )
	local prop = self.prop
	if not prop then return end

  if self.disabled then return end

	if self.isPlayShowAnimation then
		print("ERROR!!! focus item can not executed before display animation finished")
		return
	end

  self.animator:focus(enabled, confirm)

end

function PropListItem:lock(v)
  if v == self.disabled then return end
  local item = self.item
  if v then
      local darkAnimationTime = 0.3
      item:stopAllActions()
      item:setScale(1)
      item:setRotation(self.startAngle or 0)
      item:setPosition(ccp(self.beginPosition.x, self.beginPosition.y))
      item:runAction(CCSpawn:createWithTwoActions(CCFadeTo:create(darkAnimationTime, 130), CCEaseElasticOut:create(CCScaleTo:create(darkAnimationTime, 0.75))))
  else
      local darkAnimationTime = 0.25
      item:setScale(1)
      item:setRotation(self.startAngle or 0)
      item:stopAllActions()
      item:setOpacity(255)
      item:setScale(1)
  end
  self.disabled = v
end

function PropListItem:dark( enabled )
	if self.isPlayShowAnimation then
		print("ERROR!!! dark item can not executed before display animation finished")
		return
	end
  if self.disabled then return end

  self.animator:dark(enabled)
end

function PropListItem:stopHint()
	self.isAnimateHint = false
	self.isHintMode = false
  self.item:stopAllActions()
end

function PropListItem:increaseTimePropNumber(propId, itemNum, expireTime)
  if ItemType:isTimeProp(propId) then
    self.prop:increaseTimePropNumber(propId, itemNum, expireTime)
    self:_updateTemporaryMode()
    self.animator:playIncreaseAnimation()
    self:hintTemporaryMode()
  end
end

function PropListItem:increaseItemNumber( itemId, itemNum )
  local isTemp  = self.prop:increaseItemNumber(itemId, itemNum)

  if isTemp then
    self:_updateTemporaryMode()
    self.animator:playIncreaseAnimation()
    self:hintTemporaryMode()
  else
    self.animator:playIncreaseAnimation()
  end
end

function PropListItem:_updateTemporaryMode()
  --self.prop:updateTemporaryItemNumber(itemId, itemNum)

  if self.prop:isTemporaryExist() then 
    self:setTemporaryMode(true) 
  else 
    self:setTemporaryMode(false)
  end
end

function PropListItem:increaseTemporaryItemNumber( itemId, itemNum )
  self.prop:updateTemporaryItemNumber(itemId, itemNum)
  self:_updateTemporaryMode()
  self.animator:playIncreaseAnimation()
  self:hintTemporaryMode()
end

function PropListItem:explode( animationTime, usedPositionGlobal )
  self.isPlayExplodeAnimation = true
  local function onAnimationFinished()
    self.isPlayExplodeAnimation = false
    if self.isAnimateHint then 
      self:stopHint() 
    end
    if self:isAddMoveProp() then 
      self:hide() 
      self.isExplodeing = false
    else 
      self:show(0)
    end
    if self.prop and self.prop:isTemporaryMode() and self.onTemporaryItemUsed ~= nil then 
      self:onTemporaryItemUsed(self) 
    end 
  end

  self.animator:explode(animationTime, usedPositionGlobal, onAnimationFinished)
end

function PropListItem:isPlayingAnimation()
  if self.disabled then return false end
  return self.isPlayShowAnimation or self.isPlayExplodeAnimation
end

function PropListItem:bubble(delayTime)
   self.animator:bubble(delayTime)
end

function PropListItem:hitTest( position )
  local isTouchDisaable = self.darked or self.isPlayShowAnimation or not self.isTouchEnabled 
	if isTouchDisaable then return false end

	local center = self.center
	position = self.item:convertToNodeSpace(position)
	local dx = position.x - center.x
	local dy = position.y - center.y
	return (dx * dx + dy * dy) < center.r * center.r
end

function PropListItem:setDisableReason(reasonType)
  if self.isPlayShowAnimation then
    self.isPlayShowAnimation = false
  end
  self.reasonType = reasonType
  self:lock(true)
end

function PropListItem:addNumber(itemNum)
    self.prop:addNumber(itemNum)
    self:updateItemNumber()
end

function PropListItem:setNumber(itemNum)
    self.prop:setNumber(itemNum)
    self:updateItemNumber()
end

function PropListItem:setEnable()
  self.reasonType = nil
  if self.prop:isMaxUsed() then
    self:lock(true)
  else
    self:lock(false)
  end
end
