BattleUnitEffectManager = class();
--战场技能效果
function BattleUnitEffectManager:ctor(battleUnit)
	require("main.controller.command.battleScene.battle.battlefield.skilleffect.AbstractSkillEffect")
	self.class = BattleUnitEffectManager;
	--身上的效果
	self.effectMap = {}
	self.battleUnit = battleUnit;
	--暂存效果集合
	self.tempEffects = {};
end

function BattleUnitEffectManager:removeSelf()
	self.class = nil;
end

function BattleUnitEffectManager:dispose()
    self:removeSelf();
end
function BattleUnitEffectManager:beAttackEffects(souce,skillId,effectIdMap,targetCnt)
	require("main.controller.command.battleScene.battle.battlefield.skilleffect.EffectFactory")
	local effectMaxCount=99;
	local skillMgr = souce:getSkill(skillId);
	local isHurt;
	if souce.standPoint ~= self.battleUnit.standPoint then
		self.battleUnit:setAttackSouce(souce);
		BattleUtils:sendUpdateHRValue(self.battleUnit,0,self.battleUnit.deffury);
	end
	for k,v in pairs(effectIdMap) do
		local effectModel = skillMgr:getEffect(v);
		local skillEffect = EffectFactory:createSkillEffect(effectModel,souce,self.battleUnit,targetCnt);
		self:installEffect(skillEffect,souce,targetCnt,effectMaxCount);
		if not skillEffect:isContinued() and skillEffect.hurtValue and skillEffect.hurtValue<0 then
			isHurt = true;
		end
	end
	return isHurt;
end
--种入效果
function BattleUnitEffectManager:installEffect(skillEffect,souce,targetCnt,effectMaxCount)
	--处理互斥, 如果有互斥效果存在，当前效果无效
	print("#########>INS Effect objId",souce:getObjectId(),"effId",skillEffect:getEffectId(),"LV.",skillEffect:getLevel(),"Type",skillEffect.effectModel:getSkillEffType())
	for k1,effect in pairs(self.effectMap) do
		print("----->HAS Effect ",effect:getEffectId(),effect.effectModel:getSkillEffType())
	end
	if souce:isDie() or effectMaxCount<=0 then return end
	if skillEffect:getGroup() > 0 then
		for k1,effect in pairs(self.effectMap) do
			if effect:getExclusionGroup() == skillEffect:getGroup() then
				return;
			end
		end
	end
	effectMaxCount = effectMaxCount-1;
	local actPerEffMap = {};
	local actEffMap = {};
	local actSkillMap = {};
	local pasSkillMap = {};
	local actEfIdArr,actSkill = skillEffect:getActEffectSkill(skillEffect);
	for k,v in pairs(actEfIdArr) do
		local sklEffect = EffectFactory:createSkillEffect(v,souce,self.battleUnit,targetCnt);
		if sklEffect:isTemporary() then
			sklEffect:doExecute();
			table.insert(actPerEffMap,sklEffect);
		else
			table.insert(actEffMap,sklEffect);
		end
	end
	for k,v in pairs(actSkill) do
		table.insert(actSkillMap,v);
	end

	for k,v in pairs(self.effectMap) do
		local pasEfIdArr,pasSkill = v:getPasEffectSkill(skillEffect);
		for k1,v1 in pairs(pasEfIdArr) do
			local sklEffect = EffectFactory:createSkillEffect(v1,souce,self.battleUnit,targetCnt);
			if sklEffect:isTemporary() then
				sklEffect:doExecute();
				table.insert(actPerEffMap,sklEffect);
			else
				table.insert(actEffMap,sklEffect);
			end
		end
		for k2,v2 in pairs(pasSkill) do
			table.insert(pasSkillMap,v2);
		end
	end
	skillEffect:initData();
	self:effectBeAttack(skillEffect);
	--处理叠加, 存在同一种效果(id相同)才会可能叠加
	if not skillEffect:isContinued() then
		print("===========>SNAP Action   vv")
		skillEffect:doExecute();
		skillEffect:unExecute();
		print("===========>SNAP Action   ^^")
	else
		print("===========>LAST Action vv")
		local foreEffect = self.effectMap[skillEffect:getEffectId()];
		if foreEffect then
			if foreEffect:canRepeatAdd() then
				skillEffect:setRepeatCount(foreEffect:getRepeatCount()+1);
			else
				skillEffect:setRepeatCount(foreEffect:getRepeatCount());
			end
			self:unInstallEffect(foreEffect);
		end
		--开始生效
		--BattleUtils:writelog("install effect effectId="..skillEffect:getEffectId().." effectValue="..skillEffect:getEffectValue().." lastCount="..skillEffect.lastFrameCount.." battleUnitId="..self.battleUnit:getObjectId());
		self.effectMap[skillEffect:getEffectId()] = skillEffect;
		--self:synEffectUpdate(skillEffect);
		skillEffect:addEffectAction();
		skillEffect:doExecute();
		print("===========>LAST Action ^^")
	end
	for k,v in pairs(actPerEffMap) do
		v:unExecute();
	end
	if not skillEffect.isSanBi then
		for k,v in pairs(actEffMap) do
			self:installEffect(v,souce,targetCnt,effectMaxCount);
		end
		for k,v in pairs(actSkillMap) do
			souce:effectSkillAttack(v[1],v[2])
		end
		for k,v in pairs(pasSkillMap) do
			self.battleUnit:effectSkillAttack(v[1],v[2])
		end
	end
