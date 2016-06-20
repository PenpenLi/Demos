
require (BATTLE_CLASS_NAME.class)
local BaseActionForMoveTo = class("BaseActionForMoveTo",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
 	BaseActionForMoveTo.xMoved 							= nil --
	BaseActionForMoveTo.yMoved 							= nil --
	BaseActionForMoveTo.xRaw							= 0
	BaseActionForMoveTo.yRaw							= 0
	BaseActionForMoveTo.moveCostTime 					= nil -- 移动花费时间
	------------------ functions -----------------------
 

	function BaseActionForMoveTo:start(data)
		
		-- --print("************************ enter moveTo:",self:instanceName()," x->",self.blackBoard.xMoveDistance,
																				-- " y->",self.blackBoard.yMoveDistance,"data:",data)
		if self.blackBoard ~= nil and self.blackBoard.attackerUI ~= nil then

				local notMove = false
				if self.blackBoard.xMoveDistance == nil then
					self.blackBoard.xMoveDistance = 0
				end

				if self.blackBoard.yMoveDistance == nil then
					self.blackBoard.yMoveDistance = 0
				end
				if self.blackBoard.xMoveDistance == 0 and self.blackBoard.yMoveDistance == 0 then
					notMove						  = true
					-- --print("moveto distance is 0")
				end
			
			-- 如果需要移动
			if self.blackBoard.needMove == true and notMove == false then
				-- --print("start move")
				self.costTime									= 0
				self.xMoved 									= 0
				self.yMoved 									= 0
				if(self.moveCostTime == nil) then
					self.totalTime								= BATTLE_CONST.MOVE_TO_COST_TIME
				else
					self.totalTime 								= self.moveCostTime
				end
				local node 										= tolua.cast(self.blackBoard.attackerUI,"CCNode")
				self.xRaw										= self.blackBoard.attackerUI:getPositionX()
				self.yRaw										= self.blackBoard.attackerUI:getPositionY()
				-- --print("************************ startMove:",self:instanceName(),
 					-- " x->",self.blackBoard.attackerUI:getPositionX(),
 					-- " y->",self.blackBoard.attackerUI:getPositionY())
				self:addToRender()
				-- self.blackBoard.attackerUI:setLoop(false)getPositionY
				-- self.blackBoard.attackerUI:scale(2)
			-- 如果不需要移动
			else
				self:complete()					-- 执行完毕回调
			end

		end
	end

	function BaseActionForMoveTo:update( dt )


		local movePercent 									= dt/self.totalTime
		--保留1位小数
		local dx 											= math.ceil(self.blackBoard.xMoveDistance * movePercent * 10)/10
		local dy 											= math.ceil(self.blackBoard.yMoveDistance * movePercent * 10)/10
		-- --print("BaseActionForMoveTo:update:",dx,",",dy)
		self.costTime 										= self.costTime + dt -- 总消耗时间可以用来做差值，简单起见 做了匀速 所以暂时不需要了

		--如果没移动完成
		if self.costTime  < self.totalTime then

				self.xMoved = self.xMoved + dx
				self.yMoved = self.yMoved + dy

				self.blackBoard.attackerUI:moveBy(
													dx,
													dy
												)
		-- 移动完成
		else
				self.blackBoard.attackerUI:setPosition(
														self.xRaw + self.blackBoard.xMoveDistance,
														self.yRaw + self.blackBoard.yMoveDistance
													)
 				-- --print("************************ x will:",
 				-- 	(self.xRaw + self.blackBoard.xMoveDistance),
 				-- 	"y will:",(self.yRaw + self.blackBoard.yMoveDistance))
 				-- --print("************************ moveComplete:",self:instanceName(),
 					-- " x->",self.blackBoard.attackerUI:getPositionX(),
 					-- " y->",self.blackBoard.attackerUI:getPositionY())
 				self.blackBoard.xMoveDistance = self.blackBoard.xMoveDistance * -1
 				self.blackBoard.yMoveDistance = self.blackBoard.yMoveDistance * -1
				
				self:runCompleteCall("BaseActionForMoveTo moveComplete!!!")
				self:removeFromRender()
				-- BattleActionRender.removeAction(self)
				-- self.calllerBacker:runCompleteCallBack("BaseActionForMoveTo")
				--self:complete()					-- 执行完毕回调
		end
	
	end

return BaseActionForMoveTo