--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-7

	yanchuan.xie@happyelements.com
]]

StrengthenForgeCommand=class(Command);

function StrengthenForgeCommand:ctor()
	self.class=StrengthenForgeCommand;
end

function StrengthenForgeCommand:execute(notification)
  local data={UserEquipmentId=notification:getData()};
	print("StrengthenForge");
  if(connectBoo) then
    initializeSmallLoading();
  	sendMessage(10,8,data);
  end
end