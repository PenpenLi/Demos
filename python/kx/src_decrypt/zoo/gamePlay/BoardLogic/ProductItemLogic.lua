

ProductItemLogic = class{}
--
--产生顺序， 应包括所有可能掉落规则中存在的类型
--有专有掉落口的 cannonType = 专有掉落类型 否则就用GameBoardFallType.kNone
-- cannonId = 独立的掉落口id，没有的不写
--
local ProductRuleOrder = table.const{
	{cannonType = GameBoardFallType.kCannonTotems, itemId = TileConst.kTotems},
	{cannonType = GameBoardFallType.kCannonHoneyBottle, itemId = TileConst.kHoneyBottle}, 
	{cannonType = GameBoardFallType.kCannonBalloon, itemId = TileConst.kBalloon}, 
	{cannonType = GameBoardFallType.kNone, itemId = TileConst.kAddTime}, 
	{cannonType = GameBoardFallType.kNone, itemId = TileConst.kAddMove}, 
	{cannonType = GameBoardFallType.kCannonGreyCuteBall, itemId = TileConst.kGreyCute}, 
	{cannonType = GameBoardFallType.kCannonBrownCuteBall, itemId = TileConst.kBrownCute}, 
	{cannonType = GameBoardFallType.kCannonBlackCuteBall, itemId = TileConst.kBlackCute}, 
	{cannonType = GameBoardFallType.kCannonCoin, itemId = TileConst.kCoin}, 
	{cannonType = GameBoardFallType.kCannonCrystallBall, itemId = TileConst.kCrystal}, 
	{cannonType = GameBoardFallType.kNone, itemId = TileConst.kQuestionMark}, 
	{cannonType = GameBoardFallType.kCannonRocket, itemId = TileConst.kRocket}, 
	{cannonType = GameBoardFallType.kCannonCrystalStone, itemId = TileConst.kCrystalStone},
	{cannonType = GameBoardFallType.kCannonDrip, itemId = TileConst.kDrip},

}

local checkBlockCanProductReason = table.const{
	kSuccessByNormal = 1,
	kSuccessByMinNum = 2,
	kFailedByMoveTarget = 3,
	kFailedByBlockSpawnDensity = 4,
	kFailedByMaxNum = 5,
	kFailedByDropNumLimit = 6,
	kFailedByUnknow = 7,
}

function ProductItemLogic:getTileFallTypes(tileDef)
	local types = {}

	if tileDef:hasProperty(TileConst.kCannonAnimal)then table.insert(types, GameBoardFallType.kCannonAnimal) end	--是否是生成口	--39
	if tileDef:hasProperty(TileConst.kCannonIngredient)then table.insert(types, GameBoardFallType.kCannonIngredient) end	--是否是生成口	--40
	if tileDef:hasProperty(TileConst.kCannonBlock)then table.insert(types, GameBoardFallType.kCannonBlock) end	--是否是生成口	--41
	if tileDef:hasProperty(TileConst.kCannonCoin) then table.insert(types, GameBoardFallType.kCannonCoin) end 
	if tileDef:hasProperty(TileConst.kCannonCrystallBall) then table.insert(types, GameBoardFallType.kCannonCrystallBall) end 
	if tileDef:hasProperty(TileConst.kCannonBalloon) then table.insert(types, GameBoardFallType.kCannonBalloon) end 
	if tileDef:hasProperty(TileConst.kCannonHoneyBottle) then table.insert(types, GameBoardFallType.kCannonHoneyBottle) end 
	if tileDef:hasProperty(TileConst.kCannonGreyCuteBall) then table.insert(types, GameBoardFallType.kCannonGreyCuteBall) end 
	if tileDef:hasProperty(TileConst.kCannonBrownCuteBall) then table.insert(types, GameBoardFallType.kCannonBrownCuteBall) end 
	if tileDef:hasProperty(TileConst.kCannonBlackCuteBall) then table.insert(types, GameBoardFallType.kCannonBlackCuteBall) end 
	if tileDef:hasProperty(TileConst.kCannonRocket) then table.insert(types, GameBoardFallType.kCannonRocket) end 
	if tileDef:hasProperty(TileConst.kCannonCrystalStone) then table.insert(types, GameBoardFallType.kCannonCrystalStone) end 
	if tileDef:hasProperty(TileConst.kCannonTotems) then table.insert(types, GameBoardFallType.kCannonTotems) end 
	if tileDef:hasProperty(TileConst.kCannonDrip) then table.insert(types, GameBoardFallType.kCannonDrip) end 
	if #types <= 0 and tileDef:hasProperty(TileConst.kCannon) then table.insert(types, GameBoardFallType.kCannonAll) end	--是否是生成口	--5
	
	return types
