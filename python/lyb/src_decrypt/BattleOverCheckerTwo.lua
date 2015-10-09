BattleOverCheckerTwo = class();
--boss剩余血量
function BattleOverCheckerTwo:ctor(param)
	self.class = BattleOverCheckerTwo;
	self.percent = param/BattleConstants.HUNDRED_THOUSAND;
	-- self.delayTimes = 0
end

function BattleOverCheckerTwo:removeSelf()
	self.class = nil;
end

function BattleOverCheckerTwo:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerTwo:battleOver(battleField)
	if not battleField.bossHasBorn then
		return false;
	end
	-- if self.delayTimes >= 3 then
		local boss = battleField:getSecondTeam():getBoss();
		if not boss then
			battleField:getFirstTeam():win();
			-- self.delayTimes = self.delayTimes + 1
			return true;
		end
		if boss:getCurrHp()/boss:getMaxHP() <= self.percent then
			battleField:getFirstTeam():win();
			-- self.delayTimes = self.delayTimes + 1
			return true;
		end
	-- end
	return false;
end