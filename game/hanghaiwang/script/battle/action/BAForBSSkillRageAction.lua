


-- BSTree 怒气改变action
require (BATTLE_CLASS_NAME.class)
local BAForBSSkillRageAction = class("BAForBSSkillRageAction",require(BATTLE_CLASS_NAME.BaseAction))


	------------------ properties ----------------------
 
	BAForBSSkillRageAction.rageData 				= nil

	------------------ functions -----------------------
	function BAForBSSkillRageAction:start(data)
		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.rageData ~= nil) then 
 			 -- self:addToRender()
 			local rageAction 			= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        rageAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSSkillRageDamageBB).new()
	        rageAction.blackBoard:reset(self.rageData)
			rageAction.logicData 		= SkillRageDamageActionLogicData.getLogicData()
	        rageAction.name 			= "rage logic tree"
	        -- rageAction:addCallBacker(self,self.onActionsComplete)
	        -- rageAction:start()
	        self.rageData 				= nil
	        BattleActionRender.addAutoReleaseAction(rageAction)
 		end
 
 	 	self:complete()
	end
	
	-- function BAForBSSkillRageAction:onActionsComplete(data)
	-- 	-- --print("function BAForBSSkillRageAction:onActionsComplete")
	-- 	-- self:complete()
	-- end

return BAForBSSkillRageAction