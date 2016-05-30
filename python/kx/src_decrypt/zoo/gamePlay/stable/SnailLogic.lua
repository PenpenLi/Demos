SnailLogic = class()
function SnailLogic:create( context )
	-- body
	local v = SnailLogic.new()
	v.context = context
	v.mainLogic = context.mainLogic  --gameboardlogic
	v.boardView = v.mainLogic.boardView
	return v
end

function SnailLogic:check()
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Snail Logic enter")


	local function callback( ... )
		-- body
		self:handComplete();
	end

	self.hasItemToHandle = false
	self.completeItem = 0
	self.totalItem = 0
	if not self.mainLogic.snailMark then   
		self:handComplete()
		return self.totalItem
	end

	self.totalItem = self:checkSnailList( callback)
	if self.totalItem == 0 then
		self:handComplete()
	else
		self.hasItemToHandle = true
	end
	return self.totalItem
end

function SnailLogic:checkSnailList( callback )
	-- body
	local itemMap = self.mainLogic.gameItemMap
	local count = 0
	local actions = {}
	for r = 1, #itemMap do 
		for c = 1, #itemMap[r] do 
			local item = itemMap[r][c]
			if item  and item.isSnail and item:isAvailable() then
				
				local list = self:getMoveList(r, c)
				if #list > 0 then
					count = count + 1
					action = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameItemAction,
						GameItemActionType.kItem_Snail_Move,
						IntCoord:create(r,c),	
						nil,	
						GamePlayConfig_MaxAction_time)
					action.moveList = list
					action.completeCallback = callback
					action.direction = item.snailRoadType
					table.insert(actions, action)
				end
			end
		end
	end

	local function sortAction( b, a )
		-- body
		for k, v in ipairs(a.moveList) do 
			if v.x == b.ItemPos1.x and v.y == b.ItemPos1.y then 
				return true 
			end
		end
		return false
	end

	table.sort(actions, sortAction)

	for k, v in ipairs(actions) do 
		self.mainLogic:addDestructionPlanAction(v)
	end
	if count > 0 then 
		self.mainLogic:setNeedCheckFalling()
	end
	return count
end

function SnailLogic:checkItemCanMove( prePos, nextpos )
	-- body
	if not self.mainLogic.gameItemMap[nextpos.x] then return false end
	local nextItem = self.mainLogic.gameItemMap[nextpos.x][nextpos.y]
	if nextItem and nextItem.ItemType ~= GameItemType.kCoin 
		and  nextItem.ItemType ~= GameItemType.kBlackCuteBall 
		and  nextItem.ItemType ~= GameItemType.kIngredient
		and  nextItem.ItemType ~= GameItemType.kMagicLamp
		and  nextItem.ItemType ~= GameItemType.kWukong
		and  nextItem.ItemType ~= GameItemType.kHoneyBottle
		and  nextItem.ItemType ~= GameItemType.kTotems
		and  nextItem.ItemType ~= GameItemType.kCrystalStone
		and  nextItem.ItemType ~= GameItemType.kDrip
		and  nextItem.venomLevel == 0
		and not nextItem:hasLock()
		and not nextItem:hasFurball()
		and not self.mainLogic:hasChainInNeighbors(prePos.x, prePos.y, nextpos.x, nextpos.y)
		then 
		return true
	end
	return false
end

