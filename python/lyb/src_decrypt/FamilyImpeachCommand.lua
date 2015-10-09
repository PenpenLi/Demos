--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyImpeachCommand=class(Command);

function FamilyImpeachCommand:ctor()
	self.class=FamilyImpeachCommand;
end

function FamilyImpeachCommand:execute(notification)
  print("FamilyImpeachCommand");
  if connectBoo then
  	sendMessage(27,22);
  end
end