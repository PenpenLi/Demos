-------------------------------------------------------------------------
--  Class include: PropListAnimation, PropListItem, PropHelpButton
-------------------------------------------------------------------------

require "hecore.display.Director"
require "zoo.animation.PropListItem"
require "zoo.panel.PropInfoPanel"
 
local kAddStepItems = {10004}
local kCurrentMaxItemInListView = 18
local kItemGapInListView = 12
local kMaxItemIdAvailable = 10057
local kPreUsedPropItems = {10018, 10015, 10019}
local kTempPropMapping = {}
kTempPropMapping["10025"] = 10001
kTempPropMapping["10015"] = 10001
kTempPropMapping["10016"] = 10002
kTempPropMapping["10028"] = 10003
kTempPropMapping["10017"] = 10003
kTempPropMapping["10027"] = 10005
kTempPropMapping["10019"] = 10005
kTempPropMapping["10026"] = 10010
kTempPropMapping["10024"] = 10010
kTempPropMapping["10018"] = 10004
kTempPropMapping["10053"] = 10052
kTempPropMapping["10057"] = 10056

local function isAddStepItem( item )
  local itemId = item.itemId
  for j, k in ipairs(kAddStepItems) do
    if k == itemId then return true end
  end
  return false
end
local function isValidItem( item )
  local itemId = item.itemId
  if itemId > kMaxItemIdAvailable then return false end

  for i,v in ipairs(kPreUsedPropItems) do
    if v == itemId then return false end
  end
  return true
end

PropHelpButton = class()
function PropHelpButton:ctor( sprite, levelId )
  self.sprite = sprite
  self.levelId = levelId
  if not self.levelId then self.levelId = 12 end
end

function PropHelpButton:onTouchBegin(evt)
  if self:hitTest(evt.globalPosition) then
    self.sprite:setOpacity(150)
  end
end
function PropHelpButton:onTouchEnd(evt)
  self.sprite:setOpacity(255)
end

function PropHelpButton:use(position)
  if self:hitTest(position) then
    local panel = PropInfoPanel:create(2, self.levelId)
    if panel then panel:popout() end
    if __WP8 and not self.angleReloaded then
      self.angleReloaded = true
      Wp8Utils:reloadAngle()
    end
  end
end
function PropHelpButton:hitTest( position )
  local sprite = self.sprite
  local center = sprite:getPosition()
  local r = 25
  position = sprite:getParent():convertToNodeSpace(position)
  local dx = position.x - center.x - 23
  local dy = position.y - center.y + 23
  return (dx * dx + dy * dy) < r * r
end

--
-- PropListAnimation ---------------------------------------------------------
--
PropListAnimation = class()

local kPropListItemWidth = 130

function PropListAnimation:ctor()
  local context = self
  local function onTouchBegin(evt) context:onTouchBegin(evt) end
  local function onTouchMove(evt) context:onTouchMove(evt) end
  local function onTouchEnd(evt) context:onTouchEnd(evt) end

  local origin = Director:sharedDirector():getVisibleOrigin()
  local visibleSize = CCDirector:sharedDirector():getVisibleSize()

	local layer = Layer:create()
	layer.name = "level target"
	layer:setTouchEnabled(true)
  layer:setPosition(ccp(origin.x, origin.y))
  layer:ad(DisplayEvents.kTouchBegin, onTouchBegin)
  layer:ad(DisplayEvents.kTouchMove, onTouchMove)
  layer:ad(DisplayEvents.kTouchEnd, onTouchEnd)

  local kPropListScaleFactor = 1
  if __frame_ratio and __frame_ratio < 1.6 then  kPropListScaleFactor = 0.9 end
  --[[
  if kWindowFrameRatio.iPad.name == __frame_key then
    kPropListScaleFactor = 0.9
  end
  if kWindowFrameRatio.iPhone4.name == __frame_key then
    kPropListScaleFactor = 0.9
  end
  ]]
  self.propListItemWidth = kPropListScaleFactor * kPropListItemWidth
  self.propListMaxItemPerPage = math.floor(visibleSize.width / self.propListItemWidth)
  self.kPropListScaleFactor = kPropListScaleFactor
  layer:setScale(kPropListScaleFactor)

  local originY = origin.y
  local minY = 170 * kPropListScaleFactor
  layer.hitTestPoint = function ( self, worldPosition, useGroupTest )
    local localY = worldPosition.y - originY
    --print(string.format("PropListAnimation: %f %f %f %f", localY, worldPosition.y, originY, minY))
    return localY < minY
  end
  --print(string.format("PropListAnimation: %d %d %f", self.propListItemWidth, self.propListMaxItemPerPage, visibleSize.width))
	self.layer = layer

  local content = Layer:create()
  layer.name = "content"
  layer:addChild(content)
  self.content = content


  self.usePropCallback		= false
  self.cancelPropUseCallback	= false
  self.buyPropCallback		= false
  self.isTouchEnabled = true

