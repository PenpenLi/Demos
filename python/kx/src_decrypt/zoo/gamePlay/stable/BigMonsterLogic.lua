BigMonsterLogic = class()


function BigMonsterLogic:create( context )
	-- body
	local v = BigMonsterLogic.new()
	v.context = context
	v.mainLogic = context.mainLogic  --gameboardlogic
	v.boardView = v.mainLogic.boardView
	return v
end

function BigMonsterLogic:update( ... )
	-- body
end

function BigMonsterLogic:check()
	local function callback( ... )
		-- body
		self:handBigMonsterComplete();
	end

	self.hasItemToHandle = false
	self.completeItem = 0
	self.totalItem = self:checkMonsterList(self.mainLogic, callback)

	if self.totalItem == 0 then
		self:handBigMonsterComplete()
	else
		self.hasItemToHandle = true
	end
	return self.totalItem
end

function BigMonsterLogic:handBigMonsterComplete( ... )
	-- body
	self.completeItem = self.completeItem + 1 
	if self.completeItem >= self.totalItem then 
		if self.hasItemToHandle then
			self.mainLogic:setNeedCheckFalling();
		end
	end
end

function BigMonsterLogic:findTheMonster( mainLogic, r, c )
	-- body
	local result_r, result_c
	local item = mainLogic.gameItemMap[r][c]
	if item.bigMonsterFrostingType == 1 then 
		result_r = r
		result_c = c
	elseif item.bigMonsterFrostingType == 2 then
		result_r = r
		result_c = c-1
	elseif item.bigMonsterFrostingType == 3 then
		result_r = r - 1
		result_c = c
	elseif item.bigMonsterFrostingType == 4 then
		result_r = r - 1
		result_c = c - 1
	end
	return result_r, result_c
end

--随机消除4个item, 优先级 ice >　snow > animal(kCrystal) > special animal
function BigMonsterLogic:getMonsterEffectItems( mainLogic, monsterCount )
	-- body
	local randomDestoryCount = 4
	
	local gameItemMap = {}
	local boardMap = {}
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do 
			if not gameItemMap[r] then gameItemMap[r] = {} end
			gameItemMap[r][c] = mainLogic.gameItemMap[r][c]:copy()
		end
	end

	for r =1, #mainLogic.boardmap do 
		for c = 1, #mainLogic.boardmap[r] do
			if not boardMap[r] then boardMap[r] = {} end
			boardMap[r][c] = mainLogic.boardmap[r][c]:copy()
		end
	end


	local items = {}
	for k = 1, monsterCount do 
		local iceList = {}
		local snowList = {}
		local animalList = {}
		local specialAnimalList = {}
		for r = 1, #gameItemMap do 
			for c = 1, #gameItemMap[r] do 
				local item = gameItemMap[r][c]
				if item.bigMonsterFrostingType == 0 and item:isAvailable() then 
					local board = boardMap[r][c]
					if board.iceLevel > 0 and item.ItemType ~= GameItemType.kNone and not item.isBlock and not item:hasLock() then 
						table.insert(iceList, {r = r, c= c})
					elseif item.snowLevel > 0 then 
						table.insert(snowList, {r = r, c = c})
					elseif (item.ItemType == GameItemType.kAnimal  or item.ItemType == GameItemType.kCrystal )
						and not item:hasLock() 
						and not item:hasFurball()
						and item:isAvailable()
						and not item.isEmpty then
						
							if item.ItemSpecialType == 0 then 
								table.insert(animalList, {r = r, c = c})
							else 
								table.insert(specialAnimalList, {r = r, c = c})
							end
					end
				end
			end
		end

		local item_select
		for k = 1, randomDestoryCount do 
			if #iceList > 0 then 
				item_select = table.remove(iceList, math.random(1, #iceList))
				boardMap[item_select.r][item_select.c].iceLevel = boardMap[item_select.r][item_select.c].iceLevel - 1
				table.insert(items, item_select)
			elseif #snowList > 0 then 
				item_select = table.remove(snowList, math.random(1, #snowList))
				gameItemMap[item_select.r][item_select.c].snowLevel = gameItemMap[item_select.r][item_select.c].snowLevel - 1
				table.insert(items, item_select)
			elseif #animalList > 0 then 
				item_select = table.remove(animalList, math.random(1, #animalList))
				gameItemMap[item_select.r][item_select.c].isEmpty = true
				table.insert(items, item_select)
			elseif #specialAnimalList > 0 then
				item_select = table.remove(specialAnimalList, math.random(1, #specialAnimalList))
				gameItemMap[item_select.r][item_select.c].isEmpty = true
				table.insert(items, item_select)
			end
		end

	end

	local resultList = {}
	for k, v in pairs(items) do
		local has = false
		for k2, v2 in pairs(resultList) do 
			if v.r == v2.r and v.c == v2.c then
				has = true 
				v2.times = v2.times + 1
			end
		end
		if not has then 
			table.insert(resultList, {r = v.r, c = v.c, times = 1})
		end
	end

	for k,v in pairs(resultList) do 
		print(v.r, v.c, v.times, "-----------------")
	end
	return resultList
end

function BigMonsterLogic:checkMonsterList( mainLogic, callback )
	-- body
	local count = 0
	---------------------雪怪消除
	for r = 1,  #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			if item and item.ItemType == GameItemType.kBigMonster then 
				local totalStrength = item.bigMonsterFrostingStrength 
									+ mainLogic.gameItemMap[r][c+1].bigMonsterFrostingStrength
									+ mainLogic.gameItemMap[r+1][c].bigMonsterFrostingStrength
									+ mainLogic.gameItemMap[r+1][c+1].bigMonsterFrostingStrength
				if totalStrength <= 0 then
					
					count = count + 1

					ScoreCountLogic:addScoreToTotal(mainLogic,100)

					local ScoreAction = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItemScore_Get,
						IntCoord:create(r, c),
						nil,
						1)
					ScoreAction.addInt = 100
					mainLogic:addGameAction(ScoreAction)

					local action = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItem_Monster_Jump,
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
	
	if count == 0 then return 0 end                     ----------------------没有雪怪需要处理

	---------------------雪怪消除，产生的地震，
	local itemSelete = self:getMonsterEffectItems(mainLogic, count )
	for k, v in pairs(itemSelete) do 
		local actionDeleteByMonster = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItem_Monster_Destroy_Item,
						IntCoord:create(v.r, v.c),
						nil,
						GamePlayConfig_MaxAction_time
					)
		actionDeleteByMonster.completeCallback = callback
		actionDeleteByMonster.times = v.times
		mainLogic:addGameAction(actionDeleteByMonster)
	end
	return count + #itemSelete
end
