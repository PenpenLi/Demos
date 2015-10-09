SkillBaseConfig = class();
--技能基础信息
function SkillBaseConfig:ctor()
	self.class = SkillBaseConfig;
	--职业对应的动作
	self.skillActionConfig = nil;
	self.targetSkillEffects = {}
	self.skillEffectList = {}
end

function SkillBaseConfig:init(career,isRandom)
	self.lastActionMoveY = 0
	--print("pet============03"..self.skillId)
	local skillArr = StringUtils:lua_string_split(self.skillId,",")
	for k,skill in pairs(skillArr) do
		--log("==============skill==========="..skill)
		local screen,attack,beAttack = analysisSingalSkill(skill,career);
		require("main.controller.command.battleScene.battle.battlefield.skillConfig.SkillActionConfig")
		require("main.controller.command.battleScene.battle.battlefield.skillConfig.ActionConfig")
		--print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
		local skillActionConfig = SkillActionConfig.new(screen,skill,isRandom)
		--print("hhhhhhhhhhh============04")
		for key,value in pairs(attack) do
			--print("yyyyyyyyyy===========05")
			local actionConfig = ActionConfig.new(value)
			skillActionConfig:addActionConfig(actionConfig);
		end
		for key,value in pairs(beAttack) do
			local actionConfig = ActionConfig.new(value)
			skillActionConfig:addActionConfig(actionConfig);
			actionConfig:addActionMoveY(self.lastActionMoveY)
			--print("value.actionMoveY======="..value.actionMoveY)
			self.lastActionMoveY = value.actionMoveY--抛物线用
		end
		for key,attackConfig in pairs(skillActionConfig:getAttackActionMap()) do
			--print("======================================"..skillActionConfig:getAllAttackEffectX())
			--print("======================================"..attackConfig:getAttackEffectX())
			skillActionConfig:setAllActionMoiveX(skillActionConfig:getAllActionMoiveX() + attackConfig:getActionMoveX());
			--skillActionConfig:setAllAttackEffectX(skillActionConfig:getAllAttackEffectX() + attackConfig:getAttackEffectX());
		end
		self.skillActionConfig = skillActionConfig;
	end
end

function SkillBaseConfig:removeSelf()
	self.class = nil;
end

function SkillBaseConfig:dispose()
    self:removeSelf();
end

function SkillBaseConfig:isWushuang()
	return BattleUtils:isWuShuangSkill(self.skillId)
end

function SkillBaseConfig:isHurtSkill()
	return self:getType() == 1;
end

function SkillBaseConfig:setGreenBattleDistance(addDistance)
	self.skillActionConfig:setGreenBattleDistance(addDistance)
end

function SkillBaseConfig:getSkillActionMap()
	return self.skillActionConfig
end
function SkillBaseConfig:getBeAttackMoveDistance()
	if not self.beAttackMoveDistance then
		local actionConfigs = self:getSkillActionConfig():getBeAttackActionMap();
		local  beAttackMoveDistance = 0;
		for k1,actionConfig in pairs(actionConfigs) do
			beAttackMoveDistance = beAttackMoveDistance + actionConfig:getActionMoveX();
		end
		self.beAttackMoveDistance = beAttackMoveDistance
	end
	return self.beAttackMoveDistance;
end

function SkillBaseConfig:getBeijiyanchiArr()
	return self:getSkillActionConfig():getBeijiyanchiArr()
end

function SkillBaseConfig:getSubDistance(currTimes)
	local actionConfigs = self:getSkillActionConfig():getBeAttackActionMap();
	local length = #self:getSkillActionConfig():getBeijiyanchiArr()
	if length == 1 then
		return self:getBeAttackMoveDistance()
	elseif length == 2 then
		if currTimes == 1 then
			return actionConfigs["b1"]:getActionMoveX()
		else
			local dis = 0
			for key,value in pairs(actionConfigs) do
				if key ~= "b1" then
					dis = value:getActionMoveX() + dis
				end
			end
			return dis
		end
	elseif length == 3 then
		if currTimes == 1 then
			return actionConfigs["b1"]:getActionMoveX()
		elseif currTimes == 2 then
			return actionConfigs["b2"]:getActionMoveX()
		elseif currTimes == 3 then
			local dis = 0
			for key,value in pairs(actionConfigs) do
				if key ~= "b1" and key ~= "b2" then
					dis = value:getActionMoveX() + dis
				end
			end
			return dis
		end
	end
end

