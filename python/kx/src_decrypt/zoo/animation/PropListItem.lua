require "hecore.display.Director"

local kRequireConfirmItems = {10010, 10026, 10005, 10019, 10027, 10003, 10028, 10055, 10056, 10057}
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

  self.isOnceUsed =  false
end

function PropListItem:create(index, pedicle, item, propListAnimation)
	local ret = PropListItem.new()
	ret:buildUI(index, pedicle, item)
	ret.propListAnimation = propListAnimation
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

  local normalSize = bg_normal:getContentSize()
  local normalPos = bg_normal:getPosition()
  bg_normal:setAnchorPoint(ccp(0.5, 0.5))
  bg_normal:setPosition(ccp(normalPos.x + normalSize.width/2, normalPos.y - normalSize.height/2))

  bg_selected:setVisible(false)
  icon_add:setVisible(false)

  local content = item:getChildByName("content")
  local contentPos = content:getPosition()
  local contentSize = content:getContentSize()
  local contentScale = content:getScale()
  self.iconSize = {x = contentPos.x, y = contentPos.y, width = contentSize.width*contentScale, height = contentSize.height*contentScale}
  content:removeFromParentAndCleanup(true)

  self.center = {x = self.iconSize.x + self.iconSize.width/2, y = self.iconSize.y - self.iconSize.height /2, r = normalSize.width/2}

  local sprite = CCSprite:createWithSpriteFrameName("prop_bubble10000")
  local batch = SpriteBatchNode:createWithTexture(sprite:getTexture())
  item:addChild(batch)
  self.batch = batch
end

function PropListItem:getItemCenterPosition()
  local item = self.item
  local iconSize = self.iconSize
  local x = iconSize.x + iconSize.width/2
  local y = iconSize.y - iconSize.height/2
  local position = ccp(x, y)
  position = item:convertToWorldSpace(position)
  return item:getParent():convertToNodeSpace(position)
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
  local itemNum = self:getTotalItemNumber()
  self.item_number.offsetX = self.labelOffsetX
  local displayNum = self:getDisplayItemNumber()
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

  icon_add:setVisible(false)
  bg_label:setVisible(false)
  red_bg_label:setVisible(false)
  t_bg_label:setVisible(false)
  self.item_number:setVisible(false)
  timeLimitFlag:setVisible(false)

  if itemNum < 1 then
  	icon_add:setVisible(true)
    t_bg_label:stopAllActions()
  else
    if self:isTemporaryMode() then
      t_bg_label:setVisible(true)  
    elseif self:getTimePropNum() > 0 then
      red_bg_label:setVisible(true)
      timeLimitFlag:setVisible(true)
    else
      bg_label:setVisible(true)
    end
    self.item_number:setVisible(true)
  end

  local maxUsetime = self.maxUsetime or 0
  if maxUsetime > 0 and self.usedTimes >= maxUsetime and not isTemporaryMode then
    if not self.disabled then self:lock(true) end
  end
end

function PropListItem:findItemID()
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then return temporaryItemList[1].itemId end
  if self:getTimePropNum() > 0 then return self.timePropList[1].itemId end
  return self.prop.itemId
end
function PropListItem:getDefaultItemID()
  local prop = self.prop
  if prop then return prop.itemId end
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then return temporaryItemList[1].itemId end
  return 0
end

function PropListItem:getItemNumber()
  local prop = self.prop
  local itemNum = 0
  if prop then itemNum = prop.itemNum or 0 end
  return itemNum
end

function PropListItem:getTotalItemNumber()
  local prop = self.prop
  local itemNum = 0
  if prop then 
    itemNum = prop.itemNum or 0 
    local temporaryItemList = self.temporaryItemList
    if temporaryItemList and #temporaryItemList > 0 then
      for i,v in ipairs(temporaryItemList) do
        local number = v.itemNum or 0
        itemNum = itemNum + number
      end
    end
  end
  return itemNum + self:getTimePropNum()
end

