require "zoo.util.MemClass"
require "zoo.util.IntCoord"
require "zoo.gamePlay.GameBoardData"
require "zoo.gamePlay.GameItemData"
require "zoo.gamePlay.GameMapInitialLogic"
require "zoo.gamePlay.BoardAction.GameBoardActionDataSet"
require "zoo.gamePlay.BoardAction.GameBoardActionRunner"
require "zoo.gamePlay.BoardLogic.SwapItemLogic"
require "zoo.gamePlay.BoardLogic.FallingItemLogic"
require "zoo.gamePlay.BoardLogic.FallingItemExecutorLogic"
require "zoo.gamePlay.BoardLogic.ItemHalfStableCheckLogic"
require "zoo.gamePlay.BoardLogic.DestructionPlanLogic"
require "zoo.gamePlay.BoardLogic.DestroyItemLogic"
require "zoo.gamePlay.BoardLogic.RefreshItemLogic"
require "zoo.gamePlay.BoardLogic.DropBuffLogic"
require "zoo.gamePlay.mode.GameModeFactory"
require "zoo.gamePlay.BoardLogic.GameExtandPlayLogic"
require "zoo.gamePlay.BoardLogic.ProductItemLogic"
require "zoo.gamePlay.GameItemOrderData"
require "zoo.gamePlay.GamePlayMusicPlayer"
require "zoo.gamePlay.SaveRevertData"
require "zoo.gamePlay.fsm.StateMachine"
require 'zoo.gamePlay.trigger.GamePlayEventTrigger'
require "zoo.util.FUUUManager"

GameBoardLogic = memory_class()

GamePropsType = table.const
{
	kNone = 0,					--空
	kRefresh = 10001,			--游戏中 刷新
	kBack = 10002,				--游戏中 后退一步
	kSwap = 10003,				--游戏中 强制交换
	kAdd5 = 10004,				--游戏中 +5步
	kLineBrush = 10005,			--游戏中 条纹刷子
	kColorBrush_b = 10006,		--游戏前置 球----魔力鸟	----随机
	kWrap_b = 10007,			--游戏前置 糖纸
	kColorBrush = 10008,		--游戏中 颜色刷子
	kTelescope = 10009,			--游戏中 望远镜
	kHammer = 10010,			--游戏中 锤子

	kRefresh_b = 10015,			--游戏前置 刷新
	kBack_b = 10016,			--游戏前置 后退一步
	kSwap_b = 10017,			--游戏前置 强制交换
	kAdd3_b = 10018,			--游戏前置 +3
	kLineBrush_b = 10019,		--游戏前置 条纹刷子
	kHammer_b = 10024,			--游戏前置 锤子

	kRefresh_l = 10025,			--临时刷新
	kHammer_l = 10026,			--临时锤子
	kLineBrush_l = 10027,		--临时条纹刷子
	kSwap_l	= 10028,			--临时强制交换

	kOctopusForbid = 10052,		--章鱼冰道具
	kOctopusForbid_l = 10053,	--章鱼冰道具 临时
	kRandomBird    =  10055, 	--随机魔力鸟
	kBroom			= 10056,	--女巫扫把
	kBroom_l		= 10057,    --女巫扫把 临时

	kSpringFirework = 99999, 	--春节爆竹
}

GamePlayType = table.const
{
	kNone = 0,
	kClassicMoves = 1,				----移动一定步数，达到某个分数，然后结束
	kClassic = 2,					----时间模式
	kDropDown = 3,					----豆荚掉落关
	kLightUp = 4,					----冰层消除模式
	kDigTime = 5,					----时间挖掘模式
	kDigMove = 6, 					----步数挖掘模式
	kOrder = 7,						----订单模式---消除某个小动物，消除某个特效
	kDigMoveEndless = 8,			----无限制挖掘模式
	kRabbitWeekly = 9,
	kChristmasEndless = 10,
	kMaydayEndless = 12,
	kWorldCUP = 13,
	kSeaOrder = 14,
    kHalloween = 15,
    kUnlockAreaDropDown = 16,       ----解锁关卡任务掉落模式
}

GamePlayStatus = table.const
{
	kPreStart = 0,			----游戏开始前（面板、前置道具等）
	kNormal = 1,			----正常游戏
	kEnd = 2,				----满足结束条件
	kBonus = 3,				----BonusTime
	kAferBonus = 4,    		----Bonus结束
	kWin = 5,				----赢了
	kFailed = 6,			----输了
}

local encryptIndex = 0

function GameBoardLogic:ctor()
	encryptIndex = encryptIndex + 1
	self.encryptIndex = encryptIndex
	
	self.gameconfig = nil					-- 创建该游戏的选项
	self.posAdd = nil
	self.boardmap = nil;					-- 记录棋盘地形数据的矩阵
	self.gameItemMap = nil;					-- 记录棋盘物体数据的矩阵

	self.gameActionList = {}
	self.destructionPlanList = {}
	self.destroyActionList = {}
	self.fallingActionList = {}
	self.swapActionList = {}
	self.propActionList = {}
	self.needCheckMatchList = {}		--需要检测三消的坐标列表, 格式 { { r = r1, c = c1 }, { r = r2, c = c2 } }

	self.mapColorList = nil;			--当前地图可选颜色列表
	self.numberOfColors = 3;			--地图方块颜色数量
	self.colortypes = nil;				--颜色集合

	self.level = 0;
	self.randomSeed = 0;

	self.swapHelpMap = nil; 			--帮助做交换和Match的辅助Map
	self.swapHelpList = nil;
	self.swapHelpMakePos = nil;

	self.needCheckFalling = true			-- 标志位确定是否需要检查掉落（开关，设置为true后执行掉落消除直至稳定时被设置为false,isFallingStable属性为结果）
	self.isFallingStable = false			-- 标志位，表示当前是否处于掉落稳定状态
	self.isFallingStablePreFrame = false 	-- 标志位，表示上一帧是否处于掉落稳定状态

	self.FallingHelpMap = nil;
	self.isBlockChange = false;

	self.EffectHelpMap = nil;
	self.EffectSHelpMap = nil;
	self.EffectLightUpHelpMap = nil

	self.comboCount = 0;
	self.comboHelpDataSet = nil;		----连击帮助集合
	self.comboHelpList = nil;			----连击帮助列表
	self.comboHelpNumCountList = nil; 	----连击消除小动物数量
	self.comboSumBombScore = nil;		----连击的引爆分数
	self.totalScore = 0;
	self.coinDestroyNum = 0 			----销毁的银币数量

	self.balloonFrom = 0             ---------气球的剩余步数
	self.addMoveBase = GamePlayConfig_Add_Move_Base                 ---------气球爆炸增加的步数

	self.isWaitingOperation = false		----正在等待用户操作 

	self.isShowAdvise = false;

	self.theGamePlayType = 0;
	self.theGamePlayStatus = 0;			----当前游戏的状态
	self.theCurMoves = 0;				----当前剩余移动量
	self.realCostMove = 0 				----实际使用过的步数
	self.scoreTargets = {1,2,3};

	self.ingredientsTotal = 0;			----需要掉落的豆荚总数
	self.ingredientsCount = 0;

	self.ingredientsProductDropList = {};		----可以掉落豆荚的掉落口列表

	self.kLightUpTotal = 0;
	self.kLightUpLeftCount = 0;			----剩余的冰层数量

	self.isGamePaused = false;			----是否暂停
	self.timeTotalLimit = 0;			----总时间限制
	self.timeTotalUsed = 0;				----总时间消耗
	self.extraTime 		= 0;
	self.flyingAddTime = 0

	self.theOrderList = {};				----目标列表

	-- 重放代码记录
	self.replaying = false
	self.replaySteps = {}
	self.replayStep = 1

	-- random bonus
	self.randomAnimalHelpList = {}		----最后随机时屏幕中所有可以被随机到的item

	self.randFactory = HERandomObject:create(); -- rand(l, h) = [l, h]
	-- local oldRandFunc = self.randFactory.rand
	-- self.randFactory.rand = function(this, s, e)
	-- 	local result = oldRandFunc(this, s, e)
	-- 	print(result, debug.traceback())
	-- 	return result
	-- end
	self.PlayUIDelegate = nil;

	-- step stable 相关
	self.hasUseRevertThisRound = false   ----是否在此次操作回合内使用过回退道具,游戏初始化后未操作前需要禁用回退
	self.isInStep = false 				----此次Falling&Match状态是否由swap操作引起，与之对应的是由道具操作引起
	self.isBonusTime = false

	self.isVenomDestroyedInStep = false ----是否在本次操作回合内消除过毒液

	self.isUFOWin = false
	self.UFOCollection = {}           ------ufo 收集的豌豆荚
	self.tileBlockCount = 3

	self.pm25count = 0        --------pm2.5计数

	self.snailCount = 0
	self.snailMoveCount = 0

	self.setWriteReplayEnable = true     ----------是否可以写replay

	self.honeys = 0        ----------------蜂蜜罐破裂要传染的个数
	self.questionMarkFirstBomb = true
	self.isFirstRefreshComplete = true

	self.replay = nil               ------本关卡需要记录的replay
	self.allReplay = nil            ------所有replay信息

	self.toBeCollected = 0         ----将要被收集的数量

	self.digJewelLeftCount = 999 --步数挖地 当前还需要挖的宝石数量，为0时过关
	self.digJewelTotalCount = 999 --步数挖地 总共需要挖的宝石数量
end

function GameBoardLogic:encryptionFunc( key, value )
	if key == "theCurMoves" 
	or key == "totalScore" 
	or key == "ingredientsCount" 
	or key == "kLightUpLeftCount" then
		if value == nil then value = 0 end
		HeMemDataHolder:setInteger(self:getEncryptKey(key), value)
		return true
	end
	return false
end

function GameBoardLogic:decryptionFunc( key )
	if key == "theCurMoves" 
	or key == "totalScore" 
	or key == "ingredientsCount" 
	or key == "kLightUpLeftCount" then
		return HeMemDataHolder:getInteger(self:getEncryptKey(key))
	end
	return nil
end

function GameBoardLogic:getEncryptKey(key)
	return key .. "_" .. self.encryptIndex
end

