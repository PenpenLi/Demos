BattleTeam = class();

function BattleTeam:ctor(battleField, standPoint)
	self.class = BattleTeam;
	self.battleUniMap = {};--fjm
	self.bornUnitMap={};
	self.tempUnits = {};
	self.battleField = battleField;--fjm
	self.bornManager = nil;--fjm
	self.standPoint = standPoint;--fjm
	self.initBattleUnitCount = 0;
	self.aliveCount = 0;
	-- if self.battleField.battleProxy.battleType == BattleConfig.BATTLE_TYPE_2 then
		self.powerNum = BattleConfig.Max_Power_Num
	-- end
end

function BattleTeam:removeSelf()
	self.class = nil;
	self.enemyTeam = nil;
end

function BattleTeam:dispose()
	self:removeSelf();
end

function BattleTeam:getBattleUnits(skill)
	local tempTable = {}
	for key,buv in pairs(self.battleUniMap) do
		if not skill or skill.duangjnzdid == 0 then
			if buv:isAlive() then
				table.insert(tempTable,buv)
			end
		else
			table.insert(tempTable,buv)
		end
	end
	return tempTable;
end

--GeneralId,CurrentHP,CurrentMP
function BattleTeam:getAliveUnitsProMap()
	local tempTable = {}
	for key,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			table.insert(tempTable,{BattleUnitID = buv:getObjectId(),CurrentHP = buv:getCurrHp(),CurrentMP = buv:getCurrRage()})
		end
	end
	return tempTable;
end

function BattleTeam:setBattleUniMap(battleUniMap)
	self.battleUniMap = battleUniMap;
end

function BattleTeam:getStandPoint()
	return self.standPoint;
end

function BattleTeam:setStandPoint()
	self.standPoint = standPoint;
end


function BattleTeam:getBattleField()
	return self.battleField;
end

function BattleTeam:isAllStateEnumIDLE()
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			if not buv:isStateEnumIDLE() then
				return false
			end
		end
	end
	return true
end

function BattleTeam:isAllDead()
	if not self.bornManager:isBornOver() then
		return false;
	end
	for buk,buv in pairs(self.battleUniMap) do
		if not buv.isBornOver or buv.machineState:getCurrentState():getStateEnum() ~= StateEnum.DEAD then
			return false;
		end
	end
	return true
end

function BattleTeam:battleOverForceHold()
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			buv:forceToHold()
		end
	end
end

function BattleTeam:win()
	self.winT = true;
end

function BattleTeam:isWin()
	return self.winT;
end

function BattleTeam:getBoss()
	for k1, battleUnit in pairs(self.battleUniMap) do
		if battleUnit:isBoss()then
			return battleUnit;
		end
	end
	return nil;
end

function BattleTeam:stopSkillPause(objectId)
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() and buv.objectId ~= objectId then
			buv:setPause(true);
		end
	end
end

function BattleTeam:stopSkillActivite(objectId)
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() and buv.objectId ~= objectId then
			buv:setActivite(true);
		end
	end
end

function BattleTeam:enterPause()
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			buv:setPause(true);
		end
	end
	self.teamPause = true
end

function BattleTeam:onPauseScript()
	self.isPauseScript = true
end

function BattleTeam:onContinueScript()
	self.isPauseScript = nil
end

function BattleTeam:isTeamPause()
	return self.teamPause
end

function BattleTeam:activiteFromPause()
	-- print("activiteFromPause=========")
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			buv:setActivite(true);
		end
	end
	self.teamPause = false
end

function BattleTeam:getGeneralUnit()
	for buk,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			return buv;
		end
	end
end

function BattleTeam:heroOnMove(position,isClickMove)
	for key,follower in pairs(self.battleUniMap) do
		if follower:isAlive() then
			follower:onOwnerMove(position,isClickMove);
		end
	end
end

-------------------------测试用---------------------------
function BattleTeam:checkBattleUnit(allUnitArray,uMap)
	local map = uMap or self.battleUniMap
	for buk,buv in pairs(map) do
		local unitArray = {}
		unitArray.BattleUnitID = buv.objectId
		-- unitArray.BaseAttack = buv.baseAttack
		-- unitArray.BaseDefence = buv.baseDefense
		-- unitArray.BaseHp = buv.baseHp;
		unitArray.UnitPropertyArray = copyTable(self:getPropertyArray(buv:getPropertyManager().propertyMap))
		if buv.checkMaxHP then
			for key,value in pairs(unitArray.UnitPropertyArray) do
				if value.PropertyKey == PropertyType.MAX_HP then
					unitArray.UnitPropertyArray[key] = {PropertyKey = PropertyType.MAX_HP, PropertyValue = buv.checkMaxHP}
				end
			end
		end
		unitArray.SkillCDArray = self:getSkillCDArray(buv)
		table.insert(allUnitArray,unitArray)
	end
