--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

require "core.mvc.core.Controller";
require "core.mvc.core.Model";
require "core.mvc.core.View";
require "core.mvc.ext.ViewObserver";

Facade=class(Object);

function Facade:ctor()
	self.class=Facade;
	
	self.controller=Controller.new();
	self.model=Model.new();
	self.view=View.new();
	self.viewObserver=ViewObserver.new();
end

rawset(Facade,"instance",nil);
rawset(Facade,"getInstance",
	function()
		if Facade.instance then
	else
		rawset(Facade,"instance",Facade.new());
	end
	return Facade.instance;
	end);

function Facade:cutDown(notification)
	self.viewObserver:cutDown(notification);
end

function Facade:hasCommand(notification_name_string, command_class)
	return self.controller:hasCommand(notification_name_string,command_class);
end

function Facade:hasMediator(mediator_name_string)
	return self.view:hasMediator(mediator_name_string);
end

function Facade:hasProxy(proxy_name_string)
	return self.model:hasProxy(proxy_name_string);
end

function Facade:observe(command_class)
	self.viewObserver:observe(command_class);
end

function Facade:onReconnect()
	self.view:onReconnect();
end

function Facade:registerCommand(notification_name_string, command_class)
	self.controller:registerCommand(notification_name_string, command_class);
end

function Facade:registerMediator(mediator_name_string, mediator)
	self.view:registerMediator(mediator_name_string, mediator);
end

function Facade:registerProxy(proxy_name_string, proxy)
	self.model:registerProxy(proxy_name_string, proxy);
end

function Facade:removeCommand(notification_name_string, command_class)
	self.controller:removeCommand(notification_name_string, command_class);
end

function Facade:removeMediator(mediator_name_string)
	self.view:removeMediator(mediator_name_string);
end

function Facade:removeProxy(proxy_name_string)
	self.model:removeProxy(proxy_name_string);
end

function Facade:retrieveMediator(mediator_name_string)
	return self.view:retrieveMediator(mediator_name_string);
end

function Facade:retrieveProxy(proxy_name_string)
	return self.model:retrieveProxy(proxy_name_string);
end

function Facade:sendNotification(notification)
	if MusicUtils then
		MusicUtils:stopEffect4Card();
	end
	self.controller:sendNotification(notification);
end

function Facade:stop()
	MusicUtils:stop(true)
	self.view:stop();
	self.controller:stop();
	self.model:stop();
	closeSocket();
	stopSchedule();
	initializeCommonUtil();
	ExcelCacheClean();
	if ActivityConstConfig then
		ActivityConstConfig.activities={};
	end
	if BetterEquipManager then
		BetterEquipManager:cleanAllLayers();
	end
	if LayerManager then
		LayerManager:clean();
	end
end

function Facade:unobserve(command_class)
	self.viewObserver:unobserve(command_class);
end