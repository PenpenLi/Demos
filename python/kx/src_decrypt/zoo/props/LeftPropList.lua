require "zoo.props.PropListItem"
require "zoo.panel.PropInfoPanel"
require 'zoo.props.SpringPropListItem'
require "zoo.props.PropListContainer"
require "zoo.props.LeftPropListController"

local kCurrentMaxItemInListView = 18
local kItemGapInListView = 12
local kPropListItemWidth = 130
local kPropItemDirections = {2, 3, 5}

LeftPropList = class(PropListContainer)

function LeftPropList:create(propListAnimation, size)
	local node = LeftPropList.new(CCNode:create())
	PropListContainer.init(node, propListAnimation, size)
	node:_init()
	node:_buildUI()
	return node
end

function LeftPropList:dispose()
	PropListContainer.dispose(self)
  	for i = 1, kCurrentMaxItemInListView do
      self["item"..i]:dispose()
    end
end

function LeftPropList:_init()
  --[[
  if kWindowFrameRatio.iPad.name == __frame_key then
    kPropListScaleFactor = 0.9
  end
  if kWindowFrameRatio.iPhone4.name == __frame_key then
    kPropListScaleFactor = 0.9
  end
  ]]
  self.propListItemWidth = kPropListItemWidth
  self.propListMaxItemPerPage = math.floor(self.width / self.propListItemWidth)
  self:setController(LeftPropListController:create(self))
end

function LeftPropList:_buildUI(levelId)
    self.levelId = levelId
  	local winSize = CCDirector:sharedDirector():getWinSize()
    self.levelSkinConfig = GamePlaySceneSkinManager:getConfig(GamePlaySceneSkinManager:getCurrLevelType())
  	local propsListView = ResourceManager:sharedInstance():buildGroup(self.levelSkinConfig.propsListView)

  	local targetSize = propsListView:getGroupBounds().size
  	propsListView:setContentSize(CCSizeMake(targetSize.width, targetSize.height))
  	propsListView:setPosition(ccp(0, 215))
  	self.propsListView = propsListView
  	self.content:addChild(propsListView)

    local bgIndex = propsListView:getChildByName("background"):getZOrder()
    local bgGb = propsListView:getChildByName("background"):getGroupBounds(propsListView)
    local fgGb = propsListView:getChildByName("foreground"):getGroupBounds(self.content)

    local bgSymbolName = propsListView:getChildByName("background").symbolName
    local fgSymbolName = propsListView:getChildByName("foreground").symbolName

    propsListView:getChildByName("foreground"):removeFromParentAndCleanup(true)
    propsListView:getChildByName("background"):removeFromParentAndCleanup(true)

    local foreground = ResourceManager:sharedInstance():buildBatchGroup("batch", fgSymbolName)
    foreground.name = "foreground"
    foreground:setAnchorPoint(ccp(0, 0))
    foreground:ignoreAnchorPointForPosition(false)
    foreground:setPosition(ccp(fgGb.origin.x, fgGb.origin.y + fgGb.size.height))
    self.viewLayer:addChild(foreground)

    local helpButton = foreground:getChildByName("help_button")
      self.helpButton = PropHelpButton.new(helpButton, levelId)
    if self.propListAnimation and self.propListAnimation.levelType == GameLevelType.kMayDay then
      helpButton:setVisible(false)
      self.helpButton.onTouchBegin = function (self, evt) end
      self.helpButton.onTouchEnd = function (self, evt) end
      self.helpButton.hitTest = function (self, position) return false end
    end

    local background = ResourceManager:sharedInstance():buildBatchGroup("batch", bgSymbolName)
    background.name = "background"
    background:setAnchorPoint(ccp(0, 0))
    background:ignoreAnchorPointForPosition(false)
    background:setPosition(ccp(bgGb.origin.x, bgGb.origin.y + bgGb.size.height))
    propsListView:addChildAt(background, bgIndex)

    local backgroundSize = background:getGroupBounds().size

    self.minX = self.width - backgroundSize.width + 40
    self.maxX = 0
    self.visibleMinX = self.minX

    self:createItems()

    self:recItemSize()
end

