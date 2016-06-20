GameExtandPlayLogic = class{}

-----返回true，成功发起颜色变化
function GameExtandPlayLogic:checkCrystalChangeColor(mainLogic, completeCallback)
	local ret = 0
	local crystalBalls = self:filterItemByConditions(mainLogic, { gameItemTypeList = { GameItemType.kCrystal } , lotusLevelLess = 2 })
	local colorList = mainLogic.mapColorList
	local originColorMatrix = {}
	local failColorMatrix = {}
	for r = 1, #mainLogic.gameItemMap do
		originColorMatrix[r] = {}
		failColorMatrix[r] = {}
		for c = 1, #mainLogic.gameItemMap[r] do
			originColorMatrix[r][c] = mainLogic.gameItemMap[r][c].ItemColorType
			failColorMatrix[r][c] = mainLogic.gameItemMap[r][c].ItemColorType
		end
	end
	
	if #crystalBalls == 0 then
		return 0
	end

	local function getPossibleChangeColor(itemColor)
		local result = {}
		for i, v in ipairs(colorList) do
			if v ~= itemColor then
				table.insert(result, v)
			end
		end
		return result
	end

	local function checkHasMatchQuick()
		for i, item in ipairs(crystalBalls) do
			if mainLogic:checkMatchQuick(item.y, item.x, item.ItemColorType) then
				return true
			end
		end
		return false
	end

	local retryTimes = 0
	local cloneFlag = false
	local success = false 
	local hasCrystalItemInSwapArea = nil
	local possibleComposition = {}
	local numTotalPosssibleComposition = nil

	local function getTotalPossibleComposition()
		if not numTotalPosssibleComposition then
			numTotalPosssibleComposition = 1
			for i, item in ipairs(crystalBalls) do
				local possibleColor = getPossibleChangeColor(originColorMatrix[item.y][item.x])
				numTotalPosssibleComposition = numTotalPosssibleComposition * (#possibleColor > 0 and #possibleColor or 1)
			end
		end
		return numTotalPosssibleComposition
	end

	local function isCompositionEqual(compA, compB)
		if #compA ~= #compB then return false end
		for i, c in ipairs(compA) do
			if c ~= compB[i] then return false end
		end
		return true
	end

	local function isCompositionDuplicate(composition)
		for _, compoEle in ipairs(possibleComposition) do
			if isCompositionEqual(compoEle, composition) then
				return true
			end
		end
		table.insert(possibleComposition, composition)
		return false
	end

	while retryTimes < 500 do
		if #possibleComposition >= getTotalPossibleComposition() then
			success = false
			break
		end
		retryTimes = retryTimes + 1

		-- 对选择的颜色结果进行查重，重复的组合不再重复计算
		repeat
			local composition = {}
			for i, item in ipairs(crystalBalls) do
				local possibleColor = getPossibleChangeColor(originColorMatrix[item.y][item.x])
				
				if #possibleColor > 0 then
					local index = mainLogic.randFactory:rand(1, #possibleColor)
					item.ItemColorType = possibleColor[index]
				end
				table.insert(composition, item.ItemColorType)
			end
		until not isCompositionDuplicate(composition)
		
		if not checkHasMatchQuick() then
			if not cloneFlag then
				cloneFlag = true
				for r = 1, #mainLogic.gameItemMap do
					for c = 1, #mainLogic.gameItemMap[r] do
						failColorMatrix[r][c] = mainLogic.gameItemMap[r][c].ItemColorType
					end
				end
			end
			
			if not RefreshItemLogic:checkNeedRefresh(mainLogic) then
				success = true
				break
			elseif hasCrystalItemInSwapArea == nil then -- 对于无法参与匹配计算的水晶球，无需强求组成possibleSwap
				hasCrystalItemInSwapArea = false
				for i, item in ipairs(crystalBalls) do
					local isSwapAreaValid = RefreshItemLogic.isItemSwapAreaValid(mainLogic, item.y, item.x)
					if isSwapAreaValid then hasCrystalItemInSwapArea = true end
				end
				-- print(hasCrystalItemInSwapArea)
				if not hasCrystalItemInSwapArea then
					success = true
					break
				end
			end
		end
	end
	-- print("success : ", success, "retryTimes : ", retryTimes)

	for i, item in ipairs(crystalBalls) do

		local theAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,				--动作发起主体	
			GameItemActionType.kItem_Crystal_Change,			--动作类型	    
			IntCoord:create(item.y, item.x),								--动作物体1		
			nil,												--动作物体2		
			GamePlayConfig_CrystalChange_time)					--动作持续时间	
		local targetColor = nil
		if success then
			targetColor = item.ItemColorType
		else
			targetColor = failColorMatrix[item.y][item.x]
		end
		theAction.addInt = targetColor
		theAction.callback = completeCallback
		mainLogic:addGameAction(theAction)

		item.ItemColorType = originColorMatrix[item.y][item.x]
		ret = ret + 1
	end

	return ret
end

function GameExtandPlayLogic:checkVenomSpread(mainLogic, completeCallback)
	local aroundDirections = {
		{ x = -1, y = 0 }, 
		{ x = 1, y = 0 }, 
		{ x = 0, y = -1 }, 
		{ x = 0, y = 1 }
	}

	local function getItemAt(r, c)
		if mainLogic.gameItemMap[r] then
			return mainLogic.gameItemMap[r][c]
		end
		return nil
	end

	local function calculateItemAroundVenom(venom, positionMap)
		local item = nil
		local board = nil
		
		for k, v in ipairs(aroundDirections) do
			item = getItemAt(v.y + venom.y, v.x + venom.x)

			if item and (not item:hasLock()) and not item:hasFurball() 
				and (item.ItemType == GameItemType.kAnimal
					or item.ItemType == GameItemType.kAddTime
					or item.ItemType == GameItemType.kGift 
					or item.ItemType == GameItemType.kCrystal) 
				and not mainLogic:hasChainInNeighbors(venom.y, venom.x, v.y + venom.y, v.x + venom.x)
				then

				if not positionMap[item.x .. "_" .. item.y] then
					positionMap[item.x .. "_" .. item.y] = { venom = venom, item = item, dir = v }
				end
			end
		end
	end

	local function poisonedPrioritySorter(pre, next)
		if pre.item.y == next.item.y then
			return pre.item.x < next.item.x
		else
			return pre.item.y < next.item.y
		end
	end

	local POISONED_ITEM_PRIORITY_NORMAL = 1
	local POISONED_ITEM_PRIORITY_SPECIAL = 2
	local POISONED_ITEM_PRIORITY_LIST = { POISONED_ITEM_PRIORITY_SPECIAL, POISONED_ITEM_PRIORITY_NORMAL }

	local function calculatePossiblePoisonedPairs()
		local positionItemMap = {}
		local possiblePoisonedItemGroup = {}
		local item = nil
		
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				item = getItemAt(r, c)
				if item:isAvailable() and (item.ItemType == GameItemType.kVenom or item.ItemType == GameItemType.kPoisonBottle)  then
					calculateItemAroundVenom(item, positionItemMap)
				end 
			end
		end

		for k, v in ipairs(POISONED_ITEM_PRIORITY_LIST) do
			possiblePoisonedItemGroup[v] = {}
		end
		
		for k, v in pairs(positionItemMap) do
			if v.item:isAvailable() then
				if v.item.ItemType == GameItemType.kAnimal 
					and AnimalTypeConfig.isSpecialTypeValid(v.item.ItemSpecialType)
					then
					table.insert(possiblePoisonedItemGroup[POISONED_ITEM_PRIORITY_SPECIAL], v)
				elseif v.item.ItemType == GameItemType.kAnimal 
					or v.item.ItemType == GameItemType.kCrystal
					or v.item.ItemType == GameItemType.kGift then
					table.insert(possiblePoisonedItemGroup[POISONED_ITEM_PRIORITY_NORMAL], v)
				elseif v.item.ItemType == GameItemType.kAddTime then
					table.insert(possiblePoisonedItemGroup[POISONED_ITEM_PRIORITY_SPECIAL], v)
				end 
			end
			
		end
		
		for k, v in ipairs(possiblePoisonedItemGroup) do
			table.sort(v, poisonedPrioritySorter)
		end

		return possiblePoisonedItemGroup;
	end

	local ret = false

	local possiblePoisonedPairs = calculatePossiblePoisonedPairs()
	local targetPoisonPair = nil
	local groupUnit = nil

	for k, v in ipairs(possiblePoisonedPairs) do 
		groupUnit = v
		if #groupUnit > 0 then
			local targetIndex = mainLogic.randFactory:rand(1, #groupUnit)
			targetPoisonPair = groupUnit[targetIndex]
			break
		end
	end
	
	if targetPoisonPair then
		local theAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Venom_Spread,
			IntCoord:create(targetPoisonPair.venom.y, targetPoisonPair.venom.x),
			IntCoord:create(targetPoisonPair.item.y, targetPoisonPair.item.x),
			GamePlayConfig_VenomSpread_time)
		theAction.callback = completeCallback
		theAction.itemType = targetPoisonPair.venom.ItemType
		mainLogic:addGameAction(theAction)

		local targetItem = mainLogic.gameItemMap[targetPoisonPair.item.y][targetPoisonPair.item.x]
		targetItem.isBlock = true

		ret = true
	end

	return ret
end

function GameExtandPlayLogic:checkFurballTransfer(mainLogic, completeCallback)
	local cuteballMoveHandleTotal = 0
	
	local itemsWithGreyCuteBall = GameExtandPlayLogic:filterItemByConditions(mainLogic, {furballTypeList = { GameItemFurballType.kGrey }})
	table.sort(itemsWithGreyCuteBall, GameExtandPlayLogic.itemPositionSorter)

	for i, item in ipairs(itemsWithGreyCuteBall) do
		local validAroundItems = GameExtandPlayLogic:getFurballValidAroundItems(mainLogic, item)
		local targetItem = nil
		if #validAroundItems > 0 then
			cuteballMoveHandleTotal = cuteballMoveHandleTotal + 1
			targetItem = validAroundItems[mainLogic.randFactory:rand(1, #validAroundItems)]

			targetItem:addFurball(item.furballType)
			item.furballLevel = 0
			item.furballType = GameItemFurballType.kNone

			local TransferAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Furball_Transfer,
				IntCoord:create(item.y, item.x),
				IntCoord:create(targetItem.y, targetItem.x),
				GamePlayConfig_Furball_Transfer)
			TransferAction.addInt = targetItem.furballType
			TransferAction.callback = completeCallback
			mainLogic:addGameAction(TransferAction)
		end
	end

	local itemsWithBrownCuteBall = GameExtandPlayLogic:filterItemByConditions(mainLogic, {furballTypeList = { GameItemFurballType.kBrown }})
	table.sort(itemsWithBrownCuteBall, GameExtandPlayLogic.itemPositionSorter)

	for i, item in ipairs(itemsWithBrownCuteBall) do
		if not item.isBrownFurballUnstable then
			local validAroundItems = GameExtandPlayLogic:getFurballValidAroundItems(mainLogic, item)
			local targetItem = nil
			if #validAroundItems > 0 then
				cuteballMoveHandleTotal = cuteballMoveHandleTotal + 1
				targetItem = validAroundItems[mainLogic.randFactory:rand(1, #validAroundItems)]

				targetItem:addFurball(item.furballType)
				item:removeFurball()

				local TransferAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Furball_Transfer,
					IntCoord:create(item.y, item.x),
					IntCoord:create(targetItem.y, targetItem.x),
					GamePlayConfig_Furball_Transfer)
				TransferAction.addInt = targetItem.furballType
				TransferAction.callback = completeCallback
				mainLogic:addGameAction(TransferAction)
			end
		end
	end

	return cuteballMoveHandleTotal
end

function GameExtandPlayLogic:filterItemByConditions(mainLogic, conditions)
	local function isGameItemType(item, itemTypeList)
		if not itemTypeList or #itemTypeList == 0 then
			return true
		end

		for i,v in ipairs(itemTypeList) do
			if item.ItemType == v then
				return true
			end
		end

		return false
	end

	local function isGameItemFurballType(item, furballTypeList)
		if not furballTypeList or #furballTypeList == 0 then
			return true
		end

		for i,v in ipairs(furballTypeList) do
			if item.furballLevel > 0 and item.furballType == v then
				return true
			end
		end
		return false
	end

	local function checkLotusLevelLess(item , lotusLevel)
		if not lotusLevel or not item.lotusLevel then
			return true
		end

		return item.lotusLevel <= lotusLevel
	end
	
	local ret = {}
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if isGameItemType(item, conditions.gameItemTypeList) 
				and isGameItemFurballType(item, conditions.furballTypeList)
				and checkLotusLevelLess(item, conditions.lotusLevelLess)
				and item:isAvailable()
				then
				table.insert(ret, item)
			end
		end
	end

	return ret
end

function GameExtandPlayLogic.itemPositionSorter(pre, next)
	if pre.y == next.y then
		return pre.x < next.x
	else
		return pre.y < next.y
	end
end

function GameExtandPlayLogic:getFurballValidAroundItems(mainLogic, centerItem)
	local aroundDirections = {
		{ x = -1, y = 0 }, 
		{ x = 1, y = 0 }, 
		{ x = 0, y = -1 }, 
		{ x = 0, y = 1 }
	}

	local function getItemAt(r, c)
		if mainLogic.gameItemMap[r] then
			return mainLogic.gameItemMap[r][c]
		end
		return nil
	end

	local function getBoardAt(r, c)
		if mainLogic.boardmap[r] then
			return mainLogic.boardmap[r][c]
		end
		return nil
	end

	local cx = centerItem.x
	local cy = centerItem.y

	local result = {}
	local tempItem = nil
	local tempBoard = nil
	for i, coord in ipairs(aroundDirections) do 
		tempItem = getItemAt(cy + coord.y, cx + coord.x);
		tempBoard = getBoardAt(cy + coord.y, cx + coord.x)
		if tempItem 
			and (tempItem.ItemType == GameItemType.kAnimal 
				or tempItem.ItemType == GameItemType.kGift 
				or tempItem.ItemType == GameItemType.kAddTime
				or tempItem.ItemType == GameItemType.kCrystal
				or tempItem.ItemType == GameItemType.kQuestionMark)
			and not tempItem:hasFurball()
			and not tempItem.isBlock 
			and tempItem:canBeCoverByMatch()
			and not tempBoard:hasSuperCuteBall() 
			and not mainLogic:hasChainInNeighbors(cy, cx, cy + coord.y, cx + coord.x) then
			table.insert(result, tempItem)
		end
	end

	return result
end

function GameExtandPlayLogic:checkFurballSplit(mainLogic, completeCallback)
	local cuteballSplitHandleTotal = 0
	local validAroundItems = {}
	local itemsWithBrownCuteBall = GameExtandPlayLogic:filterItemByConditions(mainLogic, {furballTypeList = { GameItemFurballType.kBrown }})
	table.sort(itemsWithBrownCuteBall, GameExtandPlayLogic.itemPositionSorter)
	
	for i, item in ipairs(itemsWithBrownCuteBall) do
		validAroundItems = GameExtandPlayLogic:getFurballValidAroundItems(mainLogic, item)
		if item.isBrownFurballUnstable then
			local targetItem = nil
			local targetPos = nil
			if #validAroundItems > 0 then
				targetItem = validAroundItems[mainLogic.randFactory:rand(1, #validAroundItems)]
				targetItem:addFurball(GameItemFurballType.kGrey)
				targetPos = IntCoord:create(targetItem.y, targetItem.x)
			end
			item:removeFurball()
			item:addFurball(GameItemFurballType.kGrey)
			
			local SplitAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Furball_Split,
				IntCoord:create(item.y, item.x),
				targetPos,
				GamePlayConfig_Furball_Split)
			SplitAction.callback = completeCallback
			mainLogic:addGameAction(SplitAction)

			cuteballSplitHandleTotal = cuteballSplitHandleTotal + 1
		end
	end
	
	return cuteballSplitHandleTotal
end

function GameExtandPlayLogic:checkRoostReplace(mainLogic, completeCallback)
	local function getPossbileReplaceItemList()
		local result = {}		
		for r = 1, #mainLogic.gameItemMap do
			for c = 1, #mainLogic.gameItemMap[r] do
				local item = mainLogic.gameItemMap[r][c]
				if item.ItemType == GameItemType.kAnimal 
					and item.ItemSpecialType == 0
					and item.ItemColorType ~= AnimalTypeConfig.kYellow
					and not item:hasLock() 
					and not item:hasFurball()
					and item:isAvailable()
					then
					table.insert(result, item)
				end
			end
		end
		return result
	end

	local totalNum = 0
	local roostList = GameExtandPlayLogic:filterItemByConditions(mainLogic, { gameItemTypeList = { GameItemType.kRoost } })
	table.sort(roostList, GameExtandPlayLogic.itemPositionSorter)
	local possibleItemList = getPossbileReplaceItemList()
	local maxReplaceNumFromConfig = mainLogic.replaceColorMaxNum
	local roostReplaceMap = {}

	for i, roost in ipairs(roostList) do
		if roost.roostLevel == 4 then
			local replaceList = {}
			local from = IntCoord:create(roost.y, roost.x)
			if #possibleItemList > 0 then
				if #possibleItemList > maxReplaceNumFromConfig then
					for counter = 1, maxReplaceNumFromConfig do
						local idx = mainLogic.randFactory:rand(1, #possibleItemList)
						local item = possibleItemList[idx]
						local to = IntCoord:create(item.y, item.x)
						table.insert(replaceList, to)
						table.remove(possibleItemList, idx)
						item.ItemColorType = AnimalTypeConfig.kYellow
					end
				else
					for counter = 1, #possibleItemList do
						local idx = mainLogic.randFactory:rand(1, #possibleItemList)
						local item = possibleItemList[idx]
						local to = IntCoord:create(item.y, item.x)
						table.insert(replaceList, to)
						table.remove(possibleItemList, idx)
						item.ItemColorType = AnimalTypeConfig.kYellow
					end
				end
			end
			roostReplaceMap[from] = replaceList
			roost:roostReset()
			totalNum = totalNum + 1
		end
	end
	
	if totalNum > 0 then
		for from, replaceItemList in pairs(roostReplaceMap) do
			local ReplaceAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Roost_Replace,
				from,
				nil,
				GamePlayConfig_Roost_Replace
			)
			ReplaceAction.itemList = replaceItemList
			ReplaceAction.callback = completeCallback
			mainLogic:addGameAction(ReplaceAction)
		end
	end
			
	return totalNum
end

function GameExtandPlayLogic:onMagicTileHit(mainLogic, r, c)
	local gameItem = mainLogic.gameItemMap[r][c]
	local boardItem = mainLogic.boardmap[r][c]

	local action = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Magic_Tile_Hit,
			IntCoord:create(r,c),
			nil,
			GamePlayConfig_MaxAction_time
		)
	if AnimalTypeConfig.isSpecialTypeValid(gameItem.ItemSpecialType) then
		action.count = mainLogic:getHalloweenBoss().specialHit
	else
		action.count = mainLogic:getHalloweenBoss().normalHit
	end
	action.magicTileId = boardItem.magicTileId
	action.magicTileIndex = boardItem.magicTileIndex
	mainLogic:addGameAction(action)

	-- 计算是否掉落限时道具 TODO
	if mainLogic.theGamePlayStatus == GamePlayStatus.kNormal then
		local boss = mainLogic:getHalloweenBoss()
		if boss and boss.hit < boss.totalBlood then -- 亲密度满后不再掉落道具
			local user = UserManager:getInstance().user
			local dropPropCount = StageInfoLocalLogic:getTotalDropPropCount( user.uid )
			local dragonBoatData = mainLogic.dragonBoatData
			if dragonBoatData and dropPropCount < 1 and mainLogic.dragonBoatPropConfig then
				dragonBoatData.dropPropsPercent = dragonBoatData.dropPropsPercent or 0

				-- 解决概率特别小的情况
				-- 虽然两次随机数不是完全独立随机事件，但是总体上只要是平均分布就行
				local possibility = dragonBoatData.dropPropsPercent / 100
				local sqrt = math.sqrt(possibility)
				local maxRange = 25000
				local targetRange = sqrt * maxRange
				local function possibilityHit()
					local firstHit = math.random(1, maxRange) < targetRange
					local secondHit = math.random(1, maxRange) < targetRange
					return firstHit and secondHit
				end

				if possibilityHit() then
					local totalWeight = mainLogic.dragonBoatPropConfig:getTotalWeight()
					local random = mainLogic.randFactory:rand(1, totalWeight)
					local randPropId = mainLogic.dragonBoatPropConfig:getRandProp(random)
					if randPropId then
						local pos = mainLogic:getGameItemPosInView(r, c)
						if mainLogic.PlayUIDelegate then
							local showText = mainLogic.dropPropText or ""
							mainLogic.PlayUIDelegate:addTimeProp(randPropId, 1, pos, mainLogic.activityId, showText)
						end
					end
				end
			end
		end
	end
end

function GameExtandPlayLogic:chargeCrystalStone(mainLogic, fr, fc, colortype)
	if mainLogic.theGamePlayStatus ~= GamePlayStatus.kNormal then
		return
	end

	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item and item.ItemType == GameItemType.kCrystalStone 
				and item.ItemColorType == colortype and item:canCrystalStoneBeCharged() then
				item:chargeCrystalStoneEnergy(GamePlayConfig_CrystalEnergy_Normal)
				-- item.isNeedUpdate = true

				local theAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemSpecial_CrystalStone_Charge,
					IntCoord:create(fr,fc), 			
					IntCoord:create(r,c),				
					GamePlayConfig_MaxAction_time
					)
				theAction.addInt1 = item.ItemColorType
				theAction.addInt2 = item:getCrystalStoneEnergy()
				mainLogic:addDestructionPlanAction(theAction)
			end
		end
	end
end

function GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
	local gameItem = mainLogic.gameItemMap[r][c]
	if mainLogic.gameMode:is(HalloweenMode) and mainLogic:getHalloweenBoss() then
		if gameItem.ItemType == GameItemType.kAnimal 
				or gameItem.ItemType == GameItemType.kAddMove
				or gameItem.ItemType == GameItemType.kAddTime
				or gameItem.ItemType == GameItemType.kGift
				or gameItem.ItemType == GameItemType.kCrystal
				or gameItem.ItemType == GameItemType.kBalloon then
			local boardItem = mainLogic.boardmap[r][c]
			if boardItem and boardItem.magicTileId ~= nil then
				GameExtandPlayLogic:onMagicTileHit(mainLogic, r, c)
			end
		end
	end

	if gameItem.ItemType == GameItemType.kAnimal then
	elseif gameItem.ItemType == GameItemType.kGift then
		GameExtandPlayLogic:bombGiftBlocker(mainLogic, r, c)
		mainLogic.hasDestroyGift = true
	elseif gameItem.ItemType == GameItemType.kCoin then
		mainLogic.coinDestroyNum = mainLogic.coinDestroyNum + 1
		mainLogic:tryDoOrderList(r,c,GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kCoin, 1)
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
	elseif gameItem.ItemType  == GameItemType.kBalloon then
		if mainLogic.theGamePlayStatus == GamePlayStatus.kNormal  then           ----只在bonus前作用有效果
			mainLogic.theCurMoves = mainLogic.theCurMoves + 5
			if mainLogic.PlayUIDelegate then
				local function callback( ... )
					mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(mainLogic.theCurMoves, false)
				end
				local pos = mainLogic:getGameItemPosInView_ForPreProp(r,c)
				local icon = Sprite:createWithSpriteFrameName("add_move_icon.png")
				local scene = Director:sharedDirector():getRunningScene()
				local animation= PrefixPropAnimation:createAddMoveAnimation(icon, 0, callback, nil, ccp(pos.x, pos.y + 100))
				scene:addChild(animation)
			end
		end
	elseif gameItem.ItemType == GameItemType.kDigJewel then
		if mainLogic.theGamePlayType == GamePlayType.kDigMove then
			mainLogic.digJewelLeftCount = mainLogic.digJewelLeftCount - 1
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelLeftCount, position)
			end
		elseif mainLogic.theGamePlayType == GamePlayType.kDigMoveEndless then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelCount:getValue(), position)
			end
		elseif mainLogic.theGamePlayType == GamePlayType.kMaydayEndless then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelCount:getValue(), position)
			end
		elseif mainLogic.theGamePlayType == GamePlayType.kHalloween then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelCount:getValue(), position)
			end
		elseif mainLogic.theGamePlayType == GamePlayType.kWukongDigEndless then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			local position = nil
			if mainLogic.PlayUIDelegate then
				position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelCount:getValue(), position)
			end
			mainLogic.gameMode:chargeByDigJewel(position)
		elseif mainLogic.theGamePlayType == GamePlayType.kHedgehogDigEndless then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			if mainLogic.gameMode:canAddEnerge() then
				mainLogic.gameMode:addEnergeCount(1)
			end
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 1, mainLogic.digJewelCount:getValue(), position, nil, nil, mainLogic.gameMode:getPercentEnerge())
			end
		end
	elseif gameItem.ItemType == GameItemType.kAddMove then
		if mainLogic.theGamePlayStatus == GamePlayStatus.kNormal then           ----只在bonus前作用有效果
			mainLogic.theCurMoves = mainLogic.theCurMoves + gameItem.numAddMove
			if mainLogic.PlayUIDelegate then
				local function callback( ... )
					mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(mainLogic.theCurMoves, false)
				end
				local pos = mainLogic:getGameItemPosInView_ForPreProp(r, c)
				local icon = TileAddMove:createAddStepIcon(gameItem.numAddMove)
				local scene = Director:sharedDirector():getRunningScene()
				local animation = PrefixPropAnimation:createAddMoveAnimation(icon, 0, callback, nil, ccp(pos.x, pos.y + 90))
				scene:addChild(animation)
			end
		end
	elseif gameItem.ItemType == GameItemType.kBlackCuteBall then 
		mainLogic:tryDoOrderList(r,c,GameItemOrderType.kOthers, GameItemOrderType_Others.kBlackCuteBall, 1)
	elseif gameItem.ItemType == GameItemType.kBoss then
		local count = gameItem.drop_sapphire
		mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + count)
		mainLogic.maydayBossCount = mainLogic.maydayBossCount + 1
		if mainLogic.PlayUIDelegate then
			local position = mainLogic:getGameItemPosInView(r, c)
			for k = 1, count do 
				mainLogic.PlayUIDelegate:setTargetNumber(0, 1, mainLogic.digJewelCount:getValue(), position)
			end
			mainLogic.PlayUIDelegate:setTargetNumber(0, 2, mainLogic.maydayBossCount, position)
		end

		
	elseif gameItem.ItemType == GameItemType.kRabbit and gameItem.rabbitState ~= GameItemRabbitState.kNoTarget then
		mainLogic.rabbitCount:setValue(mainLogic.rabbitCount:getValue() + gameItem.rabbitLevel)
		if mainLogic.PlayUIDelegate  then
			local position = mainLogic:getGameItemPosInView(r, c)
			mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.rabbitCount:getValue(), position)
		end
	elseif gameItem.ItemType == GameItemType.kAddTime then
		if mainLogic.theGamePlayStatus == GamePlayStatus.kNormal then           ----只在bonus前作用有效果
			if mainLogic.PlayUIDelegate then
				local addTime = gameItem.addTime
				mainLogic.flyingAddTime = mainLogic.flyingAddTime + 1
				local function callback( ... )
					mainLogic:addExtraTime(addTime)
					mainLogic.flyingAddTime = mainLogic.flyingAddTime - 1

					local timeLeft = mainLogic:getTotalLimitTime() - mainLogic.timeTotalUsed
					timeLeft = math.ceil(timeLeft)
					if timeLeft <= 0 then timeLeft = 0 end
					mainLogic.PlayUIDelegate:setMoveOrTimeCountCallback(timeLeft, false)
				end
				local pos = mainLogic:getGameItemPosInView_ForPreProp(r, c)
				local icon = TileAddTime:createAddTimeIcon(addTime)
				local scene = Director:sharedDirector():getRunningScene()
				local animation = PrefixPropAnimation:createAddTimeAnimation(icon, 0, callback, nil, ccp(pos.x, pos.y + 90))
				scene:addChild(animation)
			end
		end
	elseif gameItem.ItemType == GameItemType.kRocket and mainLogic.hasDropDownUFO then
		GameExtandPlayLogic:fireRocket(mainLogic, r, c, gameItem.ItemColorType)
	end	
