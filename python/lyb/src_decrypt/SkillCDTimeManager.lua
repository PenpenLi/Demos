SkillCDTimeManager = class();
--技能CD管理器
function SkillCDTimeManager:ctor()
	require("main.controller.command.battleScene.battle.battlefield.skillConfig.CDTimeFrame")
	require("main.controller.command.battleScene.battle.battlefield.skillConfig.CDTime")
	self.class = SkillCDTimeManager;
	--技能冷却时间,从释放开始时计时
	self.cdTime = nil
	--技能释放完后，间隔多长时间才能发下一个技能.从释放完成后开始计时
	self.intervalTime = nil
	--技能公共cd,从释放开始时计时
	self.groupCDTimeMap = {}
	self.currDelayTimes = 0
end

function SkillCDTimeManager:removeSelf()
	self.class = nil;
end

function SkillCDTimeManager:dispose()
    self:removeSelf();
end

function SkillCDTimeManager:initFirstCDTime(skillMgr,now,firstCDTime)
	--技能冷却时间
	if self.cdTime == nil then
		self.cdTime = CDTime.new(skillMgr.skill.id, now, firstCDTime);
	end
	-- self.cdTime:setStartTime(now);
	-- self.cdTime:setCoolingTime(firstCDTime);
end

--技能冷却时间，技能动作时间
function SkillCDTimeManager:updateCDTime(battleUnit,skillMgr,now,addStopSKillTime)
	--skill:getIntervalTime()得到的是skillConfig.time的值
	--技能释放动作时间(技能固有问隔时间+技能动作时间)
	if self.intervalTime == nil then
		self.intervalTime = CDTimeFrame.new(battleUnit:getObjectId(), now);
	end
	addStopSKillTime = addStopSKillTime or 0
	self.intervalTime:setCoolingTime(skillMgr:getActionConfig():getCaskSkillTime(battleUnit)+addStopSKillTime);
	self.intervalTime:setStartTime(now);

	--技能冷却时间
	if self.cdTime == nil then
		self.cdTime = CDTime.new(skillMgr.skill.id, now, skillMgr.skill.CD);
	end
	self.cdTime:setCoolingTime(skillMgr.skill.CD);
	self.cdTime:setStartTime(now);
end

--检查技能动作是否播完
function SkillCDTimeManager:checkAcationArrived(now)
	if self.intervalTime then
		if not self.intervalTime:isArrived(now) then
			return false;
		end
	end
	return true
end

function SkillCDTimeManager:setActionTime()
	self.intervalTime = nil
end

--检查武将技能CD是否已经冷却
function SkillCDTimeManager:checkCDTimeArrived(now)
	--冷却时间没到，不能放
	if self.cdTime ~= nil then
		return self.cdTime:isArrived(now);
	end
	return true;
end

-------------------------------------三段被击------------------------------
function SkillCDTimeManager:checkBeAttackDelayTime(battleUnit,now,addStopSKillTime)
	local delayTime = self:getInitDelayTime(battleUnit,addStopSKillTime)
	if not self.beAttackDelayTime then
		self.beAttackDelayTime = CDTimeFrame.new(battleUnit.objectId, now, delayTime);
	end
	self.beAttackDelayTime:setStartTime(now);
	self.beAttackDelayTime:setCoolingTime(delayTime);
end

function SkillCDTimeManager:getInitDelayTime(battleUnit)
	local config = battleUnit:getSelectSkill():getActionConfig();
		if not self.delayBeattackTimeArr then
			self.delayBeattackTimeArr = config:getBeijiyanchiArr()
		end
		self.currDelayTimes = self.currDelayTimes + 1
		return tonumber(self.delayBeattackTimeArr[self.currDelayTimes])
end

function SkillCDTimeManager:getFirstAttackTime()
	return tonumber(self.delayBeattackTimeArr[1])
end

function SkillCDTimeManager:isNeedNextDelayTime()
	if self.delayBeattackTimeArr then
		return self.currDelayTimes < #self.delayBeattackTimeArr 
	end
end

function SkillCDTimeManager:resertBeAttackDelayTime()
	self.delayBeattackTimeArr = nil
	self.currDelayTimes = 0
end

