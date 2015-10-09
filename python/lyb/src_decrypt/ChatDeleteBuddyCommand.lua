--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatDeleteBuddyCommand=class(Command);

function ChatDeleteBuddyCommand:ctor()
	self.class=ChatDeleteBuddyCommand;
end

function ChatDeleteBuddyCommand:execute(notification)
  local data=notification:getData();
	print("chatDeleteBuddyCommand",data.UserId,data.UserName);
  if(connectBoo) then
    sendMessage(21,3,data);
  end
end