--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyStandSelectCommand=class(Command);

function FamilyStandSelectCommand:ctor()
	self.class=FamilyStandSelectCommand;
end

function FamilyStandSelectCommand:execute(notification)
  local data=notification:getData();
  print("familyStandSelectCommand",data.StandID);
  if(connectBoo) then
  	sendMessage(27,17,data);
  end
end