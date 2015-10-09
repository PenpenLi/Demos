--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyToAgoraCommand=class(Command);

function FamilyToAgoraCommand:ctor()
	self.class=FamilyToAgoraCommand;
end

function FamilyToAgoraCommand:execute(notification)
  local data=notification:getData();
  print("familyToAgoraCommand");
  if(connectBoo) then
  	sendMessage(5,2,{CityFunctionId=101});
  end
end