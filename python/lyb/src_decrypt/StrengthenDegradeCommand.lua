--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

	yanchuan.xie@happyelements.com
]]

StrengthenDegradeCommand=class(Command);

function StrengthenDegradeCommand:ctor()
	self.class=StrengthenDegradeCommand;
end

function StrengthenDegradeCommand:execute(notification)
  local data={UserEquipmentId=notification:getData()};
	print("strengthenDegrade");
  if(connectBoo) then
    initializeSmallLoading();
  	sendMessage(10,4,data);
  end
end