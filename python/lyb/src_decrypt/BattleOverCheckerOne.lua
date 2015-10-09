BattleOverCheckerOne = class();
--战场时间到了
function BattleOverCheckerOne:ctor(time)
	self.class = BattleOverCheckerOne;
	self.time = time*1000
end

function BattleOverCheckerOne:removeSelf()
	self.class = nil;
end

function BattleOverCheckerOne:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerOne:battleOver(battleField)
	if battleField:getCurrentFrameTime() >= self.time then
		--log("============1SecondTeamWin!!!!================")
		battleField:getSecondTeam():win();
		return true;
	end
	return false;
end