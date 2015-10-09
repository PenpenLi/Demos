--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-22

	yanchuan.xie@happyelements.com
]]

ChatMsgStateCommand=class(Command);

function ChatMsgStateCommand:ctor()
	self.class=ChatMsgStateCommand;
end

function ChatMsgStateCommand:execute(notification)
  local data=notification:getData();
	print("chatMsgStateCommand",data.UserId,data.UserName,data.State);
  if(connectBoo) then
    sendMessage(11,5,data);
  end
end