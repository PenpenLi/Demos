

-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月25日 16:53:37
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


---------------------------------------------------
-------------- HiddenBranch
---------------------------------------------------

assert(not HiddenBranchDirection)
HiddenBranchDirection = {
	LEFT	= 1,
	RIGHT	= 2
}

local function checkHiddenBranchDirection(dir)
	assert(dir)

	assert(dir == HiddenBranchDirection.LEFT or
		dir == HiddenBranchDirection.RIGHT)
end

------------------------------------------
-------- Event
---------------------------

assert(not HiddenBranchEvent)

HiddenBranchEvent = 
{
	OPEN_ANIM_FINISHED	= "HiddenBranchEvent.OPEN_ANIM_FINISHED"
}

HiddenBranch = class(Sprite)

function HiddenBranch:init(branchId, initialOpened, texture, ...)
	assert(branchId)
	assert(initialOpened ~= nil)
	assert(type(initialOpened) == "boolean")
	assert(#{...} == 0)

	self.resourceManager = ResourceManager:sharedInstance()

	-- --------------
	-- Init Base Class
	-- ----------------
	local sprite = CCSprite:create()
	self:setRefCocosObj(sprite)
	self.refCocosObj:setTexture(texture)
	
	-- -----------
	-- Get Data
	-- ------------
	self.metaModel = MetaModel:sharedInstance()
	self.branchDataList = self.metaModel:getHiddenBranchDataList()

	self.branchId = branchId

	-- Direction
	self.direction = false
	if tonumber(self.branchDataList[self.branchId].type) == 1 then
		self.direction = HiddenBranchDirection.RIGHT
	elseif tonumber(self.branchDataList[self.branchId].type) == 2 then
		self.direction = HiddenBranchDirection.LEFT
	else
		assert(false)
	end

	-- Position
	local curBranchData = self.branchDataList[self.branchId]
	assert(curBranchData)
	local posX = curBranchData.x
	local posY = curBranchData.y
	self:setPosition(ccp(posX, posY))

	-- ------------
	-- Update View
	-- -------------
	local branch = HiddenBranchAnimation:createStatic()
	self.branch = branch
	self:addChild(branch)

	if self.direction == HiddenBranchDirection.LEFT then
		branch:setScaleX(-1)
	end

	if not initialOpened then
		self.branch:setVisible(false)
	end
end


function HiddenBranch:getDirection(...)
	assert(#{...} == 0)

	return self.direction
end

function HiddenBranch:playOpenAnim(animLayer)
	local animBranch = nil 

	local function onAnimComplete()
		animBranch:removeFromParentAndCleanup(true)
		self.branch:setVisible(true)
		self:dp(Event.new(HiddenBranchEvent.OPEN_ANIM_FINISHED, self.branchId, self))
	end

	local manualAdjustX = 0
	local manualAdjustY = 0

	animBranch = HiddenBranchAnimation:createAnim(onAnimComplete)
	animBranch:setPosition(ccp(self:getPositionX() + manualAdjustX, self:getPositionY() + manualAdjustY))

	animLayer:addChild(animBranch)
	
	if self.direction == HiddenBranchDirection.LEFT then
		animBranch:setScaleX(-1)
	end
end

function HiddenBranch:create(branchId, initialOpened, texture, ...)
	assert(branchId)
	assert(initialOpened ~= nil)
	assert(type(initialOpened) == "boolean")
	assert(#{...} == 0)

	local newHiddenBranch = HiddenBranch.new()
	newHiddenBranch:init(branchId, initialOpened, texture)
	return newHiddenBranch
end
