

Handler_19_5 = class(Command);

function Handler_19_5:execute()
	sharedTextAnimateReward():animateStartByString("下阵成功！");
	
	local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
	tenCountryProxy:removeGeneralIdArray(tenCountryProxy.quitGeneralId)
	require "main.view.hero.heroTeam.HeroTeamSubMediator";
    local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
    if nil~=heroTeamSubMediator then
    	heroTeamSubMediator:setData();
    end
end

Handler_19_5.new():execute();