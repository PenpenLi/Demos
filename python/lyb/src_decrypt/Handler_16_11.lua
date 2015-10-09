Handler_16_11 = class(Command);

function Handler_16_11:execute()
 	print(recvTable["UserId"],recvTable["FormationId"],recvTable["PlaceIDArray"]);
 	for k,v in pairs(recvTable["PlaceIDArray"]) do
 		print(v.ID,v.Place);
 	end
    local jingjichangMediator=self:retrieveMediator(JingjichangMediator.name);
    if jingjichangMediator then
        jingjichangMediator:getViewComponent():refreshNewRightDetailData(recvTable["UserId"],recvTable["FormationId"],recvTable["PlaceIDArray"]);
    end
end

Handler_16_11.new():execute();