--[[
    同步怒气
  ]]
Handler_7_8 = class(Command)

function Handler_7_8:execute()

    --local battleProxy = self:retrieveProxy(BattleProxy.name)
    --battleProxy.CurrentRage = recvTable["CurrentRage"]

--    self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.SYNCHRONIZATION_CURRENTRAGE));

      --[[local battleProxy = self:retrieveProxy(BattleProxy.name)
      battleProxy.currentRage = recvTable["CurrentRage"];
      self:addSubCommand(BattleOverCommand);  
      self:complete(table);]]
      
  --self.battleMediator = self:retrieveMediator(BattleSceneMediator.name);
  
  ---local battleRangeData = {}
  --battleRangeData["currnetRang"] = battleProxy.CurrentRage
  
  --self.battleMediator:setRangeData(battleRangeData)
      
end

Handler_7_8.new():execute();