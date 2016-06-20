
--- 战斗录像播放

local BattleRecordPlayMediator = class("BattleRecordPlayMediator")
 BattleRecordPlayMediator.name 			= "BattleRecordPlayMediator"


 	------------------ properties ----------------------
 	BattleRecordPlayMediator.state 				= nil
 	BattleRecordPlayMediator.skipingBattle 	    = nil -- 是否是跳过战斗状态
 	BattleRecordPlayMediator.behavierTree		= nil -- action
 	BattleRecordPlayMediator.behavierTreeMap  	= nil
 	BattleRecordPlayMediator.recordData 		= nil -- 录像数据
 	BattleRecordPlayMediator.runAction 			= false
 	BattleRecordPlayMediator.round 				= nil
 	BattleRecordPlayMediator.activedBehavierMap = nil -- 已经激活过的行为树节点(激活是指触发过执行下一个人物回合的行为)

 	BattleRecordPlayMediator.fightingTalksMap 	= nil -- 对战回合 -> talkid
 	BattleRecordPlayMediator.startTalkid 		= nil -- 开始对话
 	BattleRecordPlayMediator.endTalkid 			= nil -- 结束对话
 	
 	BattleRecordPlayMediator.afterTalkRun		= nil -- 对话完成后执行什么
 	-- BattleRecordPlayMediator.skiping			= nil -- skip会等待一会儿,然后发送事件,这个阶段不接受skip事件
 	
 	BattleRecordPlayMediator.pauseRounds		= nil -- 暂停回合
 	BattleRecordPlayMediator.paused 			= nil
 	BattleRecordPlayMediator.armyBattlingLogic  = nil -- 战斗中逻辑
 	BattleRecordPlayMediator.roundLogicAction 	= nil -- 
 	BattleRecordPlayMediator.isOnLogic 			= false
 	BattleRecordPlayMediator.roundLogicHistory  = nil

 	-- BattleRecordPlayMediator.fightingTalksMapRaw		s	= nil -- 原始对话数据
 	-- BattleRecordPlayMediator.talkPlayHistory 	= nil
 	------------------ const ----------------------
 	BattleRecordPlayMediator.STATE_IDLE 		= 0
 	BattleRecordPlayMediator.STATE_PLAYING 		= 1
 	BattleRecordPlayMediator.STATE_TALK 		= 2
 	BattleRecordPlayMediator.STATE_ROUND_LOGIC 	= 3

 	BattleRecordPlayMediator.AFTER_TALK_NONE	 = 0
 	BattleRecordPlayMediator.AFTER_TALK_RUN_NEXT = 1
 	BattleRecordPlayMediator.AFTER_TALK_COMPLETE = 2

 	------------------ functions -----------------------
 		function BattleRecordPlayMediator:getInterests( ... )
			-- local  ins = require("script/notification/NotificationNames")
			return {	
						NotificationNames.EVT_PLAY_RECORD_START ,-- 初始化
	 					NotificationNames.EVT_PLAY_RECORD_COMPLETE , -- 开始配置阵型
	 					NotificationNames.EVT_BATTLE_SKIP_RECORD, -- 跳过战斗
	 					-- NotificationNames.EVT_TALK_PLAY_TALK_COMPLETE,-- 对话完成
	 					NotificationNames.EVT_REPLAY_RECORD ,-- 重播
	 					NotificationNames.EVT_RECORD_CONTINUE_PLAY, -- 继续播放
	 					NotificationNames.EVT_RECORD_PLAY_NEXT_PLAYER_ROUND, -- 提前播放下一个

					}
		end



		function BattleRecordPlayMediator:onRegest( ... )
			-- 注册回调
			--print("BattleFormationMediator onRegest")
			self.waitSkinBattle 				= false
			self.state 							= self.STATE_IDLE
			self.round 							= 0
			self.afterTalkRun 					= self.AFTER_TALK_NONE
			BattleSoundMananger.reset()
			self.behavierTreeMap 				= {}
			self.activedBehavierMap 			= {}
			-- EventBus.addEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete,self)
		end -- function end

		function BattleRecordPlayMediator:onRemove( ... )
		 
			self:removeBehavers()
			self:removeRoundLogic()
			self.activedBehavierMap 			= {}
			-- BattleActionRender.removeAll()
			-- BattleActionRender.stop()
			-- BattleLayerManager.clearAnimationLayer()
			self:setIdle()		

			
			self.afterTalkRun = self.AFTER_TALK_NONE
			-- EventBus.removeEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete)
	 		Logger.debug("!!!! BattleRecordPlayMediator:onRemove")
		end -- function end

		function BattleRecordPlayMediator:getHandler()
			return self.handleNotifications
		end

		function BattleRecordPlayMediator:getRoundLogicInfo()
			if(self.armyBattlingLogic) then
				local roundInfo = "round_" ..  BattleMainData.fightRecord:getNextRoundAttackerStringInfo()
				Logger.debug("=== roundlogic:" .. roundInfo)
				if(self.armyBattlingLogic[roundInfo]) then
					return true,self.armyBattlingLogic[roundInfo],roundInfo
				end
			end
			return false
		end

		function BattleRecordPlayMediator:playRoundLogic( ... )
			 local hasLogic,logicData,roundInfo = self:getRoundLogicInfo()
			 
			 if(hasLogic and logicData and self.roundLogicHistory[roundInfo] == nil) then
			 		self.state = self.STATE_ROUND_LOGIC
			 		self.roundLogicHistory[roundInfo] = true
			 		self:removeRoundLogic()
			 		self.isOnLogic = true
			 		self.roundLogicAction 					= require(BATTLE_CLASS_NAME.BAForBSAction).new()
			        self.roundLogicAction.blackBoard 		= {}
			   		self.roundLogicAction.logicData 		= logicData
					self.roundLogicAction.name 			= "army show"
			        self.roundLogicAction:addCallBacker(self,self.onRoundLogicComplete)
			        self.roundLogicAction:start()

			 else
			 	-- Logger.debug("=== 木有roundlogic数据")
			 	self:onRoundLogicComplete()
			 end

		end


		function BattleRecordPlayMediator:removeRoundLogic( ... )
			if(self.roundLogicAction) then
			 		self.roundLogicAction:release()
			 		self.roundLogicAction = nil
			end
			self.isOnLogic = false
		end
		

		function BattleRecordPlayMediator:onRoundLogicComplete( ... )
			self.isOnLogic = false
			self:removeRoundLogic()
			self.state = self.STATE_IDLE
			self:playNextPlayRound()

		end

		function BattleRecordPlayMediator:showShipInfo()
			self.team1ShipInfo = require(BATTLE_CLASS_NAME.BAForShowShipInfo).new()
			self.team1ShipInfo.teamid = BATTLE_CONST.TEAM1
			BattleActionRender.addAutoReleaseAction(self.team1ShipInfo)
			-- self.team1ShipInfo:start()

			self.team2ShipInfo = require(BATTLE_CLASS_NAME.BAForShowShipInfo).new()
			self.team2ShipInfo.teamid = BATTLE_CONST.TEAM2
			BattleActionRender.addAutoReleaseAction(self.team2ShipInfo)


			self.team1ShipFightUp = require(BATTLE_CLASS_NAME.BAForShowTeamFightUpAnimation).new()
			self.team1ShipFightUp.teamid = BATTLE_CONST.TEAM1
			BattleActionRender.addAutoReleaseAction(self.team1ShipFightUp)
			

			-- self.team2ShipInfo:start()
		end

		function BattleRecordPlayMediator:handleNotifications(eventName,data)
			if eventName ~= nil then
				-- 开始播放战报
				if eventName == NotificationNames.EVT_PLAY_RECORD_START then
					if(self:isIdle()) then
						BattleMainData.resetEffectsMap()
						BattleState.setPlayRecordState(true)
						self:setPlaying()
						-- 初始化对话数据:开始对话,结束对话,战斗中对话
						self.armyBattlingLogic = data
						self.roundLogicHistory = {}
 						-- data = data or {}
					 	-- self.fightingTalksMap				= data.fightingTalks
					 	-- -- for k,v in pairs(self.fightingTalksMap) do
					 	-- -- 	print("fightingTalksMap:",k,v)
					 	-- -- end
					 	-- -- table.insert(self.fightingTalksMap,11)
					 	-- -- self.fightingTalksMap[1] = 11
					 	-- self.pauseRounds 					= data.pauseRounds
					 	-- self.startTalkid 					= data.startTalkid
					 	-- self.endTalkid						= data.completeTalkid -- 11--
					 	-- if(self.endTalkid) then
					 	-- 	Logger.debug("EVT_PLAY_RECORD_START:endTalkid:" .. self.endTalkid )
					 	-- else
					 	-- 	Logger.debug("EVT_PLAY_RECORD_START:endTalkid is nill")
					 	-- end
					 	-- self.afterTalkRun 					= self.AFTER_TALK_NONE
					 	self.waitSkinBattle 				= false
					 	-- self.skiping						= false
					 	self.skipingBattle 					= false
					 	-- self:showShipInfo()
					 	self:delayPlay()
                        -- behavierTree:addCallBacker()
                       -- behavierTree:reset(BattleNodeFactory.test,roundData:getBlackBoard())
                       
					else
						error("Battle record is playing ")
					end
				-- elseif eventName == NotificationNames.EVT_PLAY_RECORD_COMPLETE then
				-- 重播
				elseif eventName == NotificationNames.EVT_REPLAY_RECORD then
					-- 
						BattleActionRender.removeAll()
						BattleActionRender.start()
						BattleLayerManager.clearAnimationLayer()
						self:setPlaying()

						self.activedBehavierMap 			= {}
						self:removeBehavers()

						self.waitSkinBattle 				= false
					 	-- self.skiping						= false
					 	self.skipingBattle 					= false
					 	self.paused 						= false
					 	for k,v in pairs(self.pauseRounds or {}) do
					 		self.pauseRounds = true
					 	end
					 	self:delayPlay()
				-- 继续播放当前战斗(如果是在pause状态)
				elseif eventName == NotificationNames.EVT_RECORD_CONTINUE_PLAY then
						if(self.paused) then
							self.paused = false
							-- self.pauseRounds[BattleMainData.fightRecord:getNextRoundNumber()] = false
							self:playNextPlayRound()
						end
				-- 提前预播下一个人物回合
				elseif eventName == NotificationNames.EVT_RECORD_PLAY_NEXT_PLAYER_ROUND then
					-- print(" ==== handle preNext evt:1")
					-- -- 删除上一个
					if(data and data.release and data.instanceName) then
						local iname = data:instanceName()
						if(iname and self.activedBehavierMap[iname] ~= true) then
						   -- print(" ==== handle preNext evt:2")
						   self.activedBehavierMap[iname] = true
						   self:playNextPlayRound(0.15)
						end

					end
					-- 	local removeResult = {}
					-- 	for k,v in pairs(self.behavierTreeMap or {}) do
					-- 		if(data == v) then
					-- 			data:release()
					-- 			-- 因为key 为string 所以我们只存储要删除的key即可(id_xxx)
					-- 			table.insert(removeResult,k)
					-- 		end

					-- 	for k,v in pairs(removeResult or {}) do
					-- 		self.behavierTreeMap[k] = nil
					-- 	end
					-- end


				-- 跳过战斗录像
				elseif eventName == NotificationNames.EVT_BATTLE_SKIP_RECORD then
					-- 对话中 移动中 不允许调过战斗
					if(self:isRoundLogic() or self:isMove()) then return end 
					
					-- --print("skipBattle click")
					if(self.skipingBattle   ~= true) then
						self:removeBehavers()
						BattleActionRender.removeAll(true)
						BattleActionRender.start()
						BattleLayerManager.clearAnimationLayer()


						-- 清除英雄动作
						if(BattleMainData.fightRecord ~= nil) then
							BattleMainData.fightRecord:stopAllPlayerAction()
						end

						self:skipBattle()
						BattleShipDisplayModule.resetPosition()
						 -- local actionArr = CCArray:create()
					  --       actionArr:addObject(CCDelayTime:create(0.5))
					  --       actionArr:addObject(CCCallFunc:create(function( ... )
					  --       	self:sendRecordCompleteEvt()
					  --       end))
					  --       local actions = CCSequence:create(actionArr)

					  --       BattleLayerManager.battleAnimationLayer:runAction(actions)
					        
						self.skipingBattle  = true
						--  
	 					-- 跳过战斗可能会导致mask不被删除,这里 fix 一下
						-- Logger.debug("== removeMask 1")
						local layer = BattleLayerManager.battlePlayerLayer 
						if(
							layer and 
							not tolua.isnull(layer) and
							layer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG) ~= nil
						  ) then
							Logger.debug("== removeMask 2")
							layer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
						end
	 
					end
				end
					-- for id,info in pairs(infoes) do
					-- 	--print("hero:",id," hp:",info[1])
					-- end -- for end
				-- elseif eventName == NotificationNames.EVT_QUIT_BATTLE then

				-- -- 对话完毕
				-- elseif eventName == NotificationNames.EVT_TALK_PLAY_TALK_COMPLETE then
				-- 	if(self.afterTalkRun == self.AFTER_TALK_COMPLETE) then

				-- 		self:sendRecordCompleteEvt()

				-- 	elseif(self.afterTalkRun == self.AFTER_TALK_RUN_NEXT) then
				-- 		self:playNextPlayRound()
				-- 	else
				-- 		--print("BattleRecordPlayMediator 收到对话结束事件,不执行任何改变")
				-- 		self.afterTalkRun = self.AFTER_TALK_NONE
				-- 	end
				-- 	self.state = self.STATE_PLAYING
				-- end -- if end
			end -- if end
		end

		function BattleRecordPlayMediator:skipBattle( ... )
								-- 
			-- local infoes = BattleMainData.fightRecord:getFinalDamageMap()
			-- for k,v in pairs(infoes) do
			-- 	local target = BattleMainData.fightRecord:getTargetData(k)
			-- 	assert(target)
			-- 	target:toState(v[1])
			-- 	-- target:resetActions()
			-- end
			-- BattleMainData.fightRecord.replayed = true
			-- BattleMainData.replayed = true
			BattleMainData.fightRecord:toEndState()

			 local actionArr = CCArray:create()
	        actionArr:addObject(CCDelayTime:create(1))
	        actionArr:addObject(CCCallFunc:create(function( ... )
	        	Logger.debug("===== skipBattleDelay complete")
	        	
	        	 

	        	self:sendRecordCompleteEvt()
	        end))
	        local actions = CCSequence:create(actionArr)

	        BattleLayerManager.battleAnimationLayer:runAction(actions)
				        

		end
		-- 播放下一回合数据
		function BattleRecordPlayMediator:playNextPlayRound( delay )

			-- local needDelay = BattleMainData.fightRecord:isFirstPlayerRound()
			-- Logger.debug("==BattleRecordPlayMediator:play:"..BattleMainData.fightRecord.index)
			-- BattleMainData.fightRecord:printHpInfo()
			-- 获取下一回合
			local nextRound = tonumber(BattleMainData.fightRecord:getNextRoundNumber())
			-- local nextRound = self.round
			-- Logger.debug("nextRound:%d,pauseRounds:%s",nextRound,tostring(self.pauseRounds[nextRound]))
			
			-- 检测是否有需要停止
			if(self.pauseRounds and (self.pauseRounds[nextRound] == true or self.pauseRounds[tostring(nextRound)] == true)) then
				self.paused = true
				self.pauseRounds[nextRound] = false
				EventBus.sendNotification(NotificationNames.NotificationNames.EVT_RECORD_PAUSED)
				return
			end

			-- 获取下一小回合数据
			local roundData = BattleMainData.fightRecord:getNextRoundData()
    		if(roundData) then
    			-- roundData:debugDamageInfo()
    			self.state 						= self.STATE_PLAYING
    			self.round 						= roundData.round
    			EventBus.sendNotification(NotificationNames.NotificationNames.EVT_UI_REFRESH_ROUND,self.round)
    			Logger.debug("			")
    			Logger.debug("============ BattleRecordPlayMediator -  self:round->" .. self.round .. " index:" .. BattleMainData.fightRecord.index)
				local behavierTree 				= require(BATTLE_CLASS_NAME.BAForBSAction).new()
                behavierTree.name 			= "BattleRoundLogicData"

                local isShip = BattleShipDisplayModule.isShip(roundData.attacker)
                
                print("===== is ship:",tostring(isShip),roundData.attacker)
	              
                if(isShip ~= true) then
                	behavierTree.blackBoard 	= require(BATTLE_CLASS_NAME.BSBattleRoundBB).new()
	                behavierTree.blackBoard:reset(roundData,delay)
	                behavierTree.blackBoard.node = behavierTree
	                behavierTree.logicData 	= BattleRoundLogicData.getLogicData()
	                behavierTree:addCallBacker(self,self.handlePlayRoundComplete)
	                self.behavierTreeMap[behavierTree:instanceName()] = behavierTree
	                
	            else
	            	behavierTree.blackBoard 	= require(BATTLE_CLASS_NAME.BSShipSkillRoundBBData).new()
	            	behavierTree.blackBoard:reset(roundData)
	                behavierTree.blackBoard.node = behavierTree
	                behavierTree.logicData 	= ShipRoundLogic.getLogicData()
	                behavierTree:addCallBacker(self,self.handlePlayRoundComplete)
	                self.behavierTreeMap[behavierTree:instanceName()] = behavierTree
	            end

	            behavierTree:start()

            else
  
			 		self:sendRecordCompleteEvt()
 
            end
		end

		function BattleRecordPlayMediator:delayPlay( ... )
			self.delayAction 						= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
 			self.delayAction.total 					= 0.2 
 			self.delayAction:addCallBacker(self,self.onDelayActionComplete)
 			self.delayAction:start()
		end
		function BattleRecordPlayMediator:onDelayActionComplete( ... )

			 if(self:isPlaying()) then
			 	 self:playRoundLogic()
				 
	         end
		end

		function BattleRecordPlayMediator:sendRecordCompleteEvt( ... )

			Logger.debug("===================  sendRecordCompleteEvt")
			-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
		   			

			self.delayAction 						= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
 			self.delayAction.total 					= 0.1 
 			self.delayAction:addCallBacker(self,self.onDelayComplete)
 			self.delayAction:start(true)

 			BattleState.setPlayRecordState(false)
 			 
		end
		
		function BattleRecordPlayMediator:onDelayComplete( ... )
			Logger.debug("==EVT_BATTLE_RECORD_PLAY_COMPLETE")
			-- self.state 							= self.STATE_IDLE
			self:setIdle()
	 	    -- 播放人物回合动画
			EventBus.sendNotification(NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE,self.skipingBattle)
		
		end

		function BattleRecordPlayMediator:handlePlayRoundComplete( data )
			print("--handlePlayRoundComplete")
			local removeNodes = {}
			local activeNext  = false
			-- 删除所有完成状态的节点
			if(self.behavierTreeMap) then
				
				for k,v in pairs(self.behavierTreeMap or {}) do
					if(v:isCompleteState() == true) then
						print("==== remove BS Node")
						table.insert(removeNodes,k)
					end				
				end

				for k,v in pairs(removeNodes or {}) do
					if(self.behavierTreeMap[v] ~= nil) then
						self.behavierTreeMap[v]:release()
						self.behavierTreeMap[v] = nil
					end
					if(self.activedBehavierMap[v] ~= true) then
						activeNext = true
						self.activedBehavierMap[v] = true
					end

				end
			end

		 
			if(true ~= self.waitSkinBattle) then
				-- local  strRound = tostring(self.round)

				if(activeNext == true) then
					local strRound = tostring(BattleMainData.fightRecord:getNextRoundNumber())
					self:playRoundLogic()
				end
				
			 
			else
				if(self.skipingBattle ~= true) then
					self.skipingBattle = true
					self:skipBattle()
				end

				-- EventBus.sendNotification(NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE)
			end


		end
 
 
		function BattleRecordPlayMediator:removeBehavers( ... )
			for k,v in pairs(self.behavierTreeMap or {}) do
				v:release()
			end
			self.behavierTreeMap = {}
		end
 
		-- 对话回调完毕
		function BattleRecordPlayMediator:onTalkComplete( ... )
			 -- self.state 		= self.STATE_PLAYING
			 self:playNextPlayRound() 
		end

		function BattleRecordPlayMediator:setIdle( ... )
			self.state = self.STATE_IDLE
		end

		function BattleRecordPlayMediator:setPlaying( ... )
			self.state = self.STATE_PLAYING
		end

		function BattleRecordPlayMediator:isIdle( ... )
			return self.state == self.STATE_IDLE
		end	

		function BattleRecordPlayMediator:isPlaying( ... )
			return self.state == self.STATE_PLAYING
		end

		function BattleRecordPlayMediator:isRoundLogic( ... )
			return self.state == self.STATE_ROUND_LOGIC
		end

		-- function BattleRecordPlayMediator:isTalk( ... )
		-- 	return self.state == self.STATE_TALK
		-- end
		function BattleRecordPlayMediator:isMove( ... )
			if(BattleMainData.isMoving) then
				Logger.debug("BattleMainData.isMoving:" .. tostring(BattleMainData.isMoving))
			else
				Logger.debug("BattleMainData.isMoving:nil")
			end
			return BattleMainData.isMoving
		end
 return BattleRecordPlayMediator