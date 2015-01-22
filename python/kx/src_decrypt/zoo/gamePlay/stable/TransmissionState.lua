TransmissionState = class(BaseStableState)

function TransmissionState:create( context )
	-- body
	local v = TransmissionState.new()
	v.context = context
	v.mainLogic = context.mainLogic  --gameboardlogic
	v.boardView = v.mainLogic.boardView
	return v
end

function TransmissionState:update( ... )
	-- body
end

function TransmissionState:onEnter()
	BaseStableState.onEnter(self)
	self.nextState = nil
	local function callback( ... )
		self:handleItemComplete();
	end

	self.hasItemToHandle = false
	self.completeItem = 0
	self.totalItem = GameExtandPlayLogic:checkTransmission(self.mainLogic, callback)
	if self.totalItem == 0 then
		self:handleItemComplete()
	else
		self.hasItemToHandle = true
	end
end

function TransmissionState:handleItemComplete( ... )
	self.completeItem = self.completeItem + 1 
	if self.completeItem >= self.totalItem then 
		
		self.nextState = self.context.blackCuteBallState
		
		if self.hasItemToHandle then
			self.mainLogic:setNeedCheckFalling()
		end
	end
end

function TransmissionState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
	self.completeItem = 0
	self.totalItem = 0
	self.hasItemToHandle = false
end

function TransmissionState:checkTransition()
	return self.nextState
end

function TransmissionState:getClassName()
	return "TransmissionState"
end