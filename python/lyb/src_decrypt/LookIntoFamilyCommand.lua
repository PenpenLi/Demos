--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

LookIntoFamilyCommand=class(Command);

function LookIntoFamilyCommand:ctor()
	self.class=LookIntoFamilyCommand;
end

function LookIntoFamilyCommand:execute(notification)
  local data=notification:getData();
  print("lookIntoFamilyCommand",data.FamilyId);
  if(connectBoo) then
  	initializeSmallLoading();
  	sendMessage(27,13,data);
  end
end