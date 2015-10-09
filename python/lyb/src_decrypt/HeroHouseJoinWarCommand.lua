--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

HeroHouseJoinWarCommand=class(Command);

function HeroHouseJoinWarCommand:ctor()
	self.class=HeroHouseJoinWarCommand;
end

function HeroHouseJoinWarCommand:execute(notification)
	-- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	-- if not heroHouseProxy.init then
	local data=notification:getData();
	if data.funcType == "Treasury" then
		data.funcType = nil;
		sendMessage(19,14,data);
	elseif data.funcType == "ArenaDefense" then
		local arenaProxy = self:retrieveProxy(ArenaProxy.name);
		local serverArray = arenaProxy:getToServerJoinArray(data.GeneralId)
    	sendMessage(16,3,{GeneralIdArray = serverArray})
	elseif data.funcType == "TenCountry" then
		local tenCountryProxy = self:retrieveProxy(TenCountryProxy.name);
		tenCountryProxy.joinGeneralId = data.GeneralId
		sendMessage(19,4,data);
	else
		sendMessage(6,12,data);
	end
	-- end;
end