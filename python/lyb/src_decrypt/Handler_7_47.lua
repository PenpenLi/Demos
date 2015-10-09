--火球移动位置

Handler_7_47 = class(MacroCommand)

function Handler_7_47:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local flyUnitID;
    local battleUnitID;
    local targetBattleUnitID;
    local skillId;
    local coordinateX;
    local coordinateY;
    local targetCoordinateX;
    local targetCoordinateY;
    local speedX;
    local speedY;
    if not battleProxy.handlerType then
        flyUnitID = recvTable["FlyUnitID"];
        battleUnitID = recvTable["BattleUnitID"];
        targetBattleUnitID = recvTable["TargetBattleUnitID"];
        skillId = recvTable["SkillId"];
        coordinateX = recvTable["CoordinateX"];
        coordinateY = recvTable["CoordinateY"];
        targetCoordinateX = recvTable["TargetCoordinateX"];
        targetCoordinateY = recvTable["TargetCoordinateY"];
        speedX = recvTable["SpeedX"];
        speedY = recvTable["SpeedY"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        flyUnitID = handlerData.FlyUnitID;
        battleUnitID = handlerData.BattleUnitID;
        targetBattleUnitID = handlerData.TargetBattleUnitID
        skillId = handlerData.SkillId;
        coordinateX =handlerData.CoordinateX;
        coordinateY =handlerData.CoordinateY;
        targetCoordinateX =handlerData.TargetCoordinateX;
        targetCoordinateY =handlerData.TargetCoordinateY;
        speedX = handlerData.SpeedX;
        speedY = handlerData.SpeedY;
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_47"] = nil
    end
    local flaySkillVO = {};
    flaySkillVO.flyUnitID = flyUnitID;
    flaySkillVO.skillId = skillId;
    flaySkillVO.battleUnitID = battleUnitID;
    flaySkillVO.targetBattleUnitID = targetBattleUnitID;
    flaySkillVO.coordinateX =  coordinateX;
    flaySkillVO.coordinateY =  coordinateY;
    flaySkillVO.targetCoordinateX = targetCoordinateX;
    flaySkillVO.targetCoordinateY = targetCoordinateY;
    
    battleProxy.battleFlySkillArray[flyUnitID] = flaySkillVO;
    
    local table = {type = "Handler_7_47", untilID = flyUnitID};
    
    self:addSubCommand(BattleMoveCommand);  
    self:complete(table);
end

Handler_7_47.new():execute();