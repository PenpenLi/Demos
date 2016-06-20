


-- 子技能action
require (BATTLE_CLASS_NAME.class)
local BAForBSShipSubSkillsAction = class("BAForBSShipSubSkillsAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForBSShipSubSkillsAction.subSkillsList 					= nil
 	BAForBSShipSubSkillsAction.queue 							= nil -- 子技能执行队列
 	------------------ functions -----------------------
 	function BAForBSShipSubSkillsAction:start( ... )
 		
 		if(self.subSkillsList ~= nil and #self.subSkillsList > 0 ) then
 			Logger.debug("BAForBSShipSubSkillsAction:start : " .. tonumber(#self.subSkillsList))
 			self.queue 									= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
 			for k,v in pairs(self.subSkillsList) do

 				local behavierTree 				= require(BATTLE_CLASS_NAME.BAForBSAction).new()
                behavierTree.name 			= "BattleRoundLogicData"
                behavierTree.blackBoard 	= require(BATTLE_CLASS_NAME.BSShipSkillRoundBBData).new()
                behavierTree.blackBoard:reset(v)
                behavierTree.logicData 	= ShipSubSkillLogic.getLogicData()
                -- behavierTree:addCallBacker(self,handlePlayRoundComplete)
                -- behavierTree:start()

 				-- local skillBS 							= require(BATTLE_CLASS_NAME.BAForBSBattleRoundLogicAction).new()
 				-- skillBS.roundData 						= v
 				self.queue:push(behavierTree)
 				self.queue:addCallBacker(self,self.onActionsComplete)
 				self.queue:start()
 			end

 		else
 			self:complete()
 		end
 	end

 	function BAForBSShipSubSkillsAction:onActionsComplete(data)
 		Logger.debug("BAForBSShipSubSkillsAction:complete : ")
 			
		self:complete()
	end
 return BAForBSShipSubSkillsAction