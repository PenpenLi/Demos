require "main.model.BagProxy";
require "main.model.GeneralListProxy";
require "main.model.EffectProxy";

Handler_6_13 = class(Command);

function Handler_6_13:execute()
	print("Handler_6_13 ",recvTable["Type"],recvTable["GeneralIdArray"],recvTable["FormationId"],recvTable["GeneralId"],recvTable["Place"]);
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

	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	heroHouseProxy:refreshPeibingPeizhi(data);
    
    if 2 == data.Type then
        local familyProxy = self:retrieveProxy(FamilyProxy.name);
        familyProxy.shiguo_general_id = recvTable["GeneralId"];
        familyProxy.shiguo_boolean = 0 == recvTable["GeneralId"] and 0 or 1;
    end
	-- heroHouseProxy:refreshEmployGeneralArrayByType(recvTable["GeneralId"],recvTable["Place"],recvTable["Type"]);

	if HeroTeamSubMediator then
      local heroTeamSubMediator = self:retrieveMediator(HeroTeamSubMediator.name)
      if heroTeamSubMediator then
        heroTeamSubMediator:getViewComponent():refreshPeibingPeizhi();
      end
    end

    if GameVar.tutorStage ~= TutorConfig.STAGE_99999 and recvTable["Type"] ~= 2 then

        if GameVar.tutorStage == TutorConfig.STAGE_1003 then

             local xPos, yPos;
             local width, height;
             local totalCount = self:getTotalGeneralCount()
             local count = #recvTable["GeneralIdArray"]
             print("+++++++++++++++++++++++++++++++++++++++++++count",count)
             if totalCount == count then
               xPos, yPos = 1075,0;
               width, height = 130,144
               GameVar.tutorSmallStep = 100315;
             else
               xPos, yPos = self:getGeneralPosByConfigId(10)--16是言豫津
               width, height = 116,110
             end
             openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});

        elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
             local xPos, yPos;
             local totalCount = self:getTotalGeneralCount()
             local count = #recvTable["GeneralIdArray"]
             print("+++++++++++++++++++++++++++++++++++++++++++count",count)
             if totalCount == count then
               xPos, yPos = 1075,0;
               width, height = 130,144
               GameVar.tutorSmallStep = 100618
             else
               xPos, yPos = self:getGeneralPosByConfigId(77)
               width, height = 116,110
             end
             openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});

        elseif GameVar.tutorStage == TutorConfig.STAGE_1016 then
            -- self.arenaProxy=self:retrieveProxy(ArenaProxy.name);
            -- if self.arenaProxy.afterBattle then--

            -- else
            --     closeTutorUI(false);
            -- end
        elseif GameVar.tutorStage ~= TutorConfig.STAGE_1002 and GameVar.tutorStage ~= TutorConfig.STAGE_1026  and GameVar.tutorStage ~= TutorConfig.STAGE_1007 and  GameVar.tutorStage ~= TutorConfig.STAGE_1027 then
            openTutorUI({x=1075, y=0, width = 130, height = 144, alpha = 125});--1075,0
        end
    end

end

-- function Handler_6_13:getPlayGeneralLimit(heroHouseProxy)
--   self.placeOpen4Juqing = 0;
--   local storyLineProxy  = self:retrieveProxy(StoryLineProxy.name)
--   local userProxy  = self:retrieveProxy(UserProxy.name)

--   local mainGeneralLevel = userProxy.mainGeneralLevel;
--   for i=1,3 do
--     local data = analysis("Gongnengkaiqi_Zhenweipeizhi",i);
--     local level = data.generals;
--     local guanka = data.guanqiaid;
--     if 0~=level then
--       if mainGeneralLevel >= level then
--         self.placeOpen4Juqing = i;
--       end
--     elseif 0~=guanka then
--       if 1 == storyLineProxy:getStrongPointState(guanka) then
--         self.placeOpen4Juqing = i;
--       end
--     end
--   end
-- end

function Handler_6_13:getTotalGeneralCount()
    local returnValue = 0;
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    local generalArray = heroHouseProxy:getGeneralArray()
    for key,generalVO in pairs(generalArray) do
        returnValue = returnValue + 1;
    end
    return returnValue;
end

function Handler_6_13:getGeneralPosById(generalId, isTenCountry)
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

    local datas
    if isTenCountry then
      local tenCountryProxy = self:retrieveProxy(TenCountryProxy.name);
      datas = heroHouseProxy:getTenCountryLeftGeneral(tenCountryProxy);
    else
      datas = heroHouseProxy:getGeneralArrayWithPlayer();
    end

    local index = 0;
    local xPos = 0
    local yPos = 0
    for k, v in ipairs(datas) do
        print('v.GeneralId', v.GeneralId)
        index = index + 1;
        if v.GeneralId == generalId then
            xPos = 3+(-1+index)%3*142
            yPos = 350-175*math.floor((-1+index)/3)
        end
    end
    print("==============================xPos, yPos", xPos, yPos)
    return xPos+110, yPos+127;
end

function Handler_6_13:getGeneralPosByConfigId(configId)
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

    local datas = heroHouseProxy:getGeneralArrayWithPlayer();
    local index = 0;
    local xPos = 0
    local yPos = 0
    for k, v in ipairs(datas) do
    	index = index + 1;
    	if v.ConfigId == configId then
    		xPos = 2+(-1+index)%2*142
    		yPos = 350-175*math.floor((-1+index)/2)
    	end
    end
    print("==============================xPos, yPos", xPos, yPos)
    return xPos+110, yPos+127;
 --    local datas = math.ceil(table.getn(heroHouseProxy:getGeneralArrayWithPlayer())/9);
 --    local temp = {};
 --    for i=1,datas do
 --    	table.insert(temp, i);
 --    end
	-- heroHouseProxy:getGeneralArrayWithPlayer()
end
Handler_6_13.new():execute();