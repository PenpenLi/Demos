




-- 敌方移动到
require (BATTLE_CLASS_NAME.class)
local BAForMoveTargetsTo = class("BAForMoveTargetsTo",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	BAForMoveTargetsTo.direction		= nil
	BAForMoveTargetsTo.moveTime			= 2.5
	BAForMoveTargetsTo.moveDistence		= nil
	BAForMoveTargetsTo.targets 			= nil

	BAForMoveTargetsTo.costTime 		= nil
	BAForMoveTargetsTo.delay 			= nil

	BAForMoveTargetsTo.walkSound 		= nil
	BAForMoveTargetsTo.walkTime			= BATTLE_CONST.WALK_SOUND_TIME
	BAForMoveTargetsTo.walkTimeCount	= nil
	BAForMoveTargetsTo.walkSoundPlayer  = nil
	------------------ functions -----------------------
	function BAForMoveTargetsTo:ctor( ... )
		self.moveDistence = 0
		self.direction 	  = BATTLE_CONST.DIR_UP
		self.super.ctor(self)
	end
	function BAForMoveTargetsTo:start( ... )
			if(self.moveDistence ~= nil and self.moveDistence ~= 0) then
				self.delay = 0

				-- local call = function ( ... )
				-- 				self:onActinComplete()
				-- 			 end
				for k,v in pairs(self.targets) do
					v:moveBy(0,-self.direction * self.moveDistence)
					v:playMoveAnimation(true)
				end
 				self.costTime = 0
				-- end
				self:addToRender()

				self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			    self.walkSoundPlayer:start()
			    -- self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
			    -- BattleSoundMananger.playEffectSound(self.walkSound,true,true)

			    -- self.walkTimeCount 						= 0
		  	 
			else
				Logger.debug("BAForMoveTargetsTo over")
				self:complete()
			end

	end

	function BAForMoveTargetsTo:update( dt )
		 if(self.delay > 0) then 
		 	self.delay = self.delay - 1 
		 	-- Logger.debug("BAForMoveTargetsTo:moveTime:"..self.delay) 
		 	return
		 end 

		-- Logger.debug("BAForMoveTargetsTo:moveTime:"..self.moveTime) 
 		-- self.walkTimeCount = self.walkTimeCount + dt
 		-- if(self.walkTimeCount >= self.walkTime) then
 		-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
 		-- 	 self.walkTimeCount = 0
 		-- end
 

		 self.costTime = self.costTime + dt
		 if(self.costTime < self.moveTime) then
		 	local dy = dt/self.moveTime * self.direction * self.moveDistence
		 	
		 	for k,v in pairs(self.targets) do
					v:moveBy(0,dy)
			end

 			if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:update(dt)
 			end

		 else
		 		-- Logger.debug()
		 		for k,v in pairs(self.targets) do
					v:toStandState()
					 
				end

			if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 			end

			BattleSoundMananger.stopAllLoop()
		 	-- self.targets:scrollPyTo(self.direction * self.moveDistence)
		 	self:complete()
		 	self.walkSoundPlayer:release()
		 end
	end


	function BAForMoveTargetsTo:onActinComplete( ... )
		self:complete()
		if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 		end
	end
return BAForMoveTargetsTo