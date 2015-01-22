TileBlockerState = class(BaseStableState)
function TileBlockerState:create( context )
	-- body
	local v = TileBlockerState.new()
	v.context = context
	v.mainLogic = context.mainLogic  --gameboardlogic
	v.boardView = v.mainLogic.boardView
	return v
end

function TileBlockerState:update( ... )
	-- body
end

function TileBlockerState:onEnter()
	BaseStableState.onEnter(self)
	self.nextState = nil
	local function callback( ... )
		-- body
		self:handleComplete();
	end

	self.hasItemToHandle = false
	self.complete = 0
	self.total = GameExtandPlayLogic:CheckTileBlockerList(self.mainLogic, callback)
	if self.total == 0 then
		self:handleComplete()
	else
		self.hasItemToHandle = true
	end
end

function TileBlockerState:handleComplete( ... )
	-- body
	self.complete = self.complete + 1 
	if self.complete >= self.total then 
		self.nextState = self.context.productRabbitState
		if self.hasItemToHandle then
			self.mainLogic:setNeedCheckFalling();
		end
	end
end

function TileBlockerState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
	self.complete = 0
	self.total = 0
	self.hasItemToHandle = false
end

function TileBlockerState:checkTransition()
	return self.nextState
end

function TileBlockerState:getClassName()
	return "TileBlockerState"
end