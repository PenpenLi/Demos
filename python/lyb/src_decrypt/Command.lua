--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

require "core.utils.class";

Command=class(Object);

function Command:ctor()
	self.class=Command;
end

function Command:execute(notification)
	
end

function Command:cutDown(notification)
	Facade.getInstance():cutDown(notification);
end

function Command:hasCommand(notification_name_string, command_class)
	return Facade.getInstance():hasCommand(notification_name_string,command_class);
end

function Command:hasMediator(mediator_name_string)
	return Facade.getInstance():hasMediator(mediator_name_string);
end

function Command:hasProxy(proxy_name_string)
	return Facade.getInstance():hasProxy(proxy_name_string);
end

function Command:observe(command_class)
	Facade.getInstance():observe(command_class);
end

function Command:registerCommand(notification_name_string, command_class)
	Facade.getInstance():registerCommand(notification_name_string, command_class);
end

function Command:registerMediator(mediator_name_string, mediator)
	Facade.getInstance():registerMediator(mediator_name_string, mediator);
end

function Command:registerProxy(proxy_name_string, proxy)
	Facade.getInstance():registerProxy(proxy_name_string, proxy);
end

function Command:removeCommand(notification_name_string, command_class)
	Facade.getInstance():removeCommand(notification_name_string, command_class);
end

function Command:removeMediator(mediator_name_string)
	Facade.getInstance():removeMediator(mediator_name_string);
end

function Command:removeProxy(proxy_name_string)
	Facade.getInstance():removeProxy(proxy_name_string);
end

function Command:retrieveMediator(mediator_name_string)
	return Facade.getInstance():retrieveMediator(mediator_name_string);
end

function Command:retrieveProxy(proxy_name_string)
	return Facade.getInstance():retrieveProxy(proxy_name_string);
end

function Command:unobserve(command_class)
	Facade.getInstance():unobserve(command_class);
end