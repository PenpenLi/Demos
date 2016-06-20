




require (BATTLE_CLASS_NAME.class)
local BAForHeroHpBarChange = class("BAForHeroHpBarChange",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForHeroHpBarChange.heroUI 						= nil
	BAForHeroHpBarChange.target							= nil
	BAForHeroHpBarChange.value 							= nil
	-- BAForHeroHpBarChange.total							= nil
	function BAForHeroHpBarChange:start()

		
		if(self.target) then
			self.target:hpChangeBy(self.value)
		end
		self.heroUI = nil
		self.target = nil
		-- if(self.heroUI and self.value and self.total) then
		-- 	self.heroUI:hpBarChangeBy(self.value)
		-- else
		-- 	--print("BAForHeroHpBarChange:start ",self.heroUI,self.value)
		-- end
 
		self:complete()
	end

	------------------ functions -----------------------
 
return BAForHeroHpBarChange