-------------------------------------------------------------------------
--  Class include: PropListAnimation, PropListItem, PropHelpButton
-------------------------------------------------------------------------

require "hecore.display.Director"
require "zoo.props.PropListItem"
require "zoo.panel.PropInfoPanel"
require 'zoo.props.SpringPropListItem'
require "zoo.props.PropListController"

local kCurrentMaxItemInListView = 18
local kItemGapInListView = 12

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
local kPropItemDirections = {2, 3, 5}

function PropListAnimation:ctor()
  local origin = Director:sharedDirector():getVisibleOrigin()
  local visibleSize = CCDirector:sharedDirector():getVisibleSize()

	local layer = Layer:create()
  layer.name = "level target"
  layer:setTouchEnabled(true)
  layer:setPosition(ccp(origin.x, origin.y))

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
  content.name = "content"
  layer:addChild(content)
  self.content = content

  self.usePropCallback		= false
  self.cancelPropUseCallback	= false
  self.buyPropCallback		= false
  self.isTouchEnabled = true

  self.controller = PropListController:create(self)
end

function PropListAnimation:create(levelId, levelModeType, levelType)
	local ret = PropListAnimation.new()
    ret:setLevelModeType(levelModeType, levelType)
	ret:buildUI(levelId)
	return ret
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
  	
    self:createItems()

    self:getPropPositions()
end

function PropListAnimation:getPropUnlimitable(itemId)
    local summerWeeklyLimitPropList = {GamePropsType.kRandomBird, GamePropsType.kBroom, GamePropsType.kBroom_l}
    if self.isUnlimited then
      if self.levelType == GameLevelType.kSummerWeekly and table.includes(summerWeeklyLimitPropList, itemId) then
        return false
      else
        return true
      end
    else
      return false
    end
end

function PropListAnimation:createItems()
    local currItems = #PropsModel.instance().propItems

    for i = 1, kCurrentMaxItemInListView do

      if i <= currItems then
        local propItem = PropsModel:instance().propItems[i]
        local item  = self:createPropListItem(i, propItem.itemId)

        item:setPropItemData(propItem, self:getPropUnlimitable(propItem.itemId)) --setup the item's data
      else
         self:createPropListItem(i, nil)
      end
    end
end

function PropListAnimation:flushTemporaryProps(positionSrc, animationCallback)
  if PropsModel:instance():temporaryPopsExist() then 
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local fromGlobalPosition = ccp(positionSrc.x - 5, positionSrc.y + 4)--ccp(winSize.width/2, winSize.height/2)
    local maxItemNum = 0
    local item_count = 0
    for i,v in ipairs(PropsModel:instance().temporaryPops) do 
      local function onAnimationFinished()
        self:addTemporaryItem(v.itemId, v.itemNum, fromGlobalPosition, false)
        item_count = item_count + 1
        if item_count >= maxItemNum and animationCallback then
          animationCallback() 
        end
      end
      maxItemNum = maxItemNum + 1
      local icon = PropListAnimation:createIcon( v.itemId )
      local sprite = PrefixPropAnimation:createPropAnimation(icon, self.layer:convertToNodeSpace(fromGlobalPosition), onAnimationFinished)
      self.layer:addChild(sprite)
    end
    PropsModel:instance():clearTemporaryPops()
  else
    animationCallback()
  end
end

function PropListAnimation:createPropListItem(index, itemId)
    local function onHideCallback(item)
      local maxIndex = self:findMaxSlotIndex()
      local removedIndex = item.index
      if maxIndex < removedIndex and removedIndex > self.propListMaxItemPerPage then
        local position = self.content:getPosition()
        local visibleX = self:getItemOffset(maxIndex)

        self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(visibleX, position.y))))
      end
    end

    local item = nil
    if itemId == kSpringPropItemID then
      print("spring: ", index, self["item"..index])
      item = SpringPropListItem:create(index, self.propsListView:getChildByName("p"..index), self.propsListView:getChildByName("i"..index), self) 
    else
      item = PropListItem:create(index, self.propsListView:getChildByName("p"..index), self.propsListView:getChildByName("i"..index), self)
    end

    item.onHideCallback = onHideCallback
    self["item"..index] = item
    if table.exist(kPropItemDirections, index) then
       item.direction = -1
    end

    return item
end