function GameBoardLogic:dispose()
	
	self:stopTargetTip()

	if self.theOrderList and #self.theOrderList > 0 then
		for i,v in ipairs(self.theOrderList) do v:dispose() end
		self.theOrderList = nil
	end

	self:stopMoveTileEffect()

	self.isUFOWin = nil
	self.UFOCollection = nil
	self.gameconfig = nil
	self.posAdd = nil
	self.boardmap = nil
	self.gameItemMap = nil
	self.digItemMap = nil
	self.digBoardMap = nil

	self.mapColorList = nil
	self.colortypes = nil

	self.swapHelpMap = nil
	self.swapHelpList = nil
	self.swapHelpMakePos = nil

	self.gameActionList = nil
	self.FallingHelpMap = nil

	self.EffectHelpMap = nil
	self.EffectSHelpMap = nil
	self.EffectLightUpHelpMap = nil

	self.comboHelpDataSet = nil
	self.comboHelpList = nil
	self.comboHelpNumCountList = nil
	self.comboSumBombScore = nil
	self.pm25 = nil
	self.pm25count = nil
	self.honeys =nil

	self:stopEliminateAdvise()

	self.fsm:dispose()
	self.fsm = nil

	self.replay = nil
	self.allReplay = nil
	self.toBeCollected = nil

end

function GameBoardLogic:create()
	local v = GameBoardLogic.new()
	v:initBoard()
	return v
end

function GameBoardLogic:initBoard()
	self.boardmap = {}
	for i= 1,9 do
		self.boardmap[i] = {}
		for j=1,9 do
			self.boardmap[i][j] = GameBoardData:create();
		end
	end

	self.gameItemMap = {}
	for i=1,9 do
		self.gameItemMap[i] = {}
		for j=1,9 do
			self.gameItemMap[i][j] = GameItemData:create();
		end
	end
  
	self.gameMode = nil

	self.mapColorList = {}
	self.colortypes = {}

	self.FallingHelpMap = {}
	self.EffectHelpMap = {}

	self.comboCount = 0;
	self.comboHelpDataSet = nil;		----连击帮助集合
	self.comboHelpList = nil;			----连击帮助列表
	self.comboHelpNumCountList = nil; 	----连击消除小动物数量
	self.comboSumBombScore = nil;		----连击的引爆分数
	self.totalScore = 0;

	self.isWaitingOperation = false;

	self.isShowAdvise = false;

	self.theGamePlayType = 0;
	self.theGamePlayStatus = 0;			----当前游戏的状态
	self.theCurMoves = 0;				----当前剩余移动量
	self.scoreTargets = {1,2,3};

	self.ingredientsTotal = 0;			----需要掉落的豆荚总数
	self.ingredientsCount = 0;

	self.ingredientsProductDropList = {};		----可以掉落豆荚的掉落口列表

	self.kLightUpTotal = 0;
	self.kLightUpLeftCount = 0;			----剩余的冰层数量

	self.isGamePaused = false;			----是否暂停
	self.timeTotalLimit = 0;			----总时间限制
	self.extraTime = 0;					----获得的总额外时间
	self.timeTotalUsed = 0;				----总时间消耗

	self.theOrderList = {};				----目标列表
	self.hasDropDownUFO = false         -----ufo

	self.fsm = StateMachine:create(self)
	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end

----游戏逻辑更新循环
function GameBoardLogic:updateGame(dt)
	self.fsm:update(dt)
	self.gameMode:update(dt)
end

function GameBoardLogic:fallingMatchUpdate(dt)
	GameBoardActionRunner:runActionList(self, true)					-- 处理动作列表中的动作
	if self.needCheckFalling then									-- 检查掉落检测的开关
		local st1 = DestructionPlanLogic:update(self)
		ItemHalfStableCheckLogic:checkAllMap(self)
		MatchItemLogic:checkPossibleMatch(self)
		local st2 = DestroyItemLogic:update(self)
		local st3 = FallingItemLogic:FallingGameItemCheck(self)		
		local st4 = FallingItemExecutorLogic:update(self)
		ItemHalfStableCheckLogic:checkElasticAnimation(self)
		
		if self.frameDebug then
			-- print("-------------------------------------------")
			self:testEmpty()
			debug.debug()
		end

		self.isFallingStablePreFrame = false
		self.isFallingStable = not st1 and not st2 and not st3 and not st4
		self.needCheckFalling = not self.isFallingStable
	end
	self:tryStableHandle()
end

-----------------------------
--重置被特效打中的map
-----------------------------
function GameBoardLogic:resetSpecialEffectList(actid)
	for r = 1, #self.gameItemMap do 
		for c = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item.specialEffectList then 
				item.specialEffectList[actid] = nil 
			end
		end
	end
end

function GameBoardLogic:getTotalLimitTime()
	local extraTime = self.extraTime or 0
	return self.timeTotalLimit + extraTime
end

function GameBoardLogic:addExtraTime(extraTime)
	self.extraTime = self.extraTime or 0
	self.extraTime = self.extraTime + extraTime
end

function GameBoardLogic:numDestrunctionPlan()
	local count = 0
	for k, v in pairs(self.destructionPlanList) do
		count = count + 1
	end
	return count
end

function GameBoardLogic:isItemAllStable()
	for r = 1, #self.gameItemMap do
		for c = 1, #self.gameItemMap[r] do
			local tempItem = self.gameItemMap[r][c]
			if tempItem and tempItem.isUsed and not tempItem.isEmpty 
				and tempItem.ItemType ~= GameItemType.kNone 
				and tempItem.ItemStatus ~= GameItemStatusType.kNone then
				return false
			end
		end
	end
	return true
end

function GameBoardLogic:tryStableHandle()
	if self.isFallingStable and not self.isFallingStablePreFrame then
		self.isFallingStablePreFrame = true
		if self.waitForElasticAnimation then
			self.waitForElasticAnimation = false
			local scheduleId
			local function waitForElasticAnimationCallback( dt )
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleId)
				self:boardStableHandler()
			end
			scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(waitForElasticAnimationCallback,0.2,false);
		else
			self:boardStableHandler()
		end
	end
end

function GameBoardLogic:boardStableHandler()
	print("-----------------------------stable")
	self.fsm:boardStableHandler()
end

function GameBoardLogic:markVenomDestroyedInStep()
	self.isVenomDestroyedInStep = true
end

function GameBoardLogic:refreshComplete()
	if self.hasDestroyGift then
		if self.PlayUIDelegate then
			self.isAdviseBannedThisRound = self.PlayUIDelegate:onGetItem("gift")
		end
	end
	if self.PlayUIDelegate and self.isInStep then
		self.isAdviseBannedThisRound = false
		self.isAdviseBannedThisRound = self.isAdviseBannedThisRound or self.PlayUIDelegate:onGameStable()
	end

	if self.PlayUIDelegate and self.firstProduceQuestionMark and self.gameMode:is(MaydayEndlessMode) then
		self.PlayUIDelegate:tryFirstQuestionMark(self)
	end

	if self.PlayUIDelegate and self.gameMode:is(MaydayEndlessMode) then
		if self.isFullFirework then
			if self.theCurMoves == 1 then
				--self.PlayUIDelegate:onShowFullFireworkTip()
			else
				self.PlayUIDelegate:tryFirstFullFirework()
			end
		end
	end

	if self.isFirstRefreshComplete then 
		self.isFirstRefreshComplete = false
	elseif self.PlayUIDelegate and self.theGamePlayType == GamePlayType.kUnlockAreaDropDown then 
		-- debug.debug()
		self.PlayUIDelegate:playSquirrelMoveAnimation()
	end

	ScoreCountLogic:endCombo(self)
	self.isInStep = false
	if self.theGamePlayStatus == GamePlayStatus.kNormal then
		if self.gameMode.refreshFailedDirectSuccess == true or self.gameMode:reachEndCondition() then
			self.fsm:afterRefreshStable(false)
			self:setGamePlayStatus(GamePlayStatus.kEnd)
		else
			self.fsm:afterRefreshStable(true)
		end
	end
end

function GameBoardLogic:getIcePosList()
	local posList = {}
	local boardmap = self.boardmap or {}
    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local item = boardmap[r][c]
            if item and item.iceLevel > 0 then
            	local pos = self:getGameItemPosInView(r,c)
            	table.insert(posList, pos)
           	end
        end
    end

    return posList
end

function GameBoardLogic:getSnowPosList()
	local posList = {}
	for r = 1, #self.gameItemMap do
		for c  = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item and item.snowLevel>0 then
            	local pos = self:getGameItemPosInView(r,c)
            	table.insert(posList, pos)
           	end
        end
    end

    return posList
end

function GameBoardLogic:getHoneyPosList()
	local posList = {}
	for r = 1, #self.gameItemMap do
		for c  = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item and (item.honeyLevel>0) then
            	local pos = self:getGameItemPosInView(r,c)
            	table.insert(posList, pos)
           	end
        end
    end

    return posList
end

function GameBoardLogic:clearTargetTip()
	if self.targetTipIcons then
		for i,v in ipairs(self.targetTipIcons) do
			v:removeFromParentAndCleanup(true)
		end
	end
	self.targetTipIcons = {}
end

