-- BSTree 免疫buff action
require (BATTLE_CLASS_NAME.class)
local BAForBSBuffImAction = class("BAForBSBuffImAction",require(BATTLE_CLASS_NAME.BaseAction))


		------------------ properties ----------------------
	BAForBSBuffImAction.sequeue 					= nil 
	BAForBSBuffImAction.imList 						= nil
	BAForBSBuffImAction.heroUI						= nil
	BAForBSBuffImAction.targetId 					= nil
	------------------ functions -----------------------
	function BAForBSBuffImAction:start(data)
		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.imList ~= nil and #self.imList > 0) then 
			self.sequeue			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
			for k,buffid in pairs(self.imList) do
				-- 生成buffaction
				local action 		= require(BATTLE_CLASS_NAME.BAForBSAction).new()
				local blackBoard	= require(BATTLE_CLASS_NAME.BSBuffImBB).new()
				local logic 		= BuffImLogicData.getLogicData() 
				blackBoard:reset(buffid,self.targetId)
				action.blackBoard 	= blackBoard
				action.logicData 	= logic
				self.sequeue:push(action)
			end
			self.sequeue:addCallBacker(self,self.onActionsComplete)
			self.sequeue:start()
		else
			self:complete()
		end

	end
	
	function BAForBSBuffImAction:onActionsComplete(data)
		-- --print("function BAForBSBuffImAction:onActionsComplete")
		self:complete()
	end

	function BAForBSBuffImAction:release( ... )
		 self.super.release(self)
		 if(self.sequeue) then
		 	self.sequeue:release()
		 	self.sequeue = nil
		 end
		 if(self.heroUI) then
		 	self.heroUI = nil
		 end
		 self.imList = nil
	end
return BAForBSBuffImAction