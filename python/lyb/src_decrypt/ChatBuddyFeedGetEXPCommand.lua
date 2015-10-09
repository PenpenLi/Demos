--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatBuddyFeedGetEXPCommand=class(Command);

function ChatBuddyFeedGetEXPCommand:ctor()
	self.class=ChatBuddyFeedGetEXPCommand;
end

function ChatBuddyFeedGetEXPCommand:execute(notification)
  print("ChatBuddyFeedGetEXPCommand");
  if(connectBoo) then
  	 sendMessage(21,9);
  end
end