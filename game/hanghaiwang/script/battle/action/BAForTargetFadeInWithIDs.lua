

--- 指定目标 淡入/淡出
--- 必要: targets,createFunction

require (BATTLE_CLASS_NAME.class)
local BAForTargetFadeInWithIDs = class("BAForTargetFadeInWithIDs",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForTargetFadeInWithIDs.idList 				= nil
	BAForTargetFadeInWithIDs.time 					= nil -- 持续时间
	-- BAForTargetFadeInWithIDs.createFunction 		= nil 

 	BAForTargetFadeInWithIDs.delayAction 	= nil
	------------------ functions -----------------------
	function BAForTargetFadeInWithIDs:start()
		-- print("=== BAForTargetFadeInWithIDs")
		if(self.idList ~= nil and #self.idList > 0) then 
			-- print("=== BAForTargetFadeInWithIDs1")
			if(self.time == nil or self.time <= 0) then
				self.time = 0.5
				-- print("=== BAForTargetFadeInWithIDs 2")
			end
			local targetRun = false
			local actionsArray = CCArray:create()
			local fadeCount = 0
			for k,id in pairs(self.idList) do
     			local targetData = BattleMainData.fightRecord:getTargetData(id)
     			if(targetData and targetData.displayData) then
     				local target = targetData.displayData
     				target:setVisible(true)
	            	target:setOpacity(0)
	            	-- print("=== BAForTargetFadeInWithIDs4",self.time)
	            	actionsArray:addObject(CCFadeIn:create(self.time))
					
					
					if(targetRun == false) then
						targetRun = true
						actionsArray:addObject(CCCallFuncN:create(function( ... )
							self:onComplete()
						end))
					end
					fadeCount = fadeCount + 1
					target.boneBinder:runAction(CCSequence:create(actionsArray))
					-- print("=== BAForTargetFadeInWithIDs 2")
     			end

			end

 			if(fadeCount > 0) then
 				self:addToRender()
 			else
 				self:complete()
 			end
		else
			-- print("=== BAForTargetFadeInWithIDs 3")
			self:complete()
		end
	end

	function BAForTargetFadeInWithIDs:onComplete()
		 -- print("=== BAForTargetFadeInWithIDs onComplete")
 		 self:complete()
 		 BattleActionRender.addAutoReleaseAction(self)
 	end

	function BAForTargetFadeInWithIDs:release()
		if(self.delayAction) then 
			self.delayAction:release()
		end

		self.idList = nil
		self:removeFromRender()					 
		self.calllerBacker:clearAll()

	end
return BAForTargetFadeInWithIDs