end

function BattleTeam:getSkillCDArray(unit)
	local allArray = {}
	--for key,value in pairs(unit.fightSkillSet) do
		local pArray = {}
		pArray.SkillId = unit.fightSkillSet.id
		pArray.Time = unit.fightSkillSet.intervalTime
		pArray.CartoonTime = unit.fightSkillSet:getCaskSkillTime(unit)
		table.insert(allArray,pArray)
	--end
	return allArray
end

function BattleTeam:getPropertyArray(array)
	local allArray = {}
	for key,value in pairs(array) do
		local pArray = {}
		pArray.PropertyKey = value.key
		pArray.PropertyValue = value.intValue
		table.insert(allArray,pArray)
	end
	return allArray
end

function BattleTeam:getAliveBattleUnitCount()
	local count = 0;
	for key,buv in pairs(self.battleUniMap) do
		if buv:isAlive() and not buv.isMyFriend then
			count = count + 1;
		end
	end
	return count;
end

function BattleTeam:getPlayUnitNum()
	return math.max(0,4-self.initBattleUnitCount);
end

function BattleTeam:getDeadUnitNum()
	return self.initBattleUnitCount - BattleUtils:getArrayLength(self.battleUniMap);
end

-------------------------测试用---------------------------

-- fjm 2.0 begin
function BattleTeam:addBattleUnit(battleUnit)
	table.insert(self.battleUniMap,battleUnit)
	battleUnit:setMyTeam(self);
	self.initBattleUnitCount = self.initBattleUnitCount+1;
end
function BattleTeam:getBattleUnitByGeneralID(generalID)
	for key,value in pairs(self.battleUniMap) do
		if generalID == value.generalID then
			return value
		end
	end
end
function BattleTeam:getBattleUnitByID(battleUnitID)
	for key,value in pairs(self.battleUniMap) do
		if battleUnitID == value:getObjectId() then
			return value
		end
	end
end
function BattleTeam:getBattleUniMap()
	local tempTable = {}
	for key,buv in pairs(self.battleUniMap) do
		if buv:isAlive() then
			table.insert(tempTable,buv)
		end
	end
	return tempTable;
end

function BattleTeam:bornRole()
	if self.bornManager then
		self.bornManager:update(now);
	end
end
function BattleTeam:initBornManager()
	require("main.controller.command.battleScene.battle.battlefield.BattleFieldBornManager");
	self.bornManager = BattleFieldBornManager.new();
	self.bornManager:init(self)
end

function BattleTeam:update(now)
	for buk,buv in pairs(self.bornUnitMap) do
		buv:update(now);
	end
	--self:removeDeadBattleUnit();
	
end
function BattleTeam:chickBorn()
	if self.bornManager then
		self.bornManager:update(now);
	end
end
function BattleTeam:removeDeadBattleUnit(dieU)
	self.aliveCount = self.aliveCount-1;
	for key,value in pairs(self.bornUnitMap) do
		if dieU:getObjectId() == value:getObjectId() then
			dieU.battleIcon:removeSkillEffect();
			self.bornUnitMap[key]=nil;
			if self.standPoint == BattleConstants.STANDPOINT_P2 then
				if self.battleField.battleProxy then
					self.battleField.battleProxy.battleOverMonsterCount = self.battleField.battleProxy.battleOverMonsterCount+1;
				end
			end
		end
	end
end
function BattleTeam:addBornUnit(unit)
	self.aliveCount = self.aliveCount+1;
	table.insert(self.bornUnitMap,unit);
end
function BattleTeam:getBornAliveCount()
	return self.aliveCount;
end
function BattleTeam:setEnemyTeam(team)
	self.enemyTeam = team;
end
function BattleTeam:getEnemyTeam()
	return self.enemyTeam;
end
function BattleTeam:initDrop()
	local bossMap = {};
	local eliteMap = {};
	local narmalMap = {};
	for buk,buv in pairs(self.bornUnitMap) do
		if buv.isBoss then
			table.insert(bossMap, buv)
		elseif buv.isElite then
			table.insert(eliteMap, buv)
		else
			table.insert(narmalMap, buv)
		end
	end
	local silverMap,cardMap,daojuMap = self:getDropTypeTable()
	self:silverDrop(silverMap)
	self:cardDrop(cardMap,bossMap,eliteMap,narmalMap)
	self:daojuDrop(daojuMap,bossMap,eliteMap,narmalMap)