function GameBoardLogic:startTargetTip()
	print("ice count: ", self.kLightUpLeftCount)
	if self.targetTipScheduleId then
		return
	end

	if self.timeOutID then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOutID)
		self.timeOutID = nil
	end

	local function playTargetTip(posList)
		for i,v in ipairs(posList) do
			
			local effectSprite = Sprite:createWithSpriteFrameName("targetTips_010.png")
			local frames = SpriteUtil:buildFrames("targetTips_%03d.png", 0, 20)
			local animate = SpriteUtil:buildAnimate(frames, 1/40)
			effectSprite:play(animate, 0.1, 1, nil, true)
			effectSprite:setPosition(ccp(v.x+2, v.y-2))

			self.PlayUIDelegate.otherElementsLayer:addChild(effectSprite)
			table.insert(self.targetTipIcons, effectSprite)
		end
	end

	local function checkSnowTarget()
		local snowNumber = 0
		local honeyNumber = 0
		local snowTargetExist = false
		local honeyExist = false
		if self.theOrderList then
			for index,orderData in ipairs(self.theOrderList) do
				if orderData.key1 == GameItemOrderType.kSpecialTarget and orderData.key2 == GameItemOrderType_ST.kSnowFlower then
					snowNumber = orderData.v1 - orderData.f1
					print("left snowNumber: ", snowNumber)
					snowTargetExist = true
				end

				if orderData.key1 == GameItemOrderType.kOthers and orderData.key2 == GameItemOrderType_Others.kHoney then
					honeyNumber = orderData.v1 - orderData.f1
					honeyTargetExist = true
					print("left honeyNumber: ", honeyNumber)
				end
			end
		end

		local totalTargetNumber = snowNumber+honeyNumber
		return totalTargetNumber>0 and totalTargetNumber<=3, snowTargetExist, honeyTargetExist
	end

	function showTargetTip()
		self:clearTargetTip()
		--ice level
		if self.theGamePlayType == GamePlayType.kLightUp then--and self.kLightUpLeftCount<=80 then
			local icePosList = self:getIcePosList()
			if #icePosList <= 3 then
				print("@@@@@@@@start to show ice tip!!!!!")
				playTargetTip(icePosList)
			end
		end

		--check for snow level
		if self.theGamePlayType == GamePlayType.kOrder then
			local checkEnable, snowTargetExist, honeyTargetExist = checkSnowTarget()
			if checkEnable then
				if snowTargetExist then
					local snowPosList = self:getSnowPosList()
					print("@@@@@@@@start to show snow tip!!!!!")
					playTargetTip(snowPosList)
				end

				if honeyTargetExist then
					local snowPosList = self:getHoneyPosList()
					print("@@@@@@@@start to show honey tip!!!!!")
					playTargetTip(snowPosList)
				end
			end
		end

	end

	function scheduleTargetTip()
		local targetTipScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(showTargetTip, 8.5, false)	
		self.targetTipScheduleId = targetTipScheduleId
	end

	self.timeOutID = setTimeOut(function()
			showTargetTip()
			scheduleTargetTip()
		end, 3)
end

function GameBoardLogic:stopTargetTip()
	print("----------stop target tip")
	if self.timeOutID then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOutID)
		self.timeOutID = nil
	end

	if self.targetTipScheduleId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.targetTipScheduleId)
		self:hideTargetTip()
		self.targetTipScheduleId = nil
	end
end

function GameBoardLogic:hideTargetTip()
	print("todo: hide target tip!!!!!")
	self:clearTargetTip()
end

function GameBoardLogic:startMoveTileEffect()
	local function showMoveTileEffect()
		if self.boardmap then
			for i = 1, #self.boardmap do
				for j = 1, #self.boardmap[i] do
					local board = self.boardmap[i][j]
					if board and board.isMoveTile then
						local roteMeta = board.tileMoveMeta:findRouteByPos(i, j, board.tileMoveReverse)
						if roteMeta then
							local itemView = self.boardView.baseMap[i][j]
							itemView:showMoveTileEffect(roteMeta:getDirection(board.tileMoveReverse))
						end
					end
				end
			end
		end
	end

	if self.moveTileEffectScheduleId then
		self:stopMoveTileEffect()
	end

	local moveTileEffectScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(showMoveTileEffect, 10, false)	
	self.moveTileEffectScheduleId = moveTileEffectScheduleId
end

function GameBoardLogic:stopMoveTileEffect()
	if self.moveTileEffectScheduleId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.moveTileEffectScheduleId)
		self.moveTileEffectScheduleId = nil
		if self.boardmap then
			for i = 1, #self.boardmap do
				for j = 1, #self.boardmap[i] do
					local board = self.boardmap[i][j]
					if board and board.isMoveTile then
						local itemView = self.boardView.baseMap[i][j]
						itemView:hideMoveTileEffect()
					end
				end
			end
		end
	end
end

function GameBoardLogic:startEliminateAdvise()
	print("----------start advise")
	if self.isAdviseBannedThisRound then
		return
	end

	local possibleSwapList = SwapItemLogic:calculatePossibleSwap(self)
	local targetPossibleSwap = possibleSwapList[math.random(#possibleSwapList)]
	self.targetPossibleSwap = targetPossibleSwap

	local function showEliminateAdvise(dt)
		self:showEliminateAdvise(dt)
	end

	if self.eliminateAdviseScheduleId then
		self:stopEliminateAdvise()
	end

	local eliminateAdviseScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(showEliminateAdvise, 8.5, false)	
	self.eliminateAdviseScheduleId = eliminateAdviseScheduleId

	local function showSquirrelDoze( ... )
		-- body
		if self.PlayUIDelegate then 
			self.PlayUIDelegate:playSquirrelAnimation()
		end
	end
	local squirrelDozeScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(showSquirrelDoze, 15, false)
	self.squirrelDozeScheduleId = squirrelDozeScheduleId
end

function GameBoardLogic:stopEliminateAdvise()
	print("----------stop advise")
	if self.eliminateAdviseScheduleId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.eliminateAdviseScheduleId)
		self:hideEliminateAdvise()
		self.eliminateAdviseScheduleId = nil
	end

	if self.squirrelDozeScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.squirrelDozeScheduleId)
		self.squirrelDozeScheduleId = nil
	end

end

function GameBoardLogic:showEliminateAdvise(dt)

	-- test by wenkan

	local function getMirrorDir(dir)
		local result = { r = dir.r, c = dir.c }
		if dir.r ~= 0 then
			result.r = -result.r
		else
			result.c = -result.c
		end
		return result
	end
	if self.boardView and self.boardView.baseMap then
		for i, v in ipairs(self.targetPossibleSwap) do
			local itemView = self.boardView.baseMap[v.r][v.c]
			local dir = self.targetPossibleSwap["dir"]
			if i ~= 1 then
				dir = getMirrorDir(dir) 
			end
			itemView:showAdviseEffect(dir)
			GamePlayMusicPlayer:playEffect(GameMusicType.kEliminateTip)
		end
	end
end

function GameBoardLogic:hideEliminateAdvise()
	if self.gameItemMap then
		for i, v in ipairs(self.targetPossibleSwap) do
			local itemView = self.boardView.baseMap[v.r][v.c]
			itemView:stopAdviseEffect()
			itemView:upDatePosBoardDataPos(self.gameItemMap[v.r][v.c], true)
		end
	end
end

function GameBoardLogic:setNeedCheckFalling()
	self.needCheckFalling = true
end

function GameBoardLogic:setGamePlayStatus(state)
	if (state ~= self.theGamePlayStatus) then
		if state == GamePlayStatus.kEnd then
			if self.PlayUIDelegate then
				self.PlayUIDelegate:setPauseBtnEnable(false)
			end
			if self.gameMode:reachTarget() then
				self.leftMoveToWin = self.theCurMoves
				if self.theGamePlayType == GamePlayType.kUnlockAreaDropDown then 
					self:setGamePlayStatus(GamePlayStatus.kAferBonus)
				else
					self:setGamePlayStatus(GamePlayStatus.kBonus)
				end
			else
				self.gameMode:afterFail()
			end
		elseif state == GamePlayStatus.kNormal then
			-- left empty
		elseif state == GamePlayStatus.kFailed then
			local targetCount = nil
			local opLog = nil
			local star = 0
			if self.theGamePlayType == GamePlayType.kDigMoveEndless then 
				targetCount = self.digJewelCount:getValue()
			elseif self.theGamePlayType == GamePlayType.kMaydayEndless
			or self.theGamePlayType == GamePlayType.kHalloween then
				targetCount = self.digJewelCount:getValue()
			elseif self.theGamePlayType == GamePlayType.kRabbitWeekly then
				targetCount = self.rabbitCount:getValue()
			end
			if self.theGamePlayType == GamePlayType.kMaydayEndless and self.gameMode:getFailReason() == 'refresh' then
				star = self.gameMode:getScoreStarLevel()
			end

			if self.PlayUIDelegate then
				FUUUManager:onGameDefiniteFinish(false , self)
				self.PlayUIDelegate:failLevel(self.level, self.totalScore, star, math.floor(self.timeTotalUsed), self.coinDestroyNum, targetCount, opLog, self.gameMode:reachTarget(), self.gameMode:getFailReason())
			end
		elseif state == GamePlayStatus.kBonus then
			if self.dropBuffLogic then 
				self.dropBuffLogic:setDropBuffEnable(false)
			end
			if BombItemLogic:getNumSpecialBomb(self) > 0 
				or (self.gameMode:canChangeMoveToStripe() and self.theCurMoves > 0)
				or self.gameMode:is(MaydayEndlessMode)
				then
			 	self.comboCount = 0
				GamePlayMusicPlayer:playEffect(GameMusicType.kBonusTime);
				if self.PlayUIDelegate and self.PlayUIDelegate.effectLayer then
					self.PlayUIDelegate.effectLayer:removeChildren(true)
					self.PlayUIDelegate.effectLayer:addChild(CommonEffect:buildBonusEffect())
				end

				self.isBonusTime = true
				self.fsm:changeState(self.fsm.fallingMatchState)
				self.fsm:boardStableHandler()
			else
				local function endGame()
					self:setGamePlayStatus(GamePlayStatus.kAferBonus)
				end
				setTimeOut(endGame, 1)
			end
		elseif state == GamePlayStatus.kWin then
			local targetCount = nil
			local bossCount = nil
			local opLog = nil 
			if self.theGamePlayType == GamePlayType.kDigMoveEndless then 
				targetCount = self.digJewelCount:getValue()
			elseif self.theGamePlayType == GamePlayType.kMaydayEndless
			or self.theGamePlayType == GamePlayType.kHalloween then
				targetCount = self.digJewelCount:getValue()
				bossCount = self.maydayBossCount
			elseif self.theGamePlayType == GamePlayType.kRabbitWeekly then
				targetCount = self.rabbitCount:getValue()
			end
			if self.PlayUIDelegate then
				self.PlayUIDelegate:passLevel(self.level, self.totalScore, self.gameMode:getScoreStarLevel(), math.floor(self.timeTotalUsed), self.coinDestroyNum, targetCount, opLog, bossCount)			
			end
			if self.theGamePlayType ~= GamePlayType.kDigTime and 
				self.theGamePlayType ~= GamePlayType.kClassic and 
				self.theGamePlayType ~= GamePlayType.kClassicMoves and
				self.theGamePlayType ~= GamePlayType.kDigMoveEndless and
				self.theGamePlayType ~= GamePlayType.kRabbitWeekly then
				
				ShareManager:setShareData(ShareManager.ConditionType.LEFT_STEP,self.leftMoveToWin)
				ShareManager:shareWithID( ShareManager.LAST_STEP_PASS )
			else
				ShareManager:setShareData(ShareManager.ConditionType.LEFT_STEP,1)
			end
			
			if self.theGamePlayType ~= GamePlayType.kRabbitWeekly then 
				ShareManager:setShareData(ShareManager.ConditionType.PASS_STEP,self.realCostMove)
				ShareManager:shareWithID( ShareManager.PASS_STEP )
			end
			FUUUManager:onGameDefiniteFinish(true , self)
		elseif state == GamePlayStatus.kAferBonus then
			local function gameResultShow( ... )
				-- body
				if (self.gameMode:getScoreStarLevel() > 0) then
					self:setGamePlayStatus(GamePlayStatus.kWin)
				else
					self:setGamePlayStatus(GamePlayStatus.kFailed)
				end
			end
			if self.theGamePlayType == GamePlayType.kUnlockAreaDropDown then
				self.PlayUIDelegate:playSquirrelGiveKeyAnimation(gameResultShow)
			else
				gameResultShow()
			end
			
		end

		if state ~= GamePlayStatus.kNormal then
			self:stopWaitingOperation()
		end
		self.theGamePlayStatus = state
	end
