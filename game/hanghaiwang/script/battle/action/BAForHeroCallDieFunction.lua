local BAForHeroCallDieFunction = class("BAForHeroCallDieFunction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	
 	BAForHeroCallDieFunction.targetUI 			= nil 
 	------------------ functions -----------------------
 	function BAForHeroCallDieFunction:start( ... )
 		if(self.targetUI) then
 			self.targetUI:die()
 		end
 		self.targetUI = nil
 		self:complete()
 	end
 return BAForHeroCallDieFunction