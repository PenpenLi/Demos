
FurballTransferState = class(BaseStableState)

function FurballTransferState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function FurballTransferState:create(context)
	local v = FurballTransferState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function FurballTransferState:onEnter()
	BaseStableState.onEnter(self)
	local context = self
	local function transferCallback()
		context:handleFurballTransferInStepComplete()
	end

	self.nextState = nil
	self.counterFurballTransferToHandle = 0
	self.totalFurballTransferToHandle = GameExtandPlayLogic:checkFurballTransfer(self.mainLogic, transferCallback)
	if self.totalFurballTransferToHandle == 0 then
		self.nextState = self:getNextState()
	end
end

function FurballTransferState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
	self.totalFurballTransferToHandle = 0
	self.counterFurballTransferToHandle = 0
end

function FurballTransferState:handleFurballTransferInStepComplete()
	self.counterFurballTransferToHandle = self.counterFurballTransferToHandle + 1
	if self.counterFurballTransferToHandle >= self.totalFurballTransferToHandle then
		print("-----------------------------furball transfer complete")
		local result = ItemHalfStableCheckLogic:checkAllMapWithNoMove(self.mainLogic)
		self.nextState = self:getNextState()
		if result then
			self.mainLogic:setNeedCheckFalling()
		else
			self.context:onEnter()
		end
	end
end

function FurballTransferState:getNextState()
	return self.context.maydayBossJumpState
end

function FurballTransferState:checkTransition()
	return self.nextState
end

function FurballTransferState:getClassName()
	return "FurballTransferState"
end