end

function GameExtandPlayLogic:bombGiftBlocker(mainLogic, r, c)
	if mainLogic.PlayUIDelegate then
		local giftBlockerMeta = MetaManager.getInstance():getGiftBlockerByLevelId(mainLogic.level)
		if giftBlockerMeta then
			local giftItemIdList = giftBlockerMeta.prop_id
			local giftItemId = giftItemIdList[mainLogic.randFactory:rand(1, #giftItemIdList)]
			local pos = mainLogic:getGameItemPosInView(r, c)
			mainLogic.PlayUIDelegate:addTemporaryItem(giftItemId, 1, pos)
		else
			mainLogic.randFactory:rand(1, 10)
		end
	else
		mainLogic.randFactory:rand(1, 10)
	end
end

function GameExtandPlayLogic:CheckBalloonList( mainLogic, completeCallback )
	-- body
	local balloonList = {}
	local balloonTotal = 0
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do
			local itemdata = mainLogic.gameItemMap[r][c]
			if itemdata:isAvailable() and itemdata.ItemType == GameItemType.kBalloon
			and itemdata.beEffectByMimosa == 0 then
				if itemdata.isFromProductBalloon then
					itemdata.isFromProductBalloon = false
				else
					balloonTotal = balloonTotal + 1
					itemdata.balloonFrom = itemdata.balloonFrom - 1
					if itemdata.balloonFrom > 0 then
						GameExtandPlayLogic:updateBalloonStepNumber(mainLogic, r, c, completeCallback)
					else
						GameExtandPlayLogic:runAwayAllBalloon(mainLogic, r, c, completeCallback)
					end
				end
			end
		end
	end
	return balloonTotal
end

----更新气球的剩余步数
function GameExtandPlayLogic:updateBalloonStepNumber( mainLogic, r, c, completeCallback)
	-- body
	
	local balloonUpdateNumberAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Balloon_update,
				IntCoord:create(r,c),
				nil,
				GamePlayConfig_Balloon_Update_time
			)

	balloonUpdateNumberAction.numberShow = mainLogic.gameItemMap[r][c].balloonFrom
	balloonUpdateNumberAction.completeCallback = completeCallback
	mainLogic:addGameAction(balloonUpdateNumberAction)
end


--气球飞走
function GameExtandPlayLogic:runAwayAllBalloon( mainLogic, r, c, completeCallback )
	-- body
	local balloonRunAwayAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItem_balloon_runAway,
		IntCoord:create(r, c),
		nil,
		GamePlayConfig_Balloon_Runaway_time)
	
	balloonRunAwayAction.completeCallback = completeCallback
	mainLogic:addGameAction(balloonRunAwayAction)
	
