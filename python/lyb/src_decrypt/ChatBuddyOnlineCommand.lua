--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatBuddyOnlineCommand=class(Command);

function ChatBuddyOnlineCommand:ctor()
	self.class=ChatBuddyOnlineCommand;
end

function ChatBuddyOnlineCommand:execute(notification)
  print("ChatBuddyOnlineCommand");
  if(connectBoo) then
    initializeSmallLoading();
    sendMessage(21,1);
  end
end