require "zoo.config.BaseTransmission"

GameMapInitialLogic = class()

function GameMapInitialLogic:init(mainLogic, config)
	local _tileMap = config.tileMap
	self:initTileData(mainLogic, config)	
	self:initSnailRoadData(mainLogic, config)

	self:initColorAndSpecialData(mainLogic, config.animalMap,  config.numberOfColors)	
	self:initColorType(mainLogic, config.numberOfColors)
	self:initDropBuff(mainLogic)
	self:initDigTileMap(mainLogic, config)
	self:initMagicLamp(mainLogic)  -- 在计算随机颜色前就初始化神灯
	self:initBottleBlocker(mainLogic)
	self:calculateItemColors(mainLogic, config)
	self:initPortal(mainLogic, config.portals)
	self:checkItemBlock(mainLogic)
	self:initIngredientProducer(mainLogic)

	self:initTransmission(mainLogic, config)
end

--生成地图基础信息
function GameMapInitialLogic:initTileData(mainLogic, config)
	local tileMap = config.tileMap
	for r = 1, #tileMap do
		if mainLogic.boardmap[r] == nil then mainLogic.boardmap[r] = {} end
		if mainLogic.gameItemMap[r] == nil then mainLogic.gameItemMap[r] = {} end
		for c = 1, #tileMap[r] do
			local tileDef = tileMap[r][c]
			mainLogic.boardmap[r][c]:initByConfig(tileDef)
			if config.gameMode == 'seaOrder' then
				mainLogic.boardmap[r][c]:setGameModeId(GameModeTypeId.SEA_ORDER_ID)
			end
			if mainLogic.boardmap[r][c].isMoveTile then
				mainLogic.boardmap[r][c]:initTileMoveByConfig(config.tileMoveCfg)
			end
			mainLogic.gameItemMap[r][c]:initByConfig(tileDef)
			mainLogic.gameItemMap[r][c]:initBalloonConfig(mainLogic.balloonFrom)
			mainLogic.gameItemMap[r][c]:initAddMoveConfig(mainLogic.addMoveBase)
			mainLogic.gameItemMap[r][c]:initAddTimeConfig(mainLogic.addTime)

			if config.gameMode == AnimalGameMode.kTaskForUnlockArea then 
				mainLogic.gameItemMap[r][c]:initUnlockAreaDropDownModeInfo()
				mainLogic.boardmap[r][c]:initUnlockAreaDropDownModeInfo()
			end
		end
	end
end

function GameMapInitialLogic:initDropBuff(mainLogic)
	if mainLogic.dropBuffLogic and mainLogic.dropBuffLogic.canBeTriggered then
		mainLogic.dropBuffLogic:onGameInit(mainLogic.realCostMove)
	end
end

function GameMapInitialLogic:initSnailRoadData( mainLogic, config )
	-- body
	local tileMap = config.routeRawData
	if not tileMap then  return end
	local initSnailNum = config.snailInitNum

	for r = 1, #tileMap do 
		if tileMap[r] then
			for c = 1, #tileMap[r] do
				local tileDef = tileMap[r][c]
				if tileDef then
					local item, board = mainLogic.gameItemMap[r][c], mainLogic.boardmap[r][c]
					board:initSnailRoadDataByConfig(tileDef)
					item:initSnailRoadType(mainLogic.boardmap[r][c])
					if item.isSnail then 
						mainLogic.snailCount = mainLogic.snailCount + 1
					end
				end
			end
		end
	end

	for r = 1, #mainLogic.boardmap do 
		for c = 1, #mainLogic.boardmap[r] do 
			self:setPreSnailRoads(mainLogic, r, c)
			local item = mainLogic.gameItemMap[r][c]
			local board = mainLogic.boardmap[r][c]
			if mainLogic.snailCount < initSnailNum 
				and board
				and board.isSnailProducer 
				and item
				and not item.isSnail then 
				item:changeToSnail(board.snailRoadType)
				mainLogic.snailCount = mainLogic.snailCount + 1
			end
		end
	end
