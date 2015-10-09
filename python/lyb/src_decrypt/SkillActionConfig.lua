SkillActionConfig = class();
--技能动作
function SkillActionConfig:ctor(skillId)
	self.class = SkillActionConfig;
	if not skillId then return end
	self.skillId = skillId
	-- /**
	--  * 技能攻击距离
	--  */
	-- @Mapping
	self.attackDistance = nil;
	-- /**
	--  * 技能攻击类型
	--  */
	-- @Mapping
	self.attackType = nil;
	-- @Mapping
	self.beijiyanchi = nil;
	-- // 攻击动作产生的x位移
	self.allActionMoiveX = 0;
	-- // 火球飞行的总距离
	self.allAttackEffectX = 0;
	local screenSkill,attack,beAttack = analysisSingalSkill(self.skillId);
	
	self.screenSkill = screenSkill;
	--攻击动作集合
	self.attackActionMap = {}
	--被攻击动作集合
	self.beAttackActionMap = {}
	self.attackType = screenSkill.attackType;
	self.beijiyanchi = screenSkill.beijiyanchi

	for key,value in pairs(attack) do
		self.attackActionMap[value.id] = value;
		value.attackEffectX = self:getCfValue(value.attackEffectX);
		self:setAllActionMoiveX(self:getAllActionMoiveX() + value.attackEffectX);
	end
	for key,value in pairs(beAttack) do
		self.beAttackActionMap[value.id] = value;
	end

	
	self.targetSkillEffects = {};
end

function SkillActionConfig:removeSelf()
	self.class = nil;
end

function SkillActionConfig:dispose()
    self:removeSelf();
end
function SkillActionConfig:getCfValue(value)
	--print("ooooooooooooooooooooooooooooooooooooo"..self.attackEffectX)
	return value == "#" and 0 or value;
end
function SkillActionConfig:getBeAttackMoveDistance()
	if not self.beAttackMoveDistance then
		local  beAttackMoveDistance = 0;
		for k1,actionConfig in pairs(beAttackActionMap) do
			beAttackMoveDistance = beAttackMoveDistance + actionConfig.actionMoveX;
		end
		self.beAttackMoveDistance = beAttackMoveDistance
	end
	return self.beAttackMoveDistance;
end

function SkillActionConfig:getBeijiyanchiArr()
	if not self.beijiyanchiArr then
		local beijiyanchi
		if not self.beijiyanchi or self.beijiyanchi == "#" then
			beijiyanchi = 100
		else
			beijiyanchi = self.beijiyanchi
		end
		if self.attackType == BattleConstants.CastTargetTypeEnemyTarget4 or 
			self.attackType == BattleConstants.CastTargetTypeEnemyTarget5 then
			beijiyanchi = tonumber(StringUtils:lua_string_split(beijiyanchi,"?")[1])
		end
		self.beijiyanchiArr = StringUtils:lua_string_split(beijiyanchi,"?")
	end
	return self.beijiyanchiArr
end
function SkillActionConfig:getSubDistance(currTimes)
	local length = #self:getBeijiyanchiArr()
	if length == 1 then
		return self:getBeAttackMoveDistance()
	elseif length == 2 then
		if currTimes == 1 then
			return beAttackActionMap["b1"].actionMoveX
		else
			local dis = 0
			for key,value in pairs(beAttackActionMap) do
				if key ~= "b1" then
					dis = value.actionMoveX + dis
				end
			end
			return dis
		end
	elseif length == 3 then
		if currTimes == 1 then
			return beAttackActionMap["b1"].actionMoveX
		elseif currTimes == 2 then
			return beAttackActionMap["b2"].actionMoveX
		elseif currTimes == 3 then
			local dis = 0
			for key,value in pairs(beAttackActionMap) do
				if key ~= "b1" and key ~= "b2" then
					dis = value.actionMoveX + dis
				end
			end
			return dis
		end
	end
end

function SkillActionConfig:getBeAttackThreeTime(currTimes,source,target)
	local beijiyanchiArr = self:getBeijiyanchiArr()
	local length = #beijiyanchiArr
	local totalTime = self:getSkillBeAttackActionTime(target);
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
function SkillActionConfig:getFlySkillyanchi()
	local yanchi = self.feixingTexiaoYanchi or 0
	return yanchi
end

function SkillActionConfig:getFlySkillType()
	return tonumber(self.feixingTexiaoType);
end
function SkillActionConfig:isFlySkill()
	return self.attackType == BattleConstants.CastTargetTypeEnemyTarget1 or self.attackType == BattleConstants.CastTargetTypeEnemyTarget2 or self.attackType == BattleConstants.CastTargetTypeEnemyTarget3;
end
function SkillActionConfig:setBeijiyanchi(beijiyanchi)
	self.beijiyanchi = beijiyanchi;
end

function SkillActionConfig:getActionId()
	return self.actionId;
end

function SkillActionConfig:getAttackDistance()
	return self.attackDistance;
