--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-14

	yanchuan.xie@happyelements.com
]]

StrengthenStarAddCommand=class(Command);

function StrengthenStarAddCommand:ctor()
	self.class=StrengthenStarAddCommand;
end

function StrengthenStarAddCommand:execute(notification)
  local data={UserEquipmentId=notification:getData()};
	print("strengthenStarAdd");
  if(connectBoo) then
    initializeSmallLoading();
  	sendMessage(10,7,data);
  end
end