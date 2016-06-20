-- BSTree 删除buff action
require (BATTLE_CLASS_NAME.class)
local BAForBSBuffDeleteAction = class("BAForBSBuffDeleteAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSBuffDeleteAction.heroUI					= nil
	BAForBSBuffDeleteAction.deleteList				= nil
	BAForBSBuffDeleteAction.sequeue 				= nil 
	BAForBSBuffDeleteAction.targetId 				= nil
	-- BAForBSBuffDeleteAction
	------------------ functions -----------------------
	function BAForBSBuffDeleteAction:start(data)
		if(self.deleteList ~= nil and #self.deleteList > 0) then 
			self.sequeue			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
			for k,buffid in pairs(self.deleteList) do
				-- 生成buffaction
				local action 		= require(BATTLE_CLASS_NAME.BAForBSAction).new()
				local blackBoard	= require(BATTLE_CLASS_NAME.BSBuffDeleteBB).new()
				local logic 		= BuffDeleteLogicData.getLogicData() 
				--print("BAForBSBuffDeleteAction:start ->",self.targetId)
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

	function BAForBSBuffDeleteAction:onActionsComplete(data)
		-- --print("function BAForBSBuffDeleteAction:onActionsComplete")
		self:complete()
	end

	function BAForBSBuffDeleteAction:release( ... )
		 self.super.release(self)
		 if(self.sequeue) then
		 	self.sequeue:release()
		 	self.sequeue = nil
		 end
		 if(self.heroUI) then
		 	self.heroUI = nil
		 end
		 self.deleteList = nil
	end

return BAForBSBuffDeleteAction