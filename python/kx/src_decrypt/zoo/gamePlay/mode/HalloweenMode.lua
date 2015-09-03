require "zoo.config.HalloweenBossConfig"
require "zoo.config.LevelDropPropConfig"
HalloweenMode = class(MoveMode)


local ground_upgrade_interval       = 2     -- upgrade ground per 2 rows
local add_max_jewel_interval        = 6     -- max_jewel adds 1 per 6 rows
local generate_add_move_interval    = 5     -- generate 1 add_move per 2(halloween)|5(dragonboat) rows
local max_jewel_limit               = 8    -- max jewel limit is 15
local initial_max_jewel             = 6
local max_generate_row              = 2
local generate_boss_interval        = 4
local generate_jewel_interval       = 2

local GroundGenerator = class()

function GroundGenerator:create(mainLogic)
    local ret = GroundGenerator.new()
    ret:init(mainLogic)
    return ret
end

function GroundGenerator:init(mainLogic)
    self.mainLogic = mainLogic
    self.level1 = 13
    self.level2 = 5
    self.level3 = 0
    self.curIndex = 0
    self.genCount = 0
    self.groundPool = self:genNewGroundPool()
end

function GroundGenerator:genGround()
    if self.curIndex >= #self.groundPool then
        self.groundPool = self:genNewGroundPool()
        self.curIndex = 0
    end
    self.curIndex = self.curIndex + 1
    return self.groundPool[self.curIndex]
end

function GroundGenerator:genNewGroundPool()
    if self.genCount > 0 and self.genCount % ground_upgrade_interval == 0 then
        if self.level2 < 10 and self.level3 < 3 then
            if self.level2 < 1 or self.mainLogic.randFactory:rand(1, 100) > 50 then -- 1 -> 2
                self.level1 = self.level1 - 1
                self.level2 = self.level2 + 1
            else -- 2 -> 3
                self.level2 = self.level2 - 1
                self.level3 = self.level3 + 1
            end
        elseif self.level2 < 10 then
            self.level1 = self.level1 - 1
            self.level2 = self.level2 + 1
        elseif self.level3 < 3 then
            self.level2 = self.level2 - 1
            self.level3 = self.level3 + 1
        end
    end
    self.groundPool = {}
    for i = 1, self.level1 do table.insert(self.groundPool, 1) end
    for i = 1, self.level2 do table.insert(self.groundPool, 2) end
    for i = 1, self.level3 do table.insert(self.groundPool, 3) end

    local length = self.level1 + self.level2 + self.level3
    -- 打乱次序
    for i =1 , length do 
        local selector = self.mainLogic.randFactory:rand(1, length)
        self.groundPool[1], self.groundPool[selector] = self.groundPool[selector], self.groundPool[1]
    end
    self.genCount = self.genCount + 1
    -- print("GroundGenerator:genNewGroundPool:", table.tostring(self.groundPool))
    return self.groundPool
end

function HalloweenMode:initModeSpecial(config)
    self.mainLogic.digJewelCount = DigJewelCount.new()
    self.mainLogic.maydayBossCount = 0

    -- initialize ground pool
    self.rowCountSinceLastGroundUpgrade = 0
    self.maxJewel = initial_max_jewel
    self.generatedRowCount = 0
    self.rowCountSinceLastAddMove = 0
    self.bossGenRowCountDown = 1

    self.lastGenBossTimes = 0
    self.lastGenJewelTimes = 0
    -- 魔法地格的数据结构  保存地格的id和击中的次数
    self.mainLogic.magicTileStruct = {}
    self.mainLogic:updateAllMagicTiles()
    self.mainLogic.dragonBoatPropConfig = LevelDropPropConfig:create(config.dragonBoatPropGen)

    print("dragonBoatPropGen:", table.tostring(self.mainLogic.dragonBoatPropConfig))
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
        self.rowCountSinceLastAddMove = 0
        self.lastGenJewelTimes = 0
        self.lastGenBossTimes  = 0
        self.groundGenerator = GroundGenerator:create(self.mainLogic)
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

    local platform = UserManager.getInstance().platform
    local uid = UserManager.getInstance().uid
    if not uid then uid = "12345" end
    local zongziFileKey = "goldZongZiFileKey_" .. tostring(platform) .. "_u_".. tostring(uid) .. ".ds"

    local localData = Localhost:readFromStorage(zongziFileKey)
    if not localData then
        localData = {}
        localData.lastData = {}
    end
    local lastDataList = localData.lastData[tostring(context.mainLogic.level)]
    if not lastDataList then 
        lastDataList = {} 
        localData.lastData[tostring(context.mainLogic.level)] = lastDataList
    end
    local randomPackage = 3
    local randomIndex = 1
    local randomSelect = 1
    local zongziIndex = 0

    local resetRandomSelect = function()
        
        randomIndex = 1
        zongziIndex = zongziIndex + 1

        local lastRandom = lastDataList[zongziIndex]
        if not lastRandom then
            randomSelect = context.mainLogic.randFactory:rand(1, randomPackage)
        else
            randomSelect = context.mainLogic.randFactory:rand(1, tonumber(randomPackage - 1) )
            if randomSelect >= lastRandom then
                randomSelect = randomSelect + 1
            end
        end
        lastDataList[zongziIndex] = randomSelect
    end

    resetRandomSelect()

    for r = 1, #extraItemMap do
        for c = 1, #extraItemMap[r] do

            local item = extraItemMap[r][c]  --GameItemData

            if item and item.ItemType == GameItemType.kGoldZongZi then

                if randomIndex ~= randomSelect then
                    item.ItemType = GameItemType.kDigGround 
                    item.digGoldZongZiLevel = 0
                    item.digJewelLevel = 0
                    item.digGroundLevel = 1
                    item.isBlock = true 
                    item.isEmpty = false
                    item.isNeedUpdate = true
                else
                    item.ItemType = GameItemType.kGoldZongZi 
                    item.digGoldZongZiLevel = 1
                    item.digJewelLevel = 0
                    item.digGroundLevel = 0
                    item.isBlock = true 
                    item.isEmpty = false
                    item.isNeedUpdate = true
                end

                if randomIndex == randomPackage then
                    resetRandomSelect()
                else
                    randomIndex = randomIndex + 1
                end
            end 
        end
    end
    Localhost:writeToStorage( localData , zongziFileKey )

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

