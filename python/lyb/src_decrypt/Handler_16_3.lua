--决战
Handler_16_3 = class(Command);

function Handler_16_3:execute()
	local arenaProxy = self:retrieveProxy(ArenaProxy.name)
    arenaProxy.generalIdArray = recvTable["GeneralIdArray"]

	require "main.view.hero.heroTeam.HeroTeamSubMediator";
    local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
    if nil~=heroTeamSubMediator then
    	heroTeamSubMediator:setData();
    end
end

Handler_16_3.new():execute();