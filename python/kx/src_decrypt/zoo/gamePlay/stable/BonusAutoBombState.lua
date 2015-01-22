
BonusAutoBombState = class(BaseStableState)

function BonusAutoBombState:dispose()
	self.mainLogic = nil
	self.boardView = nil
	self.context = nil
end

function BonusAutoBombState:create(context)
	local v = BonusAutoBombState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	return v
end

function BonusAutoBombState:onEnter()
	BaseStableState.onEnter(self)
	self.timeCount = 0
	self.nextState = nil
	self.waitCount = 0
	self.hasItemToHandle = BombItemLogic:BonusTime_RandomBombOne(self.mainLogic, false)
end

function BonusAutoBombState:onExit()
	BaseStableState.onExit(self)
	self.timeCount = 0
	self.waitCount = 0
	self.nextState = nil
end

function BonusAutoBombState:update(dt)
	self.waitCount = self.waitCount + 1
	if self.waitCount < 120 then return end
	
	self.timeCount = self.timeCount + 1
	if self.timeCount >= GamePlayConfig_BonusTime_RandomBomb_CD then
		self.timeCount = 0
		if not BombItemLogic:BonusTime_RandomBombOne(self.mainLogic, true) then 			----没有可以引爆的了
			self.nextState = self:getNextState()
			if not self.hasItemToHandle then
				self.context:onEnter()
			end
		end
	end
end

function BonusAutoBombState:checkTransition()
	return self.nextState
end

function BonusAutoBombState:getClassName( ... )
	-- body
	return "BonusAutoBombState"
end

function BonusAutoBombState:getNextState( ... )
	-- body
	return self.context.roostReplaceStateInBonusFirst
end
