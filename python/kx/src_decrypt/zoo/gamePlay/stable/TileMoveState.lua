TileMoveState = class(BaseStableState)

function TileMoveState:ctor()
end

function TileMoveState:create(context)
	local v = TileMoveState.new()
	v.context = context
	v.mainLogic = context.mainLogic
	v.boardView = v.mainLogic.boardView
	v.moveTileCount = 0

	v.actionList = {}
	return v
end

function TileMoveState:dispose()
	BaseStableState.dispose(self)
end

function TileMoveState:update(dt)
	BaseStableState.update(self, dt)

	for k, v in pairs(self.actionList) do
		self:runActionLogic(self.mainLogic, v, k)
		self:runActionView(self.mainLogic.boardView, v)
	end
end

function TileMoveState:runActionLogic(mainLogic, theAction, actid)
	if theAction.addInfo == "over" or theAction.actionStatus == GameActionStatus.kWaitingForDeath then
		self.actionList[actid] = nil
		if theAction.completeCallback then theAction.completeCallback() end
	else
		if theAction.actionStatus == GameActionStatus.kRunning then 		---running阶段，自动扣时间，到时间了，进入Death阶段
			if theAction.actionDuring < 0 then 
				theAction.actionStatus = GameActionStatus.kWaitingForDeath
			else
				theAction.actionDuring = theAction.actionDuring - 1
			end
		elseif theAction.actionStatus == GameActionStatus.kWaitingForStart then
			local fr, fc = theAction.ItemPos1.x, theAction.ItemPos1.y
			local tr, tc = theAction.ItemPos2.x, theAction.ItemPos2.y

			local fromBoardData = theAction.boardData
			local fromItemData = theAction.itemData
			self.mainLogic.boardmap[tr][tc]:copyDatasFrom(fromBoardData)
			self.mainLogic.gameItemMap[tr][tc]:copyDatasFrom(fromItemData)

			if not self.targetPositions[fr.."_"..fc] then
				self.mainLogic.boardmap[fr][fc]:resetDatas()
				self.mainLogic.gameItemMap[fr][fc]:resetDatas()
			end

			if not fromItemData.isBlock and not fromBoardData.isBlock then
				self.mainLogic:setTileMoved()
			end
			self.mainLogic:addNeedCheckMatchPoint(tr, tc)
		end
	end
end

function TileMoveState:runActionView(boardView, theAction)
	if theAction.actionStatus == GameActionStatus.kWaitingForStart then
		theAction.actionStatus = GameActionStatus.kRunning

		local fr, fc = theAction.ItemPos1.x, theAction.ItemPos1.y
		local tr, tc = theAction.ItemPos2.x, theAction.ItemPos2.y

		local prePoints = nil
		local totalMoveSteps = 0
		for _, v in ipairs(theAction.movePointList) do
			if prePoints then
				totalMoveSteps = totalMoveSteps + math.abs(v.x - prePoints.x) + math.abs(v.y - prePoints.y)
			end
			prePoints = v
		end	
		if totalMoveSteps < 1 then return end

		local datas = {}
		ItemView.copyDatasFrom(datas, boardView.baseMap[fr][fc])

		local fromItem = boardView.baseMap[fr][fc]
		local toItem = boardView.baseMap[tr][tc]
		local moveDataList = {}
		local timePerStep = 0.8 / totalMoveSteps
		prePoints = nil
		for _, v in ipairs(theAction.movePointList) do
			if prePoints then
				local moveStep = math.abs(v.x - prePoints.x) + math.abs(v.y - prePoints.y)	
				table.insert(moveDataList, {time = timePerStep * moveStep, pos = fromItem:getBasePosition(v.y, v.x)})
			else
				table.insert(moveDataList, {time = 0, pos = fromItem:getBasePosition(v.y, v.x)})
			end
			prePoints = v
		end	

		local function onMoveFinishCallback()			
			toItem:removeBoardViewTranscontainer()
    		toItem:upDatePosBoardDataPos(self.mainLogic.gameItemMap[tr][tc], true)
			toItem.isNeedUpdate = true

			theAction.addInfo = "over"
		end
		toItem:playTileMoveAnimation(fromItem:getBoardViewTransContainer(), moveDataList, onMoveFinishCallback)
		fromItem:removeBoardViewTranscontainer()
	end
end

