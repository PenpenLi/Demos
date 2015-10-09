BattleOverCheckerSix = class();
--为全是机器人战斗结束
function BattleOverCheckerSix:ctor(boss)
	self.class = BattleOverCheckerSix;
	self.boss = boss;
end

function BattleOverCheckerSix:removeSelf()
	self.class = nil;
end

function BattleOverCheckerSix:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerSix:battleOver(battleField)
	for k1,battleUnit in pairs(battleField:getFirstTeam():getBattleUnits()) then
		if battleUnit.getUserId() > ConstConfig.CONST_ROBOT_ID then
			return false;
		end
	end
	battleField:getSecondTeam():win();
	self.boss:removeBattle(battleField);
	return true;
end