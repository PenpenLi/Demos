require "zoo.gamePlay.stable.BaseStableState"
require "zoo.gamePlay.stable.FurballTransferState"
require "zoo.gamePlay.stable.RoostReplaceState"
require "zoo.gamePlay.stable.InactiveBlockerState"
require "zoo.gamePlay.stable.FurballSplitState"
require "zoo.gamePlay.stable.NeedRefreshState"
require "zoo.gamePlay.stable.BalloonCheckState"
require "zoo.gamePlay.stable.DigScrollGroundState"
require "zoo.gamePlay.stable.UFOUpdateState"
require "zoo.gamePlay.stable.BonusAutoBombState"
require "zoo.gamePlay.stable.BonusStepToLineState"
require "zoo.gamePlay.stable.BonusLastBombState"
require "zoo.gamePlay.stable.GameOverState"
require "zoo.gamePlay.stable.TileBlockerState"
require "zoo.gamePlay.stable.UpdatePM25State"
require "zoo.gamePlay.stable.BigMonsterLogic"
require "zoo.gamePlay.stable.BlackCuteBallState"
require "zoo.gamePlay.stable.MimosaState"
require "zoo.gamePlay.stable.SnailLogic"
require "zoo.gamePlay.stable.ProductSnailState"
require "zoo.gamePlay.stable.MaydayBossDieState"
require "zoo.gamePlay.stable.MaydayBossJumpState"
require "zoo.gamePlay.stable.ProductRabbitState"
require "zoo.gamePlay.stable.ChangePeriodState"
require "zoo.gamePlay.stable.TransmissionState"
require "zoo.gamePlay.stable.SeaAnimalCollectState"
require "zoo.gamePlay.stable.MagicLampCastingState"
require "zoo.gamePlay.stable.MagicLampReinitState"
require "zoo.gamePlay.stable.HoneyBottleState"
require "zoo.gamePlay.stable.HalloweenBossState"
require "zoo.gamePlay.stable.CheckNeedLoopState"
require "zoo.gamePlay.stable.MagicTileResetState"
require "zoo.gamePlay.stable.SandTransferState"
require "zoo.gamePlay.stable.MaydayBossCastingState"

StableStateMachine = class()

function StableStateMachine:ctor()
	self.currentState = nil
end

function StableStateMachine:dispose()
	self.mainLogic = nil
	self.currentState = nil
end

function StableStateMachine:create(fallingMatchState)
	local v = StableStateMachine.new()
	v.mainLogic = fallingMatchState.mainLogic
	v.fallingMatchState = fallingMatchState
	v:initStates()
	return v
end

