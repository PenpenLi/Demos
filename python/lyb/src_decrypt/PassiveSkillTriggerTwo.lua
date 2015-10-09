PassiveSkillTriggerTwo = class(AbstractPassiveSkillTrigger);
--主人hp百分比触发
function PassiveSkillTriggerTwo:ctor()
	self.class = PassiveSkillTriggerTwo;
end

function PassiveSkillTriggerTwo:cleanSelf()
	self:removeSelf()
end

function PassiveSkillTriggerTwo:dispose()
    self:cleanSelf();
end

function PassiveSkillTriggerTwo:innerInstallEffect(battleUnit,model)
	if battleUnit:getType() ~= BattleConstants.BATTLE_UNIT_TYPE_5 then
		return;
	end
	local owner = battleUnit:getOwner();
	if owner:isDieAway() then
		return;
	end
	--血量百分比
	if owner:getCurrHp() / owner:getMaxHP() > model:getValue() / BattleConstants.HUNDRED_THOUSAND then
		return;
	end
	EffectFactory:createSkillEffect(1, model:getSkillEffectConfig():getId(), model, owner, owner:getBattleField());
end
