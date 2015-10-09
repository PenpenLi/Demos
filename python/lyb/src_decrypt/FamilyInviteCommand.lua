--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyInviteCommand=class(Command);

function FamilyInviteCommand:ctor()
	self.class=FamilyInviteCommand;
end

function FamilyInviteCommand:execute(notification)
  local data=notification:getData();
  print("familyInviteCommand",data.UserId,data.UserName);
  if(connectBoo) then
  	sendMessage(27,15,data);
  end
end