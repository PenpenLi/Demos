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

function HalloweenMode:initModeSpecial(config)
    self.mainLogic.digJewelCount = DigJewelCount.new()
    self.mainLogic.maydayBossCount = 0

    -- initialize ground pool
    self.rowCountSinceLastGroundUpgrade = 0
    self.maxJewel = initial_max_jewel
    self.generatedRowCount = 0
    self.rowCountSinceLastAddMove = 0
    self.bossGenRowCountDown = 1

    -- 两周年活动新生成模式
    self.generationPoolSize = 16
    self.generationDigItemMap = {}
    self.generationDigBoardMap = {}
    self.digItemMapReadCursor = 1
    self.digBoardMapReadCursor = 1
    self.generationPoolCursor = 1
    -- 两周年活动新生成模式 end



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
        randomSelect = context.mainLogic.randFactory:rand(1, randomPackage)--去掉每次随机不能和上次一样的判断

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
        local newItemRows, newBoardRows = self:generateGroundRow(rowCountUsingGenerator)
        local genRowStartIndex = additionRow + normalRowCount - rowCountUsingGenerator

        print('newItemRows', #newItemRows, 'newBoardRows', #newBoardRows)

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

        local function __stableCallback()
            if stableScrollCallback then
                stableScrollCallback()
            end
        end


        local function localCallback()
            self.mainLogic:updateAllMagicTiles()

            local position = nil
            for r = 1, #self.mainLogic.gameItemMap do
                for c = 1, #self.mainLogic.gameItemMap[r] do
                    local item = self.mainLogic.gameItemMap[r][c]
                    if item.isHalloweenBottle then
                        position = {r = r, c = c}                            
                    end
                end
            end

            local boss = self.mainLogic:getHalloweenBoss()
            if not boss then
                if position then
                    local function completeCallback()

                        if not self.firstBoss then
                            self.firstBoss = true
                            local guideTilePos = self:getGuideTilePos()
                            if guideTilePos then
                                GameGuide:sharedInstance():onHalloweenBossFirstComeout(guideTilePos)
                            end
                        end
                        if __stableCallback then
                            __stableCallback()
                        end
                    end
                    print('gen boss', position.x, position.y)
                    -- debug.debug()
                    local action = GameBoardActionDataSet:createAs(
                            GameActionTargetType.kGameItemAction,
                            GameItemActionType.kItem_Halloween_Boss_Create,
                            IntCoord:create(position.r, position.c),
                            nil,
                            GamePlayConfig_MaxAction_time
                        )
                    action.completeCallback = completeCallback
                    self.mainLogic:addGameAction(action)

                else
                    __stableCallback()
                end
            else
                __stableCallback()
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
    for k, v in pairs(extraItemMap) do
        print('row', k)
    end
    local mainLogic = self.mainLogic
    local context = self

    local bossGenerated = false
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
                if r < mainLogic.boardView.startRowIndex then 
                    item = GameItemData:create() 
                    item:initByConfig(tileDef)
                end
                
                if bossGenerated and r == 9 and c == 5 then
                    print('tileDef.isHalloweenBottle')
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
                if r < mainLogic.boardView.startRowIndex and item.magicTileId ~= nil then 
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
        print('genBoss self.bossGenRowCountDown', self.bossGenRowCountDown)
        if self.bossGenRowCountDown <= moveUpRow then
            local item = extraItemMap[#extraItemMap][5]
            item.isHalloweenBottle = true
            bossGenerated = true
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
                or gameItemMap[r][c].ItemType == GameItemType.kGoldZongZi
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

function HalloweenMode:readDigItemMap(rowCount)
    local ret = {}
    for i = 1, rowCount do
        if self.digItemMapReadCursor > #self.mainLogic.digItemMap then
            self.digItemMapReadCursor = 1
        end
        table.insert(ret, self.mainLogic.digItemMap[self.digItemMapReadCursor])
        self.digItemMapReadCursor = self.digItemMapReadCursor + 1
    end
    return ret
end

function HalloweenMode:readDigBoardMap(rowCount)
    local ret = {}
    for i = 1, rowCount do
        if self.digBoardMapReadCursor > #self.mainLogic.digBoardMap then
            self.digBoardMapReadCursor = 1
        end
        table.insert(ret, self.mainLogic.digBoardMap[self.digBoardMapReadCursor])
        self.digBoardMapReadCursor = self.digBoardMapReadCursor + 1
    end
    return ret
end

function HalloweenMode:generateFunc(itemMap, boardMap, count, changePara, validateFunc, changeFunc)
    local pool = {}
    local cordinates = {}
    for r = 1, #itemMap do
        for c = 1, #itemMap[r] do
            local item = itemMap[r][c]
            if validateFunc(item) then
                table.insert(pool, item)
                table.insert(cordinates, {r, c})
                -- print('validateFunc', r, c)
            end
        end
    end

    if #pool <= count then
        for k, v in pairs(pool) do
            changeFunc(v, changePara)
        end
    else
        local selected = {}
        for i = 1, count do
            local index = self.mainLogic.randFactory:rand(1, #pool)
            table.insert(selected, pool[index])
            print('selected r, c ', cordinates[index][1], cordinates[index][2])
            table.remove(pool, index)
            table.remove(cordinates, index)
        end
        for k, v in pairs(selected) do
            changeFunc(v, changePara)
        end
    end
end


function HalloweenMode:generateDigJewel(itemMap, count)
    print('generateDigJewel', count)

    local function validateFunc(item)
        if item and item.ItemType == GameItemType.kDigGround then 
            return true
        end
        return false
    end
    local function changeToDigJewel(item)
        local level = item.digGroundLevel
        item:cleanAnimalLikeData()
        item.isEmpty = false
        item.ItemType = GameItemType.kDigJewel
        item.digJewelLevel = level
        item.isBlock = true
        item.isNeedUpdate = true
    end
    self:generateFunc(itemMap, nil, count, nil, validateFunc, changeToDigJewel)
end

function HalloweenMode:generateDigGround(itemMap, count)
    print('generateDigGround', count)

    local function validateFunc(item)
        if item and item.ItemType == GameItemType.kDigGround then
            if item.digGroundLevel < 3 then
                return true
            end
        elseif item and item.ItemType == GameItemType.kDigJewel then
            if item.digJewelLevel < 3 then
                return true
            end
        end
        return false
    end

    local function changeLevel(item)
        if item.ItemType == GameItemType.kDigGround then
            item.digGroundLevel = item.digGroundLevel + 1
        elseif item.ItemType == GameItemType.kDigJewel then
            item.digJewelLevel = item.digJewelLevel + 1
        end
    end
    self:generateFunc(itemMap, nil, count, nil, validateFunc, changeLevel)
end

function HalloweenMode:isItemAnimalOrDigGround(item)
    if (item.ItemType == GameItemType.kAnimal 
    and item.ItemSpecialType == 0 
    and not item:hasLock() and not item:hasFurball())
    or item.ItemType == GameItemType.kDigGround
    then
        return true
    end
    return false
end

function HalloweenMode:getRandomAnimalColor()
    local count = #self.mainLogic.mapColorList
    local select = self.mainLogic.randFactory:rand(1, count)
    return self.mainLogic.mapColorList[select]
end

function HalloweenMode:generateCage(itemMap, count)
    print('generateCage', count)
    local function validateFunc(item)
        return self:isItemAnimalOrDigGround(item)
    end
    local function changetoCage(item)
        if item.ItemType == GameItemType.kAnimal then
            item.cageLevel = 1
            -- item.isBlock = true
        elseif item.ItemType == GameItemType.kDigGround then
            item:cleanAnimalLikeData()
            item.isEmpty = false
            item.ItemType = GameItemType.kAnimal
            item.ItemColorType = self:getRandomAnimalColor()
            item.cageLevel = 1
            -- item.isBlock = true
        end
    end
    self:generateFunc(itemMap, nil, count, nil, validateFunc, changetoCage)
end

function HalloweenMode:generateVenom(itemMap, count)
    print('generateVenom', count)
    local function validateFunc(item)
        return self:isItemAnimalOrDigGround(item)
    end
    local function changetoVenom(item)
        item:cleanAnimalLikeData()
        item.isEmpty = false
        item.ItemType = GameItemType.kVenom
        item.isBlock = true
        item.venomLevel = 1
    end
    self:generateFunc(itemMap, nil, count, nil, validateFunc, changetoVenom)
end

function HalloweenMode:generateCoin(itemMap, count)
    print('generateCoin', count)
    local function validateFunc(item)
        return self:isItemAnimalOrDigGround(item)
    end
    local function changeToCoin(item)
        item:cleanAnimalLikeData()
        item.isEmpty = false
        item.ItemType = GameItemType.kCoin
    end
    self:generateFunc(itemMap, nil, count, nil, validateFunc, changeToCoin)
end

function HalloweenMode:generateOctopus(itemMap, boardMap, count)
    print('generateOctopus', count)
    local function validateFunc(item)
        return self:isItemAnimalOrDigGround(item)
    end
    local function changeToOctopus(item)
        item:cleanAnimalLikeData()
        item.ItemType = GameItemType.kPoisonBottle
        item.forbiddenLevel = 0 
        item.isBlock = true
    end
    self:generateFunc(itemMap, boardMap, count, nil, validateFunc, changeToOctopus)

end

function HalloweenMode:generateFurball(itemMap, count, color)
    print('generateFurball', count)
    local function validateFunc(item)
        return self:isItemAnimalOrDigGround(item)
    end
    local function changeToFurball(item, color)
        item:cleanAnimalLikeData()
        item.ItemType = GameItemType.kAnimal
        item.ItemColorType = self:getRandomAnimalColor()
        item.furballLevel = 1
        item.furballType = color
        -- item.isBlock = true
        item.isEmpty = false
    end
    self:generateFunc(itemMap, nil, count, color, validateFunc, changeToFurball)
end

function HalloweenMode:generateAddStep(itemMap, count)
    -- not needed
end

local GenerationConfig = {
    digJewel = {4, 4},
    digGround = {2, 4},
    furball = {border = 20, count = {2, 3}},
    cage = {border = 40, count = {3, 4}},
    venom = {border = 60, count = {2, 3}},
    coin = {border = 80, count = {3, 4}},
    octopus = {border = 100, count = {1, 1}},
    addStep = {0, 0},
}

function HalloweenMode:initGenerationPool()
    print('initGenerationPool')
    -- if self.generationPoolCursor <= self.generationPoolSize then
    --     return
    -- end

    self.generationPoolCursor = 1
    self.generationDigItemMap = {}
    self.generationDigBoardMap = {}
    local templateDigItemMap = self:readDigItemMap(self.generationPoolSize)
    local templateDigBoardMap = self:readDigBoardMap(self.generationPoolSize)

    print('templateDigItemMap', #templateDigItemMap)

    for cycle = 1, 4 do
        local itemMap = {}
        local boardMap = {}
        for index = 1, 4 do
            local cursor = (cycle-1)*4+index
            local copyItemRow = {}
            for i = 1, 9 do
                local copyItem = templateDigItemMap[cursor][i]:copy()
                table.insert(copyItemRow, copyItem)
            end
            table.insert(itemMap, copyItemRow)

            local copyBoardRow = {}
            for i = 1, 9 do
                local copyItem = templateDigBoardMap[cursor][i]:copy()
                table.insert(copyBoardRow, copyItem)
            end
            table.insert(boardMap, copyBoardRow)
        end

        local digGroundCount = self.mainLogic.randFactory:rand(GenerationConfig.digGround[1],GenerationConfig.digGround[2])
        if digGroundCount > 0 then
            self:generateDigGround(itemMap, digGroundCount)
        end

        local digJewelCount = self.mainLogic.randFactory:rand(GenerationConfig.digJewel[1],GenerationConfig.digJewel[2])
        if digJewelCount > 0 then
            self:generateDigJewel(itemMap, digJewelCount)
        end

        local addStepCount = self.mainLogic.randFactory:rand(GenerationConfig.addStep[1],GenerationConfig.addStep[2])
        if addStepCount > 0 then
            self:generateAddStep(itemMap, addStepCount)
        end

        local selection = self.mainLogic.randFactory:rand(1, 100)
        print('selection', selection)
        if selection <= GenerationConfig.furball.border then
            local color = ((self.mainLogic.randFactory:rand(1, 100) <= 50) and GameItemFurballType.kGrey or GameItemFurballType.kBrown)
            local count = self.mainLogic.randFactory:rand(GenerationConfig.furball.count[1],GenerationConfig.furball.count[2])
            self:generateFurball(itemMap, count, color)
        elseif selection <= GenerationConfig.cage.border then
            local count = self.mainLogic.randFactory:rand(GenerationConfig.cage.count[1],GenerationConfig.cage.count[2])
            self:generateCage(itemMap, count)
        elseif selection <= GenerationConfig.venom.border then
            local count = self.mainLogic.randFactory:rand(GenerationConfig.venom.count[1],GenerationConfig.venom.count[2])
            self:generateVenom(itemMap, count)
        elseif selection <= GenerationConfig.coin.border then
            local count = self.mainLogic.randFactory:rand(GenerationConfig.coin.count[1],GenerationConfig.coin.count[2])
            self:generateCoin(itemMap, count)
        elseif selection <= GenerationConfig.octopus.border then
            local count = self.mainLogic.randFactory:rand(GenerationConfig.octopus.count[1],GenerationConfig.octopus.count[2])
            self:generateOctopus(itemMap, boardMap, count)
        end

        for i = 1, 4 do
            table.insert(self.generationDigItemMap, itemMap[i])
            table.insert(self.generationDigBoardMap, boardMap[i])
        end
    end
    -- print('start..................')
    -- for r = 1, 16 do
    --     print('row no.', r)
    --     for c = 1, 9 do
    --         print(self.generationDigItemMap[r][c].ItemType)
    --     end
    --     print('row end')
    -- end
    -- print('end...............')

    print('self.generationDigItemMap', #self.generationDigItemMap)
    print('self.generationDigBoardMap', #self.generationDigBoardMap)
end

function HalloweenMode:generateGroundRow(rowCount)
    local newItemMap, newBoardMap = {}, {}
    if rowCount <= 0 then return newItemMap, newBoardMap end

    print('rowCount', rowCount)
    for i = 1, rowCount do
        if self.generationPoolCursor > self.generationPoolSize or not self.poolInited then
            self:initGenerationPool()
            self.poolInited = true
        end
        print('generationPoolCursor', self.generationPoolCursor)
        table.insert(newItemMap, self.generationDigItemMap[self.generationPoolCursor])
        table.insert(newBoardMap, self.generationDigBoardMap[self.generationPoolCursor])
        self.generationPoolCursor = self.generationPoolCursor + 1
    end
    return newItemMap, newBoardMap
end

function HalloweenMode:getGenBossCount()
    return 0
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

function HalloweenMode:getExtraMapOld(passedRow, additionRow)
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
            local colorIndex = AnimalTypeConfig.convertColorTypeToIndex(r)
            item:initByAnimalDef(math.pow(2, colorIndex))
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

function HalloweenMode:generateGroundRowOld(rowCount)

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
