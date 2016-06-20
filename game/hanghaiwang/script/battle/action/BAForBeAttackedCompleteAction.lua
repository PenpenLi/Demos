
-- 检测被攻击的人是否处于idle状态
require (BATTLE_CLASS_NAME.class)
local BAForBeAttackedCompleteAction = class("BAForBeAttackedCompleteAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForBeAttackedCompleteAction.targets 				= nil
 	
 	BAForBeAttackedCompleteAction.total 				= 0
 	BAForBeAttackedCompleteAction.current 				= 0
 	------------------ functions -----------------------
 	function BAForBeAttackedCompleteAction:start( ... )
 		-- Logger.debug("************ BAForBeAttackedCompleteAction start:" .. self:instanceName())
 		-- if(BattleMainData.skillHandle) then
 		-- 	-- Logger.debug("************ BAForBeAttackedCompleteAction start:1");
 		-- 	self:checkSkillHandle()
 		-- else
 		-- 	-- Logger.debug("************ BAForBeAttackedCompleteAction start:2");
 		-- 	self:checkTargets()
 		-- end
 		self:addToRender()
 	end
 	function BAForBeAttackedCompleteAction:checkSkillHandle( ... )
 			if(BattleMainData.skillHandle) then
 				BattleMainData.skillHandle:addCallBacker(self,self.checkTargets)
 			end
 	end
 	function BAForBeAttackedCompleteAction:update( dt )
 		
	 		if(self.attacker ~= nil and self.attacker:isIdle() == false) then
	 				return
	 		end
 			if(self.targets ~= nil) then
 			-- self.total 				= 0
 			 
	 			for k,target in pairs(self.targets) do
	 				local targetId = target.id

	 				local targetData 	= BattleMainData.fightRecord:getTargetData(targetId)
	 				if(targetData and targetData:isIdle() == false) then
	 					return 
	 				end -- if end
	 			end -- for end

 			-- Logger.debug("--BAForBeAttackedCompleteAction watch:"..self.total)
 			

 			-- if(self.total == 0) then 
 				-- --print("BAForBeAttackedCompleteAction:checkTargets -> don't have")
 				-- --print("************ BAForBeAttackedCompleteAction start ->complete:",self:instanceName())
 			
 			-- else
 				-- --print("BAForBeAttackedCompleteAction:checkTargets:",self.total)
 			-- end -- if end

 			  --  self.delay = require(BATTLE_CLASS_NAME.BAForDelayAction).new()
			   -- self.delay.total = 15
			   -- self.delay:addCallBacker(self,self.onDelayComplete)
			   -- self.delay:start()

 		-- else
 			--print("self.targets is nil")
 			-- self:complete()
 		end

 		self:complete()
 	end
 	function BAForBeAttackedCompleteAction:checkTargets( ... )
 		
 		if(self.targets ~= nil) then
 			self.total 				= 0
 			self.current 			= 0
 			for k,target in pairs(self.targets) do
 				local targetId = target.id

 				local targetData 	= BattleMainData.fightRecord:getTargetData(targetId)
 				if(targetData and targetData:isIdle() == false) then
 					self.total 		= self.total + 1
 					targetData:addQueueCallBacker(self,self.onActionComplete)

 				end -- if end
 			end -- for end

 			-- Logger.debug("--BAForBeAttackedCompleteAction watch:"..self.total)


 			if(self.total == 0) then 
 				-- --print("BAForBeAttackedCompleteAction:checkTargets -> don't have")
 				-- --print("************ BAForBeAttackedCompleteAction start ->complete:",self:instanceName())
 				self:complete()
 			else
 				-- --print("BAForBeAttackedCompleteAction:checkTargets:",self.total)
 			end -- if end

 			   self.delay = require(BATTLE_CLASS_NAME.BAForDelayAction).new()
			   self.delay.total = 15
			   self.delay:addCallBacker(self,self.onDelayComplete)
			   -- self.delay:start()

 		else
 			--print("self.targets is nil")
 			self:complete()
 		end
 	end

	function BAForBeAttackedCompleteAction:onDelayComplete( ... )
		if(self.disposed ~= true) then

			self.delay:release()
			local mes = "BAForBeAttackedCompleteAction action run out 600 frames:"
			error(mes)
		end

	end
 	function BAForBeAttackedCompleteAction:onActionComplete( ... )
 		Logger.debug("************ BAForBeAttackedCompleteAction:onActionComplete:" .. " state:" .. self.current .. "/" .. self.total)
 		-- self.delay:release()
 		self.current = self.current + 1
 		if(self.current >= self.total) then
 			self:complete()
 			self:release()
 		end
 	end

 	function BAForBeAttackedCompleteAction:release( ... )
 		self.super.release(self)
 		self.targets = nil
 	end
 return BAForBeAttackedCompleteAction