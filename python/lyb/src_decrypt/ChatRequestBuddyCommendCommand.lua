--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatRequestBuddyCommendCommand=class(Command);

function ChatRequestBuddyCommendCommand:ctor()
	self.class=ChatRequestBuddyCommendCommand;
end

function ChatRequestBuddyCommendCommand:execute(notification)
	print("ChatRequestBuddyCommendCommand");
  if(connectBoo) then
  	 sendMessage(21,7);
  end
end