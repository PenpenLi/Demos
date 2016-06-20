




-- 处理所有buff
require (BATTLE_CLASS_NAME.class)
local BAForRunAllBuffByTimeAction = class("BAForRunAllBuffByTimeAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForRunAllBuffByTimeAction.buffList 			= nil -- BattleBuffsInfo
 	BAForRunAllBuffByTimeAction.timeType 			= nil
 	
 	BAForRunAllBuffByTimeAction.total				= 0
 	BAForRunAllBuffByTimeAction.current 			= 0
 	------------------ functions -----------------------
 	
 	function BAForRunAllBuffByTimeAction:start( ... )
 		if(self.buffList ~= nil and self.timeType ~= nil) then
 			-- --print(" BAForRunAllBuffByTimeAction:start has buff")
 			self.total				= 0
 			self.current			= 0
 			for k,battleBuffsInfo in pairs(self.buffList) do
 				self.total			= self.total + 1
 				local targetid 		= battleBuffsInfo.id
 				local targetData 	= BattleMainData.fightRecord:getTargetData(targetid)
 				if(targetData) then
 					-- --print("start buff current:" , targetid)
 					targetData:pushBuffInfo(battleBuffsInfo,self.timeType,self,self.onActionComplete)
 				else
 					error("BAForRunAllBuffByTimeAction:start can't find:",targetid)
 				end
 			end
 			-- --print("BAForRunAllBuffByTimeAction has buff:",self.total)
 		else
 			-- --print("BAForRunAllBuffByTimeAction none: blist ",self.buffList," time:self.timeType",self.timeType)
 			self:complete()
 		end
 	end -- function end

 	function BAForRunAllBuffByTimeAction:onActionComplete()
 		self.current				= self.current	+  1
 		--print("time buff handleComplete: current:," , self.current, 
 				-- " total:",self.total ,
 				-- " time:",self.timeType)
 		if(self.current >= self.total) then
 			-- --print(" BAForRunAllBuffByTimeAction complete")
 			self:complete()
 		end
 	end
 	

 return BAForRunAllBuffByTimeAction