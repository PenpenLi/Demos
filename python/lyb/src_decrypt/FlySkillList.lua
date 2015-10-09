FlySkillList = class();
function FlySkillList:ctor(battleField)
	self.class = FlySkillList;
	self.battleField = battleField;
	self.flyUniMap = {};
	self.firstTeam = nil;
	self.secondTeam = nil;
	self.flaySkillId = 0;
end
function FlySkillList:removeSelf()
	self.class = nil;
end

function FlySkillList:dispose()
	self:removeSelf();
end

function FlySkillList:update(now)
	for k,v in pairs(self.flyUniMap) do
		v:update(now);
		if v:isOver() then
			table.remove(self.flyUniMap,k);
		end
	end
end
function FlySkillList:addFireballUnit(flyId,caster,skillMgr,target)
	require("main.controller.command.battleScene.battle.battlefield.unit.impl.FireballUnit");
	local flyUnit = FireballUnit.new(self,caster,flyId,skillMgr,target);
	table.insert(self.flyUniMap,flyUnit);
end
function FlySkillList:addFireRainUnit(flyId,caster,skillMgr,target)
	require("main.controller.command.battleScene.battle.battlefield.unit.impl.FireRainUnit");
	local flyUnit = FireRainUnit.new(self,caster,flyId,skillMgr,target);
	table.insert(self.flyUniMap,flyUnit);
end
function FlySkillList:getBattleField()
	return self.battleField;
end

function FlySkillList:getFirstTeam()
	return self.firstTeam;
end

function FlySkillList:setFirstTeam(firstTeam)
	self.firstTeam = firstTeam;
end

function FlySkillList:getSecondTeam()
	return self.secondTeam;
end

function FlySkillList:setSecondTeam(secondTeam)
	self.secondTeam = secondTeam;
end
function FlySkillList:sendBorenMessage(SkillId,source,target)
	self.flaySkillId = self.flaySkillId+1;
	local mpm = {};
	mpm.FlyUnitID = self.flaySkillId;
	mpm.BattleUnitID = source:getObjectId();
	mpm.TargetBattleUnitID = target:getObjectId();
	mpm.SkillId = SkillId;
	mpm.CoordinateX = source:getCoordinateX();
	mpm.CoordinateY = source:getCoordinateY();
	mpm.TargetCoordinateX = target:getCoordinateX();
	mpm.TargetCoordinateY = target:getCoordinateY();
	mpm.SubType = 47;
	self:getBattleField().battleProxy:sendAIMessage(mpm)
end
function FlySkillList:onRemoveAll()
	for k,v in pairs(self.flyUniMap) do
		v:onRemvoeFlySkill();
	end
end