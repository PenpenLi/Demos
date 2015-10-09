
PassiveSkillConfig = class(SkillBaseConfig);
--"被动技能"
function PassiveSkillConfig:ctor(config)
	self.class = PassiveSkillConfig;
	for key,value in pairs(config) do
		if key == "num" then
			self.num = value;
		elseif key == "id" then
			self.skillId = value;
		elseif key == "lv" then
			self.skillLevel = value;
		elseif key ==  "cftj" then
			self.triggerId = value;
		elseif key == "cfcsh" then
			self.triggerValue = value;
		elseif key == "shfdx" then--释放对象
			self.attackType = value;	
		elseif key == "effect" then
			self.effectList = StringUtils:lua_string_split(value,",");
		elseif key == "effectAmount" then
			self.effectValueList = StringUtils:lua_string_split(value,",");
		elseif key == "effectUp" then
			self.effectUpValueList = StringUtils:lua_string_split(value,",");
		elseif key ==  "duration" then--持续时间
			self.effectLastTime = value;
		elseif key == "probability" then
			self.effectPercentList = StringUtils:lua_string_split(value,",");
		elseif key == "chfcsh" then--触发次数
			self.triggerMaxCount = value;
		else
			self[key] = value;
		end
	end
	self.skillEffects ={}
	self.skillTrigger = nil
end

function PassiveSkillConfig:removeSelf()
	self.class = nil;
end

function PassiveSkillConfig:dispose()
    self:removeSelf();
end

function PassiveSkillConfig:getSkillId()
		return self.skillId;
end


function PassiveSkillConfig:getSkillLevel()
		return self.skillLevel;
end

function PassiveSkillConfig:getTriggerId()
		return self.triggerId;
end

function PassiveSkillConfig:getTriggerValue()
		return self.triggerValue;
end

function PassiveSkillConfig:getAttackType()
		return self.attackType;
end

function PassiveSkillConfig:getEffectList()
		return self.effectList;
end

function PassiveSkillConfig:getEffectValueList()
		return self.effectValueList;
end
function PassiveSkillConfig:getEffectUpValueList()
		return self.effectUpValueList;
end
function PassiveSkillConfig:getEffectLastTime()
		return self.effectLastTime;
end

function PassiveSkillConfig:getEffectPercentList()
		return self.effectPercentList;
end

function PassiveSkillConfig:getTriggerMaxCount()
		return self.triggerMaxCount;
end

function PassiveSkillConfig:getPassiveSkillEffects()
		return self.skillEffects;
end

function PassiveSkillConfig:setSkillTrigger(skillTrigger)
		self.skillTrigger = skillTrigger;
end

function PassiveSkillConfig:getSkillTrigger()
		return self.skillTrigger;
end


function PassiveSkillConfig:getAttackCount()
		-- TODO Auto-generated method stub
		return 0;
end


function PassiveSkillConfig:getSkillGroupId()
		-- TODO Auto-generated method stub
		return 0;
end


function PassiveSkillConfig:setSkillGroupId(skillGroupId)
		-- TODO Auto-generated method stub

end


function PassiveSkillConfig:setSkillId(skillId)
		-- TODO Auto-generated method stub

end


function PassiveSkillConfig:getName()
		-- TODO Auto-generated method stub
		return nil;
end


function PassiveSkillConfig:setName(name)
		-- TODO Auto-generated method stub

end


function PassiveSkillConfig:getType()
		-- TODO Auto-generated method stub
		return 0;
end


function PassiveSkillConfig:setType(type)
		-- TODO Auto-generated method stub

end


function PassiveSkillConfig:getPercentValue(addition)
		-- TODO Auto-generated method stub
		return 0;
end


function PassiveSkillConfig:calcPerventValue(addition)
		return 1;
end


function PassiveSkillConfig:calcWJSkillPercentValue()
		return 1;
end


function PassiveSkillConfig:setPercentValue(percentValue)
		-- TODO Auto-generated method stub

end


function PassiveSkillConfig:getValue()
		-- TODO Auto-generated method stub
		return 0;
end


function PassiveSkillConfig:setValue(value)
		-- TODO Auto-generated method stub

end

function PassiveSkillConfig:getNum()
		return self.num;
end

function PassiveSkillConfig:calcWuShuangHurtValue()
	--log("=========PassiveSkillConfig-calcWuShuangHurtValue=======")
	return 0;
end