-- BSTree 伤害buff action
require (BATTLE_CLASS_NAME.class)
local BAForBSBuffDamageAction = class("BAForBSBuffDamageAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSBuffDamageAction.sequeue 					= nil 
	BAForBSBuffDamageAction.damageList 					= nil
	BAForBSBuffDamageAction.heroUI						= nil
	BAForBSBuffDamageAction.target						= nil
	BAForBSBuffDamageAction.delayBuffDamage				= nil
	--BAForBSBuffDamageAction.damageList 					= nil

	------------------ functions -----------------------
	function BAForBSBuffDamageAction:start(data)
		if(self.damageList ~= nil and #self.damageList > 0) then 
			-- Logger.debug("BAForBSBuffDamageAction 1")
			self.sequeue			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
			local total 			= #self.damageList
			local count 			= 1
			
			-- 应厕刷需求buff伤害要在手上文字播放完毕后再播放,所以这里加了一个延迟
			local BADelayTime    = require ("script/battle/action/ccActions/BADelayTime")
			
			if(self.delayBuffDamage == true) then
				local delay = BADelayTime:new(70)
				self.sequeue:push(delay)
			end

			for k,damageData in pairs(self.damageList) do
				-- 生成buffaction
				local action 		= require(BATTLE_CLASS_NAME.BAForBSAction).new()
				local blackBoard	= require(BATTLE_CLASS_NAME.BSBuffDamageBB).new()
				local logic 		= BuffDamageLogicData.getLogicData()
				blackBoard:reset(damageData)
				action.blackBoard 	= blackBoard
				action.logicData 	= logic
				-- if(count == total) then
				-- 	action:addCallBacker(self,self.onActionsComplete)
				-- end
				count = count + 1
				-- self.target:push(action)
				
				self.sequeue:push(action)
			end
		
			self.sequeue:addCallBacker(self,self.onActionsComplete)
			self.target:pushDamageAction(self.sequeue)
			
		else
			-- Logger.debug("BAForBSBuffDamageAction not have any damage")
			self:complete()
		end

	end

	function BAForBSBuffDamageAction:onActionsComplete(data)
		if(self.disposed ~= true) then
			-- --print("function BAForBSBuffDamageAction:onActionsComplete")
			self:complete()
		end
	end
	function BAForBSBuffDamageAction:release( ... )
		 self.super.release(self)
		 self.target = nil
		 if(self.sequeue) then
		 	self.sequeue:release()
		 	self.sequeue = nil
		 end
		 if(self.heroUI) then
		 	self.heroUI = nil
		 end
		 self.damageList = nil
	end
return BAForBSBuffDamageAction