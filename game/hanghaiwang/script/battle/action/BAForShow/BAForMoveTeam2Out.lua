


-- 目标将team2从现在位置移动到屏幕外
local BAForMoveTeam2Out = class("BAForMoveTeam2Out",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForMoveTeam2Out.data 					= nil -- 移动目标索引
	BAForMoveTeam2Out.soundCountTime 		= nil -- 声音播放时间(用于从新播放音效)
	BAForMoveTeam2Out.walkSound 				= nil -- 行走音效名称
	BAForMoveTeam2Out.costTime  				= nil -- 行走已花费时间
	BAForMoveTeam2Out.moveTargets 			= nil -- 移动目标
	------------------ functions -----------------------
	function BAForMoveTeam2Out:start( ... )
		self.moveTargets = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data,true)
		if(self.moveTargets and #self.moveTargets > 0) then

			for k,displayData in pairs(self.moveTargets) do
				displayData:playMoveAnimation(true)
				-- displayData:setVisible(true)
				-- displayData:moveBy(0,-BattleMainData.moveDistence)
			end

			self:addToRender()
			self.costTime 							= 0
 			-- self.soundCountTime 					= 0
		  -- 	self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()

		else
			Logger.debug("BAForMoveTeam2Out:start 直接结束")
			self:complete()
		end
	end


	function BAForMoveTeam2Out:update( dt )
		-- Logger.debug("BAForMoveTeam2Out:update:"..self.costTime .. "/" .. BATTLE_CONST.HERO_MOVE_COST_TIME) 
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
			local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * (BattleMainData.moveDistence + 200)
			for k,v in pairs(self.moveTargets) do
				v:moveBy(0,dy)
			end
			if(self.walkSoundPlayer) then
		 		self.walkSoundPlayer:update(dt)
			end
		end
	end


return BAForMoveTeam2Out