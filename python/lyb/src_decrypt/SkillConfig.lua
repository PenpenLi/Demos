SkillConfig = class();
--技能基础信息
function SkillConfig:ctor(config)
	self.class = SkillConfig;
	--// 剑君动作
	self.sword = nil;
	--// 拳皇动作
	self.fight = nil;
	--// 枪手动作
	self.spear = nil;
	--// 弓圣动作
	self.bow = nil;
	self.monster = nil;
	--/** 是否是普通攻击 **/
	self.commonAttack = nil;
	--/** 只算战力用到 1=攻击型技能 2=防御型技能 3=血量技能 **/
	self.property = nil;
	--/** 技能组(1无双技能，2武将技能) **/
	self.skillGroupId = nil;
	--/** 数值百分比 **/
	self.percentValue = nil;
	--// 学习技能需要等级
	self.requireLevel = nil;
	-- * 名将限定
	self.generalTableId = nil;
	-- * 消耗生命 百分比
	self.hpPercent = nil;
	-- * 技能释放时间
	self.castSkillTime = nil;
	self.requireSkillPo= nil;
	self.targetSkillEffects={};
	for key,value in pairs(config) do
		if key == "id" then--/** 技能ID **/
			self.skillId = value;
		elseif key == "number" then-- * 攻击人数
			self.attackCount = value;
		elseif key == "effect" then
			self.effectList = StringUtils:lua_string_split(value,",");
		elseif key == "effectAmount" then
			self.effectValueList = StringUtils:lua_string_split(value,",");
		elseif key == "effectUp" then
			self.effectUpValueList = StringUtils:lua_string_split(value,",");
		elseif key == "duration" then--// 持续时间
			self.effectLastTime = StringUtils:lua_string_split(value,",");
		elseif key == "xGJL" then
			self.effectPercentList = StringUtils:lua_string_split(value,",");
		else
			self[key] = value;
		end
	end
end

function SkillConfig:getAdditionParam()
	local value = BattleConstants.HUNDRED_THOUSAND;
	value = value + self.chuShiJiaChen;
	value = value + (self.level - 1) * self.jiaChenZenJia;
	return value;
end

function SkillConfig:getAdditionHurt()
	return self.chuShiFuJiaGongJi + (self.level-1)*self.chengZhangFuJiaGongJi;
end

function SkillConfig:removeSelf()
	self.class = nil;
end

function SkillConfig:dispose()
    self:removeSelf();
end

function SkillConfig:getRequireLevel() 
	return self.requireLevel;
end

function SkillConfig:setRequireLevel(requireLevel) 
	self.requireLevel = requireLevel;
end

function SkillConfig:getLevel() 
	return self.level;
end

function SkillConfig:setLevel(level) 
	self.level = level;
end

function SkillConfig:getGeneralTableId() 
	return self.generalTableId;
end

function SkillConfig:setGeneralTableId(generalTableId) 
	self.generalTableId = generalTableId;
end

function SkillConfig:getHpPercent() 
	return self.hpPercent;
end

function SkillConfig:setHpPercent(hpPercent) 
	self.hpPercent = hpPercent;
end

function SkillConfig:setRequireSkillPoint(requireSkillPoint) 
	self.requireSkillPo= requireSkillPoint;
end

function SkillConfig:getRequireSkillPoint() 
	return self.requireSkillPoint;
end

function SkillConfig:getCastSkillTime() 
	return self.castSkillTime;
end

function SkillConfig:getSkillId() 
	return self.skillId;
end

function SkillConfig:setSkillId(skillId) 
	self.skillId = skillId;
end

function SkillConfig:getName() 
	return self.name;
end

function SkillConfig:setName(name) 
	self.name = name;
end

function SkillConfig:getType() 
	return self.type;
end

function SkillConfig:setType(type) 
	self.type = type;
end

function SkillConfig:getSkillGroupId() 
	return self.skillGroupId;
end

function SkillConfig:setSkillGroupId(skillGroupId) 
	self.skillGroupId = skillGroupId;
end

function SkillConfig:getDelayTime() --技能间隔
	return self.time;
end


function SkillConfig:setValue(value) 
	self.value = value;
end

function SkillConfig:getMonster() 
	return self.monster;
end

function SkillConfig:getAttackCount() 
	return self.attackCount;
end

function SkillConfig:setAttackCount(attackCount) 
	self.attackCount = attackCount;
end

function SkillConfig:setCastSkillTime(castSkillTime) 
	self.castSkillTime = castSkillTime;
end

function SkillConfig:getEffectList() 
	return self.effectList
end

function SkillConfig:setEffectList(effectList) 
	self.effectList = effectList;
end

function SkillConfig:getEffectValueList() 
	return self.effectValueList
end

function SkillConfig:setEffectValueList(effectValueList) 
	self.effectValueList = effectValueList;
end

function SkillConfig:getEffectUpValueList() 
	return self.effectUpValueList
end

function SkillConfig:getEffectLastTime() 
	return self.effectLastTime;
end
function SkillConfig:getEffectPercentList()
	return self.effectPercentList;
end
function SkillConfig:getCommonAttack() 
	return self.commonAttack;
end

function SkillConfig:setCommonAttack(commonAttack) 
	self.commonAttack = commonAttack;
end

function SkillConfig:getSword() 
	return self.sword;
end

function SkillConfig:getFight() 
	return self.fight;
end

function SkillConfig:getSpear() 
	return self.spear;
end

function SkillConfig:getBow() 
	return self.bow;
end

function SkillConfig:getProperty() 
	return self.property;
end

function SkillConfig:setSword(sword) 
	self.sword = sword;
end

function SkillConfig:setSpear(spear) 
	self.spear = spear;
end

function SkillConfig:setBow(bow) 
	self.bow = bow;
end

function SkillConfig:isAttackSkill() 
	return self.property==BattleConstants.SKILL_TYPE_ATTACK;
end

function SkillConfig:isDefenceSkill() 
	return self.property==BattleConstants.SKILL_TYPE_DEFENCE;
end

function SkillConfig:isHpSkill() 
	return self.property==BattleConstants.SKILL_TYPE_HP;
end

function SkillConfig:calcWuShuangHurtValue()
	--log("=========SkillConfig-calcWuShuangHurtValue=======")
	return 0;
end

function SkillConfig:getSeltctTargetType()
	return self.jnmblx;
end
function SkillConfig:getTargetSkillEffects()
	return self.targetSkillEffects;
end
function SkillConfig:getTargetSkillEffect(effectId)
	for k,v in pairs(self.targetSkillEffects) do
		if v:getEffectId() == effectId then
			return v;
		end
	end
end
function SkillConfig:setTargetSkillEffects(effect)
	table.insert(self.targetSkillEffects,effect);
end