function LeftPropList:show( propItems, delayTime )
    self.content:setPosition(ccp(0,0))
    delayTime = delayTime or 0 --1.35

    local propsListView = self.propsListView
    local background = propsListView:getChildByName("background")
  
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

    local springItem = self:findSpringItem()
    if springItem then
        self:moveToFirstItem(1)
    end
    self:updateVisibleMinX()

    self:getPropPositions()
end

function LeftPropList:moveToFirstItem(delayTime)
    setTimeOut(function()
         if self.content and self.content.refCocosObj then
           self.content:runAction(CCMoveTo:create(0.2, ccp(0,0)))
         end
      end, delayTime)
end

function LeftPropList:createItems()
    local currItems = #PropsModel.instance().propItems

    for i = 1, kCurrentMaxItemInListView do

      if i <= currItems then
        local propItem = PropsModel:instance().propItems[i]
        local item  = self:createPropListItem(i, propItem.itemId)

        item:setPropItemData(propItem, self.propListAnimation:getPropUnlimitable(propItem.itemId)) --setup the item's data
      else
         self:createPropListItem(i, nil)
      end
    end
end

function LeftPropList:addItemWithAnimation( item, delayTime, useHint )
  if item then
    PropsModel:instance():addItem(item)
    local itemIndex = self:findEmptySlot()
    if itemIndex >= kCurrentMaxItemInListView then return end
    --self["item"..itemIndex]:enableUnlimited(self.isUnlimited)
    self["item"..itemIndex]:setPropItemData(item, self.propListAnimation:getPropUnlimitable(item.itemId))
    self["item"..itemIndex]:show(delayTime, true) 
    if useHint then self["item"..itemIndex].animator:pushPropAnimation(2) end
    
    self:updateVisibleMinX()
    self.content:stopAllActions()
    self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(0.6, ccp(self:getItemOffset(itemIndex), 0)))) 
    return itemIndex
  end
  return -1
end

function LeftPropList:flushTemporaryProps(positionSrc, animationCallback)
  if PropsModel:instance():temporaryPopsExist() then 
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
      local sprite = PrefixPropAnimation:createPropAnimation(icon, self.propListAnimation.layer:convertToNodeSpace(fromGlobalPosition), onAnimationFinished)
      self.propListAnimation.layer:addChild(sprite)
    end
    PropsModel:instance():clearTemporaryPops()
  else
    animationCallback()
  end
end

-- 出现的位置->飞到屏幕中心->变大+发光->变小->飞到道具栏
function LeftPropList:addGetPropAnimation(item, index, fromGlobalPosition, flyFinishedCallback, propID, text)
  assert(propID, "propID cannot be nil")
  if not item or not fromGlobalPosition then return end

  local from = self.propListAnimation.layer:convertToNodeSpace(fromGlobalPosition)
  local finalPos = self:ensureItemInSight(item, 0.3)
  local to = self.propListAnimation.layer:convertToNodeSpace(finalPos) --item:getItemCenterPosition()
  local winSize = CCDirector:sharedDirector():getWinSize()

  local centerPos = self.propListAnimation.layer:convertToNodeSpace(ccp(winSize.width / 2, winSize.height / 2))

  local timeScale = 1

  local propIcon = nil
  if propID then propIcon = PropListAnimation:createIcon( propID ) end
  if propIcon then
    local offsetX = 0
    -- if index > self.propListMaxItemPerPage then offsetX = self:getItemOffset(index) end 

    self.propListAnimation.layer:addChild(propIcon)  
    propIcon:setPosition(ccp(from.x, from.y))
    local seq = CCArray:create()
    seq:addObject(CCMoveTo:create(0.3 * timeScale, centerPos))
    local function addBgAnimation()
      local anim = CommonEffect:buildGetPropLightAnim(text)
      anim:setPosition(centerPos)
      self.propListAnimation.layer:addChildAt(anim, -1)
    end
    seq:addObject(CCCallFunc:create(addBgAnimation))
    seq:addObject(CCScaleTo:create(0.5, 1.8))
    seq:addObject(CCDelayTime:create(2))
    seq:addObject(CCScaleTo:create(0.3, 1))
    
    local function addFallingtar()
      local fallingStar = FallingStar:create(centerPos, ccp(to.x + offsetX, to.y), nil, flyFinishedCallback)
      self.propListAnimation.layer:addChild(fallingStar)
    end

    seq:addObject(CCCallFunc:create(addFallingtar))
    seq:addObject(CCEaseSineInOut:create(CCMoveTo:create(0.5, ccp(to.x + offsetX, to.y))))
    local function onAnimationFinished() propIcon:removeFromParentAndCleanup(true) end
    seq:addObject(CCCallFunc:create(onAnimationFinished))
    propIcon:runAction(CCSequence:create(seq))
  end
