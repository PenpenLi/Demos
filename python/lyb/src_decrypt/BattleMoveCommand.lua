-------------------------
--BattleInitCommand handler_7_15 handler_7_16
-------------------------


BattleMoveCommand=class(Command);

function BattleMoveCommand:ctor()
	self.class=BattleMoveCommand;
	self.battleProxy = nil;
end
--------------------------
--角色移动数据
--------------------------
function BattleMoveCommand:execute(notification)
	require "main.config.BattleConfig"
	require "main.view.battleScene.BattleLayerManager"
	
    --战场数据
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    if(notification.type == "Handler_7_16") then
        self:roleMoveTo(notification["untilID"]);
    elseif(notification.type == "Handler_7_15") then
        self:roleModifyTo(notification["untilID"]);
    elseif(notification.type == "Handler_7_47") then
        self:flySkillMoveTo(notification["untilID"])
    end
end
-------------------------
--角色移动
-----------------------
function BattleMoveCommand:roleMoveTo(playerUnitID)
    local battleUnit = self.battleProxy.battleGeneralArray[playerUnitID];
    if not battleUnit then return end
    battleUnit.machineState:switchState(StateEnum.MOVE);
    battleUnit.actionManager:movingAction();
end
-------------------------
--修正坐标
-------------------------
function BattleMoveCommand:roleModifyTo(playerUnitID)
    local battleUnit = self.battleProxy.battleGeneralArray[playerUnitID];
    if not battleUnit then return end
    battleUnit.actionManager:modifyAction();
end

-------------------------
--火球生成&移动
-------------------------
function BattleMoveCommand:flySkillMoveTo(playerUnitID)
    local flaySkillVO = self.battleProxy.battleFlySkillArray[playerUnitID];
    local source = self.battleProxy.battleGeneralArray[flaySkillVO.battleUnitID];
    local target = self.battleProxy.battleGeneralArray[flaySkillVO.targetBattleUnitID];
    local skillMgr = source:getSkill(flaySkillVO.skillId)
    local flyList = self.battleProxy.AIBattleField:getFlyUniList();
    if skillMgr:getActionConfig().attackType == BattleConstants.CastTargetTypeEnemyTarget1 then
        flyList:addFireballUnit(flaySkillVO.FlyUnitID,source,skillMgr,target);
    elseif skillMgr:getActionConfig().attackType == BattleConstants.CastTargetTypeEnemyTarget3 then
        flyList:addFireRainUnit(flaySkillVO.FlyUnitID,source,skillMgr,target);
    end
end