end

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



	mainLogic.cachePool = {}
	mainLogic.productCannonCountMap = {}
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
		elseif v.itemID == TileConst.kBrownCute - 1 then
			itemType = GameItemType.kAnimal
		elseif v.itemID == TileConst.kGreyCute -1 then
			itemType = GameItemType.kAnimal
		elseif v.itemID == TileConst.kAddMove - 1 then 
			itemType = GameItemType.kAddMove
		elseif v.itemID == TileConst.kRocket - 1 then 
			itemType = GameItemType.kRocket
		elseif v.itemID == TileConst.kCrystalStone - 1 then 
			itemType = GameItemType.kCrystalStone
		elseif v.itemID == TileConst.kTotems - 1 then 
			itemType = GameItemType.kTotems
		elseif v.itemID == TileConst.kDrip - 1 then 
			itemType = GameItemType.kDrip
		end
		mainLogic.cachePool[v.itemID] = {}

		if itemType then 
			ProductItemLogic:initBlock(mainLogic, v, itemType)
		end
	end

	ProductItemLogic:initRabbitProducer(mainLogic)

	------------------------------------------
	local hasDrip = false
	if mainLogic.blockProductRules and #mainLogic.blockProductRules > 0 then
		for i = 1 , #mainLogic.blockProductRules do
			local blockRule = mainLogic.blockProductRules[i]
			print("RRR  WTF!!!!!!!!!!!!!!!!!!!!!!!!!     blockRule.itemType  " , blockRule.itemType)
			if blockRule.itemType == GameItemType.kDrip then
				hasDrip = true
				break
			end
		end
	end

	mainLogic.hasDripOnLevel = false
	if hasDrip then
		mainLogic.hasDripOnLevel = true
	end
	--------------------------------------------
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
	blockRule.blockMoveCount = 0  --当前已经走了多少步，即CurrM
	blockRule.blockMoveTarget = 0  --每走多少步触发掉落，即M
	blockRule.blockShouldCome = false
	blockRule.itemType = itemType
	
	if config.ruleType == 1 then 
		blockRule.blockMoveTarget = config.thresholdSteps                --每移动blockMoveTarget掉落
		blockRule.blockSpawnDensity = config.dropNum or 1                --每次最多掉落个数(每次触发后应该产生的个数，即N)
		blockRule.blockSpawned = 0--blockRule.blockSpawnDensity          --一次触发掉落已经产生的个数（每次触发后实际产生的个数，即currN）
		blockRule.maxNum = config.maxNum or 0                            --棋盘上最多存在的个数
		blockRule.minNum = config.minNum or 0 	
		if blockRule.minNum > blockRule.maxNum and blockRule.maxNum > 0 then blockRule.minNum = blockRule.maxNum end
		blockRule.dropNumLimit = config.dropTotalNum or 0                --掉落dropNumLimit个不再掉落（最大掉落个数，即T）
		blockRule.totalDroppedNum = 0                                    --本局已经掉落的个数（当前掉落个数）
	elseif config.ruleType == 2 then
		blockRule.blockSpawned = 0
		blockRule.maxNum = 0
		blockRule.minNum = 0
		blockRule.blockSpawnDensity = config.thresholdSteps
		blockRule.dropNumLimit = config.dropTotalNum or 0
		blockRule.totalDroppedNum = 0
	end
	table.insert( mainLogic.blockProductRules, blockRule )
end

