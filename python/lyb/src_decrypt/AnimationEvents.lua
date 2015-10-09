require "core.utils.class";

AnimationEvents = {
	kMovementChange = "movementChange", -- Dispatched when the movement of animation is changed.
	kAnimationStart = "animationStart", -- Dispatched when the playback of a animation starts.
	kMovementComplete = "movementComplete", -- Dispatched when the playback of a movement stops.
	kMovementLoopComplete = "movementLoopComplete", --Dispatched when the playback of a movement completes a loop.
};

AnimationEvent = class(Event);

function AnimationEvent:ctor(name, target)
	self.class = AnimationEvent;

	self.name  = name;
	self.data = nil;
	self.target = target;
	self.armature = target; --The armature that is the subject of this event.

	self.movementID = nil;
	self.exMovementID = nil;
end

function AnimationEvent:dispose()
	self.name = nil;
	self.target = nil;
	self.armature = nil;
	self.movementID = nil;
	self.exMovementID = nil;
	self:removeSelf();
end

function AnimationEvent:toString()
	return string.format("AnimationEvent [%s]", self.name and self.name or "nil");
end

function AnimationEvent:clone()
	local event = AnimationEvent.new(self.name, self.target);
	event.movementID = self.movementID;
	event.exMovementID = self.exMovementID;
	return event;
end
