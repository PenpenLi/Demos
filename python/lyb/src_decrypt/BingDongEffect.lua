BingDongEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function BingDongEffect:ctor()
	self.class = BingDongEffect;
end

function BingDongEffect:cleanSelf()
	self:removeSelf()
end

function BingDongEffect:dispose()
    self:cleanSelf();
end

function BingDongEffect:doExecute(now)
	self.target.machineState:switchState(StateEnum.FROZEN);
end

function BingDongEffect:doUnExecute()
	self.target.machineState:switchState(StateEnum.IDLE);
	local standPos = self.target.standPositionCcp;
	self.target:getMoveManager():setTargetX(standPos.x);
	self.target:getMoveManager():setTargetY(standPos.y);
	self.target:getMoveManager():sendTargetCoordinateXMessage(true);
end
