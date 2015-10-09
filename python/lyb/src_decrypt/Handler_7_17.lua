--[[
    "技能释放结果"
  ]]
Handler_7_17 = class(MacroCommand)

function Handler_7_17:execute()

    --[[local battleProxy = self:retrieveProxy(BattleProxy.name)
    local targetUnitID = recvTable["TargetBattleUnitId"];
    local targetGeneralVO = battleProxy.battleGeneralArray[targetUnitID];
    
    targetGeneralVO.enemyBattleUnitVO = battleProxy.battleGeneralArray[recvTable["AttackterBattleUnitId"]]
    --[[targetGeneralVO.targetCoordinateX = recvTable["AttackterCoordinateX"];
    targetGeneralVO.targetCoordinateX = battleProxy:transformCoordinateX(3,targetGeneralVO);
    
	targetGeneralVO.coordinateX = recvTable["TargetCoordinateX"];
    targetGeneralVO.coordinateX = battleProxy:transformCoordinateX(1,targetGeneralVO);
	
    targetGeneralVO.useSkill = recvTable["SkillId"];
    targetGeneralVO.attackResultArray = recvTable["AttackResultArray"];
	
    targetGeneralVO.currentHP = recvTable["CurrentHP"]
    targetGeneralVO.changeValue = recvTable["ChangeValue"]	
    targetGeneralVO.booleanValue = recvTable["BooleanValue"]
    local currentRage = recvTable["CurrentRage"]
	targetGeneralVO.isLastAttack = self:chickLastAttack(battleProxy,targetGeneralVO)
    battleProxy.isLastAttack = targetGeneralVO.isLastAttack;
    if targetGeneralVO.currentHP <= 0 and battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_11 then
            battleProxy.totalDeadNumber = battleProxy.totalDeadNumber + 1;
    end
	
    local battleMediator = self:retrieveMediator(BattleSceneMediator.name)
    if currentRage and targetGeneralVO.isMyPlayerPet then
            local battleRangeData = {}
            battleRangeData.currentRage = currentRage;
            battleMediator:setRangeData(battleRangeData)
    end
	
    local table = {type = "Handler_7_17", untilID = targetUnitID};
    self:addSubCommand(BattleSkillCommand);  
    self:complete(table);]]
end

--[[function Handler_7_17:chickLastAttack(battleProxy,targetGeneralVO)
    if battleProxy.bossMonsterID == targetGeneralVO.generalID and targetGeneralVO.currentHP <= 0 then
            return true
    else
            return false
    end
end]]

Handler_7_17.new():execute();