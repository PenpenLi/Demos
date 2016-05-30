HalloweenBossState = class(BaseStableState)

function HalloweenBossState:dispose()
    self.mainLogic = nil
    self.boardView = nil
    self.context = nil
end

function HalloweenBossState:create(context)
    local v = HalloweenBossState.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

local function getValidePositions(mainLogic, count)
    local destPositions = {}

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

    local availablePos = {}
    for r = 6, #mainLogic.gameItemMap do 
        for c = 1, #mainLogic.gameItemMap[r] do
            if isNormal(mainLogic.gameItemMap[r][c]) then
                table.insert(availablePos, {r = r, c = c})
            end
        end
    end

    if #availablePos < count then
        destPositions = availablePos
    else
        for i = 1, count do
            local idx = mainLogic.randFactory:rand(1, #availablePos)
            table.insert(destPositions, availablePos[idx])
            table.remove(availablePos, idx)
        end
    end
    return destPositions
end

function HalloweenBossState:onEnter()

    self.hasItemToHandle = false

    BaseStableState.onEnter(self)

    if not self.mainLogic.gameMode:is(HalloweenMode) then
        self:handleComplete()
        return
    end

    local function dieCallback()
        -- GameGuide:sharedInstance():onHalloweenBossDie()
        self.mainLogic.firstBossDie = true
        self.hasItemToHandle = true
        self:handleComplete()
    end

    local boss = self.mainLogic:getHalloweenBoss()
    if boss then
        if boss.hit >= boss.totalBlood then
            local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Halloween_Boss_Die,
                    IntCoord:create(r,c),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
            action.completeCallback = dieCallback
            self.mainLogic:addGameAction(action)
        else
            self:handleComplete()
        end
    else
        self:handleComplete()
    end
end


function HalloweenBossState:handleComplete()
    self.nextState = self:getNextState()
    if self.hasItemToHandle then
        self.context.needLoopCheck = true
        self.mainLogic:setNeedCheckFalling()
    end
end

function HalloweenBossState:getNextState()
    return nil
end

function HalloweenBossState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
    self.bossHandled = false
    self.hasItemToHandle = false
end

function HalloweenBossState:checkTransition()
    return self.nextState
end

function HalloweenBossState:getClassName()
    return "HalloweenBossState"
end

HalloweenBossStateInLoop = class(HalloweenBossState)
function HalloweenBossStateInLoop:create(context)
    local v = HalloweenBossStateInLoop.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    v.inBonus = false
    return v
end

function HalloweenBossStateInLoop:getClassName()
    return "HalloweenBossStateInLoop"
end

function HalloweenBossStateInLoop:getNextState()
    --return self.context.cleanDigGroundStateInLoop
    return self.context.wukongReinitState
end

HalloweenBossStateInBonus = class(HalloweenBossState)
function HalloweenBossStateInBonus:create( context )
    -- body
    local v = HalloweenBossStateInBonus.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    v.inBonus = true
    return v
end

function HalloweenBossStateInBonus:getClassName()
    return "HalloweenBossStateInBonus"
end

function HalloweenBossStateInBonus:getNextState()
    return self.context.elephantBossState
end

--boss释放技能
HalloweenBossCastingState = class(BaseStableState)
function HalloweenBossCastingState:create(context)
    local v = HalloweenBossCastingState.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

local function selectInTable(mainLogic, tab, count)
    local tableCopy = {}
    for k, v in pairs(tab) do
        table.insert(tableCopy, v)
    end
    if #tableCopy <= count then
        return tableCopy
    else
        local ret = {}
        for i = 1, count do
            local index = mainLogic.randFactory:rand(1, #tableCopy)
            table.insert(ret, tableCopy[index])
            table.remove(tableCopy, index)
        end
        return ret
    end

end

function HalloweenBossCastingState:onEnter()
    self.hasItemToHandle = false
    BaseStableState.onEnter(self)

    if not self.mainLogic.gameMode:is(HalloweenMode) then
        self:handleComplete()
        return
    end

    local function completeCallback()
        self.hasItemToHandle = true
        self:handleComplete()
    end

    local castProbability = 15
    -- if __WIN32 then
    --     castProbability = 100
    -- end

    local boss = self.mainLogic:getHalloweenBoss()

    if boss then
        local lastRoundHitCount = boss.hit - boss.lastHit
        local shouldCast = false


        -- 1号boss不能放大招
        -- 连续10步之内不能放大招

        print('lastRoundHitCount', lastRoundHitCount, 'boss.hasCast', boss.hasCast, 'self.mainLogic.realCostMove - boss.lastHitMove', self.mainLogic.realCostMove - boss.lastHitMove)
        if boss.maxMove > 0 and (not boss.hasCast or (boss.hasCast and self.mainLogic.realCostMove - boss.lastHitMove >= 10)) then

            if lastRoundHitCount > 0 then
                for i = 1, lastRoundHitCount do
                    local number = self.mainLogic.randFactory:rand(1, 100)
                    print('number', number)
                    if number <= castProbability then -- 
                        shouldCast = true
                        break
                    end
                end
            end
        end

        boss.lastHit = boss.hit

        if shouldCast then
            boss.hasCast = true
            boss.lastHitMove = self.mainLogic.realCostMove

            local genGoldZongzi = ((boss.hit / boss.totalBlood) <= 0.5) and not boss.hasGenGoldZongzi -- 如果boss血量＞50%，必出1个特殊宝石
            local genJewelCount = self.mainLogic.randFactory:rand(4, 5)
            local genSpecialCount = math.min(self.mainLogic.randFactory:rand(1, 2), 6 - genJewelCount) -- 保证genJewelCount + genSpecialCount <= 6

            local jewelPos = {}
            local specialPos = {}
            local jewelSelectionPool = {}
            local specialSelectionPool = {}
            local itemMap = self.mainLogic.gameItemMap

            for r = 6, 9 do
                for c = 1, #itemMap[r] do
                    local item = itemMap[r][c]
                    if item and item.ItemType == GameItemType.kAnimal and item.ItemSpecialType == 0 then
                        table.insert(specialSelectionPool, {r = r, c = c})
                    end
                end
            end
            local function exists(table, r, c)
                local ret = false
                for k, v in pairs(table) do
                    if v.r == r and v.c == c then
                        ret = true
                    end
                end
                return ret
            end
            for r = 1, #itemMap do
                for c = 1, #itemMap[r] do
                    local item = itemMap[r][c]
                    if item and item.ItemType == GameItemType.kDigGround then
                        table.insert(jewelSelectionPool, {r = r, c = c})
                    elseif item and item.ItemType == GameItemType.kAnimal and item.ItemSpecialType == 0 then
                        if #specialSelectionPool < genSpecialCount then
                            if not exists(specialSelectionPool, r, c) then
                                table.insert(specialSelectionPool, {r = r, c = c})
                            end
                        end
                    end
                end
            end 

            local goldZongziPos
            if genGoldZongzi then
                boss.hasGenGoldZongzi = true

                local firstCloudRow = 0
                local firstRowClouds = {}
                for r = 1, #itemMap do
                    for c = 1, #itemMap[r] do
                        local item = itemMap[r][c]
                        if item and item.ItemType == GameItemType.kDigGround or item.ItemType == GameItemType.kDigJewel then
                            if firstCloudRow == 0 then
                                firstCloudRow = r
                            end
                            if r == firstCloudRow then
                                table.insert(firstRowClouds, {r = r, c = c})
                            end
                        end
                    end
                end 

                goldZongziPos = selectInTable(self.mainLogic, firstRowClouds, 1)
                if goldZongziPos[1] then
                    goldZongziPos = goldZongziPos[1]
                else
                    goldZongziPos = nil
                end
            end


            -- 金粽子占用的格子不能再生成普通宝石
            if goldZongziPos then
                for k, v in pairs(jewelSelectionPool) do
                    if v.r == goldZongziPos.r and v.c == goldZongziPos.c then
                        table.remove(jewelSelectionPool, k)
                    end
                end
            end

            local jewelPos = selectInTable(self.mainLogic, jewelSelectionPool, genJewelCount)
            local specialPos = selectInTable(self.mainLogic, specialSelectionPool, genSpecialCount)
            local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Halloween_Boss_Casting,
                    IntCoord:create(1,1),
                    nil,
                    GamePlayConfig_MaxAction_time
                )


            action.jewelPositions = jewelPos
            action.specialPositions = specialPos
            action.goldZongziPosition = goldZongziPos
            action.completeCallback = completeCallback

            print('jewelPositions', table.tostring(jewelPos))
            print('specialPositions', table.tostring(specialPos))
            print('goldZongziPosition', table.tostring(goldZongziPos))

            if __WIN32 then
                self.mainLogic:addGameAction(action)
            else
                self.mainLogic:addGameAction(action)
            end

        else
            self:handleComplete()
        end
    else
        self:handleComplete()
    end
end

function HalloweenBossCastingState:handleComplete()
    self.nextState = self:getNextState()
    if self.hasItemToHandle then
        self.context:onEnter()
    end
end

function HalloweenBossCastingState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
    self.hasItemToHandle = false
end

function HalloweenBossCastingState:getClassName()
    return "HalloweenBossCastingState"
end

function HalloweenBossCastingState:getNextState()
    return self.context.productSnailState
end

function HalloweenBossCastingState:checkTransition()
    return self.nextState
end