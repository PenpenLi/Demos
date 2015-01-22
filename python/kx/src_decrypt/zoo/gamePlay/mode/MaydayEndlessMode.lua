MaydayEndlessMode = class(MoveMode)


local ground_upgrade_interval       = 4     -- upgrade ground per 4 rows
local add_max_jewel_interval        = 6     -- max_jewel adds 1 per 6 rows
local generate_add_move_interval    = 2     -- generate 1 add_move per 2 rows
local max_jewel_limit               = 15    -- max jewel limit is 15
local initial_max_jewel             = 1
local max_generate_row              = 2
local generate_boss_interval        = 4
local generate_jewel_interval       = 2


function MaydayEndlessMode:initModeSpecial(config)
    self.mainLogic.digJewelCount = DigJewelCount.new()
    self.mainLogic.maydayBossCount = 0

    -- initialize ground pool
    self.groundPool = {}
    for i=1, 9*max_generate_row do
        self.groundPool[i] = 1 -- level 1 ground
    end
    self.rowCountSinceLastGroundUpgrade = 0
    self.maxJewel = initial_max_jewel
    self.generatedRowCount = 0


    self.lastGenBossTimes = 0
    self.lastGenJewelTimes = 0
    
end

function MaydayEndlessMode:afterFail()
    print('MaydayEndlessMode:afterFail')
    local mainLogic = self.mainLogic
    local function tryAgainWhenFailed(isTryAgain)   ----确认加5步之后，修改数据
        if isTryAgain then
            self:getAddSteps(5)
            mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
            mainLogic.fsm:changeState(mainLogic.fsm.waitingState)
        else
            if MoveMode.reachEndCondition(self) then
                self.leftMoveToWin = self.theCurMoves
                mainLogic:setGamePlayStatus(GamePlayStatus.kBonus)
            else
                mainLogic:setGamePlayStatus(GamePlayStatus.kFailed)
            end
        end
    end 
    if mainLogic.PlayUIDelegate then
        mainLogic.PlayUIDelegate:addStep(mainLogic.level, mainLogic.totalScore, self:getScoreStarLevel(mainLogic), self:reachTarget(), tryAgainWhenFailed)
    end
end

