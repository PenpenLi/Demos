MagicTileResetState = class(BaseStableState)

function MagicTileResetState:create( context )
    -- body
    local v = MagicTileResetState.new()
    v.context = context
    v.mainLogic = context.mainLogic  --gameboardlogic
    v.boardView = v.mainLogic.boardView
    return v
end

function MagicTileResetState:onEnter()
    BaseStableState.onEnter(self)
    self.nextState = nil
    self:handleMagicTile()

end

function MagicTileResetState:handleMagicTile()
    if not self.mainLogic.gameMode:is(HalloweenMode) then 
        self.magicTileHandled = true
        self:handleComplete()
        return 
    end

    local function tileChangeCallback()
        self.magicTileHandled = true
        self.waitingCallback = false
        self:handleComplete()
    end

    local boardmap = self.mainLogic.boardmap
    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local item = boardmap[r][c]
            if item then
                if item.isMagicTileAnchor then
                    -- 如果没有初始化
                    if item.magicTileId ~= nil and item.isHitThisRound == true then
                        -- 如果已经初始化就更新剩余
                        item.remainingHit = item.remainingHit - 1
                        item.isHitThisRound = false
                    end
                end
            end
        end
    end

    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local item = boardmap[r][c]
            if item and item.isMagicTileAnchor and item.remainingHit == 1 then
                local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Magic_Tile_Change,
                    IntCoord:create(r,c),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
                action.objective = 'color'
                action.completeCallback = tileChangeCallback
                self.mainLogic:addGameAction(action)
                self.waitingCallback = true
            elseif item and item.isMagicTileAnchor and item.remainingHit <= 0 then
                local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Magic_Tile_Change,
                    IntCoord:create(r,c),
                    nil,
                    GamePlayConfig_MaxAction_time
                )
                action.objective = 'die'
                action.completeCallback = tileChangeCallback
                self.mainLogic:addGameAction(action)
                self.waitingCallback = true
            end
        end
    end

    if self.waitingCallback ~= true then
        tileChangeCallback()
    end
end

function MagicTileResetState:handleComplete()
    if self.magicTileHandled == true then
        self.magicTileHandled = false
        self.nextState = self.context.magicLampReinitState
        self.context:onEnter()
    end
end

function MagicTileResetState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
    self.magicTileHandled = false
    self.waitingCallback = false
end

function MagicTileResetState:checkTransition()
    return self.nextState
end

function MagicTileResetState:getClassName()
    return "MagicTileResetState"
end