function StableStateMachine:initStates()
	self.needLoopCheck = false

	self.maydayBossCastingState = MaydayBossCastingState:create(self)

	self.halloweenBossStateInBonus = HalloweenBossStateInBonus:create(self)

	-- 产生新的蜗牛
	self.productSnailState = ProductSnailState:create(self)
	-- 圣诞节关卡中的地块 重置处理
	self.magicTileResetState = MagicTileResetState:create(self)
	-- 神灯重置处理
	self.magicLampReinitState = MagicLampReinitState:create(self)

	self.roostReplaceStateInLoop = RoostReplaceStateInLoop:create(self)
	self.magicLampCastingStateInLoop = MagicLampCastingStateInLoop:create(self)
	self.honeyBottleStateInLoop = HoneyBottleStateInLoop:create(self)
	self.furballSplitStateInLoop = FurballSplitStateInLoop:create(self)
	self.halloweenBossStateInLoop = HalloweenBossStateInLoop:create(self)
	self.digScrollGroundStateInLoop = DigScrollGroundStateInLoop:create(self)

	-- 海洋生物
	self.seaAnimalCollectState = SeaAnimalCollectState:create(self)
	-- 劳动节boss死亡
	self.maydayBossDieState = MaydayBossDieState:create(self)
	-- 蜗牛逻辑
	self.snailLogic = SnailLogic:create(self)
	-- 检测雪怪
	self.bigMonsterLogic = BigMonsterLogic:create(self)

	-- 检测是否进入状态循环，由mainLogic.needLoopCheck字段控制
	self.checkNeedLoopState = CheckNeedLoopState:create(self)
	-- 检测刷新棋盘
	self.needRefreshState = NeedRefreshState:create(self)

	-- BonusTime引爆棋盘中现有的特效阶段 
	self.bonusAutoBombState = BonusAutoBombState:create(self)
	-- BonusTime剩余步数转化为条纹
	self.bonusStepToLineState = BonusStepToLineState:create(self)
	-- BonusTime转化为条纹后爆破
	self.bonusLastBombState = BonusLastBombState:create(self)
	-- 游戏结束前的延迟...
	self.gameOverState = GameOverState:create(self)
	self.roostReplaceStateInBonusFirst = RoostReplaceStateInBonusFirst:create(self)
	self.roostReplaceStateInBonusSecond = RoostReplaceStateInBonusSecond:create(self)

	-- 使用道具状态
	self.furballSplitStateInPropFirst = FurballSplitStateInPropFirst:create(self)

	-- 气球
	self.balloonCheckState = BalloonCheckState:create(self)
	-- 传送带
	self.transmissionState = TransmissionState:create(self)
	-- 黑色毛球跳动
	self.blackCuteBallState = BlackCuteBallState:create(self)
	-- 灰色&褐色毛球跳动
	self.furballTransferState = FurballTransferState:create(self)
	-- 劳动节boss换位
	self.maydayBossJumpState = MaydayBossJumpState:create(self)
	-- 鸡窝生产小鸡
	self.roostReplaceStateInSwapFirst = RoostReplaceStateInSwapFirst:create(self)
	-- 不活跃障碍 毒液、水晶球、毒液冰融化等不会造成消除的障碍
	self.inactiveBlockerState = InactiveBlockerState:create(self)
	-- 流沙移动逻辑
	self.sandTransferState = SandTransferState:create(self)	
	-- 神灯障碍
	self.magicLampCastingStateInSwapFirst = MagicLampCastingStateInSwapFirst:create(self)
	-- 褐色毛球分裂
	self.furballSplitStateInSwapFirst = FurballSplitStateInSwapFirst:create(self)
	-- 翻转地块
	self.tileBlockerState = TileBlockerState:create(self)
	-- UFO作用更新
	self.ufoUpdateState = UFOUpdateState:create(self)
	-- 兔子生成逻辑
	self.productRabbitState = ProductRabbitState:create(self)
	-- 兔子周赛阶段结束
	self.changePeriodState = ChangePeriodState:create(self)
	-- 含羞草
	self.mimosaState = MimosaState:create(self)
	-- PM2.5 在挖地关中产生云块
	self.updatePM25State = UpdatePM25State:create(self)
end

function StableStateMachine:update(dt)
	if self.currentState then
		self.currentState:update(dt)
	end
end

function StableStateMachine:changeState(target)
	if target ~= nil then
		if self.currentState then
			self.currentState:onExit()
		end

		self.currentState = target
		self.currentState:onEnter()
		
		--递归调用,以此保障当上一个优先级的障碍不需要处理时,直接进入下一个状态,从而不必空跑一帧
		if self.currentState then
			self:changeState(self.currentState:checkTransition())
		end
	end
end

function StableStateMachine:onEnter(isFromFallingMatch)
	if isFromFallingMatch then 
		if self.bigMonsterLogic:check() > 0  then
			if self.currentState then
				self.currentState:stopUpdate()
			end
			return 
		end---检测处理雪怪逻辑

		if self.maydayBossDieState:onEnter() > 0 then
			if self.currentState then
				self.currentState:stopUpdate()
			end
			return
		end
		
		if self.snailLogic:check() > 0 then 
			if self.currentState then
				self.currentState:stopUpdate()
			end
			return 
		end---检测处理蜗牛

		if self.seaAnimalCollectState:onEnter() > 0 then
			if self.currentState then
				self.currentState:stopUpdate()
			end
			return
		end
	end

	if self.currentState then
		self:changeState(self.currentState:checkTransition())
	else
		if self.mainLogic.isBonusTime then
			self:changeState(self.bonusAutoBombState)
		else
			if self.mainLogic.isInStep then
				self:changeState(self.balloonCheckState)
			else
				self:changeState(self.furballSplitStateInPropFirst)
			end
		end
	end
end

function StableStateMachine:onExit()
	if self.currentState then
		self.currentState:onExit()
		self.currentState = nil
	end
end