function PropListItem:getDisplayItemNumber()
  local prop = self.prop
  local tempNum = 0
  if prop then 
    local temporaryItemList = self.temporaryItemList
    if temporaryItemList and #temporaryItemList > 0 then
      for i,v in ipairs(temporaryItemList) do
        local number = v.itemNum or 0
        tempNum = tempNum + number
      end
    end
  end
  if tempNum > 0 then
    return tempNum
  else
    local timePropNum = self:getTimePropNum()
    if timePropNum > 0 then
      return timePropNum
    else
      return prop.itemNum
    end
  end
end

function PropListItem:getPropMeta()
  local prop = self.prop
  if not prop then return nil end
  local itemId = prop.itemId
  return MetaManager:getInstance():getPropMeta(itemId)
end

function PropListItem:isTemporaryMode()
  if self.prop and self.prop.temporary == 1 then return true end
  return false
end

function PropListItem:updateTimePropNum()
  local num = 0
  if self.timePropList then
    for _,v in pairs(self.timePropList) do
      if v and v.itemNum then num = num + v.itemNum end
    end
  end
  self.timePropNum = num
end

function PropListItem:useTimeProp()
  for i,v in ipairs(self.timePropList) do
    if v.itemNum > 0 then 
      v.itemNum = v.itemNum - 1 
      self:updateTimeProps()
      return
    end
  end
end

function PropListItem:updateTimeProps()
  if self.timePropList then
    local newList = {}
    for i,v in ipairs(self.timePropList) do
      if v.itemNum > 0 then
        table.insert(newList, v)
      end
    end
    self.timePropList = newList
  end 
  self:updateTimePropNum()
end

function PropListItem:getTimePropNum()
  -- print("getTimePropNum:", self.timePropNum)
  return self.timePropNum
end

function PropListItem:setTimeProps(props)
  self.timePropList = {}
  if props and #props > 0 then
    for _,v in pairs(props) do
      table.insert(self.timePropList, v)
    end
    table.sort( self.timePropList, function( a, b )
      return a.expireTime < b.expireTime
    end )
    -- print("addTimeProps ret=", table.tostring(self.timePropList))
  end
  self:updateTimePropNum()
end

function PropListItem:isAddMoveProp()
  if self.prop and self.prop.itemId == 10004 then 
      return true 
  elseif self.prop.itemId == 10057 and RecallManager.getInstance():getRecallLevelState(self.propListAnimation.levelId) then--推送召回功能 三免费道具打关卡需求 10057 临时魔力扫把
      if self.isOnceUsed then 
        return true
      end
  end
  return false
end

function PropListItem:setTemporaryMode(v)
  local item = self.item
  local itemNum = self:getTotalItemNumber()
  if itemNum > 0 then
    local t_bg_label = item:getChildByName("t_bg_label")
    local bg_label = item:getChildByName("bg_label")
    local red_bg_label = item:getChildByName("red_bg_label")
    t_bg_label:setVisible(v)
    t_bg_label:stopAllActions()
    bg_label:setVisible(not v)
    red_bg_label:setVisible(not v)
    if v and self.disabled then self:lock(false) end
    if v then t_bg_label:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCTintTo:create(0.8, 200,200,200), CCTintTo:create(0.8, 255,255,255)))) end
  end   
end

function PropListItem:hintTemporaryMode()
  if self:isTemporaryMode() and not self.isHintMode then
    self.isHintMode = true
  end
end

function PropListItem:useWithType(itemId, propType)
  assert(type(itemId)=="number")
  assert(type(propType) == "number")

  -- print("~~useWithType:", itemId, propType)

  if propType == UsePropsType.NORMAL then
    if self.prop and self.prop.itemId == itemId then
      self.prop.itemNum = self.prop.itemNum - 1
    end
  elseif propType == UsePropsType.EXPIRE then
    for _,v in pairs(self.timePropList) do
      if v.itemId == itemId and v.itemNum > 0 then
        v.itemNum = v.itemNum - 1
        break
      end
    end
  elseif propType == UsePropsType.TEMP then
    local item = nil
    for _,v in pairs(self.temporaryItemList) do
      if v.itemId == itemId then 
        item = v 
        break
      end
    end
    if item then self:updateTemporaryItemNumber(itemId, item.itemNum - 1) end
  end
  self:updateItemNumber()
