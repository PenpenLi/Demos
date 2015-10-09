--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyFoundCommand=class(Command);

function FamilyFoundCommand:ctor()
	self.class=FamilyFoundCommand;
end

function FamilyFoundCommand:execute(notification)
  local data=notification:getData();
  print("familyFoundCommand",data.FamilyName);
  if(connectBoo) then
  	sendMessage(27,1,data);
  end
end