end

function GameMapInitialLogic:setPreSnailRoads( mainLogic , r, c)
	-- body
	local board = mainLogic.boardmap[r][c]
	if board and board:isHasPreSnailRoad() then
		if r - 1 > 0 and mainLogic.boardmap[r-1][c] and mainLogic.boardmap[r-1][c].snailRoadType == RouteConst.kDown then
			board:setPreSnailRoad( RouteConst.kDown, r-1, c)
		elseif mainLogic.boardmap[r+1] and mainLogic.boardmap[r+1][c] and mainLogic.boardmap[r+1][c].snailRoadType == RouteConst.kUp then
			board:setPreSnailRoad( RouteConst.kUp, r+ 1, c)
		elseif c - 1 > 0 and mainLogic.boardmap[r][c -1] and mainLogic.boardmap[r][c -1].snailRoadType == RouteConst.kRight then
			board:setPreSnailRoad(RouteConst.kRight, r, c-1)
		elseif mainLogic.boardmap[r][c+1] and mainLogic.boardmap[r][c+1].snailRoadType == RouteConst.kLeft then
			board:setPreSnailRoad(RouteConst.kLeft, r, c+1)
		else
			board:setPreSnailRoad()
		end

	end
end

--为动物添加颜色、特效信息
function GameMapInitialLogic:initColorAndSpecialData(mainLogic, animalMap, numberOfColors)
	for r = 1, #mainLogic.gameItemMap do
		if mainLogic.gameItemMap[r] == nil then
			mainLogic.gameItemMap[r] = {}
		end
		for c = 1, #mainLogic.gameItemMap[r] do
			local animalDef = animalMap[r][c]
			local item = mainLogic.gameItemMap[r][c]
			item:initByAnimalDef(animalDef)
			if item.ItemType == GameItemType.kAnimal then
				if mainLogic.colortypes[item.ItemColorType] == nil then			--辅助统计颜色
					-- 当统计到的物体颜色数量超过了指定颜色数量后，其他的指定颜色不再被统计，并且不会自动生成其他颜色的物体
					if item.ItemColorType ~= 0 and table.size(mainLogic.colortypes) < numberOfColors then
						mainLogic.colortypes[item.ItemColorType] = true
					end
				end
			end
		end
	end
end

--生成传送门信息
function GameMapInitialLogic:initPortal(mainLogic, portals)
	if portals then
		for k, portPairs in pairs(portals) do
			if portPairs then
				local x1 = 0
				local y1 = 0
				local x2 = 0
				local y2 = 0
				for k,v in pairs(portPairs) do
					if k == 1 then
						x1 = v[1] + 1
						y1 = v[2] + 1
					else
						x2 = v[1] + 1
						y2 = v[2] + 1
					end
				end
				mainLogic.boardmap[y1][x1]:addPassEnterInfo(y2, x2)
				mainLogic.boardmap[y2][x2]:addPassExitInfo(y1, x1)
			end
		end
	end
end

--统计存在的颜色类型
function GameMapInitialLogic:initColorType(mainLogic, numColorsFromConfig)
	if numColorsFromConfig then
		mainLogic.numberOfColors = numColorsFromConfig
	end

	local colorsize = 0
	for k,v in pairs(mainLogic.colortypes) do
		colorsize = colorsize + 1
	end
	-----------补足颜色------
	if mainLogic.numberOfColors > 6 then mainLogic.numberOfColors = 6 end
	if colorsize < mainLogic.numberOfColors then	--颜色数量不够，进行补充
		local ts = mainLogic.numberOfColors - colorsize
		repeat
			local trycolor = mainLogic.randFactory:rand(1,6)
			if mainLogic.colortypes[trycolor] == nil then
				mainLogic.colortypes[trycolor] = true
				ts = ts - 1
			end
		until ts <= 0
	end

	for k, v in pairs(mainLogic.colortypes) do
		table.insert(mainLogic.mapColorList, k)
	end
end

