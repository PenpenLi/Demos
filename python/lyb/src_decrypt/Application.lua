--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]
require "core.mvc.core.Object";
require "core.mvc.core.Facade";

Application=class(Object);

function Application:ctor()
	self.class=Application;
end

function Application:initialize()

end

function Application:registerCommand(notification_name_string, command_class)
	Facade.getInstance():registerCommand(notification_name_string, command_class);
end

function Application:start()
	Facade.getInstance():sendNotification(Notification.new(Notifications.APPLICATION_START));
end

function Application:stop()
	Facade.getInstance():stop();
end