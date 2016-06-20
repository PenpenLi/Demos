

-- 多个目标所在索引播放特效
require (BATTLE_CLASS_NAME.class)
local BAForTargetsPlayEffectAction = class("BAForTargetsPlayEffectAction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForTargetsPlayEffectAction.targets 		= nil -- 目标
 	BAForTargetsPlayEffectAction.effectName		= nil -- 特效名称

 	BAForTargetsPlayEffectAction.total			= 0
 	BAForTargetsPlayEffectAction.current			= 0
 	------------------ functions -----------------------
 	function BAForTargetsPlayEffectAction:start( ... )
 		--print("BAForTargetsPlayEffectAction:start")
 		for k,display in pairs(self.targets or {}) do
 			self.total 				= self.total + 1
 		end
 		if(self.targets ~= nil and self.effectName ~= nil) then
 			-- self.total 				= #self.targets
 			self.current			= 0
 			if(self.total <= 0 or self.total == nil) then
 					--print("warning:BAForTargetsPlayEffectAction:start->total is 0")
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

 	function BAForTargetsPlayEffectAction:onOneEffectComplete()

 		self.current = self.current + 1
 		--print("BAForTargetsPlayEffectAction one complete:",self.current,":",self.total)
 		if(self.current >= self.total) then
 			self:complete()
 		end
 	end
 return BAForTargetsPlayEffectAction