MaydayEndlessMode = class(MoveMode)

local function swapInTable(table, i, j)
    local t = table[i]
    table[i] = table[j]
    table[j] = t
end

local ground_upgrade_interval       = 4     -- upgrade ground per 4 rows
local add_max_jewel_interval        = 6     -- max_jewel adds 1 per 6 rows
local generate_add_move_interval    = 5     -- generate 1 add_move per 5 rows
local max_jewel_limit               = 8    -- max jewel limit is 8
local initial_max_jewel             = 6
local max_generate_row              = 2
local generate_boss_interval        = 4
local generate_jewel_interval       = 2
local initial_level2_count          = 4
local max_level2_count              = 10
local max_level3_count              = 3


function MaydayEndlessMode:initModeSpecial(config)
    self.mainLogic.digJewelCount = DigJewelCount.new()
    self.mainLogic.maydayBossCount = 0

    -- initialize ground pool
    self.groundPool = {}
    local length = 9*max_generate_row
    for i=1, length do
        if i >= 1 and i <= initial_level2_count then
            self.groundPool[i] = 2 
        else    
            self.groundPool[i] = 1 -- level 1 ground
        end
    end
    -- 打乱次序
    for i =1 , 2*length do 
        local selector = self.mainLogic.randFactory:rand(1, length)
        swapInTable(self.groundPool, 1, selector)
    end

    self.rowCountSinceLastGroundUpgrade = 0
    self.maxJewel = initial_max_jewel
    self.generatedRowCount = 0
    self.rowCountSinceLastAddMove = 0


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

        if context.mainLogic.PlayUIDelegate then
            context.mainLogic.PlayUIDelegate:playFirstShowFireworkGuide()
        end

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
    self.rowCountSinceLastAddMove = self.rowCountSinceLastAddMove + rowCount

    self:upgradeGround(rowCount)

    local genBossCount = self:getGenBossCount()
    local genJewelCount = self:getGenJewelCount(rowCount)
    local shouldAddMove = self:shouldAddMove()

    print('rowCount', rowCount)
    print('generatedRowCount', self.generatedRowCount)
    print('genBossCount', genBossCount)
    print('genJewelCount', genJewelCount)


    local length = 9 * rowCount
    local usableIndex = {}
    for i=1, length do
        table.insert(usableIndex, i)
    end
    local function removeUsableIndex(index)
        for k, v in pairs(usableIndex) do
            if v == index then
                table.remove(usableIndex, k)
            end
        end
    end


    for i = 1, genBossCount do 
        -- 永远是在倒数第二行生成boss，每行最后一个格子不能生成
        local selector = self.mainLogic.randFactory:rand(length - 17, length - 10)
        local index = usableIndex[selector]
        result[index]         = self:getBossTileDef()
        result[index + 1]     = self:getBossEmptyTileDef()
        result[index + 9]     = self:getBossEmptyTileDef()
        result[index + 10]    = self:getBossEmptyTileDef()
        removeUsableIndex(index)
        removeUsableIndex(index+1)
        removeUsableIndex(index+9)
        removeUsableIndex(index+10)
    end
    -- generate add_move
    if shouldAddMove then
        local selector = self.mainLogic.randFactory:rand(1, #usableIndex)
        local index = usableIndex[selector]
        removeUsableIndex(index)
        result[index] = self:getAddMoveTileDef()
    end

    -- generate jewel
    local maxIndex = math.min(genJewelCount, #usableIndex)
    for i = 1, maxIndex do
        local selector = self.mainLogic.randFactory:rand(1, #usableIndex)
        local index = usableIndex[selector]
        removeUsableIndex(index)
        result[index] = self:getJewelTileDef(index)
    end

    for i=1, length do 
        if result[i] == nil then 
            result[i] = self:getGroundTileDef(i)
        end
    end

    return result

end

function MaydayEndlessMode:shouldAddMove()
    if self.mainLogic.levelType == GameLevelType.kSummerWeekly then
        return false
    end

    if self.rowCountSinceLastAddMove >= generate_add_move_interval then
        self.rowCountSinceLastAddMove = self.rowCountSinceLastAddMove - generate_add_move_interval
        return true
    else 
        return false
    end
end

function MaydayEndlessMode:getMaxJewelPerTwoRows()
    local maxJewel = initial_max_jewel + math.floor(self.generatedRowCount / add_max_jewel_interval)
    return math.min(maxJewel, max_jewel_limit)
end

function MaydayEndlessMode:upgradeGround(rowCount)
    self.rowCountSinceLastGroundUpgrade = self.rowCountSinceLastGroundUpgrade + rowCount
    if self.rowCountSinceLastGroundUpgrade >= ground_upgrade_interval then

        local counter  = 0
        local length = 9 * max_generate_row
        local level2_count = 0
        local level3_count = 0


        -- 限制每两行生成的各级云层数量。。。。。
        for i=1, length do 
            if self.groundPool[i] == 2 then
                level2_count = level2_count + 1
            elseif self.groundPool[i] == 3 then
                level3_count = level3_count + 1
            end
        end
        if level2_count >= max_level2_count and level3_count >= max_level3_count then
            return
        end

        while counter <= length do
            counter = counter + 1
            local selector = self.mainLogic.randFactory:rand(1, length)
            if (self.groundPool[selector] == 1 and level2_count < max_level2_count)
            or (self.groundPool[selector] == 2 and level3_count < max_level3_count) then
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

function MaydayEndlessMode:getGenJewelCount(rowCount)
    local genJewelTimes = math.floor(self.generatedRowCount / generate_jewel_interval)
    -- print('genJewelTimes', genJewelTimes, self.lastGenJewelTimes)
    -- if genJewelTimes > self.lastGenJewelTimes then
    --     local diff = genJewelTimes - self.lastGenJewelTimes
    --     self.lastGenJewelTimes = genJewelTimes
    --     return self:getMaxJewelPerTwoRows(rowCount) * diff
    -- end
    -- return 0
    local result = self:getMaxJewelPerTwoRows(rowCount) / 2 * rowCount
    return result
end

function MaydayEndlessMode:getAddMoveTileDef()
    -- add_move + animal
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kAddMove)
    tileDef:addTileData(TileConst.kAnimal)
    return tileDef
end

function MaydayEndlessMode:getGroundTileDef(index)
    if index > 9*max_generate_row then
        index = index % (9*max_generate_row)
    end
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
    if index > 9*max_generate_row then
        index = index % (9*max_generate_row)
    end
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