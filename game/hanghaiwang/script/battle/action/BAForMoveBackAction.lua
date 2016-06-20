

-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForMoveBackAction = class("BAForMoveBackAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForMoveBackAction.targetUI						= nil

	
	BAForMoveBackAction.xMoved 							= nil --
	BAForMoveBackAction.yMoved 							= nil --
	BAForMoveBackAction.xMoveDistance					= nil
	BAForMoveBackAction.yMoveDistance					= nil
	BAForMoveBackAction.moveCostTime 					= nil -- 移动花费时间
	------------------ functions -----------------------
 	function BAForMoveBackAction:start()
 		--print("BAForMoveBackAction:start")
		if(self.targetUI ~= nil and self.targetUI:isMoved()) then 
			local from = ccp(self.targetUI:getPositionX(),
							 self.targetUI:getPositionY())
			local toPostion = ccp(self.targetUI.rawPositon.x,
								  self.targetUI.rawPositon.y)
			-- self.action = require(BATTLE_CLASS_NAME.BaseActionForMoveTo).new()
			self.xMoveDistance = toPostion.x - from.x
			self.yMoveDistance = toPostion.y - from.y

			local notMove = false
				if self.xMoveDistance == nil then
					self.xMoveDistance = 0
				end

				if self.yMoveDistance == nil then
					self.yMoveDistance = 0
				end
				if self.xMoveDistance == 0 and self.yMoveDistance == 0 then
					notMove				= true
					-- --print("moveto distance is 0")
				end
			
			-- 如果需要移动
			if notMove == false then
				-- --print("start move")
				self.costTime									= 0
				self.xMoved 									= 0
				self.yMoved 									= 0

				self.xRaw										= self.targetUI:getPositionX()
				self.yRaw										= self.targetUI:getPositionY()

				if(self.moveCostTime == nil) then
					self.totalTime								= BATTLE_CONST.MOVE_TO_COST_TIME
					local dis	= math.sqrt(self.xMoveDistance * self.xMoveDistance + self.yMoveDistance * self.yMoveDistance)
					self.totalTime								= 0.01 + dis/2100
				else
					self.totalTime 								= self.moveCostTime
				end
				 
				self:addToRender()
 
			-- 如果不需要移动
			else
				self:complete()					-- 执行完毕回调
			end

		else
			self:complete()
		end
		
	end

	function BAForMoveBackAction:update( dt )


		local movePercent 		= dt/self.totalTime
		--保留1位小数
		local dx 				= math.ceil(self.xMoveDistance * movePercent * 10)/10
		local dy 				= math.ceil(self.yMoveDistance * movePercent * 10)/10
		-- --print("BaseActionForMoveTo:update:",dx,",",dy)
		self.costTime 			= self.costTime + dt -- 总消耗时间可以用来做差值，简单起见 做了匀速 所以暂时不需要了

		--如果没移动完成
		if self.costTime  < self.totalTime then

				self.xMoved = self.xMoved + dx
				self.yMoved = self.yMoved + dy

				self.targetUI:moveBy(
										dx,
										dy
									)
		-- 移动完成
		else
				self.targetUI:setPosition(
											self.xRaw + self.xMoveDistance,
											self.yRaw + self.yMoveDistance
										)
 
				
				self:runCompleteCall("BaseActionForMoveTo moveComplete!!!")
				self:removeFromRender()
 
		end
	
	end
return BAForMoveBackAction