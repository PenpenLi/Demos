FlySkillMoveManager = class();
function FlySkillMoveManager:ctor(flyUnit)
	self.class = FlySkillMoveManager;
	self.flyUnit = flyUnit;
	self.speedX = 0;
	self.speedY = 0;
	self.startTime = 0;
	self.needTime = 0;
	self.isArrive = false;
	self.startX = 0;
	self.startY = 0;
	self.selectIdArr = {};
	self.selectTargetFun = nil;
end

function FlySkillMoveManager:removeSelf()
	self.class = nil;
end

function FlySkillMoveManager:dispose()
    self:removeSelf();
end
function FlySkillMoveManager:configSectorEndXY(sx,sy,ex,ey)
	local dx = ex-sx;
	local dy = ey-sy;
	local dc = math.sqrt(dx*dx+dy*dy);
	local r = math.deg(math.atan(math.abs(dy/dx)))*2;
	local rc = analysis("Xishuhuizong_Xishubiao",1030,"constant");
	if r > rc then
		dx = dc*math.cos(math.rad(rc*0.5))*(dx/math.abs(dx));
		dy = dc*math.sin(math.rad(rc*0.5))*(dy/math.abs(dy));
		ex = sx+dx;
		ey = sy+dy;
	end
	return ex,ey;
end
function FlySkillMoveManager:moveStart()
	local skill = self.flyUnit:getSkill();
	self.selectTargetFun = skill:getSelectTargetFun();
	local config = skill:getSkillActionConfig();--:getSkillConfig()
	local dis = config.attackDistance;
	local isSector = tonumber(config.attackShape)==BattleConfig.SKILL_SECTOR_ID;
	local speed = self:cfgSpeed(config.feixingTexiaoSudu);
	self.startX = self.flyUnit:getCoordinateX();
	self.startY = self.flyUnit:getCoordinateY();

	if self.flyUnit:getTheCaster():haveTarget() or self.flyUnit.clickPosition then 
		local target = self.flyUnit:getTheCaster():getTarget();
		local mx,my = 0,0;
		if self.flyUnit.clickPosition then
			mx,my = self.flyUnit.clickPosition.x,self.flyUnit.clickPosition.y;
			if isSector then
				mx,my = self:configSectorEndXY(self.startX,self.startY,mx,my);
			end
		else
			mx,my = target:getCoordinateX(),target:getCoordinateY();
		end
		local dX = mx - self.startX;
		local dY = my - self.startY;
		local dC = math.sqrt(dX*dX+dY*dY);

		self.speedX = speed*dX/dC;
		self.speedY = speed*dY/dC;

		self.speedY = 0;--只横着飞 如果需要斜着飞去掉这行
	else
		local faceDirect = self.flyUnit:getTheCaster():getFaceDirect();
		self.speedX = speed*faceDirect;
		self.speedY = 0;
	end
	self.needTime = math.abs(dis/speed);
	self:sendTargetMoveMessage();
	if self.speedX>0 then
		self.startX = self.flyUnit:getCoordinateX()+self:getValue(config.feixingTexiaoX);
	else
		self.startX = self.flyUnit:getCoordinateX()-self:getValue(config.feixingTexiaoX);
	end
	self.startY = self.flyUnit:getCoordinateY();--+self:getValue(config.feixingTexiaoY);
	self.flyUnit:setCoordinateX(self.startX);
	self.flyUnit:setCoordinateY(self.startY);
end
function FlySkillMoveManager:getValue(value,defaultV)
	defaultV = not defaultV and 0 or defaultV;
	if(value == nil or value == "#" or value == "") then
		return defaultV;
	else
		return value;
	end	
end
function FlySkillMoveManager:cfgSpeed(EffectTime)
	if not EffectTime then
		EffectTime = 0.3;
	elseif EffectTime > 10 then
		EffectTime = EffectTime/1000.0;
	else
		EffectTime = EffectTime*0.3;
	end
	return EffectTime;
end
function FlySkillMoveManager:isArrived()
	return self.isArrive;
end

function FlySkillMoveManager:updateMove(now)
	if self.startTime <= 0 then 
		self.startTime = now;
	end
	local moveX = self.startX + self.speedX*(now-self.startTime);
	--local moveY = self.startY + self.speedY*(now-self.startTime);

	self.flyUnit:setCoordinateX(moveX);
	--self.flyUnit:setCoordinateY(moveY);
	self.isArrive = (now - self.startTime > self.needTime);
end
function FlySkillMoveManager:isAttack()
	return true;
end

function FlySkillMoveManager:updateAttack(now)
	local newTargers = {};
	local skill = self.flyUnit:getSkill();
	local targets = self.selectTargetFun(self.flyUnit:getTheCaster(),ccp(self.flyUnit:getCoordinateX(),self.flyUnit:getCoordinateY()), skill);
	for i, v in ipairs(targets) do 
		local objId = v:getObjectId();
		local isHave = false;
		for j, key in ipairs(self.selectIdArr) do 
			if objId == key then
				isHave = true;
				break;
			end
		end
		if not isHave then

			table.insert(self.selectIdArr,objId);
			table.insert(newTargers,v);
		end
	end;
	if #newTargers == 0 then return end
	local hitMpm = BattleFormula:stateBeAttack(self.flyUnit:getTheCaster(),newTargers,0,0,skill);
	CastSkillCompute:getInstance():castSkillBeAttack(self.flyUnit:getTheCaster(), target, skill,hitMpm);
end


function FlySkillMoveManager:moveOver()
	self.flyUnit:onAttackOver();
end

function FlySkillMoveManager:sendTargetMoveMessage()
	local mpm = {};
	local skill = self.flyUnit:getSkill();
	mpm.FlyUnitID = self.flyUnit:getId();
	mpm.BattleUnitId = self.flyUnit:getTheCaster():getObjectId();
	mpm.SkillId = skill.id;
	mpm.CoordinateX = self.flyUnit:getCoordinateX();
	mpm.CoordinateY = self.flyUnit:getCoordinateY();
	mpm.TargetCoordinateX = mpm.CoordinateX+self.speedX*self.needTime;
	mpm.TargetCoordinateY = mpm.CoordinateY; -- +self.speedY*self.needTime;
	mpm.SpeedX = self.speedX;
	mpm.SpeedY = 0; -- self.speedY;
	mpm.SubType = 47;
	self.flyUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end