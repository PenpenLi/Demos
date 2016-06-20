
-- 播放怒气释放特效 meffect31
require (BATTLE_CLASS_NAME.class)
local BAForShowRageSkillFireEffect = class("BAForShowRageSkillFireEffect",require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero))

 
	------------------ properties ----------------------
	

	------------------ functions -----------------------
	function BAForShowRageSkillFireEffect:start(data)

		--print("------------------------ BAForShowRageSkillFireEffect")
		  -- 调试用,后面会用skillid来检索动作id,然后保存到blackboard中
		
		-- 2014.10.15 陈帅提出要改回去
		if self.blackBoard ~= nil and self.blackBoard.attackerUI ~= nil and self.disposed ~= true then
			self.animationName 	= BATTLE_CONST.ANIMATION_RAGE_FIRE
			self.heroUI 		= self.blackBoard.attackerUI
			self.super.start(self)
			-- local animation = require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()

			-- animation.animationName 								= BATTLE_CONST.ANIMATION_RAGE_FIRE
			-- animation.heroUI 										= self.blackBoard.attackerUI
			-- BattleActionRender.addAutoReleaseAction(animation)
			 
		else
			--print("BAForShowRageSkillFireEffect:start start error")
			self:complete()
		end
 	
		
	end -- function end

return BAForShowRageSkillFireEffect