function ProductItemLogic:product(mainLogic, r, c)
	if not mainLogic.boardmap[r][c].isProducer then return nil end
	
	local theGameBoardFallType = mainLogic.boardmap[r][c].theGameBoardFallType
	
	ProductItemLogic:updateCachePool(mainLogic)
	if not mainLogic.productCannonCountMap then
		mainLogic.productCannonCountMap = {}
	end

	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonIngredient) then
		local res = ProductItemLogic:productIngredient(mainLogic)
		if res then return res end 
	end

	for k = 1, #ProductRuleOrder do 
		local ruleItem = ProductRuleOrder[k]
		if table.exist(theGameBoardFallType, ruleItem.cannonType) then 
			local res = ProductItemLogic:productBlock(mainLogic, ruleItem.itemId - 1 , r, c)
			if res then return res end
		end
	end

	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonBlock) then
		local res = ProductItemLogic:productBlock(mainLogic , nil , r, c)
		if res then return res end 
	end

	if table.exist(theGameBoardFallType, GameBoardFallType.kCannonAll) then
		local res = ProductItemLogic:productIngredient(mainLogic)
		if not res then res = ProductItemLogic:productBlock(mainLogic , nil , r, c) end
		if res then return res end 
	end

	return ProductItemLogic:productAnimal(mainLogic)
end

function ProductItemLogic:productAnimal(mainLogic)
	local res = GameItemData:create()
	res.ItemColorType = mainLogic:randomColor()
	res.ItemType = GameItemType.kAnimal
	return res
end

function ProductItemLogic:productIngredient(mainLogic)
	if mainLogic.ingredientsCount < mainLogic.ingredientsTotal and mainLogic.ingredientsTotalCount > 0 and (mainLogic.ingredientsMoveCount >=
		mainLogic.ingredientSpawnDensity or mainLogic.ingredientsShouldCome) then

		local res = GameItemData:create()
		res.ItemType = GameItemType.kIngredient
		if mainLogic.theGamePlayType == GamePlayType.kUnlockAreaDropDown then 
			res:initUnlockAreaDropDownModeInfo()
		end
		mainLogic.ingredientsMoveCount = 0
		mainLogic.ingredientsShouldCome = false
		mainLogic.ingredientsTotalCount = mainLogic.ingredientsTotalCount - 1
		return res
	else
		return nil
	end
end

function ProductItemLogic:buildBlockData( blockRule ,mainLogic)
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
	elseif blockRule.itemID == TileConst.kAddTime - 1 then
		gameItemData.ItemColorType = mainLogic:randomColor()
		gameItemData.ItemType = GameItemType.kAddTime
		gameItemData.addTime = mainLogic.addTime or 5
	elseif blockRule.itemID == TileConst.kAddMove - 1 then 
		gameItemData.ItemColorType = mainLogic:randomColor()
		gameItemData.ItemType = GameItemType.kAddMove
		gameItemData.numAddMove = mainLogic.addMoveBase or GamePlayConfig_Add_Move_Base
	elseif blockRule.itemID == TileConst.kGreyCute - 1 then
		gameItemData.ItemType = GameItemType.kAnimal
		gameItemData.ItemColorType = mainLogic:randomColor()
		gameItemData.furballLevel = 1
		gameItemData.furballType = GameItemFurballType.kGrey
	elseif blockRule.itemID == TileConst.kBrownCute- 1 then
		gameItemData.ItemType = GameItemType.kAnimal
		gameItemData.ItemColorType = mainLogic:randomColor()
		gameItemData.furballLevel = 1
		gameItemData.furballType = GameItemFurballType.kBrown
	elseif blockRule.itemID == TileConst.kRocket- 1 then
		gameItemData.ItemType = GameItemType.kRocket
		gameItemData.ItemColorType = mainLogic:randomColor()
	elseif blockRule.itemID == TileConst.kCrystalStone - 1 then
		gameItemData.ItemType = GameItemType.kCrystalStone
		-- gameItemData.ItemColorType = mainLogic:randomCrystalStoneColor()
		gameItemData.ItemColorType = mainLogic:randomSingleDropColor(TileConst.kCrystalStone)
	elseif blockRule.itemID == TileConst.kTotems - 1 then
		gameItemData.ItemType = GameItemType.kTotems
		gameItemData.ItemColorType = mainLogic:randomSingleDropColor(TileConst.kTotems)
	elseif blockRule.itemID == TileConst.kDrip - 1 then
		gameItemData.ItemType = GameItemType.kDrip
		gameItemData.ItemColorType = AnimalTypeConfig.kDrip
		gameItemData.dripState = DripState.kNormal
	end

	return gameItemData
