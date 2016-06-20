
 -- 闪电出现
local BAForLightingEffectShow = class("BAForLightingEffectShow",require(BATTLE_CLASS_NAME.BAForHeroesEffectShow))

function BAForLightingEffectShow:start( ... )
	if(self.data) then
		self.showEffectName = BATTLE_CONST.BSE_EFFECT1
		self.super.start(self)
	end
	-- self:complete()	
end


return BAForLightingEffectShow