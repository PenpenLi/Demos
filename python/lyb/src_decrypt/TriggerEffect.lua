TriggerEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function TriggerEffect:ctor()
	self.class = TriggerEffect;
end

function TriggerEffect:cleanSelf()
	self:removeSelf()
end

function TriggerEffect:dispose()
    self:cleanSelf();
end

function TriggerEffect:doExecute(now)
	for k,v in pairs(self.efSklAr) do
		self.target:effectSkillAttack(v,self:getLevel());
	end
end

function TriggerEffect:doUnExecute()
	
end
function TriggerEffect:configExeSkill()
	local skIdAr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actSkillTime,",");
	local skIdCha = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actSkillChaTime,",");
	local ispasSkillCha = tonumber(self.effectModel:getSkillEffectConfig().IfactSkillChaTime) or 0;
	self.efSklAr = {};
	local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
	for i,v in ipairs(skIdAr) do
		if v and tonumber(v) and tonumber(v) > 0 then
			if ispasSkillCha >0 then
				if randomValue <= tonumber(skIdCha[i]) then
					table.insert(self.efSklAr,v);
					break;
				end
			else
				randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
				if randomValue <= tonumber(skIdCha[i]) then
					table.insert(self.efSklAr,v);
				end
			end
		end
	end
end