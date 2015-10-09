-- add by mohai.wu 小红点数据

Handler_29_4 = class(Command);

function Handler_29_4:execute()
  print(" \n\n\n\n----------29_4-------------")
    -- for k,v in pairs(recvTable["IDArray"]) do
    --   print("29_4 v.ID = ", v.ID)
    --   if v.ID > 6 and v.ID < 14 then
    --     -- 七天乐小红点
    --   else
    --     -- 活动界面小红点
    --     if HuoDongMediator then
    --       local huoDongMediator = self:retrieveMediator(HuoDongMediator.name);
    --       if huoDongMediator then
    --           huoDongMediator:refreshRedDot2(v.ID);
    --       end
    --     end 
    --   end
    -- end

    local tab = {};
    for k,v in pairs(recvTable["IDArray"]) do
      tab[v.ID] = true;

    end
    for k,v in pairs(tab) do
      print(k,v)
    end
    if HuoDongMediator then
      local huoDongMediator = self:retrieveMediator(HuoDongMediator.name);
      if huoDongMediator then
          huoDongMediator:refreshRedDot2(tab);
      end
    end 

    if SevenDaysMediator then
      local sevenDaysMediator = self:retrieveMediator(SevenDaysMediator.name);
      if sevenDaysMediator ~= nil then
        sevenDaysMediator:refreshRedDot(tab);
      end
    end
    
end

Handler_29_4.new():execute();