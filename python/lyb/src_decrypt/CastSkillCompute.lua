CastSkillCompute = class(Object);
--释放技能计算
function CastSkillCompute:ctor()
	require("main.controller.command.battleScene.battle.battlefield.compute.CastSkillResult")
	self.selectTarget = SelectTargetImpl:getInstance();
end

rawset(CastSkillCompute,"instance",nil);
rawset(CastSkillCompute,"getInstance",
	function()
		if CastSkillCompute.instance then
	else
		rawset(CastSkillCompute,"instance",CastSkillCompute.new());
	end
	return CastSkillCompute.instance;
	end);

function CastSkillCompute:cleanSelf()
	self.class = nil;
end

function CastSkillCompute:dispose()
	self.cleanSelf();
end
--攻击和被击产生位移
function CastSkillCompute:triggerSkillAttackActionMove(source, skill)
	if source:getFaceDirect() then
		source:setPositionXY(source:getCoordinateX() + skill:getActionConfig():getAllActionMoiveX(),source:getCoordinateY());
	else
		source:setPositionXY(source:getCoordinateX() - skill:getActionConfig():getAllActionMoiveX(),source:getCoordinateY());
	end
end

-- 释放技能
function CastSkillCompute:castSkill(source, target, skillMgr)
	--print("castSkill---oooooooooooooooooo>"..source.objectId..target.objectId);
	--local origenalCoordinateX = source:getCoordinateX();
	if source:isDie() then
		return;
	end
	local mpm = {};
	-- AttackterBattleUnitId,AttackterCoordinateX,SkillId,AttackResult,CurrentRage,AttackResultArray
	mpm.AttackterBattleUnitId = source:getObjectId();
	mpm.AttackterCoordinateX = source:getCoordinateX();
	mpm.AttackterCoordinateY = source:getCoordinateY();
	mpm.SkillId = skillMgr.skill.id;
	mpm.FaceDirect = source:getFaceDirect() and -1 or 1;
	mpm.SubType = 24;
	source:getBattleField().battleProxy:sendAIMessage(mpm)
end

function CastSkillCompute:castSkillBeAttack(source,skillMgr,hitMpm)
	if #hitMpm == 0 then 
		return
	end
	local mpm = {};
	-- AttackterBattleUnitId,AttackterCoordinateX,SkillId,AttackResult,CurrentRage,AttackResultArray
	mpm.AttackterBattleUnitId = source:getObjectId();
	mpm.SkillId = skillMgr.skill.id;
	mpm.BeAttackActionId = skillMgr:getCDTimeManager():getBeAttackActionId()
	mpm.AttackResultArray = hitMpm;
	mpm.SubType = 44;
	source:getBattleField().battleProxy:sendAIMessage(mpm)

	local recordArray = {}
	local frameTime = source:getBattleField().currentFrame
	--local len = string.len(frameTime);
	--local timeNum = tonumber(string.sub(frameTime, len-6, len))
	--log("=========getCurrentFrameTimeNum========="..timeNum)
	recordArray.Time = frameTime;
	recordArray.Index = source:getBattleField():getRecordLength()+1
	recordArray.BattleUnitID = source:getObjectId()
	recordArray.SkillId = skillMgr.skill.id;
	recordArray.Count = 0
	local hurtArray = {}
	for key,value in pairs(hitMpm) do
		if value.needWriteLog then
			local array = {}
			array.BattleUnitID = value.TargetBattleUnitId
			array.ChangeValue = value.ChangeValue
			array.AttackStage = mpm.BeAttackActionId
			array.HurtEffectArray = value.hurtEffectArray
			table.insert(hurtArray,array)
		end
	end
	recordArray.HurtArray = hurtArray;
	source:getBattleField():setAttackRecordArray(recordArray)
end

function CastSkillCompute:setTimeOut(source,castSkillTime)
	local battleAIHandler;
	local function battleAIHandlerF()
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(battleAIHandler)
		source:onImmediateMove();
		--source:getMoveManager():sendCurrentCoordinateXMessage();
	end
	battleAIHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(battleAIHandlerF, castSkillTime - 45, false)
end
