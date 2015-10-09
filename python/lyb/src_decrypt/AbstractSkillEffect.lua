AbstractSkillEffect = class();

function AbstractSkillEffect:ctor()
	self.class = AbstractSkillEffect;
	self.repeatCount = 1;--叠加次数
	--效果是否第一次执行
	self.isFirst = true;
	--是否被驱散
	self.beDisperse = nil
	-- 持续性效果生效次数
	self.currentFrame = 0;
	-- 生效回合
	self.attackFrame = 0;
	-- /** 效果持续的(帧数,攻击次数, 被击次数) **/
	self.lastFrame=0;
	-- 被击次数
	self.beAttackCount = 0;
	-- 攻击次数
	self.attackCount = 0;

end

function AbstractSkillEffect:init(effectModel,source,target,battleField)
	self.effectModel = effectModel;
	self.source = source;
	self.target = target;--效果作用目标
	self.battleField = battleField;--战场
	self.repeatCount = 1;
	self.attackFrame = self.effectModel.intervalFrame;  --   +effectModel:getBeginRound();
	self.lastFrame=effectModel:getLastFrame();
end
function AbstractSkillEffect:initData()
	-- body
end
function AbstractSkillEffect:removeSelf()
	self.class = nil;
end

function AbstractSkillEffect:dispose()
    self:cleanSelf();
end

function AbstractSkillEffect:getExclusionGroup()
	return self.effectModel:getSkillEffectConfig().contradiction;
end
function AbstractSkillEffect:getGroup()
	return self.effectModel:getSkillEffectConfig().group;
end
function AbstractSkillEffect:getEffectId()
	return self.effectModel:getEffectId();
end

function AbstractSkillEffect:getEffectValue()
	return self.effectModel:getValue();
end
function AbstractSkillEffect:getEffectPersent()
	return self.effectModel:getPersent();
end

function AbstractSkillEffect:getRepeatCount()
	return self.repeatCount;
end

function AbstractSkillEffect:setRepeatCount(repeatCount)
	print(".........>>  Repeat Count",repeatCount);
	self.repeatCount = repeatCount;
end

-- 一周期时间是否到达
function AbstractSkillEffect:isArrivedIntervalRound()
	return self.attackFrame<=self.currentFrame;		
end


function AbstractSkillEffect:execute(now)
	self.attackFrame = self.attackFrame+self.effectModel.intervalFrame;
end
function AbstractSkillEffect:addCurrentFrame()
	self.currentFrame = self.currentFrame+1;
end
function AbstractSkillEffect:unExecute()
	self:doUnExecute();
	self.effectModel = nil;
	self.source = nil;
	self.target = nil;
	self.battleField = nil;
	self.currentFrame = -9999;
end

function AbstractSkillEffect:getEffectModel()
	return self.effectModel;
end

function AbstractSkillEffect:getBattleField()
	return self.battleField;
end

function AbstractSkillEffect:setBeDisperse(beDisperse)
	self.beDisperse = beDisperse;
end

function AbstractSkillEffect:isBeDisperse()
	return self.beDisperse;
end

function AbstractSkillEffect:isDispel()
	return self.effectModel:getSkillEffectConfig().disperse;
end
function AbstractSkillEffect:indescred()
	return self.effectModel:getSkillEffectConfig().negative-1;
end
function AbstractSkillEffect:isIndescred()
	return self.effectModel:getSkillEffectConfig().negative<1;
end

function AbstractSkillEffect:getSkillId()
	return self.effectModel:getSkillId();
end
--是否还能叠加
function AbstractSkillEffect:canRepeatAdd()
	return self.repeatCount < self.effectModel:getSkillEffectConfig().overlap;
end
--是否是持续效果
function AbstractSkillEffect:isLast()
	return self.effectModel:getSkillEffectConfig().continued;
end
function AbstractSkillEffect:setTemporary()
	self.temporary = true;
end
function AbstractSkillEffect:setUseSource()
	self.useSource = true;
end
function AbstractSkillEffect:isTemporary()
	return self.temporary;
end
--是否同步数据到客户端
function AbstractSkillEffect:isSynClient()
	return self.effectModel:getSkillEffectConfig().showNumber;
end
--属性ID
function AbstractSkillEffect:getProperty()
	return self.effectModel:getSkillEffectConfig().property;
end

function AbstractSkillEffect:getLevel()
	return self.effectModel:getSkillLevel();
end

