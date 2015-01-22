GameExtandPlayLogic = class{}

-----返回true，成功发起颜色变化
function GameExtandPlayLogic:checkCrystalChangeColor(mainLogic, completeCallback)
	local ret = 0
	local crystalBalls = self:filterItemByConditions(mainLogic, { gameItemTypeList = { GameItemType.kCrystal } })
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

	local retryTimes = 1
	local cloneFlag = false
	local success = false 
	while retryTimes < 500 do
		for i, item in ipairs(crystalBalls) do
			local possibleColor = getPossibleChangeColor(originColorMatrix[item.y][item.x])
			
			if #possibleColor > 0 then
				local index = mainLogic.randFactory:rand(1, #possibleColor)
				item.ItemColorType = possibleColor[index]
			end
		end
		
		if not checkHasMatchQuick() then
			if not cloneFlag then
				-- print("record fail color matrix times : ", retryTimes)
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
			end
		end
		retryTimes = retryTimes + 1
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
					and (v.item.ItemSpecialType >= AnimalTypeConfig.kLine and v.item.ItemSpecialType <= AnimalTypeConfig.kColor)
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

	local ret = {}
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if isGameItemType(item, conditions.gameItemTypeList) 
				and isGameItemFurballType(item, conditions.furballTypeList)
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

	local cx = centerItem.x
	local cy = centerItem.y

	local result = {}
	local tempItem = nil
	for i, coord in ipairs(aroundDirections) do 
		tempItem = getItemAt(cy + coord.y, cx + coord.x);
		if tempItem 
			and (tempItem.ItemType == GameItemType.kAnimal 
				or tempItem.ItemType == GameItemType.kGift 
				or tempItem.ItemType == GameItemType.kAddTime
				or tempItem.ItemType == GameItemType.kCrystal)
			and not tempItem:hasFurball() 
			and not tempItem.isBlock 
			and tempItem:canBeMatch() then
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

function GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)
	local gameItem = mainLogic.gameItemMap[r][c]
	if gameItem.ItemType == GameItemType.kAnimal and mainLogic.gameMode:is(HalloweenMode) and mainLogic:getHalloweenBoss() then
		local boardItem = mainLogic.boardmap[r][c]
		if boardItem and boardItem.magicTileId ~= nil then
			local action = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Magic_Tile_Hit,
					IntCoord:create(r,c),
					nil,
					GamePlayConfig_MaxAction_time
				)
			if gameItem.ItemSpecialType >= AnimalTypeConfig.kLine and gameItem.ItemSpecialType <= AnimalTypeConfig.kColor then
				action.count = mainLogic:getHalloweenBoss().specialHit
			else
				action.count = mainLogic:getHalloweenBoss().normalHit
			end
			action.magicTileId = boardItem.magicTileId
			mainLogic:addGameAction(action)
		end
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
		elseif mainLogic.theGamePlayType == GamePlayType.kMaydayEndless
		or mainLogic.theGamePlayType == GamePlayType.kHalloween then
			mainLogic.digJewelCount:setValue(mainLogic.digJewelCount:getValue() + 1)
			if mainLogic.PlayUIDelegate then
				local position = mainLogic:getGameItemPosInView(r, c)
				mainLogic.PlayUIDelegate:setTargetNumber(0, 0, mainLogic.digJewelCount:getValue(), position)
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
			if itemdata:isAvailable() and itemdata.ItemType == GameItemType.kBalloon then
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
function GameExtandPlayLogic:decreaseDigGround( mainLogic, r, c, scoreScale )
	-- body
	scoreScale = scoreScale or 1
	local item = mainLogic.gameItemMap[r][c]
	item.digGroundLevel = item.digGroundLevel - 1

	if item.digGroundLevel == 0 then
		item:AddItemStatus(GameItemStatusType.kDestroy)
	end

	ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_DigGround * scoreScale)

	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r, c),
		nil,
		1)
	ScoreAction.addInt = GamePlayConfig_Score_MatchAt_DigGround * scoreScale
	mainLogic:addGameAction(ScoreAction)

	 local digGroudDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_DigGroundDec,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_GameItemDigGroundDeleteAction_CD)
	 mainLogic:addDestroyAction(digGroudDecAction)
end

