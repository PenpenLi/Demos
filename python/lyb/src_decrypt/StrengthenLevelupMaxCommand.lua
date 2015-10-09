--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

	yanchuan.xie@happyelements.com
]]

StrengthenLevelupMaxCommand=class(Command);

function StrengthenLevelupMaxCommand:ctor()
	self.class=StrengthenLevelupMaxCommand;
end

function StrengthenLevelupMaxCommand:execute(notification)
  local data={UserEquipmentId=notification:getData(),BooleanValue=1};
  print("strengthenLevelupMax",data.UserEquipmentId);
  if(connectBoo) then
    initializeSmallLoading();
    sendMessage(10,2,data);
  end
end