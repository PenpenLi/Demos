



-- BSTree 技能hp改变
require (BATTLE_CLASS_NAME.class)
local BAForBSDieAction = class("BAForBSDieAction",require(BATTLE_CLASS_NAME.BaseAction))


	------------------ properties ----------------------
 
	BAForBSDieAction.target 				= nil
	BAForBSDieAction.dieAction				= nil
	BAForBSDieAction.skill 					= nil
	------------------ functions -----------------------
	function BAForBSDieAction:start(data)
		-- --print("start run dieBS")
		if(self.target ~= nil) then 
			-- --print("enter run dieBS")
			if(self.dieAction == nil) then
		        self.dieAction 						= require(BATTLE_CLASS_NAME.BAForBSAction).new()
			    self.dieAction.blackBoard 			= require(BATTLE_CLASS_NAME.BSDieBB).new()
			    self.dieAction.blackBoard:reset(self.target,true,self.skill)
				self.dieAction.logicData 			= DieLogicData.getLogicData()
			    self.dieAction.name 				= "skill rage logic action"
				self.dieAction:addCallBacker(self,self.onActionsComplete)
		        self.dieAction:start()
		    end

	    else
	    	error("BAForBSDieAction:start target is nil or ")
 		end
 
	end
	
	function BAForBSDieAction:onActionsComplete(data)
		-- --print("function BAForBSDieAction:onActionsComplete")
		self:complete()
	end

	function BAForBSDieAction:release( ... )
		 self.super.release(self)
 
		 self.target = nil
		 if(self.dieAction) then
		 	self.dieAction:release()
		 	self.dieAction = nil
		 end
	end

return BAForBSDieAction