end

function PropListItem:show(delayTime, newIcon, initDisable)
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
    self:hintTemporaryMode()
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
	local prop = self.prop
	if not prop then return false end
	local itemId = prop.itemId
	for i,v in ipairs(kRequireConfirmItems) do
		if v == itemId then return true end
	end
	return false
end

function PropListItem:isTempItem(itemId)
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then
    for i,v in ipairs(temporaryItemList) do
      if v.itemId == itemId then return true end
    end
  end
  return false
end

function PropListItem:isTimeItem( itemId )
  if self.timePropList and #self.timePropList > 0 then
    for i,v in ipairs(self.timePropList) do
      if v.itemId == itemId then return true end
    end
  end
  return false
end

function PropListItem:verifyItemId( itemId )
  local prop = self.prop
  if not prop then return false end

  if self:isTempItem(itemId) 
      or self:isTimeItem(itemId) 
      or itemId == prop.itemId then 
    return true 
  end
  
  return false
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

  local isTemporaryMode = self:isTemporaryMode()
  if isTemporaryMode then
      --推送召回活动 
      if RecallManager.getInstance():getRecallLevelState(self.propListAnimation.levelId) then
          -- print("self.prop.itemId===================================",self.prop.itemId)
          -- 临时魔力扫把特殊处理
          if self.prop.itemId == 10057 then
              self.isOnceUsed = true
              DcUtil:UserTrack({category = "recall", sub_category = "use_molisaoba"})
          elseif self.prop.itemId == 10010 then --10026
              DcUtil:UserTrack({category = "recall", sub_category = "use_xiaomuchui"}) 
          elseif self.prop.itemId == 10005 then --10027
              DcUtil:UserTrack({category = "recall", sub_category = "use_mofabang"}) 
          end 
      end
    self:updateTemporaryItemNumber(itemId, -1)  	
  else
    if self:getTimePropNum() > 0 then
      self:useTimeProp()
    else
      prop.itemNum = prop.itemNum - 1
      if prop.itemNum < 0 then prop.itemNum = 0 end
    end
    self.usedTimes = self.usedTimes + 1
  end
	self:updateItemNumber()

	self:bubble(0.3)
	self:explode(0.4, usedPositionGlobal)
end

function PropListItem:playMaxUsedAnimation(tipDesc)
  self:shake()

  local array = CCArray:create()
  array:addObject(CCScaleTo:create(0.3, 1.1))
  array:addObject(CCDelayTime:create(0.2))
  array:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.5, 1.3), CCFadeOut:create(0.5)))
  array:addObject(CCHide:create())
  local prop_disable_icon = self.item:getChildByName("prop_disable_icon")
  prop_disable_icon:setCascadeOpacityEnabled(false)
  self.item:setChildIndex(prop_disable_icon, self.item:getNumOfChildren())
  prop_disable_icon:setScale(1)
  prop_disable_icon:setVisible(true)
  prop_disable_icon:setOpacity(255)
  prop_disable_icon:stopAllActions()
  prop_disable_icon:runAction(CCSequence:create(array))

  local position = prop_disable_icon:getPosition()
  local label = TextField:create(tipDesc, nil, 22)
  local function onAnimationFinished() label:removeFromParentAndCleanup(true) end
  local fade = CCArray:create()
  fade:addObject(CCMoveBy:create(0.3, ccp(0, 20)))
  fade:addObject(CCDelayTime:create(0.2))
  fade:addObject(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCMoveBy:create(0.5, ccp(0, 15))))
  fade:addObject(CCCallFunc:create(onAnimationFinished))
  
  label:setPosition(ccp(position.x, 90))
  label:runAction(CCSequence:create(fade))
  self.item:addChild(label)
