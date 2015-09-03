
ButtonsBarEventDispatcher = class(EventDispatcher)

ButtonsBarEvents = {
	kClose = "kClose",
}

function ButtonsBarEventDispatcher:ctor()
	
end

function ButtonsBarEventDispatcher:dispatchCloseEvent()
	self:dispatchEvent(Event.new(ButtonsBarEvents.kClose, {}, self))
end