function PropListAnimation:show( propItems, delayTime )
    self.content:setPosition(ccp(0,0))
    delayTime = delayTime or 0 --1.35

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

    local currItems = #PropsModel.instance().propItems

  	for i = 1, kCurrentMaxItemInListView do
      local item = self["item"..i]

      if i <= currItems then
        local propItem = PropsModel:instance().propItems[i]
        local initDisable = propItem.itemId ~= kSpringPropItemID and propItem.itemId == GamePropsType.kBack
        item:show(0, true, initDisable)
      else
        item:hide() 
      end
    end

    local springItem = self.controller:findSpringItem()
    if springItem then
        setTimeOut(function()
             if self.content and self.content.refCocosObj then
               self.content:runAction(CCMoveTo:create(0.2, ccp(0,0)))
             end
          end, 1)
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
      item.animator:windover(delayTime)
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

function PropListAnimation:onGameMoveChange(number, animated)

  if self.levelModeType == "Classic" or self.levelModeType == "RabbitWeekly" then
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
  if not PropsModel:instance():addStepItemExist() or self:findAddMoveItem() then return end
  self:addItemWithAnimation(PropsModel:instance().addStepItems[1], 0.3, true)
  --self:addItemWithAnimation(table.remove(self.addStepItems), 0.3, true)
end

function PropListAnimation:hideAddMoveItem()
  local item = self:findAddMoveItem()
  if item and not item.isExplodeing then item:hide() end
end

function PropListAnimation:findAddMoveItem()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:isAddMoveProp() then 
      return item 
    end
  end

  return nil
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
    PropsModel:instance():addItem(item)
    local itemIndex = self:findEmptySlot()
    if itemIndex >= kCurrentMaxItemInListView then return end
    --self["item"..itemIndex]:enableUnlimited(self.isUnlimited)
    self["item"..itemIndex]:setPropItemData(item, self:getPropUnlimitable(item.itemId))
    self["item"..itemIndex]:show(delayTime, true) 
   if useHint then self["item"..itemIndex].animator:pushPropAnimation(2) end
    
    self:updateVisibleMinX()
    self.content:stopAllActions()
    self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.6, ccp(self:getItemOffset(itemIndex), 0)))) 
    return itemIndex
  end
  return -1
end

-- 出现的位置->飞到屏幕中心->变大+发光->变小->飞到道具栏
function PropListAnimation:addGetPropAnimation(item, index, fromGlobalPosition, flyFinishedCallback, propID, text)
  assert(propID, "propID cannot be nil")
  if not item or not fromGlobalPosition then return end

  local from = self.layer:convertToNodeSpace(fromGlobalPosition)
  local to = item:getItemCenterPosition() --itemTo:getPosition()
  local winSize = CCDirector:sharedDirector():getWinSize()

  local centerPos = self.layer:convertToNodeSpace(ccp(winSize.width / 2, winSize.height / 2))

  local timeScale = 1

  local propIcon = nil
  if propID then propIcon = PropListAnimation:createIcon( propID ) end
  if propIcon then
    local offsetX = 0
    if index > self.propListMaxItemPerPage then offsetX = self:getItemOffset(index) end 

    self.layer:addChild(propIcon)  
    propIcon:setPosition(ccp(from.x, from.y))
    local seq = CCArray:create()
    seq:addObject(CCMoveTo:create(0.3 * timeScale, centerPos))
    local function addBgAnimation()
      local anim = CommonEffect:buildGetPropLightAnim(text)
      anim:setPosition(centerPos)
      self.layer:addChildAt(anim, -1)
    end
    seq:addObject(CCCallFunc:create(addBgAnimation))
    seq:addObject(CCScaleTo:create(0.5, 1.8))
    seq:addObject(CCDelayTime:create(2))
    seq:addObject(CCScaleTo:create(0.3, 1))
    
    local function addFallingtar()
      local fallingStar = FallingStar:create(centerPos, ccp(to.x + offsetX, to.y+278), nil, flyFinishedCallback)
      self.layer:addChild(fallingStar)
    end

    seq:addObject(CCCallFunc:create(addFallingtar))
    seq:addObject(CCEaseSineInOut:create(CCMoveTo:create(0.5, ccp(to.x + offsetX, to.y+278))))
    local function onAnimationFinished() propIcon:removeFromParentAndCleanup(true) end
    seq:addObject(CCCallFunc:create(onAnimationFinished))
    propIcon:runAction(CCSequence:create(seq))
  end
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
  print("added temporary item: ", itemId, itemNum)

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
    local mappingItemId = PropsModel.kTempPropMapping[tostring(itemId)]
    if mappingItemId then itemFound, itemIndex = self:findItemByItemID(mappingItemId) end
    
    if itemFound then
      local function onNormalFlyFinishedCallback()
        itemFound:increaseTemporaryItemNumber(itemId, itemNum)
      end    
      self:addFallingtar(itemFound, itemIndex, fromGlobalPosition, onNormalFlyFinishedCallback, animatedItemID)
      return
    end
  end

  local itemData = PropItemData:createWithData({itemId=itemId, itemNum=itemNum, temporary=1})
  local index = self:addItemWithAnimation(itemData, 0)
  if index < 1 then return end

  local onTemporaryItemUsed = function( removedItem )
    local maxIndex = self:findMaxSlotIndex()
    local removedIndex = removedItem.index
    PropsModel:instance():removeItem(removedItem)
    if maxIndex < removedIndex and removedIndex > self.propListMaxItemPerPage then
      local position = self.content:getPosition()
      local visibleX = self:getItemOffset(maxIndex)
      self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(visibleX, position.y))))
    end
  end
  self:addFallingtar(self["item"..index], index, fromGlobalPosition, nil, animatedItemID)
  self["item"..index].onTemporaryItemUsed = onTemporaryItemUsed
