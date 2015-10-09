Handler_16_6 = class(Command);

function Handler_16_6:execute()
	-- local arenaProxy = self:retrieveProxy(ArenaProxy.name)
 --    local userId = recvTable["UserId"];
 --    arenaProxy.allRankGeneralArray[userId] = recvTable["RankGeneralArray"]
 	uninitializeSmallLoading();
 	print(recvTable["UserId"],recvTable["FormationId"],recvTable["PlaceIDArray"]);
 	for k,v in pairs(recvTable["PlaceIDArray"]) do
 		print(v.ID,v.Place);
 	end
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshHeroDetailData(recvTable["UserId"],recvTable["FormationId"],recvTable["PlaceIDArray"]);
    end

	if GameVar.tutorStage == TutorConfig.STAGE_1016 then
	     openTutorUI({x=846, y=46, width = 192, height = 62, alpha = 125});
	end

end

Handler_16_6.new():execute();