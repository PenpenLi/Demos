require "core.utils.class";

FrameEvents = {
	kMovementFrameEvent = "movementFrameEvent", -- Dispatched when the animation of the armatrue enter a frame.
	kBoneFrameEvent = "boneFrameEvent", -- Dispatched when a bone of the armatrue enter a frame.
};

FrameEvent = class(Event);

function FrameEvent:ctor(name, target)
	self.class = FrameEvent;

	self.name  = name;
	self.data = nil;
	self.target = target;
	self.armature = target; --The armature that is the subject of this event.

	self.movementID = nil;
	self.frameLabel = nil;
	self.bone = nil; --The bone that is the subject of this event.
end

function FrameEvent:dispose()
	self.data = nil;
	self.name = nil;
	self.target = nil;
	self.armature = nil;

	self.movementID = nil;
	self.frameLabel = nil;
	self.bone = nil;
	self:removeSelf();
end

function FrameEvent:toString()
	return string.format("FrameEvent [%s]", self.name and self.name or "nil");
end

function FrameEvent:clone()
	local evt = FrameEvent.new(self.name, self.target);
	evt.movementID = self.movementID;
	evt.frameLabel = self.frameLabel;
	evt.bone = self.bone;
	return evt;
end
