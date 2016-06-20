

-- 多个目标所在索引播放特效
require (BATTLE_CLASS_NAME.class)
local BAForTargetsPostionPlayEffectAction = class("BAForTargetsPostionPlayEffectAction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForTargetsPostionPlayEffectAction.targets 		= nil -- 目标
 	BAForTargetsPostionPlayEffectAction.effectName		= nil -- 特效名称

 	BAForTargetsPostionPlayEffectAction.total			= 0
 	BAForTargetsPostionPlayEffectAction.current			= 0
 	------------------ functions -----------------------
 	function BAForTargetsPostionPlayEffectAction:start( ... )
 		if(self.targets ~= nil and self.effectName ~= nil) then
 			self.total 				= #self.targets
 			self.current			= 0
 			if(self.total <= 0 or self.total == nil) then
 					--print("warning:BAForTargetsPostionPlayEffectAction:start->total is 0")
 					self:complete()
 			else	
 				 	for k,display in pairs(self.targets or {}) do
 				 		local playEffect 			= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
 				 		playEffect.heroUI 			= display
 				 		playEffect.animationName	= self.effectName
 						playEffect:addCallBacker(self,self.onOneEffectComplete)
 						playEffect:start()
 					end
 			end

 		else
 			self:complete()
 		end
 	end -- function end

 	function BAForTargetsPostionPlayEffectAction:onOneEffectComplete()
 		self.current = self.current + 1
 		if(self.current >= self.total) then
 			self:complete()
 		end
 	end
 return BAForTargetsPostionPlayEffectAction