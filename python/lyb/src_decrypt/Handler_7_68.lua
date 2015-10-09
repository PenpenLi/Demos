
Handler_7_68 = class(MacroCommand);
--攻击完成
function Handler_7_68:execute()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  local step;
  local battleUnitID;
  local battleUnitIDArray;
  local faceDirect;
  if not battleProxy.handlerType then
      battleUnitID = recvTable["BattleUnitID"];
      step = recvTable["Type"]
      battleUnitIDArray = recvTable["BattleUnitIDArray"]
      faceDirect = recvTable["Face"]
  else
      local handlerData = battleProxy.handlerData;
      battleUnitID = handlerData.BattleUnitID
      step = handlerData.Type;
      battleUnitIDArray = handlerData.BattleUnitIDArray;
      faceDirect = handlerData.Face
      battleProxy.handlerData = nil;
      battleProxy.handlerType = nil;
      package.loaded["main.controller.handler.Handler_7_68"] = nil
  end

  if step == 1 then
    self:stepOne(battleUnitID,faceDirect,battleProxy)
  elseif step == 2 then
    self:stepTwo()
  elseif step == 3 then

  elseif step == 4 then

  end
end

function Handler_7_68:stepOne(battleUnitID,faceDirect,battleProxy)
    local generalVO = battleProxy.battleGeneralArray[battleUnitID]
    generalVO.battleIcon:bodyRepeat(BattleConfig.ROLE_HOLD)
    local jinengPO = analysis("Jineng_Jineng",generalVO.bossSkill)
    local  realKey = "key".. jinengPO.editorid
    generalVO.battleIcon:refreshBossAttackArea(generalVO,faceDirect==-1,realKey,generalVO.bossStopSkillTime)
    generalVO.battleIcon:changeFaceDirect(faceDirect==-1);
end

function Handler_7_68:stepTwo()
  -- body
end
Handler_7_68.new():execute();