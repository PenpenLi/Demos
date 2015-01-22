SeaAnimalCollectState = class(BaseStableState)


function SeaAnimalCollectState:create( context )
    -- body
    local v = SeaAnimalCollectState.new()
    v.context = context
    v.mainLogic = context.mainLogic  --gameboardlogic
    v.boardView = v.mainLogic.boardView
    return v
end

function SeaAnimalCollectState:update( ... )
    -- body
end

function SeaAnimalCollectState:onEnter()
    print("---------->>>>>>>>>> SeaAnimalCollectState enter")
    if not self.mainLogic.gameMode:is(SeaOrderMode) then
    	return 0
    end

    return self:tryCollect()

end


function SeaAnimalCollectState:handleComplete()
    self.mainLogic:setNeedCheckFalling();
end

function SeaAnimalCollectState:onExit()
    print("----------<<<<<<<<<< SeaAnimalCollectState exit")
    self.nextState = nil
    self.hasItemToHandle = false
end

function SeaAnimalCollectState:checkTransition()
    print("-------------------------SeaAnimalCollectState checkTransition")
    return self.nextState
end

function SeaAnimalCollectState:tryCollect()
	local gameItemMap = self.mainLogic.gameItemMap
	local boardMap = self.mainLogic.boardmap
	local seaAnimals = self.mainLogic.gameMode.allSeaAnimals
	if not seaAnimals then return 0 end
	local count = 0

	local callbackCount = 0
	local function callback()
		callbackCount = callbackCount + 1
		if callbackCount == count then
			self:handleComplete()
		end
	end

	for k, v in pairs(seaAnimals) do
		-- 判断动物上的冰是否都消除了
		if v.isFreed ~= true then

			local isFreed = true
			for r = v.y, v.yEnd do 
				for c = v.x, v.xEnd do
					if boardMap[r][c].iceLevel and boardMap[r][c].iceLevel > 0 then
						isFreed = false
						break
					end
				end
				if not isFreed then break end
			end

			-- isFreed = false -- test

			-- print(v.x, v.y, v.xEnd, v.yEnd, 'isFreed', isFreed)

			if isFreed then
				count = count + 1
				v.isFreed = true
				local destruction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItem_Area_Destruction,
					IntCoord:create(v.x, v.y),
					IntCoord:create(v.xEnd, v.yEnd),
					GamePlayConfig_MaxAction_time)
				destruction.completeCallback = callback
				self.mainLogic:addGameAction(destruction)

				local key1 = GameItemOrderType.kSeaAnimal
				local key2
				local rotation = 0
				local addScore = 0
				if v.type == SeaAnimalType.kPenguin then
					key2 = GameItemOrderType_SeaAnimal.kPenguin
					rotation = 0
					addScore = GamePlayConfig_SeaAnimal_Penguin_Score
				elseif v.type == SeaAnimalType.kPenguin_H then
					key2 = GameItemOrderType_SeaAnimal.kPenguin
					rotation = 90
					addScore = GamePlayConfig_SeaAnimal_Penguin_Score
				elseif v.type == SeaAnimalType.kSeaBear then
					key2 = GameItemOrderType_SeaAnimal.kSeaBear
					rotation = 0
					addScore = GamePlayConfig_SeaAnimal_Bear_Score
				elseif v.type == SeaAnimalType.kSeal then
					key2 = GameItemOrderType_SeaAnimal.kSeal
					rotation = 0
					addScore = GamePlayConfig_SeaAnimal_Seal_Score
				elseif v.type == SeaAnimalType.kSeal_V then 
					key2 = GameItemOrderType_SeaAnimal.kSeal
					rotation = -90
					addScore = GamePlayConfig_SeaAnimal_Seal_Score
				end
				self.mainLogic:tryDoOrderList(v.y,v.x,key1,key2,1, rotation)

				ScoreCountLogic:addScoreToTotal(self.mainLogic, addScore)

				local ScoreAction = GameBoardActionDataSet:createAs(
					GameActionTargetType.kGameItemAction,
					GameItemActionType.kItemScore_Get,
					IntCoord:create(v.x, v.y),
					nil,				
					1)
				ScoreAction.addInt = addScore
				ScoreAction.addInt2 = 2
				self.mainLogic:addGameAction(ScoreAction)

			end
		end
	end
	return count
end