end

function LeftPropList:addFallingtar( item, index, fromGlobalPosition, flyFinishedCallback, propID )
  if not item or not fromGlobalPosition then return end

  --local itemTo = item.item
  local finalPos = self:ensureItemInSight(item, 0.3)
  local to = self.propListAnimation.layer:convertToNodeSpace(finalPos) --item:getItemCenterPosition()
  local from = self.propListAnimation.layer:convertToNodeSpace(fromGlobalPosition) 
  local offsetX = 0
  -- if index > self.propListMaxItemPerPage then offsetX = self:getItemOffset(index) end  
  local fallingStar = BezierFallingStar:create(from, ccp(to.x + offsetX, to.y), nil, flyFinishedCallback)
  self.propListAnimation.layer:addChild(fallingStar)

  local propIcon = nil
  if propID then propIcon = PropListAnimation:createIcon( propID ) end
  if propIcon then
    self.propListAnimation.layer:addChild(propIcon)
    -- local time = fallingStar.time or 0.5
    local array = CCArray:create()
    local function onAnimationFinished() propIcon:removeFromParentAndCleanup(true) end
    -- array:addObject(CCEaseSineInOut:create(CCMoveTo:create(time, ccp(to.x + offsetX, to.y))))
    array:addObject(fallingStar:createMoveAction(from, ccp(to.x + offsetX, to.y)))
    array:addObject(CCCallFunc:create(onAnimationFinished))
    propIcon:setPosition(ccp(from.x, from.y))
    propIcon:runAction(CCSequence:create(array))

  end
end

function LeftPropList:addTemporaryItem( itemId, itemNum, fromGlobalPosition, showIcon )
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

function LeftPropList:addTimeProp(propId, itemNum, expireTime, fromGlobalPosition, showIcon, text)
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
      self.isPlayingTimePropAnim = false
    end    
    self.isPlayingTimePropAnim = true
    self:addGetPropAnimation(itemFound, itemIndex, fromGlobalPosition, onAnimationFinishedCallback, animatedItemID, text)
  else
    PropsModel:instance():addTimeProp(propId, itemNum, expireTime)
    local itemData = PropItemData:create(itemId)
    local index = self:addItemWithAnimation(itemData, 0)
    if index < 1 then return end
    self:addGetPropAnimation(self["item"..index], index, fromGlobalPosition, nil, animatedItemID, text)
  end
end

function LeftPropList:isPlayingAddTimePropAnim()
  return self.isPlayingTimePropAnim
end

function LeftPropList:ensureItemInSight(item, duration)
	assert(item)

	local localPos = self.content:getParent():convertToNodeSpace(item:getItemCenterPosition())
	local posX = localPos.x
	local posY = localPos.y
	local originX = 0
	local firstItemX = originX + kPropListItemWidth / 2 + 20
	local lastItemX = originX + self.width - (kPropListItemWidth / 2 + 20)
	if localPos.x < firstItemX then
		posX = firstItemX
		self:updateContentWithDeltaX(firstItemX - localPos.x, duration)
	elseif localPos.x > lastItemX then
		posX = lastItemX
		self:updateContentWithDeltaX(lastItemX - localPos.x, duration)
	end
	local finalPosInWorld = self.content:getParent():convertToWorldSpace(ccp(posX, posY))
	return finalPosInWorld
end

function LeftPropList:showAddStepItem()
  if not PropsModel:instance():addStepItemExist() or self:findAddMoveItem() then return end
  self:addItemWithAnimation(PropsModel:instance().addStepItems[1], 0.3, true)
  --self:addItemWithAnimation(table.remove(self.addStepItems), 0.3, true)
end

function LeftPropList:hideAddMoveItem()
  local item = self:findAddMoveItem()
  if item and not item.isExplodeing then 
  	item:hide() 
  	self:updateVisibleMinX()
  end
end

function LeftPropList:findAddMoveItem()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:isAddMoveProp() then 
      return item 
    end
  end

  return nil