end
function PropListItem:use()
	local prop = self.prop
  local meta = self:getPropMeta()
  if not prop or not meta then return false end
  
	--avoid use prop multy times
	if self.isAnimating then return false end

	if not prop or self:getTotalItemNumber() < 1 then 
		    self:shake()
		    if self.propListAnimation.buyPropCallback then
			    self.propListAnimation:callBuyPropCallback(prop.itemId)
		    end

		return false
	end
  local isTempProperty  = self:isTemporaryMode()
  local maxUsetime = self.maxUsetime or 0
  if maxUsetime > 0 and self.usedTimes >= maxUsetime and not isTempProperty then
    local tip = Localization:getInstance():getText("prop.disabled.tip2", {num=self.maxUsetime})
    self:playMaxUsedAnimation(tip)
    return false
  elseif self.reasonType then
    if self.reasonType == 1 then
      local tip = Localization:getInstance():getText("prop.disabled.tip3", {num=self.maxUsetime})
      self:playMaxUsedAnimation(tip)
    elseif self.reasonType == 2 then
      local tip = Localization:getInstance():getText("prop.disabled.tip4", {num=self.maxUsetime})
      self:playMaxUsedAnimation(tip)
    elseif self.reasonType == 3 then
      local tip = Localization:getInstance():getText("prop.disabled.tip6")
      self:playMaxUsedAnimation(tip)
    end 
    return false
  end

  local usePropType = nil
  if isTempProperty then 
    usePropType = UsePropsType.TEMP
  elseif self:getTimePropNum() > 0 then
    usePropType = UsePropsType.EXPIRE
  else
    usePropType = UsePropsType.NORMAL
  end

	-- Use Prop Callback
	if self.propListAnimation.usePropCallback then

		local itemId 		= self:findItemID()		
		local isRequireConfirm	= self:isItemRequireConfirm()

    print("use prop:", itemId, usePropType, isRequireConfirm)
		return self.propListAnimation:callUsePropCallback(self, itemId, usePropType, isRequireConfirm)
	end
  return true
end

function PropListItem:shake()
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

function PropListItem:windover(delayTime)
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

function PropListItem:focus( enabled, confirm )
	local prop = self.prop
	if not prop then return end

  if self.disabled then return end

	if self.isPlayShowAnimation then
		print("ERROR!!! focus item can not executed before display animation finished")
		return
	end

	self.focused = enabled
	local item = self.item
	local bg_selected = item:getChildByName("bg_selected")
  local nameLabel = item:getChildByName("name_label")
  nameLabel:setOpacity(255)

	if enabled then
		bg_selected:setVisible(true)
		bg_selected:setOpacity(0)
		bg_selected:runAction(CCFadeIn:create(0.2))

		self.isAnimateHint = false

		local animationTime = 1.2
		local sequence = CCSequence:createWithTwoActions(CCScaleTo:create(animationTime, 1.065, 0.95),CCScaleTo:create(animationTime, 0.96, 1))
		item:stopAllActions()
		item:setScale(1)
    item:setRotation(self.startAngle)
  	item:setPosition(ccp(self.beginPosition.x, self.beginPosition.y))
		item:runAction(CCRepeatForever:create(sequence))

    nameLabel:setString(self.itemName or "")
    nameLabel:setVisible(true)
	else
		item:setScale(1)
    item:setRotation(self.startAngle)
		item:setOpacity(255)
		item:setColor(ccc3(255,255,255))
		item:stopAllActions()
		
		bg_selected:stopAllActions()
		bg_selected:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.2), CCHide:create()))

    if not confirm then
      local tip = Localization:getInstance():getText("prop.use.cancel.tips")
      nameLabel:setString(tip)
    end
    nameLabel:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.5), CCHide:create()))

		self.isAnimateHint = false
		if self.isHintMode then self:hint(0) end
		self.propListAnimation:callCancelPropUseCallback(prop.itemId)
	end
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

	self.darked = enabled
	local item = self.item
	if enabled then
  		local darkAnimationTime = 0.5
  		
  		self.isAnimateHint = false
  		local array = CCArray:create()
  		array:addObject(CCFadeTo:create(darkAnimationTime, 150))
  		array:addObject(CCEaseElasticOut:create(CCScaleTo:create(darkAnimationTime, 0.85)))
  		item:stopAllActions()
  		item:setScale(1)
      item:setRotation(self.startAngle)
  		item:setPosition(ccp(self.beginPosition.x, self.beginPosition.y))
  		item:runAction(CCSpawn:create(array))
	else
  		local darkAnimationTime = 0.25
		  local array = CCArray:create()
  		array:addObject(CCFadeTo:create(darkAnimationTime, 255))
  		array:addObject(CCEaseElasticOut:create(CCScaleTo:create(darkAnimationTime, 1)))

  		item:setScale(1)
      item:setRotation(self.startAngle)
		  --item:setOpacity(255)
  		--item:setColor(ccc3(255,255,255))
  		item:stopAllActions()
  		item:runAction(CCSpawn:create(array))

  		self.isAnimateHint = false
  		if self.isHintMode then self:hint(0) end
	end
