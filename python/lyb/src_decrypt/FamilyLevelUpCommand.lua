--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyLevelUpCommand=class(Command);

function FamilyLevelUpCommand:ctor()
	self.class=FamilyLevelUpCommand;
end

function FamilyLevelUpCommand:execute(notification)
  local data=notification:getData();
  print("familyLevelUpCommand");
  if(connectBoo) then
  	sendMessage(27,2,data);
  end
end