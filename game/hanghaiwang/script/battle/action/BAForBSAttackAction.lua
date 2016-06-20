


-- BSTree 添加buff
require (BATTLE_CLASS_NAME.class)
local BAForBSAttackAction = class("BAForBSAttackAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSAttackAction.roundData						= nil
	BAForBSAttackAction.attackAction					= nil
	------------------ functions -----------------------
	function BAForBSAttackAction:start(data)
		 -- --print("_________________________ BAForBSAttackAction start")
		if(self.disposed == true) then
		 	-- --print("_________________________ BAForBSAttackAction start")
		end

		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.roundData ~= nil) then 

			-- self:addToRender()
 			self.attackAction 					= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        self.attackAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSSkillSystemBBData).new()
	        self.attackAction.blackBoard:reset(self.roundData)
			self.attackAction.logicData 		= AttackLogicData.getLogicData()
	        self.attackAction.name 				= "attackerTree"
	        self.attackAction:addCallBacker(self,self.onActionsComplete)
	        -- --print("BAForBSAttackAction:start->attackAction:start()")
	        self.attackAction:start()

		else
			--print("BAForBSAttackAction:start-> roundData is nil")
			self:complete()
		end

	end
	function BAForBSAttackAction:toString(p)
		
	end
	function BAForBSAttackAction:onActionsComplete(data)
		-- --print("_________________________function BAForBSAttackAction:onActionsComplete")
		if(self.disposed ~= true) then
			if(self.attackAction) then
				self.attackAction:release()
				self.attackAction = nil
			end
			if(self.roundData) then
				self.roundData 	  = nil
			end
			self:complete()
		end
	end

	function BAForBSAttackAction:release()
		self.super.release(self)
		self.roundData = nil
		if(self.attackAction) then
			self.attackAction:release()
			self.attackAction = nil
		end
	end
return BAForBSAttackAction