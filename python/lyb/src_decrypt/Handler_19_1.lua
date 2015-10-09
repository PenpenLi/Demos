
Handler_19_1 = class(Command);

function Handler_19_1:execute()
    print("Handler_19_1..");
    for k,v in pairs(recvTable["GeneralIdArray"]) do
        print("..");
        for k_,v_ in pairs(v) do
            print(k_,v_);
        end
    end
	require "main.view.treasury.TreasuryMediator";
    local GeneralIdArray = recvTable["GeneralIdArray"];
    local CDTimeArray = recvTable["CDTimeArray"];
    if not GeneralIdArray then GeneralIdArray = {} end
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    heroHouseProxy:setTreasuryGeneralArr(GeneralIdArray);
	local treasuryMediator = self:retrieveMediator(TreasuryMediator.name);
	if nil~=treasuryMediator then
        for k,v in pairs(CDTimeArray) do
            treasuryMediator:refreshRemainSeconds(v.Type,v.Time);
        end
	end
	require "main.view.hero.heroTeam.HeroTeamSubMediator";
    local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
    if nil~=heroTeamSubMediator then
    	heroTeamSubMediator:setData();
    end
end

Handler_19_1.new():execute();