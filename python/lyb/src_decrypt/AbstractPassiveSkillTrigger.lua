AbstractPassiveSkillTrigger = class();

function AbstractPassiveSkillTrigger:ctor()
	self.class = AbstractPassiveSkillTrigger;
end

function AbstractPassiveSkillTrigger:removeSelf()
	self.class = nil;
end

function AbstractPassiveSkillTrigger:dispose()
	self.skillConfig = nil
    self:removeSelf();
end

function AbstractPassiveSkillTrigger:init(config)
	self.skillConfig = config;
end

function AbstractPassiveSkillTrigger:checkAndCreateEffect(source)
	if source:isDieAway() then
		return;
	end
	--技能触发次数限制
	if source:getPassiveSkillUseCount(self.skillConfig:getSkillId()) > self.skillConfig:getTriggerMaxCount() then
		return;
	end
	for k1,model in pairs(self.skillConfig:getSkillEffects()) then
		if model:checkHappen() then
			self:innerInstallEffect(source, model);
		end
	end
end