end

function LeftPropList:setItemDark( hitItemID, darked )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and i ~= hitItemID then item:dark(darked) end
  end
end

function LeftPropList:addFakeAllProp( value )
  -- body
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible then 
      item:setNumber(value)
    end
  end
end

function LeftPropList:findItemByItemID( itemId )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:verifyItemId(itemId) then return item, i end
  end
  return nil, -1
end

function LeftPropList:recItemSize()
  local item = self.propsListView:getChildByName("i1")
  local size = item:getGroupBounds().size
  self.itemSizeRec = {width = size.width, height = size.height}
end

function LeftPropList:getPropPositions()
  self.propPositions = {}
  for i = 1, 5 do
    local item = self.propsListView:getChildByName("i"..i)
    local pos = item:getPosition()
    pos = item:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
    if i == 2 or i == 3 or i == 5 then
      pos.x = pos.x - self.itemSizeRec.width / 5
    else
      pos.x = pos.x + self.itemSizeRec.width / 5
    end
    pos.y = pos.y + self.itemSizeRec.height * 2 / 5
    table.insert(self.propPositions, pos)
  end
end

function LeftPropList:getPositionByIndex(index)
  local pos = self.propPositions[index]
  if self.content then pos.x = pos.x + self.content:getPosition().x end
  return pos
end

function LeftPropList:createPropListItem(index, itemId)
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
    local background = self.propsListView:getChildByName("background")
    if itemId == kSpringPropItemID then
      print("spring: ", index, self["item"..index])
      item = SpringPropListItem:create(index, background:getChildByName("p"..index), self.propsListView:getChildByName("i"..index), self.propListAnimation) 
    else
      item = PropListItem:create(index, background:getChildByName("p"..index), self.propsListView:getChildByName("i"..index), self.propListAnimation)
    end

    item.onHideCallback = onHideCallback
    self["item"..index] = item
    if table.exist(kPropItemDirections, index) then
       item.direction = -1
    end

    return item
end

function LeftPropList:windover(direction)
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

function LeftPropList:hasAllItemAnimationFinished()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item:isPlayingAnimation() then return false end
  end
  return true
end

function LeftPropList:findHitItemIndex( evt )
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and item.visible and item:hitTest(evt.globalPosition) then return i end
  end
  return 0
end

function LeftPropList:findMaxSlotIndex()
  for i = kCurrentMaxItemInListView, 1, -1 do
    local item = self["item"..i]
    if item and item.visible then return i end
  end
  return 1
end

function LeftPropList:findEmptySlot()
  for i = 1, kCurrentMaxItemInListView do
    local item = self["item"..i]
    if item and not item.visible then return i end
  end
  return -1
end

function LeftPropList:getItemOffset( index )
  local contentWidth = (self["item"..1].item:getContentSize().width - kItemGapInListView)
  -- 每6个道具会出现一个树枝，因此加上一个40的offset作调整
  local contentMinX = self.width - contentWidth * index - math.ceil((index - 6) / 6) * 40
  if contentMinX > 0 then contentMinX = 0 end
  return math.max(self.minX, contentMinX)
end

function LeftPropList:updateVisibleMinX()
  self.visibleMinX = self:getItemOffset(self:findMaxSlotIndex())
end

function LeftPropList:updateContentWithDeltaX(dx, duration)
  local position = self.content:getPosition()
  local fx = position.x + dx
  if fx > self.maxX then fx = self.maxX end
  if fx < self.visibleMinX then fx = self.visibleMinX end

  self.content:stopAllActions()
  if duration and duration > 0 then
  	self.content:runAction(CCEaseSineOut:create(CCMoveTo:create(duration, ccp(fx, position.y))))
  else
	self.content:setPositionX(fx)
  end
end

function LeftPropList:updateContentPosition( evt )
  if PropsModel:instance().propItems and self:findMaxSlotIndex() > self.propListMaxItemPerPage then
    if evt.globalPosition and self.prev_position then
      local dx = evt.globalPosition.x - self.prev_position.x
      self:updateContentWithDeltaX(dx)
    end
    self.prev_position = evt.globalPosition
  end  
end

function LeftPropList:findSpringItem()
  local item = self.item3
  if item and item:is(SpringPropListItem) then
    return item
  end
  return nil
end