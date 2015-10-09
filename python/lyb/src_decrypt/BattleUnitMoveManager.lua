BattleUnitMoveManager = class();
--战斗单位移动控制器
function BattleUnitMoveManager:ctor(battleUnit)
	self.class = BattleUnitMoveManager;
	self.battleUnit = battleUnit;
	--目标坐标点
	self.targetX = 0;
	self.targetY = 0;
	--最后跟新坐标时间
	self.lastTime = 0;
	--最后一次同步的坐标位置
	self.lastSynCoordinateX = 0

	self.lastTargetX = 0;
	self.lastTargetY = 0;
	self.isReached = false
end

function BattleUnitMoveManager:removeSelf()
	self.class = nil;
end

function BattleUnitMoveManager:dispose()
    self:removeSelf();
end

function BattleUnitMoveManager:getLastSynCoordinateX()
	return self.lastSynCoordinateX;
end

function BattleUnitMoveManager:setLastSynCoordinateX(lastSynCoordinateX)
	self.lastSynCoordinateX = lastSynCoordinateX;
end

function BattleUnitMoveManager:setTargetX(targetX)
	self.targetX = targetX;
end

function BattleUnitMoveManager:setTargetY(targetY)
	self.targetY = targetY;
end

function BattleUnitMoveManager:getTargetX()
	return self.targetX;
end

function BattleUnitMoveManager:getTargetY()
	return self.targetY;
end

--是否到达目地
function BattleUnitMoveManager:isArrived(now)
	if self.battleUnit.actionManager:isOnMove() then
		return true;
	else
		return false;
	end
end
--同步当前位置消息
function BattleUnitMoveManager:sendRestPosMessage(x,y)
	if self.battleUnit:isDie() then
		return;
	end
	local mpm = {};
	mpm.CoordinateX = x;
	mpm.CoordinateY = y;
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.SubType = 15;
	if not self.battleUnit:getBattleField().battleProxy then return end
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end
--同步当前位置消息
function BattleUnitMoveManager:sendCurrentCoordinateXMessage()
	if self.battleUnit:isDie() then
		return;
	end
	local mpm = {};
	mpm.CoordinateX = self.battleUnit:getCoordinateX();
	mpm.CoordinateY = self.battleUnit:getCoordinateY();
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.SubType = 15;
	if not self.battleUnit:getBattleField().battleProxy then return end
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end

function BattleUnitMoveManager:setIsReachedData(bool)
	self.isReached = bool
end

function BattleUnitMoveManager:sendTargetCoordinateXMessage(needStop)
	if self.battleUnit:isDie() then
		return;
	end
	local mpm = {};
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.CoordinateX = self.battleUnit:getCoordinateX();
	mpm.CoordinateY = self.battleUnit:getCoordinateY();
	mpm.TargetCoordinateX = self.targetX;
	mpm.TargetCoordinateY = self.targetY;
	mpm.NeedStop = needStop
	mpm.BooleanValue = self.battleUnit:getCoordinateX() > self.targetX and 0 or 1;
	mpm.SubType = 16;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end

function BattleUnitMoveManager:sendJumpCoordinateXMessage()
	if self.battleUnit:isDie() then
		return;
	end
	local mpm = {};
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.CoordinateX = self.battleUnit:getCoordinateX();
	mpm.CoordinateY = self.battleUnit:getCoordinateY();
	mpm.TargetCoordinateX = self.targetX;
	mpm.TargetCoordinateY = self.targetY;
	mpm.BooleanValue = self.battleUnit:getCoordinateX() > self.targetX and 0 or 1;
	mpm.SubType = 45;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end