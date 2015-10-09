Handler_19_18 = class(Command);

function Handler_19_18:execute()
	--UserName,Level,Zhanli,FormationId,PlaceConfigArray,TargetStateArray
 	uninitializeSmallLoading();
 	local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
 	tenCountryProxy.targetStateArray = recvTable["TargetStateArray"]
    local tenCountryMediator=self:retrieveMediator(TenCountryMediator.name);
    if tenCountryMediator then
        tenCountryMediator:getViewComponent():refreshHeroDetailData(recvTable["Zhanli"],recvTable["UserName"],recvTable["FormationId"],recvTable["PlaceConfigArray"],recvTable["Level"]);
    end
    if GameVar.tutorStage == TutorConfig.STAGE_1026 then
        openTutorUI({x=848, y=45, width = 192, height = 60});
    end
end

Handler_19_18.new():execute();