end

function PropListAnimation:create(levelId)
	local ret = PropListAnimation.new()
	ret:buildUI(levelId)
	return ret
end

function PropListAnimation:registerUsePropCallback(usePropCallback, ...)
	assert(type(usePropCallback) == "function")
	assert(#{...} == 0)

	print("PropListAnimation:registerUsePropCallback Called !")
	self.usePropCallback = usePropCallback
end

function PropListAnimation:registerCancelPropUseCallback(callbackFunc, ...)
	assert(type(callbackFunc) == "function")
	assert(#{...} == 0)

	self.cancelPropUseCallback = callbackFunc
end

function PropListAnimation:registerBuyPropCallback(callbackFunc, ...)
	assert(type(callbackFunc) == "function")
	assert(#{...} == 0)

	self.buyPropCallback = callbackFunc
end

function PropListAnimation:callBuyPropCallback(itemId, ...)
	assert(type(itemId) == "number")
	assert(#{...} == 0)

	self.buyPropCallback(itemId)
end

function PropListAnimation:callUsePropCallback(propItemUsed, itemId, isTempProperty, isRequireConfirm, ...)
	assert(propItemUsed)
	assert(type(itemId) == "number")
	assert(type(isTempProperty) == "boolean")
	assert(type(isRequireConfirm) == "boolean")
	assert(#{...} == 0)

	self.propItemUsed = propItemUsed

	if self.usePropCallback then
		return self.usePropCallback(itemId, isTempProperty, isRequireConfirm)
	end
	return true
end

function PropListAnimation:callCancelPropUseCallback(itemId, ...)
	assert(#{...} == 0)

	if self.cancelPropUseCallback then
		self.cancelPropUseCallback(itemId)
	end
end

--function PropListAnimation:confirmPropItemUsed(...)
--	assert(#{...} == 0)
--	assert(self.propItemUsed)
--	self.propItemUsed:confirm()
--end

function PropListAnimation:createIcon( itemId )
  local sprite = Sprite:createWithSpriteFrameName("Prop_"..itemId.." instance 10000")
  sprite.name = "icon"
  return sprite
end

function PropListAnimation:dispose()
  for i = 1, kCurrentMaxItemInListView do
      self["item"..i]:dispose()
    end
  if self.layer then self.layer:rma() end
  self.layer = nil
end

function PropListAnimation:buildUI(levelId)
    self.levelId = levelId
	  local winSize = CCDirector:sharedDirector():getWinSize()
  	local propsListView = ResourceManager:sharedInstance():buildGroup("props_animations")
  	local targetSize = propsListView:getGroupBounds().size
  	propsListView:setContentSize(CCSizeMake(targetSize.width, targetSize.height))
  	propsListView:setPosition(ccp(0, targetSize.height))
  	self.propsListView = propsListView
  	self.content:addChild(propsListView)

  	local background = propsListView:getChildByName("bg")
    local backgroundSize = background:getGroupBounds().size
    self.minX = winSize.width - backgroundSize.width + 40
    self.maxX = 0
    self.visibleMinX = self.minX

  	local leaf_l_1 = propsListView:getChildByName("leaf_l_1")
    local leaf_l_2 = propsListView:getChildByName("leaf_l_2")
    local help_button = propsListView:getChildByName("help_button")

    leaf_l_1:removeFromParentAndCleanup(false)
    leaf_l_2:removeFromParentAndCleanup(false)
    help_button:removeFromParentAndCleanup(false)

    leaf_l_1:setPosition(ccp(-13, 118))
    leaf_l_2:setPosition(ccp(-13, 178))
    help_button:setPosition(ccp(3,52))

    self.layer:addChild(leaf_l_1)
    self.layer:addChild(leaf_l_2)
    self.layer:addChild(help_button)
    self.helpButton = PropHelpButton.new(help_button, levelId)
  	
    local function onHideCallback(item)
      local maxIndex = self:findMaxSlotIndex()
      local removedIndex = item.index
      if maxIndex < removedIndex and removedIndex > self.propListMaxItemPerPage then
        local position = self.content:getPosition()
        local visibleX = self:getItemOffset(maxIndex)
        self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(visibleX, position.y))))
      end
    end
    
  	for i = 1, kCurrentMaxItemInListView do
      local item = PropListItem:create(i, propsListView:getChildByName("p"..i), propsListView:getChildByName("i"..i), self)
      item.onHideCallback = onHideCallback
  		self["item"..i] = item
  	end
    self.item2.direction = -1
    self.item3.direction = -1
    self.item5.direction = -1
    self:getPropPositions()
end

function PropListAnimation:flushTemporaryProps(positionSrc)
  if self.temporaryPops and #self.temporaryPops > 0 then 
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local fromGlobalPosition = ccp(positionSrc.x - 5, positionSrc.y + 4)--ccp(winSize.width/2, winSize.height/2)
    for i,v in ipairs(self.temporaryPops) do 
      local function onAnimationFinished()
        self:addTemporaryItem(v.itemId, v.itemNum, fromGlobalPosition, false)
      end
      local icon = PropListAnimation:createIcon( v.itemId )
      local sprite = PrefixPropAnimation:createPropAnimation(icon, self.layer:convertToNodeSpace(fromGlobalPosition), onAnimationFinished)
      self.layer:addChild(sprite)
    end
    self.temporaryPops = nil
  end
end

function PropListAnimation:show( propItems, delayTime )
  self.propItems = {}
  self.addStepItems = {}
  self.content:setPosition(ccp(0,0))
  self.temporaryPops = {}

  delayTime = delayTime or 0 --1.35

  --there is no temporary prop at the beginning of a round
  if propItems and #propItems > 0 then
    for i, v in ipairs(propItems) do
      if v.temporary == 1 then
        table.insert(self.temporaryPops, v)
      else
        if isValidItem(v) then
          if isAddStepItem(v) then table.insert(self.addStepItems, v)
          else table.insert(self.propItems, v) end
        else print("item not supported or already uses as pre-prop, id:"..v.itemId) end
      end
    end
  end

	local winSize = CCDirector:sharedDirector():getWinSize()
	local propsListView = self.propsListView
	local background = propsListView:getChildByName("bg")
  
  	local backgroundPos = background:getPosition()
  	local bgX, bgY = backgroundPos.x, backgroundPos.y
  	background:setVisible(true)
    --local function onTestTemporary() self:flushTemporaryProps() end
    --background:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5),CCCallFunc:create(onTestTemporary)))
    local function onUpdateContent()
      if math.random() > 0.6 then self:windover() end
      --self:windover()
    end
    background:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(10), CCCallFunc:create(onUpdateContent))))
    local currItems = #self.propItems

  	for i = 1, kCurrentMaxItemInListView do 
      if i <= currItems then
        local isInitDisabled = self.propItems[i].itemId == GamePropsType.kBack
        self["item"..i]:enableUnlimited(self.isUnlimited)
        self["item"..i].prop = self.propItems[i] --setup the item's data
        self["item"..i]:show(0, true, isInitDisabled) 
      else self["item"..i]:hide() end
    end
