--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

HeroPutOffEquipeCommand=class(Command);

function HeroPutOffEquipeCommand:ctor()
	self.class=HeroPutOffEquipeCommand;
end

function HeroPutOffEquipeCommand:execute(notification)
	-- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	-- if not heroHouseProxy.init then
	local data=notification:getData();
		sendMessage(6,7,data);
	-- end;
end