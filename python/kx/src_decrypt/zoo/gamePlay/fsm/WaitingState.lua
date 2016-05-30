require "zoo.gamePlay.fsm.GameState"

WaitingState = class(GameState)

function WaitingState:create(context)
	local v = WaitingState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	return v
end

function WaitingState:onEnter()
	print(">>>>>>>>>>>>>>>>>waiting state enter")
	self.nextState = nil

	GameExtandPlayLogic:onEnterWaitingState(self.mainLogic)
	GameExtandPlayLogic:halloweenTutorial(self.mainLogic)
	if self.mainLogic.gameMode:reachEndCondition() then
		self.mainLogic:setGamePlayStatus(GamePlayStatus.kEnd)
	else
		self.mainLogic:startWaitingOperation()
	end

	if self.mainLogic.replaying then
		self.mainLogic:Replay()
	end
end

function WaitingState:onExit()
	print("<<<<<<<<<<<<<<<<<waiting state exit")
	self.mainLogic:stopWaitingOperation()
	self.nextState = nil
end

function WaitingState:update(dt)
end

function WaitingState:checkTransition()
	return self.nextState
end

function WaitingState:startSwapHandler()
	self.mainLogic:stopWaitingOperation()
	self.nextState = self.context.swapState
end