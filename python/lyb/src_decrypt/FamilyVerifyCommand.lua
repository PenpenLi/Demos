--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyVerifyCommand=class(Command);

function FamilyVerifyCommand:ctor()
	self.class=FamilyVerifyCommand;
end

function FamilyVerifyCommand:execute(notification)
  local data=notification:getData();
  print("familyVerifyCommand",data.UserId,data.BooleanValue);
  if(connectBoo) then
  	sendMessage(27,7,data);
  end
end