end

function SkillActionConfig:setGreenBattleDistance(addDistance)
	self.attackDistance = self.attackDistance + addDistance
end

function SkillActionConfig:getEffectRange()
	return self.effectRange;
end
function SkillActionConfig:getPauseTime()
	if self.pauseTime then
		return tonumber(self.pauseTime);
	end
	return 0;
end
function SkillActionConfig:getAttackType()
	return self.attackType;
end

function SkillActionConfig:getPaowuxian()
	return self.paowuxian 
end

--技能释放动作播放时间
function SkillActionConfig:getCaskSkillTime(source)
	if not self.playSkillTime then
		local totalTime = 0;
		local tempTable = {}
		for i=1,9 do
			local tempA = self.attackActionMap["a"..i]
			if tempA then
				table.insert(tempTable,tempA)
			end
		end
		for k1,action in pairs(tempTable) do
			totalTime = totalTime + self:getActionTime(source,action);
		end
		self.playSkillTime = totalTime
	end
	return self.playSkillTime;
end
function SkillActionConfig:getActionTime(source,action)
	local totalTime = 0
	if 0 ~= action.actionMoveX or 0 ~= action.actionMoveY then
		local rate
		if (0 == action.attackActionTime or nil == action.attackActionTime) then
			rate = 0.5 
		else
			if action.attackActionTime >= 10 then
				rate = action.attackActionTime / 1000
			else
				rate = 0.5 / action.attackActionTime 
			end
		end
		totalTime = totalTime + rate*1000 + action.delayTime;
	else

		if action.actionJiasu ~= 0 and action.actionJiasu ~= "#" then
		else
			action.actionJiasu = 1;
		end
		totalTime = source:getActionTotalTime(action.attackActionID) / action.actionJiasu * math.max(1, action.actionLoop) + action.delayTime
	end
	return math.ceil(totalTime)
end

--获取技能被攻击动作播放时间
function SkillActionConfig:getSkillBeAttackActionTime(target)
	if not self.beattackTotalTime then
		local totalTime = 0;
		for k1,actionConfig in pairs(self.beAttackActionMap) do
			local actionTime = self:getActionTime(target,actionConfig);
			totalTime = totalTime + actionTime;
		end
		self.beattackTotalTime = totalTime
	end
	return self.beattackTotalTime;
end

function SkillActionConfig:setBeAttackActionMap(beAttackActionMap)
	self.beAttackActionMap = beAttackActionMap
end

function SkillActionConfig:getFrameDelayTime()
	if not self.frameDelayTime then
		local totalTime = 0;
		local tempTable = {}
		for i=1,9 do
			local tempA = self.attackActionMap["a"..i]
			if tempA then
				table.insert(tempTable,tempA)
			end
		end
		for k1,action in pairs(tempTable) do
			totalTime = totalTime + action.delayTime
		end
		self.FrameDelayTime = totalTime
	end
	return self.FrameDelayTime;
end
function SkillActionConfig:getTargetSkillEffects()
	return self.targetSkillEffects;
end

function SkillActionConfig:setTargetSkillEffects(effect)
	table.insert(self.targetSkillEffects,effect);
end

--获取三段被击时间
function SkillActionConfig:getSkillBeAttackThreeTime()
	return self.attackActionMap;
end

function SkillActionConfig:getAttackActionMap()
	return self.attackActionMap;
end

function SkillActionConfig:getBeAttackActionMap()
	return self.beAttackActionMap;
end

function SkillActionConfig:setBeAttackActionMap(beAttackActionMap)
	self.beAttackActionMap = beAttackActionMap;
end

function SkillActionConfig:setAllAttackEffectX(allAttackEffectX)
	self.allAttackEffectX = allAttackEffectX;
end

function SkillActionConfig:setAllActionMoiveX(allActionMoiveX)
	self.allActionMoiveX = allActionMoiveX;
end


function SkillActionConfig:checkSkillActionExists(modleId)
	for k1,actionConfig in pairs(self.attackActionMap) do
		--local key = DummyUtils:getCompositeKey(modleId, actionConfig:getAttackActionID());
		local key = "key_"..modleId.."_"..actionConfig.attackActionID;
		ArtsFrameConfigContext:getInstance():getCartoonTotalTime(key);
	end
	for k1,actionConfig in pairs(self.beAttackActionMap) do
		--local key = DummyUtils:getCompositeKey(modleId, actionConfig:getAttackActionID());
		local key = "key_"..modleId.."_"..actionConfig.attackActionID;
		ArtsFrameConfigContext:getInstance():getCartoonTotalTime(key);
	end
end

function SkillActionConfig:getAllActionMoiveX()
	return self.allActionMoiveX;
end

function SkillActionConfig:getAllAttackEffectX()
	return self.allAttackEffectX;
end
--技能效果产生的位移
function SkillActionConfig:getSkillEffectMoveX()
	return self.allAttackEffectX;
end