MagicLampCastingState = class(BaseStableState)

function MagicLampCastingState:create(context)
    local v = MagicLampCastingState.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function MagicLampCastingState:dispose()
    self.mainLogic = nil
    self.boardView = nil
    self.context = nil
end

function MagicLampCastingState:update(dt)
    
end

function MagicLampCastingState:onEnter()
    BaseStableState.onEnter(self)
    self.nextState = nil

    self:tryHandleCasting()
end

function MagicLampCastingState:tryHandleCasting()
    local mainLogic = self.mainLogic
    local gameItemMap = mainLogic.gameItemMap

    -- bonus time
    if mainLogic.isBonusTime then
        self:onActionComplete()
        return
    end

    -- get the lamps
    local lamps = {}
    for r = 1, #gameItemMap do
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item and item.ItemType == GameItemType.kMagicLamp and item:isAvailable() and item.lampLevel >= 5 then
                table.insert(lamps, item)
            end
        end
    end

    if #lamps == 0 then
        self:onActionComplete()
        return
    end

    local count = 0

    local function actionCallback()
        count = count + 1
        if count >= #lamps then
            self:onActionComplete(true)
        end
    end

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

    local availablePosAllColor = {}
    for k, v in pairs(mainLogic.mapColorList) do
        availablePosAllColor[v] = {}
    end
    -- 对应颜色插入对应的数组
    for r = 1, #gameItemMap do 
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item ~= nil and isNormal(item) then
                table.insert(availablePosAllColor[item.ItemColorType], {r = r, c = c})
            end
        end
    end

    for k, v in pairs(lamps) do
        local speicalItemPos = {}
        local genCount = 3
        local availablePos = availablePosAllColor[v.ItemColorType]
        if #availablePos < genCount then
            speicalItemPos = availablePos
        else
            for i = 1, genCount do
                local idx = self.mainLogic.randFactory:rand(1, #availablePos)
                table.insert(speicalItemPos, availablePos[idx])
                table.remove(availablePos, idx)
            end
        end

        local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Casting,
                        IntCoord:create(v.y, v.x),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
        action.completeCallback = actionCallback
        action.speicalItemPos = speicalItemPos
        self.mainLogic:addGameAction(action)
    end
end

function MagicLampCastingState:onExit()
    BaseStableState.onExit(self)
end

function MagicLampCastingState:checkTransition()
    return self.nextState
end

function MagicLampCastingState:onActionComplete(bomb)
    if bomb then
        self.context.needLoopCheck = true
        self.mainLogic:setNeedCheckFalling()
        self.nextState = self
    else
        self.nextState = self:getNextState()
    end
end

function MagicLampCastingState:getNextState( ... )
    -- body
    return nil
end

function MagicLampCastingState:getClassName( ... )
    -- body
    return "MagicLampCastingState"
end

MagicLampCastingStateInSwapFirst = class(MagicLampCastingState)
function MagicLampCastingStateInSwapFirst:create(context)
    local v = MagicLampCastingStateInSwapFirst.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v 
end
function MagicLampCastingStateInSwapFirst:getClassName()
    return "MagicLampCastingStateInSwapFirst"
end

function MagicLampCastingStateInSwapFirst:getNextState()
    return self.context.furballSplitStateInSwapFirst
end

MagicLampCastingStateInLoop = class(MagicLampCastingState)
function MagicLampCastingStateInLoop:create(context)
    local v = MagicLampCastingStateInLoop.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function MagicLampCastingStateInLoop:getClassName()
    return "MagicLampCastingStateInLoop"
end

function MagicLampCastingStateInLoop:getNextState()
    return self.context.honeyBottleStateInLoop
end
