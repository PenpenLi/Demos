require "zoo.gamePlay.levelTarget.LevelTargetAnimationOrder"
-----------------------------------------
--class LevelTargetAnimationOtherMode
-----------------------------------------

LevelTargetAnimationOtherMode = class(LevelTargetAnimationOrder)
function LevelTargetAnimationOtherMode:getTargetTypeBySelectItem(selectedItem)
	-- body
	return selectedItem.type
end
------------------------------------
--class LevelTargetAnimationDrop
------------------------------------
LevelTargetAnimationDrop = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationDrop:getIconFullName( itemType, id )
	-- body
	return "target."..itemType
end

function LevelTargetAnimationDrop:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
end

function LevelTargetAnimationDrop:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	self.c1:revertTargetNumber(itemId, itemNum)
end

------------------------------------
--class LevelTargetAnimationIce
------------------------------------
LevelTargetAnimationIce = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationIce:getIconFullName( itemType, id )
	-- body
	return "target."..itemType
end

------------------------------------
--class LevelTargetAnimationSeaOrder
------------------------------------
LevelTargetAnimationSeaOrder = class(LevelTargetAnimationOrder)
function LevelTargetAnimationSeaOrder:initGameModeTargets( ... )
	-- body
	for i=1, 4 do
  		self["c"..i] = TargetItemFactory.create(SeaOrderTargetItem, self.levelTarget:getChildByName("c"..i), i, self)
  	end
  	self:updateTargets()
end

------------------------------------------------
--class LevelTargetAnimationDigMoveEndless
------------------------------------------------
LevelTargetAnimationDigMoveEndless = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationDigMoveEndless:getIconFullName( itemType, id )
	-- body
	return "target."..itemType
end

function LevelTargetAnimationDigMoveEndless:initGameModeTargets( ... )
	-- body
	self:createTargets(2,4) 
    self.c1 = TargetItemFactory.create(EndlessTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateTargets()
end

function LevelTargetAnimationDigMoveEndless:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
end

function LevelTargetAnimationDigMoveEndless:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	self.c1:revertTargetNumber(itemId, itemNum)
end

------------------------------------------------
--class LevelTargetAnimationDigMoveEndlessQixi
------------------------------------------------
LevelTargetAnimationDigMoveEndlessQixi = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationDigMoveEndlessQixi:getIconFullName( itemType, id )
	-- body
	return "target."..itemType
end

------------------------------------------------
--class LevelTargetAnimationDigMove
------------------------------------------------
LevelTargetAnimationDigMove = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationDigMove:getIconFullName( itemType, id )
	-- body
	return "target."..itemType
end

function LevelTargetAnimationDigMove:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
end

function LevelTargetAnimationDigMove:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	self.c1:revertTargetNumber(itemId, itemNum)
end

------------------------------------------------
--class LevelTargetAnimationMaydayEndless
------------------------------------------------
LevelTargetAnimationMaydayEndless = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationMaydayEndless:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	if itemId == 2 then
		self.c2:setTargetNumber(itemId, itemNum, animate, globalPosition)
	else
		self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
	end
end

function LevelTargetAnimationMaydayEndless:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	if itemId == 0 then
		self.c1:revertTargetNumber( itemId, itemNum)
	elseif itemId == 2 then 
		self.c2:revertTargetNumber(itemId, itemNum)
	end
end

function LevelTargetAnimationMaydayEndless:initGameModeTargets( ... )
	-- body
	self:createTargets(2,4)  
    self.c1 = TargetItemFactory.create(EndlessMayDayTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateTargets()
end

------------------------------------------------
--class LevelTargetAnimationHalloween
------------------------------------------------
LevelTargetAnimationHalloween = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationHalloween:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	if itemId == 2 then
		self.c2:setTargetNumber(itemId, itemNum, animate, globalPosition)
	else
		self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
	end
end

function LevelTargetAnimationHalloween:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	if itemId == 0 then
		self.c1:revertTargetNumber( itemId, itemNum)
	elseif itemId == 2 then 
		self.c2:revertTargetNumber(itemId, itemNum)
	end
end

function LevelTargetAnimationHalloween:initGameModeTargets( ... )
	-- body
	self:createTargets(2,4)  
    self.c1 = TargetItemFactory.create(HalloweenTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateTargets()
end




LevelTargetAnimationWukongEndless = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationWukongEndless:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	if itemId == 2 then
		self.c2:setTargetNumber(itemId, itemNum, animate, globalPosition)
	else
		self.c1:setTargetNumber(itemId, itemNum, animate, globalPosition)
	end
end

function LevelTargetAnimationWukongEndless:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	if itemId == 0 then
		self.c1:revertTargetNumber( itemId, itemNum)
	elseif itemId == 2 then 
		self.c2:revertTargetNumber(itemId, itemNum)
	end
end

function LevelTargetAnimationWukongEndless:initGameModeTargets( ... )
	-- body
	self:createTargets(2,4)  
    self.c1 = TargetItemFactory.create(EndlessMayDayTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateTargets()
end



------------------------------------------------
--class LevelTargetAnimationHedgehogEndless
------------------------------------------------
LevelTargetAnimationHedgehogEndless = class(LevelTargetAnimationOrder)
function LevelTargetAnimationHedgehogEndless:initGameModeTargets( ... )
	-- body
	self:createTargets(3,4)
    self.c1 = TargetItemFactory.create(FillTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
	self.c2 = TargetItemFactory.create(EndlessTargetItem, self.levelTarget:getChildByName("c2"), 2, self)
	self:updateTargets()
end

function LevelTargetAnimationHedgehogEndless:getTargetTypeBySelectItem( selectedItem )
	-- body
	return kLevelTargetType.hedgehog_endless
end


LevelTargetAnimationLotus = class(LevelTargetAnimationOtherMode)
function LevelTargetAnimationLotus:setTargetNumber( itemType, itemId, itemNum, animate, globalPosition, rotation, percent )
	-- body
	if globalPosition and globalPosition.x == 0 and globalPosition.y == 0 then
		globalPosition = nil
	end
	self.c1:setTargetNumber(itemId, itemNum , animate, globalPosition)
end

function LevelTargetAnimationLotus:revertTargetNumber( itemType, itemId, itemNum )
	-- body
	self.c1:revertTargetNumber( itemId, itemNum)
end

function LevelTargetAnimationLotus:initGameModeTargets( ... )
	-- body
	self:createTargets(1,4)  
    --self.c1 = TargetItemFactory.create(EndlessMayDayTargetItem, self.levelTarget:getChildByName("c1"), 1, self)
    self:updateTargets()
end







