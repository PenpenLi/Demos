local kRequireConfirmItems = {10010, 10026, 10005, 10019, 10027, 10003, 10028, 10055, 10056, 10057}

PropItemData = class()

function PropItemData:ctor(itemId)
	self.itemId = itemId
  self.isOnceUsed = false
  self.usedTimes = 0
  self.itemNum = 0
  self.timePropNum = 0
end

function PropItemData:create(itemId)
	local propItemData = PropItemData.new(itemId)

  return propItemData
end

--{itemId=itemId, itemNum=itemNum, temporary=1}
function PropItemData:createWithData(data)
  	local item = self:create(data.itemId)
  	item.itemNum = data.itemNum
  	item.temporary = data.temporary

  	return item
end

function PropItemData:enableUnlimited(isUnlimited)
    self.isUnlimited = isUnlimited

    local meta = self:getPropMeta()
    self.maxUsetime = meta.maxUsetime or 0

    if isUnlimited then
        self.maxUsetime = 4294967295
    end
end

function PropItemData:initTimeProps()
	local timeProps = PropsModel:instance():getTimePropsByItemId(self.itemId)
	self:setTimeProps(timeProps)
end

function PropItemData:setTimeProps(props)
  if self:_isSpringItem() then
    return
  end

	self.timePropList = {}
	if props and #props > 0 then
		for _,v in pairs(props) do
		 	table.insert(self.timePropList, v)
		end
		table.sort( self.timePropList, function( a, b )
			return a.expireTime < b.expireTime
		end )
	end

	self:_updateTimePropNum()
end

function PropItemData:getPropMeta()
  if self:_isSpringItem() then
      return {}
  end

  return MetaManager:getInstance():getPropMeta(self.itemId)
end

function PropItemData:isTemporaryExist()
   return self.temporaryItemList and #self.temporaryItemList>0
end

function PropItemData:isTemporaryMode()
  if self:_isSpringItem() then
      return false
  end

  return self.temporary == 1
end

function PropItemData:_updateTimePropNum()
  local num = 0
  if self.timePropList then
    for _,v in pairs(self.timePropList) do
      if v and v.itemNum then num = num + v.itemNum end
    end
  end
  self.timePropNum = num
end

function PropItemData:useTimeProp()
  if self:_isSpringItem() then
    return
  end

  for i,v in ipairs(self.timePropList) do
    if v.itemNum > 0 then 
      v.itemNum = v.itemNum - 1 
      self:_updateTimeProps()
      return
    end
  end
end

function PropItemData:_updateTimeProps()
  if self.timePropList then
    local newList = {}
    for i,v in ipairs(self.timePropList) do
      if v.itemNum > 0 then
        table.insert(newList, v)
      end
    end
    self.timePropList = newList
  end 
  self:_updateTimePropNum()
end

function PropItemData:getTimePropNum()
  if self:_isSpringItem() then
      return 0
  end

  return self.timePropNum
end

function PropItemData:isAddMoveProp(levelId)
  if self.itemId == 10004 then 
      return true 
  elseif self.itemId == 10057 and RecallManager.getInstance():getRecallLevelState(levelId) then--推送召回功能 三免费道具打关卡需求 10057 临时魔力扫把
      if self.isOnceUsed then 
        return true
      end
  end
  return false
end

function PropItemData:getDisplayItemNumber()
  if self:_isSpringItem() then
    return 0
  end

  local tempNum = 0
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then
    for i,v in ipairs(temporaryItemList) do
      local number = v.itemNum or 0
      tempNum = tempNum + number
    end
  end

  if tempNum > 0 then
    return tempNum
  else
    local timePropNum = self:getTimePropNum()
    if timePropNum > 0 then
      return timePropNum
    else
      return self.itemNum
    end
  end
end

function PropItemData:getTotalItemNumber()
    if self:_isSpringItem() then
        return 0
    end

    local itemNum = self.itemNum or 0 
    local temporaryItemList = self.temporaryItemList
    if temporaryItemList and #temporaryItemList > 0 then
      for i,v in ipairs(temporaryItemList) do
        local number = v.itemNum or 0
        itemNum = itemNum + number
      end
    end

    return itemNum + self:getTimePropNum()
end

function PropItemData:isItemRequireConfirm()
  if self:_isSpringItem() then
      return false
  end

	for i,v in ipairs(kRequireConfirmItems) do
		if v == self.itemId then return true end
	end
	return false
end

function PropItemData:isTempItem(itemId)
  if self:_isSpringItem() then
      return false
  end

  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then
    for i,v in ipairs(temporaryItemList) do
      if v.itemId == itemId then return true end
    end
  end
  
  return false
end

function PropItemData:isTimeItem( itemId )
  if self:_isSpringItem() then
      return false
  end

  if self.timePropList and #self.timePropList > 0 then
    for i,v in ipairs(self.timePropList) do
      if v.itemId == itemId then return true end
    end
  end
  return false
end

function PropItemData:verifyItemId( itemId )
  if self:_isSpringItem() then
      return false
  end

  if self:isTempItem(itemId) 
      or self:isTimeItem(itemId) 
      or itemId == self.itemId then 
    return true 
  end
  
  return false
