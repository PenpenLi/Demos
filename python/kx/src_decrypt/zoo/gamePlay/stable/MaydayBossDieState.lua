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
    local deadbuffNum = 0 -- 生成春节问好数量
    for r = 1, #gameItemMap do 
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item.ItemType == GameItemType.kBoss 
            and item.bossLevel > 0 
            and item.blood ~= nil
            and item.blood <= 0 
            and not item.isDead then
                count = count + 1
                posR, posC = r, c
                addMoveCount = item.animal_num
                drop_sapphire = item.drop_sapphire
                deadbuffNum = BossConfig[item.bossLevel].deadbuffNum
                item.isDead = true
            end
        end
    end
    print('count, posR, posC', count, posR, posC)

    if count > 0 then

        local function bossDie()
            local addMoveItemPos = GameExtandPlayLogic:getNormalPositionsForBoss(self.mainLogic, addMoveCount, 6, 9, nil)
            deadbuffNum = 0
            local questionItemPos = GameExtandPlayLogic:getNormalPositionsForBoss(self.mainLogic, deadbuffNum, 6, 9, addMoveItemPos)

            local banlist = {}
            for k, v in pairs(addMoveItemPos) do
                table.insert( banlist , v )
            end
            for k, v in pairs(questionItemPos) do
                table.insert( banlist , v )
            end

            local dripPos = {}
            if self.mainLogic.hasDripOnLevel then
                dripPos = GameExtandPlayLogic:getNormalPositionsForBoss(
                    self.mainLogic,  self.mainLogic.randFactory:rand(2, 3) , 6, 9, banlist)
            end
           

            -- print('addMoveItemPos', table.tostring(addMoveItemPos))
            -- print('questionItemPos', table.tostring(questionItemPos))

            local action = GameBoardActionDataSet:createAs(
                            GameActionTargetType.kGameItemAction,
                            GameItemActionType.kItem_Mayday_Boss_Die,
                            IntCoord:create(posR, posC),
                            nil,
                            GamePlayConfig_MaxAction_time
                        )
            action.completeCallback = callback
            action.addMoveItemPos = addMoveItemPos
            action.questionItemPos = questionItemPos
            action.dripPos = dripPos
            self.mainLogic:addGameAction(action)
        end

        -- 如果boss死前可以发放大招，那么发大招之后才死

        local buffCount = 0
        local _buffCounter = 0
        local function buffCallback()
            _buffCounter = _buffCounter + 1
            if _buffCounter >= buffCount then
                bossDie()
            end
        end        

        buffCount = GameExtandPlayLogic:checkBossCasting(self.mainLogic, buffCallback , true)

        if buffCount == 0 then
            bossDie()
        end

       
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

