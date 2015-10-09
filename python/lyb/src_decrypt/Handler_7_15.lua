--[[
    玩家当前位置
  ]]
Handler_7_15 = class(MacroCommand)

function Handler_7_15:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    if not battleProxy then return end
	-- 如果处于慢动作阶段 不再同步人物位置 zhangke
	if battleProxy.isLastAttack then return; end
    local battleUnitID;
    local coordinateX;
    local coordinateY;
    if not battleProxy.handlerType then
        battleUnitID = recvTable["BattleUnitID"];
        coordinateX = recvTable["CoordinateX"];
        coordinateY = recvTable["CoordinateY"];
        -- -- 屏幕适配偏移
        -- coordinateX = coordinateX + GameData.uiOffsetX
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.BattleUnitID
        coordinateX =handlerData.CoordinateX
        coordinateY =handlerData.CoordinateY
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_15"] = nil
    end

    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    if not battleGeneralVO then return;end
    -- battleGeneralVO.targetCoordinateX = coordinateX;
    -- battleGeneralVO.targetCoordinateY= coordinateY;
    battleGeneralVO:setPositionCcp(ccp(coordinateX,coordinateY));
    battleGeneralVO:onRestMove();
    -- local table = {type = "Handler_7_15", untilID = battleUnitID};
    -- self:addSubCommand(BattleMoveCommand);  
    -- self:complete(table);
end

Handler_7_15.new():execute();