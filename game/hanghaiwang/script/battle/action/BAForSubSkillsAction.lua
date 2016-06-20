


-- 子技能action
require (BATTLE_CLASS_NAME.class)
local BAForSubSkillsAction = class("BAForSubSkillsAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForSubSkillsAction.subSkillsList 					= nil
 	BAForSubSkillsAction.queue 							= nil -- 子技能执行队列
 	------------------ functions -----------------------
 	function BAForSubSkillsAction:start( ... )
 		
 		if(self.subSkillsList ~= nil and #self.subSkillsList > 0 ) then
 			-- Logger.debug("BAForSubSkillsAction:start : " .. tonumber(#self.subSkillsList))
 			self.queue 									= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
 			for k,v in pairs(self.subSkillsList) do

 				local behavierTree 				= require(BATTLE_CLASS_NAME.BAForBSAction).new()
                behavierTree.name 			= "BattleRoundLogicData"
                behavierTree.blackBoard 	= require(BATTLE_CLASS_NAME.BSBattleRoundBB).new()
                behavierTree.blackBoard:reset(v)
                behavierTree.logicData 	= BattleRoundSubskillLogic.getLogicData()
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

 	function BAForSubSkillsAction:onActionsComplete(data)
 		-- Logger.debug("BAForSubSkillsAction:complete : ")
 			
		self:complete()
	end
 return BAForSubSkillsAction