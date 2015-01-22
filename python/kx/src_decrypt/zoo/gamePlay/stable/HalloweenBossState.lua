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
    BaseStableState.onEnter(self)

    if not self.mainLogic.gameMode:is(HalloweenMode) then
        self.bossHandled = true
        self:handleComplete()
        return
    end

    local function dieCallback()
        self.bossHandled = true
        self:handleComplete()
    end

    local boss = self.mainLogic:getHalloweenBoss()
    if boss then
        if boss.hit >= boss.totalBlood then
            local destPositions = getValidePositions(self.mainLogic, boss.dropAddMove)
            local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Halloween_Boss_Die,
                    IntCoord:create(r,c),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
            action.destPositions = destPositions
            action.completeCallback = dieCallback
            self.mainLogic:addGameAction(action)
        elseif boss.move >= boss.maxMove - 1 then

            local changeCount = boss.genBellCount + boss.genCloudCount

            local destPositions = getValidePositions(self.mainLogic, changeCount)


            local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Halloween_Boss_Casting,
                    IntCoord:create(1,1),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
            action.destPositions = destPositions
            action.completeCallback = dieCallback
            self.mainLogic:addGameAction(action)


            boss.move = 0

        else
            if self.mainLogic.isInStep then
                boss.move = boss.move + 1
            end
            dieCallback()
        end
    else
        dieCallback()
    end
end

function HalloweenBossState:handleComplete()
    if self.bossHandled then
        self.bossHandled = false
        self.nextState = self:getNextState()
        self.context:onEnter()
    end
end

function HalloweenBossState:getNextState()
    return nil
end

function HalloweenBossState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
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
    return v
end

function HalloweenBossStateInLoop:getClassName()
    return "HalloweenBossStateInLoop"
end

function HalloweenBossStateInLoop:getNextState()
    return self.context.digScrollGroundStateInLoop
end

HalloweenBossStateInBonus = class(HalloweenBossState)
function HalloweenBossStateInBonus:create( context )
    -- body
    local v = HalloweenBossStateInBonus.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function HalloweenBossStateInBonus:getClassName()
    return "HalloweenBossStateInBonus"
end

function HalloweenBossStateInBonus:getNextState()
    return self.context.gameOverState
end
