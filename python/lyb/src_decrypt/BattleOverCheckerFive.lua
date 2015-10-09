BattleOverCheckerFive = class();
--全局boss死亡
function BattleOverCheckerFive:ctor(boss)
	self.class = BattleOverCheckerFive;
	self.overallBoss = boss;
end

function BattleOverCheckerFive:removeSelf()
	self.class = nil;
end

function BattleOverCheckerFive:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerFive:initData(boss)
	self.overallBoss = boss;
end

function BattleOverCheckerFive:battleOver(battleField)
	if self.overallBoss:getHp() <= 0 then
		battleField:getFirstTeam():win();
		self.overallBoss:battleOver();
		return true;
	end
	if self.overallBoss:timeOver() then
		battleField:getSecondTeam():win();
		self.overallBoss:battleOver();
		return true;
	end
	return false;
end