
Handler_7_60 = class(MacroCommand);

function Handler_7_60:execute()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  local round = recvTable["Round"]
  local smallRound = recvTable["SmallRound"]
  local array = recvTable["MonsterStateArray"]
  battleProxy.type3LeftRound = round ~=0 and round or nil
  battleProxy.type3SmallRound = smallRound ~= 0 and smallRound or nil
  battleProxy.type3MonsterStateArray = #array~=0 and array or nil
end

Handler_7_60.new():execute();