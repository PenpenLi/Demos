--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-21

	yanchuan.xie@happyelements.com
]]

SmallChatMenuCommand=class(MacroCommand);

function SmallChatMenuCommand:ctor()
  self.class=SmallChatMenuCommand;
end

function SmallChatMenuCommand:execute(notification)
  local smallChatMediator=self:retrieveMediator(SmallChatMediator.name);
  smallChatMediator:onMenu();
end