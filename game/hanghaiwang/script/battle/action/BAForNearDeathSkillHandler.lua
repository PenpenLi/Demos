-- 处理目标濒死
require (BATTLE_CLASS_NAME.class)
local BAForNearDeathSkillHandler = class("BAForNearDeathSkillHandler",require(BATTLE_CLASS_NAME.BaseAction))
 	
	------------------ properties ----------------------
	
	BAForNearDeathSkillHandler.target 				= nil
	BAForNearDeathSkillHandler.skill 				= nil
	BAForNearDeathSkillHandler.deathAction 			= nil
	------------------ functions -----------------------
	function BAForNearDeathSkillHandler:start()
	 	
	 	if(	
		 		-- 如果目标显示数据存在
		 		self.target and
		 		self.target.displayData and
		 		self.target.displayData:isOnStage() == true and 

		 		-- 如果目标有死亡技能有效
		 	 	self.target:hasDeadSkill() == true and 
		 	 	self.target.deadSkillWillExcute == true and
		 	 	self.target.deadSkillExcuted == true
		 	 	-- self.target.nearDeathLeftRound ~= nil and
		 	 	-- self.target.nearDeathLeftRound >= 0				-- 如果目标已经执行过死亡
	 		) then
			 		-- 如果目标死亡技能已经被触发
			 		-- if(self.target.deadSkillExcuted == true) then

			 			-- 如果已经到了死亡触发时机
		 			-- if(self.target.nearDeathLeftRound == 0) then
		 				self.target.deadSkillWillExcute = false
		 				self.target.deadSkillExcuted 	= true
		 				self.deathAction = require(BATTLE_CLASS_NAME.BAForBSDieAction).new()
		 				self.deathAction.target = self.target
						self.deathAction:addCallBacker(self,self.onDeathActionComplete)
						self.deathAction:start()
		 			-- end
		 			-- self.target:downNearDeathRound()
		 		-- end
	 	else
	 		self:complete()
	 		self:release()
	 	end
		
	end

	function BAForNearDeathSkillHandler:onDeathActionComplete( ... )
		self:complete()
		self:release()
	end

	function BAForNearDeathSkillHandler:release( ... )
		self.super.release(self)
		if(self.deathAction ~= nil) then
			self.deathAction:release()
			self.deathAction = nil
		end
		self.target = nil
	end
 
return BAForNearDeathSkillHandler