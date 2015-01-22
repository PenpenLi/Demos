MaydayBossDieState = class(BaseStableState)


function MaydayBossDieState:create( context )
    -- body
    local v = MaydayBossDieState.new()
    v.context = context
    v.mainLogic = context.mainLogic  --gameboardlogic
    v.boardView = v.mainLogic.boardView
    return v
end

function MaydayBossDieState:update( ... )
    -- body
end

function MaydayBossDieState:onEnter()
    print("---------->>>>>>>>>> MaydayBossDieState enter")
    self.nextState = nil
    local function callback( ... )
        -- body
        print('DIE COMPLEPTE')
        self:handleComplete();
    end

    local gameItemMap = self.mainLogic.gameItemMap
    local count = 0
    local posR, posC = 0, 0
    local drop_sapphire = 0
    local addMoveCount = 0
    for r = 1, #gameItemMap do 
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item.ItemType == GameItemType.kBoss 
            and item.bossLevel > 0 
            and item.blood ~= nil
            and item.blood <= 0 then
                count = count + 1
                posR, posC = r, c
                addMoveCount = item.animal_num
                drop_sapphire = item.drop_sapphire
            end
        end
    end
    print('count, posR, posC', count, posR, posC)

    if count > 0 then
        local addMoveItemPos = {}

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
        for r = 5, #gameItemMap do 
            for c = 1, #gameItemMap[r] do
                if isNormal(gameItemMap[r][c]) then
                    table.insert(availablePos, {r = r, c = c})
                end
            end
        end

        if #availablePos < addMoveCount then
            addMoveItemPos = availablePos
        else
            for i = 1, addMoveCount do
                local idx = self.mainLogic.randFactory:rand(1, #availablePos)
                table.insert(addMoveItemPos, availablePos[idx])
                table.remove(availablePos, idx)
            end
        end

        print('addMoveItemPos', table.tostring(addMoveItemPos))

        local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Mayday_Boss_Die,
                        IntCoord:create(posR, posC),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
        action.completeCallback = callback
        action.addMoveItemPos = addMoveItemPos
        self.mainLogic:addGameAction(action)
    end 

    return count
end


function MaydayBossDieState:handleComplete()
    self.mainLogic:setNeedCheckFalling();
end

function MaydayBossDieState:onExit()
    print("----------<<<<<<<<<< MaydayBossDieState exit")
    self.nextState = nil
    self.hasItemToHandle = false
end

function MaydayBossDieState:checkTransition()
    print("-------------------------MaydayBossDieState checkTransition")
    return self.nextState
end

