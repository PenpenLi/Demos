--[[
    玩家跳跃位置
  ]]
Handler_7_45 = class(MacroCommand)

function Handler_7_45:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local battleUnitID;
    local coordinateX;
    local coordinateY;
    local moveFaceDirect;
    local targetCoordinateX;
    local targetCoordinateY;
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        moveFaceDirect = recvTable["BooleanValue"];
        coordinateX = recvTable["CoordinateX"];
        coordinateY = recvTable["CoordinateY"];
        targetCoordinateX = recvTable["TargetCoordinateX"];
        targetCoordinateY = recvTable["TargetCoordinateY"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        moveFaceDirect =handlerData.BooleanValue
        coordinateX =handlerData.CoordinateX;
        coordinateY =handlerData.CoordinateY;
        targetCoordinateX =handlerData.TargetCoordinateX
        targetCoordinateY =handlerData.TargetCoordinateY
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
	battleGeneralVO.moveFaceDirect = moveFaceDirect == 0;
    battleGeneralVO:setPositionCcp(ccp(coordinateX,coordinateY));
    battleGeneralVO.targetCoordinateX = targetCoordinateX;
    battleGeneralVO.targetCoordinateY = targetCoordinateY; 
       
    local table = {type = "Handler_7_45", untilID = battleUnitID};
    self:addSubCommand(BattleMoveCommand);  
    self:complete(table);
end

Handler_7_45.new():execute();