FlySkillAttackManager = class();
function FlySkillAttackManager:ctor(flyUnit)
	self.class = FlySkillAttackManager;
	self.flyUnit = flyUnit;
	self.isAttack = false;
	self.startX = 0;
	self.startY = 0;
	self.selectTargetFun = nil;
end

function FlySkillAttackManager:removeSelf()
	self.class = nil;
end

function FlySkillAttackManager:dispose()
    self:removeSelf();
end
function FlySkillAttackManager:configSectorEndXY(sx,sy,ex,ey,dis)
	local dx = ex-sx;
	local dy = ey-sy;
	local dc = math.sqrt(dx*dx+dy*dy);
	print("configSectorEndXY",dc,dis)
	if dc > dis then
		local r = math.deg(math.atan(math.abs(dy/dx)))*2;
		dx = dis*math.cos(math.rad(r))*(dx/math.abs(dx));
		dy = dis*math.sin(math.rad(r))*(dy/math.abs(dy));
		ex = sx+dx;
		ey = sy+dy;
	end
	return ex,ey;
end
function FlySkillAttackManager:attackStart()
	local skill = self.flyUnit:getSkill();
	self.selectTargetFun = skill:getSelectTargetFun();
	local config = skill:getSkillActionConfig();--:getSkillConfig()
	local dis = config.attackDistance;
	self.startX = self.flyUnit:getCoordinateX();
	self.startY = self.flyUnit:getCoordinateY();
	if not self.flyUnit.clickPosition and self.flyUnit:getTheCaster():haveTarget() then
		self.target = self.flyUnit:getTheCaster():getTarget();
		self.startX = self.target:getCoordinateX();
		self.startY = self.target:getCoordinateY();
	end
	if not self.flyUnit.clickPosition then 
		self.flyUnit.clickPosition = ccp(self.startX,self.startY);
	end
	local endX,endY = self:configSectorEndXY(self.startX,self.startY,self.flyUnit.clickPosition.x,self.flyUnit.clickPosition.y,dis);
	self.flyUnit:setCoordinateX(endX);
	self.flyUnit:setCoordinateY(endY);
	self:sendTargetAttackMessage();
end
function FlySkillAttackManager:getValue(value,defaultV)
	defaultV = not defaultV and 0 or defaultV;
	if(value == nil or value == "#" or value == "") then
		return defaultV;
	else
		return value;
	end	
end
function FlySkillAttackManager:isAttacked()
	return self.isAttack;
end

function FlySkillAttackManager:updateAttack(now)

	local skill = self.flyUnit:getSkill();
	local targets = self.selectTargetFun(self.flyUnit:getTheCaster(),ccp(self.flyUnit.clickPosition.x,self.flyUnit.clickPosition.y), skill);
	if #targets == 0 then return end
	local hitMpm = BattleFormula:stateBeAttack(self.flyUnit:getTheCaster(),targets,0,0,skill);
	CastSkillCompute:getInstance():castSkillBeAttack(self.flyUnit:getTheCaster(), target, skill,hitMpm);
	self.isAttack = true;
end

function FlySkillAttackManager:attackOver()
	self.flyUnit:onAttackOver();
end

function FlySkillAttackManager:sendTargetAttackMessage()
	local mpm = {};
	local skill = self.flyUnit:getSkill();
	mpm.FlyUnitID = self.flyUnit:getId();
	mpm.BattleUnitId = self.flyUnit:getTheCaster():getObjectId();
	mpm.SkillId = skill.id;
	mpm.CoordinateX = self.flyUnit:getCoordinateX();
	mpm.CoordinateY = self.flyUnit:getCoordinateY();
	mpm.SubType = 47;
	self.flyUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end