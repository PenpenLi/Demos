FireballUnit = class();
function FireballUnit:ctor(fireballList,caster,fireballId,skillMgr,target)
	self.class = FireballUnit;
	self.fireballList = fireballList;
	self.theCaster = caster;
	self.target = target;
	self.attackIsOver = false;
	self.fireballId = fireballId;
	self.skillMgr = skillMgr;
	self:init();
end
function FireballUnit:getId()
	return self.fireballId;
end
function FireballUnit:dispose()
	
end
function FireballUnit:setCoordinateX(cx)
	self.coordinateX = cx;
end
function FireballUnit:setCoordinateY(cy)
	self.coordinateY = cy;
end
function FireballUnit:getCoordinateX()
	return self.coordinateX;
end
function FireballUnit:getCoordinateY()
	return self.coordinateY;
end
function FireballUnit:init()
	self:setCoordinateX(self.theCaster:getCoordinateX());
	self:setCoordinateY(self.theCaster:getCoordinateY());
	require("main.controller.command.battleScene.battle.battlefield.flySkill.FlySkillFollowManager")
	self.flySkillFollowManager = FlySkillFollowManager.new(self);
	self.flySkillFollowManager:moveStart();
end
function FireballUnit:update(now)
	if self.flySkillFollowManager:isArrived() then
		self.skillMgr:updataAttack();
		self:onAttackOver();
	else
		self.flySkillFollowManager:update(now);--执行效果
	end
end

function FireballUnit:getFireballList()
	return self.fireballList;
end
function FireballUnit:getFlyFollowManager()
	return self.flySkillFollowManager;
end
function FireballUnit:getBattleField()
	return self.fireballList:getBattleField();
end

function FireballUnit:getTheCaster()
	return self.theCaster;
end
function FireballUnit:getTarget()
	return self.target;
end
function FireballUnit:getSkillMgr()
	return self.skillMgr;
end

function FireballUnit:isOver()
	return self.attackIsOver;
end

function FireballUnit:onAttackOver()
	self.attackIsOver = true;
end

function FireballUnit:onRemvoeFlySkill()
	self.flySkillFollowManager:onRemoveEffect();
end