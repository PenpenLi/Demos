require "core.utils.class";

DisplayEvents = {
-- touch
	kTouchBegin = "touchBegin",
	kTouchEnd = "touchEnd",
	kTouchMove = "touchMove",
	
	kTouchOut = "touchOut",
	kTouchOver = "touchOver",
	
	kTouchTap = "touchTap",
	
-- text
    kTextFieldInit = "initTextField";
};

DisplayEvent = class(Event);

function DisplayEvent:ctor(name, target, globalPosition)
	self.class = DisplayEvent;

	self.name  = name;
	self.data = nil;
	self.target = target;
	self.sprite = target; --The armature that is the subject of this event.
	local uiglobalPosition = ccp(globalPosition.x - GameData.uiOffsetX, globalPosition.y - GameData.uiOffsetY);
	self.metaglobalPosition = globalPosition;
	self.globalPosition = uiglobalPosition;
	self.propagation = true;
end

function DisplayEvent:dispose()
	self.data = nil;
	self.name = nil;
	self.target = nil;
	self.sprite = nil;

	self:removeSelf();
end

--Prevents processing of any event listeners in nodes subsequent to the current node in the event flow.
function DisplayEvent:stopPropagation()
    self.propagation = false;
end

function DisplayEvent:toString()
	return string.format("DisplayEvent [%s]", self.name and self.name or "nil");
end

function DisplayEvent:clone()
	local evt = DisplayEvent.new(self.name, self.target);
	return evt;
end