function GameMapInitialLogic:initDigTileMap(mainLogic, config)
	if mainLogic.theGamePlayType == GamePlayType.kDigMove 
		or mainLogic.theGamePlayType == GamePlayType.kDigTime 
		or mainLogic.theGamePlayType == GamePlayType.kDigMoveEndless
		or mainLogic.theGamePlayType == GamePlayType.kMaydayEndless
		or mainLogic.theGamePlayType == GamePlayType.kHalloween
		then
		mainLogic.digItemMap = {}
		mainLogic.digBoardMap = {}
		local animalMap = config.animalMap
		local normalTileRow = 9
		for r = 1, #config.digTileMap do
			local realR = r + normalTileRow
			if mainLogic.gameItemMap[realR] == nil then mainLogic.gameItemMap[realR] = {} end
			if mainLogic.boardmap[realR] == nil then mainLogic.boardmap[realR] = {} end
			if mainLogic.digItemMap[r] == nil then mainLogic.digItemMap[r] = {} end
			if mainLogic.digBoardMap[r] == nil then mainLogic.digBoardMap[r] = {} end
			for c = 1, #config.digTileMap[r] do
				local tileDef = config.digTileMap[r][c]
				local animalDef = animalMap[realR][c]
				local item = GameItemData:create()
				item:initByConfig(tileDef)
				item:initByAnimalDef(animalDef)
				item:initBalloonConfig(mainLogic.balloonFrom)
				item:initAddMoveConfig(mainLogic.addMoveBase)
				item:initAddTimeConfig(mainLogic.addTime)
				mainLogic.gameItemMap[realR][c] = item
				mainLogic.digItemMap[r][c] = item

				local board = GameBoardData:create()
				board:initByConfig(tileDef)
				mainLogic.boardmap[realR][c] = board
				mainLogic.digBoardMap[r][c] = board
			end
		end
	end
end

--开始随机生成颜色
function GameMapInitialLogic:calculateItemColors(mainLogic, config)
	--挖地模式下，需要将屏幕之外的地格也计算在内
	if mainLogic.theGamePlayType == GamePlayType.kDigMove 
		or mainLogic.theGamePlayType == GamePlayType.kDigTime 
		or mainLogic.theGamePlayType == GamePlayType.kDigMoveEndless
		or mainLogic.theGamePlayType == GamePlayType.kMaydayEndless
		or mainLogic.theGamePlayType == GamePlayType.kHalloween
		then
		local normalTileRow = 9
		self:_calculateItemColors(mainLogic, config.animalMap, normalTileRow)

		for r = 1, #mainLogic.gameItemMap do
			if r > normalTileRow then
				mainLogic.gameItemMap[r] = nil
				mainLogic.boardmap[r] = nil
			end
		end
		mainLogic.swapHelpMap = nil
	else
		self:_calculateItemColors(mainLogic, config.animalMap)
	end
end

function GameMapInitialLogic:_calculateItemColors(mainLogic, animalMap, possibleMoveRowLimit)
	local function resetColors()
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				if mainLogic.gameItemMap[r][c]:isColorful() 
					and mainLogic.gameItemMap[r][c].ItemType ~= GameItemType.kMagicLamp
					and mainLogic.gameItemMap[r][c].ItemType ~= GameItemType.kBottleBlocker then
					mainLogic.gameItemMap[r][c].ItemColorType = AnimalTypeConfig.getType(animalMap[r][c])
				end
			end
		end
	end

	local function randomSetColors()
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				local success = self:randomSetColor(mainLogic, r, c)
				if not success then
					return false
				end 
			end
		end
		return true
	end

	for i = 1, 10000 do
		-- ensure no match
		resetColors()	
		local success = randomSetColors()
		
		-- ensure possbile moves generating match 
		if success and not RefreshItemLogic:checkNeedRefresh(mainLogic, possibleMoveRowLimit) then
			break
		end
	end
end