end

function ProductItemLogic:getItemAmountByItemType( rule , mainLogic )
	-- body
	local boardAmout = 0
	if rule.itemID == TileConst.kBrownCute - 1 then 
		boardAmout = mainLogic:getFurballAmout(GameItemFurballType.kBrown)
	elseif rule.itemID == TileConst.kGreyCute - 1 then 
		boardAmout = mainLogic:getFurballAmout(GameItemFurballType.kGrey)
	else
		boardAmout = mainLogic:getItemAmountByItemType(rule.itemType)
	end

	local cacheAmout = #mainLogic.cachePool[rule.itemID]

	return cacheAmout + boardAmout

end

function ProductItemLogic:isBlockCanProduct( mainLogic,rule )
	
	local resultNum , ResultReason = self:countNeedProductBlockNum(mainLogic,rule)
	local productResult = resultNum and resultNum > 0
	return productResult , resultNum , ResultReason
end

function ProductItemLogic:countNeedProductBlockNum( mainLogic,rule )
	--print("RRR   ===================ProductItemLogic:countNeedProductBlockNum===================  ")

	local resultNum = 0 
	local currAmount = ProductItemLogic:getItemAmountByItemType(rule, mainLogic)

	local function getResultNum()
		resultNum = rule.blockSpawnDensity - rule.blockSpawned
		if rule.dropNumLimit > 0 and resultNum + rule.totalDroppedNum > rule.dropNumLimit then
			resultNum = rule.dropNumLimit - rule.totalDroppedNum
		end

		if rule.maxNum > 0 and resultNum + currAmount > rule.maxNum then
			resultNum = rule.maxNum - currAmount
		end

		return resultNum
	end

	if rule.blockProductType == 1 then
		if rule.dropNumLimit > 0 and rule.totalDroppedNum >= rule.dropNumLimit  then
			return resultNum , checkBlockCanProductReason.kFailedByDropNumLimit
		end

		local isOverMaxNum = false
		if rule.maxNum > 0 and currAmount >= rule.maxNum then
			isOverMaxNum = true
		end

		local isLessThenMinNum = false
		if rule.minNum > 0 and currAmount < rule.minNum then
			isLessThenMinNum = true
		end

		if rule.blockSpawned < rule.blockSpawnDensity then
			if isOverMaxNum then
				return resultNum , checkBlockCanProductReason.kFailedByMaxNum
			else
				local r = checkBlockCanProductReason.kSuccessByNormal
				if isLessThenMinNum then
					r = checkBlockCanProductReason.kSuccessByMinNum
				elseif rule.blockMoveCount >= rule.blockMoveTarget then
					r = checkBlockCanProductReason.kSuccessByNormal
				else
					return resultNum , checkBlockCanProductReason.kFailedByMoveTarget
				end

				return getResultNum() , r
			end
		else
			return resultNum , checkBlockCanProductReason.kFailedByBlockSpawnDensity
		end

	elseif rule.blockProductType == 2 then 

		if rule.dropNumLimit > 0 and rule.totalDroppedNum >= rule.dropNumLimit  then
			return resultNum , checkBlockCanProductReason.kFailedByDropNumLimit
		end

		if rule.blockMoveCount > rule.blockSpawnDensity or rule.blockShouldCome then 
			return 1
		end
	end

	return resultNum , checkBlockCanProductReason.kFailedByUnknow
end


