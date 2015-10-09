--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

ChatAddBuddyCommand=class(Command);

function ChatAddBuddyCommand:ctor()
	self.class=ChatAddBuddyCommand;
end

function ChatAddBuddyCommand:execute(notification)
  local data=notification:getData();
	print("chatAddBuddyCommand",data.UserId,data.UserName);
  if(connectBoo) then
    sendMessage(21,4,data);
    --sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_61));
  end
end