end

function PropListAnimation:addTimeProp(propId, itemNum, expireTime, fromGlobalPosition, showIcon, text)
  itemNum = itemNum or 0
  local itemId = ItemType:getRealIdByTimePropId(propId)
  local itemFound, itemIndex = self:findItemByItemID(itemId)
  local animateFallingIcon = true
  local animatedItemID = nil
  if showIcon ~= nil then animateFallingIcon = showIcon end
  if animateFallingIcon then animatedItemID = itemId end

  if itemFound then
    local function onAnimationFinishedCallback()
      itemFound:increaseTimePropNumber(propId, itemNum, expireTime)
    end    
    self:addGetPropAnimation(itemFound, itemIndex, fromGlobalPosition, onAnimationFinishedCallback, animatedItemID, text)
  else
    PropsModel:instance():addTimeProp(propId, itemNum, expireTime)
    local itemData = PropItemData:create(itemId)
    local index = self:addItemWithAnimation(itemData, 0)
    if index < 1 then return end
    self:addGetPropAnimation(self["item"..index], index, fromGlobalPosition, nil, animatedItemID, text)
  end
end

function PropListAnimation:updateVisibleMinX()
  self.visibleMinX = self:getItemOffset(self:findMaxSlotIndex())
end

function PropListAnimation:updateContentPosition( evt )
  if PropsModel:instance().propItems and self:findMaxSlotIndex() > self.propListMaxItemPerPage then
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

function PropListAnimation:addFakeAllProp( value )
  -- body
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible then 
      item:setNumber(value)
    end
  end

end

function PropListAnimation:useItemWithType(itemId, propType)
  local item = self:findItemByItemID(itemId)
  if item then 
    item:useWithType(itemId, propType)
  end
end

function PropListAnimation:setItemNumber( itemId, itemNum )
  local item = self:findItemByItemID(itemId)
  if item then
      item:setNumber(itemNum)
  end
end

function PropListAnimation:addItemNumber( itemId, itemNum )
  local item = self:findItemByItemID(itemId)
  if item then 
    item:addNumber(itemNum)
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

function PropListAnimation:setPropState(itemId, reasonType, enable)
  if itemId ~= nil then 
    local item = self:findItemByItemID(itemId)
    if item then
      if enable then
          item:setEnable()
      else
          item:setDisableReason(reasonType) 
      end
    end
  end
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

function PropListAnimation:setLevelModeType(levelModeType, levelType)
    self.levelModeType = levelModeType
    self.levelType = levelType
    if self.levelModeType == 'MaydayEndless' or self.levelModeType == 'halloween' then
        self.isUnlimited = true
    end
end

function PropListAnimation:setSpringItemPercent(percent)
  local item = self.item3
  if item and item:is(SpringPropListItem) then
    item:setPercent(percent, true)
  end
end

function PropListAnimation:findSpringItem()
  local item = self.propsListView:getChildByName("i"..3)
  if item and self.item3:is(SpringPropListItem) then
    return item
  end
  return nil
end

function PropListAnimation:setSpringItemEnergy(energy, theCurMoves)
  local item = self.item3
  if item and item:is(SpringPropListItem) then
    item:setEnergy(energy, true, theCurMoves)
  end
end

function PropListAnimation:getSpringItemGlobalPosition()
  local item = self:findSpringItem()
  if item then
    local pos = item:getPosition()
    pos = ccp(pos.x - 30, pos.y + 60)
    return item:getParent():convertToWorldSpace(pos)
  end
  return ccp(0,0)
end