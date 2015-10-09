require("main.controller.command.battleScene.battle.fsm.AbstractState")
InitState = class(AbstractState);
--怪物初始状态
function InitState:ctor(battleUnit,machineState)
	self.class = InitState;
	self.battleUnit = battleUnit;
	self.machineState = machineState;
end

function InitState:cleanSelf()
	self.battleUnit = nil;
	self.machineState = nil;
	self:removeSelf()
end

function InitState:dispose()
    self:cleanSelf();
end

function InitState:getStateEnum()
	return StateEnum.INIT;
end

function InitState:onBegin(now)
	--self.battleUnit:getCdTimeManager():initStateInitTime(self.battleUnit,now,2000);
end

function InitState:onExit()
	--self.battleUnit:getCdTimeManager():setStateInitTime(nil);
end

function InitState:onUpdate(now)
	if InitState.superclass.onUpdate(self,now) then
		self:inneOnUpdate(now)
	end
end

function InitState:inneOnUpdate(now)
	--if self.battleUnit:getCdTimeManager():stateInitTimeArrived(now) then
		self.battleUnit:setCurrentState(StateEnum.IDLE);
	--end
end