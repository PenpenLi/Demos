--
	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
	-- Create date: 2013-4-17

	-- yanchuan.xie@happyelements.com


Handler_29_1 = class(Command);

function Handler_29_1:execute()
  local huodongProxy=self:retrieveProxy(HuoDongProxy.name)
  local tab = recvTable["OperationActivityArray"];
  huodongProxy:setData(recvTable["OperationActivityArray"])
  print("Handler_29_1:execute() ***************")

 if HuoDongMediator then
    local med=self:retrieveMediator(HuoDongMediator.name);
    if med then
      med:setData();
    end
  end
  local SevenDaysBoolValue = 0;
  local firstPayBoolValue = 0;
  for i,v in ipairs(recvTable["OperationActivityArray"]) do
    if v.ID == 4 or v.ID == 17 then
      if v.BooleanValue == 1 then
         firstPayBoolValue = 1;
      end
    end
    if v.ID > 6 and v.ID < 14 then
      if v.BooleanValue == 1 then
        SevenDaysBoolValue = 1;
      end
    end
    
  end

  -- if SevenDaysMediator  then
  --   print( "\n\n\n\nif SevenDaysMediator  then")
  --   local med = self:retrieveMediator(SevenDaysMediator.name);
  --   if med then
  --     -- med:refreshData();
  --     med:refreshLeftRedDot();
  --     print( "\n\n\n\nif SevenDaysMediator  then")
  --   end
  -- end


  if MainSceneMediator then
    local med=self:retrieveMediator(MainSceneMediator.name);
    if med then
      med:refreshHuoDongLogin();
      med:refreshFirstPayLogin(firstPayBoolValue);
      med:refreshSevenDays(SevenDaysBoolValue == 1 and true or false);

    end
  end



  if GameVar.tutorStage == TutorConfig.STAGE_2004 then
    local has = false;
    for k, v in pairs(recvTable["OperationActivityArray"])do
      if v.ID == 1 then
        has = true;
        break;
      end
    end
    if not has then
      sendServerTutorMsg({})
      closeTutorUI();
    end
  end
end

Handler_29_1.new():execute();