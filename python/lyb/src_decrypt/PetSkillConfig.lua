
PetSkillConfig = class(SkillBaseConfig);
--无双技
function PetSkillConfig:ctor(config)
	self.class = PetSkillConfig;
	-- 剑君动作
	--Mapping
	self.sword = nil;
	-- 拳皇动作
	--Mapping
	self.fight = nil;
	-- 枪手动作
	--Mapping
	self.spear = nil;
	-- 弓圣动作
	--Mapping
	self.bow = nil;
	--Mapping
	self.monster = nil;

	-- 技能名称 **/
	-- --Mapping(column="name")
	self.name = nil;
	-- 是否是普通攻击 **/
	--Mapping()
	self.commonAttack = nil;
	-- 只算战力用到 1=攻击型技能 2=防御型技能 3=血量技能 **/
	--Mapping()
	self.property = nil;
	-- 技能类型 1为伤害技能，2为辅助技能，3为特殊技能--
	--Mapping(column = "type")
	self.type = nil;
	-- 技能准备时间 **/
	-- 冷却时间，控制当前技能
	--Mapping(column = "cd")
	--self.prepareTime;
	-- 技能组(1无双技能，2武将技能) **/
	self.skillGroupId = nil;
	-- 数值百分比 **/
	self.percentValue = nil;
	--Mapping(column = "percentage")
	--self.percentValueStr;
	-- 数值 **/
	--Mapping(column = "amount")
	--self.value;
	--
	--攻击人数
	--
	--Mapping(column = "number")
	--self.attackCount;
	-- 学习技能需要等级
	self.requireLevel = nil;
	--Mapping(column = "lv")
	--self.skillLevel;
	--
	--名将限定
	--
	self.generalTableId = nil;

	--
	--消耗生命 百分比
	--
	self.hpPercent = nil;
	--Mapping(column = "consumption")
	--self.hpPercentStr;

	--
	--命中公式
	--
	-- --Mapping(column = "formula")
	-- self.mzgs;
	--
	--技能释放时间
	--
	self.castSkillTime = nil;
	--Mapping(column = "effect")
	--self.effectList;
	--Mapping(column = "effectAmount")
	--self.effectValueList;
	-- 持续时间
	--Mapping(column = "duration")
	--self.effectLastTime;
	--Mapping(column = "probability")
	--self.effectPercentList;
	--Mapping(column = "time")
	-- 释放完当前技能后多长时间才能释放下一个技能
	self.delayTime = nil;
	self.requireSkillPo= nil;

	for key,value in pairs(config) do
		if key == "id" then
			--/** 技能ID **/
			--@Mapping(column = "id")
			self.skillId = value;
		elseif key == "num" then
			--/** 技能名称 **/
			--// @Mapping(column="name")
			self.num = value;
		elseif key == "cd" then
			--/** 技能准备时间 **/
			--// 冷却时间，控制当前技能
			--@Mapping(column = "cd")
			self.prepareTime = value;
		elseif key == "percentage" then
			--@Mapping(column = "percentage")
			self.percentValue = value;
		elseif key == "amount" then
			--/** 数值 **/
			--@Mapping(column = "amount")
			self.value = value;
		elseif key == "number" then
			--/**
			-- * 攻击人数
			-- */
			--@Mapping(column = "number")
			self.attackCount = value;
		elseif key == "lv" then
			--@Mapping(column = "lv")
			self.level = value;
		elseif key == "consumption" then
			--@Mapping(column = "consumption")
			self.hpPercentStr = value;
		elseif key == "effect" then
			--@Mapping(column = "effect")
			self.effectList = StringUtils:lua_string_split(value,",");
		elseif key == "effectAmount" then
			--@Mapping(column = "effectAmount")
			self.effectValueList = StringUtils:lua_string_split(value,",");
		elseif key == "effectUp" then
			self.effectUpValueList = StringUtils:lua_string_split(value,",");
		elseif key == "duration" then
			--// 持续时间
			--@Mapping(column = "duration")
			self.effectLastTime = value;
		elseif key == "probability" then
			--@Mapping(column = "probability")
			self.effectPercentList = StringUtils:lua_string_split(value,",");
		elseif key == "time" then
			--@Mapping(column = "time")
			--// 释放完当前技能后多长时间才能释放下一个技能
			self.delayTime = value;
		else
			self[key] = value;
		end
	end
end

function PetSkillConfig:removeSelf()
	self.class = nil;
end

function PetSkillConfig:dispose()
    self:removeSelf();
end

function PetSkillConfig:getRequireLevel()
		return self.requireLevel;
end

function PetSkillConfig:getNum()
		return self.num;
end

function PetSkillConfig:setRequireLevel(requireLevel)
		self.requireLevel = requireLevel;
