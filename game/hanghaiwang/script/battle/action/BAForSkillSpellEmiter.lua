



-- 技能发射器 
require (BATTLE_CLASS_NAME.class)
local BAForSkillSpellEmiter = class("BAForSkillSpellEmiter",require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero))

 
	------------------ properties ----------------------
	

	------------------ functions -----------------------
	function BAForSkillSpellEmiter:start(data)

		--print("------------------------ BAForSkillSpellEmiter")
		  -- 调试用,后面会用skillid来检索动作id,然后保存到blackboard中
		
		if self.blackBoard ~= nil then
			-- 决定播放1个特效还是 多个
				-- 1. 远程: 生成远程弹道 和 伤害类
				-- 2. 瞬发: 生成特效 和 trigger 和 伤害类
			
		else
			--print("BAForSkillSpellEmiter:start start error")
		end
 	

	end -- function end

return BAForSkillSpellEmiter