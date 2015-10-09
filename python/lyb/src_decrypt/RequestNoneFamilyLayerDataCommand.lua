--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RequestNoneFamilyLayerDataCommand=class(Command);

function RequestNoneFamilyLayerDataCommand:ctor()
	self.class=RequestNoneFamilyLayerDataCommand;
end

function RequestNoneFamilyLayerDataCommand:execute(notification)
  local data=notification:getData();
  print("requestNoneFamilyLayerDataCommand",data.Page);
  if(connectBoo) then
  	sendMessage(27,9,data);
  end
end