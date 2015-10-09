--[[
    效果消失
  ]]
Handler_7_12 = class(MacroCommand)

function Handler_7_12:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local battleUnitID
    local effectId
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        effectId = recvTable["EffectId"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        effectId = handlerData.EffectId
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_12"] = nil
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    if battleGeneralVO.effectArray then
        battleGeneralVO.effectArray[effectId] = nil;
    end
    battleGeneralVO.actionManager:removeEffectAction();
    -- local table = {type = "Handler_7_12", untilID = battleUnitID};
    -- self:addSubCommand(BattleEffectCommand);  
    -- self:complete(table);
end

Handler_7_12.new():execute();