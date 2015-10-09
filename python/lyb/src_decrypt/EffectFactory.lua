EffectFactory = {};
--默认效果(空实现)

function EffectFactory:createSkillEffect(effectModel,souce,target,targetCnt)
	--持续型效果
	local battlefield = target:getBattleField();
	local skillEffectType = effectModel:getSkillEffType()
	if skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3001 then--TODU 吸收
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.XiShouEffect");
		local xiShouEffect = XiShouEffect.new();
		xiShouEffect:init(effectModel,souce,target,battlefield);
		xiShouEffect:initTtlValue();
		return xiShouEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3002 then--TODU 冰冻
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.BingDongEffect");
		local bingEffect = BingDongEffect.new();
		bingEffect:init(effectModel,souce,target,battlefield);
		return bingEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3003 then--TODU 复活
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3004 then--TODU 眩晕
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.XuanyunEffect");
		local xuanyunEffect = XuanyunEffect.new();
		xuanyunEffect:init(effectModel,souce,target,battlefield);
		return xuanyunEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3005 then--TODU 沉默
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.ChenMoEffect");
		local chenMoEffect = ChenMoEffect.new();
		chenMoEffect:init(effectModel,souce,target,battlefield);
		return chenMoEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3006 then--TODU 无敌
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.WuDiEffect");
		local wuDiEffect = WuDiEffect.new();
		wuDiEffect:init(effectModel,souce,target,battlefield);
		return wuDiEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3007 then--TODU 减血生命上限百分比
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.JXMaxPerEffect");
		local jXMPEffect = JXMaxPerEffect.new();
		jXMPEffect:init(effectModel,souce,target,battlefield);
		return jXMPEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3008 then--TODU 减血生命百分比
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.JianxuePercentEffect");
		local jXPEffect = JianxuePercentEffect.new();
		jXPEffect:init(effectModel,souce,target,battlefield);
		return jXPEffect;
	elseif skillEffectType == BattleConstants.SKILL_EFFECT_TYPE_3009 then--TODU 加血
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.JiaXueEffect")
		local jxSkillEffect = JiaXueEffect.new();--增加当前血量（百分比）
		jxSkillEffect:init(effectModel,souce,target,battlefield);
		return jxSkillEffect;
	elseif skillEffectType >= BattleConstants.SKILL_EFFECT_TYPE_3010 
	and skillEffectType <= BattleConstants.SKILL_EFFECT_TYPE_3017 then--TODU 攻击
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.AttackEffect");
		local attackEffect = AttackEffect.new();
		attackEffect:init(effectModel,souce,target,battlefield);
		attackEffect:setAttackCount(targetCnt);
		return attackEffect;
	elseif skillEffectType > BattleConstants.SKILL_EFFECT_TYPE_3100 
	and skillEffectType < BattleConstants.SKILL_EFFECT_TYPE_3150 then--TODU 本次临时属性 施法者
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.ImmPropertyEffect")
		local immPrEffect = ImmPropertyEffect.new();
		immPrEffect:setTemporary();
		immPrEffect:setUseSource();
		immPrEffect:init(effectModel,souce,target,battlefield);
		return immPrEffect;
	elseif skillEffectType > BattleConstants.SKILL_EFFECT_TYPE_3150 
	and skillEffectType < BattleConstants.SKILL_EFFECT_TYPE_3200 then--TODU 本次临时属性 被击者
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.ImmPropertyEffect")
		local immPrEffect = ImmPropertyEffect.new();
		immPrEffect:setTemporary();
		immPrEffect:init(effectModel,souce,target,battlefield);
		return immPrEffect;
	elseif skillEffectType > BattleConstants.SKILL_EFFECT_TYPE_3200 
	and skillEffectType < BattleConstants.SKILL_EFFECT_TYPE_3300 then--TODU 属性
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.PropertyEffect")
		local propertyEffect = PropertyEffect.new();
		propertyEffect:init(effectModel,souce,target,battlefield);
		return propertyEffect;
	elseif skillEffectType > BattleConstants.SKILL_EFFECT_TYPE_3300 
	and skillEffectType < BattleConstants.SKILL_EFFECT_TYPE_3400 then--TODU 效果触发器
		require("main.controller.command.battleScene.battle.battlefield.skilleffect.TriggerEffect");
		local triggerEffect = TriggerEffect.new();
		triggerEffect:init(effectModel,souce,target,battlefield);
		triggerEffect:configExeSkill();
		return triggerEffect;
	else
		print("********************************************");
		print("**  not have this effect type:",skillEffectType);
		print("********************************************");
	end
end