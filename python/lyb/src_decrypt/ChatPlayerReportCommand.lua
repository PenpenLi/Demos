--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatPlayerReportCommand=class(Command);

function ChatPlayerReportCommand:ctor()
	self.class=ChatPlayerReportCommand;
end

function ChatPlayerReportCommand:execute(notification)
  local data=notification:getData();
  print("chatPlayerReportCommand",data.Type,data.Title,data.Content);
  if(connectBoo) then
    sendMessage(24,33,data);
  end
end