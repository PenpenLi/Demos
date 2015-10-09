--[[
    返回 战斗效果
  ]]
Handler_7_5 = class(MacroCommand)

function Handler_7_5:execute()
    local battleUnitID
    local effectTable
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        effectTable = recvTable["EffectArray"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local playData = battleProxy.handlerData;
        battleUnitID = playData.BattleUnitID
        effectTable = playData.EffectArray
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_5"] = nil
    end
    
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    for k,v in pairs(effectTable) do
       
        if battleGeneralVO.effectArray == nil then
            battleGeneralVO.effectArray = {};
        end
        if battleGeneralVO.effectArray[k] == nil then
            local effectVO = {};
            effectVO.effectID = v.EffectId;
            effectVO.skillId = v.SkillId;
            effectVO.priority = v.Priority;
            effectVO.effectValue = v.EffectValue;
            effectVO.attackterBattleUnitId = v.AttackterBattleUnitId;
            battleGeneralVO.effectArray[effectVO.effectID] = effectVO;
        end
    end
    battleGeneralVO.actionManager:addEffectAction();
    -- local table = {type = "Handler_7_5", untilID = battleUnitID};
    -- self:addSubCommand(BattleEffectCommand);  
    -- self:complete(table);
    
end

Handler_7_5.new():execute();