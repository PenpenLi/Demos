
Handler_7_20 = class(Command);

function Handler_7_20:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    battleProxy.serverBackBattleOver = true
end

Handler_7_20.new():execute();