BalloonCheckState = class(BaseStableState)

function BalloonCheckState:create( context )
	-- body
	local v = BalloonCheckState.new()
	v.context = context
	v.mainLogic = context.mainLogic  --gameboardlogic
	v.boardView = v.mainLogic.boardView
	return v
end

function BalloonCheckState:onEnter()
	BaseStableState.onEnter(self)
	self.nextState = nil
	local function callback( ... )
		-- body
		self:handleBalloonComplete();
	end

	self.hasItemToHandle = false
	self.completeBalloon = 0
	self.totalBalloon = GameExtandPlayLogic:CheckBalloonList(self.mainLogic, callback)
	if self.totalBalloon == 0 then
		self:handleBalloonComplete()
	else
		self.hasItemToHandle = true
	end
end

function BalloonCheckState:handleBalloonComplete( ... )
	self.completeBalloon = self.completeBalloon + 1 
	if self.completeBalloon >= self.totalBalloon then 
		
		self.nextState = self.context.transmissionState
		
		if self.hasItemToHandle then
			self.mainLogic:setNeedCheckFalling()
		end
	end
end

function BalloonCheckState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
	self.completeBalloon = 0
	self.totalBalloon = 0
	self.hasItemToHandle = false
end

function BalloonCheckState:checkTransition()
	return self.nextState
end

function BalloonCheckState:getClassName()
	return "BalloonCheckState"
end