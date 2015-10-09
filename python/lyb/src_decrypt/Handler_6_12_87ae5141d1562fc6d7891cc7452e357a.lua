require "main.model.BagProxy";
require "main.model.GeneralListProxy";
require "main.model.EffectProxy";

Handler_6_12 = class(Command);

function Handler_6_12:execute()
	print("Handler_6_12 ",recvTable["Type"],recvTable["GeneralIdArray"],recvTable["FormationId"],recvTable["GeneralId"],recvTable["Place"]);
	for k,v in pairs(recvTable["GeneralIdArray"]) do
		print(v.GeneralId, v.Place);
	end
	uninitializeSmallLoading();
	if 0 == recvTable["FormationId"] then
		recvTable["FormationId"] = 2;
	end
	local data = {};
	data.Type=recvTable["Type"];
	data.GeneralIdArray=recvTable["GeneralIdArray"];
	data.FormationId=recvTable["FormationId"];
	data.GeneralId=recvTable["GeneralId"];
	data.Place=recvTable["Place"];
	data.IDArray=recvTable["IDArray"];

	local familyProxy = self:retrieveProxy(FamilyProxy.name);
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	heroHouseProxy:refreshPeibingPeizhi(data);
	-- heroHouseProxy:refreshEmployGeneralArrayByType(recvTable["GeneralId"],recvTable["Place"],recvTable["Type"]);

	local updateType = recvTable["Type"]
	if updateType == 1 then
		local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
		  heroHouseProxy:refreshGeneralIsPlay(recvTable["GeneralIdArray"]);

		   local userProxy = self:retrieveProxy(UserProxy.name);
		   userProxy.generalArray = {};
		   for k, v in pairs(heroHouseProxy:getGeneralArray())do
			  print("v.GeneralId", v.GeneralId)
			  if self:isInBattle(recvTable["GeneralIdArray"], v.GeneralId) then
			    table.insert(userProxy.generalArray, {ConfigId = v.ConfigId})
			  end
		  end

		  if MainSceneMediator then
		      local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name)
		      if mainSceneMediator then
		            mainSceneMediator:refreshGeneralRoleLayer()
		      end
		  end
	elseif updateType == 5 then
		local arenaProxy = self:retrieveProxy(ArenaProxy.name);
		arenaProxy.generalIdArray = recvTable["GeneralIdArray"]
		local arenaMediator=self:retrieveMediator(ArenaMediator.name);
	    if arenaMediator then
	        arenaMediator:refreshDefData();
	    end
	elseif updateType == 6 then
		local arenaProxy = self:retrieveProxy(ArenaProxy.name);
		arenaProxy.generalIdArray2 = recvTable["GeneralIdArray"]
	elseif updateType == 7 then
		local shadowProxy=self:retrieveProxy(ShadowProxy.name);
		shadowProxy.generalIdArray = recvTable["GeneralIdArray"]

	elseif updateType == 2 then
		local tenCountryProxy = self:retrieveProxy(TenCountryProxy.name);
		tenCountryProxy.placeGeneralIdArray = recvTable["GeneralIdArray"]
	elseif updateType == 3 or updateType == 4 then
		local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
		heroHouseProxy:setTreasuryGeneralArr(recvTable["GeneralIdArray"]);
	elseif updateType >= 8 and updateType <= 12 then
		local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
		heroHouseProxy:setFEBGeneralArr(recvTable["GeneralIdArray"],updateType-6);
	else
		  
	end

	if HeroTeamSubMediator then
      local heroTeamSubMediator = self:retrieveMediator(HeroTeamSubMediator.name)
      if heroTeamSubMediator then
	      	local familyProxy = self:retrieveProxy(FamilyProxy.name);
			familyProxy:refreshUserCountByBiandui(recvTable["GeneralId"],recvTable["Type"]);
            heroTeamSubMediator:getViewComponent():onGotoBattleConfirm();
            if updateType == 2 then
		      if 0 == familyProxy.shiguo_general_id then
					familyProxy.shiguo_general_id = recvTable["GeneralId"];
				end
				familyProxy.shiguo_boolean = 0 == recvTable["GeneralId"] and 0 or 1;
			end
      end
  	end
  if JingjichangMediator then
  	local jingjichangMediator = self:retrieveMediator(JingjichangMediator.name)
  	if jingjichangMediator then
  		jingjichangMediator:getViewComponent():refreshPeibingChange();
  	end
  end
  if TenCountryMediator then
  	local tenCountryMediator = self:retrieveMediator(TenCountryMediator.name)
  	if tenCountryMediator then
  		tenCountryMediator:getViewComponent():refreshPeibingChange();
  	end
  end
end
function Handler_6_12:isInBattle(generalIdArray, generalId)
    for k, v in pairs(generalIdArray) do
        if v.GeneralId == generalId then
            return true;
        end
    end
    return false;
end
Handler_6_12.new():execute();