--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatPrivateToPlayerCommand=class(MacroCommand);

function ChatPrivateToPlayerCommand:ctor()
	self.class=ChatPrivateToPlayerCommand;
end

function ChatPrivateToPlayerCommand:execute(notification)
  self:addSubCommand(MainSceneToChatCommand);
  self:complete();
  self:retrieveMediator(ChatPopupMediator.name):onPrivateToPlayer(notification:getData().UserName);
end