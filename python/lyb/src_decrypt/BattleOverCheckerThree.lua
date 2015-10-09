BattleOverCheckerThree = class();
--玩家剩余血量
function BattleOverCheckerThree:ctor(checkParam)
	self.class = BattleOverCheckerThree;
	self.percent = checkParam / BattleConstants.HUNDRED_THOUSAND;
end

function BattleOverCheckerThree:removeSelf()
	self.class = nil;
end

function BattleOverCheckerThree:dispose()
	self.overallBoss = nil
    self:removeSelf();
end

function BattleOverCheckerThree:battleOver(battleField)
	return false;
end