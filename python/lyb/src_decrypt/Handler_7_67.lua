
Handler_7_67 = class(MacroCommand);
--攻击完成
function Handler_7_67:execute()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  local skillID;
  local battleUnitID;
  local skillCDingBool;
  if not battleProxy.handlerType then
      battleUnitID = recvTable["BattleUnitID"];
      skillID = recvTable["SkillID"]
  else
      local handlerData = battleProxy.handlerData;
      battleUnitID = handlerData.BattleUnitID
      skillID = handlerData.SkillID;
      skillCDingBool = handlerData.SkillCDingBool
      battleProxy.handlerData = nil;
      battleProxy.handlerType = nil;
      package.loaded["main.controller.handler.Handler_7_67"] = nil
  end
end

Handler_7_67.new():execute();