--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RequestFamilyApplyArrayCommand=class(Command);

function RequestFamilyApplyArrayCommand:ctor()
	self.class=RequestFamilyApplyArrayCommand;
end

function RequestFamilyApplyArrayCommand:execute(notification)
  local data=notification:getData();
  print("requestFamilyApplyArrayCommand");
  if(connectBoo) then
  	sendMessage(27,6,data);
  end
end