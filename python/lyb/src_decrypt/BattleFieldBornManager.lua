BattleFieldBornManager = class();

function BattleFieldBornManager:ctor()
	self.class = BattleFieldBornManager;
	self.battleField = nil;
	self.battleTeam = nil;
	self.waveMap = nil;
	self.nextWaveMap = nil;
	self.round = 0;
	self.maxRound = 0
	self.currentRound = 0
	self.currentScriptStep = 1--脚本用的1,2,3,4,5,6个波数点
end
function BattleFieldBornManager:init(battleTeam)
	self.battleTeam = battleTeam;
	self.battleField = battleTeam:getBattleField();
	self:initData(self.battleField:getId(),self.battleField:getBtlModeId());
end

function BattleFieldBornManager:initData(battleId,btlModId)
	self.waveMap = {};
	for key,buv in pairs(self.battleTeam.battleUniMap) do
		local waveArr = self.waveMap[buv.wave];
		print(buv.generalID.." btlModId "..btlModId.."   "..buv.wave);
		if not waveArr then 
			if buv.condtion then
				waveArr = {condtion=buv.condtion;map={}};
			else
				local monsterConfig =analysisByUnionKey("Zhanweiyuzhanchangpeizhi_Zhanchangguaiwupeizhi",{"battleId","wave"},btlModId.."_"..buv.wave);--TODO
				waveArr = {condtion=monsterConfig.condition;map={}};
			end
			self.waveMap[buv.wave] = waveArr;
			self.round = self.round+1; 
			self.maxRound = self.maxRound+1
		end
		table.insert(waveArr.map,buv);
	end
end
function BattleFieldBornManager:update(now)
	for i,v in pairs(self.waveMap) do
		if not v.isBorn and not self.isOnBorn then
			local splitArray = StringUtils:lua_string_split(v.condtion,",")
			if v.condtion == "1,0" or v.condtion == "3,1" then
				self.isOnBorn = true;
				self.nextWaveMap = v.map;
				self:botnBattleUnit();
				self.battleField.maxRound = v.round;
				self.waveMap[i].isBorn = true;
				break;
			elseif v.condtion == "2,0" and self.battleTeam.aliveCount <=0 then
				self.isOnBorn = true;
				self.battleField.maxRound = v.round;
				self.waveMap[i].isBorn = true;
				self.nextWaveMap = v.map;
				self:addCurrentScriptStep()
				self.battleField:scriptTwoBattleStepStart()
				break;
			elseif splitArray[1] == "3" then
				if self.battleField:getCurWave()== tonumber(splitArray[2]) then
					self.isOnBorn = true;
					self.nextWaveMap = v.map;
					self:botnBattleUnit();
					self.battleField.maxRound = v.round;
					self.waveMap[i].isBorn = true;
					break
				end
			end
		end
	end
end
function BattleFieldBornManager:addCurrentScriptStep()
	self.currentScriptStep = self.currentScriptStep + 1
end
function BattleFieldBornManager:moveToNextWavePlace()
	self.battleField:onBornWait();
	local function nextFun()
		self.battleField:moveToNextWavePlace()
		self.isOnBorn = nil;
	end
	Tweenlite:delayCallS(0.7,nextFun);
end
function BattleFieldBornManager:botnBattleUnit()
	self.currentRound = self.currentRound + 1
	self.battleField:onActionUI()
	self.round = self.round-1;
	for k,v in pairs(self.nextWaveMap) do
		self.battleTeam:addBornUnit(v);
		v:BornUnit();
		if v.standPoint == BattleConstants.STANDPOINT_P1  then
			v.standPositionCcp = Battle_Pos_L[v.standPosition];
			v:setPositionCcp(Battle_Pos_L[v.standPosition]);
		else
			v.standPositionCcp = Battle_Pos_R[v.standPosition]; 
			v:setPositionCcp(Battle_Pos_R[v.standPosition]);
		end
	end
	self.isOnBorn = nil;
end
function BattleFieldBornManager:isBornOver()
	return self.round == 0;
end