function SkillBaseConfig:getBeAttackThreeTime(currTimes,source,target)
	local beijiyanchiArr = self:getSkillActionConfig():getBeijiyanchiArr()
	local length = #beijiyanchiArr
	local totalTime = self:getSkillActionConfig():getSkillBeAttackActionTime(target);
	local tempTime = nil
	local isNeedCheckDead = nil
	if length == 1 then
		tempTime = totalTime
		isNeedCheckDead = true
	elseif length == 2 then
		if currTimes == 1 then
			tempTime = tonumber(beijiyanchiArr[2])+300
		else
			tempTime = totalTime - tonumber(beijiyanchiArr[2])
			isNeedCheckDead = true
		end
	elseif length == 3 then
		if currTimes == 1 then
			tempTime = tonumber(beijiyanchiArr[2]) + 300
		elseif currTimes == 2 then
			tempTime = tonumber(beijiyanchiArr[3]) + 300
		elseif currTimes == 3 then
			tempTime = totalTime - tonumber(beijiyanchiArr[2]) - tonumber(beijiyanchiArr[3])
			isNeedCheckDead = true
		end
	end
	-- print(length.."==========currTimes==currTimes================="..currTimes)
	return tonumber(tempTime),isNeedCheckDead,totalTime
end

function SkillBaseConfig:getAttackMoveDistance()
	return self:getSkillActionConfig():getAllActionMoiveX();
end

--是否是群攻技能
function SkillBaseConfig:isAoeSkill()
	return self:getEffectRange() > 0 or self:isWushuang();
end

function SkillBaseConfig:isDirectHurtSkill()
	if not self:isHurtSkill() then
		return false;
	end
	if self:isSpecialKill() then
		return false;
	end
	return true;
end

function SkillBaseConfig:isSpecialKill()
	return self:getSkillId() == BattleConstants.SkillIdWushuangStatus;
end
--获取技能释放准备动作播放时间
-- function SkillBaseConfig:getPrepareCaskSkillTime(battleUnit)
-- 	return self:getSkillActionConfig():getPrepareCaskSkillTime(battleUnit);
-- end
--获取被攻击动作播放时间
function SkillBaseConfig:getBeAttackTime(target)
	return self:getSkillActionConfig():getSkillBeAttackActionTime(target);
end

function SkillBaseConfig:getAttackDistance()
	return self:getSkillActionConfig():getAttackDistance();
end

function SkillBaseConfig:getBeijiyanchi()
	return self:getSkillActionConfig():getBeijiyanchi();
end

function SkillBaseConfig:getFlySkillType()
	return self:getSkillActionConfig():getFlySkillType();
end
function SkillBaseConfig:isFlySkill()
	return self:getSkillActionConfig():isFlySkill();
end
function SkillBaseConfig:getFlySkillyanchi()
	return self:getSkillActionConfig():getFlySkillyanchi();
end
function SkillBaseConfig:getEffectRange()
	return self:getSkillActionConfig():getEffectRange();
end

function SkillBaseConfig:getEffectDelayTime()
	return self:getSkillActionConfig():getHurtAction():getEffectDelayTime();
end

function SkillBaseConfig:getTargetSkillEffects()
	return self.targetSkillEffects;
end

function SkillBaseConfig:setTargetSkillEffects(effect)
	table.insert(self.targetSkillEffects,effect);
end

function SkillBaseConfig:getSkillEffects()
	return self.skillEffectList;
end

-- function SkillBaseConfig:getSkillAttackActionTime(battleUnit)
-- 	return self:getSkillActionConfig():getSkillAttackActionTime(battleUnit);
-- end

function SkillBaseConfig:getTarget()
	return self:getSkillActionConfig():getAttackType();
end
function SkillBaseConfig:getPauseTime()
	return self:getSkillActionConfig():getPauseTime();
end
function SkillBaseConfig:hasQTE()
	return self:getSkillActionConfig():hasQTE();
end
function SkillBaseConfig:getCaskSkillTime(source)
	return self:getSkillActionConfig():getCaskSkillTime(source);
end

function SkillBaseConfig:checkSkillActionExists(modleId)
	-- try{
	-- 		getSkillActionConfig().checkSkillActionExists(modleId);
	-- 	} catch (Exception e) {
	-- 		System.out.println(e);
	-- 	}
end

function SkillBaseConfig:getSkillActionConfig()
	return self.skillActionConfig;
end
function SkillBaseConfig:getSelectTargetFun()
	return SelectTargetImpl:getInstance():getSelectTargetFun(self);
end