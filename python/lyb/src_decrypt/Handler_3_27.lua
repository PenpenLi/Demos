Handler_3_27 = class(Command);

function Handler_3_27:execute()
	local userProxy = self:retrieveProxy(UserProxy.name);
	userProxy:setNobility(recvTable["Nobility"]);
	self:refreshGuanzhi();

    self:checkFunctionOpen(userProxy.nobility)

    self:setTutorStage(userProxy.nobility);
end

function Handler_3_27:checkFunctionOpen(nobility)
    local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
    openFunctionProxy:checkOpenFunctionsByNobility(nobility);
end

function Handler_3_27:setTutorStage(nobility)
  
   local stage = self:getTutorByNobility(nobility);
   if stage then
      print("!!!!!!!!!!!!!!!!!!!stage:" .. stage);
   end
   if stage and stage > 0 then



      if FactionMediator and self:retrieveMediator(FactionMediator.name) then
        GameVar.tutorSmallStep = 0
        GameVar.tutorStage = stage;
        GameVar.tuturReaccess = false;
        sendServerTutorMsg({Stage = GameVar.tutorStage})
      end
   end
end
function Handler_3_27:getTutorByNobility(nobility)
    local stageArr = analysisByName("Xinshouyindao_Xinshou", "guanzhiid", nobility)
    for i_k, i_v in pairs(stageArr) do
        return i_v.jieduan;
    end
    return nil;
end
function Handler_3_27:refreshGuanzhi()
    if GuanzhiPopupMediator then
        local mediator = self:retrieveMediator(GuanzhiPopupMediator.name);
        if mediator then
            mediator:refreshUpdate();
        end
    end
    
    if FactionCurrencyMediator then
        local factionCurrencyMediator=self:retrieveMediator(FactionCurrencyMediator.name);
        if nil~=factionCurrencyMediator then
          factionCurrencyMediator:setHuobiText();
        end
    end
end

Handler_3_27.new():execute();