end

function GameBoardLogic:initByConfig(level, config, levelType)
	he_log_info(string.format("GameBoardLogic:initByConfig level %d",level))

	self.level = level
	self.levelType = levelType
	self.totalScore = 0
	self.randomSeed = config.randomSeed
	if self.randomSeed == nil then self.randomSeed = 0 end

 	if self.randomSeed ~= 0 then 
 		self.randFactory:randSeed(self.randomSeed)
 	else
 		self.randomSeed = os.time()
 		self.randFactory:randSeed(self.randomSeed)
 	end

	print("level init id:", level, "randomSeed:", self.randomSeed)

	self.theGamePlayType = LevelMapManager:getLevelGameModeByName(config.gameMode)

	--气球处理
	if config.balloonFrom then 
		self.balloonFrom = config.balloonFrom
	end

	if config.addMoveBase and config.addMoveBase > 0 then
		self.addMoveBase = tonumber(config.addMoveBase)
		if self.addMoveBase > 9 then
			self.addMoveBase = 9
		end
	end

	if config.addTime then
		self.addTime = tonumber(config.addTime)
		if self.addTime > 9 then
			self.addTime = 9
		end
	end

	self.uncertainCfg1 = config.uncertainCfg1
	self.uncertainCfg2 = config.uncertainCfg2

	self.honeys = config.honeys
	self.hasDropDownUFO = config.hasDropDownUFO or self.theGamePlayType == GamePlayType.kRabbitWeekly
	self.pm25 = config.pm25

	-- 初始化神奇掉落规则
	self.dropBuffLogic = DropBuffLogic:create(self, config)

	GameMapInitialLogic:init(self, config)
	FallingItemLogic:preUpdateHelpMap(self)

	self.gameMode = GameModeFactory:create(self)
	self.theCurMoves = config.moveLimit
	if not self.theCurMoves then self.theCurMoves = 0 end
	self.scoreTargets = config.scoreTargets
	self.replaceColorMaxNum = config.replaceColorMaxNum

	self.needCheckFalling = true
	self.isFallingStable = false
	self.isFallingStablePreFrame = false
	self.timeTotalUsed = 0
	self.theGamePlayStatus = GamePlayStatus.kPreStart
	self.ingredientsCount = 0

	self.gameMode:initModeSpecial(config)
	FUUUManager:update(self.gameMode)
	ProductItemLogic:init(self, config)

	self.gamePlayEventTrigger = GamePlayEventTrigger:create()
end


function GameBoardLogic:getSnailTotalCount( )
	-- body
	local orderlist = self.theOrderList
	for k, v in pairs(orderlist) do 
		if v.key1 ==GameItemOrderType.kSpecialTarget and v.key2 == GameItemOrderType_ST.kSnail then 
			return v.v1
		end
	end
	return 0
end

function GameBoardLogic:getSnailOnScreenCount( ... )
	-- body
	local result = 0
	for r = 1, #self.gameItemMap do
		for c  = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item and item.isSnail then
				result = result + 1
			end
		end
	end 
	return result
end

function GameBoardLogic:onGameInit()
	self.gameMode:onGameInit()
end

function GameBoardLogic:getColorOfGameItem(r, c)--获取动物、水晶、gift、牢笼的颜色
	local color = 0
	if self:isPosValid(r, c) then
		local item = self.gameItemMap[r][c]
		if item:canBeCoverByMatch() then
			color = item.ItemColorType
		end
	end
	return color
end

function GameBoardLogic:checkMatchQuick(r,c, color)	--快速检测如果r、c位置是color会怎样
	local x1 = self:getColorOfGameItem(r - 2 , c)
	local x2 = self:getColorOfGameItem(r - 1 , c)
	local x3 = self:getColorOfGameItem(r + 1 , c)
	local x4 = self:getColorOfGameItem(r + 2 , c)

	local y1 = self:getColorOfGameItem(r , c - 2)
	local y2 = self:getColorOfGameItem(r , c - 1)
	local y3 = self:getColorOfGameItem(r , c + 1)
	local y4 = self:getColorOfGameItem(r , c + 2)

	if (color == x2 and x1 == x2)
		or (color == x2 and color == x3)
		or (color == x3 and color == x4)
		or (color == y2 and y1 == y2)
		or (color == y2 and y3 == y2)
		or (color == y3 and y3 == y4)
		then
		return true
	end
	return false
end

----产生一个新的掉落数据
function GameBoardLogic:randomANewItemFallingData(r,c)
	local data = ProductItemLogic:product(self, r, c)
	return data
end

function GameBoardLogic:randomColor()
	if self.dropBuffLogic and self.dropBuffLogic.dropBuffEnable then
		return self.dropBuffLogic:randomColor()
	end
	local x = self.randFactory:rand(1,#self.mapColorList)
	return self.mapColorList[x]
end


function GameBoardLogic:getBoardMap()
	return self.boardmap
end

function GameBoardLogic:getItemMap()
	return self.gameItemMap
end

function GameBoardLogic:isItemCanUsed(r,c)		--地图上可以被使用的地块
	if self.boardmap[r]
		and self.boardmap[r][c]
		and self.boardmap[r][c].isUsed
		then
		return true
	end
	return false
end

function GameBoardLogic:checkItemBlock(r,c)
	local item = self.gameItemMap[r][c];
	local board = self.boardmap[r][c];

	if item:checkBlock() then
		self.isBlockChange = true;
	end
	board.isBlock = item.isBlock;
	return self.isBlockChange
end

function GameBoardLogic:setChainBreaked()
	self.chainBreaked = true
end

function GameBoardLogic:setTileMoved()
	self.tileMoved = true
end

----更新Block的状态来影响下落
function GameBoardLogic:updateFallingAndBlockStatus()
	if self.isBlockChange or self.chainBreaked or self.tileMoved then
		FallingItemLogic:updateHelpMapByDeleteBlock(self)
		self.isBlockChange = false
		self.chainBreaked = false
		self.tileMoved = false
	end
end

function GameBoardLogic:isItemCanMoved(r,c)		--地图上可以被移动的Item
	if r > 0 and r<= #self.gameItemMap and c>0 and c<= #self.gameItemMap[r] then
		local item = self.gameItemMap[r][c]
		if item and item:canBeSwap() then
			return true
		end
	end
	return false
end

function GameBoardLogic:isItemInTile(r, c)	-- 判断点击位置是否在棋盘有效位置中
	if r > 0 and r <= #self.boardmap and c > 0 and c <= #self.boardmap[r] then
		if self.boardmap[r] and self.boardmap[r][c] and self.boardmap[r][c].isUsed and
			self.gameItemMap[r] and self.gameItemMap[r][c] and self.gameItemMap[r][c].isUsed then
			return true
		end
	end
	return false
end

--可以被交换，但是不一定有匹配
function GameBoardLogic:canBeSwaped(r1,c1,r2,c2)
	if not self.isWaitingOperation or self.theGamePlayStatus ~= GamePlayStatus.kNormal then
		return 0
	end
	return SwapItemLogic:canBeSwaped(self, r1,c1,r2,c2)
end

function GameBoardLogic:canUseHammer(r, c)
	local item = self.gameItemMap[r][c]
	return item:canBeEffectByHammer()
end

function GameBoardLogic:canUseLineBrush(r, c)
	if self.gameItemMap[r][c].ItemType ~= GameItemType.kAnimal or
		self.gameItemMap[r][c].ItemSpecialType >= AnimalTypeConfig.kLine then
		return false
	end
	return true
end

function GameBoardLogic:canUseForceSwap(r1, c1, r2, c2)
	if not self:isItemCanMoved(r1, c1) or not self:isItemCanMoved(r2, c2) or
		not self:tileNextToEachOther(r1, c1, r2, c2) then
		return false
	end
	return true
end

function GameBoardLogic:isNormal(item)
    if item.ItemType == GameItemType.kAnimal
	    and item.ItemSpecialType == 0 -- not special
	    and item:isAvailable()
	    and not item:hasLock() 
	    and not item:hasFurball()
	    then
	        return true
    end
    return false
end

function GameBoardLogic:canUseRandomBird()
	for r=1, #self.gameItemMap do
		for c = 1, #self.gameItemMap[r] do
			local item = self.gameItemMap[r][c]
			if item and self:isNormal(item) then
				return true
			end
		end
	end
	return false
end

function GameBoardLogic:canUseBroom(r, c)
	local rows = self:getBroomRows(r)
	return not (self:isRowEmpty(rows.r1) and self:isRowEmpty(rows.r2))
end

--开始尝试交换两个Item，期间不能点击其他东西，交换结束后，可以匹配消除，则消除，不能则进行物品回调
function GameBoardLogic:startTrySwapedItem(r1,c1,r2,c2)
	local gameBoardActionItem1 = IntCoord:create(r1,c1)
	local gameBoardActionItem2 = IntCoord:create(r2,c2)
	local theAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameBoardAction,		--动作发起主体	--能够进行普通交换ard为主体
		GameBoardActionType.kStartTrySwapItem,		--动作类型	    --能够进行普通交换交换两个Item
		gameBoardActionItem1,						--动作物体1		
		gameBoardActionItem2,						--动作物体2		
		GamePlayConfig_SwapAction_CD)				--动作持续时间	--将引起一下次数据变化
	self:addSwapAction(theAction)
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwap)
end

