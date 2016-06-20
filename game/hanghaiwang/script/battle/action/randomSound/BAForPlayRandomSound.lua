-- 播放随机声音
require (BATTLE_CLASS_NAME.class)
local BAForPlayRandomSound = class("BAForPlayRandomSound",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForPlayRandomSound.soundNameLib 			= {"A006_step_01","A006_step_02","A006_step_03"} -- 所有随机声音名称
	BAForPlayRandomSound.soundDurationLib		= {0.678,0.469,0.652} -- 所有声音时间长度
	BAForPlayRandomSound.lastRandomIndex 		= nil -- 上一次随机声音
	BAForPlayRandomSound.soundDuration 			= nil -- 当前声音强度
	BAForPlayRandomSound.soundCost		 		= nil -- 当前声音强度
	BAForPlayRandomSound.num					= nil -- 总数
	BAForPlayRandomSound.actionDuration 		= nil -- 动作总时长
	BAForPlayRandomSound.animationName 			= "A006" -- 行走动作名称
	BAForPlayRandomSound.soundDelay 			= nil
	BAForPlayRandomSound.soundDelayCost 		= nil
	BAForPlayRandomSound.delayComplete 			= nil


	BAForPlayRandomSound.DELAY_FRAME 			= 5
	------------------ functions -----------------------
 	function BAForPlayRandomSound:start()

 		
		if(self.soundNameLib ~= nil and #self.soundNameLib > 0 and 
		   self.soundDurationLib ~= nil and #self.soundDurationLib > 0 and 
		   #self.soundDurationLib == #self.soundNameLib) then


			 self.actionDuration 	=  db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName) * BATTLE_CONST.FRAME_TIME - self.DELAY_FRAME * BATTLE_CONST.FRAME_TIME	-- todo load from db
			 self.num 				= #self.soundNameLib
			 self.soundCost 		= 0
			 self.soundDelayCost 	= 0
			 self.delayComplete 	= false
			 -- self:playNextRandomSound()
			 self:addToRender()
			 self:startDelay()
		else
			self:complete()
		end
		
	end
	function BAForPlayRandomSound:startDelay( ... )
		self.soundDelayCost 		= 0
		self.soundDelay 			= self.DELAY_FRAME * BATTLE_CONST.FRAME_TIME
		self.delayComplete 			= false
	end
	function BAForPlayRandomSound:playNextRandomSound( ... )

		local randomIndex =  math.floor(math.random()*self.num+1)
		if(randomIndex == self.lastRandomIndex) then
			randomIndex = randomIndex%self.num + 1
		end
		local soundName 	 = self.soundNameLib[randomIndex]
		-- print("playNextRandomSound",soundName)
		self.soundDuration   = self.soundDurationLib[randomIndex]
		self.soundCost 		 = 0
		self.lastRandomIndex = randomIndex
		BattleSoundMananger.removeSound(soundName)
		BattleSoundMananger.playEffectSound(soundName,false)
	end

	function BAForPlayRandomSound:update( dt )
		-- print("--- BAForPlayRandomSound:update",dt,self.soundCost,self.soundDuration,"actionDuration:",self.actionDuration)
		if(self.soundDelayCost >= self.soundDelay) then
			if(self.delayComplete == false) then
				-- if(self.soundDelayCost)

				self:playNextRandomSound()
				-- self.soundCost = self.soundCost + self.soundDelayCost - self.soundDelay
				self.delayComplete = true
			else
				self.soundCost = self.soundCost + dt
				-- self.delayComplete = 
				if(self.soundCost >= self.actionDuration) then
				-- if(self.soundCost >= self.actionDuration) then
					-- self:playNextRandomSound()
					self:startDelay()
				end
			end
			
		else
			self.soundDelayCost = self.soundDelayCost + dt
		end
	end

	function BAForPlayRandomSound:release( ... )
		self.super.release(self)
		self.soundNameLib 		= nil
		self.soundDurationLib 	= nil
	end

return BAForPlayRandomSound