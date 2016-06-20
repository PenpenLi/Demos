

-- 在英雄身上播放特效(通过hid)

require (BATTLE_CLASS_NAME.class)
local BAForPlayEffectAtHeroByID = class("BAForPlayEffectAtHeroByID",require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero))
  
 	------------------ properties ----------------------
 	BAForPlayEffectAtHeroByID.hid 					= nil -- 目标id
 	------------------ functions -----------------------
 	function BAForPlayEffectAtHeroByID:start(data)
 		if(hid == nil) then
 			self:complete()
 		else
 			local target = BattleMainData.fightRecord:getTargetData(hid)
 			if(target) then
 				self.heroUI  = target.displayData
 				self.super.start(self)
 			else
 				Logger.debug("== BAForPlayEffectAtHeroByID:start 未发现:" .. tostring(hid))
 				self:complete()
 			end
 		end
 	end

return BAForPlayEffectAtHeroByID
