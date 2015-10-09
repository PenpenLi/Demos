
Handler_27_46 = class(MacroCommand)

function Handler_27_46:execute()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  battleProxy.battleremainSeconds = recvTable["RemainSeconds"] + os.time();
end

Handler_27_46.new():execute();