-------------------------------------------------------------------------
--  Class include: MovementData, MovementFrameData, MovementBoneData
-------------------------------------------------------------------------


require "core.skeleton.Nodes"
--
-- MovementData ---------------------------------------------------------
--

-- initialize
MovementData = class(Object);
function MovementData:ctor()
	self.movementBoneData = {}; -- of <MovementBoneData>
	self.movementFrameList = {}; -- of <MovementFrameData>
	self.name = nil;
	self.duration = 1;
	self.durationTo = 0;
	self.durationTween = 0;
	self.tweenEasing = nil; -- number, but nil by defaullt
	self.loop = false;

	self.class = MovementData;
end

function MovementData:toString()
	return string.format("MovementData[%s, %.2f, %.2f]",
	self.name and self.name or "nil", self.duration, self.durationTo);
end

function MovementData:dispose()

	for k,v in pairs(self.movementBoneData) do
		v:dispose();
	end

	self.movementBoneData = nil;
	self.movementFrameList = nil;
	self.name = nil;
	self:removeSelf();

end

-- public methods
function MovementData:dump()
	print("\ndump MovementData", self:toString());
	for k, v in pairs(self.movementBoneData) do
		print("MovementData", k, v);
	end
end

function MovementData:setValues(duration, durationTo, durationTween, loop, tweenEasing)
	local d = duration or 1;
	local dt = durationTo or 0;
	local dw = durationTween or 0;

	if d > 0 then
		self.duration = d;
	else
		self.duration = 1;
	end

	if dt > 0 then
		self.durationTo = dt;
	else
		self.durationTo = 0;
	end

	if dw > 0 then
		self.durationTween = dw;
	else
		self.durationTween = 0;
	end

	self.loop = loop or false;
	self.tweenEasing = tweenEasing or nil;
end

function MovementData:getMovementBoneData(name)
	if self.movementBoneData then
		return self.movementBoneData[name];
	end

	return nil;
end

function MovementData:addMovementBoneData(data)
	if data and self.movementBoneData then
		local n = data.name;
		self.movementBoneData[n] = data;
	end
end


--
-- MovementFrameData ---------------------------------------------------------
--

-- initialize
MovementFrameData = class(Object);
function MovementFrameData:ctor()
	self.start = 0;
	self.duration = 0;
	self.movement = nil;
	self.event = nil;

	self.class = MovementFrameData;
end
function MovementFrameData:toString()
	return string.format("MovementFrameData[%s, %s, %.2f, %.2f]",
	self.movement and self.movement or "nil",
	self.event and self.event or "nil",
	self.start, self.duration);
end
function MovementFrameData:dispose()
	self.movement = nil;
	self.event = nil;
	self:removeSelf();
end

-- public methods
function MovementFrameData:setValues(start, duration, movement, event)
	self.start = start or 0;
	self.duration = duration or 0;
	self.movement = movement;
	self.event = event;
end


--
-- MovementBoneData ---------------------------------------------------------
--

-- initialize
MovementBoneData = class(Object);
function MovementBoneData:ctor()
	self.frameList = {}; -- of <FrameData>
	self.duration = 0;
	self.name = nil;
	self.scale = 1;
	self.delay = 0;

	self.class = MovementBoneData;
end

function MovementBoneData:toString()
	return string.format("MovementBoneData[name=%s, duration=%.2f, scale=%.2f, delay=%.2f]",
	self.name and self.name or "nil", self.duration, self.scale, self.delay);
end

function MovementBoneData:dispose()
	self.frameList = nil;
	self.name = nil;
	self:removeSelf();
end

-- public methods
function MovementBoneData:dump()
	print("\ndump MovementBoneData", self:toString());
	for k, v in pairs(self.frameList) do
		print("--", k, v:toString());
	end
end

function MovementBoneData:setValues(scale, delay)
	local s = scale or 1; -- 1 by default;
	local d = delay or 0; -- 0 by default;

	if s > 0 then
		self.scale = s;
	else
		self.scale = 1;
	end
	
    self.delay = d;
--[[
	self.delay = d % 1;
	if self.delay > 0 then
		self.delay = self.delay - 1;
	end;
	]]
end