function AbstractSkillEffect:calcEffectValueByRate(baseValue)
	return math.floor(baseValue * (self:getEffectValue() / BattleConstants.HUNDRED_THOUSAND));
end

function AbstractSkillEffect:isOver()
	if self.isOverFlg then
		return true;
	elseif self.target and self.target:isDie() then
		return true;
	else
		return self.currentFrame>self.lastFrame;
	end
end
function AbstractSkillEffect:addAttackCount()
	self.attackCount = self.attackCount + 1;
end

function AbstractSkillEffect:addBeAttackCount()
	self.beAttackCount = self.beAttackCount + 1;
end
function AbstractSkillEffect:getEffectType()
	return self.effectModel:getSkillEffectConfig().skitype;
end
function AbstractSkillEffect:isContinued()
	return self.effectModel and self.effectModel:getLastType() == 1;
end
function AbstractSkillEffect:doHurt(hurt)
	local skillId;
	if not self:isContinued() then skillId = self:getSkillId() end
	local xiShouEff = self.target:getEffectByType(BattleConstants.SKILL_EFFECT_TYPE_3001);--吸收伤害
	if self:isIndescred() and xiShouEff then
		local tmp = xiShouEff:cutHurt(hurt);
		if tmp>0 then self:doHurt(tmp); end
	else
		BattleUtils:sendUpdateHRValue(self.target,hurt,0,skillId,self.isSanBi,self.isBaoJi,self.isZhuDang);
	end
end

function AbstractSkillEffect:addEffectAction()
	local efId = self:getEffectId();
	self.target.effectArray[efId] = efId;
	self.target.actionManager:addEffectAction();
end
function AbstractSkillEffect:removeEffectAction()
	local efId = self:getEffectId();
	self.target.effectArray[efId] = nil;
	self.target.actionManager:removeEffectAction();
end
function AbstractSkillEffect:getActEffectSkill(skillEffect)
	local actCond = self.effectModel:getSkillEffectConfig().actCond;
	if not actCond or actCond<=0 then return {},{} end;
	local function effctAndSkill()
		local efIdAr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actEffect,",");
		local efIdCha = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actEffectCha,",");
		local isActEffectCha = self.effectModel:getSkillEffectConfig().IfactEffectCha;
		local skIdAr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actSkill,",");
		local skIdCha = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actSkillCha,",");
		local isactSkillCha = self.effectModel:getSkillEffectConfig().IfactSkillCha;
		local efMdlAr = {};
		local efSklAr = {};
		local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- self.source:getBattleField():addRandomValue(randomValue);
		for i,v in ipairs(efIdAr) do
			if v and tonumber(v) and tonumber(v) > 0 then
				if isActEffectCha >0 then
					if randomValue <= tonumber(efIdCha[i]) then
						table.insert(efMdlAr,SkillEffectModel.new(self.effectModel.level,self.effectModel.skillId,v,100000))
						break;
					end
				else
					randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
					-- self.source:getBattleField():addRandomValue(randomValue);
					if randomValue <= tonumber(efIdCha[i]) then
						table.insert(efMdlAr,SkillEffectModel.new(self.effectModel.level,self.effectModel.skillId,v,100000))
					end
				end
			end
		end
		randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- self.source:getBattleField():addRandomValue(randomValue);
		for i,v in ipairs(skIdAr) do
			if v and tonumber(v) and tonumber(v) > 0 then
				if isactSkillCha >0 then
					if randomValue <= tonumber(skIdCha[i]) then
						table.insert(efSklAr,v);
						break;
					end
				else
					randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
					-- self.source:getBattleField():addRandomValue(randomValue);
					if randomValue <= tonumber(skIdCha[i]) then
						table.insert(efSklAr,{v,self:getLevel()});
					end
				end
			end
		end
		print("<<ZZZZ D S X>>  success");
		return efMdlAr,efSklAr;
	end
	print("<<ZZZZ D S X>>",actCond);
	if actCond == 1001 then
		 if skillEffect.isBaoJi then
			return effctAndSkill();
		 end
	elseif actCond == 1002 then --目标身上有某类buf
		local actParaArr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actPara,",");
		for k,v in pairs(actParaArr) do
			if self.target:hasEffectType(v) then
				return effctAndSkill();
			end
		end
	elseif actCond == 1003 then--自己身上有某类buf
		local actParaArr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().actPara,",");
		for k,v in pairs(actParaArr) do
			if self.source:hasEffectType(v) then
				return effctAndSkill();
			end
		end
	elseif actCond == 1004 then--如果目标生命低于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.target:getCurrHp()<self.target:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	elseif actCond == 1005 then--如果自己生命低于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.source:getCurrHp()<self.source:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	elseif actCond == 1006 then--如果目标生高低于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.target:getCurrHp()>self.target:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	elseif actCond == 1007 then--如果自己生高低于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.source:getCurrHp()>self.source:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	elseif actCond == 1008 then--空过滤
		return effctAndSkill();
	end
	
	return {},{};
