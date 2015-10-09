BattleOverCheckerFour = class();
--一方全部死亡
function BattleOverCheckerFour:ctor()
	self.class = BattleOverCheckerFour;
end

function BattleOverCheckerFour:removeSelf()
	self.class = nil;
end

function BattleOverCheckerFour:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerFour:battleOver(battleField)
	if battleField:getFirstTeam():isAllDead() then
		log("============4SecondTeamWin!!!!================")
		battleField:getSecondTeam():win();
		return true;
	end
	if battleField:getSecondTeam():isAllDead() then
		log("============4FirstTeamWin!!!!================")
		battleField:getFirstTeam():win();
		return true;
	end
	return false;
end