end
function BattleTeam:getDropTypeTable()--掉落初始化数据
	local silverMap = nil;
	local cardMap = {};
	local daojuMap = {};
	local diaoLuoDaoJuNum = 0;
	local diaoLuoDaoYiLiangNum = 0
	for key,itemVO in pairs(self.battleField.battleProxy.itemIdArray) do
		local functionID = analysis("Daoju_Daojubiao",itemVO.ItemId,"functionID");
		if itemVO.ItemId == 2 then--银两
			silverMap = itemVO;
			diaoLuoDaoYiLiangNum = diaoLuoDaoYiLiangNum + itemVO.Count
		elseif functionID == 4 or functionID == 20 then--卡牌灵魂石
			table.insert(cardMap,itemVO)
			diaoLuoDaoJuNum = diaoLuoDaoJuNum + itemVO.Count
		elseif functionID ~= 0 then--道具
			table.insert(daojuMap,itemVO)
			diaoLuoDaoJuNum = diaoLuoDaoJuNum + itemVO.Count
		end
	end
	self.battleField.battleProxy.diaoLuoDaoJuNum = diaoLuoDaoJuNum
	self.battleField.battleProxy.diaoLuoDaoYiLiangNum = diaoLuoDaoYiLiangNum
	return silverMap,cardMap,daojuMap
end
function BattleTeam:silverDrop(silverMap)--掉落银两
	if not silverMap then return end
	local waveMap = self.bornManager.waveMap
	local tatalRound = #waveMap;
	local average = math.floor(silverMap.Count/tatalRound)
	local yu = silverMap.Count%tatalRound
	for key,roundMap in pairs(waveMap) do
		local number = math.random(#roundMap.map)
		if not waveMap[key].map[number].needDropDaojuTable then
			waveMap[key].map[number].needDropDaojuTable = {}
		end
		if key ~= #waveMap then
			local daoju = {ItemId = 2,Count = average}
			table.insert(waveMap[key].map[number].needDropDaojuTable,daoju)
		else
			local daoju = {ItemId = 2,Count = average + yu}
			table.insert(waveMap[key].map[number].needDropDaojuTable,daoju)
		end
	end
end
function BattleTeam:cardDrop(cardMap,bossMap,eliteMap,narmalMap)--掉落卡
	if #cardMap == 0 then return end
	local waveMap = self.bornManager.waveMap
	if #bossMap ~= 0 then
		self:addUnitDrop(bossMap,cardMap)
	elseif #eliteMap ~= 0 then
		self:addUnitDrop(eliteMap,cardMap)
	else
		self:addUnitDrop(narmalMap,cardMap)
	end
	if #cardMap ~= 0 then
		self:cardDrop(cardMap,bossMap,eliteMap,narmalMap)
	end
end
function BattleTeam:addUnitDrop(unitMap,dropMap)--掉落卡道具
	for key,buv in pairs(unitMap) do
		if not buv.needDropDaojuTable then
			buv.needDropDaojuTable = {}
		end
		local itemVO = dropMap[#dropMap]
		if itemVO then
			local daoju = {ItemId = itemVO.ItemId,Count = itemVO.Count}
			table.insert(buv.needDropDaojuTable,daoju)
		end
		table.remove(dropMap,#dropMap)
		if #dropMap == 0 then break end
	end
end
function BattleTeam:daojuDrop(daojuMap,bossMap,eliteMap,narmalMap)--掉落道具
	if #daojuMap == 0 then return end
	if #bossMap ~= 0 then
		self:addUnitDrop(bossMap,daojuMap)
	end
	if #daojuMap == 0 then return end
	if #eliteMap ~= 0 then
		self:addUnitDrop(eliteMap,daojuMap)
	end
	if #daojuMap == 0 then return end
	self:daojuAddUnit(narmalMap,daojuMap)
end
function BattleTeam:daojuAddUnit(narmalMap,daojuMap)
	local waveMap = self.bornManager.waveMap
	local tatalRound = #waveMap;
	local daojuCount = #daojuMap
	local average = math.floor(daojuCount/tatalRound)
	local yu = daojuCount%tatalRound
	for key,roundMap in pairs(waveMap) do
		local number = math.random(#roundMap.map)
		if not waveMap[key].map[number].needDropDaojuTable then
			waveMap[key].map[number].needDropDaojuTable = {}
		end
		if key ~= #waveMap then
			local daoju = {ItemId = daojuMap[#daojuMap].ItemId,Count = average}
			table.insert(waveMap[key].map[number].needDropDaojuTable,daoju)
		else
			local daoju = {ItemId = daojuMap[#daojuMap].ItemId,Count = average + yu}
			table.insert(waveMap[key].map[number].needDropDaojuTable,daoju)
		end
		table.remove(daojuMap,#daojuMap)
		if #daojuMap == 0 then break end
	end
end
function BattleTeam:onRestPos()
	for buk,buv in pairs(self.bornUnitMap) do
		buv:onRestPos(buv.standPositionCcp.x,buv.standPositionCcp.y);
	end
end