end
---------------
--地块削减一层
---------------
function GameExtandPlayLogic:decreaseDigGround( mainLogic, r, c, scoreScale, noScore )
	-- body
	scoreScale = scoreScale or 1
	local item = mainLogic.gameItemMap[r][c]
	item.digGroundLevel = item.digGroundLevel - 1

	if item.digGroundLevel == 0 then
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
		item:AddItemStatus(GameItemStatusType.kDestroy)
	end

	if not noScore then
		local addScore = GamePlayConfigScore.MatchAtDigGround * scoreScale
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
	end

	 local digGroudDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_DigGroundDec,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_GameItemDigGroundDeleteAction_CD)
	 digGroudDecAction.cleanItem = item.digGroundLevel == 0 and true or false
	 mainLogic:addDestroyAction(digGroudDecAction)
end

--------------------
--宝石块削减一层
--------------------
function GameExtandPlayLogic:decreaseDigJewel( mainLogic, r, c, scoreScale, noScore, isFromSpringBomb )
	-- body
	scoreScale = scoreScale or 1
	local item = mainLogic.gameItemMap[r][c]
	item.digJewelLevel = item.digJewelLevel -1

	if item.digJewelLevel == 0 then
		if mainLogic.theGamePlayType == 12 and not isFromSpringBomb then
			mainLogic:chargeFirework(1, r, c)
		end
		SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
		item:AddItemStatus(GameItemStatusType.kDestroy)
	end

	if not noScore then
		local addScore = GamePlayConfigScore.MatchAt_DigJewel * scoreScale
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)

		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
	end
	
	local digJewelDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_DigJewleDec,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_GameItemDigJewelDeleteAction_CD)
	digJewelDecAction.cleanItem = item.digJewelLevel == 0 and true or false
	mainLogic:addDestroyAction(digJewelDecAction)
end

--------------------
--金粽子块削减一层
--------------------
function GameExtandPlayLogic:decreaseDigGoldZongZi( mainLogic, r, c, scoreScale, noScore, isFromSpringBomb )
	local item = mainLogic.gameItemMap[r][c]
	item.digGoldZongZiLevel = item.digGoldZongZiLevel -1

	if item.digGoldZongZiLevel == 0 then
		--item:AddItemStatus(GameItemStatusType.kItemHalfStable)
	end

	local digGoldZongZiDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_Gold_ZongZi_Active,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_GameItemDigJewelDeleteAction_CD)
	
	mainLogic:addDestroyAction(digGoldZongZiDecAction)

end

--function GameExtandPlayLogic:dripCasting( mainLogic, r, c, isLeader, leaderPos )
function GameExtandPlayLogic:dripCasting( mainLogic, dripList , callback )
	print("RRR   GameExtandPlayLogic:dripCasting  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	if mainLogic and dripList and #dripList > 0 then

		local countCallback = 0
		local totalCallback = 0

		local function onActivityComplete()

			countCallback = countCallback + 1
			--print("RRR   GameExtandPlayLogic:dripCasting   onActivityComplete    " , countCallback , "   totalCallback " , totalCallback)
			if countCallback >= totalCallback then
				if callback then callback() end
			end
		end
		for i = 1 , #dripList do

			local item = dripList[i]

			--print("RRR   RRR   GameExtandPlayLogic:dripCasting    dripList " , i , item.startDripCastingAction)
			if not item.startDripCastingAction then
				GameExtandPlayLogic:__dripCasting( mainLogic, item.y , item.x , onActivityComplete )
				totalCallback = totalCallback + 1
			end
			
			--[[
			local dripCastingAction = GameBoardActionDataSet:createAs(
		 		GameActionTargetType.kGameItemAction,
		 		GameItemActionType.kItem_Drip_Casting,
		 		IntCoord:create( item.y , item.x ),
		 		nil,
		 		GamePlayConfig_MaxAction_time)

			dripCastingAction.completeCallback = onActivityComplete
			
			mainLogic:addDestructionPlanAction(dripCastingAction)
			mainLogic:setNeedCheckFalling()	
			]]
		end

		

	end
end

function GameExtandPlayLogic:__dripCasting(  mainLogic, r, c , callback )
	
	local item = mainLogic.gameItemMap[r][c]
	print("RRR    GameExtandPlayLogic:__dripCasting   " , r, c , item.startDripCastingAction )
	if item.startDripCastingAction == true then
		--return
	end

	item.startDripCastingAction = true

	local dripCastingAction = GameBoardActionDataSet:createAs(
 		GameActionTargetType.kGameItemAction,
 		GameItemActionType.kItem_Drip_Casting,
 		IntCoord:create( item.y , item.x ),
 		nil,
 		GamePlayConfig_MaxAction_time)

	dripCastingAction.completeCallback = function () if callback then callback() end end
	
	if _G.test_DripMode == 2 then
		--mainLogic:addGameAction(dripCastingAction)
		mainLogic:addDestructionPlanAction(dripCastingAction)
	else
		mainLogic:addDestructionPlanAction(dripCastingAction)
	end
	
	mainLogic:setNeedCheckFalling()	

end

function GameExtandPlayLogic:decreaseLotus( mainLogic, r, c , scoreScale , noScore)
	--crash.crash()
	local item = mainLogic.gameItemMap[r][c]
	local board = mainLogic.boardmap[r][c]

	if board.lotusLevel > 0 then

		local lotusDecAction = GameBoardActionDataSet:createAs(
		 		GameActionTargetType.kGameItemAction,
		 		GameItemActionType.kItem_Decrease_Lotus,
		 		IntCoord:create(r,c),
		 		nil,
		 		GamePlayConfig_MaxAction_time)

		lotusDecAction.originLotusLevel = board.lotusLevel

		mainLogic:addDestroyAction(lotusDecAction)
	end
end

function GameExtandPlayLogic:decreaseBottleBlocker( mainLogic, r, c , scoreScale , noScore )
	local item = mainLogic.gameItemMap[r][c]
	
	if item.bottleLevel == 0 then
		return
	end

	if item.bottleLevel == 1 then
		item.bottleState = BottleBlockerState.ReleaseSpirit
	else
		item.bottleState = BottleBlockerState.HitAndChanging
	end

	item.bottleLevel = item.bottleLevel -1

	if item.bottleLevel == 0 then
		mainLogic:tryDoOrderList(r, c, GameItemOrderType.kSpecialTarget, GameItemOrderType_ST.kBottleBlocker, 1)
	end

	if not noScore then
		scoreScale = scoreScale or 1
		local addScore = scoreScale * GamePlayConfigScore.MatchBySnow
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r,c),				
			nil,				
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
	end

	local bottleBlockerDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_Bottle_Blocker_Explode,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_MaxAction_time)
	bottleBlockerDecAction.oldColor = item.ItemColorType
	bottleBlockerDecAction.oldState = item.bottleState
	bottleBlockerDecAction.newBottleLevel = item.bottleLevel

	mainLogic:addDestroyAction(bottleBlockerDecAction)
end

