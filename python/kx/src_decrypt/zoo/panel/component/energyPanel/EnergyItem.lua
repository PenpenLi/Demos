

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月17日 15:08:01
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.common.ItemType"
require "zoo.panel.component.common.BubbleItem"

---------------------------------------------------
-------------- EnergyItem
---------------------------------------------------

assert(not EnergyItem)
--assert(BaseUI)
assert(BubbleItem)
--EnergyItem = class(BaseUI)
EnergyItem = class(BubbleItem)

function EnergyItem:init(ui, itemType, animLayer, flyToPosInAnimLayer, ...)
	assert(ui)
	assert(itemType)
	assert(animLayer)
	assert(flyToPosInAnimLayer)
	assert(#{...} == 0)

	self.ui	= ui

	-- ---------------
	-- Init Base Class
	-- ----------------
	--BaseUI.init(self, self.ui)
	BubbleItem.init(self, self.ui, itemType)

	-- ----------
	-- Data
	-- -----------
	self.itemType			= itemType
	self.animLayer			= animLayer
	self.flyToPosInAnimLayer	= flyToPosInAnimLayer
	self.flyingTime			= 0.5

	--------------
	--- Play Bubble Anim
	-------------------
	self:playBubbleNormalAnim(true)
end

function EnergyItem:getEnergyPointToAdd(...)
	assert(#{...} == 0)

	local itemType = self.itemType

	if itemType == ItemType.SMALL_ENERGY_BOTTLE then
		return 1
	elseif itemType == ItemType.MIDDLE_ENERGY_BOTTLE then
		return 5
	elseif itemType == ItemType.LARGE_ENERGY_BOTTLE then
		return 30
	else
		assert(false)
	end
end

function EnergyItem:playFlyingEnergyAnimation(animFinishCallback, ...)
	assert(type(animFinishCallback) == "function")
	assert(#{...} == 0)

	------ Convert Parent Position To Play Anim Layer
	--local position = animLayer:convertToNodeSpace(ccp(self.flyToPosInWorldSpace.x, self.flyToPosInWorldSpace.y))

	-- -------------------------------------------
	-- Convert Self Center Pos To Play Anim Layer
	-- ---------------------------------------------
	
	-- Convert To Wrold Space
	local selfCenterInWorld = self:convertToWorldSpace(ccp(self.centerX, self.centerY))

	-- Convert To Anim Layer
	local selfCenterInAnimLayer = self.animLayer:convertToNodeSpace(ccp(selfCenterInWorld.x, selfCenterInWorld.y))

	-- Create New Energy Icon
	local newEnergyIcon	= ResourceManager:sharedInstance():buildItemGroup(ItemType.ENERGY_LIGHTNING)
	newEnergyIcon:setPosition(ccp(selfCenterInAnimLayer.x, selfCenterInAnimLayer.y))
	self.animLayer:addChild(newEnergyIcon)

	-- Move To Action
	local moveTo	= CCMoveTo:create(self.flyingTime, ccp(self.flyToPosInAnimLayer.x, self.flyToPosInAnimLayer.y))

	-- Finish Callback
	local function finish()
		newEnergyIcon:removeFromParentAndCleanup(true)
		animFinishCallback()
	end
	local callFunc	= CCCallFunc:create(finish)

	-- Sequence
	local actionArray	= CCArray:create()
	actionArray:addObject(moveTo)
	actionArray:addObject(callFunc)

	local sequence	= CCSequence:create(actionArray)

	newEnergyIcon:runAction(sequence)
end

function EnergyItem:create(ui, itemType, animLayer, flyToPosInAnimLayer, ...)
	assert(ui)
	assert(itemType)
	assert(animLayer)
	assert(flyToPosInAnimLayer)

	assert(#{...} == 0)

	local newEnergyItem = EnergyItem.new()
	newEnergyItem:init(ui, itemType, animLayer, flyToPosInAnimLayer)
	return newEnergyItem
end
