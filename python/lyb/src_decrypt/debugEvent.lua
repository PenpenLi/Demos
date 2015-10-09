-------------------------------------------------------------------------
--  Class include: Event, EventDispatcher
-------------------------------------------------------------------------


require "core.utils.class";

local debugEvent =false;

--
-- Event ---------------------------------------------------------
--

-- common event name we used in library.
Events = {
	kComplete = "complete",
	kCancel = "cancel",
	kConnect = "connect",
	kConfirm = "confirm",
	kError = "error",
	kStart = "start",
	kClose = "close"
};

Event = class();
function Event:ctor(name, data, target)
	self.class = Event;

	self.name  = name;
	self.data = data;
	self.target = target;
	self.code = 0;
	self.context = nil;
end
function Event:dispose()
	self.name = nil;
	self.target = nil;
	self.data = nil;
	self.context = nil;
	self:removeSelf();
end
function Event:toString()
	return string.format("Event [%s]", self.name and self.name or "nil");
end

--
-- EventDispatcher ---------------------------------------------------------
--

-- members
EventDispatcher = class();

-- initialize
function EventDispatcher:ctor()
	self.class = EventDispatcher;
	self.receivers  = {}; -- of <{function,function...}>
end

function EventDispatcher:removeSelf()
	self.class = nil;
end

function EventDispatcher:dispose()
    self:cleanSelf();
end

-- public methods
function EventDispatcher:is(compareClass)
	if not compareClass then
		return false
	end

	local rawClass = self.class;
	while rawClass do
		if rawClass == compareClass then
			return true;
		end
		rawClass = rawClass.super;
	end

	return false;
end

function EventDispatcher:toString()
	return "EventDispatcher";
end

function EventDispatcher:dispatchEvent(event)
	if debugEvent then
		print("EventDispatcher:dispatchEvent", event.name, event.data, event.target);
	end
	local eventName = event.name;
	if not eventName then return end;

	local list = self.receivers[eventName]; --of <function>

	if (not list) or type(list) ~= "table" then return end;

	-- by default, iterator throw a table is a non-atom operation,
	-- to avoid modify table while iteration (by callback), we need a atom-table or just clone the old one as I did.
	local cached = {};
	for k, v in ipairs(list) do
		cached[k] = v;
	end

	for k, v in ipairs(cached) do
	    event.context = nil;
	    if v[2] then
        event.context = v[2];
        v[1](event.context,event,v[3]);
      else
        v[1](event);
      end;
		
		 event.context = nil;
	end
end

function EventDispatcher:hasEventListener(eventName, listener)
	if not eventName then
		return false;
	end

	if self.receivers then
		local list = self.receivers[eventName]; --of <function>
		if not list then return false end;

		for i, v in ipairs(list) do
			if v[1] == listener then return true, i end;
		end
	end

	return false;
end


function EventDispatcher:hasEventListenerByName(eventName)
	if not eventName then
		return false;
	end

	if self.receivers then
		local list = self.receivers[eventName]; --of <function>
		if list and table.getn(list) > 0 then
			return true;
		end
	end

	return false;
end

function EventDispatcher:addEventListener(eventName, listener, context, data)
	if debugEvent then
		print("EventDispatcher:addEventListener", eventName, listener);
	end

	if (not eventName) or (not listener) or (not self.receivers) then return end;

	local bool = self:hasEventListener(eventName, listener);
	if bool then
		if debugEvent then
			print("EventDispatcher:addEventListener event already add");
		end
	else
		local list = self.receivers[eventName]; --of <function>
		if (not list) or type(list) ~= "table" then
			list = {};
			self.receivers[eventName] = list;
		end
    if nil ~= data then   
      table.insert(list, {listener, context, data});
    else
      table.insert(list, {listener, context});
    end
	end
end

function EventDispatcher:removeEventListener(eventName, listener)
	if debugEvent then
		print("EventDispatcher:removeEventListener", eventName, listener);
	end

	if (not eventName) or (not listener) or (not self.receivers) then return end;
	local bool, i = self:hasEventListener(eventName, listener);
	if bool then
		local list = self.receivers[eventName]; --of <function>
		table.remove(list, i);
	end
end

function EventDispatcher:removeEventListenerByName(eventName)
	if debugEvent then
		print("EventDispatcher:removeEventListenerByName", eventName);
	end
	if (not eventName) or (not self.receivers) then return end;
	self.receivers[eventName] = nil;
end

function EventDispatcher:removeAllEventListeners()
	local list = self.receivers;
	for k, v in pairs(list) do
		self.receivers[k] = nil;
	end
end
