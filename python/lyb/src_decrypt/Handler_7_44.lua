
Handler_7_44 = class(MacroCommand)
function Handler_7_44:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local battleUnitID
    local coordinateX
    local coordinateY
    local targetCoordinateX
    local targetCoordinateY
    local attackResult
    local attackSkillId
    local attackResultArray
    local currentRage
    local attackMoveSpeed
    local attackMoveLastX
    if not battleProxy.handlerType then
        battleUnitID = recvTable["AttackterBattleUnitId"];
        coordinateX = recvTable["AttackterCoordinateX"];
        coordinateY = recvTable["AttackterCoordinateY"];
        targetCoordinateX = recvTable["TargetCoordinateX"];
        targetCoordinateY = recvTable["TargetCoordinateY"];
        attackSkillId = recvTable["SkillId"];
        currentRage = recvTable["CurrentRage"]
        attackResultArray = recvTable["AttackResultArray"];
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        battleUnitID = handlerData.AttackterBattleUnitId
        attackSkillId = handlerData.SkillId
        beAttackActionId = handlerData.BeAttackActionId
        attackResultArray = handlerData.AttackResultArray
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
    end
    local scBtUnit = battleProxy.battleGeneralArray[battleUnitID];
    scBtUnit = scBtUnit and scBtUnit or battleProxy.battleUserArray[battleUnitID];
    if not scBtUnit then return end
    local aRACnt = 0;
    for key,value in pairs(attackResultArray) do
        aRACnt = aRACnt+1;
    end
    local hurtCount = 0;
    for key,value in pairs(attackResultArray) do
        local targetUnitID = value.TargetBattleUnitId;
        local tgBtUnit = battleProxy.battleGeneralArray[targetUnitID];
        if tgBtUnit then
            tgBtUnit.enemyBattleUnitVO = scBtUnit;
            --同步被攻击坐标
            tgBtUnit.currentHP = value.CurrentHP
            --最后一击
            tgBtUnit.isLastAttack = self:chickLastAttack(tgBtUnit)
            --同步攻击技能
            tgBtUnit.beAttackSkillId = attackSkillId;
            tgBtUnit.beAttackActionId = beAttackActionId;
            if tgBtUnit.effectManager:beAttackEffects(scBtUnit,attackSkillId,value.hurtEffectArray,aRACnt) then
                hurtCount = hurtCount+1;
            end
        end
    end
    --吸血
    BattleUtils:sendUpdateHRValue(scBtUnit,BattleFormula:computeXiXue(scBtUnit,hurtCount));
end

function Handler_7_44:chickLastAttack(tgBtUnit)
    if tgBtUnit.currentHP <= 0 and tgBtUnit.isBoss then
        return true
    end
end

Handler_7_44.new():execute();
