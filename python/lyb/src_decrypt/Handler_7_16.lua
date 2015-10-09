--[[
    玩家移动目标位置
  ]]
Handler_7_16 = class(MacroCommand)

function Handler_7_16:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local battleUnitID;
    local targetBattleUnitID;
    local coordinateX;
    local coordinateY;
    local moveFaceDirect;
    local targetCoordinateX;
    local targetCoordinateY;
    local needStop;
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        moveFaceDirect = recvTable["BooleanValue"];
        targetBattleUnitID = recvTable["TargetBattleUnitID"];
        coordinateX = recvTable["CoordinateX"];
        coordinateY = recvTable["CoordinateY"];
        -- 屏幕适配偏移
        -- print("coordinateX------1====="..coordinateX)
        -- coordinateX = coordinateX + GameData.uiOffsetX
        -- print("coordinateX------2====="..coordinateX)

        targetCoordinateX = recvTable["TargetCoordinateX"];
        targetCoordinateY = recvTable["TargetCoordinateY"];
        -- print("targetCoordinateX------1====="..targetCoordinateX)
        -- targetCoordinateX = targetCoordinateX + GameData.uiOffsetX
        -- print("targetCoordinateX------2====="..targetCoordinateX)
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        moveFaceDirect =handlerData.BooleanValue;
        targetBattleUnitID =handlerData.TargetBattleUnitID;
        coordinateX =handlerData.CoordinateX;
        coordinateY =handlerData.CoordinateY;
        targetCoordinateX =handlerData.TargetCoordinateX
        targetCoordinateY =handlerData.TargetCoordinateY
        needStop = handlerData.needStop
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_16"] = nil
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    local dx = math.abs(targetCoordinateX-coordinateX);
    local dy = math.abs(targetCoordinateY-coordinateY);
    if math.floor(dx) == 0 and math.floor(dy) == 0 then
        battleGeneralVO.machineState:switchState(StateEnum.IDLE);
        return
    end
	battleGeneralVO.moveFaceDirect = moveFaceDirect == 0;
    battleGeneralVO.targetBattleUnitID = targetBattleUnitID;
    battleGeneralVO:setPositionCcp(ccp(coordinateX,coordinateY));
    battleGeneralVO.targetCoordinateX = targetCoordinateX;
    battleGeneralVO.targetCoordinateY = targetCoordinateY;
    battleGeneralVO.needStop = needStop
    
    --battleGeneralVO.coordinateX = battleProxy:transformCoordinateX(1,battleGeneralVO);

    --battleGeneralVO.targetCoordinateX = battleProxy:transformCoordinateX(3,battleGeneralVO);

    -- print("========battleUnitID========="..battleUnitID.."=========move=========="..battleGeneralVO.coordinateX.."--targetCoordinateX=="..battleGeneralVO.targetCoordinateX)   
       
    local table = {type = "Handler_7_16", untilID = battleUnitID};
    
    self:addSubCommand(BattleMoveCommand);  
    self:complete(table);

    -- if battleProxy.battleType == BattleConfig.BATTLE_TYPE_22 or
    --    battleProxy.battleType == BattleConfig.BATTLE_TYPE_15 or
    --    battleProxy.battleType == BattleConfig.BATTLE_TYPE_18 or
    --    battleProxy.battleType == BattleConfig.BATTLE_TYPE_19 then
    --         local battleSceneMediator=self:retrieveMediator(BattleSceneMediator.name);
    --         battleSceneMediator:setWaitingDisVisible()
    -- end
end

Handler_7_16.new():execute();