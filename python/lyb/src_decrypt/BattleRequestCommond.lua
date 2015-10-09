
BattleRequestCommond = class(Command)

function BattleRequestCommond:ctor()
	self.class=BattleRequestCommond;
end

function BattleRequestCommond:execute(notification)
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	if battleProxy:hasPlaybackData(notification.battleID) then
		battleProxy.handlerType = "BattleRequestCommond";
		battleProxy.viewBattleID = notification.battleID;
		battleProxy.handlerData = battleProxy.playbackArray[notification.battleID][1];
		require "main.controller.handler.Handler_7_1";
		return
	end
	local function onAllServerConfigLoaded(statusCode, responseData)
		uninitializeSmallLoading();
		if responseData then
			log("======================responseData========================="..responseData)
			local lua = "return " .. responseData    
 			local func = loadstring(lua)
 			local testData = func()
 			if #testData < 2 then return end
			local battleProxy = self:retrieveProxy(BattleProxy.name)
			battleProxy:setPlayBackData(notification.battleID,testData)
			battleProxy:playBackSort(notification.battleID)
			battleProxy.handlerType = "BattleRequestCommond";
			battleProxy.viewBattleID = notification.battleID;
			battleProxy.handlerData = battleProxy.playbackArray[notification.battleID][1];
			require "main.controller.handler.Handler_7_1";
	  	end
	end
	require "core.net.HttpService";
	self.service = HttpService.new();
	self.service:setUrl("http://"..GameData.serverAdd..":8082/context/battlereport/"..notification.battleID);
	self.service:setResponseCallback(onAllServerConfigLoaded);
	self.service:send();
	initializeSmallLoading()
end
