
Handler_7_49 = class(Command)
--友军出战
function Handler_7_49:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
    local coordinateX;local coordinateY;local battleUnitID;local handlerData;
    if not battleProxy.handlerType then
    
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        handlerData = battleProxy.handlerData;
        coordinateX = handlerData.CoordinateX;
        coordinateY = handlerData.CoordinateY;
        battleUnitID = handlerData.BattleUnitID;
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local generalVO = battleProxy.battleGeneralArray[battleUnitID]
    generalVO.battleIcon:setVisible(true)
    generalVO.roleShadow:setVisible(true)
    generalVO.battleIcon:setPositionXY(coordinateX,coordinateY,true)
    local battleSceneMediator=self:retrieveMediator(BattleSceneMediator.name);
    battleSceneMediator:refreshFriend(handlerData)
end

Handler_7_49.new():execute();