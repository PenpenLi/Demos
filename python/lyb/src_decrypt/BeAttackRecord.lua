
BeAttackRecord = class();
--记录战斗单位在一段时间内连续被攻击的记录
function BeAttackRecord:ctor(attackId,attackTime)
	self.class = BeAttackRecord;
	self.attackId = attackId;
	self.attackTime = attackTime;
end

function BeAttackRecord:removeSelf()
	self.class = nil;
end

function BeAttackRecord:dispose()
    self:cleanSelf();
end

function BeAttackRecord:getAttackId()
	return attackId;
end

function BeAttackRecord:setAttackId(attackId)
	self.attackId = attackId;
end

function BeAttackRecord:getAttackTime()
	return attackTime;
end

function BeAttackRecord:setAttackTime(attackTime)
	self.attackTime = attackTime;
end


AttackRecordCount = class();
--记录战斗单位在一段时间内连续被攻击的记录
function AttackRecordCount:ctor()
	self.class = AttackRecordCount;
	self.CountContinueTime = 1500;--可调
	self.MaxBeAttactCount = 3;--可调
	self.beAttackRecords = {};
end

function AttackRecordCount:removeSelf()
	self.class = nil;
end

function AttackRecordCount:dispose()
    self:cleanSelf();
end

function AttackRecordCount:addAttackRecord(attackId,attackTime)
	table.insert(self.beAttackRecords,BeAttackRecord.new(attackId, attackTime))
end

function AttackRecordCount:getBeAttactCount()
	return 0;
end

function AttackRecordCount:isBeJiDao()
	return self:getBeAttactCount() >= self.MaxBeAttactCount;
end

function AttackRecordCount:clear()
	self.beAttackRecords=nil
end
