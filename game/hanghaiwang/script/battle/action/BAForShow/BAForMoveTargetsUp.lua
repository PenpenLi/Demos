
-- 目标向下移动(用于team2)
local BAForMoveTargetsUp = class("BAForMoveTargetsUp",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForMoveTargetsUp.data 				= nil -- 移动目标索引
	BAForMoveTargetsUp.soundCountTime 		= nil -- 声音播放时间(用于从新播放音效)
	BAForMoveTargetsUp.walkSound 			= nil -- 行走音效名称
	BAForMoveTargetsUp.costTime  			= nil -- 行走已花费时间
	BAForMoveTargetsUp.moveTargets 			= nil -- 移动目标
	------------------ functions -----------------------
	function BAForMoveTargetsUp:start( ... )
		self.moveTargets = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(self.moveTargets and #self.moveTargets > 0) then

			for k,displayData in pairs(self.moveTargets) do
				displayData:playMoveAnimation(true)
				-- displayData:setVisible(true)
				displayData:moveBy(0,-BattleMainData.moveDistence)
			end

			self:addToRender()
			self.costTime 							= 0
 			-- self.soundCountTime 					= 0
		  -- 	self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()

		else
			Logger.debug("BAForMoveTargetsUp:start 直接结束")
			self:complete()
		end
	end


	function BAForMoveTargetsUp:update( dt )
		-- Logger.debug("BAForMoveTargetsUp:update:"..self.costTime .. "/" .. BATTLE_CONST.HERO_MOVE_COST_TIME) 
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
			local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * BattleMainData.moveDistence
			for k,v in pairs(self.moveTargets) do
				v:moveBy(0,dy)
			end
			if(self.walkSoundPlayer) then
		 		self.walkSoundPlayer:update(dt)
			end
		end
	end


return BAForMoveTargetsUp