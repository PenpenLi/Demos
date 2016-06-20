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
    self.hasItemToHandle = false
    self.handleCount = 0
    self.completeCount = 0
    self:handleMagicTile()

end

function MagicTileResetState:handleMagicTile()
    if not self.mainLogic.gameMode:is(HalloweenMode) then 
        self:handleComplete()
        return 
    end

    local function tileChangeCallback()
        self.completeCount = self.completeCount + 1
        if self.completeCount >= self.handleCount then
            self.hasItemToHandle = true
            self:handleComplete()
        end
    end

    local boardmap = self.mainLogic.boardmap
    for r = 1, #boardmap do 
        for c = 1, #boardmap[r] do 
            local item = boardmap[r][c]
            if item then
                if item.isMagicTileAnchor then
                    if self.mainLogic.isInStep and item.magicTileId ~= nil and item.isHitThisRound == true then
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
                self.handleCount = self.handleCount + 1
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
                self.handleCount = self.handleCount + 1
            end
        end
    end

    if self.handleCount == 0 then
        self:handleComplete()
    end
end

function MagicTileResetState:handleComplete()
    self.nextState = self.context.checkHedgehogCrazyState
    if self.hasItemToHandle then
        self.context:onEnter()
    end
end

function MagicTileResetState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
    self.hasItemToHandle = false
    self.handleCount = 0
    self.completeCount = 0
end

function MagicTileResetState:checkTransition()
    return self.nextState
end

function MagicTileResetState:getClassName()
    return "MagicTileResetState"
end