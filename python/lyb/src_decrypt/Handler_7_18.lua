--[[
    战斗单位属性变化同步
  ]]
Handler_7_18 = class(Command)

function Handler_7_18:execute()

    --local battleProxy = self:retrieveProxy(BattleProxy.name)
    --battleProxy.battleUnitID = recvTable["BattleUnitID"]
    --battleProxy.unitPropertyArray = recvTable["UnitPropertyArray"]
    
    --self:sendNotification(BattleSceneNotification.new(BattleSceneNotifications.CHANGE_ATTRIBUTE));
end

Handler_7_18.new():execute();