--------------------
--宝石块削减一层
--------------------
function GameExtandPlayLogic:decreaseDigJewel( mainLogic, r, c, scoreScale )
	-- body
	scoreScale = scoreScale or 1
	local item = mainLogic.gameItemMap[r][c]
	item.digJewelLevel = item.digJewelLevel -1

	if item.digJewelLevel == 0 then
		item:AddItemStatus(GameItemStatusType.kDestroy)
	end

	ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_DigJewel * scoreScale)

	local ScoreAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemScore_Get,
		IntCoord:create(r, c),
		nil,
		1)
	ScoreAction.addInt = GamePlayConfig_Score_MatchAt_DigJewel * scoreScale
	mainLogic:addGameAction(ScoreAction)
	
	local digJewelDecAction = GameBoardActionDataSet:createAs(
	 		GameActionTargetType.kGameItemAction,
	 		GameItemActionType.kItem_DigJewleDec,
	 		IntCoord:create(r,c),
	 		nil,
	 		GamePlayConfig_GameItemDigJewelDeleteAction_CD)
	mainLogic:addDestroyAction(digJewelDecAction)
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
					local r_up = GameExtandPlayLogic:upstairsItemsByUfo( itemMap, r, c )
					local r_ufo_up = GameExtandPlayLogic:upstairsItemsByUfo( itemMap, r_ufo, c_ufo )
					if r_ufo_up < 0 then
						if r_up > 0 then r_ufo = r c_ufo = c end
					elseif r_up < r_ufo_up and r_up > 0 then 
						r_ufo = r c_ufo = c
					end
				end
			end
		end
	end
	return mainLogic:getGameItemPosInView(1, c_ufo)
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
-------------------
--check item can be effect by ufo
--------------------
function GameExtandPlayLogic:checkUFOItemUpdate( mainLogic, completeCallback )
	-- body
	local item_count = 0
	local item_top = false
	if mainLogic.gameMode:reachEndCondition(mainLogic) then ---产品的需求，如果达到胜利条件则 不再判断, 直接返回
		return item_count, item_top
	end
	if mainLogic.gameMode:is(RabbitWeeklyMode) and mainLogic.gameMode:isNeedChangeState(nil, false) then 
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
					and item:isAvailable() and item.rabbitState ~= GameItemRabbitState.kSpawn then

					local r_up, isTop, isShowDangerous = GameExtandPlayLogic:upstairsItemsByUfo( itemList_copy, r, c )
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
--------------------
--get upstairs r c  by ufo
--------------------
function GameExtandPlayLogic:upstairsItemsByUfo( itemList_copy, r, c )
	-- body
	local item = itemList_copy[r][c]
	local tempGoUpstairOneStep = r > 1 and itemList_copy[r-1][c]
	local tempGoUpstairTwoStep = r > 2 and itemList_copy[r-2][c]
	local canGoUpstairOneStep = tempGoUpstairOneStep and tempGoUpstairOneStep.isUsed 
							and not (tempGoUpstairOneStep:hasLock()
								or tempGoUpstairOneStep:hasFurball()
								or tempGoUpstairOneStep:canBeEffectByUFO()
								or tempGoUpstairOneStep.isBlock
								or tempGoUpstairOneStep.ItemType == GameItemType.kNone)
	local canGoUpstairTwoStep = tempGoUpstairTwoStep and tempGoUpstairTwoStep.isUsed
							 and not(--canGoUpstairOneStep or
								tempGoUpstairTwoStep:hasFurball()
								or tempGoUpstairTwoStep:hasLock()
								or tempGoUpstairTwoStep:canBeEffectByUFO()
								or tempGoUpstairTwoStep.isBlock
								or tempGoUpstairTwoStep.ItemType == GameItemType.kNone)
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
			if item:isAvailable() and not item:hasLock() and not item:hasFurball() then
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
	if item.ItemType == GameItemType.kMimosa and #item.mimosaHoldGrid > 0 and item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
		return r, c
	else
		for r1 = 1, #mainLogic.gameItemMap do 
			for c1 = 1, #mainLogic.gameItemMap[r1] do 
				local temp_item = mainLogic.gameItemMap[r1][c1]
				if temp_item and #temp_item.mimosaHoldGrid > 0 and temp_item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
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

function GameExtandPlayLogic:backMimosa(mainLogic, r, c, callback )
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
		action.direction = item.mimosaDirection
		item.mimosaLevel = 1
		mainLogic:setNeedCheckFalling()
		mainLogic:addDestroyAction(action)
	else
		if callback then callback() end
	end

end

