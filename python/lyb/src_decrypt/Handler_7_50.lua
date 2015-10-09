
Handler_7_50 = class(Command)
--友军消失
function Handler_7_50:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
    local boolVlaue;local battleUnitID;
    if not battleProxy.handlerType then
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        boolVlaue = handlerData.BoolVlaue;
        battleUnitID = handlerData.BattleUnitID;
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local generalVO = battleProxy.battleGeneralArray[battleUnitID]
    generalVO.battleIcon:setVisible(false)
    generalVO.roleShadow:setVisible(false)
end

Handler_7_50.new():execute();