function TileMoveState:onEnter()
    BaseStableState.onEnter(self)
    self.moveTileCount = 0
    self.targetPositions = {}
    self.moveTiles = {}
    local boardmap = self.mainLogic.boardmap or {}
  	for r = 1, #boardmap do 
    	for c = 1, #boardmap[r] do 
    		local board = boardmap[r][c]
            if board and board.isMoveTile then
            	if board:checkTileCanMove() then
            		board:resetMoveTileData()

            		local routeMeta = board.tileMoveMeta:findRouteByPos(r, c, board.tileMoveReverse)
            		if not routeMeta then return end

            		local canTurn = true -- 是否可以拐弯
            		local movePointList = {}
            		table.insert(movePointList, IntCoord:create(r, c))
            		local tr, tc, leftStep = routeMeta:moveWithStep(r, c, board.tileMoveMeta.step, board.tileMoveReverse)
            		table.insert(movePointList, IntCoord:create(tr, tc))
            		while leftStep > 0 do
            			local nextRouteMeta = nil
            			if board.tileMoveReverse then nextRouteMeta = routeMeta.pre else nextRouteMeta = routeMeta.next end
            			if nextRouteMeta and (canTurn or nextRouteMeta:getDirection() == routeMeta:getDirection()) then
            				tr, tc, leftStep = nextRouteMeta:moveWithStep(tr, tc, leftStep, board.tileMoveReverse)
            				table.insert(movePointList, IntCoord:create(tr, tc))
            				routeMeta = nextRouteMeta
            			else
            				break
            			end
            		end
            		if routeMeta:isFinalPos(tr, tc, board.tileMoveReverse) then
            			board.tileMoveReverse = not board.tileMoveReverse
            		end

            		self.targetPositions[tr.."_"..tc] = true
            		self.moveTiles[r.."_"..c] = {tr, tc}

            		self.moveTileCount = self.moveTileCount + 1

        			local action = GameBoardActionDataSet:createAs(
						GameActionTargetType.kGameBoardAction,
						GameBoardActionType.kTileMove,
						IntCoord:create(r, c),
						IntCoord:create(tr, tc),
						GamePlayConfig_MaxAction_time)

        			local function completeCallback() 
        				self.moveTileCount = self.moveTileCount - 1

						if self.moveTileCount <= 0 then
							self:updatePortals()
							-- self.mainLogic:testEmpty()
					    	self.nextState = self:getNextState()
    						self.mainLogic:setNeedCheckFalling()
						end
        			end
        			action.completeCallback = completeCallback
        			action.itemData = self.mainLogic.gameItemMap[r][c]:copy()
        			action.boardData = board:copy()
        			action.movePointList = movePointList

        			self.actionList[#self.actionList + 1] = action
            	end
            end
    	end
    end
    if self.moveTileCount <= 0 then
		-- self.mainLogic:testEmpty()
    	self.nextState = self:getNextState()
	end
end

function TileMoveState:updatePortals()
	for fromPos, toPos in pairs(self.moveTiles) do
		local tr = toPos[1]
		local tc = toPos[2]
		local newBoard = self.mainLogic.boardmap[tr][tc]
		local newBoard = self.mainLogic.boardmap[tr][tc]
		if newBoard:hasEnterPortal() then
			local exitPointX, exitPointY = newBoard.passExitPoint_x, newBoard.passExitPoint_y
			local newPoint = self.moveTiles[exitPointX.."_"..exitPointY] 
			if newPoint then
				exitPointX, exitPointY = newPoint[1], newPoint[2]
			end
			local exitPortalBoard = self.mainLogic.boardmap[exitPointX][exitPointY]
			exitPortalBoard.passEnterPoint_x = tr
			exitPortalBoard.passEnterPoint_y = tc
		end
		if newBoard:hasExitPortal() then
			local enterPointX, enterPointY = newBoard.passEnterPoint_x, newBoard.passEnterPoint_y
			local newPoint = self.moveTiles[enterPointX.."_"..enterPointY] 
			if newPoint then
				enterPointX, enterPointY = newPoint[1], newPoint[2]
			end
			local enterPortalBoard = self.mainLogic.boardmap[enterPointX][enterPointY]
			enterPortalBoard.passExitPoint_x = tr
			enterPortalBoard.passExitPoint_y = tc
		end
	end
end

function TileMoveState:onExit()
    BaseStableState.onExit(self)
    self.nextState = nil
end

function TileMoveState:checkTransition()
	return self.nextState
end

function TileMoveState:getNextState()
	return self.context.magicLampCastingStateInSwapFirst
end

function TileMoveState:getClassName()
	return "TileMoveState"
end