end

function PropListAnimation:windover(direction)
  local pt = 0
  local begin, ended, step = 1, kCurrentMaxItemInListView, 1
  if direction == -1 then begin, ended, step = kCurrentMaxItemInListView, 1, -1 end
  for i = begin, ended, step do
    local item = self["item"..i]
    if item and item.visible then       
      local delayTime = pt * 0.3
      item:windover(delayTime)
      pt = pt + 1
    end
  end 
end

function PropListAnimation:findMaxSlotIndex()
  for i = kCurrentMaxItemInListView, 1, -1 do
    local item = self["item"..i]
    if item and item.visible then return i end
  end
  return 1
end
function PropListAnimation:findEmptySlot()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and not item.visible then return i end
  end
  return -1
end
function PropListAnimation:findItemIndex( item )
  for i,v in ipairs(self.propItems) do
    if v == item then return i end
  end
  return -1
end
function PropListAnimation:removeItemWithAnimation( removedItem )
  local removedIndex = self:findItemIndex(removedItem.prop)
  if removedIndex > 0 then table.remove(self.propItems, removedIndex) end
end

function PropListAnimation:onGameMoveChange(number, animated)
  if self.levelModeType == "Classic"
  or self.levelModeType == "RabbitWeekly"
   then
    --time mode
  else
    if number <= 5 and not animated then 
      self:showAddStepItem()
    else
      self:hideAddMoveItem()
    end
  end
