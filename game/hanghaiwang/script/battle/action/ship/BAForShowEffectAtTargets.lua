

require (BATTLE_CLASS_NAME.class)
local BAForShowEffectAtTargets = class("BAForShowEffectAtTargets",require(BATTLE_CLASS_NAME.BaseAction))
	 BAForShowEffectAtTargets.animationName = nil
	 BAForShowEffectAtTargets.targets = nil
	 BAForShowEffectAtTargets.total  = nil
	 BAForShowEffectAtTargets.count = nil
	 BAForShowEffectAtTargets.actions = nil
	 function BAForShowEffectAtTargets:start()
	 	if(self.animationName ~= nil and self.targets ~= nil and #self.targets > 0) then
	 		self.count = 0
	 		self.total = #self.targets
	 		self.actions = {}
	 		-- print("==BAForShowEffectAtTargets:0",self.animationName,#self.targets)
	 		for k,v in pairs(self.targets or {}) do
	 			-- print("==BAForShowEffectAtTargets:1")
	 			local eff = require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
	 			eff.animationName = self.animationName
	 			eff.heroUI 		  = v
	 			eff:addCallBacker(self,self.onOneComplete)
	 			table.insert(self.actions,eff)
	 			eff:start()
	 			-- print("==BAForShowEffectAtTargets:2")
	 		end
	 	else
	 		-- print("==BAForShowEffectAtTargets error:",self.animationName,self.targets,#self.targets)
	 		self:complete()
	 	end
	 	-- print("==BAForShowEffectAtTargets:3")
	 end

	 function BAForShowEffectAtTargets:onOneComplete( ... )
	 	self.count = self.count + 1
	 	-- print("==BAForShowEffectAtTargets:onOneComplete",2)
	 	if(self.count >= self.total) then
	 		-- print("==BAForShowEffectAtTargets:onOneComplete",3)
	 		for k,v in pairs(self.actions or {}) do
		 		v:release()
		 	end
		 	self.actions = {}
		 	
	 		self:complete()
	 	end

	 end
return BAForShowEffectAtTargets