end
--卸载效果
function BattleUnitEffectManager:unInstallEffect(skillEffect)
	print("EffectManager:unInstallEffect",skillEffect:getEffectId())
	self.effectMap[skillEffect:getEffectId()] = nil
	--self:synEffectDetele(skillEffect);
	--BattleUtils:writelog("uninstall effect effectId="..skillEffect:getEffectId().." battleUnitId="..self.battleUnit:getObjectId().. " currentFrame="
	--					.. skillEffect.currentFrame);
	skillEffect:removeEffectAction();
	skillEffect:unExecute();
end
function BattleUnitEffectManager:update(now)
	for k1,v1 in pairs(self.effectMap) do
		table.insert(self.tempEffects, v1)
	end
	for k1,skillEffect in pairs(self.tempEffects) do
		--被驱散了
		skillEffect:addCurrentFrame();
		if skillEffect:isBeDisperse() then
			self:unInstallEffect(skillEffect);
		elseif skillEffect:isOver() then
			self:unInstallEffect(skillEffect);
		elseif skillEffect:isArrivedIntervalRound() then
			skillEffect:execute(now);
			skillEffect:doExecute(now);
		end
	end
	self.tempEffects = {};
end


function BattleUnitEffectManager:getSource(effectId)
	local effect = self.effectMap[effectId];
	if effect then
		return effect:getSource();
	end
end
function BattleUnitEffectManager:hasEffect(effectId)
	return self.effectMap[effectId];
end
function BattleUnitEffectManager:hasEffectType(efType)
	for k,v in pairs(self.effectMap) do
		if not v:isOver() and tonumber(v:getEffectType()) == tonumber(efType) then
			return true;
		end 
	end
end
function BattleUnitEffectManager:getEffectByType(efType)
	for k,v in pairs(self.effectMap) do
		if not v:isOver() and v:getEffectType() == efType then
			return v;
		end 
	end
end
function BattleUnitEffectManager:clear()
	self.effectMap = {}
end
--同步效果
function BattleUnitEffectManager:synEffectUpdate(effect)
	local mpm = {};
	local list = {};
	local tempMpm = {};
	tempMpm.AttackterBattleUnitId = self.battleUnit:getObjectId();
	tempMpm.SkillId = effect:getSkillId();
	tempMpm.Priority = effect:getPriority();
	tempMpm.EffectId = effect:getEffectId();
	tempMpm.EffectValue = effect:getEffectValue();
	table.insert(list,tempMpm)
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.EffectArray = list;
	mpm.SubType = 5;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end
--同步删除效果
function BattleUnitEffectManager:synEffectDetele(effect)
	local mpm = {};
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.EffectId = effect:getEffectId();
	mpm.SubType = 12;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end
--播被击
function BattleUnitEffectManager:effectBeAttack(effect)
	local mpm = {};
	mpm.BattleUnitID = self.battleUnit:getObjectId();
	mpm.SkillId = effect:getSkillId();
	mpm.Play = effect.effectModel:isBeAttack() and 1 or 0;
	mpm.SubType = 46;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end
function BattleUnitEffectManager:quxie()
	--驱邪，当前帧改变所有负面效果的beDisperse， 下一帧才驱散
	for k1,effect in pairs(self.effectMap) do
		--能被驱散，且是负面效果
		if effect:isDispel() and effect:isIndescred() then
			effect:setBeDisperse(true);
		end
	end
end

function BattleUnitEffectManager:zhongxie()
	--和驱邪相反
	for k1,effect in pairs(self.effectMap) do
		if effect:isDispel() and effect:isIndescred() then
			effect:setBeDisperse(true);
		end
	end
end

function BattleUnitEffectManager:getEffect(effectId) 
	for key,effect in pairs(self.effectMap) do
		if effect:getEffectId() == effectId then
			return effect;
		end
	end
	return nil;
end

function BattleUnitEffectManager:addAddition(effectId,value)
	local effectModel = self.effectMap[effectId];
	if not effectModel then
		return;
	end
	value = value + effectModel:getEffectValue();
end

function BattleUnitEffectManager:reduAddition64(effectId,value)
	local effectModel = self.effectMap[effectId];
	if not effectModel then
		return;
	end
	value = value - effectModel:getEffectValue();
	if value <= 0 then
		value = 0;
	end
end

function BattleUnitEffectManager:checkAndAddAttackCount()
	for key,effect in pairs(self.effectMap) do
		if effect:getEffectModel().continued == BattleConstants.SKILL_EFFECT_LAST_TYPE_2 then
			effect:addAttackCount();
		end
	end
end

function BattleUnitEffectManager:checkAndAddBeAttackCount() 
	for key,effect in pairs(self.effectMap) do
		if effect:getEffectModel().continued == BattleConstants.SKILL_EFFECT_LAST_TYPE_3 then
			effect:addBeAttackCount();
		end
	end
end