--判断item的block状态
function GameMapInitialLogic:checkItemBlock(mainLogic)
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			mainLogic:checkItemBlock(r,c)
		end
	end
	mainLogic:updateFallingAndBlockStatus()
end

--记录金豆荚生成口
function GameMapInitialLogic:initIngredientProducer(mainLogic)
	mainLogic.ingredientsProductDropList = {}
	for r = 1, #mainLogic.boardmap do
		for c = 1, #mainLogic.boardmap[r] do
			if mainLogic.boardmap[r][c].isProducer == true then
				if table.exist(mainLogic.boardmap[r][c].theGameBoardFallType, GameBoardFallType.kCannonAll)
					or table.exist(mainLogic.boardmap[r][c].theGameBoardFallType, GameBoardFallType.kCannonIngredient) 
					then
					table.insert(mainLogic.ingredientsProductDropList, mainLogic.boardmap[r][c])
				end
			end
		end
	end
end

--尝试为一个物体随机一个颜色
function GameMapInitialLogic:randomSetColor(mainLogic, r, c)
	local success = true
	if mainLogic.gameItemMap[r][c] ~= nil then
		if mainLogic.gameItemMap[r][c]:isColorful() then 			--可以随机颜色的物体
			if mainLogic.gameItemMap[r][c].ItemColorType == AnimalTypeConfig.kRandom 			--随机类型
				and mainLogic.gameItemMap[r][c].ItemSpecialType ~= AnimalTypeConfig.kColor then	
				local color = 0
				local counter = 0
				while true do 
					color = mainLogic:randomColor()
					local ret = mainLogic:checkMatchQuick(r, c, color)
					if not ret then break end
					counter = counter + 1
					if counter > 100 then 
						success = false
						break 
					end
				end
				mainLogic.gameItemMap[r][c].ItemColorType = color
			end
		end
	end
	return success
end

function GameMapInitialLogic:getPossibleColorsForItem(mainLogic, r, c)
	local result = {}
	for k, v in pairs(mainLogic.mapColorList) do 
		if not mainLogic:checkMatchQuick(r, c, v) then
			table.insert(result, v)
		end
	end
	return result
end

