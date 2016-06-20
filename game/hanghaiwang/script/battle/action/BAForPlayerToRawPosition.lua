-- 还原指定人物到原始位置

require (BATTLE_CLASS_NAME.class)
local BAForPlayerToRawPosition = class("BAForPlayerToRawPosition",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForPlayerToRawPosition.heroUI 				= nil -- 目标ui
	------------------ functions -----------------------
	function BAForPlayerToRawPosition:start()
		if(self.heroUI ~= nil) then 
			self.heroUI:toRawPosition()
		end
		self:complete()
		self:release()
	end


	function BAForPlayerToRawPosition:release( ... )
		self.heroUI = nil
		self.super.release(self)
	end
 
return BAForPlayerToRawPosition
