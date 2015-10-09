
Handler_7_24 = class(MacroCommand)

function Handler_7_24:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local battleUnitID
    local coordinateX
    local coordinateY
    local targetCoordinateX
    local targetCoordinateY
    local attackResult
    local currentRage
    local attackSkillId
    local attackResultArray
    local yuanFen
    local faceDirect;
    if not battleProxy.handlerType then
        battleUnitID = recvTable["AttackterBattleUnitId"];
        coordinateX = recvTable["AttackterCoordinateX"];
        coordinateY = recvTable["AttackterCoordinateY"];
        targetCoordinateX = recvTable["TargetCoordinateX"];
        targetCoordinateY = recvTable["TargetCoordinateY"];
        attackResult = recvTable["AttackResult"];
        currentRage = recvTable["CurrentRage"]
        attackSkillId = recvTable["SkillId"];
        yuanFen = recvTable["YuanFen"];
        faceDirect = recvTable["FaceDirect"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.AttackterBattleUnitId
        coordinateX = handlerData.AttackterCoordinateX
        coordinateY = handlerData.AttackterCoordinateY
        attackResult = handlerData.AttackResult
        currentRage = handlerData.CurrentRage
        attackSkillId = handlerData.SkillId
        faceDirect = handlerData.FaceDirect
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local battleGeneralVO = battleProxy.battleGeneralArray[battleUnitID];
    --同步攻击坐标
    if not battleGeneralVO  then
        return
    end
    battleGeneralVO:setPositionCcp(ccp(coordinateX,coordinateY));

    battleGeneralVO.faceDirect = faceDirect == -1 and true or false;
    battleGeneralVO.booleanValue = nil;
        --同步攻击技能
    battleGeneralVO.attackSkillId = attackSkillId;
    --同步攻击漂汉字效果
    local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    battleMediator:refreshRangeData(battleGeneralVO)
    battleGeneralVO.actionManager:attackAction();
end

function Handler_7_24:getRightBattleUnitID(attackResultArray)
    for k1,v1 in pairs(attackResultArray) do
        if v1.isBoss then
            return k1;
        end
    end
    local len = #attackResultArray;
    local num = math.random(len)
    return attackResultArray[num].TargetBattleUnitId
end

Handler_7_24.new():execute();
