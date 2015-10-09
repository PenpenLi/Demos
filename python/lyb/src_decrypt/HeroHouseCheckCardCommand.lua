--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

HeroHouseCheckCardCommand=class(Command);

function HeroHouseCheckCardCommand:ctor()
	self.class=HeroHouseCheckCardCommand;
end

function HeroHouseCheckCardCommand:execute(notification)
	-- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	-- if not heroHouseProxy.init then
	local data=notification:getData();
		-- sendMessage(6,5,data);
	-- end;
end