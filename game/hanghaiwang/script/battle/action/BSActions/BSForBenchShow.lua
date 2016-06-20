
-- BSTree 替补上场
local BSForBenchShow = class("BSForBenchShow",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BSForBenchShow.sequeue 						= nil 
	BSForBenchShow.showList 					= nil
 	BSForBenchShow.total						= nil
 	BSForBenchShow.current 						= nil
 	BSForBenchShow.activeQueue					= nil
	------------------ functions -----------------------
	function BSForBenchShow:start(data)
		self.activeQueue = false
		if(self.showList ~= nil and #self.showList > 0) then 

			self.total = 0
			self.current = 0
			self.sequeue			= require(BATTLE_CLASS_NAME.BSSpawn).new()
			for k,benchInfo in pairs(self.showList) do
				local action 		= require(BATTLE_CLASS_NAME.BAForBSAction).new()
				local blackBoard	= require(BATTLE_CLASS_NAME.BSBenchShowBB).new()
				local logic 		= BenchShowLogic.getLogicData()
				local old = BattleMainData.fightRecord:indexDataByIndexAndTeamid(benchInfo.pos,benchInfo.teamId)
				-- if(old) then
					self.total = self.total + 1
					blackBoard:reset(benchInfo.id,benchInfo.pos)
					action.blackBoard 	= blackBoard
					action.logicData 	= logic
					local benchData 	= BattleMainData.fightRecord:getTargetData(benchInfo.id)
					if(benchData) then
						-- benchData:addQueueCallBacker(self,self.onActionsComplete)
						action:addCallBacker(self,self.onActionsComplete)
						benchData:pushBSTAction(action)
					else
						error("BSForBenchShow error 未发现替补数据")
					end
					-- old:addQueueCallBacker(self,self.onActionsComplete)
					-- old:pushBSTAction(action)
				-- else
					-- print("== bench show new",self.total)
					-- self.sequeue:add(action)
					-- self.total = self.total + 1
					-- self.activeQueue = true
				-- end
				
				-- print("======")
				-- print_table("==",logic)
				
			end
			-- if(self.activeQueue) then
			-- self.sequeue:addCallBacker(self,self.onActionsComplete)
			-- self.sequeue:start()
			-- end
		else
			self:complete()
		end

	end

	-- function BSBenchShowBB:	
	
	function BSForBenchShow:onActionsComplete(data)
		self.current = self.current + 1
		-- print("------ function BSForBenchShow:onActionsComplete",self.current, #self.showList)
		if(self.current >= self.total) then
			if(self.disposed ~= true) then
				
				self:complete()
			end
		end
	end
	function BSForBenchShow:release( ... )
		 self.super.release(self)
		 if(self.sequeue) then
		 	self.sequeue:release()
		 	self.sequeue = nil
		 end
		 if(self.heroUI) then
		 	self.heroUI = nil
		 end
	end
return BSForBenchShow