end

function PropListAnimation:showAddStepItem()
  if not self.addStepItems or #self.addStepItems < 1 or self:findAddMoveItem() then return end
  self:addItemWithAnimation(self.addStepItems[1], 0.3, true)
  --self:addItemWithAnimation(table.remove(self.addStepItems), 0.3, true)
end
function PropListAnimation:hideAddMoveItem()
  local item = self:findAddMoveItem()
  if item and not item.isExplodeing then item:hide() end
end

function PropListAnimation:findAddMoveItem()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:isAddMoveProp() then return item end
  end
  return item
end

function PropListAnimation:getItemOffset( index )
  local winSize = CCDirector:sharedDirector():getVisibleSize()
  local contentWidth = (self["item"..1].item:getContentSize().width - kItemGapInListView) -- * self.kPropListScaleFactor 
  -- 每6个道具会出现一个树枝，因此加上一个40的offset作调整
  local contentMinX = winSize.width - contentWidth * index - math.ceil((index - 6) / 6) * 40 / self.kPropListScaleFactor 
  if contentMinX > 0 then contentMinX = 0 end
  return math.max(self.minX, contentMinX)
end

function PropListAnimation:addItemWithAnimation( item, delayTime, useHint )
  if item then
    table.insert(self.propItems, item)
    local itemIndex = self:findEmptySlot()
    if itemIndex >= kCurrentMaxItemInListView then return end
    self["item"..itemIndex]:enableUnlimited(self.isUnlimited)
    self["item"..itemIndex].prop = item
    self["item"..itemIndex]:show(delayTime, true) 
   if useHint then self["item"..itemIndex]:pushPropAnimation(2) end
    
    self:updateVisibleMinX()
    self.content:stopAllActions()
    self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.6, ccp(self:getItemOffset(itemIndex), 0)))) 
    return itemIndex
  end
  return -1
end

