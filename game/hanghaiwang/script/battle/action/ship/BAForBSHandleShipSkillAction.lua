








-- 技能分发
require (BATTLE_CLASS_NAME.class)
local BAForBSHandleShipSkillAction = class("BAForBSHandleShipSkillAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSHandleShipSkillAction.roundData						= nil
	BAForBSHandleShipSkillAction.skillAction					= nil
	------------------ functions -----------------------
	function BAForBSHandleShipSkillAction:start(data)

		print("BAForBSHandleShipSkillAction start")
		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.roundData ~= nil) then 

			self:addToRender()
 			self.skillAction 					= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        self.skillAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSShipSkillHandleBBData).new()
	        self.skillAction.blackBoard:reset(self.roundData)
			self.skillAction.logicData 			= ShipHanleLogic.getLogicData()
	        self.skillAction.name 				= "BAForBSHandleShipSkillAction"
	        self.skillAction:addCallBacker(self,self.onActionsComplete)
	     
	        BattleMainData.skillHandle = self

	        self.skillAction:start()

		else
			self:complete()
		end

	end
	
	function BAForBSHandleShipSkillAction:onActionsComplete(data)
		-- --print("function BAForBSHandleShipSkillAction:onActionsComplete")
		BattleMainData.skillHandle = nil
		if(skillAction) then
			skillAction:release()
			skillAction = nil
		end
		self:complete()
	end
		-- 释放函数
	function BAForBSHandleShipSkillAction:release(data)

		self.super.release(self)
		self.roundData = nil
		if(self.skillAction) then
			self.skillAction:release()
			skillAction = nil
		end
	end
return BAForBSHandleShipSkillAction