--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyChangeNoticeCommand=class(Command);

function FamilyChangeNoticeCommand:ctor()
	self.class=FamilyChangeNoticeCommand;
end

function FamilyChangeNoticeCommand:execute(notification)
  local data=notification:getData();
  print("familyChangeNoticeCommand",data.ParamStr1);
  if(connectBoo) then
  	sendMessage(27,19,data);
  end
end