function PropListAnimation:addFallingtar( item, index, fromGlobalPosition, flyFinishedCallback, propID )
  if not item or not fromGlobalPosition then return end

  --local itemTo = item.item
  local to = item:getItemCenterPosition() --itemTo:getPosition()
  local from = self.layer:convertToNodeSpace(fromGlobalPosition) 
  local offsetX = 0
  if index > self.propListMaxItemPerPage then offsetX = self:getItemOffset(index) end  
  local fallingStar = FallingStar:create(from, ccp(to.x + offsetX, to.y+278), nil, flyFinishedCallback)
  self.layer:addChild(fallingStar)

  local propIcon = nil
  if propID then propIcon = PropListAnimation:createIcon( propID ) end
  if propIcon then
    self.layer:addChild(propIcon)
    local time = fallingStar.time or 0.5
    local array = CCArray:create()
    local function onAnimationFinished() propIcon:removeFromParentAndCleanup(true) end
    array:addObject(CCEaseSineInOut:create(CCMoveTo:create(time, ccp(to.x + offsetX, to.y+278))))
    array:addObject(CCCallFunc:create(onAnimationFinished))
    propIcon:setPosition(ccp(from.x, from.y))
    propIcon:runAction(CCSequence:create(array))
  end
end
function PropListAnimation:addTemporaryItem( itemId, itemNum, fromGlobalPosition, showIcon )
  itemNum = itemNum or 0
  local itemFound, itemIndex = self:findItemByItemID(itemId)
  local animateFallingIcon = true
  local animatedItemID = nil
  if showIcon ~= nil then animateFallingIcon = showIcon end
  if animateFallingIcon then animatedItemID = itemId end
 
  if itemFound then
    local function onTempFlyFinishedCallback()
      itemFound:increaseItemNumber(itemId, itemNum)
    end    
    self:addFallingtar(itemFound, itemIndex, fromGlobalPosition, onTempFlyFinishedCallback, animatedItemID)
    return
  else
    local mappingItemId = kTempPropMapping[tostring(itemId)]
    if mappingItemId then itemFound, itemIndex = self:findItemByItemID(mappingItemId) end
    
    if itemFound then
      local function onNormalFlyFinishedCallback()
        itemFound:increateTemporaryItemNumber(itemId, itemNum)
      end    
      self:addFallingtar(itemFound, itemIndex, fromGlobalPosition, onNormalFlyFinishedCallback, animatedItemID)
      return
    end
  end
  local index = self:addItemWithAnimation({itemId=itemId, itemNum=itemNum, temporary=1}, 0)
  if index < 1 then return end

  local onTemporaryItemUsed = function( removedItem )
    local maxIndex = self:findMaxSlotIndex()
    local removedIndex = removedItem.index
    self:removeItemWithAnimation(removedItem)
    if maxIndex < removedIndex and removedIndex > self.propListMaxItemPerPage then
      local position = self.content:getPosition()
      local visibleX = self:getItemOffset(maxIndex)
      self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(visibleX, position.y))))
    end
  end
  self:addFallingtar(self["item"..index], index, fromGlobalPosition, nil, animatedItemID)
  self["item"..index].onTemporaryItemUsed = onTemporaryItemUsed
end

function PropListAnimation:updateVisibleMinX()
  self.visibleMinX = self:getItemOffset(self:findMaxSlotIndex())
end
function PropListAnimation:onTouchBegin( evt )
  self.isMoved = false
  self.prev_position = evt.globalPosition
  self.begin_index = self:findHitItemIndex(evt)
  self:updateVisibleMinX()

  if self.isTouchEnabled then self.helpButton:onTouchBegin(evt) end
end

function PropListAnimation:updateContentPosition( evt )
  if self.propItems and self:findMaxSlotIndex() > self.propListMaxItemPerPage then
    if evt.globalPosition and self.prev_position then
      local dx = evt.globalPosition.x - self.prev_position.x
      local position = self.content:getPosition()
      local fx = position.x + dx
      if fx > self.maxX then fx = self.maxX end
      if fx < self.visibleMinX then fx = self.visibleMinX end
      self.content:setPositionX(fx)
    end
    self.prev_position = evt.globalPosition
  end  
end
function PropListAnimation:findHitItemIndex( evt )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:hitTest(evt.globalPosition) then return i end
  end
  return 0
end
function PropListAnimation:setItemDark( hitItemID, darked )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and i ~= hitItemID then item:dark(darked) end
  end
end

function PropListAnimation:findItemByItemID( itemId )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:verifyItemId(itemId) then return item, i end
  end
  return nil, -1
end

