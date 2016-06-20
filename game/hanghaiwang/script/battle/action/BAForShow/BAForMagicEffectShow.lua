
 -- 魔法效果出现
local BAForMagicEffectShow = class("BAForMagicEffectShow",require(BATTLE_CLASS_NAME.BAForHeroesEffectShow))

function BAForMagicEffectShow:start( ... )
	
	if(self.data) then
		self.showEffectName = BATTLE_CONST.BSE_EFFECT1
		self.super.start(self)
	end
	-- self:complete()	
end


return BAForMagicEffectShow