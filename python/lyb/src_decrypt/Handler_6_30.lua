

Handler_6_30 = class(MacroCommand);

function Handler_6_30:execute()
  -- require "main.model.SummonHeroProxy";
  -- require "main.view.summonHero.SummonHeroMediator";
  -- require "main.controller.command.mainScene.MainSceneToSummonHeroCommand"


  -- local summonHeroProxy=self:retrieveProxy(SummonHeroProxy.name);
  -- summonHeroProxy.GeneralEmployInfoArray = recvTable["GeneralEmployInfoArray"];
  -- summonHeroProxy.Count = recvTable["Count"];
  

  -- print("============(6,30)==return============",summonHeroProxy.GeneralEmployInfoArray,summonHeroProxy.Count)

  -- for k, v in pairs(summonHeroProxy.GeneralEmployInfoArray) do
  --   print("=(6,30)=:",k,v,v.ConfigId);
  -- end
  --  print("=(6,30)11=:",summonHeroProxy.GeneralEmployInfoArray[1].ConfigId);

  -- local summonHeroMediator = self:retrieveMediator(SummonHeroMediator.name)
  -- if summonHeroMediator then
  --   --刷新数据
  --   summonHeroMediator:drawResult();
  --   summonHeroMediator:setData();
  -- end


  --添加subcommand
  -- if summonHeroProxy.fundStateArray and summonHeroProxy.fundStateArray[1]==0 then
  --   self:addSubCommand(MainSceneToFundCommand);
  --   self:complete();
  -- end  
  --self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_FUND))
end

Handler_6_30.new():execute();