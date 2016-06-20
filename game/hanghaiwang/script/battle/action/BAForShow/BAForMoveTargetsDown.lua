
-- 目标向下移动(用于team2)
local BAForMoveTargetsDown = class("BAForMoveTargetsDown",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForMoveTargetsDown.data 				= nil -- 移动目标索引
	BAForMoveTargetsDown.soundCountTime 	= nil -- 声音播放时间(用于从新播放音效)
	BAForMoveTargetsDown.walkSound 			= nil -- 行走音效名称
	BAForMoveTargetsDown.costTime  			= nil -- 行走已花费时间
	BAForMoveTargetsDown.moveTargets 		= nil -- 移动目标
	------------------ functions -----------------------
	function BAForMoveTargetsDown:start( ... )
		-- Logger.debug("--- BAForMoveTargetsDown:start")
		self.moveTargets = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(self.moveTargets and #self.moveTargets > 0) then

			for k,displayData in pairs(self.moveTargets) do
				displayData:playMoveAnimation(true)
				-- displayData:setVisible(true)
				displayData:moveBy(0,BattleMainData.moveDistence)
			end

			self:addToRender()
			self.costTime 							= 0
 			-- self.soundCountTime 					= 0
		  	-- self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
		  	-- self.walkSound 							= "A006_step_02" --
		  	-- self.walkSound 							= "A006_step_01" --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
 			-- Logger.debug("--- " .. tostring(self.walkSound))
 			-- registLoopSound
			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()
		else
			Logger.debug("BAForMoveTargetsDown:start 直接结束")
			self:complete()
		end
	end


	function BAForMoveTargetsDown:update( dt )
		-- Logger.debug("BAForMoveTargetsDown:update:"..self.costTime .. "/" .. BATTLE_CONST.HERO_MOVE_COST_TIME) 
		-- self.soundCountTime = self.soundCountTime + dt
		-- if(self.soundCountTime >= BATTLE_CONST.WALK_SOUND_TIME) then
		-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
		-- 	 self.soundCountTime = 0
		-- end
		self.costTime = self.costTime + dt
		if(self.costTime >= BATTLE_CONST.HERO_MOVE_COST_TIME) then

			for k,v in pairs(self.moveTargets) do
				v:toStandState()
			end

			if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 			end
 

			BattleSoundMananger.stopAllLoop()
			self:complete()
			self:release()
		else
			local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * -BattleMainData.moveDistence
			for k,v in pairs(self.moveTargets) do
				v:moveBy(0,dy)
			end
			if(self.walkSoundPlayer) then
		 		self.walkSoundPlayer:update(dt)
			end

		end
	end


return BAForMoveTargetsDown