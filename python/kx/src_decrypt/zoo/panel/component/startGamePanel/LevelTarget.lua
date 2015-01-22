
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年11月14日 15:14:14
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- LevelTarget
---------------------------------------------------

assert(not LevelTarget)
assert(BaseUI)
LevelTarget = class(BaseUI)

function LevelTarget:init(gameModeName, orderList, ...)
	assert(type(gameModeName) == "string")
	assert(#{...} == 0)

	if gameModeName == "Order" then
		assert(orderList)
	end

	-------------------
	-- Get Data
	-- -----------------
	local numberOfTarget = false
	local targetResNames = {}

	if gameModeName == "Order" or gameModeName == 'seaOrder' then
		for k,v in pairs(orderList) do
				local resName = "target.order" .. v.k
				table.insert(targetResNames, resName)
		end

	elseif gameModeName == "Light up" then
		table.insert(targetResNames, "target.ice")
	elseif gameModeName == "Drop down" then
		table.insert(targetResNames, "target.drop")
	elseif gameModeName == "Classic" then
		table.insert(targetResNames, "target.time")
	elseif gameModeName == "Classic moves" then
		table.insert(targetResNames, "target.score")
	elseif gameModeName == "DigMoveEndless" then
		table.insert(targetResNames, "target.score")
	elseif gameModeName == "DigMove" then
		table.insert(targetResNames, "target.dig_move")
	else
		assert(false)
	end

	print(table.tostring(targetResNames))

	numberOfTarget = #targetResNames

	------------------
	-- Create UI Component
	-- -------------------
	local resName = tostring(numberOfTarget) .. "Target"
	self.ui = ResourceManager:sharedInstance():buildGroup(resName)

	-----------------
	-- Init Base Class
	-- -----------------
	BaseUI.init(self, self.ui)

	----------------
	-- Get UI
	-- ----------------
	local targetContainer	= {}
	local placeholderSizes	= {}

	for index = 1,numberOfTarget do
		local target = self.ui:getChildByName("target" .. tostring(index))
		assert(target)
		table.insert(targetContainer, target)

		local placeholder = target:getChildByName("placeholder")
		assert(placeholder)
		local placeholderSize = placeholder:getGroupBounds().size
		table.insert(placeholderSizes, placeholderSize)
		placeholder:setVisible(false)
	end

	---------------------
	-- Init UI Component
	-- ------------------
	for index = 1, #targetResNames do
		local sprite = Sprite:createWithSpriteFrameName(targetResNames[index] .." instance 10000")
		sprite:setAnchorPoint(ccp(0,1))
		targetContainer[index]:addChild(sprite)

		local deltaScale = 0.65
		sprite:setScaleX(deltaScale)
		sprite:setScaleY(deltaScale)

		local placeholderSize	= placeholderSizes[index]
		local spriteSize	= sprite:getGroupBounds().size

		local deltaWidth	= -spriteSize.width + placeholderSize.width
		local deltaHeight	= -spriteSize.height + placeholderSize.height

		local halfDeltaWidth	= deltaWidth / 2
		local halfDeltaHeight	= deltaHeight / 2

		sprite:setPosition(ccp(halfDeltaWidth, -halfDeltaHeight))
		--sprite:setAnchorPointCenterWhileStayOrigianlPosition()

	end
end

function LevelTarget:create(gameModeName, orderList, ...)
	assert(type(gameModeName) == "string")
	assert(#{...} == 0)

	local newLevelTarget = LevelTarget.new()
	newLevelTarget:init(gameModeName, orderList)
	return newLevelTarget
end