function GameBoardLogic:startWaitingOperation()
	self.isWaitingOperation = true
	self.gamePlayEventTrigger:chechMatch(self)
	self:onWaitingOperationChanged()
end

function GameBoardLogic:stopWaitingOperation()
	self.isWaitingOperation = false
	self:onWaitingOperationChanged()
end

function GameBoardLogic:onWaitingOperationChanged()
	if self.isWaitingOperation == true then
		if self.boardView.isPaused == false then
			self:startEliminateAdvise()
			self:startMoveTileEffect()
			self:startTargetTip()
		else
			self:stopEliminateAdvise()
			self:stopMoveTileEffect()
			self:stopTargetTip()
		end

		if self.PlayUIDelegate then
			self.PlayUIDelegate:setItemTouchEnabled(true)
			if self.hasUseRevertThisRound then
				self.PlayUIDelegate:setPropState(GamePropsType.kBack, 2, false)
			elseif not self.saveRevertData then
				-- init disable revert prop, left empty
			else
				self.PlayUIDelegate:setPropState(GamePropsType.kBack, nil, true)
			end		
			if self.PlayUIDelegate:hasInGameProp(GamePropsType.kRandomBird) then
				if not self:canUseRandomBird() then
					self.PlayUIDelegate:setPropState(GamePropsType.kRandomBird, 4, false)
				else
					self.PlayUIDelegate:setPropState(GamePropsType.kRandomBird, nil, true)
				end
			end
		end
	elseif self.isWaitingOperation == false then
		self:stopEliminateAdvise()
		self:stopMoveTileEffect()
		self:stopTargetTip()
		if self.PlayUIDelegate then
			self.PlayUIDelegate:setItemTouchEnabled(false)
		end
		if self.boardView then
			self.boardView:stopOldSelectEffect()
		end
	end

end


----搞笑式移动两个方块----被绳子格挡住了
function GameBoardLogic:startTrySwapedItemFun(r1,c1,r2,c2)
	local gameBoardActionItem1 = IntCoord:create(r1,c1)
	local gameBoardActionItem2 = IntCoord:create(r2,c2)
	local theAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameBoardAction,		--动作发起主体	--能够进行普通交换ard为主体
		GameBoardActionType.kStartTrySwapItem_fun,		--动作类型	    --能够进行普通交换交换两个Item
		gameBoardActionItem1,						--动作物体1		
		gameBoardActionItem2,						--动作物体2		
		GamePlayConfig_SwapAction_Fun_CD)			--动作持续时间	--将引起一下次数据变化

	self:addSwapAction(theAction)
	GamePlayMusicPlayer:playEffect(GameMusicType.kSwapFun)
end

--添加一个新的动作到队列里面
function GameBoardLogic:addGameAction(theAction)
	self:addActionToList(theAction, self.gameActionList)
end

function GameBoardLogic:addDestructionPlanAction(theAction)
	self:addActionToList(theAction, self.destructionPlanList)
end

function GameBoardLogic:addDestroyAction(theAction)
	self:addActionToList(theAction, self.destroyActionList)
end

function GameBoardLogic:addFallingAction(theAction)
	self:addActionToList(theAction, self.fallingActionList)
end

function GameBoardLogic:addSwapAction(theAction)
	self:addActionToList(theAction, self.swapActionList)

	self.fsm:onStartSwap()
end

function GameBoardLogic:addPropAction(theAction)
	self:addActionToList(theAction, self.propActionList)
end

function GameBoardLogic:addActionToList(theAction, theList)
	local actCount = #theList + 1
	for i = 1, #theList do 					
		if theList[i] == nil then
			actCount = i
			break
		end
	end
	theList[actCount] = theAction
	theAction.actid = actCount	
end

function GameBoardLogic:addNeedCheckMatchPoint(r, c)
	table.insert(self.needCheckMatchList, { r = r, c = c })
end

function GameBoardLogic:cleanNeedCheckMatchList()
	self.needCheckMatchList = nil
	self.needCheckMatchList = {}
end

