--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-16

	yanchuan.xie@happyelements.com
]]

SmallChatNotifications={SMALL_CHAT_MENU="smallChatMenu",
						SMALL_CHAT_CLOSE="smallChatClose",
						SMALL_CHAT_VISIBLE="SMALL_CHAT_VISIBLE"};

SmallChatNotification=class(Notification);

function SmallChatNotification:ctor(type_string,data)
	self.class = SmallChatNotification;
	self.type = type_string;
  self.data = data;
end

function SmallChatNotification:getData()
  return self.data;
end