function MaydayEndlessMode:onGameInit()
    local context = self
    local function setGameStart()
        context.mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
        context.mainLogic.boardView:showItemViewLayer()
        context.mainLogic.boardView:removeDigScrollView()
        context.mainLogic.boardView.isPaused = false
        context.mainLogic.fsm:initState()

        self.generatedRowCount = 0
        self.lastGenJewelTimes = 0
        self.lastGenBossTimes  = 0
    end

    local function playPrePropAnimation()
        if context.mainLogic.PlayUIDelegate then
            context.mainLogic.PlayUIDelegate:playPrePropAnimation(setGameStart) 
        else
            setGameStart()
        end
    end

    local function playDigScrollAnimation()
        context.mainLogic.boardView:startScrollInitDigView(playPrePropAnimation)
    end

    local extraItemMap, extraBoardMap = context:getExtraMap(0, #context.mainLogic.digBoardMap)
    print('extraItemMap', #extraItemMap, 'extraBoardMap', #extraBoardMap)
    self.mainLogic.boardView:initDigScrollView(extraItemMap, extraBoardMap)
    self.mainLogic.boardView:hideItemViewLayer()
    self.mainLogic.passedRow = 0

    if self.mainLogic.PlayUIDelegate then
        self.mainLogic.PlayUIDelegate:playLevelTargetPanelAnim(playDigScrollAnimation)
    else
        playDigScrollAnimation()
    end
    self.mainLogic:stopWaitingOperation()
end

function MaydayEndlessMode:reachEndCondition()
    return MoveMode.reachEndCondition(self)
end

function MaydayEndlessMode:reachTarget()
    return false
end

function MaydayEndlessMode:getExtraMap(passedRow, additionRow)
    local itemMap = {}
    local boardMap = {}

    local rowCountUsingConfig = 0
    local rowCountUsingGenerator = 0

    local totalAvailableConfigRowCount = #self.mainLogic.digItemMap
    ---------------------- TEST -----------------------
    -- local totalAvailableConfigRowCount = 0 -- TEST
    ---------------------------------------------------

    if passedRow + additionRow <= totalAvailableConfigRowCount then -- all rows from config
        rowCountUsingConfig = additionRow
        rowCountUsingGenerator = 0
    elseif passedRow >= totalAvailableConfigRowCount then -- all rows from generator
        rowCountUsingConfig = 0
        rowCountUsingGenerator = additionRow 
    else
        rowCountUsingConfig = totalAvailableConfigRowCount - passedRow
        rowCountUsingGenerator = additionRow - rowCountUsingConfig
    end

    -- init row 1 to row 9
    local normalRowCount = #self.mainLogic.gameItemMap
    -- print('normalRowCount', normalRowCount)
    for row = 1, normalRowCount do
        table.insert(itemMap, self.mainLogic.gameItemMap[row])
        table.insert(boardMap, self.mainLogic.boardmap[row])
    end

    -- read config rows if available
    if rowCountUsingConfig > 0 then
        -- print('using config')
        for i = 1, rowCountUsingConfig do 
            local configRowIndex = passedRow + i
            table.insert(itemMap, self.mainLogic.digItemMap[configRowIndex])
            table.insert(boardMap, self.mainLogic.digBoardMap[configRowIndex])
            for c = 1, #self.mainLogic.digItemMap[configRowIndex] do 
                self.mainLogic.digItemMap[configRowIndex][c].y = i + normalRowCount
            end
            for c = 1, #self.mainLogic.digBoardMap[configRowIndex] do
                self.mainLogic.digBoardMap[configRowIndex][c].y = i + normalRowCount
            end
        end
    end

    if rowCountUsingGenerator > 0 then
        local generatedItems = self:generateGroundRow(rowCountUsingGenerator)
        local newItemRows = {}
        local newBoardRows = {}
        for i=1, rowCountUsingGenerator do 
            newItemRows[i] = {}
            newBoardRows[i] = {}
        end


        for k, v in pairs(generatedItems) do 
            local item = GameItemData:create()
            item:initByConfig(v)
            local r = self.mainLogic:randomColor()
            item:initByAnimalDef(math.pow(2, r))
            item:initBalloonConfig(self.mainLogic.balloonFrom)
            item:initAddMoveConfig(self.mainLogic.addMoveBase)
            if item.ItemType == GameItemType.kBoss then 
                print(item.bossLevel, item.blood)
            end

            local board = GameBoardData:create()
            board:initByConfig(v)

            local rowIndex = math.ceil(k / 9)
            local colIndex = k - (rowIndex - 1) * 9 
            newItemRows[rowIndex][colIndex] = item
            newBoardRows[rowIndex][colIndex] = board
        end


        local genRowStartIndex = additionRow + normalRowCount - rowCountUsingGenerator

        for k1, itemRow in pairs(newItemRows) do 
            table.insert(itemMap, itemRow)
            for k2, col in pairs(itemRow) do 
                col.x = k2
                col.y = k1 + genRowStartIndex
            end
        end

        for k1, boardRow in pairs(newBoardRows) do 
            table.insert(boardMap, boardRow)
            for k2, col in pairs(boardRow) do 
                col.x = k2
                col.y = k1 + genRowStartIndex
            end
        end
    end

    -- print('itemMap, boardMap', #itemMap, #boardMap)
    return itemMap, boardMap
end

function MaydayEndlessMode:checkScrollDigGround(stableScrollCallback)
    local maxDigGroundRow = self:getDigGroundMaxRow()
    local SCROLL_GROUND_MIN_LIMIT = 2
    local SCROLL_GROUND_MAX_LIMIT = 4

    if maxDigGroundRow <= SCROLL_GROUND_MIN_LIMIT and not self:hasBossOnMap() then
        local moveUpRow = SCROLL_GROUND_MAX_LIMIT - maxDigGroundRow
        
        -- 只滚动偶数行，避免boss被分割。boss只生成在偶数行
        if moveUpRow % 2 ~= 0 then 
            moveUpRow = moveUpRow - 1 
        end

        self:doScrollDigGround(moveUpRow, stableScrollCallback)
        return true
    end
    return false
end

function MaydayEndlessMode:doScrollDigGround(moveUpRow, stableScrollCallback)
    local extraItemMap, extraBoardMap = self:getExtraMap(self.mainLogic.passedRow, moveUpRow)
    local mainLogic = self.mainLogic
    local context = self
    local function scrollCallback()
        local newItemMap = {}
        local newBoardMap = {}
        for r = 1, 9 do
            local row = r + moveUpRow
            newItemMap[r] = {}
            newBoardMap[r] = {}
            for c = 1, 9 do
                local item = extraItemMap[row][c]:copy()
                local mimosaHoldGrid = item.mimosaHoldGrid
                item.mimosaHoldGrid = {}
                for k, v in pairs(mimosaHoldGrid) do 
                    v.x = v.x - moveUpRow
                    if v.x > 0 then
                        table.insert(item.mimosaHoldGrid, v)
                    end
                end
                
                item.y = r
                local board = extraBoardMap[row][c]:copy()
                board.y = r
                board.isProducer = mainLogic.boardmap[r][c].isProducer
                board.theGameBoardFallType = table.clone(mainLogic.boardmap[r][c].theGameBoardFallType)
                newItemMap[r][c] = item
                newBoardMap[r][c] = board
                mainLogic:addNeedCheckMatchPoint(r, c)
            end
        end
        mainLogic.gameItemMap = nil
        mainLogic.gameItemMap = newItemMap
        mainLogic.boardmap = nil
        mainLogic.boardmap = newBoardMap
        FallingItemLogic:preUpdateHelpMap(mainLogic)
        mainLogic.boardView:reInitByGameBoardLogic()
        mainLogic.boardView:showItemViewLayer()
        mainLogic.boardView:removeDigScrollView()

        if stableScrollCallback and type(stableScrollCallback) == "function" then
            stableScrollCallback()
        end
    end

    self.mainLogic.passedRow = self.mainLogic.passedRow + moveUpRow
    self.mainLogic.boardView:hideItemViewLayer()
    self.mainLogic.boardView:scrollMoreDigView(extraItemMap, extraBoardMap, scrollCallback)
end

--获得从含有挖地云块的第一层到最下一层的层数
function MaydayEndlessMode:getDigGroundMaxRow()
    local gameItemMap = self.mainLogic.gameItemMap
    for r = 1, #gameItemMap do
        for c = 1, #gameItemMap[r] do
            if gameItemMap[r][c].ItemType == GameItemType.kDigGround
                or gameItemMap[r][c].ItemType == GameItemType.kDigJewel
                then
                return 10 - r
            end
        end
    end
    return 0
end

function MaydayEndlessMode:hasBossOnMap()
    local gameItemMap = self.mainLogic.gameItemMap
    for r = #gameItemMap, 1, -1 do -- 从最后一行开始，效率更高
        for c = 1, #gameItemMap[r] do 
            if gameItemMap[r][c].ItemType == GameItemType.kBoss then 
                return true
            end
        end
    end
    return false
end

function MaydayEndlessMode:saveDataForRevert(saveRevertData)
    local mainLogic = self.mainLogic
    saveRevertData.passedRow = mainLogic.passedRow
    saveRevertData.digJewelCount = mainLogic.digJewelCount:getValue()
    saveRevertData.maydayBossCount = mainLogic.maydayBossCount
    MoveMode.saveDataForRevert(self,saveRevertData)
end

function MaydayEndlessMode:revertDataFromBackProp()
    local mainLogic = self.mainLogic
    mainLogic.passedRow = mainLogic.saveRevertData.passedRow
    mainLogic.digJewelCount:setValue(mainLogic.saveRevertData.digJewelCount)
    mainLogic.maydayBossCount = mainLogic.saveRevertData.maydayBossCount
    MoveMode.revertDataFromBackProp(self)
end

function MaydayEndlessMode:revertUIFromBackProp()
    local mainLogic = self.mainLogic
    if mainLogic.PlayUIDelegate then
        mainLogic.PlayUIDelegate:revertTargetNumber(0, 0, mainLogic.digJewelCount:getValue())
        mainLogic.PlayUIDelegate:revertTargetNumber(0, 2, mainLogic.maydayBossCount)
    end
    MoveMode.revertUIFromBackProp(self)
end

function MaydayEndlessMode:generateGroundRow(rowCount)

    local result = {}

    if rowCount <= 0 then return result end

    self.generatedRowCount = self.generatedRowCount + rowCount

    self:upgradeGround(rowCount)

    local genBossCount = self:getGenBossCount()
    local genJewelCount = self:getGenJewelCount()

    print('rowCount', rowCount)
    print('generatedRowCount', self.generatedRowCount)
    print('genBossCount', genBossCount)
    print('genJewelCount', genJewelCount)


    local length = 9 * rowCount
    local usedIndex = {}

    for i = 1, genBossCount do 
        -- 永远是在倒数第二行生成boss，每行最后一个格子不能生成
        local selector = self.mainLogic.randFactory:rand(length - 17, length - 10)
        usedIndex[selector]         = true
        usedIndex[selector + 1]     = true
        usedIndex[selector + 9]     = true
        usedIndex[selector + 10]    = true
        result[selector]         = self:getBossTileDef()
        result[selector + 1]     = self:getBossEmptyTileDef()
        result[selector + 9]     = self:getBossEmptyTileDef()
        result[selector + 10]    = self:getBossEmptyTileDef()
    end
    -- generate add_move
    if shouldAddMove then
        local selector = self.mainLogic.randFactory:rand(1, length)
        while usedIndex[selector] == true and #usedIndex < length do
            selector = self.mainLogic.randFactory:rand(1, length)
        end
        usedIndex[selector] = true
        result[selector] = self:getAddMoveTileDef()
    end

    -- generate jewel
    print('GEN jewel', self.maxJewel)
    for i = 1, genJewelCount do
        local selector = self.mainLogic.randFactory:rand(1, length)
        while usedIndex[selector] == true and #usedIndex < length do
            selector = self.mainLogic.randFactory:rand(1, length)
        end
        usedIndex[selector] = true
        result[selector] = self:getJewelTileDef(selector)
    end

    for i=1, length do 
        if result[i] == nil then 
            result[i] = self:getGroundTileDef(i)
        end
    end

    return result

end

function MaydayEndlessMode:getMaxJewel()
    local maxJewel = initial_max_jewel + math.floor(self.generatedRowCount / add_max_jewel_interval)
    return maxJewel
end

function MaydayEndlessMode:upgradeGround(rowCount)
    self.rowCountSinceLastGroundUpgrade = self.rowCountSinceLastGroundUpgrade + rowCount
    if self.rowCountSinceLastGroundUpgrade >= ground_upgrade_interval then

        local counter  = 0
        local length = 9 * max_generate_row
        while counter <= length do
            counter = counter + 1
            local selector = self.mainLogic.randFactory:rand(1, length)
            if self.groundPool[selector] and self.groundPool[selector] < 3 then
                self.groundPool[selector] = self.groundPool[selector] + 1
                break
            end
        end
        self.rowCountSinceLastGroundUpgrade = self.rowCountSinceLastGroundUpgrade - ground_upgrade_interval
    end
end

function MaydayEndlessMode:getGenBossCount()
    local genBossTimes = math.floor(self.generatedRowCount / generate_boss_interval)
    -- print('genBossTimes', genBossTimes, self.lastGenBossTimes)
    if genBossTimes > self.lastGenBossTimes then
        self.lastGenBossTimes = genBossTimes
        return 1
    else
        return 0
    end
end

function MaydayEndlessMode:getGenJewelCount()
    local genJewelTimes = math.floor(self.generatedRowCount / generate_jewel_interval)
    -- print('genJewelTimes', genJewelTimes, self.lastGenJewelTimes)
    if genJewelTimes > self.lastGenJewelTimes then
        local diff = genJewelTimes - self.lastGenJewelTimes
        self.lastGenJewelTimes = genJewelTimes
        return self:getMaxJewel() * diff
    end
    return 0
end


function MaydayEndlessMode:shouldAddMove(rowCount)
    if true then return false end -- 此模式不生成+5
end

function MaydayEndlessMode:getAddMoveTileDef()
    -- add_move + animal
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kAddMove)
    tileDef:addTileData(TileConst.kAnimal)
    return tileDef
end

function MaydayEndlessMode:getGroundTileDef(index)
    local level = self.groundPool[index] or 1
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kDigGround)
    tileDef:addTileData(TileConst.kBlocker)
    if level == 1 then
        tileDef:addTileData(TileConst.kDigGround_1)
    elseif level == 2 then
        tileDef:addTileData(TileConst.kDigGround_2)
    elseif level == 3 then
        tileDef:addTileData(TileConst.kDigGround_3)
    end
    return tileDef
end

function MaydayEndlessMode:getJewelTileDef(index)
    local level = self.groundPool[index] or 1
    local tileDef = TileMetaData.new()
    -- print('level', level)
    tileDef:addTileData(TileConst.kBlocker)
    if level == 1 then
        tileDef:addTileData(TileConst.kDigJewel_1_blue)
    elseif level == 2 then
        tileDef:addTileData(TileConst.kDigJewel_2_blue)
    elseif level == 3 then
        tileDef:addTileData(TileConst.kDigJewel_3_blue)
    end
    return tileDef
end

function MaydayEndlessMode:getBossTileDef()
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kBlocker)
    tileDef:addTileData(TileConst.kMayDayBlocker4)
    return tileDef
end

function MaydayEndlessMode:getBossEmptyTileDef()
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kBlocker)
    tileDef:addTileData(TileConst.kMaydayBlockerEmpty)
    return tileDef
end

function MaydayEndlessMode:initBossBlood()
    local gameItemMap = self.mainLogic.gameItemMap
    for r = 1, #gameItemMap do
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item.ItemType == GameItemType.kBoss and item.bossLevel > 0 then
                item.blood = 10
            end
        end
    end
end