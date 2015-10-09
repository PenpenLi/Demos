--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-21

	yanchuan.xie@happyelements.com
]]

SmallChatCloseCommand=class(MacroCommand);

function SmallChatCloseCommand:ctor()
  self.class=SmallChatCloseCommand;
end

function SmallChatCloseCommand:execute(notification)
  require "main.controller.notification.SmallChatNotification";
  self:removeMediator(SmallChatMediator.name);
  self:removeCommand(SmallChatNotifications.SMALL_CHAT_MENU,SmallChatMenuCommand);
  self:removeCommand(SmallChatNotifications.SMALL_CHAT_CLOSE,SmallChatCloseCommand);
  setMenuOpened(false);
end