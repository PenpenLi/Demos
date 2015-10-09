--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

HeroHouseQuitWarCommand=class(Command);

function HeroHouseQuitWarCommand:ctor()
	self.class=HeroHouseQuitWarCommand;
end

function HeroHouseQuitWarCommand:execute(notification)
	-- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	-- if not heroHouseProxy.init then
	local data=notification:getData();
	if data.funcType == "Treasury" then
		data.funcType = nil;
		sendMessage(19,15,data);
	elseif data.funcType == "ArenaDefense" then
		local arenaProxy = self:retrieveProxy(ArenaProxy.name);
		local serverArray = arenaProxy:getToServerQuitArray(data.GeneralId)
    	sendMessage(16,3,{GeneralIdArray = serverArray})
	elseif data.funcType == "TenCountry" then
		local tenCountryProxy = self:retrieveProxy(TenCountryProxy.name);
		tenCountryProxy.quitGeneralId = data.GeneralId
		sendMessage(19,5,data);
	else
		sendMessage(6,13,data);
	end
	-- end;
end