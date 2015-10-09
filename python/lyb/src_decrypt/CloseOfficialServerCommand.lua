--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

CloseOfficialServerCommand=class(Command);

function CloseOfficialServerCommand:ctor()
	self.class=CloseOfficialServerCommand;
end

function CloseOfficialServerCommand:execute(notification)
  self:removeMediator(OfficialServerMediator.name);
end