
HomeScenePopoutAction = class()

function HomeScenePopoutAction:ctor( ... )
	self.isPlaceholder = false
end

function HomeScenePopoutAction:popout( ... )
end

function HomeScenePopoutAction:placeholder( ... )
	self.hasPopout = false
	self.isPlaceholder = true	
	return self
end

function HomeScenePopoutAction:fixed( ... )
	self.isFixed = true
	return self	
end

function HomeScenePopoutAction:next( ... )
	HomeScenePopoutQueue:next(self)
end

function HomeScenePopoutAction:getConditions( ... )
	return {"enter","enterForground","preActionNext"}
end