--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

	yanchuan.xie@happyelements.com
]]

StrengthenLevelupCommand=class(Command);

function StrengthenLevelupCommand:ctor()
	self.class=StrengthenLevelupCommand;
end

function StrengthenLevelupCommand:execute(notification)
  local data={UserEquipmentId=notification:getData(),BooleanValue=0};
  print("strengthenLevelup",data.UserEquipmentId,data.BooleanValue);
  if(connectBoo) then
    initializeSmallLoading();
    sendMessage(10,2,data);
  end
end