

ProductItemLogic = class{}

function ProductItemLogic:init(mainLogic, config)
	mainLogic.ingredientsMoveCount = 0
	mainLogic.ingredientSpawnDensity = config.ingredientSpawnDensity
	if not mainLogic.ingredientSpawnDensity then
		mainLogic.ingredientSpawnDensity = 5
	end
	mainLogic.ingredientsShouldCome = false
	mainLogic.ingredientsTotalCount = mainLogic.ingredientsTotal - config.numIngredientsOnScreen

	mainLogic.snailCount = mainLogic.snailCount or 0
	mainLogic.snailMoveCount = 0
	mainLogic.snailSpawnDensity = config.snailMoveToAdd
	mainLogic.snailTotalCount = mainLogic:getSnailTotalCount()

	mainLogic.blockProductRules = {};
	-------------------------------
	--crystal, balloon, coin, black_cute_ball
	--todo gift
	----------------------------------
	for __, v in pairs(config.dropRules) do
		local itemType
		if v.itemID == TileConst.kCrystal - 1 then
			itemType = GameItemType.kCrystal 
		elseif v.itemID == TileConst.kBalloon - 1 then
			itemType = GameItemType.kBalloon 
		elseif v.itemID == TileConst.kCoin - 1 then
			itemType = GameItemType.kCoin
		elseif v.itemID == TileConst.kBlackCute -1 then
			itemType = GameItemType.kBlackCuteBall
		elseif v.itemID == TileConst.kHoneyBottle - 1 then
			itemType = GameItemType.kHoneyBottle
		elseif v.itemID == TileConst.kAddTime - 1 then
			itemType = GameItemType.kAddTime
		elseif v.itemID == TileConst.kQuestionMark - 1 then
			itemType = GameItemType.kQuestionMark
		end

		if itemType then 
			ProductItemLogic:initBlock(mainLogic, v, itemType)
		end
	end

	ProductItemLogic:initRabbitProducer(mainLogic)
end

function ProductItemLogic:initRabbitProducer(mainLogic)
	local producers = {}
	for r = 1, #mainLogic.boardmap do 
		for c = 1, #mainLogic.boardmap[r] do 
			local board = mainLogic.boardmap[r][c]
			if board and board.isRabbitProducer then
				table.insert(producers, {r = r, c = c})
			end
		end
	end
	mainLogic.rabbitProducers = producers
end

function ProductItemLogic:initBlock(mainLogic, config, itemType)
	local blockRule = {}
	blockRule.blockProductType = config.ruleType
	blockRule.itemID = config.itemID
	blockRule.blockMoveCount = 0
	blockRule.blockMoveTarget = 0
	blockRule.blockShouldCome = false
	blockRule.itemType = itemType
	
	if config.ruleType == 1 then 
		blockRule.blockMoveTarget = config.thresholdSteps
		blockRule.blockSpawnDensity = config.dropNum or 1
		blockRule.blockSpawned = blockRule.blockSpawnDensity
		blockRule.maxNum = config.maxNum or 0
		blockRule.dropNumLimit = config.dropTotalNum or 0
		blockRule.totalDroppedNum = 0
	elseif config.ruleType == 2 then
		blockRule.blockSpawnDensity = config.thresholdSteps
		blockRule.dropNumLimit = config.dropTotalNum or 0
		blockRule.totalDroppedNum = 0
	end
	table.insert( mainLogic.blockProductRules, blockRule )
end

function ProductItemLogic:product(mainLogic, r, c)
	if not mainLogic.boardmap[r][c].isProducer then return nil end
	
	local theGameBoardFallType = mainLogic.boardmap[r][c].theGameBoardFallType
	


	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonIngredient) then
		local res = ProductItemLogic:productIngredient(mainLogic)
		if res then return res end 
	end

	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonBlock) then
		local res = ProductItemLogic:productBlock(mainLogic)
		if res then return res end 
	end

	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonAll) then
		local res = ProductItemLogic:productIngredient(mainLogic)
		if not res then res = ProductItemLogic:productBlock(mainLogic) end
		if res then return res end 
	end

	local res = nil
	if mainLogic.theGamePlayType == GamePlayType.kClassic then
		res = ProductItemLogic:productAddTimeAnimal(mainLogic)
	end
	if not res then res = ProductItemLogic:productAnimal(mainLogic) end
	return res
end

