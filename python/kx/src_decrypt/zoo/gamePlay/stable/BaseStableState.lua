
BaseStableState = class()

function BaseStableState:ctor()
	
end

function BaseStableState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function BaseStableState:create(context)
	local v = BaseStableState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function BaseStableState:update(dt)
	
end

function BaseStableState:onEnter()
	print("---------->>>>>>>>>> " .. self:getClassName() .. " state enter")
end

function BaseStableState:onExit()
	print("----------<<<<<<<<<< " .. self:getClassName() .. " state exit")
end

function BaseStableState:getClassName( ... )
	asset(false)
	return "BaseStableState"
end

function BaseStableState:checkTransition()
	
end
