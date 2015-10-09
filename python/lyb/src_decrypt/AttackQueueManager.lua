AttackQueueManager = class()

function AttackQueueManager:ctor()
	self.class = AttackQueueManager;
	self.battleUnitQueueMap = {}
	self.needMakQueue = true;--回合控制
	self.canMakeAttack = true
	self.battleUnitMap = nil
	self.attackingUnitTable = {}
	self.hasAttackUnitTable = {}
end

function AttackQueueManager:removeSelf()
	self.class = nil;
end

function AttackQueueManager:dispose()
    self:removeSelf();
    self.battleUnitQueueMap = nil
end

function AttackQueueManager:initData(firstTeam,secondTeam)
	self.firstTeam = firstTeam;
	self.secondTeam = secondTeam;
end

function AttackQueueManager:update(now)
	if not self.needMakQueue then return end
	self.needMakQueue = nil--回合开始的时候计算一次
	self:makeData()
end

function AttackQueueManager:makeData()
	local battleUnitMapTemp = {}
	self:makeMapData(battleUnitMapTemp)--组织队列
	self:makeQueueMap(battleUnitMapTemp)--给队列排序
end

function AttackQueueManager:makeMapData(battleUnitMapTemp)
	self:makeBattleUnitMap(self.firstTeam,battleUnitMapTemp)
	self:makeBattleUnitMap(self.secondTeam,battleUnitMapTemp)
end

function AttackQueueManager:makeBattleUnitMap(team,battleUnitMapTemp)
	for key,unit in pairs(team:getBattleUniMap()) do
		if not self.hasAttackUnitTable[unit:getObjectId()] then
			if not battleUnitMapTemp[unit:getSuDu().."_"..unit:getStandPoint()] then
				local unitTable = {}
				unitTable.suDu = unit:getSuDu()
				unitTable.standPoint = unit:getStandPoint()
				unitTable.unitArr = {}
				battleUnitMapTemp[unit:getSuDu().."_"..unit:getStandPoint()] = unitTable
			end
			table.insert(battleUnitMapTemp[unit:getSuDu().."_"..unit:getStandPoint()].unitArr,unit)
		end
	end
end

local function sortOnBySuDu(a, b) 
	if a.suDu > b.suDu then
		return true
	else
		if a.suDu == b.suDu then
			return a.standPoint < b.standPoint 
		else
			return false
		end
	end
end
function AttackQueueManager:makeQueueMap(unitMap)
	local tempTable = {}
	for key,value in pairs(unitMap) do
		table.insert(tempTable,value)
	end
	table.sort(tempTable,sortOnBySuDu)
	self.battleUnitMap = tempTable;
end

function AttackQueueManager:canAttack(objectId)
	if not self.canMakeAttack then return end
	local attackTable = self.battleUnitMap[1]
	if not attackTable then return end
	for key,unit in pairs(attackTable.unitArr) do
		if unit:getObjectId() == objectId then
			self.attackingUnitTable[objectId] = objectId;
			self.hasAttackUnitTable[objectId] = objectId;
			self.battleUnitMap[1].unitArr[key] = nil
			if BattleUtils:getArrayLength(self.battleUnitMap[1].unitArr) == 0 then
				self.battleUnitMap[1] = nil
				self.canMakeAttack = nil
			end
			return true
		end
	end
end

function AttackQueueManager:removeAttackingData(objectId)
	self.attackingUnitTable[objectId] = nil;
	if BattleUtils:getArrayLength(self.attackingUnitTable) == 0 then
		self.canMakeAttack = true
		self:makeData()
	end
	if BattleUtils:getArrayLength(self.battleUnitMap) == 0 then
		self.needMakQueue = true
		self.hasAttackUnitTable = {}
	end
end