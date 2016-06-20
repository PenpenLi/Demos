





-- 技能怒气
require (BATTLE_CLASS_NAME.class)
local BSSkillRageDamageBB = class("BSSkillRageDamageBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 
	------------------ properties ----------------------
	BSSkillRageDamageBB.hasRageChange			= false -- 是否有怒气变化
	BSSkillRageDamageBB.value					= false
	BSSkillRageDamageBB.target					= nil 	-- 目标数据模型
	BSSkillRageDamageBB.targetUI				= nil 	-- 目标显示模型
	BSSkillRageDamageBB.des 					= "BSSkillRageDamageBB"
	------------------ functions -----------------------
	function BSSkillRageDamageBB:reset(	data )
		if(data ~= nil and data.rage ~= nil and data.rage ~= 0) then
			self.des 								= "BSSkillRageDamageBB"
			self.hasRageChange						= true
			self.value								= tonumber(data.rage)
			-- --print("BSSkillRageDamageBB:reset rageChange:",self.value," target:",data.id)
			self.target								= BattleMainData.fightRecord:getTargetData(data.id)
			self.targetUI 							= self.target.displayData					 
		else
			self.hasRageChange						= false

		end
		-- --print("BSSkillRageDamageBB:reset hasRageChange:",self.hasRageChange)
	end

return BSSkillRageDamageBB
