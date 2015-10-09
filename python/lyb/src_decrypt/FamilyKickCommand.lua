--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyKickCommand=class(Command);

function FamilyKickCommand:ctor()
	self.class=FamilyKickCommand;
end

function FamilyKickCommand:execute(notification)
  local data=notification:getData();
  print("familyKickCommand",data.UserId);
  if(connectBoo) then
  	sendMessage(27,18,data);
  end
end