function PropListAnimation:setItemNumber( itemId, itemNum )
  local item = self:findItemByItemID(itemId)
  if item and item.prop then 
    item.prop.itemNum = itemNum or 0
    item:updateItemNumber()
  end
end

function PropListAnimation:addItemNumber( itemId, itemNum )
  local item = self:findItemByItemID(itemId)
  if item and item.prop then 
    item.prop.itemNum = item.prop.itemNum + (itemNum or 0)
    item:updateItemNumber()
  end
end


function PropListAnimation:confirm(itemId, usedPositionGlobal)
  if self.focusItem then
    self.focusItem:focus(false, true)
    self.focusItem:confirm(itemId, usedPositionGlobal)
    self:setItemDark(-1, false)
    self.focusItem = nil
  else
    local hitItem, hitIndex = self:findItemByItemID(itemId)
    if hitItem then 
      hitItem:confirm(itemId, usedPositionGlobal)
    end
  end
end

function PropListAnimation:setItemTouchEnabled(enable)
  self.isTouchEnabled = enable
end

function PropListAnimation:setRevertPropDisable(itemId, reasonType)
  if itemId ~= nil then 
    local item = self:findItemByItemID(itemId)
    if item then item:setDisableReason(reasonType) end
  end
end

function PropListAnimation:setRevertPropEnable(itemId)
  if itemId ~= nil then 
    local item = self:findItemByItemID(itemId)
    if item then item:setEnable() end
  end
end

function PropListAnimation:setOctopusForbidEnable(enable, reason)
    local item = self:findItemByItemID(GamePropsType.kOctopusForbid)
    if item then 
      if enable then
        item:setEnable()
      else
        item:setDisableReason(reason)
      end
    end
end

function PropListAnimation:onTouchMove( evt )
  if self.focusItem then
  else   
    if evt.globalPosition and self.prev_position then
      local dx = evt.globalPosition.x - self.prev_position.x
      local dy = evt.globalPosition.y - self.prev_position.y
      if dx < 0 then self.directionWind = -1 
      else self.directionWind = 1 end
      if dx * dx + dy * dy > 64 then self.isMoved = true end
    end
    self:updateContentPosition(evt)
  end  
end
function PropListAnimation:onTouchEnd( evt )
  self.helpButton:onTouchEnd(evt)

  if self.focusItem then
    self.focusItem:focus(false)
    self:setItemDark(-1, false)
    self.focusItem = nil
  else
    self:updateContentPosition(evt)
    if self.isMoved then return self:windover(self.directionWind) end

    if not self.isTouchEnabled then return end

    if self.helpButton:use(evt.globalPosition) then return end

    local hitItemID = self:findHitItemIndex(evt)
    if hitItemID > 0 and hitItemID == self.begin_index then 
      local hitItem = self["item"..hitItemID]
      if hitItem:isItemRequireConfirm() then
          if hitItem:use() then 
            self.focusItem = hitItem
            hitItem:focus(true) 
            self:setItemDark(hitItemID, true)
         end
      else hitItem:use() end
    end
  end

  self.begin_index = 0
end

function PropListAnimation:getPropPositions()
  self.propPositions = {}
  for i = 1, 5 do
    local item = self.propsListView:getChildByName("i"..i)
    local pos = item:getPosition()
    pos = item:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
    local size = item:getGroupBounds().size
    if i == 2 or i == 3 or i == 5 then
      pos.x = pos.x - size.width / 5
    else
      pos.x = pos.x + size.width / 5
    end
    pos.y = pos.y + size.height / 3
    table.insert(self.propPositions, pos)
  end
end

function PropListAnimation:getPositionByIndex(index)
  local pos = self.propPositions[index]
  if self.content then pos.x = pos.x + self.content:getPosition().x end
  return pos
end

function PropListAnimation:setLevelModeType(levelModeType)
    self.levelModeType = levelModeType
    if self.levelModeType == 'MaydayEndless' or self.levelModeType == 'halloween' then
        self.isUnlimited = true
    end
end