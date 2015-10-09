SkillEffectModel = class();

function SkillEffectModel:ctor(level,skillId,effectId,rate)--,value,lastTime,rate,skillEffectConfig
	self.class = SkillEffectModel;
	--// 发生几率
	self.rate = rate;
	self.skillId = skillId;
	self.level = level or 1;
	self.skillEffectConfig = analysis("Jineng_Jinengxiaoguo",effectId);
	--// 百分比
	self.persent = self.skillEffectConfig.chuShiJiaChen+self.skillEffectConfig.jiaChenZenJia*(self.level-1);
	--// 效果值
	self.value = self.skillEffectConfig.chuShiFuJiaGongJi+self.skillEffectConfig.chengZhangFuJiaGongJi*(self.level-1);
	--  * 持续回合
	self.duration = self.skillEffectConfig.duration or 0;
	self.lastFrame = tonumber(self.duration)/BattleConstants.Frame_Time;
	self.intervalRound = self.skillEffectConfig.interval or 0;--间隔时间
	self.intervalFrame = tonumber(self.intervalRound)/BattleConstants.Frame_Time;
end

function SkillEffectModel:removeSelf()
	self.class = nil;
end

function SkillEffectModel:dispose()
    self:removeSelf();
end

function SkillEffectModel:getValue()
	return self.value;
end

function SkillEffectModel:getLastFrame()
	return self.lastFrame;
end

function SkillEffectModel:getRate()
	return self.rate;
end

function SkillEffectModel:getSkillId()
	return self.skillId;
end

function SkillEffectModel:getSkillType()
	return analysis("Jineng_Jineng",self.skillId,"typyP");
end

function SkillEffectModel:getEffectId()
	return self.skillEffectConfig.id;
end
function SkillEffectModel:getSkillLevel()
	return self.level;
end
function SkillEffectModel:getSkillEffectConfig()
	return self.skillEffectConfig;
end

function SkillEffectModel:getLastType()
	return self.skillEffectConfig.continued;
end

function SkillEffectModel:getSkillEffType()
	return self.skillEffectConfig.skitype;
end

function SkillEffectModel:isBeAttack()
	return tonumber(self.skillEffectConfig.action)==1;
end

function SkillEffectModel:getPersent()
	return self.persent;
end


function SkillEffectModel:isWai()
	return self:isDamType(BattleConstants.SKILL_EFFECT_DAM_TYPE_1);
end

function SkillEffectModel:isDamType(damType)
	if self.skillEffectConfig.damType == damType then
		return true;
	end
	return false;
end