function ProductItemLogic:productRabbit(mainLogic, count, callback, isInit)
	if not mainLogic.rabbitProducers then 
		ProductItemLogic:initRabbitProducer(mainLogic)
	end

	------------    helper functions    --------------
	local function isAnimalOrCrystal(item)
		return item.ItemType == GameItemType.kAnimal 
		and item.ItemSpecialType == 0 
		or item.ItemType == GameItemType.kCrystal
	end

	local function isSpecialItem(item)
		return item.ItemType == GameItemType.kAnimal 
		and item.ItemSpecialType ~= 0 
		and item.ItemSpecialType ~= AnimalTypeConfig.kColor
	end

	local function isBirdItem(item)
		return item.ItemType == GameItemType.kAnimal 
		and item.ItemSpecialType == AnimalTypeConfig.kColor
	end

	local function getShiftToPosition(pos)
		local top, topL, topR, topTop
		local shiftToPos = nil
		top = mainLogic.gameItemMap[pos.r-1][pos.c]
		topL = mainLogic.gameItemMap[pos.r-1][pos.c-1]
		topR = mainLogic.gameItemMap[pos.r-1][pos.c+1]
		topTop = mainLogic.gameItemMap[pos.r-2][pos.c]
		local function __canShiftTo(item)
			if not item then return false end
			-- print(item.x, item.y, item.ItemType, GameItemType.kAnimal, item.ItemSpecialType, AnimalTypeConfig.kColor)
			if item.isEmpty or (item.ItemType == GameItemType.kAnimal and item.ItemSpecialType == AnimalTypeConfig.kColor)
			or item.isBlock or item.ItemType == GameItemType.kRabbit then
				return false
			else 
				local board = mainLogic.boardmap[item.y][item.x]
				if board and board.isRabbitProducer then
					return false
				end
			end
			return true
		end

		if __canShiftTo(top) then
			shiftToPos = {r = pos.r-1, c = pos.c}
		elseif __canShiftTo(topL) then
			shiftToPos = {r = pos.r-1, c = pos.c-1}
		elseif __canShiftTo(topR) then
			shiftToPos = {r = pos.r-1, c = pos.c+1}
		elseif __canShiftTo(topTop) then
			shiftToPos = {r = pos.r-2, c = pos.c}
		end
		return shiftToPos
	end

	local function getColorForRabbit(r, c)
		local item = mainLogic.gameItemMap[r][c]
		if item.ItemColorType and item.ItemColorType > 0 then
			return item.ItemColorType
		else
			local function randomColor( mainLogic, r, c )
				local colorList = mainLogic.mapColorList
				local selectColorList = {}
				for k, v in pairs(colorList) do 
					if not mainLogic:checkMatchQuick(r, c, v) then 
						table.insert(selectColorList, v)
					end
				end
				if #selectColorList > 0 then
					return selectColorList[mainLogic.randFactory:rand(1,#selectColorList)]
				else
					return colorList[1]
				end
			end
			return randomColor(mainLogic, r, c)
		end
	end

	local function produceRabbitDirect(rabbitPos, shiftToPos, color, level)
		-- produce rabbit
		local item = mainLogic.gameItemMap[rabbitPos.r][rabbitPos.c]
		item:changeToRabbit(color, level)
		item:changeRabbitState(GameItemRabbitState.kSpawn)
		item.isNeedUpdate = true

		-- shift item elsewhere
		if shiftToPos then
			local ox = mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c].x
			local oy = mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c].y
			mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c] = mainLogic.gameItemMap[rabbitPos.r][rabbitPos.c]:copy()
			mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c].isNeedUpdate = true
			mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c].x = ox
			mainLogic.gameItemMap[shiftToPos.r][shiftToPos.c].y = oy
		end
	end

	--------------------------------------------------------

	local animal = {}
	local special = {}
	local birds = {}

	for k, v in pairs(mainLogic.rabbitProducers) do 
		local item = mainLogic.gameItemMap[v.r][v.c]
		if isAnimalOrCrystal(item) then
			table.insert(animal, {r = v.r, c = v.c})
		elseif isSpecialItem(item) then
			table.insert(special, {r = v.r, c = v.c})
		elseif isBirdItem(item) then
			table.insert(birds, {r = v.r, c = v.c})
		end
	end

	-- print('#animal', #animal, '#special', #special, '#birds', #birds)

	local genCount = 0
	for i = 1, count do 
		local rabbitPos, shiftToPos
		if #animal > 0 then
			local selector = mainLogic.randFactory:rand(1, #animal)
			rabbitPos = animal[selector]
			table.remove(animal, selector)
		elseif #special > 0 then
			local selector = mainLogic.randFactory:rand(1, #special)
			rabbitPos = special[selector]
			table.remove(special, selector)
		elseif #birds > 0 then
			local selector = mainLogic.randFactory:rand(1, #birds)
			rabbitPos = birds[selector]
			table.remove(birds, selector)

			-- 如果可能，把鸟移到别处
			shiftToPos = getShiftToPosition(rabbitPos)
		end
		
		if rabbitPos then
			genCount = genCount + 1
			
			print('rabbitPos', rabbitPos.r, rabbitPos.c, 'shiftToPos', shiftToPos and shiftToPos.r or 'nil', shiftToPos and shiftToPos.c or 'nil')

			local rabbitColor = getColorForRabbit(rabbitPos.r, rabbitPos.c)
			local rabbitLevel = mainLogic.gameMode:isDoubleRabbitStage() and 2 or 1

			if isInit then
				produceRabbitDirect(rabbitPos, shiftToPos, rabbitColor, rabbitLevel)
			else
				local action = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Rabbit_Product,
					rabbitPos,
					shiftToPos,
					GamePlayConfig_MaxAction_time
					)
				action.completeCallback = callback
				action.color = rabbitColor
				action.level = rabbitLevel
				mainLogic:addGameAction(action)	
			end
		end
	end

	return genCount
end

function ProductItemLogic:productSnail( mainLogic , callback)
	-- body
	if mainLogic.snailCount < mainLogic.snailTotalCount  and 
		(mainLogic.snailMoveCount > mainLogic.snailSpawnDensity or mainLogic:getSnailOnScreenCount() == 0) then 
		local spailSpawnList_1 = {}
		local spailSpawnList_2 = {}
		for r = 1, #mainLogic.boardmap do 
			for c = 1, #mainLogic.boardmap[r] do 
				local board = mainLogic.boardmap[r][c]
				if board.isSnailProducer then 
					local item = mainLogic.gameItemMap[r][c]
					if item and (item.ItemType == GameItemType.kAnimal or item.ItemType == GameItemType.kCrystal) and item:isAvailable() then
						local pos = IntCoord:create(r, c)
						if item.ItemSpecialType == 0 then
							table.insert(spailSpawnList_1, pos)
						else
							table.insert(spailSpawnList_2, pos)
						end
					end
				end
			end
		end

		local randomItem = spailSpawnList_1[mainLogic.randFactory:rand(1,#spailSpawnList_1)]
		if not randomItem then 
			randomItem = spailSpawnList_2[mainLogic.randFactory:rand(1,#spailSpawnList_2)]
		end

		if randomItem then 
			mainLogic.snailCount = mainLogic.snailCount + 1
			mainLogic.snailMoveCount = 0
			local action = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Snail_Product,
				randomItem,
				nil,
				GamePlayConfig_MaxAction_time
				)

			action.completeCallback = callback
			action.direction = mainLogic.boardmap[randomItem.x][randomItem.y].snailRoadType
			mainLogic:addGameAction(action)
			return 1
		end

	end
	return 0

end

function ProductItemLogic:productAnimal(mainLogic)
	local res = GameItemData:create()
	res.ItemColorType = mainLogic:randomColor()
	res.ItemType = GameItemType.kAnimal
	return res
end

function ProductItemLogic:productIngredient(mainLogic)
	if mainLogic.ingredientsCount < mainLogic.ingredientsTotal and mainLogic.ingredientsTotalCount > 0 and (mainLogic.ingredientsMoveCount >
		mainLogic.ingredientSpawnDensity or mainLogic.ingredientsShouldCome) then

		local res = GameItemData:create()
		res.ItemType = GameItemType.kIngredient
		mainLogic.ingredientsMoveCount = 0
		mainLogic.ingredientsShouldCome = false
		mainLogic.ingredientsTotalCount = mainLogic.ingredientsTotalCount - 1
		return res
	else
		return nil
	end
end

function ProductItemLogic:buildBlockData( blockRule, mainLogic)
	-- body
	local gameItemData = GameItemData:create()
	if blockRule.itemID == TileConst.kCrystal - 1 then
		gameItemData.ItemType = GameItemType.kCrystal
		gameItemData.ItemColorType = mainLogic:randomColor()

	elseif blockRule.itemID == TileConst.kBalloon - 1 then
		gameItemData.ItemType = GameItemType.kBalloon
		gameItemData.ItemColorType = mainLogic:randomColor()
		gameItemData.balloonFrom = mainLogic.balloonFrom
		gameItemData.isFromProductBalloon = true
	elseif blockRule.itemID == TileConst.kCoin - 1 then 
		gameItemData.ItemType = GameItemType.kCoin
	elseif blockRule.itemID == TileConst.kBlackCute - 1 then
		gameItemData.ItemType = GameItemType.kBlackCuteBall 
		gameItemData.blackCuteStrength = 2
	elseif blockRule.itemID == TileConst.kHoneyBottle - 1 then
		gameItemData.ItemType = GameItemType.kHoneyBottle
		gameItemData.honeyBottleLevel = 1
	elseif blockRule.itemID == TileConst.kQuestionMark - 1 then
		gameItemData.ItemType = GameItemType.kQuestionMark
		gameItemData.ItemColorType = mainLogic:randomColor()
	end

	return gameItemData
end

function ProductItemLogic:isBlockCanProduct( mainLogic,rule )
	-- body
	if rule.blockProductType == 1 then
		if rule.blockSpawned < rule.blockSpawnDensity or rule.blockMoveCount >= rule.blockMoveTarget then 
			if rule.maxNum > 0 and mainLogic:getItemAmountByItemType(rule.itemType) >= rule.maxNum 
					or rule.dropNumLimit > 0 and rule.totalDroppedNum >= rule.dropNumLimit then
				return false
			else
				return true
			end
		end
	elseif rule.blockProductType == 2 then 
		if rule.blockMoveCount > rule.blockSpawnDensity or rule.blockShouldCome then 
			if rule.dropNumLimit > 0 and rule.totalDroppedNum >= rule.dropNumLimit then
				return false
			else
				return true
			end
		end
	end
	return false
end

function ProductItemLogic:productBlock(mainLogic)
	for k,v in pairs(mainLogic.blockProductRules) do
		if v.itemType ~= GameItemType.kAddTime and ProductItemLogic:isBlockCanProduct(mainLogic, v)  then
			local res = self:buildBlockData(v, mainLogic)
			v.blockShouldCome = false
			v.blockSpawned = v.blockSpawned + 1
			v.totalDroppedNum = v.totalDroppedNum + 1
			if v.blockMoveCount >= v.blockMoveTarget then v.blockSpawned = 1 end
			if v.blockProductType == 2 or v.blockMoveCount >= v.blockMoveTarget then v.blockMoveCount = 0 end
			return res
		end
	end

end

function ProductItemLogic:productAddTimeAnimal( mainLogic )
	for k,v in pairs(mainLogic.blockProductRules) do
		if v.itemType == GameItemType.kAddTime and ProductItemLogic:isBlockCanProduct(mainLogic, v)  then
			v.blockShouldCome = false
			v.blockSpawned = v.blockSpawned + 1
			v.totalDroppedNum = v.totalDroppedNum + 1
			if v.blockMoveCount >= v.blockMoveTarget then v.blockSpawned = 1 end
			if v.blockProductType == 2 or v.blockMoveCount >= v.blockMoveTarget then v.blockMoveCount = 0 end
			
			local res = GameItemData:create()
			res.ItemColorType = mainLogic:randomColor()
			res.ItemType = GameItemType.kAddTime
			res.addTime = mainLogic.addTime or 5
			return res
		end
	end
	return nil
end

function ProductItemLogic:addStep(mainLogic)
	mainLogic.ingredientsMoveCount = mainLogic.ingredientsMoveCount + 1
	mainLogic.snailMoveCount = mainLogic.snailMoveCount + 1
	for k,v in pairs(mainLogic.blockProductRules) do
		v.blockMoveCount = v.blockMoveCount + 1
	end
end

function ProductItemLogic:resetStep(mainLogic, type)
	if type == GameItemType.kIngredient then
		mainLogic.ingredientsMoveCount = 0
	else
		for k,v in pairs(mainLogic.blockProductRules) do
			if 	(type == GameItemType.kCrystal and v.itemID == TileConst.kCrystal - 1)
				or (type == GameItemType.kCoin and v.itemID == TileConst.kCoin - 1) 
				or (type == GameItemType.kBalloon and v.itemID == TileConst.kBalloon - 1)
				or (type == GameItemType.kBlackCuteBall and v.itemID == TileConst.kBlackCute - 1)
				or (type == GameItemType.kHoneyBottle and v.itemID == TileConst.kHoneyBottle - 1 )
				or (type == GameItemType.kQuestionMark and v.itemID == TileConst.kQuestionMark - 1 ) then
					v.blockMoveCount = 0
			end
		end
	end
end

function ProductItemLogic:shoundCome(mainLogic, type)

	if type == GameItemType.kIngredient then
		mainLogic.ingredientsShouldCome = true
	end

	for k, v in pairs(mainLogic.blockProductRules) do
		if (type == GameItemType.kCrystal and v.itemID == TileConst.kCrystal - 1 )
			or (type == GameItemType.kBalloon and v.itemID == TileConst.kBalloon - 1)
			or (type == GameItemType.kCoin and v.itemID == TileConst.kCoin -1)
			or (type == GameItemType.kBlackCuteBall and v.itemID == TileConst.kBlackCute - 1)
			or (type == GameItemType.kHoneyBottle and v.itemID == TileConst.kHoneyBottle - 1) 
			or (type == GameItemType.kQuestionMark and v.itemID == TileConst.kQuestionMark - 1 ) then 

			v.blockShouldCome = true
		end

	end

end