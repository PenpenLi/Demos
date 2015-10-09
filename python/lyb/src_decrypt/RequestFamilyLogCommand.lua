--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RequestFamilyLogCommand=class(Command);

function RequestFamilyLogCommand:ctor()
	self.class=RequestFamilyLogCommand;
end

function RequestFamilyLogCommand:execute(notification)
  local data=notification:getData();
  print("requestFamilyLogCommand");
  if(connectBoo) then
  	sendMessage(27,16,data);
  end
end