--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyDismissCommand=class(Command);

function FamilyDismissCommand:ctor()
	self.class=FamilyDismissCommand;
end

function FamilyDismissCommand:execute(notification)
  local data=notification:getData();
  print("familyDismissCommand");
  if(connectBoo) then
    local userProxy = self:retrieveProxy(UserProxy.name)
  	if 1==userProxy:getFamilyPositionID() then
  		sendMessage(27,10,data);
  	else
  		sendMessage(27,3,data);
  	end
  end
end