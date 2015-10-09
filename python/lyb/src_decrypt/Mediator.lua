--

Mediator=class(Object);

function Mediator:ctor()
	self.class=Mediator;
	self.viewComponent=nil;
end

rawset(Mediator,"name","Mediator");

function Mediator:getMediatorName()
		return self.class.name;
end

function Mediator:getViewComponent()
	return self.viewComponent;
end

function Mediator:onRegister()
	
end

function Mediator:onRemove()
	
end

function Mediator:onReconnect()

end

function Mediator:sendNotification(notification)
	Facade.getInstance():sendNotification(notification);
end