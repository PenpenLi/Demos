--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

HeroHouseInitCommand=class(Command);

function HeroHouseInitCommand:ctor()
	self.class=HeroHouseInitCommand;
end

function HeroHouseInitCommand:execute(notification)
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	if not heroHouseProxy.init then
		--命令已删除(by gaoyun)
		--sendMessage(6,1);
	end;
end