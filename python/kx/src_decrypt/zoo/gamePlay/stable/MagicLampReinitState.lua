MagicLampReinitState = class(BaseStableState)

function MagicLampReinitState:create(context)
    local v = MagicLampReinitState.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function MagicLampReinitState:dispose()
    self.mainLogic = nil
    self.boardView = nil
    self.context = nil
end

function MagicLampReinitState:update(dt)
    
end

function MagicLampReinitState:onEnter()
    BaseStableState.onEnter(self)
    self.nextState = nil
    self:tryHandleReinit()
end

function MagicLampReinitState:tryHandleReinit()
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
            if item and item.ItemType == GameItemType.kMagicLamp and item:isAvailable() and item.lampLevel == 0 then
                table.insert(lamps, item)
            end
        end
    end

    if #lamps == 0 then
        self:onActionComplete()
        return
    end

    local banColors = {}
    for k, v in pairs(lamps) do
        if banColors[v] == nil then
            banColors[v] = 0
        end
        banColors[v] = banColors[v] + 1
    end
    local function isColorBanned(color)
        return banColors[v] ~= nil and banColors[color] >= 2
    end


    local count = 0
    local function actionCallback ()
        count = count + 1
        if count >= #lamps then
            self:onActionComplete()
        end
    end

    for k, item in pairs(lamps) do
        local currentColor = item.ItemColorType
        local possibleColors = GameMapInitialLogic:getPossibleColorsForItem(mainLogic, item.y, item.x)
        local newColor = GameMapInitialLogic:getColorForMagicLamp(mainLogic)
        
        local _i = 0
        while not table.exist(possibleColors, newColor) or isColorBanned(newColor) do
            newColor = GameMapInitialLogic:getColorForMagicLamp(mainLogic)
            _i = _i + 1
            if _i > 12 then
                newColor = currentColor
                break 
            end
        end

        local reinitAction = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Magic_Lamp_Reinit,
                        IntCoord:create(item.y, item.x),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
        reinitAction.completeCallback = actionCallback
        reinitAction.color = newColor
        self.mainLogic:addGameAction(reinitAction)

    end
end

function MagicLampReinitState:getClassName()
    return "MagicLampReinitState"
end

function MagicLampReinitState:checkTransition()
    return self.nextState
end

function MagicLampReinitState:onActionComplete()
    self.nextState = self:getNextState()
    self.context:onEnter()
end

function MagicLampReinitState:getNextState()
    return self.context.needRefreshState
end