--随机一个可用的颜色。规则：关卡内有的颜色且尽量不造成三消且和当前位于r，c的Item的ItemColorType不一致
function GameExtandPlayLogic:getRandomColorByDefaultLogic( mainLogic, r, c )

	local resultColor = AnimalTypeConfig.kBlue

	local item = mainLogic.gameItemMap[r][c]

	if item then

		local levelColors = {}
		for i = 1, #mainLogic.mapColorList do 
			table.insert( levelColors , mainLogic.mapColorList[i] )
		end

		if levelColors and #levelColors > 0 then
			local size = #levelColors
			local selfColorIndex = 0
			for i = 1, size do
				if item.ItemColorType == levelColors[i] then
					selfColorIndex = i
				end
			end

			if selfColorIndex > 0 then
				table.remove( levelColors , selfColorIndex )
			end

			local possibleColors = {}
			local k,v
			for k, v in pairs(levelColors) do 
				if not mainLogic:checkMatchQuick(r, c, v) then
					table.insert(possibleColors, v)
				end
			end

			if #possibleColors > 0 then
				resultColor = possibleColors[ mainLogic.randFactory:rand(1, #possibleColors) ]
			else
				resultColor = levelColors[ mainLogic.randFactory:rand(1, #levelColors) ]
			end
		end
	end

	return resultColor
end

--随机妖精瓶子的颜色。规则：关卡内有的颜色且尽量不造成三消且和当前的ItemColorType不一致
function GameExtandPlayLogic:randomBottleBlockerColor( mainLogic, r, c )

	local item = mainLogic.gameItemMap[r][c]

	if item and item.ItemType == GameItemType.kBottleBlocker then
		return GameExtandPlayLogic:getRandomColorByDefaultLogic(mainLogic, r, c)
	end

	return AnimalTypeConfig.kBlue
end

function GameExtandPlayLogic:updateItemsEffectedByUFO(mainLogic)
	if mainLogic.hasDropDownUFO then
		local itemMap = mainLogic.gameItemMap
		local baseMap = mainLogic.boardView.baseMap
		for r = 1, #itemMap do
			for c = 1 ,#itemMap[r] do 
				local itemdata = itemMap[r][c]
				if itemdata and itemdata:canBeEffectByUFO() then
					local isDangerours = GameExtandPlayLogic:isItemInDanger(mainLogic, r, c)
					baseMap[r][c]:updateDangerousStatus(isDangerours)
				end
			end
		end
	end
end

--获取ufo的位置
function GameExtandPlayLogic:getUFOPosition( mainLogic )
	-- body
	local r_ufo = 10
	local c_ufo = 1
	local itemMap = mainLogic.gameItemMap
	for r = 1, #itemMap do
		for c = 1 ,#itemMap[r] do 
			local itemdata = itemMap[r][c]
			if itemdata:canBeEffectByUFO() then 
				if r < r_ufo then 
					r_ufo = r c_ufo = c 
				elseif r == r_ufo then 
					local r_up = GameExtandPlayLogic:upstairsItemsByUfo(mainLogic, itemMap, r, c )
					local r_ufo_up = GameExtandPlayLogic:upstairsItemsByUfo(mainLogic, itemMap, r_ufo, c_ufo )
					if r_ufo_up < 0 then
						if r_up > 0 then r_ufo = r c_ufo = c end
					elseif r_up < r_ufo_up and r_up > 0 then 
						r_ufo = r c_ufo = c
					end
				end
			end
		end
	end
	local oldPos = mainLogic:getGameItemPosInView(1, c_ufo)
	return ccp(oldPos.x, oldPos.y + 20), IntCoord:create(1, c_ufo) -- y+20为飞碟提供坠落空间
end

function GameExtandPlayLogic:getSquirrelPosYinBoard( mainLogic, old_c )
	-- body
	local r_squirrel = 1
	local c_squirrel = 10
	local itemMap = mainLogic.gameItemMap
	for r = 1, #itemMap do 
		for c = 1, #itemMap[r] do 
			local itemData = itemMap[r][c]
			if itemData:canBeEffectByUFO() then 
				if  r_squirrel <= r then 
					r_squirrel = r c_squirrel = c
				end
			end
		end
	end

	local isDangerours = true
	if r_squirrel <= 3 then 
		isDangerours  = false
	end
	return c_squirrel, isDangerours
end


function GameExtandPlayLogic:resetRabbitItemState(mainLogic)
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap do 
			local item = mainLogic.gameItemMap[r][c]
			if item and item.rabbitState == GameItemRabbitState.kSpawn then 
				item:changeRabbitState(GameItemRabbitState.kNone)
			end
		end
	end
end

function GameExtandPlayLogic:recoverUFO(mainLogic)
	if mainLogic.hasDropDownUFO and not mainLogic.isUFOWin then -- 飞碟被击晕
		if mainLogic.UFOSleepCD > 0 then
			if mainLogic.UFOSleepCD < 3 then
				mainLogic.PlayUIDelegate:playUFORecoverAnimation()
			end
			mainLogic.oldUFOSleepCD = mainLogic.UFOSleepCD
			mainLogic.UFOSleepCD = mainLogic.UFOSleepCD - 1
		end
	end
end

function GameExtandPlayLogic:revertUFOToPreStatus(mainLogic)
	if mainLogic.hasDropDownUFO then
		-- 根据
		local oldStatus = UFOStatus.kNormal
		if mainLogic.oldUFOSleepCD == 2 then
			oldStatus = UFOStatus.kWakeUp
		elseif mainLogic.oldUFOSleepCD > 2 then
			oldStatus = UFOStatus.kStun
		end
		mainLogic.PlayUIDelegate:forceUpdateUFOStatus(oldStatus)
	end
end

-------------------
--check item can be effect by ufo
--------------------
function GameExtandPlayLogic:checkUFOItemUpdate( mainLogic, completeCallback )
	-- body
	local item_count = 0
	local item_top = false
	if mainLogic.gameMode:reachEndCondition() then ---产品的需求，如果达到胜利条件则 不再判断, 直接返回
		return item_count, item_top
	end
	if mainLogic.gameMode:is(RabbitWeeklyMode) and mainLogic.gameMode:isNeedChangeState(nil, false) then 
		return item_count, item_top
	end

	if mainLogic.UFOSleepCD > 0 then -- 飞碟被击晕
		return item_count, item_top
	end

	if mainLogic.hasDropDownUFO and not mainLogic.isUFOWin and mainLogic.theCurMoves > 0 then 
		local itemList = mainLogic.gameItemMap

		local itemList_copy = {}
		for r = 1, #itemList do 
			if not itemList_copy[r] then itemList_copy[r] = {} end
			for c = 1, #itemList[r] do 
				itemList_copy[r][c] = itemList[r][c]:copy()
			end
		end

		local hasTopItem = false
		for r = 1, #itemList_copy do 
			for c = 1, #itemList_copy[r] do 
				local item = itemList_copy[r][c]
				if item:canBeEffectByUFO() 
					and not item:hasLock()
					and item:isAvailable() and item.rabbitState ~= GameItemRabbitState.kSpawn then

					local r_up, isTop, isShowDangerous = GameExtandPlayLogic:upstairsItemsByUfo(mainLogic, itemList_copy, r, c )
					item.isTop = isTop
					if isTop then hasTopItem = true end
					item.isShowDangerous = isShowDangerous
					if r_up > 0 and not isTop then 
						itemList_copy[r][c] = itemList_copy[r_up][c]
						itemList_copy[r_up][c] = item
					end
				end
			end
		end

		for r = 1, #itemList_copy do 
			for c = 1,#itemList_copy[r] do
				local itemdata = itemList_copy[r][c]
				local canSendAction = false
				if hasTopItem then
					if itemdata.isTop then canSendAction = true  item_top = true end
				else
					if itemdata.y ~= r then canSendAction = true end
				end

				if canSendAction then 
					item_count = item_count + 1
					local intcoord2 = itemdata.isTop and IntCoord:create(1, c) or IntCoord:create(r, c)
					local itemForceToMoveAction = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_ItemForceToMove,
							IntCoord:create(itemdata.y, c),
							intcoord2,
							GamePlayConfig_MaxAction_time
						)
					itemForceToMoveAction.completeCallback = completeCallback
					itemForceToMoveAction.isTop = itemdata.isTop
					itemForceToMoveAction.isShowDangerous = itemdata.isShowDangerous
					itemForceToMoveAction.isUfoLikeItem = itemdata:canBeEffectByUFO()
					mainLogic:addGameAction(itemForceToMoveAction)
				end 
			end
		end

		if item_count > 0 then 
			if mainLogic.PlayUIDelegate then
				mainLogic.PlayUIDelegate:playUFOPullAnimation(true)
			end
		else
			if mainLogic.PlayUIDelegate then
				mainLogic.PlayUIDelegate:playUFOPullAnimation(false)
			end
		end
	end
	return item_count, item_top

end

function GameExtandPlayLogic:isItemInDanger(mainLogic, r, c)
	local itemMap = mainLogic.gameItemMap
	local top_num = 1
	for k = 1, 9 do 
		if itemMap[k][c].isUsed then 
			top_num = k
			break
		end
	end
	if r - top_num < 2 then 
		return true 
	else 
		return false 
	end	
end
--------------------
--get upstairs r c  by ufo
--------------------
function GameExtandPlayLogic:upstairsItemsByUfo(mainLogic, itemList_copy, r, c )
	-- body
	local item = itemList_copy[r][c]
	local tempGoUpstairOneStep = r > 1 and itemList_copy[r-1][c]
	local tempGoUpstairTwoStep = r > 2 and itemList_copy[r-2][c]

	local function checkItemAvailable(item)
		if not item or not item.isUsed then return false end

		if item:hasLock()
			or item:hasFurball()
			or item:canBeEffectByUFO()
			or item.isBlock
			or item.ItemType == GameItemType.kNone then 
			return false
		else
			return true
		end
	end
	local canGoUpstairOneStep = false
	local canGoUpstairTwoStep = false
	if checkItemAvailable(tempGoUpstairOneStep) 
		and not mainLogic:hasChainInNeighbors(r, c, r-1, c) then
		canGoUpstairOneStep = true
	end
	if checkItemAvailable(tempGoUpstairTwoStep)
		and not mainLogic:hasChainInNeighbors(r, c, r-1, c)
		and not mainLogic:hasChainInNeighbors(r-1, c, r-2, c) then
		canGoUpstairTwoStep = true
	end
	
	local isTop = false
	local top_num = 1
	for k = 1, 9 do 
		if itemList_copy[k][c].isUsed then 
			top_num = k
			break
		end
	end
	if r == top_num then 
		isTop = true
	end

	local tempItem = nil
	local isShowDangerous = false
	if item.rabbitLevel > 1 and r >= 7 then
		if canGoUpstairTwoStep then
			if r-2 - top_num < 2 then isShowDangerous = true end
			return r - 2, false, isShowDangerous
		elseif canGoUpstairOneStep then 
			if r-1 - top_num < 2 then isShowDangerous = true end
			return r - 1, false, isShowDangerous
		elseif isTop then 
			return 1, true, isShowDangerous
		else
			return -1, false, isShowDangerous
		end
	else
		if canGoUpstairOneStep then 
			if r-1 - top_num < 2 then isShowDangerous = true end
			return r - 1, false, isShowDangerous
		elseif canGoUpstairTwoStep then
			if r-2 - top_num < 2 then isShowDangerous = true end
			return r - 2, false, isShowDangerous
		elseif isTop then 
			return 1, true, isShowDangerous
		else
			return -1, false, isShowDangerous
		end
	end

	
end

function GameExtandPlayLogic:choseItemToIngredient( mainLogic, r, c )
	-- body
	local min = 10
	local max = 0
	local item
	for k = 1, 9 do 
		item = mainLogic.gameItemMap[k][c]
		if item.isUsed then 
			if min > k then min = k end
			if max < k then max = k end
		end
	end

	for k = max - math.floor((max - min)/2), min, -1 do 
		item = mainLogic.gameItemMap[k][c]
		if item and (not item:hasLock()) and not item:hasFurball() and 
			(item.ItemType == GameItemType.kAnimal
			or item.ItemType == GameItemType.kCrystal
			or item.ItemType == GameItemType.kCoin) then
			return k, c
		end
	end
end

function GameExtandPlayLogic:reviveGame( mainLogic, callback)
	-- body
	local isRabbitWeeklyScene = LevelMapManager:getInstance():isRabbitWeeklyLevel(mainLogic.level)

	for k, v in pairs(mainLogic.UFOCollection) do 
		if isRabbitWeeklyScene then 
			local count = v.level > 1 and 2 or 1
			mainLogic.rabbitCount:setValue(mainLogic.rabbitCount:getValue() + count)
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(v.r, v.c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.rabbitCount:getValue(), position)
			end
			if callback then callback() end
		else
			local r, c = GameExtandPlayLogic:choseItemToIngredient( mainLogic, v.r, v.c )
			if r and c then 
				local changeToIngredientAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_ItemChangeToIngredient,
					IntCoord:create(r, c),
					IntCoord:create(v.r, v.c),
					GamePlayConfig_MaxAction_time
				)

				changeToIngredientAction.completeCallback = callback
				mainLogic:addGameAction(changeToIngredientAction)
			else
				if callback then callback() end
			end
		end
		
	end

	mainLogic.UFOCollection = {}

end

function GameExtandPlayLogic:CheckTileBlockerList(mainLogic, callback)
	-- body
	local count = 0
	mainLogic.tileBlockCount = mainLogic.tileBlockCount - 1
	for r = 1, #mainLogic.boardmap do 
		for c = 1, #mainLogic.boardmap[r] do
			local boardData = mainLogic.boardmap[r][c]
			boardData.reverseCount = mainLogic.tileBlockCount
			if boardData:isRotationTileBlock() then 
				count = count + 1
				local action = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_TileBlocker_Update,
				IntCoord:create(r, c),
				nil,
				GamePlayConfig_MaxAction_time
			)

			action.completeCallback = callback
			action.coutDown = mainLogic.tileBlockCount
			action.isReverseSide = boardData.isReverseSide
			mainLogic:addGameAction(action)
			end
		end 
	end
	if mainLogic.tileBlockCount  <= 0 then 
		mainLogic.tileBlockCount = 3
		if count > 0 then 
			GamePlayMusicPlayer:playEffect(GameMusicType.kTileBlockerTurn)
		end
	end
	return count
end

function GameExtandPlayLogic:checkPM25(mainLogic, callback)
	local count = 0
	if mainLogic.pm25 > 0 then 
		mainLogic.pm25count = mainLogic.pm25count + 1
		if mainLogic.pm25count % mainLogic.pm25 == 0 then 
			--get all normal animals
			local itemList = {}
			for r = 1, #mainLogic.gameItemMap do 
				for c = 1, #mainLogic.gameItemMap[r] do 
					local item = mainLogic.gameItemMap[r][c]
					if (item.ItemType == GameItemType.kAnimal or item.ItemType == GameItemType.kCrystal)
						and item:isAvailable()
						and not item:hasLock() 
						and not item:hasFurball() 
						and item.ItemSpecialType == 0 then 
						table.insert(itemList, {r = r, c = c})
					end
				end
			end

			--random item
			for k = 1, GamePlayConfig_PM25_ChangeItem_Max_Count do 
				if #itemList > 0 then 
					local selected = table.remove(itemList, mainLogic.randFactory:rand(1, #itemList))
					local action = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItem_PM25_Update,
						IntCoord:create(selected.r, selected.c),
						nil,
						GamePlayConfig_MaxAction_time
					)

					count = count + 1
					action.completeCallback = callback
					mainLogic:addGameAction(action)
				end
			end

		end
	end

	return count
end

-------------------------
--随机获取优先级为 普通动物，水晶球， 特效动物列表
--maxNum 获取的数量
-------------------------
function GameExtandPlayLogic:getRandomColorItems( mainLogic, maxNum )
	-- body
	local animal_normal_list = {}
	local crystal_list = {}
	local animal_special_list = {}
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			local board = mainLogic.boardmap[r][c]
			if item:isAvailable() and not item:hasLock() and not item:hasFurball() and not board:hasSuperCuteBall() then
				if item.ItemType == GameItemType.kAnimal then
					if item.ItemSpecialType == 0 then
						table.insert(animal_normal_list, {r=r, c=c})
					else
						table.insert(animal_special_list, {r=r, c=c})
					end
				elseif item.ItemType == GameItemType.kCrystal then
					table.insert(crystal_list, {r=r, c=c})
				end
			end
		end
	end

	local result = {}
	for k = 1, maxNum do 
		local item = table.remove(animal_normal_list, mainLogic.randFactory:rand(1, #animal_normal_list))
		if not item then 
			item = table.remove(crystal_list, mainLogic.randFactory:rand(1, #crystal_list))
		end

		if not item then
			item = table.remove(animal_special_list, mainLogic.randFactory:rand(1, #animal_special_list))
		end

		if item then 
			result[k] = item
		end
	end
	return result
end

function GameExtandPlayLogic:checkBlackCuteBallList( mainLogic, callback )
	-- body
	local count = 0
	local needReplaceItem = {}
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kBlackCuteBall and item:isAvailable() then
				
				if item.blackCuteStrength == 2 then 
					table.insert(needReplaceItem, {r=r, c=c})
					count = count + 1
				elseif item.blackCuteStrength == 1 then
					if item.lastInjuredStep ~= mainLogic.realCostMove then
						count = count + 1
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_Black_Cute_Ball_Update,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_MaxAction_time
						)
						action.completeCallback = callback
						mainLogic:addGameAction(action)
					end
				end
			end
		end
	end

	local select_list = GameExtandPlayLogic:getRandomColorItems( mainLogic, #needReplaceItem )
	for k = 1, #select_list do 
		local blackCuteCoord = IntCoord:create(needReplaceItem[k].r, needReplaceItem[k].c)
		local replaceItemCoord = IntCoord:create(select_list[k].r, select_list[k].c)
		local action = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Black_Cute_Ball_Update,
			blackCuteCoord,
			replaceItemCoord,
			GamePlayConfig_MaxAction_time
		)
		action.completeCallback = callback
		mainLogic:addGameAction(action)
	end

	---找到的替换item不够
	if #select_list < #needReplaceItem then
		print("find no enough items")
		count = count - (#needReplaceItem - #select_list)
	end
	return count
end

function GameExtandPlayLogic:findMimosa(mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	if (item.ItemType == GameItemType.kMimosa or item.ItemType == GameItemType.kKindMimosa )
		-- and #item.mimosaHoldGrid > 0 and item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
		and #item.mimosaHoldGrid > 0 and not item.isBackAllMimosa then
		return r, c
	else
		for r1 = 1, #mainLogic.gameItemMap do 
			for c1 = 1, #mainLogic.gameItemMap[r1] do 
				local temp_item = mainLogic.gameItemMap[r1][c1]
				-- if temp_item and #temp_item.mimosaHoldGrid > 0 and temp_item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
				if temp_item and #temp_item.mimosaHoldGrid > 0 and not temp_item.isBackAllMimosa then
					for k, v in pairs(temp_item.mimosaHoldGrid) do
						if v.x == r and v.y == c then
							return r1, c1
						end
					end
				end
			end
		end 
	end
	return nil
end

-------含羞草退到r, c点 无保护
function GameExtandPlayLogic:backMimosaToRC(mainLogic, r, c, callback)
	-- body
	local _r, _c = GameExtandPlayLogic:findMimosa(mainLogic, r, c )
	if _r and _c then
		local item = mainLogic.gameItemMap[_r][_c]
		local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_KindMimosa_back,
							IntCoord:create(_r, _c),
							IntCoord:create(r, c),
							GamePlayConfig_MaxAction_time
							)
		action.completeCallback = callback
		local mimosaHoldGrid = item.mimosaHoldGrid
		local max = #mimosaHoldGrid
		local newHoldGrid = {}
		local list = {}
		local isPopHoldGrid = false
		for k = 1, max do
			local v = mimosaHoldGrid[k]
			if v.x == r and v.y == c then
				isPopHoldGrid = true
			end

			if isPopHoldGrid then
				table.insert(list, IntCoord:create(v.x, v.y))

			else
				table.insert(newHoldGrid, IntCoord:create(v.x, v.y))
			end
		end

		action.direction = item.mimosaDirection
		action.itemType = item.ItemType
		action.list = list

		item.mimosaHoldGrid = newHoldGrid
		item.mimosaLevel = 1
		if #newHoldGrid == 0 then
			item.mimosaLevel = 0
		end
		mainLogic:addDestroyAction(action)
	else
		if callback then callback() end
	end

end

-------含羞草退出所有 有保护
function GameExtandPlayLogic:backMimosa( mainLogic, r, c, callback )
	-- body
	local _r, _c = GameExtandPlayLogic:findMimosa(mainLogic, r, c )
	if _r and _c then
		local item = mainLogic.gameItemMap[_r][_c]
		local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_Mimosa_back,
							IntCoord:create(_r, _c),
							nil,
							GamePlayConfig_MaxAction_time
							)
		action.completeCallback = callback
		action.mimosaHoldGrid = item.mimosaHoldGrid
		for k, v in pairs(item.mimosaHoldGrid) do    --------保护起来
			local item_t = mainLogic.gameItemMap[v.x][v.y]
			item_t.beEffectByMimosa = GameItemType.kMimosa 
		end
		action.direction = item.mimosaDirection
		action.itemType = item.ItemType
		item.mimosaLevel = 1
		item.isBackAllMimosa = true
		mainLogic:addDestroyAction(action)
	else
		if callback then callback() end
	end

end

function GameExtandPlayLogic:getMimosaToHoldGrid(itemType, mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	local rAdd, cAdd = 0, 0
	local result = nil
	if item and item.ItemType == itemType then
		if item.mimosaDirection == 1 then  --left
			rAdd = 0  cAdd = -1
		elseif item.mimosaDirection == 2 then  --right
			rAdd = 0  cAdd = 1
		elseif item.mimosaDirection == 3 then  --up
			rAdd = -1  cAdd = 0
		elseif item.mimosaDirection == 4 then  --down
			rAdd = 1  cAdd = 0
		end
	end

	local grid
	local i = 1
	if (item.mimosaHoldGrid and #item.mimosaHoldGrid > 0 ) then
		grid = IntCoord:create(item.mimosaHoldGrid[#item.mimosaHoldGrid].x + i * rAdd, item.mimosaHoldGrid[#item.mimosaHoldGrid].y + i * cAdd)
	else
		grid = IntCoord:create(r + i * rAdd, c + i * cAdd)
	end

	if mainLogic:hasChainInNeighbors(grid.x - i * rAdd, grid.y - i * cAdd, grid.x, grid.y) then
		return nil
	end

	if mainLogic.gameItemMap[grid.x] and mainLogic.gameItemMap[grid.x][grid.y] then
		local item_select = mainLogic.gameItemMap[grid.x][grid.y]
		if item_select and item_select.isUsed
			and not item_select.isEmpty
			and not item_select:hasFurball() 
			and not item_select:hasLock() 
			and item_select.ItemType ~= GameItemType.kBlackCuteBall
			and item_select:isAvailable()
			and not item_select.isBlock
			or item_select.ItemType == GameItemType.kMagicLamp
			or item_select.ItemType == GameItemType.kWukong then
			result = grid
		end
	end
	return result
end

function GameExtandPlayLogic:updateMimosaToHoldGridList(itemType, mainLogic)
	-- body
	local itemMap = mainLogic.gameItemMap
	local result = {}
	for i = 1, GamePlayConfig_Mimosa_Grow_Grid_Num + 1 do 
		for r = #itemMap, 1, -1 do 
			if not result[r] then result[r] = {} end
			for c = #itemMap[r], 1, -1 do 
				local item = itemMap[r][c]
				if item and item.ItemType == itemType and item:isAvailable() 
					and item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
					local tryGrid = GameExtandPlayLogic:getMimosaToHoldGrid(itemType, mainLogic, r, c )
					if tryGrid then
						if i == 1 then
							item.isCanGrow = true
						else
							local item_select = itemMap[tryGrid.x][tryGrid.y]
							item_select.beEffectByMimosa = item.ItemType
							item_select.mimosaDirection = item.mimosaDirection
							if not result[r][c] then result[r][c] = {} end
							table.insert(result[r][c], tryGrid)
							table.insert(item.mimosaHoldGrid, tryGrid)
						end
					end
				end
			end
		end
	end

	return result
	

end

function GameExtandPlayLogic:checkMimosa( itemType, mainLogic, callback )
	-- body
	local count = 0
	local map = mainLogic.gameItemMap
	local addGridMap = GameExtandPlayLogic:updateMimosaToHoldGridList(itemType, mainLogic)
	for r = 1, #map do 
		for c = 1, #map[r] do
			local item = map[r][c]
			if item and item.ItemType == itemType and item:isAvailable() then
				item.mimosaLevel = item.mimosaLevel + 1
				if item.mimosaLevel > GamePlayConfig_Mimosa_Grow_Step then
					local tryGrids = addGridMap[r][c]
					if tryGrids and #tryGrids > 0 then              -------生长
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_Mimosa_Grow,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_MaxAction_time
							)
						action.completeCallback = callback
						action.addItem = tryGrids
						action.direction = item.mimosaDirection
						action.itemType = item.ItemType
						mainLogic:addGameAction(action)
						count = count + 1
					elseif #item.mimosaHoldGrid > 0 and not item.isCanGrow then    -------------退回
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_Mimosa_back,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_MaxAction_time
							)
						action.completeCallback = callback
						action.mimosaHoldGrid = item.mimosaHoldGrid
						action.direction = item.mimosaDirection
						action.itemType = item.ItemType
						mainLogic:addGameAction(action)
						item.mimosaLevel = 1
						count = count + 1
					end
					item.isCanGrow = nil
				else 
					if item.mimosaLevel == GamePlayConfig_Mimosa_Grow_Step then
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_Mimosa_Ready,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_MaxAction_time
							)
						action.completeCallback = callback
						mainLogic:addGameAction(action)
						count = count + 1
					end
				end
			end
		end
	end
	return count
end



function GameExtandPlayLogic:MaydayBossLoseBlood(mainLogic, r, c, isMatch , actid , hitBlood)
	
	local item = mainLogic.gameItemMap[r][c]
	local boss = nil
	local boss_r, boss_c = r, c 
	if item.bossLevel > 0 then
		boss = item
	else
		if c - 1 > 0 and mainLogic.gameItemMap[r][c - 1].bossLevel > 0 then
			boss = mainLogic.gameItemMap[r][c - 1]
			boss_r, boss_c = r, c-1
		elseif r - 1 > 0 and mainLogic.gameItemMap[r - 1][c].bossLevel > 0 then
			boss = mainLogic.gameItemMap[r - 1][c]
			boss_r, boss_c = r-1, c
		elseif (c - 1 > 0 and r - 1 > 0) and mainLogic.gameItemMap[r - 1][c - 1].bossLevel > 0 then
			boss = mainLogic.gameItemMap[r - 1][c-1]
			boss_r, boss_c = r-1, c-1
		end
	end
	
	local canBeEffectBySpecaial = true
	if isMatch == false and actid and boss ~= nil then
		if not boss.specialEffectList then 
			boss.specialEffectList = {}
		end

		if boss.specialEffectList[actid] then
			canBeEffectBySpecaial = false 
		end

		if canBeEffectBySpecaial then
			boss.specialEffectList[actid] = true
		end
	end

	if boss ~= nil and boss.blood > 0 and canBeEffectBySpecaial then
		local addScore = GamePlayConfigScore.MayDayBossBeHit
		-- boss.digBlockCanbeDelete = false
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(r, c),
			nil,
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)
		local bloodLoseCount = isMatch and 1 or boss.speicial_hit_blood
		if hitBlood and type(hitBlood) == "number" and hitBlood > 0 then
			bloodLoseCount = hitBlood
		end
		-- hitCounter的增量不会超过boss当前血量
		if boss.blood > bloodLoseCount then
			boss.hitCounter = boss.hitCounter + bloodLoseCount
		else
			boss.hitCounter = boss.hitCounter + boss.blood
		end

		boss.blood = boss.blood - bloodLoseCount
		if boss.blood < 0 then boss.blood = 0 end
		local decAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Mayday_Boss_Loss_Blood,
			IntCoord:create(boss_r, boss_c),
			nil,
			GamePlayConfig_MaxAction_time)
		decAction.addInt = boss.blood / boss.maxBlood
		decAction.debug_string = tostring(boss.blood)..'/'..tostring(boss.maxBlood)
		mainLogic:addDestroyAction(decAction)
	end
end

function GameExtandPlayLogic:showUFOReveivePanel(gameMode, isWin)
	local mainLogic = gameMode.mainLogic
    local function reviveGameCallback( ... )
        -- body
        if mainLogic.PlayUIDelegate then 
            mainLogic.PlayUIDelegate:playUFOReFlyInotAnimation()
        end
        gameMode.mainLogic:setNeedCheckFalling()
        mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
        mainLogic.fsm:changeState(mainLogic.fsm.fallingMatchState)
    end

    local function reviveMissileAnimationCallback( ... )
        -- body
        GameExtandPlayLogic:reviveGame( mainLogic, reviveGameCallback)
    end

    local function confirmReviev( isTryAgain )   ----确认使用兔兔导弹后，修改数据
        -- body
        if isTryAgain then
            mainLogic.isUFOWin = false
            local icon = Sprite:createWithSpriteFrameName("RabbitMissile")
            local scene = Director:sharedDirector():getRunningScene()
            local animation = PrefixPropAnimation:createReviveMissileAnimation(icon, reviveMissileAnimationCallback)
            scene:addChild(animation)
        else
            if isWin then 
            	mainLogic:setGamePlayStatus(GamePlayStatus.kWin)
            else
            	mainLogic:setGamePlayStatus(GamePlayStatus.kFailed)
            end
        end
    end

    local function addPanel()
        mainLogic.PlayUIDelegate:showAddRabbitMissilePanel(mainLogic.level, mainLogic.totalScore, gameMode:getScoreStarLevel(mainLogic), gameMode:reachTarget(), confirmReviev)
    end

    if mainLogic.PlayUIDelegate then 
        mainLogic.PlayUIDelegate:playUFOFlyawayAnimation(addPanel)
    end
end

function GameExtandPlayLogic:showAddStepPanel(gameMode)
	local mainLogic = gameMode.mainLogic;
	local function tryAgainWhenFailed(isTryAgain)	----确认加5步之后，修改数据
	    if isTryAgain then
	      gameMode:getAddSteps(5)
	      mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
	      mainLogic.fsm:changeState(mainLogic.fsm.waitingState)
	    else
	      mainLogic:setGamePlayStatus(GamePlayStatus.kFailed)
	    end
	end 

	if mainLogic.PlayUIDelegate then
	    mainLogic.PlayUIDelegate:addStep(mainLogic.level, mainLogic.totalScore, gameMode:getScoreStarLevel(mainLogic), gameMode:reachTarget(), tryAgainWhenFailed)
	end
end

function GameExtandPlayLogic:showAddTimePanel(gameMode)
	local mainLogic = gameMode.mainLogic

	local function addTimeCallback(confirmUse)
		if confirmUse then
			gameMode:addTime(15)
			mainLogic:setGamePlayStatus(GamePlayStatus.kNormal)
	      	mainLogic.fsm:changeState(mainLogic.fsm.waitingState)
		else
			mainLogic:setGamePlayStatus(GamePlayStatus.kFailed)
		end
	end

	if mainLogic.PlayUIDelegate then
		mainLogic.PlayUIDelegate:showAddTimePanel(mainLogic.level, mainLogic.totalScore, gameMode:getScoreStarLevel(mainLogic), gameMode:reachTarget(), addTimeCallback)
	end
end

function GameExtandPlayLogic:checkTransmission(mainLogic, callback)
	local result = 0
	local gameItemMap = mainLogic.gameItemMap
	local boardmap = mainLogic.boardmap
	for r = 1, #boardmap do 
		for c = 1, #boardmap[r] do 
			local board = boardmap[r][c]
			if board.transType > 0 then
				result = result  + 1
				local to_r, to_c = board.transLink.x, board.transLink.y
				local action =  GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Transmission,
					IntCoord:create(r, c),
					IntCoord:create(to_r, to_c),
					GamePlayConfig_MaxAction_time)
				action.completeCallback = callback
				action.itemData = gameItemMap[r][c]:copy()
				action.boardData = boardmap[r][c]:copy()
				action.toBoardDataDirect = boardmap[to_r][to_c].transDirect
				mainLogic:addGameAction(action)
			end
		end
	end

	return result
end

--------------------
--蜂蜜罐子增加一层
--------------------
function GameExtandPlayLogic:increaseHoneyBottle( mainLogic, r, c, times, scoreScale )
	-- body
	scoreScale = scoreScale or 1
	local item = mainLogic.gameItemMap[r][c]
	if item.honeyBottleLevel + times > 4 then times = 4 - item.honeyBottleLevel end
	item.honeyBottleLevel = item.honeyBottleLevel + times
	
	local incAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_Honey_Bottle_increase,
	 		IntCoord:create(r,c),
	 		nil,
	 		1)
	incAction.addInt = times
	mainLogic:addDestroyAction(incAction)
end

function GameExtandPlayLogic:checkHoneyBottleBroken( mainLogic, callback )
	-- body
	local gameItemMap = mainLogic.gameItemMap
	local boardMap = mainLogic.boardmap
	--select item to run
	local brokenHoneyBottle = {}
	local canBeInfectItemList = {}
	local subCanBeInfectItemList = {}
	for r = 1, #gameItemMap do 
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if item then 
				local intCoord = IntCoord:create(r, c)
				if item.honeyBottleLevel > 3 and item:isAvailable() then
					table.insert(brokenHoneyBottle, intCoord)
				elseif item:canInfectByHoneyBottle() then
					if boardMap[r][c].honeySubSelect then 
						table.insert(subCanBeInfectItemList, intCoord)
					else
						table.insert(canBeInfectItemList, intCoord)
					end
				end
			end 
		end
	end
	
	for k, v in pairs(brokenHoneyBottle) do 
		local infectList = {}
		for k = 1, mainLogic.honeys do 
			local item 
			if #canBeInfectItemList > 0 then
				--todo
				item = table.remove(canBeInfectItemList, mainLogic.randFactory:rand(1, #canBeInfectItemList))
				table.insert(infectList, item)
			elseif #subCanBeInfectItemList > 0 then 
				item = table.remove(subCanBeInfectItemList, mainLogic.randFactory:rand(1, #subCanBeInfectItemList))
				table.insert(infectList, item)
			end
		end
		
		local addScore = GamePlayConfigScore.MatchAt_DigJewel
		ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(v.x, v.y),
			nil,
			1)
		ScoreAction.addInt = addScore
		mainLogic:addGameAction(ScoreAction)

		local infectAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_Honey_Bottle_Broken,
	 		v,
	 		nil,
	 		GamePlayConfig_MaxAction_time)
		infectAction.infectList = infectList
		infectAction.completeCallback = callback
		mainLogic:addGameAction(infectAction)
	end

	return #brokenHoneyBottle
end

function GameExtandPlayLogic:honeyDestroy( mainLogic, r, c, scoreScale )
	-- body
	local  item = mainLogic.gameItemMap[r][c]
	----1-1.数据变化
	item.honeyLevel = item.honeyLevel - 1
	item.digBlockCanbeDelete = false

	mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kHoney, 1)
	local honeyAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemDestroy_HoneyDec,
		IntCoord:create(r,c),				
		nil,				
		GamePlayConfig_Honey_Disappear)
	mainLogic:addDestroyAction(honeyAction)
	
end

function GameExtandPlayLogic:canSandTransferToPos(mainLogic, r, c)
	assert(mainLogic)
	assert(type(r)=="number")
	assert(type(c)=="number")

	if not mainLogic:isPosValid(r, c) then
		return false
	end

	local board = mainLogic.boardmap[r][c]
	if not board or board.sandLevel > 0 then
		return false 
	end 

	local item = mainLogic.gameItemMap[r][c]
	if not item or not item.isUsed or item:isPermanentBlocker() 
			or item.ItemType == GameItemType.kMagicStone
			or item:isActiveTotems()
			or (not item:isAvailable()) then -- 
		return false 
	end

	return true
end

function GameExtandPlayLogic:getSandTransferAvailablePosAround(mainLogic, r, c)
	local result = {}
	local boardmap = mainLogic.boardmap
	local board = boardmap[r][c]

	local aroundDirections = {
		{ dr = -1, dc = 0 }, 
		{ dr = 1, dc = 0 }, 
		{ dr = 0, dc = -1 }, 
		{ dr = 0, dc = 1 }
	}

	for _, dir in pairs(aroundDirections) do
		if not mainLogic:hasRopeInNeighbors(r, c, r + dir.dr, c + dir.dc)
			and not mainLogic:hasChainInNeighbors(r, c, r + dir.dr, c + dir.dc)
			and GameExtandPlayLogic:canSandTransferToPos(mainLogic, r + dir.dr, c + dir.dc) 
			then
			table.insert(result, IntCoord:create(r + dir.dr, c + dir.dc))
		end
	end
	return result
end

function GameExtandPlayLogic:getRandomTransferSandPos(mainLogic, sands, callback)
	local result = {}
	local boardmap = mainLogic.boardmap
	for _,v in pairs(sands) do
		local r = v.x
		local c = v.y
		local board = boardmap[r][c]
		if board.sandLevel > 0 and not v.handled then
			local posAround = self:getSandTransferAvailablePosAround(mainLogic, r, c)
			if #posAround > 0 then
				local fromPos = IntCoord:create(r, c)
				local toPos = posAround[mainLogic.randFactory:rand(1, #posAround)]
				-- local toPos = posAround[math.random(#posAround)]

				local sandLevel = board.sandLevel
				boardmap[toPos.x][toPos.y].sandLevel = sandLevel
				board.sandLevel = 0

				local sandTransferAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Sand_Transfer,
					IntCoord:clone(fromPos),				
					IntCoord:clone(toPos),				
					GamePlayConfig_MaxAction_time)
				mainLogic:addGameAction(sandTransferAction)
				sandTransferAction.addInt = sandLevel
				sandTransferAction.callback = callback

				table.insert(result, toPos)
				v.handled = true
			end
		end
	end
	return result
end

function GameExtandPlayLogic:getSandBoardPos(mainLogic)
	local result = {}
	local boardmap = mainLogic.boardmap
	for r = 1, #boardmap do 
		for c = 1, #boardmap[r] do 
			local board = boardmap[r][c]
			local item = mainLogic.gameItemMap[r][c]
			if board and board.sandLevel > 0 and item:isAvailable() then
				table.insert(result, IntCoord:create(r,c))
			end
		end
	end
	return result
end

function GameExtandPlayLogic:checkSandToTransfer( mainLogic, callback )
	local result = 0
	local boardmap = mainLogic.boardmap
	local sands = GameExtandPlayLogic:getSandBoardPos(mainLogic)
	local transferPos = GameExtandPlayLogic:getRandomTransferSandPos(mainLogic, sands, callback)
	while #transferPos > 0 do
		result = result + #transferPos

		transferPos = GameExtandPlayLogic:getRandomTransferSandPos(mainLogic, sands, callback)
	end
	return result
end

-- useOtherRows:如果指定的行内找不到足够的位置，是否使用其他行填补空缺
function GameExtandPlayLogic:getNormalPositionsForBoss(mainLogic, count, fromRow, toRow, banList, useOtherRows)
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

	local function isBanned(r, c, banList)
		for k, v in pairs(banList) do
			if r == v.r and c == v.c then
				return true
			end
		end
		return false
	end

	if not fromRow then fromRow = 1 end
	if not toRow then toRow = 9	end
	if not count then count = 1 end
	if not useOtherRows then useOtherRows = true end
	if not banList or type(banList) ~= 'table' then banList = {} end

	local gameItemMap = mainLogic.gameItemMap

	local availablePos = {}
	for r = fromRow, toRow do
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if isNormal(item) and not isBanned(r, c, banList) then
				table.insert(availablePos, {r=r, c=c})
			end
		end
	end

	if #availablePos < count and useOtherRows then
		local backupPos = {}
		for r = 1, #gameItemMap do
			if r < fromRow or r > toRow then
				for c = 1, #gameItemMap[r] do
					local item = gameItemMap[r][c]
					if isNormal(item) and not isBanned(r, c, banList) then
						table.insert(backupPos, {r=r, c=c})
					end
				end
			end
		end
		
		-- 为了兼容如果其他行也不够的情况
		local result = table.clone(availablePos)
		local backupCount = math.min(count - #availablePos, #backupPos)
		for i = 1, backupCount do
			local index = mainLogic.randFactory:rand(1, #backupPos)
			table.insert(result, backupPos[index])
			table.remove(backupPos, index)
		end
		return result
	end


	if #availablePos < count then
		return availablePos
	else
		local result = {}
		for i = 1, count do 
			local index = mainLogic.randFactory:rand(1, #availablePos)
			table.insert(result, availablePos[index])
			table.remove(availablePos, index)
		end
		return result
	end

end

function GameExtandPlayLogic:checkBossCasting(mainLogic, callback , passDrip)


	local counter = 0
	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if gameItemMap[r][c].ItemType == GameItemType.kBoss 
				and gameItemMap[r][c].bossLevel > 0  then
				local boss = gameItemMap[r][c]
				local buffBlood = BossConfig[boss.bossLevel].buffBlood
				local buffRate = BossConfig[boss.bossLevel].buffRate
				local buffNum = BossConfig[boss.bossLevel].buffNum
				local buffLimit = BossConfig[boss.bossLevel].buffLimit

				
				if boss.hitCounter >= buffBlood then
					-- local genCount = math.floor(boss.hitCounter / buffBlood) * buffNum
					local genCount = math.floor(boss.hitCounter / buffBlood)
					-- print('genCount', genCount)
					local targetPositions = {}
					for i = 1, genCount do 
						local rand = mainLogic.randFactory:rand(1, 100) / 100
						-- print(rand, buffRate)
						if rand <= buffRate then
							local randCount = 0
							local rand2 = mainLogic.randFactory:rand(1, 100)
							if rand2 >= 0 and rand2 < 60 then
								randCount = 1
							elseif rand2 >= 60 and rand2 < 90 then
								randCount = 2
							elseif rand2 >= 90 and rand2 <= 100 then
								randCount = 3
							end

							print('randCount', rand2, randCount)

							local result = GameExtandPlayLogic:getNormalPositionsForBoss(mainLogic, randCount, 6, 9, targetPositions)
							for k, v in pairs(result) do 
								table.insert(targetPositions, v)
							end
						end
					end

					
					

					-- 最多只保留buffLimit个
					if #targetPositions > buffLimit then
						local tmp = {}
						for i=1, buffLimit do 
							table.insert(tmp, targetPositions[i])
						end
						targetPositions = tmp
					end

					print('finalCount', #targetPositions)

					local rand = mainLogic.randFactory:rand(1, 100) / 100
					local dripPositions = {}
					local dripFixMap = {}
					if not passDrip and rand <= buffRate and mainLogic.hasDripOnLevel then
						dripPositions = GameExtandPlayLogic:getNormalPositionsForBoss(
											mainLogic, mainLogic.randFactory:rand(2, 3) , 6, 9, targetPositions)
						for k, v in pairs(dripPositions) do 
							table.insert(targetPositions, v)
							dripFixMap[tostring(v.r) .. "_" .. tostring(v.c) ] = true
						end
					end
					print('finalCount 2222  ', #targetPositions)
					if #targetPositions > 0 then
						counter = counter + 1
						local action = GameBoardActionDataSet:createAs(
							GameActionTargetType.kGameItemAction,
							GameItemActionType.kItem_mayday_boss_casting,
							IntCoord:create(r, c),
							nil,
							GamePlayConfig_MaxAction_time)
						action.targetPositions = targetPositions
						action.dripPositions = dripFixMap
						action.completeCallback = callback
						mainLogic:addGameAction(action)
					end
					boss.hitCounter = boss.hitCounter - genCount * buffBlood
				end
			end
		end
	end
	return counter
end

function GameExtandPlayLogic:testRateOfQuestionMark( mainLogic, r, c )
	local tableRate = {}
	for i = 1, 100 do 
		local v = GameExtandPlayLogic:getChangeItemSelected( mainLogic, r, c)
		local changeType = v.changeType
		local changeItem = v.changeItem
		if changeType == UncertainCfgConst.kCanFalling then
			local tile = changeItem + 1
			if tile == TileConst.kGreyCute then 
				if not tableRate.kGrey then  
					tableRate.kGrey = 0 
				end 
				tableRate.kGrey = tableRate.kGrey + 1 
			elseif tile == TileConst.kBrownCute then 
				if not tableRate.kBrownCute then  
					tableRate.kBrownCute = 0 
				end 
				tableRate.kBrownCute = tableRate.kBrownCute + 1
			elseif tile == TileConst.kBlackCute then 
				if not tableRate.kBlackCute then  
					tableRate.kBlackCute = 0 
				end 
				tableRate.kBlackCute = tableRate.kBlackCute + 1
			elseif tile == TileConst.kCoin then 
				if not tableRate.kCoin then  
					tableRate.kCoin = 0 
				end 
				tableRate.kCoin = tableRate.kCoin + 1
			elseif tile == TileConst.kCrystal then 
				if not tableRate.kCrystal then  
					tableRate.kCrystal = 0 
				end 
				tableRate.kCrystal = tableRate.kCrystal + 1
			elseif tile == TileConst.kAddMove then 
				if not tableRate.kAddMove then  
					tableRate.kAddMove = 0 
				end 
				tableRate.kAddMove = tableRate.kAddMove + 1
			end
		elseif changeType == UncertainCfgConst.kCannotFalling then
			local tile = changeItem + 1
			if tile == TileConst.kPoison then 
				if not tableRate.kPoison then  
					tableRate.kPoison = 0 
				end 
				tableRate.kPoison = tableRate.kPoison + 1  
			elseif tile == TileConst.kPoisonBottle then 
				if not tableRate.kPoisonBottle then  
					tableRate.kPoisonBottle = 0 
				end 
				tableRate.kPoisonBottle = tableRate.kPoisonBottle + 1 
			elseif tile == TileConst.kDigJewel_1_blue then 
				if not tableRate.kDigJewel_1_blue then  
					tableRate.kDigJewel_1_blue = 0 
				end 
				tableRate.kDigJewel_1_blue = tableRate.kDigJewel_1_blue + 1 
			elseif tile == TileConst.kDigJewel_2_blue then 
				if not tableRate.kDigJewel_2_blue then  
					tableRate.kDigJewel_2_blue = 0 
				end 
				tableRate.kDigJewel_2_blue = tableRate.kDigJewel_2_blue + 1 
			elseif tile == TileConst.kDigJewel_3_blue then 
				if not tableRate.kDigJewel_3_blue then  
					tableRate.kDigJewel_3_blue = 0 
				end 
				tableRate.kDigJewel_3_blue = tableRate.kDigJewel_3_blue + 1 
			end
		elseif changeType == UncertainCfgConst.kSpecial then
			local specialType = AnimalTypeConfig.getSpecial(changeItem)
			if specialType == AnimalTypeConfig.kLine then
				if not tableRate.kLine then  
					tableRate.kLine = 0 
				end 
				tableRate.kLine = tableRate.kLine + 1 
			elseif specialType == AnimalTypeConfig.kColumn then
				if not tableRate.kColumn then  
					tableRate.kColumn = 0 
				end 
				tableRate.kColumn = tableRate.kColumn + 1 

			elseif specialType == AnimalTypeConfig.kWrap then
				if not tableRate.kWrap then  
					tableRate.kWrap = 0 
				end 
				tableRate.kWrap = tableRate.kWrap + 1 

			elseif specialType == AnimalTypeConfig.kColor then
				if not tableRate.kColor then  
					tableRate.kColor = 0 
				end 
				tableRate.kColor = tableRate.kColor + 1 

			end
		end
		


	end
	for k, v in pairs(tableRate) do
		print(k, v)
	end
end

function GameExtandPlayLogic:getChangeItemSelected( mainLogic, r, c)
	-- body
	local item = mainLogic.gameItemMap[r][c]
	local itemList = nil
	local dropPropsPercent = nil -- 0 ~ 100，nil表示不予干预
	local isOnlyFallingItem

	local uncertainCfg = nil
	if item.isProductByBossDie then 
		uncertainCfg = mainLogic.uncertainCfg2
	else
		uncertainCfg = mainLogic.uncertainCfg1
	end

	if not uncertainCfg then
		print("getChangeItemSelected:uncertainCfg not exsit while BossDie=", item.isProductByBossDie)
		return 
	end

	local canDropProps = false
	if uncertainCfg:hasDropProps() then

		if mainLogic.levelType == GameLevelType.kSummerWeekly then
			if mainLogic.summerWeeklyData then
				dropPropsPercent = mainLogic.summerWeeklyData.dropPropsPercent
			end
		elseif mainLogic.laborDayData then -- 强制指定道具掉落的百分比
			dropPropsPercent = mainLogic.laborDayData.dropPropsPercent
		end

		local user = UserManager:getInstance().user
		local dropPropCount = StageInfoLocalLogic:getTotalDropPropCount( user.uid )
		if dropPropCount >= 1 then -- 本次关卡掉落过一次后不再掉落
			dropPropsPercent = 0
		end

		if not dropPropsPercent or dropPropsPercent > 0 then -- 未强制指定或指定的掉落百分比大于0
			canDropProps = true
		end
	end

	if item.ItemStatus == GameItemStatusType.kNone
			or item.ItemStatus == GameItemStatusType.kItemHalfStable then
		isOnlyFallingItem = false
		itemList = uncertainCfg.allItemList
	else
		isOnlyFallingItem = true
		itemList = uncertainCfg.canfallingItemList
	end

	local itemListNotEmpty = itemList and #itemList > 0
	if itemListNotEmpty or canDropProps then
		local total = 0
		local onlyProps = false
		if itemListNotEmpty then
			total = isOnlyFallingItem and itemList[#itemList].limitInCanFallingItem or itemList[#itemList].limitInAllItem
		end
		if canDropProps then 
			if dropPropsPercent == nil then -- 不需要调整概率，使用默认权重
				total = total + uncertainCfg.dropPropTotalWeight
			else -- 根据概率计算是否掉落道具
				if mainLogic.randFactory:rand(1, 10000) <= dropPropsPercent * 100 then
					onlyProps = true
				end
			end
		end

		-- print(canDropProps, dropPropsPercent, total)

		if itemListNotEmpty and not onlyProps then
			local randValue = mainLogic.randFactory:rand(1, total)
			-- print("randValue:", randValue, table.tostring(itemList))
			for k = 1, #itemList do 
				local limit = isOnlyFallingItem and itemList[k].limitInCanFallingItem or itemList[k].limitInAllItem
				if randValue <= limit then
					return itemList[k]
				end
			end
		end
		-- 随机到的是掉落道具
		if canDropProps then
			local dropPropList = uncertainCfg.dropPropList
			local propTotalWeight = dropPropList[#dropPropList].limitInProps
			local propRandValue = mainLogic.randFactory:rand(1, propTotalWeight)
			-- print("propRandValue:", propRandValue, table.tostring(dropPropList))
			for k = 1, #dropPropList do 
				local limit = dropPropList[k].limitInProps
				if propRandValue <= limit then
					return dropPropList[k]
				end
			end
		end
	end

	return nil
end

function GameExtandPlayLogic:changeItemTypeFromQuestionMark( mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	local selected = GameExtandPlayLogic:getChangeItemSelected( mainLogic, r, c)
	while mainLogic.questionMarkFirstBomb do  ----------------------------游戏第一次福袋爆炸不能产生褐色毛球和章鱼
		if selected.changeItem + 1 == TileConst.kPoisonBottle 
			or selected.changeItem + 1 == TileConst.kBrownCute then
			selected = GameExtandPlayLogic:getChangeItemSelected(mainLogic, r, c)
		else
			mainLogic.questionMarkFirstBomb = false
		end
	end
	if selected then 
		mainLogic.addMoveBase = mainLogic.addMoveBase > 0 and mainLogic.addMoveBase or GamePlayConfig_Add_Move_Base
		if selected.changeType == UncertainCfgConst.kProps then
			local pos = mainLogic:getGameItemPosInView(r, c)
			if mainLogic.PlayUIDelegate then
				local activityId = 0
				local text = nil
				if mainLogic.levelType == GameLevelType.kSummerWeekly then
					text = Localization:getInstance():getText("weeklyrace.winter.prop.desc", {n="\n"})
				else
					activityId = mainLogic.activityId
				end
				mainLogic.PlayUIDelegate:addTimeProp(selected.changeItem, 1, pos, activityId, text)
			end
		end
		item:changeItemFromQuestionMark(selected.changeType, selected.changeItem, mainLogic:randomColor(), mainLogic.addMoveBase)
		if not mainLogic.hasQuestionMarkProduct then
			mainLogic.hasQuestionMarkProduct = true
			local action = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_QuestionMark_Protect,
			nil,
			nil,
			GamePlayConfig_MaxAction_time)
			mainLogic:addDestroyAction(action)
		end
		item.questionMarkProduct = 2
		mainLogic:checkItemBlock(r, c)
	else
		item:cleanAnimalLikeData()
	end
end

function GameExtandPlayLogic:questionMarkBomb( mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
	GameExtandPlayLogic:changeItemTypeFromQuestionMark( mainLogic, r, c )
	mainLogic.swapHelpMap[r][c] = -mainLogic.swapHelpMap[r][c]

	local boardView = mainLogic.boardView
	local itemView = boardView.baseMap[r][c]
	itemView:playQuestionMarkDestroy()
	if itemView.itemSprite[ItemSpriteType.kEnterClipping] then
		itemView:FallingDataIntoClipping(item)
		local boardData = mainLogic.boardmap[r][c]
		local r1 = boardData.passEnterPoint_x
		local c1 = boardData.passEnterPoint_y
		if r1 > 0 and c1 > 0 then
			local exitItem = boardView.baseMap[r1][c1]
			if exitItem.itemSprite[ItemSpriteType.kClipping] then
				exitItem:FallingDataOutOfClipping(item)
			end
		end
	else
		itemView:initByItemData(item)
	end
	itemView:upDatePosBoardDataPos(item)
	mainLogic.gameItemMap[r][c].isNeedUpdate = true

	--add score
	local addScore = GamePlayConfigScore.QuestionMarkDestory
	ScoreCountLogic:addScoreToTotal(mainLogic, addScore)
	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r, c),
		nil,
		1)
	ScoreAction.addInt = addScore
	mainLogic:addGameAction(ScoreAction)
end 

function GameExtandPlayLogic:resetMagicStone(mainLogic)
	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kMagicStone and item.magicStoneLevel >= TileMagicStoneConst.kMaxLevel then
				item.magicStoneActiveTimes = 0
			end
		end
	end
end

function GameExtandPlayLogic:calcMagicStoneEffectPositions(mainLogic, r, c)
	local item = mainLogic.gameItemMap[r][c]
	local posOffset = TileMagicStone:calcEffectPositions(item.magicStoneDir)
	local validPos = {}
	for _, v in pairs(posOffset) do
		local tr, tc = r + v.x, c + v.y
		if mainLogic:isPosValid(tr, tc) and mainLogic.boardmap[tr][tc].isUsed then
			table.insert(validPos, v)
		end
	end
	return validPos
end

function GameExtandPlayLogic:onEnterWaitingState(mainLogic)
	GameExtandPlayLogic:updateItemStates(mainLogic)
	-- 更新棋盘上受UFO影响Item的状态
	GameExtandPlayLogic:updateItemsEffectedByUFO(mainLogic)
	-- 水晶石引导
	GameExtandPlayLogic:trySwapCrystalStonesGuide(mainLogic)
end

function GameExtandPlayLogic:halloweenTutorial(mainLogic)
	if mainLogic.levelType == GameLevelType.kMayDay then 
	    local goldZongziPos = nil
	    for r = 1, #mainLogic.gameItemMap do
	        for c = 1, #mainLogic.gameItemMap[r] do
	            local item = mainLogic.gameItemMap[r][c]
	            if item.ItemType == GameItemType.kGoldZongZi and not goldZongziPos then
	                goldZongziPos = {r = r, c = c}
	            end
	        end
	    end

	    if goldZongziPos then
	        GameGuide:sharedInstance():onGoldZongziAppear(goldZongziPos)
	    end
	end
end

function GameExtandPlayLogic:trySwapCrystalStonesGuide(mainLogic)
	-- 这个引导只在730关出现
	if mainLogic.level ~= 730 or not GameGuide:checkHaveGuide(mainLogic.level) then
		return
	end

	local function findNearbyActiveStonePos(r, c)
		local directions = {{dr=0, dc=1}, {dr=0, dc=-1}, {dr=1, dc=0}, {dr=-1, dc=0}}
		for _, dir in ipairs(directions) do
			local r1 = r + dir.dr
			local c1 = c + dir.dc
			if mainLogic:isPosValid(r1, c1) then
				local item = mainLogic.gameItemMap[r1][c1]
				if item and item.ItemType == GameItemType.kCrystalStone and item:isActiveCrystalStoneAvailble() 
						and not mainLogic:hasRopeInNeighbors(r, c, r1, c1) then
					return ccp(r1, c1)
				end
			end
		end
		return nil
	end

	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item and item.ItemType == GameItemType.kCrystalStone and item:isActiveCrystalStoneAvailble() then
				local pos = findNearbyActiveStonePos(r, c)
				if pos then
					GameGuide:trySwapCrystalStonesGuide(ccp(r, c), pos)
					return
				end
			end
		end
	end	
end

function GameExtandPlayLogic:updateItemStates(mainLogic)
	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kMagicStone then -- 重置魔法石状态
				if item.magicStoneLevel >= TileMagicStoneConst.kMaxLevel then
					item.magicStoneActiveTimes = 0
				end
			elseif item.ItemType == GameItemType.kCrystalStone then -- 染色宝宝能量充满，改变状态
				if not item:isActiveCrystalStoneAvailble() and item:getCrystalStoneEnergy() >= GamePlayConfig_CrystalStone_Energy then
					item:setCrystalStoneActive(true)
					local itemView = mainLogic.boardView.baseMap[r][c]
					itemView:playCrystalStoneFullAnimate()
				end
			end
		end
	end
end

function GameExtandPlayLogic:checkIsReleaseEnery( mainLogic, callback )
	-- body
	local count = 0
	if mainLogic.theGamePlayType == GamePlayType.kHedgehogDigEndless then
		local r, c = mainLogic.gameMode:findHedgehogRC()
		if mainLogic.gameMode:checkIsReleaseEnery(r, c) then
			count = count + 1
			local _action = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Hedgehog_Release_Energy,
				IntCoord:create(r, c),
				nil,
				GamePlayConfig_MaxAction_time)
			_action.completeCallback = callback
			_action.hedgehogLevel = 2
			mainLogic:addGameAction(_action)

			local dc_data = {
				game_type = "stage",
				game_name = "2016_children_day",
				category = "other",
				sub_category = "children_day_crazy_ready"
			}
			DcUtil:activity(dc_data)
		end
	end

	return count
end

function GameExtandPlayLogic:fireRocket(mainLogic, r, c, colortype)
	local item = mainLogic.gameItemMap[r][c]
	local targetPos = nil
	local isUFOExist = false

	if mainLogic.hasDropDownUFO and not mainLogic.isUFOWin and (mainLogic.theGamePlayStatus == GamePlayStatus.kNormal) then
		isUFOExist = true
	end
	if isUFOExist then
		targetPos = mainLogic.PlayUIDelegate:getUFOStayPositionInBoard()
		local sleepCD = GamePlayConfig_UFO_SleepCD_On_Hit
		if mainLogic.UFOSleepCD < sleepCD then
			mainLogic.UFOSleepCD = sleepCD
		end
	else
		targetPos = IntCoord:create(1, c)
	end

	local action = GameBoardActionDataSet:createAs(
                    GameActionTargetType.kGameItemAction,
                    GameItemActionType.kItem_Rocket_Active,
                    IntCoord:create(r, c),
                    targetPos,
                    GamePlayConfig_MaxAction_time
                )
	action.addInt = colortype
	action.isUFOExist = isUFOExist

    mainLogic:addDestructionPlanAction(action)
end

function GameExtandPlayLogic:playTileHighlight(mainLogic, type, startPos, endPos)
	if not startPos or not endPos then return end

	local fromR, fromC = startPos.x, startPos.y
	local toR, toC = endPos.x, endPos.y
	if fromR > toR then fromR, toR = toR, fromR end
	if fromC > toC then fromC, toC = toC, fromC end

	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if r >= fromR and r <= toR and c >= fromC and c <= toC then
				local item = mainLogic.gameItemMap[r][c]
				if item and item.isUsed then
					mainLogic.boardView.baseMap[r][c]:playTileHighlightEffect(type)
					mainLogic.boardView.baseMap[r][c].isNeedUpdate  = true
				end
			end
		end
	end	
end

function GameExtandPlayLogic:stopTileHighlight(mainLogic, startPos, endPos)
	if not startPos or not endPos then return end

	local fromR, fromC = startPos.x, startPos.y
	local toR, toC = endPos.x, endPos.y
	if fromR > toR then fromR, toR = toR, fromR end
	if fromC > toC then fromC, toC = toC, fromC end

	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if r >= fromR and r <= toR and c >= fromC and c <= toC then
				local item = mainLogic.gameItemMap[r][c]
				if item and item.isUsed then
					mainLogic.boardView.baseMap[r][c]:stopTileHighlightEffect()
					mainLogic.boardView.baseMap[r][c].isNeedUpdate  = true
				end
			end
		end
	end	
end

function GameExtandPlayLogic:addScoreToTotal(mainLogic, r, c, addScore)
	ScoreCountLogic:addScoreToTotal(mainLogic, addScore);
	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r,c),				
		nil,				
		1)
	ScoreAction.addInt = addScore
	mainLogic:addGameAction(ScoreAction)
end

function GameExtandPlayLogic:specialCoverInactiveCrystalStone(mainLogic, r, c, scoreScale)
	local item = mainLogic.gameItemMap[r][c]
	if item and item.isUsed and item.ItemType == GameItemType.kCrystalStone and not item:isCrystalStoneActive() then -- 未充满的继续充能
		if mainLogic.theGamePlayStatus == GamePlayStatus.kNormal and item:canCrystalStoneBeCharged() then
			item:chargeCrystalStoneEnergy(GamePlayConfig_CrystalEnergy_Special)
			-- item.isNeedUpdate = true

			local theAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemSpecial_CrystalStone_Charge,
				nil, 			
				IntCoord:create(r,c),				
				GamePlayConfig_MaxAction_time
				)
			theAction.addInt1 = item.ItemColorType
			theAction.addInt2 = item:getCrystalStoneEnergy()
			mainLogic:addDestructionPlanAction(theAction)
		end
	end
end

function GameExtandPlayLogic:specialCoverActiveCrystalStone(mainLogic, r, c, scoreScale)
	local item = mainLogic.gameItemMap[r][c]
	if item and item.isUsed and item.ItemType == GameItemType.kCrystalStone and item:isCrystalStoneActive() then
		local theAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemSpecial_CrystalStone_Animal ,
			IntCoord:create(r,c),
			nil,				
			GamePlayConfig_SpecialBomb_CrystalStone_Animal_Time1
			)

		theAction.addInt1 = item.ItemColorType ----染色宝宝的颜色
		mainLogic:addDestructionPlanAction(theAction)
	end
end

function GameExtandPlayLogic:onItemTouchBegin(mainLogic, r, c)

	if mainLogic.gameItemMap and mainLogic.gameItemMap[r] and mainLogic.gameItemMap[r][c] then
		local item = mainLogic.gameItemMap[r][c]
		if item.ItemType == GameItemType.kWukong then
			if item.wukongProgressCurr >= item.wukongProgressTotal and item.wukongState ~= TileWukongState.kReadyToJump then
				if wukongLastGuideCastingCount ~= wukongCastingCount then
					wukongLastGuideCastingCount = wukongCastingCount
					local boardmap = mainLogic.boardmap
					local moneyTargetBoardPos = {}
				    for r = 1, #boardmap do
				        for c = 1, #boardmap[r] do
				            local board = boardmap[r][c]
				            if board and board.isWukongTarget then
								table.insert(moneyTargetBoardPos, {r = r , c = c} )
				            end
				        end
				    end
					GameGuide:sharedInstance():onWukongGuideJump({wukongGuide = true, pos = moneyTargetBoardPos}, "wukongGuideJumpClick" )
				end
			end
		end
	end
end

function GameExtandPlayLogic:activeAllTotemsWithColor(mainLogic, colortype, scoreScale)
	local gameItemMap = mainLogic.gameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if item and item.isUsed and item.ItemType == GameItemType.kTotems 
					and not item:isActiveTotems() and item.ItemColorType == colortype then
				SpecialCoverLogic:effectTotemsAt(mainLogic, r, c, scoreScale)
			end
		end
	end	
end

function GameExtandPlayLogic:checkSuperCuteBallRecover(mainLogic, callback)
	local count = 0
	local boardmap = mainLogic.boardmap
	for r = 1, #boardmap do
		for c = 1, #boardmap[r] do
			local board = boardmap[r][c]
			if board and board.isUsed and board:hasSuperCuteBall() and board.superCuteState == GameItemSuperCuteBallState.kInactive then
				if board.superCuteAddInt <= 0 then
					count = count + 1

					local item = mainLogic.gameItemMap[r][c]

					board.superCuteAddInt = 0
					board.superCuteState = GameItemSuperCuteBallState.kActive
					item.beEffectBySuperCute = true

					mainLogic:checkItemBlock(r, c)

					local recoverAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItem_SuperCute_Recover,
						IntCoord:create(r,c),				
						nil,				
						GamePlayConfig_MaxAction_time)
					recoverAction.completeCallback = callback
					mainLogic:addGameAction(recoverAction)
				end
				board.superCuteAddInt = board.superCuteAddInt - 1
			end
		end
	end	
	return count
end

function GameExtandPlayLogic:getSuperCuteValidAroundItems(mainLogic, centerItem)
	local aroundDirections = {
		{ x = -1, y = 0 }, 
		{ x = 1, y = 0 }, 
		{ x = 0, y = -1 }, 
		{ x = 0, y = 1 }
	}

	local function getItemAt(r, c)
		if mainLogic.gameItemMap[r] then
			return mainLogic.gameItemMap[r][c]
		end
		return nil
	end

	local function getBoardAt(r, c)
		if mainLogic.boardmap[r] then
			return mainLogic.boardmap[r][c]
		end
		return nil
	end

	local cx = centerItem.x
	local cy = centerItem.y

	local result = {}
	for i, coord in ipairs(aroundDirections) do 
		local tempItem = getItemAt(cy + coord.y, cx + coord.x);
		local tempBoard = getBoardAt(cy + coord.y, cx + coord.x)

		if tempItem 
			and not tempItem.isEmpty
			and tempItem:isAvailable()
			and tempItem.beEffectByMimosa ~= GameItemType.kKindMimosa -- 不能跳到含羞草的藤曼上
			and tempItem.ItemType ~= GameItemType.kBlackCuteBall
			and tempItem.ItemType ~= GameItemType.kBigMonster
			and tempItem.ItemType ~= GameItemType.kBigMonsterFrosting
			and tempItem.ItemType ~= GameItemType.kSuperBlocker
			and not tempItem:hasFurball()
			and tempBoard.tileBlockType ~= 1 -- 翻转地块
			and not tempBoard.isMoveTile -- 移动地格
			and not tempBoard:hasSuperCuteBall() 
			and tempBoard.transType == TransmissionType.kNone -- 传送带
			and not mainLogic:hasChainInNeighbors(cy, cx, cy + coord.y, cx + coord.x) then
			table.insert(result, tempItem)
		end
	end

	return result
end

function GameExtandPlayLogic:checkSuperCuteBallTransfer(mainLogic, callback)
	local count = 0
	local boardmap = mainLogic.boardmap
	local superCuteBoardList = {}
	for r = 1, #boardmap do
		for c = 1, #boardmap[r] do
			local board = boardmap[r][c]
			if board and board.isUsed and board:hasSuperCuteBall() and board.superCuteState == GameItemSuperCuteBallState.kActive then
				table.insert(superCuteBoardList, board)
			end
		end
	end	
	if #superCuteBoardList > 0 then
		for _, board in pairs(superCuteBoardList) do
			local item = mainLogic.gameItemMap[board.y][board.x]
			local validAroundItems = GameExtandPlayLogic:getSuperCuteValidAroundItems(mainLogic, item)
			if #validAroundItems > 0 then
				local targetItem = validAroundItems[mainLogic.randFactory:rand(1, #validAroundItems)]
				local targetBoard = mainLogic.boardmap[targetItem.y][targetItem.x]

				targetBoard.superCuteState = board.superCuteState
				targetItem.beEffectBySuperCute = true

				board.superCuteState = GameItemSuperCuteBallState.kNone
				item.beEffectBySuperCute = false

				mainLogic:checkItemBlock(item.y,item.x)
				mainLogic:checkItemBlock(targetItem.y,targetItem.x)
				mainLogic:addNeedCheckMatchPoint(item.y,item.x)

				count = count + 1
				local transferAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_SuperCute_Transfer,
					IntCoord:create(item.y,item.x),				
					IntCoord:create(targetItem.y,targetItem.x),				
					GamePlayConfig_MaxAction_time)
				transferAction.completeCallback = callback
				mainLogic:addGameAction(transferAction)
			end 
		end
	end
	return count
end
