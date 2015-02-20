
DigScrollGroundState = class(BaseStableState)

function DigScrollGroundState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function DigScrollGroundState:create(context)
	local v = DigScrollGroundState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function DigScrollGroundState:onEnter()
	BaseStableState.onEnter(self)
	self.nextState = nil

	local function scrollComplete()
		self.nextState = self:getNextState()
		self.mainLogic:setNeedCheckFalling()
	end
	
	if self.mainLogic.theGamePlayType == GamePlayType.kDigMove
	or self.mainLogic.theGamePlayType == GamePlayType.kDigMoveEndless 
	or self.mainLogic.theGamePlayType == GamePlayType.kMaydayEndless
    or self.mainLogic.theGamePlayType == GamePlayType.kHalloween then
		local digNeedScroll = self.mainLogic.gameMode:checkScrollDigGround(scrollComplete)
		if not digNeedScroll then
			self.nextState = self:getNextState()
		else
			self.context.needLoopCheck = true
		end
	else
		self.nextState = self:getNextState()
	end
end

function DigScrollGroundState:getNextState()
	return nil
end

function DigScrollGroundState:onExit()
	BaseStableState.onExit(self)
	self.nextState = nil
end

function DigScrollGroundState:checkTransition()
	return self.nextState
end

function DigScrollGroundState:getClassName()
	return "DigScrollGroundState"
end

DigScrollGroundStateInLoop = class(DigScrollGroundState)
function DigScrollGroundStateInLoop:create(context)
    local v = DigScrollGroundStateInLoop.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function DigScrollGroundStateInLoop:getClassName()
	return "DigScrollGroundStateInLoop"
end

function DigScrollGroundStateInLoop:getNextState()
	-- return self.context.checkNeedLoopState
	return self.context.maydayBossCastingState
end