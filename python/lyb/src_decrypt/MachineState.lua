require("main.controller.command.battleScene.battle.fsm.StateEnum")
require("main.controller.command.battleScene.battle.fsm.MachineStateImpl")
require("main.controller.command.battleScene.battle.battlefield.compute.SelectTargetImpl")
require("main.controller.command.battleScene.battle.fsm.battleunit.InitState")
require("main.controller.command.battleScene.battle.fsm.battleunit.IdleState")
require("main.controller.command.battleScene.battle.fsm.battleunit.PursueState")
require("main.controller.command.battleScene.battle.fsm.battleunit.AttackState")
require("main.controller.command.battleScene.battle.fsm.battleunit.FlyAttackState")
require("main.controller.command.battleScene.battle.fsm.battleunit.MoveState")
require("main.controller.command.battleScene.battle.fsm.battleunit.BeAttackState")
require("main.controller.command.battleScene.battle.fsm.battleunit.DeadState")
require("main.controller.command.battleScene.battle.fsm.battleunit.FrozenState")
require("main.controller.command.battleScene.battle.fsm.battleunit.PerSkillState")
-- require("main.controller.command.battleScene.battle.battlefield.compute.CastSkillCompute")
MachineState = class(MachineStateImpl);
--宠物移动
function MachineState:ctor(battleUnit)
	self.class = MachineState;
	self.battleUnit = battleUnit;
end

function MachineState:cleanSelf()
	self.battleUnit = nil;
	self:removeSelf()
end

function MachineState:dispose()
    self:cleanSelf();
end

function MachineState:initialize()
	self.stateMap[StateEnum.INIT] = InitState.new(self.battleUnit, self);
	self.stateMap[StateEnum.IDLE] = IdleState.new(self.battleUnit, self);
	self.stateMap[StateEnum.PURSUE] = PursueState.new(self.battleUnit, self);
	self.stateMap[StateEnum.ATTACK] = AttackState.new(self.battleUnit, self);
	self.stateMap[StateEnum.FLYATTACK] = FlyAttackState.new(self.battleUnit, self);
	self.stateMap[StateEnum.MOVE] = MoveState.new(self.battleUnit, self);
	self.stateMap[StateEnum.BEATTACKED] = BeAttackState.new(self.battleUnit, self);
	self.stateMap[StateEnum.DEAD] = DeadState.new(self.battleUnit, self);
	self.stateMap[StateEnum.FROZEN] = FrozenState.new(self.battleUnit, self);
	self.stateMap[StateEnum.PERSKILL] = PerSkillState.new(self.battleUnit, self);
	self:setCurrentState(self.stateMap[StateEnum.INIT]);--设置当前状态
end