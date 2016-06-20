
 -- 特效(特效为编辑器指定)+英雄出现
local BAForShowTargetsWithDynamicEffect = class("BAForShowTargetsWithDynamicEffect",require(BATTLE_CLASS_NAME.BAForHeroesEffectShow))

 
	------------------ properties ----------------------

	------------------ functions -----------------------
	
	function BAForShowTargetsWithDynamicEffect:start( ... )
		if(self.data and #self.data > 1 and type(self.data[#self.data]) == "string") then
			--最后一个位置为特效名称
			self.showEffectName = self.data[#self.data]
			table.remove(self.data,#self.data)
			self.super.start(self)
		else
			self:complete()
		end
	end

return BAForShowTargetsWithDynamicEffect