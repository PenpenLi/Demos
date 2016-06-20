


--- 指定目标 淡入/淡出
--- 必要: targets,createFunction

require (BATTLE_CLASS_NAME.class)
local BAForTargetsFadeInOrOutAction = class("BAForTargetsFadeInOrOutAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForTargetsFadeInOrOutAction.targets 				= nil
	BAForTargetsFadeInOrOutAction.time 					= nil -- 持续时间
	-- BAForTargetsFadeInOrOutAction.createFunction 		= nil 

 	BAForTargetsFadeInOrOutAction.delayAction 	= nil
	------------------ functions -----------------------
	function BAForTargetsFadeInOrOutAction:start()
		print("=== BAForTargetsFadeInOrOutAction")
		if(self.targets ~= nil and #self.targets > 0) then 
			print("=== BAForTargetsFadeInOrOutAction1")
			if(self.time == nil or self.time <= 0) then
				self.time = 0.5
				print("=== BAForTargetsFadeInOrOutAction 2")
			end
			local targetRun = false
			local actionsArray = CCArray:create()
			for k,target in pairs(self.targets) do
     
            	target:setVisible(true)
            	target:setOpacity(0)
            	print("=== BAForTargetsFadeInOrOutAction4",self.time)
            	actionsArray:addObject(CCFadeIn:create(self.time))
				
				
				if(targetRun == false) then
					targetRun = true
					actionsArray:addObject(CCCallFuncN:create(function( ... )
						self:onComplete()
					end))
				end

				target.boneBinder:runAction(CCSequence:create(actionsArray))
			end
			-- print("=== BAForTargetsFadeInOrOutAction delay:",self.time)
			-- self.delayAction 						= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
 		-- 	self.delayAction.total 					= self.time
 		-- 	self.delayAction:addCallBacker(self,self.onComplete)
 		-- 	self.delayAction:start()
 			self:addToRender()
		else
			print("=== BAForTargetsFadeInOrOutAction 3")
			self:complete()
		end
	end

	function BAForTargetsFadeInOrOutAction:onComplete()
		 print("=== BAForTargetsFadeInOrOutAction onComplete")
 		 self:complete()
 		 BattleActionRender.addAutoReleaseAction(self)
 	end

	function BAForTargetsFadeInOrOutAction:release()
		if(self.delayAction) then 
			self.delayAction:release()
		end

		self.targets = nil
		self:removeFromRender()					 
		self.calllerBacker:clearAll()

	end
return BAForTargetsFadeInOrOutAction