end

function PropItemData:findItemID()
  if self:_isSpringItem() then
      return kSpringPropItemID
  end

  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then return temporaryItemList[1].itemId end
  if self:getTimePropNum() > 0 then return self:findTimePropID() end
  return self.itemId
end

function PropItemData:findTimePropID()
  if self.timePropList then
    for i,v in ipairs(self.timePropList) do
        if v and v.itemNum > 0 then
          return v.itemId
        end
    end
  end

  return nil
end

function PropItemData:getDefaultItemID()
  if self:_isSpringItem() then
      return kSpringPropItemID
  end

  if self.itemId then return self.itemId end
  local temporaryItemList = self.temporaryItemList
  if temporaryItemList and #temporaryItemList > 0 then return temporaryItemList[1].itemId end
  return 0
end

function PropItemData:increaseTimePropNumber(propId, itemNum, expireTime)
  if self:_isSpringItem() then
      return
  end

  if ItemType:getRealIdByTimePropId(propId) ~= self.itemId then
      return
  end

  itemNum = itemNum or 0
  self.timePropList = self.timePropList or {}
  local expireItem = PropItemData:create(propId)
  expireItem.realItemId = ItemType:getRealIdByTimePropId( propId )
  expireItem.itemNum = itemNum 
  expireItem.expireTime = expireTime
  expireItem.temporary = 0
  expireItem.isTimeProp = true

  table.insert(self.timePropList, expireItem)
  self:_updateTimeProps()
end

function PropItemData:increaseItemNumber( itemId, itemNum )
  itemNum = itemNum or 0
  if self.temporaryItemList then 
    self:updateTemporaryItemNumber(itemId, itemNum)
    return true
  else
    self.itemNum = self.itemNum + itemNum
    return false
  end
end

function PropItemData:updateTemporaryItemNumber( itemId, itemNum )
  if self:_isSpringItem() then
      return
  end

  itemNum = itemNum or 0
  self.temporaryItemList = self.temporaryItemList or {}
  self.temporary = 1

  local itemFound, oldNum = nil, 0
  for i,v in ipairs(self.temporaryItemList) do
    if v.itemId == itemId then itemFound = v end
  end
  if itemFound then oldNum = itemFound.itemNum or 0 
  else 
    itemFound = {itemId = itemId}
    table.insert(self.temporaryItemList, itemFound) 
  end
  itemFound.itemNum = oldNum + itemNum
  if itemFound.itemNum <= 0 then 
    table.removeValue(self.temporaryItemList, itemFound)
  end

  if #self.temporaryItemList < 1 then 
      self:clearTemporary()
  end
end

function PropItemData:clearTemporary()
 	self.temporaryItemList = nil
  self.temporary = 0
end

function PropItemData:useWithType(itemId, propType)
  assert(type(itemId)=="number")
  assert(type(propType) == "number")

  if self:_isSpringItem() then
      return
  end

  if propType == UsePropsType.NORMAL then
    if  self.itemId == itemId then
      self.itemNum = self.itemNum - 1
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
    if item then 
      self:updateTemporaryItemNumber(itemId, item.itemNum - 1)
    	return item 
    end
  end

  return nil
end

function PropItemData:confirm(itemId, levelId)
  local isTemporaryMode = self:isTemporaryMode()
  if isTemporaryMode then
      --推送召回活动 
      if RecallManager.getInstance():getRecallLevelState(levelId) then
          -- print("self.prop.itemId===================================",self.prop.itemId)
          -- 临时魔力扫把特殊处理
          if self.itemId == 10057 then
              self.isOnceUsed = true
              DcUtil:UserTrack({category = "recall", sub_category = "use_molisaoba"})
          elseif self.itemId == 10010 then --10026
              DcUtil:UserTrack({category = "recall", sub_category = "use_xiaomuchui"}) 
          elseif self.itemId == 10005 then --10027
              DcUtil:UserTrack({category = "recall", sub_category = "use_mofabang"}) 
          end 
      end
      self:updateTemporaryItemNumber(itemId, -1)

      return true
  else
    if self:getTimePropNum() > 0 then
      self:useTimeProp()
    else
      self.itemNum = self.itemNum - 1
      if self.itemNum < 0 then self.itemNum = 0 end
    end
    self.usedTimes = self.usedTimes + 1
  end

  return false
end

function PropItemData:getPropType()
  local usePropType = nil
  if self:isTemporaryMode() then 
    usePropType = UsePropsType.TEMP
  elseif self:getTimePropNum() > 0 then
    usePropType = UsePropsType.EXPIRE
  else
    usePropType = UsePropsType.NORMAL
  end

  return usePropType
end


function PropItemData:isMaxUsed()

  local isTempProperty  = self:isTemporaryMode()
  local maxUsetime = self.maxUsetime or 0
  
  return maxUsetime > 0 and self.usedTimes >= maxUsetime and not isTempProperty
end

function PropItemData:setNumber(itemNum)
    self.itemNum = itemNum or 0
end

function PropItemData:addNumber(itemNum)
    self.itemNum = self.itemNum + (itemNum or 0)
end

function PropItemData:_isSpringItem()
    return self.itemId == kSpringPropItemID
end
