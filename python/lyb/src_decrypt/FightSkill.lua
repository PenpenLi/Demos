FightSkill = class();
function FightSkill:ctor(grade,config,career,type,level,battleType)
	self.class = FightSkill;
	self.id = config.skillId;
	self.grade = grade;--TODO去掉   fjm
	--print("=SkillConfig=============pet01")
	--print("000000000000000000000000=="..career)
	-- if self.id == 1020 then
	-- 	local  aaaaaa = 1

	-- end
	self.skillConfig = config
	self.career = career;
	--普通攻击，武将技能，无双技能
	self.type = type;
	--无双技能所属的英魂
	self.wuShuangSkillowner = nil
	--冷却cd时间
	self.coolingTime = 0
	--间隔时间
	self.intervalTime = 0
	--无双
	self.wushuangAddition = 0
	
	self.duangjnzdid = battleType ~= BattleConfig.BATTLE_TYPE_2 and config.duangjnzdid or 0
	-- 附加伤害
	self.additionHurt = 0;
	-- 技能加成系数
	self.additionParam = 0;
	
	if level then
		self.level = level
	else
		self.level = 1
	end
	self:fillFightSkill();

end

function FightSkill:fillFightSkill()
	local level = self:getLevel();
	self:setAdditionParam(self:_getSkillAdditionPercent(level));
	self:setAdditionHurt(self:_getAdditionHurt(level));
end

function FightSkill:_getSkillAdditionPercent(level)
	local value = BattleConstants.HUNDRED_THOUSAND;
	value = value + self.skillConfig.chuShiJiaChen;
	value = value + (level - 1) * self.skillConfig.jiaChenZenJia;
	return value;
end

function FightSkill:_getAdditionHurt( level )
	return self.skillConfig.chuShiFuJiaGongJi + (level-1)*self.skillConfig.chengZhangFuJiaGongJi;
end

function FightSkill:removeSelf()
	self.class = nil;
end

function FightSkill:dispose()
	self.cleanSelf();
end

function FightSkill:getGeneralGrade()
	return self.grade;
end

function FightSkill:getWushuangAddition()
	return self.wushuangAddition
end

function FightSkill:getRageMax()
	return self.skillConfig.rage
end

function FightSkill:isNeedHurt()
	return self.skillConfig.jiSuanMa == 1--jiSuanMa
end

function FightSkill:fillEffectData()
	--print("============self.career=="..self.career)
	--print(self.skillConfig.skillId)
	--self.skillConfig:setPercentValue(self.skillConfig:getPercentValueStr());
	local effectList = self.skillConfig:getEffectList();
	local effectValueList = self.skillConfig:getEffectValueList();
	local effectUpValueList = self.skillConfig:getEffectUpValueList();
	--持续时间
	local effectLastTime = self.skillConfig:getEffectLastTime();
	local effectPercentList = self.skillConfig:getEffectPercentList();

	-- if #effectList ~= #effectValueList and #effectList ~= #effectLastTime and #effectList ~= #effectPercentList then
	-- 	throw new DataFormatException("技能效果列  配置数量不一致 skillId=" + skillConfig.getSkillId());
	-- end
	if effectList[1] == "0" then return;end
	for j = 1,#effectList do
		local id = tonumber(effectList[j]);
		if id > 0 then
			local skillEffectConfig = analysis("Jineng_Jinengxiaoguo",id)
			if not skillEffectConfig then
			 	log("不存在的技能效果 skillId=" + skillConfig.getSkillId() + " effectId=" + id);
			end
			local skillEffect = SkillEffectModel.new(effectValueList[j]+effectUpValueList[j]*(self:getLevel()-1), effectLastTime,100000, self.skillConfig:getSkillId(), skillEffectConfig);
			skillEffect:setHatredFactor(0);
			self.skillConfig:setTargetSkillEffects(skillEffect);
		end
	end
end

function FightSkill:isWushuang()
	return self.skillConfig:isWushuang();
end

function FightSkill:getId()
	return self.id;
end

function FightSkill:getTarget()
	return self.skillConfig:getTarget(self.career);
end

function FightSkill:getCareer()
	return self.career;
end

function FightSkill:setId(id)
	self.id = id;
end

function FightSkill:getSkillGroupId()
	return self.skillConfig:getSkillGroupId();
end

function FightSkill:setGreenBattleDistance(addDistance)
	self.skillConfig:setGreenBattleDistance(addDistance)
end

function FightSkill:getLevel()
	return self.level
end

function FightSkill:getFirsCDTime()
	return self.skillConfig.FristCD
end

function FightSkill:getGrade()
	return self.grade
end

function FightSkill:getSkillConfig()
	return self.skillConfig;
end

function FightSkill:getCaskSkillTime(source)
	return self.skillConfig:getCaskSkillTime(source, self.career);
end
function FightSkill:getPauseTime()
	return self.skillConfig:getPauseTime();
end
function FightSkill:hasQTE()
	return self.skillConfig:hasQTE();
end
function FightSkill:setSkillConfig(skillConfig)
	self.skillConfig = skillConfig;
end

function FightSkill:getSkillId()
	return self.skillConfig.skillId;
end

function FightSkill:getWuShuangSkillowner()
	return self.wuShuangSkillowner;
end

function FightSkill:setWuShuangSkillowner(wuShuangSkillowner)
	self.wuShuangSkillowner = wuShuangSkillowner;
end

function FightSkill:setCoolingTime(coolingTime)
	--print("coolingTimecoolingTime=="..coolingTime)
	self.coolingTime = coolingTime;
end

function FightSkill:getType()
	return self.type;
end

function FightSkill:isType(typeT)
	return typeT == self.type
end
--技能冷却时间
function FightSkill:getCoolingTime()
	return self.coolingTime;
end

function FightSkill:getSkillActionConfig()
	return self.skillConfig:getSkillActionConfig();
end
function FightSkill:getSelectTargetFun()
	return self.skillConfig:getSelectTargetFun();
end
function FightSkill:setIntervalTime(intervalTime)
	self.intervalTime = intervalTime;
end

function FightSkill:getIntervalTime()
	return self.intervalTime;
end

function FightSkill:getCount()
		return count;
end

function FightSkill:addCount()
	self.count = self.count + 1
end

function FightSkill:setAdditionHurt(additionHurt)
	self.additionHurt = additionHurt;
	return self;
end

function FightSkill:getAdditionHurt()
	return self.additionHurt;
end

function FightSkill:setAdditionParam(additionParam)
	self.additionParam = additionParam;
	return self;
end

function FightSkill:getAdditionParam()
	return self.additionParam;
end

function FightSkill:getSeltctTargetType()
	return self.skillConfig.seltctTargetType
end

