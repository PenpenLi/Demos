


-- BSTree  
require (BATTLE_CLASS_NAME.class)
local BAForBSShipAttackAction = class("BAForBSShipAttackAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSShipAttackAction.roundData						= nil
	BAForBSShipAttackAction.attackAction					= nil
	------------------ functions -----------------------
	function BAForBSShipAttackAction:start(data)
		 -- --print("_________________________ BAForBSShipAttackAction start")
		if(self.disposed == true) then
		 	-- --print("_________________________ BAForBSShipAttackAction start")
		end

		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.roundData ~= nil) then 

 			self.attackAction 					= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        self.attackAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSShipAttackBBData).new()
	        self.attackAction.blackBoard:reset(self.roundData)
			self.attackAction.logicData 		= ShipAttackLogic.getLogicData()
	        self.attackAction.name 				= "attackerTree"
	        self.attackAction:addCallBacker(self,self.onActionsComplete)
	        -- --print("BAForBSShipAttackAction:start->attackAction:start()")
	        self.attackAction:start()

		else
			--print("BAForBSShipAttackAction:start-> roundData is nil")
			self:complete()
		end

	end
	function BAForBSShipAttackAction:toString(p)
		
	end
	function BAForBSShipAttackAction:onActionsComplete(data)
		-- --print("_________________________function BAForBSShipAttackAction:onActionsComplete")
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

	function BAForBSShipAttackAction:release()
		self.super.release(self)
		self.roundData = nil
		if(self.attackAction) then
			self.attackAction:release()
			self.attackAction = nil
		end
	end
return BAForBSShipAttackAction