local _magicLampColorPool = {}
local function initMagicLampColorPool(mainLogic)
	local tmp = {}
	_magicLampColorPool = {}
	for k, v in pairs(mainLogic.mapColorList) do 
		table.insert(tmp, v)
	end
	local tmp2 = {}
	while #tmp > 0 do
		local selector = mainLogic.randFactory:rand(1, #tmp)
		table.insert(tmp2, tmp[selector])
		table.remove(tmp, selector)
	end
	for i=1, 2 do
		for k, v in pairs(tmp2) do
			table.insert(_magicLampColorPool, v)
		end
	end
end
function GameMapInitialLogic:getColorForMagicLamp(mainLogic)
	if #_magicLampColorPool == 0 then
		initMagicLampColorPool(mainLogic)
	end

	local size = #_magicLampColorPool
	local color = _magicLampColorPool[size]
	_magicLampColorPool[size] = nil
	return color
end

function GameMapInitialLogic:initMagicLamp(mainLogic)
	local localMagicLampItems = {}

	local function randomizeTable(table)
		local size = #table
		local function swapInTable(table, i, j)
			local t = table[i]
			table[i] = table[j]
			table[j] = t
		end
		for i = 1, size do
			swapInTable(table, 1, mainLogic.randFactory:rand(1, size))
		end
	end

	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item then
				if item.ItemType == GameItemType.kMagicLamp then
					local possibleColors = GameMapInitialLogic:getPossibleColorsForItem(mainLogic, r, c)
					randomizeTable(possibleColors)
					local queueItem = {item = item, possibleColors = possibleColors, currentIndex = 1, r = r, c = c}
					table.insert(localMagicLampItems, queueItem)
				end
			end
		end
	end

	if #localMagicLampItems > #mainLogic.mapColorList * 2 then
		assert(false, 'magic lamp config error')
		return
	end

	if #localMagicLampItems == 0 then
		return 
	end

	local function sort(v1, v2)
		return #v1.possibleColors < #v2.possibleColors
	end

	-- possibleColor越少，处理优先级越高
	table.sort(localMagicLampItems, sort)

	local counter = 0
	local maxTimes = 1
	for k, v in pairs(localMagicLampItems) do
		maxTimes = maxTimes * #v.possibleColors
	end

	local function getNextCombination()
		
		counter = counter + 1
		if counter > maxTimes then
			return nil
		end

		local index = 1
		local combination = {}
		for k, v in pairs(localMagicLampItems) do
			table.insert(combination, v.possibleColors[v.currentIndex])
		end
		localMagicLampItems[index].currentIndex = localMagicLampItems[index].currentIndex + 1 -- current item++
		while localMagicLampItems[index].currentIndex > #localMagicLampItems[index].possibleColors do -- indent
			local next = localMagicLampItems[index + 1]
			if next then
				next.currentIndex = next.currentIndex + 1
				localMagicLampItems[index].currentIndex = 1
				index = index + 1
			else
				localMagicLampItems[index].currentIndex = localMagicLampItems[index].currentIndex - 1 --恢复
			end
		end
		return combination
	end

	local function isLegal(combination)
		local colorStats = {}
		for k, v in pairs(combination) do 
			if not colorStats[v] then
				colorStats[v] = 0
			end
			colorStats[v] = colorStats[v] + 1
		end
		for k, v in pairs(colorStats) do 
			if v > 2 then 
				return false
			end
		end
		return true
	end

	local function hasMatch(combination)
		local hasMatch = false
		for i = 1, #combination do
			localMagicLampItems[i].item.ItemColorType = combination[i]
		end
		local hasMatch = false
		for k, v in pairs(localMagicLampItems) do
			if mainLogic:checkMatchQuick(v.r, v.c, v.item.ItemColorType) then
				hasMatch = true
				break
			end
		end
		return hasMatch
	end

	local result = getNextCombination()
	while result do
		if not isLegal(result) or hasMatch(result) then
			result = getNextCombination()
		else
			break
		end
	end
end

-------------------------------------------------

function GameMapInitialLogic:initBottleBlocker(mainLogic)
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item then
				if item.ItemType == GameItemType.kBottleBlocker then
					item.ItemColorType = GameExtandPlayLogic:randomBottleBlockerColor(mainLogic, r, c)
				end
			end
		end
	end
end

----------------------------------
--初始化传送带
----------------------------------
function GameMapInitialLogic:initTransmission(mainLogic, config)
	if not config.trans or #config.trans == 0 then return end 
	for k, v in pairs(config.trans) do 


		local transItem = BaseTransmission:create(tostring(v)):getHeadTrans()
		while (transItem ~= nil) do
			local start = transItem:getStart()
			local length = transItem:getTransLength()
			local direction = transItem:getDirection()

			local dx, dy = 0, 0
			if direction == TransmissionDirection.kLeft then
				dy = -1
			elseif direction == TransmissionDirection.kRight then 
				dy = 1
			elseif direction == TransmissionDirection.kUp then
				dx = -1
			else
				dx = 1
			end 

			for k = 1, length do 
				local type_trans = transItem:getTransTypeByIndex(k)
				local link = transItem:getLinkPositionByIndex(k)
				local color = 0				
				if not transItem:hasCercle() then
					if transItem:isHeadTrans() and k == 1 then
						color = transItem:getStartType()
					elseif transItem:isEndTrans() and k == length then
						color = transItem:getHeadTrans():getEndType()
					end
				end
				print('setting:', 'X', start.x + dx * (k-1), 'Y', start.y + dy * (k-1),'TYPE', type_trans, 'DIRECTION', direction, 'COLOR', color, 'LINK', link.x, link.y)
				mainLogic.boardmap[start.x + dx * (k-1)][start.y + dy * (k-1)]:setTransmissionConfig(type_trans, direction, color, link)
			end
			transItem = transItem:getNextTrans()
		end
	end
end