end

function PetSkillConfig:getGeneralTableId()
		return self.generalTableId;
end

function PetSkillConfig:setGeneralTableId(generalTableId)
		self.generalTableId = generalTableId;
end

function PetSkillConfig:getHpPercent()
		return self.hpPercent;
end

function PetSkillConfig:setHpPercent(hpPercent)
		self.hpPercent = hpPercent;
end

function PetSkillConfig:setRequireSkillPoint(requireSkillPoint)
		self.requireSkillPo= requireSkillPoint;
end

function PetSkillConfig:getRequireSkillPoint()
		return self.requireSkillPoint;
end

function PetSkillConfig:getCastSkillTime()
		return self.castSkillTime;
end

function PetSkillConfig:getSkillId()
		return self.skillId;
end

function PetSkillConfig:setSkillId(skillId)
		self.skillId = skillId;
end

function PetSkillConfig:getName()
		return self.name;
end

function PetSkillConfig:setName(name)
		self.name = name;
end

function PetSkillConfig:getType()
		return self.type;
end

function PetSkillConfig:setType(type)
		self.type = type;
end

function PetSkillConfig:getPrepareTime()
		return self.prepareTime;
end

function PetSkillConfig:getSkillGroupId()
		return self.skillGroupId;
end

function PetSkillConfig:setSkillGroupId(skillGroupId)
		self.skillGroupId = skillGroupId;
end

function PetSkillConfig:getDelayTime()
		return self.delayTime;
end

function PetSkillConfig:getPercentValue(addition)
		return self.percentValue;
end

function PetSkillConfig:getValue()
		return self.value;
end

function PetSkillConfig:setValue(value)
		self.value = value;
end

function PetSkillConfig:getMonster()
		return self.monster;
end

function PetSkillConfig:getAttackCount()
		return self.attackCount;
end

function PetSkillConfig:setAttackCount(attackCount)
		self.attackCount = attackCount;
end

function PetSkillConfig:setCastSkillTime(castSkillTime)
		self.castSkillTime = castSkillTime;
end

--@Override
function PetSkillConfig:setPercentValue(percentValue)
		self.percentValue = percentValue;

end

function PetSkillConfig:getPercentValueStr()
		return self.percentValueStr;
end

function PetSkillConfig:setPercentValueStr(percentValueStr)
		self.percentValueStr = percentValueStr;
end

function PetSkillConfig:getHpPercentStr()
		return self.hpPercentStr;
end

function PetSkillConfig:getEffectList()
		return self.effectList;
end

function PetSkillConfig:setEffectList(effectList)
		self.effectList = effectList;
end

function PetSkillConfig:getEffectValueList()
		return self.effectValueList;
end
function PetSkillConfig:getEffectUpValueList()
		return self.effectUpValueList;
end
function PetSkillConfig:setEffectValueList(effectValueList)
		self.effectValueList = effectValueList;
end

function PetSkillConfig:getEffectLastTime()
		return self.effectLastTime;
end

function PetSkillConfig:getEffectPercentList()
		return self.effectPercentList;
end

function PetSkillConfig:setEffectPercentList(effectPercentList)
		self.effectPercentList = effectPercentList;
end

function PetSkillConfig:getCommonAttack()
		return self.commonAttack;
end

function PetSkillConfig:setCommonAttack(commonAttack)
		self.commonAttack = commonAttack;
end

function PetSkillConfig:getSword()
		return self.sword;
end

function PetSkillConfig:getFight()
		return self.fight;
end

function PetSkillConfig:getSpear()
		return self.spear;
end

function PetSkillConfig:getBow()
		return self.bow;
end

function PetSkillConfig:getProperty()
		return self.property;
end

function PetSkillConfig:setSword(sword)
		self.sword = sword;
end

function PetSkillConfig:setSpear(spear)
		self.spear = spear;
end

function PetSkillConfig:setBow(bow)
		self.bow = bow;
end

function PetSkillConfig:isAttackSkill()
		return self.property==BattleConstants.SKILL_TYPE_ATTACK;
end

function PetSkillConfig:isDefenceSkill()
		return self.property==BattleConstants.SKILL_TYPE_DEFENCE;
end

function PetSkillConfig:isHpSkill()
		return self.property==BattleConstants.SKILL_TYPE_HP;
end

--@Override
function PetSkillConfig:getSkillLevel()
		return self.skillLevel;
end

--@Override
function PetSkillConfig:calcPerventValue(addition)
		return 1;
end

--@Override
function PetSkillConfig:calcWJSkillPercentValue()
		return self.percentValue;
end

function PetSkillConfig:calcWuShuangHurtValue()
	--log("=========PetSkillConfig-calcWuShuangHurtValue=======")
	return 0;
end