function ProductItemLogic:productBlock(mainLogic, ruleItmeId , r , c)

	local function addProductCannonCountMap()

		local rst = true
		if not mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ] then
			mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ] = 0
		end

		mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ] = mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ] + 1

		if mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ] > 2 then
			rst = false
		end	

		--print("RRR   +++++++++++++++  addProductCannonCountMap  +++++++++++++++++  " , r , c , ruleItmeId)
		--print("RRR   +++++++++++++++  addProductCannonCountMap  +++++++++++++++++  conut = " , mainLogic.productCannonCountMap[ tostring(r) .. "_" .. tostring(c) ])
		return rst
	end
	
	if ruleItmeId then

		if mainLogic.cachePool[ruleItmeId] and #mainLogic.cachePool[ruleItmeId] > 0  then 

			if ruleItmeId == TileConst.kDrip - 1 then
				if addProductCannonCountMap() then
					--print("RRR   Product  Drip  111")
					return table.remove(mainLogic.cachePool[ruleItmeId])
				else
					--print("RRR   Pass  Drip  111")
					return nil
				end
			else
				return table.remove(mainLogic.cachePool[ruleItmeId])
			end
		end
	else
		for k = 1, #ProductRuleOrder do 
			local itemList = mainLogic.cachePool[ProductRuleOrder[k].itemId -1]
			if itemList and #itemList > 0 then

				if ProductRuleOrder[k].itemId == TileConst.kDrip then
					if addProductCannonCountMap() then
						--print("RRR   Product  Drip  222")
						return table.remove(itemList)
					else
						--print("RRR   Pass  Drip  222")
						return nil
					end
				else
					return table.remove(itemList)
				end
			end
		end
	end
end

function ProductItemLogic:updateCachePool( mainLogic )
	for k, v in pairs(mainLogic.blockProductRules) do
		if mainLogic.cachePool[v.itemID] and #mainLogic.cachePool[v.itemID] == 0 then

			local productResult , resultNum , ResultReason = self:isBlockCanProduct(mainLogic, v)
			if productResult then
				for i=1 , resultNum do
					v.totalDroppedNum = v.totalDroppedNum + 1
					v.blockSpawned = v.blockSpawned + 1
					local res = ProductItemLogic:buildBlockData(v, mainLogic)
					table.insert(mainLogic.cachePool[v.itemID], res)
				end

				v.blockMoveCount = 0
				--v.blockSpawned = 0
				v.blockShouldCome = false
				v.needClearBlockSpawnedNextStep = true
			end

			--[[
			local canProduct = false
			local isBlockCanProductResult = false 
			local isBlockCanProductReason = checkBlockCanProductReason.kFailedByUnknow

			local function checkIsBlockCanProduct() 
				local r1 , r2 = ProductItemLogic:isBlockCanProduct(mainLogic, v)
				isBlockCanProductResult = r1
				isBlockCanProductReason = r2
				return r1
			end

			while checkIsBlockCanProduct() do 
				canProduct = true
				v.blockSpawned = v.blockSpawned + 1
				v.totalDroppedNum = v.totalDroppedNum + 1

				if isBlockCanProductReason == checkBlockCanProductReason.kSuccessByMinNum then
					v.blockMoveCount = 0
					v.blockSpawned = 0
				end
				local res = ProductItemLogic:buildBlockData(v, mainLogic)
				table.insert(mainLogic.cachePool[v.itemID], res)
			end

			if canProduct then 
				v.blockShouldCome = false
				if v.blockMoveCount >= v.blockMoveTarget then v.blockSpawned = 0 end
				if v.blockProductType == 2 or v.blockMoveCount >= v.blockMoveTarget then v.blockMoveCount = 0 end
			end
			]]
		end
	end
end


function ProductItemLogic:addStep(mainLogic)
	mainLogic.ingredientsMoveCount = mainLogic.ingredientsMoveCount + 1
	mainLogic.snailMoveCount = mainLogic.snailMoveCount + 1
	for k,v in pairs(mainLogic.blockProductRules) do
		v.blockMoveCount = v.blockMoveCount + 1
		if v.needClearBlockSpawnedNextStep then
			v.needClearBlockSpawnedNextStep = false
			v.blockSpawned = 0
		end
	end

	--print("RRR   +++++++++++++++  ProductItemLogic:addStep  +++++++++++++++++  " , table.tostring(mainLogic.productCannonCountMap) )
	mainLogic.productCannonCountMap = {}
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
	--print("RRR   +++++++++++++++  ProductItemLogic:resetStep  +++++++++++++++++  " , table.tostring(mainLogic.productCannonCountMap) )
	mainLogic.productCannonCountMap = {}
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
		if item.ItemColorType and AnimalTypeConfig.isColorTypeValid(item.ItemColorType) then
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
		(mainLogic.snailMoveCount >= mainLogic.snailSpawnDensity or mainLogic:getSnailOnScreenCount() == 0) then 
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