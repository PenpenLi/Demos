


Handler_6_21 = class(MacroCommand);

function Handler_6_21:execute()

  local zhenFaMediator = self:retrieveMediator(ZhenFaMediator.name);
  local id = recvTable["ID"];
  local level = recvTable["Level"];
  -- print("ID, Level",ID, Level)
  local zhenFaProxy = self:retrieveProxy(ZhenFaProxy.name);
  local oldDataLen = #zhenFaProxy:getData();

  zhenFaProxy:refreshData(id,level);

  local newDataLen = #zhenFaProxy:getData();
  if oldDataLen == 1 and newDataLen == 2 then
    GameVar.tutorStage = TutorConfig.STAGE_1027;
    GameVar.tuturReaccess = false;
    sendServerTutorMsg({Stage = GameVar.tutorStage})
  end	

  if zhenFaMediator  then 
  	zhenFaMediator:refreshData(id,level);
  end

  self:addSubCommand(JudgeReddotCommand);
  self:complete({data={functionId=FunctionConfig.FUNCTION_ID_61}});

end

Handler_6_21.new():execute();