





-- 技能分发
require (BATTLE_CLASS_NAME.class)
local BAForBSHandleSkillAction = class("BAForBSHandleSkillAction",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForBSHandleSkillAction.roundData						= nil
	BAForBSHandleSkillAction.skillAction					= nil
	------------------ functions -----------------------
	function BAForBSHandleSkillAction:start(data)

		-- --print("BAForBSHandleSkillAction start")
		-- self.sequeue 			= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		if(self.roundData ~= nil) then 

			self:addToRender()
 			self.skillAction 					= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        self.skillAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSSkillSystemBBData).new()
	        self.skillAction.blackBoard:reset(self.roundData)
			self.skillAction.logicData 			= SkillLogicData.getLogicData()
	        self.skillAction.name 				= "BAForBSHandleSkillAction"
	        self.skillAction:addCallBacker(self,self.onActionsComplete)
	     
	        BattleMainData.skillHandle = self

	        self.skillAction:start()

		else
			self:complete()
		end

	end
	
	function BAForBSHandleSkillAction:onActionsComplete(data)
		-- --print("function BAForBSHandleSkillAction:onActionsComplete")
		BattleMainData.skillHandle = nil
		if(skillAction) then
			skillAction:release()
			skillAction = nil
		end
		self:complete()
	end
		-- 释放函数
	function BAForBSHandleSkillAction:release(data)

		self.super.release(self)
		self.roundData = nil
		if(self.skillAction) then
			self.skillAction:release()
			skillAction = nil
		end
	end
return BAForBSHandleSkillAction