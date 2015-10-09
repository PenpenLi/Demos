
Handler_16_5 = class(Command);

function Handler_16_5:execute()
	-- local arenaProxy = self:retrieveProxy(ArenaProxy.name)
 --    arenaProxy.rankArray = recvTable["RankArray"];
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshRankingData(recvTable["UserArenaArray"]);
    end
end

Handler_16_5.new():execute();