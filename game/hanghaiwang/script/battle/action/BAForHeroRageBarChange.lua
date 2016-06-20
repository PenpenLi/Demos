

require (BATTLE_CLASS_NAME.class)
local BAForHeroRageBarChange = class("BAForHeroRageBarChange",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForHeroRageBarChange.heroUI 							= nil
	BAForHeroRageBarChange.value 							= nil
	function BAForHeroRageBarChange:start()
		-- --print("BAForHeroRageBarChange start:",self.heroUI," value:",self.value)
	 	if(self.heroUI) then
			self.heroUI:rageBarChangeBy(self.value)
			self.heroUI = nil
		end
		self:complete()
	end

	------------------ functions -----------------------
 
return BAForHeroRageBarChange