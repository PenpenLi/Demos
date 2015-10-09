--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RequestFamilyMemberArrayCommand=class(Command);

function RequestFamilyMemberArrayCommand:ctor()
	self.class=RequestFamilyMemberArrayCommand;
end

function RequestFamilyMemberArrayCommand:execute(notification)
  local data=notification:getData();
  print("requestFamilyMemberArrayCommand",data.FamilyId);
  if(connectBoo) then
  	sendMessage(27,5,data);
  end
end