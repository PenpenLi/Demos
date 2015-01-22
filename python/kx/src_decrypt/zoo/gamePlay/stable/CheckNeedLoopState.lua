
CheckNeedLoopState = class(BaseStableState)

function CheckNeedLoopState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function CheckNeedLoopState:create(context)
	local v = CheckNeedLoopState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function CheckNeedLoopState:onEnter()
	BaseStableState.onEnter(self)

	if self.context.needLoopCheck then
		self.context.needLoopCheck = false
		self.nextState = self.context.roostReplaceStateInLoop
		print("----------------------------- need loop once, skip refresh check")
	else
		self.nextState = self.context.productSnailState
	end
end

function CheckNeedLoopState:onExit()
	BaseStableState.onExit(self)

	self.nextState = nil
end

function CheckNeedLoopState:checkTransition()
	return self.nextState
end

function CheckNeedLoopState:getClassName()
	return "CheckNeedLoopState"
end