end

function PropListItem:stopHint()
	self.isAnimateHint = false
	self.isHintMode = false
  self.item:stopAllActions()
end

function PropListItem:hint(delayTime)
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

function PropListItem:tmpAnimation(delayTime)
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
        local a = {0.5, 0.75}
        local cycle = math.random(#a)
        cycle = a[cycle]
        local b = {2, 4, 6}
        local swing = math.random(#b)
        swing = b[swing]
        local rotation = item:getRotation()
        sequence:addObject(CCEaseSineOut:create(CCRotateTo:create(cycle, rotation + swing)))
        local function repeatForever()
          local cycle = math.random(#a)
          cycle = a[cycle]
          local swing = math.random(#b)
          swing = b[swing]
          local repeatFoever = CCArray:create()
          repeatFoever:addObject(CCEaseSineInOut:create(CCRotateTo:create(cycle, rotation - swing)))
          repeatFoever:addObject(CCEaseSineInOut:create(CCRotateTo:create(cycle, rotation + swing)))
          if swing == b[1] then repeatFoever:addObject(CCDelayTime:create(1.5)) end
          repeatFoever:addObject(CCCallFunc:create(repeatForever))
          local rep = CCSequence:create(repeatFoever)
          item:runAction(rep)
        end
        sequence:addObject(CCCallFunc:create(repeatForever))
        item:setPosition(ccp(context.beginPosition.x, context.beginPosition.y))
        item:runAction(CCSequence:create(sequence))
      end
    end
  end
  self.hint = self.tmpAnimation
  item:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onHintCallback)))
end

function PropListItem:pushPropAnimation(delayTime)
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
        arr:addObject(CCScaleTo:create(0.3, 0.96, 1.1))
        arr:addObject(CCScaleTo:create(0.3, 0.98, 0.85))
        arr:addObject(CCScaleTo:create(0.3, 0.99, 1.1))
        arr:addObject(CCScaleTo:create(0.3, 1, 0.85))
        arr:addObject(CCScaleTo:create(0.3, 0.99, 1.1))
        arr:addObject(CCScaleTo:create(0.3, 0.98, 0.85))
        local action = CCRepeatForever:create(CCSequence:create(arr))
        item:setPosition(ccp(context.beginPosition.x, context.beginPosition.y))
        item:runAction(action)
      end
    end
  end
  self.hint = self.pushPropAnimation
  item:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onHintCallback)))
end