function GameExtandPlayLogic:getMimosaToHoldGrid( mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	local rAdd, cAdd = 0, 0
	local result = nil
	if item and item.ItemType == GameItemType.kMimosa then
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

	if mainLogic.gameItemMap[grid.x] and mainLogic.gameItemMap[grid.x][grid.y] then
		local item_select = mainLogic.gameItemMap[grid.x][grid.y]
		if item_select and item_select.isUsed
			and not item_select.isEmpty
			and not item_select:hasFurball() 
			and not item_select:hasLock() 
			and item_select.ItemType ~= ItemType.kBlackCuteBall
			and item_select:isAvailable()
			and not item_select.isBlock
			or item_select.ItemType == GameItemType.kMagicLamp then
			result = grid
		end
	end
	return result
end

function GameExtandPlayLogic:updateMimosaToHoldGridList( mainLogic)
	-- body
	local itemMap = mainLogic.gameItemMap
	local result = {}
	for i = 1, GamePlayConfig_Mimosa_Grow_Grid_Num + 1 do 
		for r = #itemMap, 1, -1 do 
			if not result[r] then result[r] = {} end
			for c = #itemMap[r], 1, -1 do 
				local item = itemMap[r][c]
				if item and item.ItemType == GameItemType.kMimosa and item:isAvailable() 
					and item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
					local tryGrid = GameExtandPlayLogic:getMimosaToHoldGrid( mainLogic, r, c )
					if tryGrid then
						if i == 1 then
							item.isCanGrow = true
						else
							local item_select = itemMap[tryGrid.x][tryGrid.y]
							item_select.beEffectByMimosa = true
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

function GameExtandPlayLogic:checkMimosa( mainLogic, callback )
	-- body
	local count = 0
	local map = mainLogic.gameItemMap
	local addGridMap = GameExtandPlayLogic:updateMimosaToHoldGridList( mainLogic)
	for r = 1, #map do 
		for c = 1, #map[r] do
			local item = map[r][c]
			if item and item.ItemType == GameItemType.kMimosa and item:isAvailable() then
				if item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
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
						mainLogic:addGameAction(action)
						item.mimosaLevel = 1
						count = count + 1
					end
					item.isCanGrow = nil
				else 
					item.mimosaLevel = item.mimosaLevel + 1
					if item.mimosaLevel >= GamePlayConfig_Mimosa_Grow_Step then
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



function GameExtandPlayLogic:MaydayBossLoseBlood(mainLogic, r, c, isMatch , actid)
	
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
		local addScore = 100
		boss.digBlockCanbeDelete = false
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

		boss.blood = boss.blood - bloodLoseCount
		if boss.blood < 0 then boss.blood = 0 end
		local decAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItem_Mayday_Boss_Loss_Blood,
			IntCoord:create(boss_r, boss_c),
			nil,
			GamePlayConfig_MaxAction_time)
		decAction.addInt = boss.blood / boss.maxBlood
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
	--select item to run
	local brokenHoneyBottle = {}
	local canBeInfectItemList = {}
	for r = 1, #gameItemMap do 
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if item then 
				local intCoord = IntCoord:create(r, c)
				if item.honeyBottleLevel > 3 then
					table.insert(brokenHoneyBottle, intCoord)
				elseif item:canInfectByHoneyBottle() then
					table.insert(canBeInfectItemList, intCoord)
				end
			end 
		end
	end

	for k, v in pairs(brokenHoneyBottle) do 
		local infectList = {}
		for k = 1, mainLogic.honeys do 
			if #canBeInfectItemList > 0 then
				--todo
				local item = table.remove(canBeInfectItemList, mainLogic.randFactory:rand(1, #canBeInfectItemList))
				table.insert(infectList, item)
			end
		end
		ScoreCountLogic:addScoreToTotal(mainLogic, GamePlayConfig_Score_MatchAt_DigJewel)
		local ScoreAction = GameBoardActionDataSet:createAs(
			GameActionTargetType.kGameItemAction,
			GameItemActionType.kItemScore_Get,
			IntCoord:create(v.x, v.y),
			nil,
			1)
		ScoreAction.addInt = GamePlayConfig_Score_MatchAt_DigJewel
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

	mainLogic:tryDoOrderList(r, c, GameItemOrderType.kOthers, GameItemOrderType_Others.kHoney, 1)
	local honeyAction = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItemDestroy_HoneyDec,
		IntCoord:create(r,c),				
		nil,				
		GamePlayConfig_MaxAction_time)
	mainLogic:addDestroyAction(honeyAction)
	
end