
--- 指定目标 执行移动动作 x秒

require (BATTLE_CLASS_NAME.class)
local BAForTargetsPlayMoveInTimeAction = class("BAForTargetsPlayMoveInTimeAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForTargetsPlayMoveInTimeAction.targets 		= nil -- 目标
 	BAForTargetsPlayMoveInTimeAction.time 			= nil -- 播放时间
 
 	BAForTargetsPlayMoveInTimeAction.delayAction 	= nil
 	BAForTargetsPlayMoveInTimeAction.walkTime 		= BATTLE_CONST.WALK_SOUND_TIME
 	BAForTargetsPlayMoveInTimeAction.countTime      = nil
 	BAForTargetsPlayMoveInTimeAction.walkSound      = nil
 	BAForTargetsPlayMoveInTimeAction.costTime 		= nil
 	------------------ functions -----------------------
 	function BAForTargetsPlayMoveInTimeAction:start()
 		if(self.targets and self.time > 0) then

 			for k,traget in pairs(self.targets) do
 				 if(traget) then 
 				 	traget:playMoveAnimation(true)
 				 end
 			end
 			self.costTime 							= 0
 			-- self.delayAction 						= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
 			-- self.delayAction.total 					= self.time 
 			-- self.delayAction:addCallBacker(self,self.onDelayComplete)
 			-- self.delayAction:start()
 			self:addToRender()

 			-- self.countTime 							= 0
		  -- 	self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
 			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()

 		else
 			self:complete()
 		end
 	end

 

 	function BAForTargetsPlayMoveInTimeAction:update( dt )
 		-- Logger.debug("BAForTargetsPlayMoveInTimeAction:moveTime:"..self.time .. "  " .. self.costTime) 
 		-- self.countTime = self.countTime + dt
 		-- if(self.countTime >= self.walkTime) then
 		-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
 		-- 	 self.countTime = 0
 		-- end

 		

 		self.costTime = self.costTime + dt
 		if(self.costTime >= self.time) then

 			if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 			end
 			
 			BattleSoundMananger.stopAllLoop()
 			self:complete()
 			self:release()
 		else
 			if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:update(dt)
 			end

 		end
 	end
 	function BAForTargetsPlayMoveInTimeAction:onDelayComplete()
 		 self:complete()
 		
 		if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 		end
 		 -- BattleActionRender.addAutoReleaseAction(self)
 		 self:release()
 	end


 	function BAForTargetsPlayMoveInTimeAction:release()
 		-- --print(" BAForTargetsPlayMoveInTimeAction:release:",self.targets)
 		self:removeFromRender()					 
		self.calllerBacker:clearAll()


 		if(self.delayAction) then
 		 	self.delayAction:release()
 		 	self.delayAction = nil
 		end

 		if(self.targets) then

 		 	for k,v in pairs(self.targets) do
 		 		v:toStandState()
 		 		-- print("stop:",k)
 		 	end
 		 	self.targets = nil
 		end

 		if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 		end
 	end
 return BAForTargetsPlayMoveInTimeAction