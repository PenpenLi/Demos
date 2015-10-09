--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

Notifications={APPLICATION_START="gameStart"};

Notification=class(Object);

function Notification:ctor(type_string, data)
	self.class=Notification;
	self.type=type_string;
  self.data = data;
end

function Notification:getData()
  return self.data;
end