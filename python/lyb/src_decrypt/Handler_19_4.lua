

Handler_19_4 = class(Command);

function Handler_19_4:execute()
	sharedTextAnimateReward():animateStartByString("上阵成功！");
	
	local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
	tenCountryProxy:insertGeneralIdArray(tenCountryProxy.joinGeneralId)

	require "main.view.hero.heroTeam.HeroTeamSubMediator";
    local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
    if nil~=heroTeamSubMediator then
    	heroTeamSubMediator:setData();
    end
end

Handler_19_4.new():execute();