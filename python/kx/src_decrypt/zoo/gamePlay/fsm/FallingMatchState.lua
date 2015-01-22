require "zoo.gamePlay.fsm.GameState"
require "zoo.gamePlay.stable.StableStateMachine"

FallingMatchState = class(GameState)

function FallingMatchState:create(context)
	local v = FallingMatchState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = context.mainLogic.boardView

	local stableFSM = StableStateMachine:create(v)
	v.stableFSM = stableFSM
	return v
end

function FallingMatchState:dispose()
	v.mainLogic = nil
	v.boardView = nil
	v.context = nil

	v.stableFSM:dispose()
	v.stableFSM = nil
end

function FallingMatchState:update(dt)
	self.mainLogic:fallingMatchUpdate(dt)
	self.stableFSM:update(dt)
end

function FallingMatchState:onEnter()
	print(">>>>>>>>>>>>>>>>>falling state enter")
	self.nextState = nil
end

function FallingMatchState:onExit()
	print("<<<<<<<<<<<<<<<<<falling state exit")
	self.nextState = nil
end

function FallingMatchState:afterRefreshStable(isEnterWaiting)
	if isEnterWaiting then
		self.nextState = self.context.waitingState
	end
	self.stableFSM:onExit()
end

function FallingMatchState:boardStableHandler()
	self.stableFSM:onEnter(true)
end

function FallingMatchState:checkTransition()
	return self.nextState
end