function GameBoardLogic:getGamePlayType(...)
	assert(#{...} == 0)

	return self.theGamePlayType
end

function GameBoardLogic:getActionListCount()
	if self.gameActionList == nil then
		self.gameActionList = {}
	end
	local n = 0
	for k,v in pairs(self.gameActionList) do
		n = n + 1
	end
	return n;
end

--交换两个Item--并且尝试匹配消除
function GameBoardLogic:SwapedItemAndMatch(r1,c1,r2,c2, doSwap)	--doSwap==true表示确实进行交换，并且引起相应效果，doSwap==false表示仅仅判断是否能够交换
	local tempSaveDataForRevert = self:getSaveDataForRevert()
	
	local swapInfo = { { r = r1, c = c1 }, { r = r2, c = c2 } }
	self.swapInfo = swapInfo

	local ret = SwapItemLogic:SwapedItemAndMatch(self, r1, c1, r2, c2, doSwap) 
	if ret and doSwap then
		self:UseMoves()
		self.saveRevertData = tempSaveDataForRevert
		if self.PlayUIDelegate then
			self.PlayUIDelegate:onGameSwap({x = r1, y = c1}, {x = r2, y = c2})
		end
	else
		self.swapInfo = nil
	end
	return ret
end

--获取当前的数据快照用于回退，包含item、board地格、分数记录等数据
function GameBoardLogic:getSaveDataForRevert()
	local ret = SaveRevertData:create(self)
	return ret
end

------返回魔力鸟非主动触发时消除的颜色类型------
function GameBoardLogic:getBirdEliminateColor()
	local colorlist = {}
	----1.求每个颜色的动物数量
	for r=1,#self.gameItemMap do
		for c=1,#self.gameItemMap[r] do
			local item = self.gameItemMap[r][c]
			if item:isColorful() then
				if item.bombRes == nil or (item.bombRes.x == 0 and item.bombRes.y == 0) then 		----已经被引爆的不计入颜色
					if (colorlist[item.ItemColorType] == nil )then
						colorlist[item.ItemColorType] = 1
					else
						colorlist[item.ItemColorType] = colorlist[item.ItemColorType] + 1
					end
				end
			end
		end
	end

	----2.求颜色最多的那个
	local colorTypeList = {}
	for k,v in pairs(colorlist) do
		if k >= AnimalTypeConfig.kBlue and k <= AnimalTypeConfig.kYellow then
			table.insert(colorTypeList, k)
		end
	end

	local result = nil
	if #colorTypeList > 0 then
		result = colorTypeList[self.randFactory:rand(1, #colorTypeList)]
	end
	return result
end

----返回地图上某个颜色的所有物体的Position----
function GameBoardLogic:getPosListOfColor(theColor)
	local posList = {}
	local count = 0

	if theColor and theColor > 0 then 			----正确颜色才会有引爆
		for r=1,#self.gameItemMap do
			for c=1,#self.gameItemMap[r] do
				local item = self.gameItemMap[r][c];
				if (item.ItemColorType == theColor) then
					count = count + 1;
					posList[count] = IntCoord:create(r,c)
				end
			end
		end
	end
	return posList
end

----使用某个道具
function GameBoardLogic:canUseProps()
	if self:getActionListCount() == 0 then
		return true;
	end
	return false;
end
function GameBoardLogic:useProps(propsType, r1, c1, r2, c2)
	if self.boardView then
		self.boardView:stopOldSelectEffect()
	end

	if not propsType then return false end
	if self:getActionListCount() == 0 then
		if propsType == GamePropsType.kRefresh 
			or propsType == GamePropsType.kRefresh_b 
			or propsType == GamePropsType.kRefresh_l
			then
			if RefreshItemLogic.tryRefresh(self) then
				-----成功了----
				RefreshItemLogic:runRefreshAction(self, true)
				self.fsm:changeState(self.fsm.usePropState)
			end
		elseif propsType == GamePropsType.kAdd5 then
			self.theCurMoves = self.theCurMoves + 5
			if self.PlayUIDelegate then
				self.PlayUIDelegate:setMoveOrTimeCountCallback(self.theCurMoves, false)
			end
			-- fallingMatchState
			if self.replaying then    --播放replay的特殊处理
				self.fsm.waitingState.nextState = self.fsm.waitingState
			end
		elseif propsType == GamePropsType.kSwap 
			or propsType == GamePropsType.kSwap_l 
			or propsType == GamePropsType.kSwap_b
			then
			print("********Swap")
			if not r1 or not r2 or not c1 or not c2 then
				return false
			end
			if not self:canUseForceSwap(r1, c1, r2, c2) then
				return false
			end
			local propAction = GameBoardActionDataSet:createAs(GameActionTargetType.kPropsAction,
				GamePropsActionType.kSwap, IntCoord:create(r1,c1), IntCoord:create(r2, c2), GamePlayConfig_SwapAction_CD)
			self:addPropAction(propAction)
			self.fsm:changeState(self.fsm.usePropState)
			print("********TheEnd")
		elseif propsType == GamePropsType.kLineBrush 
			or propsType == GamePropsType.kLineBrush_l 
			or propsType == GamePropsType.kLineBrush_b
			then
			print("********LineBrush")
			if not r1 or not c1 or not r2 or not c2 then
				return false
			end
			if not self:canUseLineBrush(r1, c1) then
				return false
			end
			local targetPos = IntCoord:create(r2, c2)
			local propAction = GameBoardActionDataSet:createAs(GameActionTargetType.kPropsAction,
				GamePropsActionType.kLineBrush, IntCoord:create(r1,c1), targetPos, GamePlayConfig_LineBrush_Animation_CD)
			self:addPropAction(propAction)
			self.fsm:changeState(self.fsm.usePropState)
			print("TheEnd")
		elseif propsType == GamePropsType.kHammer 
			or propsType == GamePropsType.kHammer_l 
			or propsType == GamePropsType.kHammer_b
			then
			print("********Hammer")
			if not r1 or not c1 then
				return false
			end
			if not self:canUseHammer(r1, c1) then
				return false
			end
			local propAction = GameBoardActionDataSet:createAs(GameActionTargetType.kPropsAction,
				GamePropsActionType.kHammer, IntCoord:create(r1,c1), nil, GamePlayConfig_Hammer_Animation_CD)
			self:addPropAction(propAction)
			self.fsm:changeState(self.fsm.usePropState)
			print("********TheEnd")
		elseif propsType == GamePropsType.kBack 
			or propsType == GamePropsType.kBack_b 
			then
			print("********TheRevert")
			self.hasUseRevertThisRound = true
			if self.saveRevertData then
				self.gameMode:revertDataFromBackProp()
				if self.PlayUIDelegate then
					local winSize = CCDirector:sharedDirector():getWinSize()
					local node = TimebackAnimation:create()
					node:setPosition(ccp(winSize.width / 2, winSize.height / 2))
					self.PlayUIDelegate.effectLayer:addChild(node)
				end
				local propAction = GameBoardActionDataSet:createAs(GameActionTargetType.kPropsAction, GamePropsActionType.kBack, nil, nil, GamePlayConfig_Back_AnimTime)
				self:addPropAction(propAction)
				self.fsm:changeState(self.fsm.usePropState)
			end
			print("********TheEnd")
		elseif propsType == GamePropsType.kOctopusForbid or propsType == GamePropsType.kOctopusForbid_l then
			local action = GameBoardActionDataSet:createAs(
			        GameActionTargetType.kPropsAction, 
			        GamePropsActionType.kOctopusForbid,
			        nil, 
			        nil, 
			        GamePlayConfig_Back_AnimTime)
			action.addInfo = ''
			self:addPropAction(action)
			self.fsm:changeState(self.fsm.usePropState)
			self.octopusWait = 3
			if self.PlayUIDelegate then
				self.PlayUIDelegate:setPropState(GamePropsType.kOctopusForbid,3, false)
			end
		elseif propsType == GamePropsType.kRandomBird then
			local action = GameBoardActionDataSet:createAs(
			        GameActionTargetType.kPropsAction, 
			        GamePropsActionType.kRandomBird,
			        IntCoord:create(r1, c1), 
			        nil, 
			        GamePlayConfig_Back_AnimTime)
			self:addPropAction(action)
			self.fsm:changeState(self.fsm.usePropState)
		elseif propsType == GamePropsType.kBroom or propsType == GamePropsType.kBroom_l then
			local rows = self:getBroomRows(r1)
			local action = GameBoardActionDataSet:createAs(
			        GameActionTargetType.kPropsAction, 
			        GamePropsActionType.kBroom,
			        nil, 
			        nil, 
			        GamePlayConfig_Back_AnimTime)
			action.rows = rows
			self:addPropAction(action)
			self.fsm:changeState(self.fsm.usePropState)
		elseif propsType == GamePropsType.kSpringFirework then
			local action = GameBoardActionDataSet:createAs(
		        GameActionTargetType.kPropsAction, 
		        GamePropsActionType.kFirecracker,
		        nil, 
		        nil, 
		        GamePlayConfig_MaxAction_time)
			self:addPropAction(action)
			self.fsm:changeState(self.fsm.usePropState)
		end
		r1, c1, r2, c2 = r1 or 0, c1 or 0, r2 or 0, c2 or 0
		if not self.replaying then
			-- table.insert(self.replaySteps, {prop = propsType, x1 = r1, y1 = c1, x2 = r2, y2 = c2})
			self:addReplayStep({prop = propsType, x1 = r1, y1 = c1, x2 = r2, y2 = c2})
			print("***********ReplayLog: Remembering Property usage!")
		end
		return true;
	end
	return false;
end

function GameBoardLogic:isRowEmpty(rowNum)
	local gameItemMap = self.gameItemMap
	local isEmpty = true
	if gameItemMap[rowNum] then
		for c = 1, #gameItemMap[rowNum] do
			local item = gameItemMap[rowNum][c]
			if item and item.isEmpty == false then
				isEmpty = false
				break
			end
		end
	end
	return isEmpty
end

function GameBoardLogic:getBroomRows(r)
	local r1 = r
	local r2 = r1 - 1
	if r2 < 1 or (self:isRowEmpty(r2) and r1 < 9) then
		r2 = r1 + 1
	end

    -- 保证r1 < r2
    if r1 > r2 then
        local _t = r1
        r1 = r2
        r2 = _t
    end
    return {r1 = r1, r2 = r2}
end

----使用一次移动
function GameBoardLogic:UseMoves()
	self.realCostMove = self.realCostMove + 1
	self.gameMode:useMove()

	----豆荚关变化
	ProductItemLogic:addStep(self)

	-- 重新计算颜色掉落概率
	if self.dropBuffLogic then
		if self.newCompletedAnimalOrders then 
			-- 完成后只有下一步开始才重新计算概率，使用道具不考虑
			self.dropBuffLogic:onAnimalOrderCompleted(self.newCompletedAnimalOrders)
			self.newCompletedAnimalOrders = nil
		end

		self.dropBuffLogic:onUseMoves(self.realCostMove)
	end

	self:updateMoveTilesOnUseMove()
	self:updateBossDataOnUseMove()

	self:resetStepRecords()
end

function GameBoardLogic:updateBossDataOnUseMove()
	if self.gameMode:is(HalloweenMode) then
		local boss = self:getHalloweenBoss()
		if boss then 
			boss.move = boss.move + 1
		end
	end
end

function GameBoardLogic:updateMoveTilesOnUseMove()
	local boardmap = self.boardmap or {}
    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local board = boardmap[r][c]
            if board and board.isMoveTile then
            	board:onUseMoves()
           	end
        end
    end
end

--开始移动回合前，重置所有步数稳定处理搜需要的标识位及数据
function GameBoardLogic:resetStepRecords()
	self.isInStep = true 

	self.isVenomDestroyedInStep = false 

	self.hasUseRevertThisRound = false
end

function GameBoardLogic:tryDoOrderList(r,c,key1,key2,v1, rotation)
	if v1 == nil then v1 = 1; end;
	local ts = false
	for i,v in ipairs(self.theOrderList) do
		if v.key1 == key1 and v.key2 == key2 then
			if v.f1 < v.v1 and v.f1 + v1 >= v.v1 and key1 == GameItemOrderType.kAnimal then
				if self.dropBuffLogic and self.dropBuffLogic.dropBuffEnable then
					self.newCompletedAnimalOrders = self.newCompletedAnimalOrders or {}
					table.insert(self.newCompletedAnimalOrders, key2)
				end
			end
			v.f1 = v.f1 + v1;
			ts = true
			-- print("@@@@@tryDoOrderList", v.key1,v.key2,v.f1, v.v1)
			if self.PlayUIDelegate then 				-----向UI注册函数发起调用
				local pos_t = self:getGameItemPosInView(r,c);
				local num = v.v1 - v.f1;
				if num < 0 then num = 0; end;
				self.PlayUIDelegate:setTargetNumber(v.key1, v.key2, num, pos_t, rotation);
			end
		end
	end
	return ts;
end

function GameBoardLogic:addReplayStep( item )
	-- body
	if item and self.setWriteReplayEnable then
		table.insert(self.replaySteps, item)
		if isLocalDevelopMode then 
			self:WriteReplay("test.rep")
		end
	end
	
end

function GameBoardLogic:ReadReplay(fileName, base)
	if not base then
		base = CCFileUtils:sharedFileUtils():fullPathForFilename("resource")
	end
	local path = base .. "/" .. fileName
	local hFile, err = io.open(path, "r")
	local text
	if hFile and not err then
		text = hFile:read("*a")
		io.close(hFile)
	end

	--local text = Localhost:readFromStorage(path)
	if text then
		return table.deserialize(text)
	end
	return nil
end

--关闭replay
function GameBoardLogic:setWriteReplayOff(  )
	-- body
	self.setWriteReplayEnable = false
end

function GameBoardLogic:WriteReplay(fileName, base)
	if not base then
		base = CCFileUtils:sharedFileUtils():fullPathForFilename("resource")
	end

	local path = HeResPathUtils:getUserDataPath() .. "/" .. fileName
	local text
	if not self.replay then 
		local hFile, err = io.open(path, "r")
		if hFile and not err then
			text = hFile:read("*a")
			io.close(hFile)
		end
		self.allReplay = table.deserialize(text) or {}

		local replay = {}
		replay.level = self.level
		replay.randomSeed = self.randomSeed
		replay.replaySteps = self.replaySteps
		replay.selectedItemsData = {}

		for k, v in pairs(self.selectedItemsData) do 
			local v_r = {}
			v_r.id = v.id
			v_r.destXInWorldSpace = v.destXInWorldSpace
			v_r.destYInWorldSpace = v.destYInWorldSpace
			table.insert(replay.selectedItemsData, v_r)
		end
		table.insert(self.allReplay, replay)
		self.replay = replay
	end
	text = table.serialize(self.allReplay)
	Localhost:safeWriteStringToFile(text, path)
end

function GameBoardLogic:ReplayStart()
	self.replaying = true
	self.replayStep = 1
end

function GameBoardLogic:Replay()
	if self.replayStep <= #self.replaySteps then
		if not self.replaySteps[self.replayStep].prop then
			self:startTrySwapedItem(self.replaySteps[self.replayStep].x1, self.replaySteps[self.replayStep].y1,
				self.replaySteps[self.replayStep].x2, self.replaySteps[self.replayStep].y2)
			self.replayStep = self.replayStep + 1
		else
			self:useProps(self.replaySteps[self.replayStep].prop, self.replaySteps[self.replayStep].x1,
				self.replaySteps[self.replayStep].y1, self.replaySteps[self.replayStep].x2,
				self.replaySteps[self.replayStep].y2)
			self.replayStep = self.replayStep + 1
		end
	else
		--self:checkCanMoveItem(0)
		self.replaying = false
	end
end

function GameBoardLogic:getGameItemPosInView_ForPreProp(r, c)
	self.posAdd = self.posAdd or ccp(0, 0)
	local tempX = (c - 0.5) * GamePlayConfig_Tile_Width
	local tempY = (GamePlayConfig_Max_Item_Y - r - 0.5 ) * GamePlayConfig_Tile_Height
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	return ccp(tempX * GamePlayConfig_Tile_ScaleX + self.posAdd.x - visibleOrigin.x,
		tempY * GamePlayConfig_Tile_ScaleY + self.posAdd.y - visibleOrigin.y)
end

function GameBoardLogic:getGameItemPosInView(r, c)
	self.posAdd = self.posAdd or ccp(0, 0)
	local tempX = (c - 0.5) * GamePlayConfig_Tile_Width
	local tempY = (GamePlayConfig_Max_Item_Y - r - 0.5 ) * GamePlayConfig_Tile_Height
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	return self.boardView:convertToWorldSpace(ccp(tempX, tempY))
end

-- 确定两个方块是否相邻
function GameBoardLogic:tileNextToEachOther(r1, c1, r2, c2)
	if not r1 or r1 <= 0 or r1 > #self.gameItemMap or not r2 or r2 <= 0 or r2 > #self.gameItemMap or
		not c1 or c1 <= 0 or c1 > #self.gameItemMap[r1] or not c2 or c2 <= 0 or c2 > #self.gameItemMap[r2] then
		return false
	end
	return (r1 == r2 and math.abs(c1 - c2) == 1) or (c1 == c2 and math.abs(r1 - r2) == 1)
end

function GameBoardLogic:preGameProp(propID, animCallback)
	if propID == GamePropsType.kWrap_b then
		local y1, x1, t1, y2, x2, t2
		local validTargetItemList = {}
		local validCrystalList = {}
		for r = 1, #self.gameItemMap do
			for c = 1, #self.gameItemMap[r] do
				local item = self.gameItemMap[r][c]
				if item.isUsed 
					and item.ItemSpecialType == 0
					and item:isAvailable()
					then
					if item.ItemType == GameItemType.kAnimal then 
						table.insert(validTargetItemList, {r = r, c = c})
					elseif item.ItemType == GameItemType.kCrystal then
						table.insert(validCrystalList, {r = r, c = c})
					end
					
				end
			end
		end	

		if #validTargetItemList + #validCrystalList >= 1 then
			local idx1, pos1, idx2, pos2
			if #validTargetItemList >= 2 then
				idx1 =self.randFactory:rand(1,#validTargetItemList)
				pos1 = validTargetItemList[idx1]
				table.remove(validTargetItemList, idx1)
				idx2 = self.randFactory:rand(1,#validTargetItemList)
				pos2 = validTargetItemList[idx2]
			elseif #validTargetItemList == 1 then 
				pos1 = validTargetItemList[1]
				if #validCrystalList == 0 then 
					pos2 = pos1
				else
					idx2 =  self.randFactory:rand(1,#validCrystalList)
					pos2 = validCrystalList[idx2]
				end
				
			else
				idx1 =  self.randFactory:rand(1,#validCrystalList)
				pos1 = validCrystalList[idx1]
				table.remove(validCrystalList, idx1)
				if #validCrystalList == 0 then 
					pos2 = pos1
				else
					idx2 =  self.randFactory:rand(1,#validCrystalList)
					pos2 = validCrystalList[idx2]
				end
				
			end

			x1 = pos1.c
			y1 = pos1.r
			x2 = pos2.c
			y2 = pos2.r

			t1 = self.randFactory:rand(1,2) + AnimalTypeConfig.kLine - 1
			t2 = AnimalTypeConfig.kWrap

			local function finishColorBrush_b()
				self.gameItemMap[y1][x1].ItemType = GameItemType.kAnimal
				self.gameItemMap[y2][x2].ItemType = GameItemType.kAnimal
				self.gameItemMap[y1][x1]:changeItemType(self.gameItemMap[y1][x1].ItemColorType, t1)
				self.gameItemMap[y2][x2]:changeItemType(self.gameItemMap[y2][x2].ItemColorType, t2)
				self.gameItemMap[y1][x1].isNeedUpdate = true
				self.gameItemMap[y2][x2].isNeedUpdate = true
				if self.boardView then
					self.boardView:updateItemViewByLogic()			----界面展示刷新
					self.boardView:updateItemViewSelf()				----界面自我刷新
				end
			end
				
			
			if self.PlayUIDelegate then
				animCallback(self:getGameItemPosInView_ForPreProp(y1, x1), self:getGameItemPosInView_ForPreProp(y2, x2), finishColorBrush_b)
			else
				finishColorBrush_b()
			end
		end
	elseif propID == GamePropsType.kRefresh_b then
		-- 纯界面道具，无动作
	elseif propID == GamePropsType.kAdd3_b then
		self.gameMode:getAddSteps(3)
	end
end

function GameBoardLogic:isPosValid(r, c)
	return r > 0 and r <= #self.gameItemMap and c > 0 and c <= #self.gameItemMap[r] 
end

function GameBoardLogic:getGameItemAt(r, c)
	if self:isPosValid(r, c) then
		return self.gameItemMap[r][c]
	end
	return nil
end

function GameBoardLogic:getIngredientsOnScreen( ... )
	-- body
	local result = 0
	for r = 1, #self.gameItemMap do 
		for c = 1, #self.gameItemMap[r] do 
			if self.gameItemMap[r][c].ItemType == GameItemType.kIngredient then 
				result = result + 1
			end
		end
	end
	return result - self.toBeCollected
end

function GameBoardLogic:getItemAmountByItemType( itemType )
	-- body
	local result = 0
	for r = 1, #self.gameItemMap do 
		for c = 1, #self.gameItemMap[r] do 
			if self.gameItemMap[r][c].ItemType == itemType then 
				result = result + 1
			end
		end
	end
	return result
end

function GameBoardLogic:getFurballAmout( furballType )
	-- body
	local result = 0
	for r = 1, #self.gameItemMap do 
		for c = 1, #self.gameItemMap[r] do 
			if self.gameItemMap[r][c].furballType == furballType then 
				result = result + 1
			end
		end
	end
	return result
end

function GameBoardLogic:testEmpty()
	local format = "item status map\n"
	for r=1,#self.gameItemMap do
		for c=1,#self.gameItemMap[r] do
			local itemView = self.boardView.baseMap[r][c]
			-- local oldBoard = itemView.oldBoard
			-- local iceLevel = oldBoard and oldBoard.iceLevel or 0
			local spriteNum = itemView.itemSprite and table.size(itemView.itemSprite) or 0
			local boardUsed = self.boardmap[r][c].isUsed and 1 or 0

			local board = self.boardmap[r][c]

			format = format .. string.format("%d-%02d-%d", boardUsed, spriteNum, itemView.itemShowType) .. " "
		end

		format = format .. " | "

	-- 	-- for c=1,#self.gameItemMap[r] do
	-- 	-- 	local item = self.gameItemMap[r][c]
	-- 	-- 	local itemView = self.boardView.baseMap[r][c]
	-- 	-- 	format = format .. item.ItemColorType .. " "
	-- 	-- end
		format = format .. "\n"
	end
	-- format = format .. "\nboard status map\n"
	-- for r = 1, #self.boardmap do
	-- 	for c = 1, #self.boardmap[r] do
	-- 		local board = self.boardmap[r][c]
	-- 		local flag = 0 
	-- 		if board.isMoveTile then flag = 1 end
	-- 		format = format .. string.format("%02d", flag) .. " "
	-- 	end
	-- 	format = format .. " | "
	-- 	format = format .. "\n"
	-- end
	print(format)
end

function GameBoardLogic:testItem()
	local r = 3
	local c = 2
	local item = self.gameItemMap[r][c]
	local itemView = self.boardView.baseMap[r][c]
	local dClipPos = nil
	if itemView.itemSprite[ItemSpriteType.kDisappearClipping] then
		dClipPos = itemView.itemSprite[ItemSpriteType.kDisappearClipping]:getPosition().y
		dClipPos = string.format("%0.1f", dClipPos)
	end

	print("item itemShow clippingUp " 
		.. tostring(itemView:getItemSprite(ItemSpriteType.kItem) ~= nil) .. " "
		.. tostring(itemView:getItemSprite(ItemSpriteType.kItemShow) ~= nil) .. " "
		.. tostring(itemView:getItemSprite(ItemSpriteType.kDisappearClipping) ~= nil) .. " "
		.. tostring(dClipPos)
		)
end

function GameBoardLogic:quitLevel()
	local targetCount = 0
	local opLog = nil
	if self.theGamePlayType == GamePlayType.kRabbitWeekly then
		targetCount = self.rabbitCount:getValue()
	end
	if self.PlayUIDelegate then
		self.PlayUIDelegate:sendQuitLevelMessage(self.level, self.totalScore, self.gameMode:getScoreStarLevel(), math.floor(self.timeTotalUsed), self.coinDestroyNum, targetCount, opLog)
	end
end

function GameBoardLogic:getForbiddenOctopus()
	local result = {}
	for r = 1, #self.gameItemMap do
		for c = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item.ItemType == GameItemType.kPoisonBottle and item.forbiddenLevel > 0 then
				table.insert(result, item)
			end
		end
	end
	return result
end

function GameBoardLogic:hasOctopus()
	for r = 1, #self.gameItemMap do
		for c = 1, #self.gameItemMap[r] do 
			local item = self.gameItemMap[r][c]
			if item.ItemType == GameItemType.kPoisonBottle then
				return true
			end
		end
	end
	return false
end

function GameBoardLogic:areaDevidedByRope(x, y, xEnd, yEnd)
	local boardmap = self.boardmap
	local firstRow, lastRow = y, yEnd
	local firstCol, lastCol = x, xEnd

	local isDevided = false
	for r = y, yEnd do 
		if boardmap[r] then 
			for c = x, xEnd do
				local item = boardmap[r][c]
					
				if item then
					if r == firstRow then
						if c == firstCol then -- 左上角
							if item:hasBottomRope() or item:hasRightRope() then
								isDevided = true
							end
						elseif c == lastCol then -- 右上角
							if item:hasBottomRope() or item:hasLeftRope() then
								isDevided = true
							end
						else
							if item:hasLeftRope() or item:hasRightRope() or item:hasBottomRope() then
								isDevided = true
							end
						end
					elseif r == lastRow then
						if c == firstCol then -- 左下角
							if item:hasTopRope() or item:hasRightRope() then
								isDevided = true
							end
						elseif c == lastCol then -- 右下角
							if item:hasTopRope() or item:hasLeftRope() then
								isDevided = true
							end
						else
							if item:hasTopRope() or item:hasLeftRope() or item:hasRightRope() then
								isDevided = true
							end
						end
					else
						if c == firstCol then -- 第一列
							if item:hasTopRope() or item:hasRightRope() or item:hasBottomRope() then
								isDevided = true
							end
						elseif c == lastCol then -- 最后一列
							if item:hasTopRope() or item:hasLeftRope() or item:hasBottomRope() then
								isDevided = true
							end
						else
							if item:hasRope() then
								isDevided = true
							end
						end
					end

					if isDevided then
						return true
					end
				end
			end
		end
	end
	return false
end

function GameBoardLogic:getPositionForRandomBird()
	local list = {}
	local function isNormal(item)
        if item.ItemType == GameItemType.kAnimal
        and item.ItemSpecialType == 0 -- not special
        and item:isAvailable()
        and not item:hasLock() 
        and not item:hasFurball()
        then
            return true
        end
        return false
    end
	for r=1, #self.gameItemMap do
		for c = 1, #self.gameItemMap[r] do
			local item = self.gameItemMap[r][c]
			if item and isNormal(item) then
				table.insert(list, {r = r, c = c})
			end
		end
	end


	local selector = self.randFactory:rand(1, #list)
	local selected = list[selector]

	print(table.tostring(selected))
	return selected
end

function GameBoardLogic:getHalloweenBoss()
	return self.halloweenBoss
end

function GameBoardLogic:dragonBoatBossDie(diePosition, bells)
	local boss = self.halloweenBoss
	local boss = self.halloweenBoss
	if not boss then return end
	local count = boss.dropBellOnDie
	self.digJewelCount:setValue(self.digJewelCount:getValue() + count)
	self.maydayBossCount = self.maydayBossCount + 1
	if self.gameMode.onBossDie then
		self.gameMode:onBossDie()
	end
	if self.PlayUIDelegate then
		local levelTargetPanel = self.PlayUIDelegate.levelTargetPanel
		if levelTargetPanel and levelTargetPanel.c1 then
			local c1Icon = levelTargetPanel.c1.icon
			if c1Icon and not c1Icon.isDisposed then
				local c1IconPos = c1Icon:getParent():convertToWorldSpace(c1Icon:getPosition())
				local scene = Director:sharedDirector():getRunningScene()
				local c1IconPosInScene = scene:convertToNodeSpace(c1IconPos)
				for _, bell in pairs(bells) do
					if bell and not bell.isDisposed then
						local bellPosInScene = scene:convertToNodeSpace(bell:getParent():convertToWorldSpace(bell:getPosition()))
						bell:stopAllActions()
						bell:removeFromParentAndCleanup(false)

						local bellSeq = CCArray:create()
						bellSeq:addObject(CCMoveTo:create(0.8, ccp(c1IconPosInScene.x, c1IconPosInScene.y)))
						local function onAnimComplete()
							if bell then bell:removeFromParentAndCleanup(true) end
						end
						bellSeq:addObject(CCCallFunc:create(onAnimComplete))
						bell:runAction(CCSequence:create(bellSeq))
						bell:setPosition(bellPosInScene)
						scene:addChild(bell)
					end
				end
			end
		end
		local position = diePosition or ccp(0, 0)
		self.PlayUIDelegate:setTargetNumber(0, 1, self.digJewelCount:getValue(), position, nil, false)
		self.PlayUIDelegate:setTargetNumber(0, 2, self.maydayBossCount, position)
	end

	self.halloweenBoss = nil
	if bells and #bells > 0 then
		for _, bell in pairs(bells) do

		end
	end
	self.halloweenBoss = nil
end

function GameBoardLogic:halloweenBossDie(diePosition)
	local boss = self.halloweenBoss
	if not boss then return end
	local count = boss.dropBellOnDie
	self.digJewelCount:setValue(self.digJewelCount:getValue() + count)
	self.maydayBossCount = self.maydayBossCount + 1
	if self.gameMode.onBossDie then
		self.gameMode:onBossDie()
	end
	if self.PlayUIDelegate then
		local position = diePosition or ccp(0, 0)
		for k = 1, count do 
			self.PlayUIDelegate:setTargetNumber(0, 1, self.digJewelCount:getValue(), position)
		end
		self.PlayUIDelegate:setTargetNumber(0, 2, self.maydayBossCount, position)
	end
	self.halloweenBoss = nil
end

function GameBoardLogic:initHalloweenBoss(bossConfig)
	self.halloweenBoss = 
	{
		hit = 0, 
		totalBlood = bossConfig.blood, 
		dropBellOnHit = bossConfig.dropBellOnHit,
		dropBellOnDie = bossConfig.dropBellOnDie, 
		dropAddMove = bossConfig.dropAddMove,
		move = 0, 
		maxMove = bossConfig.maxMove,
		normalHit = bossConfig.normalHit,
		specialHit = bossConfig.specialHit,
		genBellCount = bossConfig.genBellCount,
		genCloudCount = bossConfig.genCloudCount,
	}
end

local magicTileIdCounter = 0
local max_tile_hit       = 7
local function getMagicTileId()
    magicTileIdCounter = magicTileIdCounter + 1
    return magicTileIdCounter
end


function GameBoardLogic:updateAllMagicTiles(boardmap)
    local boardmap = boardmap or self.boardmap
    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local item = boardmap[r][c]
            if item then
                if item.isMagicTileAnchor then
                    -- 如果没有初始化
                    if item.magicTileId == nil then
                        local id = getMagicTileId()
                        item.magicTileId = id
                        item.remainingHit = max_tile_hit
                        for i = r, r + 1 do 
                            for j = c, c + 2 do
                            	if boardmap[i] then
	                                local otherItem = boardmap[i][j]
	                                if otherItem then
	                                    otherItem.magicTileId = id
	                                end
	                            end
                            end
                        end
                    else
                    	local id = item.magicTileId
                    	for i = r, r + 1 do 
                            for j = c, c + 2 do
                            	if boardmap[i] then
	                                local otherItem = boardmap[i][j]
	                                if otherItem then
	                                    otherItem.magicTileId = id
	                                end
	                            end
                            end
                        end
                    end
                end
            end
        end
    end
end

function GameBoardLogic:useFirecracker()
	self.fireworkEnergy = 0
	self.isFullFirework = false
	self:useProps(GamePropsType.kSpringFirework)
end

function GameBoardLogic:chargeFirework(count, r, c)
	if not self.fireworkEnergy then
		self.fireworkEnergy = 0
	end
	self.fireworkEnergy = self.fireworkEnergy + count
	if self.PlayUIDelegate then
		print("@@@@@@@@@@@@@@@fireworkEnergy updated: ", self.fireworkEnergy)
		self.PlayUIDelegate:setFireworkEnergy(self.fireworkEnergy)
		self.PlayUIDelegate:playSpringCollectEffect(self:getGameItemPosInView(r, c))
	end
	if self.fireworkEnergy >= self.PlayUIDelegate:getFireworkEnergy() then
		self.isFullFirework = true
	end
end

function GameBoardLogic:onProduceQuestionMark(r, c)
    self.firstProduceQuestionMark = true
end

-- for new dc use
function GameBoardLogic:getStageIndex()
	return self.gameMode:getStageIndex()
end

-- for new dc use
function GameBoardLogic:getStageMoveLimit()
	return self.gameMode:getStageMoveLimit()
end

function GameBoardLogic:hasChainInNeighbors(r1, c1, r2, c2)
	if not self:isPosValid(r1, c1) or not self:isPosValid(r2, c2) then
		return false
	end

	local deltaR = r2 - r1
	local deltaC = c2 - c1
	local borad1 = self.boardmap[r1][c1]
	local borad2 = self.boardmap[r2][c2]
	if deltaC == 1 then
		return borad1:hasChainInDirection(ChainDirConfig.kRight) or borad2:hasChainInDirection(ChainDirConfig.kLeft)
	elseif deltaC == -1 then
		return borad1:hasChainInDirection(ChainDirConfig.kLeft) or borad2:hasChainInDirection(ChainDirConfig.kRight)
	elseif deltaR == 1 then
		return borad1:hasChainInDirection(ChainDirConfig.kDown) or borad2:hasChainInDirection(ChainDirConfig.kUp)
	elseif deltaR == -1 then
		return borad1:hasChainInDirection(ChainDirConfig.kUp) or borad2:hasChainInDirection(ChainDirConfig.kDown)
	end
	return false
end

function GameBoardLogic:isTheSameMatchData(r1, c1, r2, c2)
	if not self.swapHelpMap or not self:isPosValid(r1, c1) or not self:isPosValid(r2, c2) then
		return false
	end
	local matchId1 = math.abs(self.swapHelpMap[r1][c1])
	local matchId2 = math.abs(self.swapHelpMap[r2][c2])
	return matchId1 == matchId2
end

function GameBoardLogic:hasRopeInNeighbors(r1, c1, r2, c2)
	if not self:isPosValid(r1, c1) or not self:isPosValid(r2, c2) then
		return false
	end

	local deltaR = r2 - r1
	local deltaC = c2 - c1
	local borad1 = self.boardmap[r1][c1]
	local borad2 = self.boardmap[r2][c2]
	if deltaC == 1 then
		return borad1:hasRightRope() or borad2:hasLeftRope()
	elseif deltaC == -1 then
		return borad1:hasLeftRope() or borad2:hasRightRope()
	elseif deltaR == 1 then
		return borad1:hasBottomRope() or borad2:hasTopRope()
	elseif deltaR == -1 then
		return borad1:hasTopRope() or borad2:hasBottomRope()
	end
	return false
end