function SkillCDTimeManager:beAttackDelayTimeArrived(now)
	if self.beAttackDelayTime then
		return self.beAttackDelayTime:isArrived(now)
	end
end

function SkillCDTimeManager:checkBeAttackTime(battleUnit,now,time)
	if not self.beAttackTime then
		self.beAttackTime = CDTimeFrame.new(battleUnit.objectId, now, time);
	end
	self.beAttackTime:setStartTime(now);
	self.beAttackTime:setCoolingTime(time);
end

function SkillCDTimeManager:beAttackTimeArrived(now)
	if self.beAttackTime then
		return self.beAttackTime:isArrived(now)
	end
end

function SkillCDTimeManager:getBeAttackActionId()
	return self.currDelayTimes ~= 0 and self.currDelayTimes or 1
end
-------------------------------------三段被击------------------------------

function SkillCDTimeManager:initRestTime(battleUnit,now,time)
	if not self.restTime then
		self.restTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.restTime:setStartTime(now);
	self.restTime:setCoolingTime(time);
end

function SkillCDTimeManager:restTimeArrived(now)
	if self.restTime then
		return self.restTime:isArrived(now)
	end
end


function SkillCDTimeManager:initIstateTime(battleUnit,now,time)
	if not self.iStateTime then
		self.iStateTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.iStateTime:setStartTime(now);
	self.iStateTime:setCoolingTime(time);
end

function SkillCDTimeManager:iStateTimeArrived(now)
	if self.iStateTime then
		return self.iStateTime:isArrived(now)
	end
end

function SkillCDTimeManager:initIdleTime(battleUnit,now,time,addTime)
	addTime = addTime or 0
	if not self.idleTime then
		self.idleTime = CDTime.new(battleUnit.objectId, now, time + addTime);
	end
	self.idleTime:setStartTime(now);
	self.idleTime:setCoolingTime(time + addTime);
end

function SkillCDTimeManager:idleTimeArrived(now)
	if self.idleTime then
		return self.idleTime:isArrived(now)
	else
		return true
	end
end

function SkillCDTimeManager:initFriendTime(battleUnit,now,time)
	if not self.firendTime then
		self.firendTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.firendTime:setStartTime(now);
	self.firendTime:setCoolingTime(time);
end

function SkillCDTimeManager:firendTimeArrived(now)
	if self.firendTime then
		return self.firendTime:isArrived(now)
	end
end

function SkillCDTimeManager:initDeadTime(battleUnit,now,time)
	if not self.deadTime then
		self.deadTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.deadTime:setStartTime(now);
	self.deadTime:setCoolingTime(time);
end

function SkillCDTimeManager:deadTimeArrived(now)
	if self.deadTime then
		return self.deadTime:isArrived(now)
	end
end

function SkillCDTimeManager:initStopSkillTime(battleUnit,now,time)
	if not self.stopSkillTime then
		self.stopSkillTime = CDTimeFrame.new(battleUnit.objectId, now, time);
	end
	self.stopSkillTime:setStartTime(now);
	self.stopSkillTime:setCoolingTime(time);
end

function SkillCDTimeManager:stopSkillTimeArrived(now)
	if self.stopSkillTime then
		return self.stopSkillTime:isArrived(now)
	end
end

function SkillCDTimeManager:initStopTime(battleUnit,now,time)
	if not self.stopTime then
		self.stopTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.stopTime:setStartTime(now);
	self.stopTime:setCoolingTime(time);
end

function SkillCDTimeManager:stopTimeArrived(now)
	if self.stopTime then
		return self.stopTime:isArrived(now)
	end
end
--------------------------------------------------------------

--初始化状态initTime用
function SkillCDTimeManager:initStateInitTime(battleUnit,now,time)
	if not self.stateInitTime then
		self.stateInitTime = CDTime.new(battleUnit.objectId, now, time);
	end
	self.stateInitTime:setStartTime(now);
	self.stateInitTime:setCoolingTime(time);
end
--初始化状态initTime用
function SkillCDTimeManager:stateInitTimeArrived(now)
	if self.stateInitTime then
		return self.stateInitTime:isArrived(now)
	end
end
--初始化状态initTime用
function SkillCDTimeManager:setStateInitTime(stateInitTime)
	self.stateInitTime = stateInitTime
end