function PropListItem:playIncreaseAnimation()
  if self.isPlayShowAnimation then return self:updateItemNumber() end

  local function onAnimationFinished()
    self:updateItemNumber()
    self.isAnimateHint = false
    if self.isHintMode then self:tmpAnimation(0) end
  end
  local item = self.item
  local array = CCArray:create()
  -- array:addObject(CCSpawn:createWithTwoActions(CCEaseSineIn:create(CCScaleTo:create(0.15, 0.6, 0.3)), CCMoveTo:create(0.15, ccp(self.beginPosition.x, self.beginPosition.y))))
  -- array:addObject(CCEaseBackOut:create(CCScaleTo:create(0.35, 1)))
  array:addObject(CCScaleTo:create(0.25, 0))
  array:addObject(CCScaleTo:create(0.25, 1))
  array:addObject(CCCallFunc:create(onAnimationFinished))
  item:stopAllActions()
  item:setRotation(self.startAngle)
  item:runAction(CCSequence:create(array))
end
function PropListItem:increaseItemNumber( itemId, itemNum )
  itemNum = itemNum or 0
  if self.temporaryItemList then self:increateTemporaryItemNumber(itemId, itemNum)
  else
    self.prop.itemNum = self.prop.itemNum + itemNum
    self:playIncreaseAnimation()
  end
end

function PropListItem:updateTemporaryItemNumber( itemId, itemNum )
  itemNum = itemNum or 0
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList == nil then temporaryItemList = {} end
  self.temporaryItemList = temporaryItemList
  self.prop.temporary = 1

  local itemFound, oldNum = nil, 0
  for i,v in ipairs(temporaryItemList) do
    if v.itemId == itemId then itemFound = v end
  end
  if itemFound then oldNum = itemFound.itemNum or 0 
  else 
    itemFound = {itemId = itemId}
    table.insert(temporaryItemList, itemFound) 
  end
  itemFound.itemNum = oldNum + itemNum
  if itemFound.itemNum <= 0 then 
    table.removeValue(temporaryItemList, itemFound)
  end
  print(oldNum, itemNum, itemFound.itemNum, "itemFound.itemNum", itemId)
  if #temporaryItemList < 1 then 
    self.temporaryItemList = nil
    self.prop.temporary = 0
    self:setTemporaryMode(false)
  else self:setTemporaryMode(true) end
end
function PropListItem:increateTemporaryItemNumber( itemId, itemNum )
  self:updateTemporaryItemNumber(itemId, itemNum)
  self:playIncreaseAnimation()
  self:hintTemporaryMode()
end

