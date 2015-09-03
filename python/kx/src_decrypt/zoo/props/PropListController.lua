PropListController = class()

function PropListController:ctor(propList)
	self.propList = propList
end

function PropListController:create(propList)
	local controller = PropListController.new(propList)
	controller:init()

	return controller
end

function PropListController:init()
	local layer = self.propList.layer

	local function onTouchBegin(evt) self:onTouchBegin(evt) end
  	local function onTouchMove(evt)  self:onTouchMove(evt) end
  	local function onTouchEnd(evt)  self:onTouchEnd(evt) end

	layer:ad(DisplayEvents.kTouchBegin, onTouchBegin)
	layer:ad(DisplayEvents.kTouchMove, onTouchMove)
	layer:ad(DisplayEvents.kTouchEnd, onTouchEnd)
end

function PropListController:registerUsePropCallback(usePropCallback, ...)
	assert(type(usePropCallback) == "function")
	assert(#{...} == 0)

	print("PropListAnimation:registerUsePropCallback Called !")
	self.usePropCallback = usePropCallback
end

function PropListController:registerCancelPropUseCallback(callbackFunc, ...)
	assert(type(callbackFunc) == "function")
	assert(#{...} == 0)

	self.cancelPropUseCallback = callbackFunc
end

function PropListController:registerBuyPropCallback(callbackFunc, ...)
	assert(type(callbackFunc) == "function")
	assert(#{...} == 0)

	self.buyPropCallback = callbackFunc
end

function PropListController:callBuyPropCallback(itemId, ...)
	assert(type(itemId) == "number")
	assert(#{...} == 0)

	self.buyPropCallback(itemId)
end

function PropListController:callUsePropCallback(propItemUsed, itemId, usePropType, isRequireConfirm, ...)
	assert(propItemUsed)
	assert(type(itemId) == "number")
	assert(type(usePropType) == "number")
	assert(type(isRequireConfirm) == "boolean")
	assert(#{...} == 0)

	self.propList.propItemUsed = propItemUsed

	if self.usePropCallback then
		return self.usePropCallback(itemId, usePropType, isRequireConfirm)
	end
	return true
end

function PropListController:callCancelPropUseCallback(itemId, ...)
	assert(#{...} == 0)

	if self.cancelPropUseCallback then
		self.cancelPropUseCallback(itemId)
	end
end

function PropListController:registerSpringItemCallback(callback)
  	self.springItemCallback = callback
end

function PropListController:findSpringItem()
	for i=1, 18 do
		local item = self.propList["item"..i]
		if item and item:is(SpringPropListItem) then
			return item
		end
	end

	return nil
end

function PropListController:findSpringItemIcon()
	for i=1, 18 do
		local item = self.propList["item"..i]
		if item and item:is(SpringPropListItem) then
			if item.icon then 
				return item.icon
			end
		end
	end

	return nil
end

function PropListController:forceUseSpringItem(forceUsedCallback)

	for i=1, 18 do
		local item = self.propList["item"..i]
		if item and item:is(SpringPropListItem) then
			if item.use then 
				item:use(forceUsedCallback, true)
			else
				print("@!@@@@@@@@@@@@@@@@@item don't have a use method!!!!!!!!!!!!!!")
			end
		end
	end
end

function PropListController:onTouchBegin( evt )
	local propList = self.propList

	propList.isMoved = false
	propList.prev_position = evt.globalPosition
	propList.begin_index = propList:findHitItemIndex(evt)
	propList:updateVisibleMinX()

	if propList.isTouchEnabled then propList.helpButton:onTouchBegin(evt) end
end

function PropListController:onTouchMove( evt )
	local propList = self.propList

	if propList.focusItem then
	else   
		if evt.globalPosition and propList.prev_position then
		  local dx = evt.globalPosition.x - propList.prev_position.x
		  local dy = evt.globalPosition.y - propList.prev_position.y
		  if dx < 0 then propList.directionWind = -1 
		  else propList.directionWind = 1 end
		  if dx * dx + dy * dy > 64 then propList.isMoved = true end
		end
		propList:updateContentPosition(evt)
	end  
end

function PropListController:onTouchEnd( evt )
	local propList = self.propList

  	propList.helpButton:onTouchEnd(evt)

	if propList.focusItem then
	    propList.focusItem:focus(false)
	    propList:setItemDark(-1, false)
	    propList.focusItem = nil
	else
	    propList:updateContentPosition(evt)
	    if propList.isMoved then return propList:windover(propList.directionWind) end

	    if not propList.isTouchEnabled then return end

	    if propList.helpButton:use(evt.globalPosition) then return end

	    local hitItemID = propList:findHitItemIndex(evt)
	    if hitItemID > 0 and hitItemID == propList.begin_index then 
	      local hitItem = propList["item"..hitItemID]
	      if hitItem:isItemRequireConfirm() then
	          if hitItem:use() then 
	            propList.focusItem = hitItem
	            hitItem:focus(true) 
	            propList:setItemDark(hitItemID, true)
	         end
	      else 
	      	hitItem:use() 
	      end
	    end
	end

	propList.begin_index = 0
end