end
function AbstractSkillEffect:getPasEffectSkill(effect)
	local pasCond = self.effectModel:getSkillEffectConfig().pasCond;
	if not pasCond or pasCond<=0 then return {},{} end;
	local pasParaArr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().passPara,",");
	local function effctAndSkill()
		local efIdAr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().pasEffect,",");
		local efIdCha = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().pasEffectCha,",");
		local ispasEffectCha = self.effectModel:getSkillEffectConfig().IfpasEffectCha;
		local skIdAr = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().pasSkill,",");
		local skIdCha = StringUtils:lua_string_split(self.effectModel:getSkillEffectConfig().pasSkillCha,",");
		local ispasSkillCha = tonumber(self.effectModel:getSkillEffectConfig().IfpasSkillCha) or 0;
		local efMdlAr = {};
		local efSklAr = {};
		local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- self.source:getBattleField():addRandomValue(randomValue);
		for i,v in ipairs(efIdAr) do
			if v and tonumber(v) and tonumber(v) > 0 then
				if ispasEffectCha >0 then
					if randomValue <= tonumber(efIdCha[i]) then
						table.insert(efMdlAr,SkillEffectModel.new(self.effectModel.level,self.effectModel.skillId,v,100000))
						break;
					end
				else
					randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
					-- self.source:getBattleField():addRandomValue(randomValue);
					if randomValue <= tonumber(efIdCha[i]) then
						table.insert(efMdlAr,SkillEffectModel.new(self.effectModel.level,self.effectModel.skillId,v,100000))
					end
				end
			end
		end
		randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- self.source:getBattleField():addRandomValue(randomValue);
		for i,v in ipairs(skIdAr) do
			if v and tonumber(v) and tonumber(v) > 0 then
				if ispasSkillCha >0 then
					if randomValue <= tonumber(skIdCha[i]) then
						table.insert(efSklAr,v);
						break;
					end
				else
					randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
					-- self.source:getBattleField():addRandomValue(randomValue);
					if randomValue <= tonumber(skIdCha[i]) then
						table.insert(efSklAr,{v,self:getLevel()});
					end
				end
			end
		end
		print("<<BBBB D S X>>  success");
		return efMdlAr,efSklAr;
	end
print("<<BBBB D S X>>",pasCond);
	if pasCond == 2001 then
		if effect.effectModel:getSkillType() == 1 then
			return effctAndSkill();
		end
	elseif pasCond == 2002 then
		if effect.effectModel:getSkillType() == 2 then
			return effctAndSkill();
		end
	elseif pasCond == 2003 then
		if effect.effectModel:getSkillType() == 3 then
			return effctAndSkill();
		end
	elseif pasCond == 2004 then
		if effect.effectModel:getSkillType() == 1 or 
			effect.effectModel:getSkillType() == 2 or 
			effect.effectModel:getSkillType() == 3 then
			return effctAndSkill();
		end
	elseif pasCond == 2006 then
		for k,v in pairs(pasParaArr) do
			print(">>  Skill effect Type == cond",effect.effectModel:getSkillEffType(),v)
			if tonumber(effect.effectModel:getSkillEffType()) == tonumber(v) then
				return effctAndSkill();
			end
		end
	elseif actCond == 2007 then--如果目标生命低于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.target:getCurrHp()<self.target:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	elseif actCond == 2008 then--如果目标生命高于X%
		local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
		if self.target:getCurrHp()>self.target:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
			return effctAndSkill();
		end
	-- elseif actCond == 2009 then--如果目标生高低于X%
	-- 	local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
	-- 	if self.target:getCurrHp()<self.target:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
	-- 		return effctAndSkill();
	-- 	end
	-- elseif actCond == 2010 then--如果自己生高低于X%
	-- 	local actper = tonumber(self.effectModel:getSkillEffectConfig().actPara);
	-- 	if self.source:getCurrHp()<self.source:getMaxHP()*actper/BattleConstants.HUNDRED_THOUSAND then
	-- 		return effctAndSkill();
	-- 	end
	end

	return {},{};
end