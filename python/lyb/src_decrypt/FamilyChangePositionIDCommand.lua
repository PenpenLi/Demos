--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyChangePositionIDCommand=class(Command);

function FamilyChangePositionIDCommand:ctor()
	self.class=FamilyChangePositionIDCommand;
end

function FamilyChangePositionIDCommand:execute(notification)
  local data=notification:getData();
  print("familyChangePositionIDCommand",data.UserId,data.FamilyPositionId);
  if(connectBoo) then
  	sendMessage(27,11,data);
  end
end