require "zoo.config.HalloweenBossConfig"
HalloweenMode = class(MoveMode)


local ground_upgrade_interval       = 3     -- upgrade ground per 4 rows
local add_max_jewel_interval        = 6     -- max_jewel adds 1 per 6 rows
local generate_add_move_interval    = 2     -- generate 1 add_move per 2 rows
local max_jewel_limit               = 15    -- max jewel limit is 15
local initial_max_jewel             = 1
local max_generate_row              = 2
local generate_boss_interval        = 4
local generate_jewel_interval       = 2

function HalloweenMode:initModeSpecial(config)
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
    -- 魔法地格的数据结构  保存地格的id和击中的次数
    self.mainLogic.magicTileStruct = {}
    self.mainLogic:updateAllMagicTiles()
    HalloweenBossConfig.reinit()
    
end



function HalloweenMode:afterFail()
    print('HalloweenMode:afterFail')
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

function HalloweenMode:onGameInit()
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
    self.mainLogic:updateAllMagicTiles(extraBoardMap)
    -- print('extraItemMap', #extraItemMap, 'extraBoardMap', #extraBoardMap)
    self.mainLogic.boardView:initDigScrollView(extraItemMap, extraBoardMap, true)
    self.mainLogic.boardView:hideItemViewLayer()
    self.mainLogic.passedRow = 0

    if self.mainLogic.PlayUIDelegate then
        self.mainLogic.PlayUIDelegate:playLevelTargetPanelAnim(playDigScrollAnimation)
    else
        playDigScrollAnimation()
    end
    self.mainLogic:stopWaitingOperation()
end

function HalloweenMode:reachEndCondition()
    return MoveMode.reachEndCondition(self)
end

function HalloweenMode:reachTarget()
    return false
end

function HalloweenMode:getExtraMap(passedRow, additionRow)
    -- print('passedRow, additionRow', passedRow, additionRow, '#self.mainLogic.digItemMap', #self.mainLogic.digItemMap, '#self.mainLogic.gameItemMap', #self.mainLogic.gameItemMap)
    -- debug.debug()
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

function HalloweenMode:checkScrollDigGround(stableScrollCallback)
    local maxDigGroundRow = self:getDigGroundMaxRow()
    local SCROLL_GROUND_MIN_LIMIT = 2
    local SCROLL_GROUND_MAX_LIMIT = 3

    if maxDigGroundRow <= SCROLL_GROUND_MIN_LIMIT then
        local moveUpRow = SCROLL_GROUND_MAX_LIMIT - maxDigGroundRow

        local function localCallback()
            self.mainLogic:updateAllMagicTiles()
            local boss = self.mainLogic:getHalloweenBoss()
            if not boss then
                local position = nil
                for r = 1, #self.mainLogic.gameItemMap do
                    for c = 1, #self.mainLogic.gameItemMap[r] do
                        local item = self.mainLogic.gameItemMap[r][c]
                        if item.isHalloweenBottle then
                            position = {r = r, c = c}                            
                        end
                    end
                end
                local action = GameBoardActionDataSet:createAs(
                        GameActionTargetType.kGameItemAction,
                        GameItemActionType.kItem_Halloween_Boss_Create,
                        IntCoord:create(position.r, position.c),
                        nil,
                        GamePlayConfig_MaxAction_time
                    )
                action.completeCallback = stableScrollCallback
                self.mainLogic:addGameAction(action)

                if not self.firstBoss then
                    self.firstBoss = true
                    GameGuide:sharedInstance():onHalloweenBossFirstComeout(self:getGuideTilePos())
                end
                
            else
                stableScrollCallback()
            end
        end
        self:doScrollDigGround(moveUpRow, localCallback)
        return true
    end
    return false
end

function HalloweenMode:doScrollDigGround(moveUpRow, stableScrollCallback)
    -- print('moveUpRow', moveUpRow) debug.debug()
    local extraItemMap, extraBoardMap = self:getExtraMap(self.mainLogic.passedRow, moveUpRow)
    local mainLogic = self.mainLogic
    local context = self

    local selector = nil
    local function scrollCallback()
        local newItemMap = {}
        local newBoardMap = {}
        for r = 1, 9 do
            local row = r + moveUpRow
            newItemMap[r] = {}
            newBoardMap[r] = {}
            for c = 1, 9 do
                local item = extraItemMap[row][c]:copy()
                local tileDef = TileMetaData.new()
                tileDef:addTileData(TileConst.kEmpty)
                if r == 1 then 
                    item = GameItemData:create() 
                    item:initByConfig(tileDef)
                end
                -- if tileDef.isHalloweenBottle then
                if selector and r == selector.r and c == selector.c then
                    print('tileDef.isHalloweenBottle')
                    -- debug.debug()
                    item.isHalloweenBottle = true
                end
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
                if r == 1 and item.magicTileId ~= nil then 
                    board = GameBoardData:create() 
                    board:initByConfig(tileDef)
                end
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

    local genBoss = (self.mainLogic:getHalloweenBoss() == nil)

    if genBoss then
        local startRow, endRow = 0, 0
        if moveUpRow == 1 then
            startRow = #extraItemMap
            endRow = startRow
        elseif moveUpRow == 2 then
            startRow = #extraItemMap - 1
            endRow = startRow + 1
        elseif moveUpRow == 3 then
            startRow = #extraItemMap - 2
            endRow = startRow + 2
        end

        local selectionPool = {}
        for r = startRow, endRow do
            if extraItemMap[r] then
                -- 优先选择一级云块
                for c = 1, #extraItemMap[r] do
                    local item = extraItemMap[r][c]
                    if item and item.ItemType == GameItemType.kDigGround and item.digGroundLevel == 1 then
                        table.insert(selectionPool, {r = r, c = c})
                    end
                end
                -- 如果没有一级云块，随便找一个动物吧。。。
                if #selectionPool == 0 then
                    for c = 1, #extraItemMap[r] do
                        local item = extraItemMap[r][c]
                        if item and item.ItemType == GameItemType.kAnimal then
                            table.insert(selectionPool, {r = r, c = c})
                        end
                    end
                end
                -- 如果还是不行，随便选一个
                if #selectionPool == 0 then
                    for c = 1, #extraItemMap[r] do
                        local item = extraItemMap[r][c]
                        if item then
                            table.insert(selectionPool, {r = r, c = c})
                        end
                    end
                end
            end
        end

        -- 生成鹿角
        selector = selectionPool[self.mainLogic.randFactory:rand(1, #selectionPool)]
        extraItemMap[selector.r][selector.c].isHalloweenBottle = true
        selector.r = selector.r - moveUpRow 
    end


    self.mainLogic.passedRow = self.mainLogic.passedRow + moveUpRow
    self.mainLogic.boardView:hideItemViewLayer()
    self.mainLogic.boardView:scrollMoreDigView(extraItemMap, extraBoardMap, scrollCallback, true)
end

--获得从含有挖地云块的第一层到最下一层的层数
function HalloweenMode:getDigGroundMaxRow()
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

function HalloweenMode:hasBossOnMap()
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

function HalloweenMode:saveDataForRevert(saveRevertData)
    local mainLogic = self.mainLogic
    saveRevertData.passedRow = mainLogic.passedRow
    saveRevertData.digJewelCount = mainLogic.digJewelCount:getValue()
    saveRevertData.maydayBossCount = mainLogic.maydayBossCount
    MoveMode.saveDataForRevert(self,saveRevertData)
end

function HalloweenMode:revertDataFromBackProp()
    local mainLogic = self.mainLogic
    mainLogic.passedRow = mainLogic.saveRevertData.passedRow
    mainLogic.digJewelCount:setValue(mainLogic.saveRevertData.digJewelCount)
    mainLogic.maydayBossCount = mainLogic.saveRevertData.maydayBossCount
    MoveMode.revertDataFromBackProp(self)
end

function HalloweenMode:revertUIFromBackProp()
    local mainLogic = self.mainLogic
    if mainLogic.PlayUIDelegate then
        mainLogic.PlayUIDelegate:revertTargetNumber(0, 0, mainLogic.digJewelCount:getValue())
        mainLogic.PlayUIDelegate:revertTargetNumber(0, 2, mainLogic.maydayBossCount)
    end
    MoveMode.revertUIFromBackProp(self)
end

function HalloweenMode:generateGroundRow(rowCount)

    local result = {}

    if rowCount <= 0 then return result end

    print('rowCount', rowCount)
    -- 生成magic tile
    local magicTileIndex = {}
    local digTileMapCount = #self.mainLogic.digBoardMap
    print('digTileMapCount', digTileMapCount)

    for r = self.generatedRowCount+1, self.generatedRowCount + rowCount do
        local refIndex = r % digTileMapCount
        if refIndex == 0 then refIndex = digTileMapCount end
        print('refIndex', refIndex)
        for c=1, #self.mainLogic.digBoardMap[refIndex] do
            local item = self.mainLogic.digBoardMap[refIndex][c]
            if item and item.isMagicTileAnchor then
                table.insert(magicTileIndex, (r - self.generatedRowCount - 1) * 9 + c)
            end
        end
    end

    print('*********** GEN magicTileIndex')
    print(table.tostring(magicTileIndex))
    -- debug.debug()

    self.generatedRowCount = self.generatedRowCount + rowCount

    self:upgradeGround(rowCount)

    -- local genBossCount = self:getGenBossCount()
    local genJewelCount = self:getGenJewelCount()

    print('rowCount', rowCount)
    print('generatedRowCount', self.generatedRowCount)
    -- print('genBossCount', genBossCount)
    print('genJewelCount', genJewelCount)


    local length = 9 * rowCount
    local usedIndex = {}

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

    for k, v in pairs(magicTileIndex) do
        result[v]:addTileData(TileConst.kMagicTile)
    end

    return result

end

function HalloweenMode:getMaxJewel()
    local maxJewel = initial_max_jewel + math.floor(self.generatedRowCount / add_max_jewel_interval)
    return maxJewel
end

function HalloweenMode:upgradeGround(rowCount)
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

function HalloweenMode:getGenBossCount()
    local genBossTimes = math.floor(self.generatedRowCount / generate_boss_interval)
    -- print('genBossTimes', genBossTimes, self.lastGenBossTimes)
    if genBossTimes > self.lastGenBossTimes then
        self.lastGenBossTimes = genBossTimes
        return 1
    else
        return 0
    end
end

function HalloweenMode:getGenJewelCount()
    local genJewelTimes = math.floor(self.generatedRowCount / generate_jewel_interval)
    -- print('genJewelTimes', genJewelTimes, self.lastGenJewelTimes)
    if genJewelTimes > self.lastGenJewelTimes then
        local diff = genJewelTimes - self.lastGenJewelTimes
        self.lastGenJewelTimes = genJewelTimes
        return self:getMaxJewel() * diff
    end
    return 0
end


function HalloweenMode:shouldAddMove(rowCount)
    if true then return false end -- 此模式不生成+5
end

function HalloweenMode:getAddMoveTileDef()
    -- add_move + animal
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kAddMove)
    tileDef:addTileData(TileConst.kAnimal)
    return tileDef
end

function HalloweenMode:getGroundTileDef(index)
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

function HalloweenMode:getJewelTileDef(index)
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

function HalloweenMode:getBossTileDef()
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kBlocker)
    tileDef:addTileData(TileConst.kMayDayBlocker4)
    return tileDef
end

function HalloweenMode:getBossEmptyTileDef()
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kBlocker)
    tileDef:addTileData(TileConst.kMaydayBlockerEmpty)
    return tileDef
end

function HalloweenMode:initBossBlood()
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

function HalloweenMode:getGuideTilePos()
    local boardmap = self.mainLogic.boardmap
    for r = 1, #boardmap do
        if boardmap[r] then
            for c = 1, #boardmap[r] do
                local item = boardmap[r][c]
                if item and item.isMagicTileAnchor then
                    local pos = {r = r, c = c}
                    return pos
                end
            end
        end
    end
end