function SnailLogic:getMoveList( r, c, isOnlyCheck )
	-- body
	local list = {}
	local item = self.mainLogic.gameItemMap[r][c]
	local board = self.mainLogic.boardmap[r][c]
	local prePos = IntCoord:create(r, c)
	local nextpos = board:getNextSnailRoad()
	local nextboard  = nil
	if nextpos and self:checkItemCanMove(prePos, nextpos) then
		local nextboard = self.mainLogic.boardmap[nextpos.x][nextpos.y]
		local nextItem = self.mainLogic.gameItemMap[nextpos.x][nextpos.y]
		while nextItem.isSnail and not self.mainLogic:hasChainInNeighbors(prePos.x, prePos.y, nextpos.x, nextpos.y) do  -- 处理连续的蜗牛
			table.insert(list, nextpos)
			prePos = nextpos
			nextpos = nextboard:getNextSnailRoad()
			nextItem = self.mainLogic.gameItemMap[nextpos.x][nextpos.y]
			nextboard = self.mainLogic.boardmap[nextpos.x][nextpos.y]
		end
		local combSnailCount = #list

		local isArriveCollection = false
		while nextboard and nextboard.isSnailRoadBright and self:checkItemCanMove(prePos, nextpos) do       ---连续的路径
			table.insert(list, nextpos)
			local item = self.mainLogic.gameItemMap[nextpos.x][nextpos.y]
			if not isOnlyCheck then
				item.snailTarget = true
				self.mainLogic:checkItemBlock(nextpos.x, nextpos.y)
			end
			
			
			if nextboard.isSnailCollect then 
				isArriveCollection = true
			end
			prePos = nextpos
			nextpos = nextboard:getNextSnailRoad()

			if nextpos and self:checkItemCanMove(prePos, nextpos) then
				nextboard = self.mainLogic.boardmap[nextpos.x][nextpos.y]
			else
				nextboard = nil
			end
		end

		if not isArriveCollection then
			for k = 1, combSnailCount do 
				table.remove(list, #list)
			end
		end
	end
	return list
end

function SnailLogic:hasSnailToMove( ... )
	-- body
	local itemMap = self.mainLogic.gameItemMap
	local count = 0
	local actions = {}
	for r = 1, #itemMap do 
		for c = 1, #itemMap[r] do 
			local item = itemMap[r][c]
			if item  and item.isSnail and item:isAvailable() then
				
				local list = self:getMoveList(r, c, true)
				if #list > 0 then
					return true
				end
			end
		end
	end
	return false
end

function SnailLogic:handComplete( ... )
	-- body
	self.completeItem = self.completeItem + 1 
	if self.completeItem >= self.totalItem then
		if not self:hasSnailToMove() then
			self:resetAllSnailRoad()
		end
	end
end

function SnailLogic:resetSnailRoadAtPos( mainLogic, r, c )
	-- body
	mainLogic.boardmap[r][c].isSnailRoadBright = false
	mainLogic.boardView.baseMap[r][c]:playSnailRoadChangeState(false)
end

function SnailLogic:resetAllSnailRoad( ... )
	-- body
	local boardmap = self.mainLogic.boardmap 
	for r = 1, #boardmap do 
		for c = 1, #boardmap[r] do 
			if boardmap[r][c].isSnailRoadBright then
				self:resetSnailRoadAtPos(self.mainLogic, r, c)
			end
		end
	end

end

function SnailLogic:SpecialCoverSnailRoadAtPos( mainLogic, r, c )
	-- body
	if SnailLogic:canEffectSnailRoadAt(mainLogic, r, c) then
		SnailLogic:doEffectSnailRoadAtPos(mainLogic, r, c)
	end

end

function SnailLogic:canEffectSnailRoadAt( mainLogic, r, c )
	-- body
	if not mainLogic:isPosValid(r, c) then
		return false
	end
	local board = mainLogic.boardmap[r][c]
	local item = mainLogic.gameItemMap[r][c]
	if board.snailRoadViewType and (board.snailRoadViewType ==  TileRoadType.kLine 
		or board.snailRoadViewType ==  TileRoadType.kCorner
		or board.snailRoadViewType ==  TileRoadType.kEndPoint ) then
		if item and item.isUsed 
			and not item:hasFurball() 
			and not item:hasLock() 
			and item:isAvailable()
			and item.ItemType ~= GameItemType.kMagicLamp
			and item.ItemType ~= GameItemType.kWukong
			and item.ItemType ~= GameItemType.kTotems
			and not (item.ItemType == GameItemType.kBottleBlocker and item.bottleLevel > 0) -- 瓶子怪
			-- and not item.isEmpty  
			then
			return true
		end
	end
	return false
end

function SnailLogic:doEffectSnailRoadAtPos( mainLogic, r, c )
	-- body
	local item = mainLogic.gameItemMap[r][c]
	local board = mainLogic.boardmap[r][c]

	if mainLogic.theGamePlayType == GamePlayType.kHedgehogDigEndless then
		if board.hedgeRoadState == HedgeRoadState.kStop then
			board:changeHedgehogRoadState(HedgeRoadState.kPass)
			local action = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Hedgehog_Road_State,
				IntCoord:create(r,c),	
				nil,	
				GamePlayConfig_MaxAction_time)
			action.hedgeRoadState = board.hedgeRoadState
			mainLogic:addGameAction(action)
		end
	else
		if not board.isSnailRoadBright then
			board.isSnailRoadBright = true
			local action = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItem_Snail_Road_Bright,
				IntCoord:create(r,c),	
				nil,	
				GamePlayConfig_MaxAction_time)
			mainLogic:addGameAction(action)
		end
	end

	
end
