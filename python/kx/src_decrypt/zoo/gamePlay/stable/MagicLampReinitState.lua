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
    self.hasItemToHandle = false
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
    local banColors = {}
    for r = 1, #gameItemMap do
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item and item.ItemType == GameItemType.kMagicLamp then
                if item.lampLevel == 0 and item:isAvailable() then -- 只有available的才能初始化
                    table.insert(lamps, item)
                end

                -- 所有的神灯都参与颜色统计
                local color = item.ItemColorType
                if banColors[color] == nil then banColors[color] = 0 end
                banColors[color] = banColors[color] + 1
            end
        end
    end

    -- 挖地模式下，计算颜色时要考虑到剩下的配置里面的神灯颜色，否则会
    -- 造成滚屏后可能出现3个同色神灯
    if mainLogic.theGamePlayType == GamePlayType.kDigMove 
        or mainLogic.theGamePlayType == GamePlayType.kDigTime 
        or mainLogic.theGamePlayType == GamePlayType.kDigMoveEndless
        or mainLogic.theGamePlayType == GamePlayType.kMaydayEndless
        or mainLogic.theGamePlayType == GamePlayType.kHalloween 
        then
        local passedRow = mainLogic.passedRow
        local totalConfigRow = #mainLogic.digItemMap
        for r = passedRow + 1, totalConfigRow do 
            for c = 1, #mainLogic.digItemMap[r] do
                local item = mainLogic.digItemMap[r][c]
                if item and item.ItemType == GameItemType.kMagicLamp then
                    if item.lampLevel == 0 and item:isAvailable() then
                        table.insert(lamps, item)
                    end
                    local color = item.ItemColorType
                    if banColors[color] == nil then banColors[color] = 0 end
                    banColors[color] = banColors[color] + 1
                end
            end
        end
    end


    if #lamps == 0 then
        self:onActionComplete()
        return
    end

    local function isColorBanned(color)
        return banColors[color] ~= nil and banColors[color] >= 2
    end


    local count = 0
    local function actionCallback ()
        count = count + 1
        if count >= #lamps then
            self.hasItemToHandle = true
            self:onActionComplete()
        end
    end

    for k, item in pairs(lamps) do
        local possibleColors = GameMapInitialLogic:getPossibleColorsForItem(mainLogic, item.y, item.x)

        local targetColors = {}
        for i, color in ipairs(mainLogic.mapColorList) do
            if table.exist(possibleColors, color) and not isColorBanned(color) then
                table.insert(targetColors, color)
            end
        end

        local newColor = nil
        if #targetColors == 0 then
            self.context.needLoopCheck = true -- 循环多做一次
            self.needCheckMatch = true
            for k, v in pairs(mainLogic.mapColorList) do
                if not isColorBanned(v) then
                    newColor = v
                    break
                end
            end
        else
            newColor = targetColors[mainLogic.randFactory:rand(1, #targetColors)]
        end

        if banColors[newColor] == nil then banColors[newColor] = 0 end
        banColors[newColor] = banColors[newColor] + 1
        item.ItemColorType = newColor

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

    if self.needCheckMatch then
        local result = ItemHalfStableCheckLogic:checkAllMapWithNoMove(self.mainLogic)
        self.nextState = self:getNextState()
        if result then
            self.mainLogic:setNeedCheckFalling()
        else
            self.context:onEnter()
        end
    else

        self.nextState = self:getNextState()
        if self.hasItemToHandle then
            self.context:onEnter()
        end
    end
end

function MagicLampReinitState:getNextState()
    return self.context.checkNeedLoopState
end

function MagicLampReinitState:onExit()
    BaseStableState.onExit(self)
    self.hasItemToHandle = nil
    self.nextState = nil
    self.needCheckMatch = nil
end