function HalloweenMode:onBossDie()
    local leftGroundRow = self:getDigGroundMaxRow()
    self.bossGenRowCountDown = 5 - leftGroundRow
    print("HalloweenMode:onBossDie, bossGenRowCountDown=", self.bossGenRowCountDown)
end

function HalloweenMode:getExtraMap(passedRow, additionRow)
    print('passedRow, additionRow', passedRow, additionRow, '#self.mainLogic.digItemMap', #self.mainLogic.digItemMap, '#self.mainLogic.gameItemMap', #self.mainLogic.gameItemMap)
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

            local position = nil
            local goldZongziPos = nil
            for r = 1, #self.mainLogic.gameItemMap do
                for c = 1, #self.mainLogic.gameItemMap[r] do
                    local item = self.mainLogic.gameItemMap[r][c]
                    if item.isHalloweenBottle then
                        position = {r = r, c = c}                            
                    end
                    if item.ItemType == GameItemType.kGoldZongZi and not goldZongziPos then
                        goldZongziPos = {r = r, c = c}
                    end
                end
            end

            if goldZongziPos then
                -- print("~~~~~~~~~~~~~~~goldZongziPos~~~~~~~~~~")
                GameGuide:sharedInstance():onGoldZongziAppear(goldZongziPos)
            end

            local boss = self.mainLogic:getHalloweenBoss()
            if not boss then
                if position then
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
                        local guideTilePos = self:getGuideTilePos()
                        if guideTilePos then
                            GameGuide:sharedInstance():onHalloweenBossFirstComeout(guideTilePos)
                        end
                    end
                else
                    stableScrollCallback()
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
        if self.bossGenRowCountDown <= moveUpRow then
            local selectionPool = {}
            local r = #extraItemMap - moveUpRow + self.bossGenRowCountDown
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

            -- 生成鹿角
            selector = selectionPool[self.mainLogic.randFactory:rand(1, #selectionPool)]
            extraItemMap[selector.r][selector.c].isHalloweenBottle = true
            selector.r = selector.r - moveUpRow 
        else
            self.bossGenRowCountDown = self.bossGenRowCountDown - moveUpRow
        end
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
    -- 复用地形中所有超级地块的位置
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
    self.rowCountSinceLastAddMove = self.rowCountSinceLastAddMove + rowCount

    local genJewelCount = self:getGenJewelCount(rowCount)

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
        result[selector] = self:getJewelTileDef()
    end

    local shouldAddMove = self:shouldAddMove()
    print('shouldAddMove:', shouldAddMove)
    if shouldAddMove then
        local selector = self.mainLogic.randFactory:rand(1, length)
        while usedIndex[selector] == true and #usedIndex < length do
            selector = self.mainLogic.randFactory:rand(1, length)
        end
        usedIndex[selector] = true
        result[selector] = self:getAddMoveTileDef()
    end

    for i=1, length do 
        if not result[i] then 
            result[i] = self:getGroundTileDef()
        end
    end

    for k, v in pairs(magicTileIndex) do
        result[v]:addTileData(TileConst.kMagicTile)
    end

    return result
end

function HalloweenMode:testGen()
    for i = 1, 30 do
        local str = ""
        for j = 1, 18 do
            local ground = self.groundGenerator:genGround()
            str = str .. ground
        end
        print(str)
    end
end

function HalloweenMode:getGenBossCount()
    return 0
end

function HalloweenMode:getMaxJewelPerTwoRows()
    local maxJewel = initial_max_jewel + math.floor(self.generatedRowCount / add_max_jewel_interval)
    return math.min(maxJewel, max_jewel_limit)
end

function HalloweenMode:getGenJewelCount(rowCount)
    local genJewelTimes = math.floor(self.generatedRowCount / generate_jewel_interval)
    local result = math.floor(self:getMaxJewelPerTwoRows() / 2 * rowCount)
    return result
end


function HalloweenMode:shouldAddMove(rowCount)
    if self.rowCountSinceLastAddMove >= generate_add_move_interval then
        self.rowCountSinceLastAddMove = self.rowCountSinceLastAddMove - generate_add_move_interval
        return true
    else 
        return false
    end
end

function HalloweenMode:getAddMoveTileDef()
    -- add_move + animal
    local tileDef = TileMetaData.new()
    tileDef:addTileData(TileConst.kAddMove)
    tileDef:addTileData(TileConst.kAnimal)
    return tileDef
end

function HalloweenMode:getGroundTileDef()
    local level = self.groundGenerator:genGround()
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

function HalloweenMode:getJewelTileDef()
    local level = self.groundGenerator:genGround()
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
end

function HalloweenMode:getBossEmptyTileDef()
end

function HalloweenMode:initBossBlood()
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