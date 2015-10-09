-- --
-- 	Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- 	Create date: 2013-4-17

-- 	yanchuan.xie@happyelements.com


Handler_29_2 = class(Command);

function Handler_29_2:execute()

  log("function Handler_29_2:execute()");
  local huodongProxy=self:retrieveProxy(HuoDongProxy.name)
  local tem=recvTable["OperationActivityDetailArray"];
  -- for k,v in pairs(recvTable["OperationActivityDetailArray"]) do
  --   print("Handler_29_2.",v.ID,v.ActivityConditionArray);
  -- end

  -- print("tem[1][ID]  = ", tem[1]["ID"] )

  huodongProxy:setData2(tem)

  if FirstPayMediator then
    local firstPayMediator = self:retrieveMediator(FirstPayMediator.name);
    if firstPayMediator and tem[1]["ActivityConditionArray"][1] and tem[1]["ID"] == 4 then
       firstPayMediator:refreshData(tem[1]["ActivityConditionArray"][1]);
    end
  end
  -- 累充，add by mohai.wu
  if SecondPayMediator then
    local secondPayMediator = self:retrieveMediator(SecondPayMediator.name);
    if secondPayMediator ~= nil then
      secondPayMediator:refreshData(tem[1]["ActivityConditionArray"][1]);
    end
  end

  --开服七天乐数据
  if tem[1]["ID"] > 6 and tem[1]["ID"] < 14 then
    print("kaifuqitianle")
      local SevenDaysMediator = self:retrieveMediator(SevenDaysMediator.name);
        SevenDaysMediator:refreshData();
    return;
  end



  if HuoDongMediator then
    local huoDongMediator = self:retrieveMediator(HuoDongMediator.name);
    if huoDongMediator then
      huoDongMediator:refreshData();
      -- print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Handler_29_2",tem[1]["ID"])
      -- if not (tem[1]["ID"] == 2) then
      --   huoDongMediator:refreshRedDot(tem[1]["ID"]);
      -- end
    end
  end 
  if MainSceneMediator then
    local med=self:retrieveMediator(MainSceneMediator.name);
    if med then
      med:refreshHuoDong();
    end
  end


end

Handler_29_2.new():execute();