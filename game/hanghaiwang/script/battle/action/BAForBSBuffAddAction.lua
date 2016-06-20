-- BSTree 添加buff
require (BATTLE_CLASS_NAME.class)
local BAForBSBuffAddAction = class("BAForBSBuffAddAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSBuffAddAction.sequeue 					= nil 
	BAForBSBuffAddAction.addList 					= nil
	BAForBSBuffAddAction.heroUI						= nil
	BAForBSBuffAddAction.targetId 					= nil
	------------------ functions -----------------------
	function BAForBSBuffAddAction:start(data)
		-- --print("BAForBSBuffAddAction start:",self.addList," len:",#self.addList)
		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.addList ~= nil and #self.addList > 0) then 
			self.sequeue			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
			for k,buffid in pairs(self.addList) do
				-- 生成buffaction
				local action 		= require(BATTLE_CLASS_NAME.BAForBSAction).new()
				local blackBoard	= require(BATTLE_CLASS_NAME.BSBuffAddBB).new()
				local logic 		= BuffAddLogicData.getLogicData()
				--print("buffadd ini: bid:",buffid," target:",self.targetId)
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
	
	function BAForBSBuffAddAction:onActionsComplete(data)
		if(self.disposed ~= true) then
			-- --print("function BAForBSBuffAddAction:onActionsComplete")
			self:complete()
		end
	end
	function BAForBSBuffAddAction:release( ... )
		 self.super.release(self)
		 if(self.sequeue) then
		 	self.sequeue:release()
		 	self.sequeue = nil
		 end
		 if(self.heroUI) then
		 	self.heroUI = nil
		 end
	end
return BAForBSBuffAddAction