function PropListItem:explode( animationTime, usedPositionGlobal )
  local item = self.item
  local bg_normal = item:getChildByName("bg_normal")
  local bg_label = item:getChildByName("bg_label")
  local icon_add = item:getChildByName("icon_add")

  local function onAnimationFinished()
    if self.isAnimateHint then 
      self:stopHint() 
    end
    if self:isAddMoveProp() then 
      self:hide() 
      self.isExplodeing = false
    else 
      self:show(0) 
    end
    if self:isTemporaryMode() and self.onTemporaryItemUsed ~= nil then 
      self:onTemporaryItemUsed(self) 
    end 
  end

  if self.item_number:isVisible() then self.item_number:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.15), CCFadeOut:create(0.4))) end
  if bg_label:isVisible() then bg_label:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.15), CCFadeOut:create(0.4))) end
  if icon_add:isVisible() then icon_add:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.15), CCFadeOut:create(0.4))) end
  bg_normal:stopAllActions()
  bg_normal:setScale(1)
  bg_normal:setRotation(0)
  bg_normal:setOpacity(255)

  local background = bg_normal
  local startAngle = (1 + math.random()*2) * self.direction
  local array = CCArray:create()
  array:addObject(CCSpawn:createWithTwoActions(CCRotateBy:create(animationTime, startAngle), CCScaleTo:create(animationTime, 0.7, 0.85)))
  array:addObject(CCFadeOut:create(0))
  array:addObject(CCDelayTime:create(0.2))
  array:addObject(CCCallFunc:create(onAnimationFinished))
  background:setScale(1.2)
  background:runAction(CCSequence:create(array))
  
  if self.prop and self.prop.itemId then
  	local iconAnimation = PropListAnimation:createIcon(self.prop.itemId)
  	if iconAnimation then
  		
      local winSize = CCDirector:sharedDirector():getVisibleSize()
      local origin = Director:sharedDirector():getVisibleOrigin()
      local useFallingStar = false
      local itemId = self:getDefaultItemID()
      if itemId == 10004 then
        self.isExplodeing = true
        usedPositionGlobal = ccp(winSize.width - 100, winSize.height - 100)
        useFallingStar = true
      end

      if usedPositionGlobal then
        local scene = Director:sharedDirector():getRunningScene()
        local container = CocosObject:create()  
        container:setPosition(ccp(origin.x, origin.y))
        if scene then scene:addChild(container) end

        local flyTime = 0.5
        local positionTo = container:convertToNodeSpace(usedPositionGlobal)
        if useFallingStar then flyTime = 0.7 end

        local position = item:convertToWorldSpace(ccp(self.iconSize.x + self.iconSize.width/2, self.iconSize.y - self.iconSize.height/2))
        position = container:convertToNodeSpace(position)
        local function onIconAnimated() if container then container:removeFromParentAndCleanup(true) end end
        local iconSpawn = CCMoveTo:create(flyTime, positionTo)
        iconAnimation:runAction(CCSequence:createWithTwoActions(iconSpawn, CCCallFunc:create(onIconAnimated)))
        iconAnimation:setPosition(position)
        container:addChild(iconAnimation)

        if useFallingStar then
          local star = FallingStar:create(ccp(position.x, position.y), ccp(usedPositionGlobal.x, usedPositionGlobal.y))
          container:addChild(star)
        end
      else
        local function onIconAnimated() if iconAnimation then iconAnimation:removeFromParentAndCleanup(true) end end
        local iconSpawn = CCSpawn:createWithTwoActions(CCFadeTo:create(0.6, 100), CCEaseBackIn:create(CCMoveBy:create(0.6, ccp(0, 150))))
        iconAnimation:setPosition(ccp(self.iconSize.x + self.iconSize.width/2, self.iconSize.y - self.iconSize.height/2))
        iconAnimation:runAction(CCSequence:createWithTwoActions(iconSpawn, CCCallFunc:create(onIconAnimated)))
        item:addChildAt(iconAnimation, 4)
      end
  	end
  end

  local icon = self.icon
  if icon then icon:setVisible(false) end
end

function PropListItem:bubble(delayTime)
  local maxParticles = 30
  local center = self.center
  self.batch:removeChildren(true)
  for i = 1, maxParticles do
    local sprite = nil
    if math.random() > 0.5 then sprite = Sprite:createWithSpriteFrameName("prop_bubble10000")
    else sprite = Sprite:createWithSpriteFrameName("prop_bubble20000") end
    self.batch:addChild(sprite)
    local r = 70 + math.random() * 20
    local angle = math.random() * 360
    local x = center.x + r * math.cos(angle)
    local y = center.y + r * math.sin(angle)
    local animationTime = 0.3 + math.random()*0.25
    
    local spawn = CCArray:create()
    spawn:addObject(CCFadeOut:create(animationTime))
    spawn:addObject(CCEaseSineOut:create(CCMoveTo:create(animationTime, ccp(x, y))))
    spawn:addObject(CCScaleTo:create(animationTime, math.random() + 1))
    
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(math.random()*0.1 + delayTime))
    array:addObject(CCShow:create())
    array:addObject(CCSpawn:create(spawn))
    array:addObject(CCHide:create())

    sprite:setVisible(false)
    sprite:setScale(0.3)
    sprite:setPosition(ccp(center.x + (math.random()*10 - 5), center.y + (math.random()*10 - 5)))
    sprite:runAction(CCSequence:create(array))
  end
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

function PropListItem:setEnable()
  self.reasonType = nil
  local maxUsetime = self.maxUsetime or 0
  local isTemporaryMode = self:isTemporaryMode()
  if maxUsetime > 0 and self.usedTimes >= maxUsetime and not isTemporaryMode then
    self:lock(true)
  else
    self:lock(false)
  end
end

function PropListItem:enableUnlimited(enable)
    self.isUnlimited = enable
end