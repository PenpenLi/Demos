


--- 队伍上场逻辑

local BattleTeamShowMediator 					= class("BattleTeamShowMediator")
 BattleTeamShowMediator.name 					= "BattleTeamShowMediator"

 
	------------------ properties ----------------------
	BattleTeamShowMediator.state 				= nil
	BattleTeamShowMediator.action 				= nil -- 逻辑树action


	BattleTeamShowMediator.STATE_RUNNING 		= 1
	BattleTeamShowMediator.STATE_IDEL			= 2


	------------------ functions -----------------------
	function BattleTeamShowMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_TEAM_SHOW_START,					-- 初始化
					NotificationNames.EVT_TEAM_ENDSHOW_START
					-- NotificationNames.EVT_BATTLE_SKIP_RECORD
				}
	end -- function end

	function BattleTeamShowMediator:onRegest( ... )
		-- --print()
		--print("BattleTeamShowMediator onRegest")
		self.state = self.STATE_IDEL
		ObjectTool.setProperties(self)
		--print("BattleTeamShowMediator:onRegest:",self.instanceName())
	end -- function end

	function BattleTeamShowMediator:onRemove( ... )
 		self.state = self.STATE_IDEL
 		if(self.action) then
 			self.action:release()
 			self.action = nil
 		end
 			Logger.debug("!!!! BattleTeamShowMediator:onRemove")
 		--print("BattleTeamShowMediator:onRemove:",self.instanceName())
	end -- function end

	function BattleTeamShowMediator:getHandler()
		return self.handleNotifications
	end


	function BattleTeamShowMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		-- --print("StrongHoldMediator handleNotifications call:",eventName,"data:",data)
		if eventName ~= nil then
			-- 开始执行团队上场逻辑
			if eventName == NotificationNames.EVT_TEAM_SHOW_START then

				if(self.STATE_IDEL == self.state) then

					self:startShow(data)
				else
					error("BattleTeamShowMediator 正在执行")
				end -- if end
		 	elseif(eventName == NotificationNames.EVT_TEAM_ENDSHOW_START) then
		 		-- print("--- EVT_TEAM_ENDSHOW_START")
		 		if(self.STATE_IDEL == self.state) then

					self:showEndLogic(data)
				else
					error("BattleTeamShowMediator 正在执行")
				end -- if end
			end -- if end
		end -- ifend
	end

 	function setStrongHoldInfo( blackBoard )
		if(BattleMainData.strongholdData ~= nil) then
        	blackBoard.strongHoldName = BattleMainData.strongholdData.displayName
        	blackBoard.currentNum = BattleMainData.strongholdData.index
        	blackBoard.totalNum = BattleMainData.strongholdData.total
        end
 	end

	function BattleTeamShowMediator:startShow(data)

			
		EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)
                        
		self.state 						= self.STATE_RUNNING
		self.armyid = 0
		if(data ~= nil and tonumber(data) > 0) then
			self.armyid = data
		else
			if(BattleMainData.strongholdData ~= nil) then
				local armyData 					= BattleMainData.strongholdData:getCurrentArmyData()
				if(armyData) then
					self.armyid = armyData.id
				else
					Logger.debug("== armyData is nil")
				end

			end
		end

		if(self.armyid > 0) then
			local logic  = battleShow.indexLogicByArmyID(self.armyid)
			assert(logic,"战斗出场逻辑为空")
			-- print_table("logic:",logic)
			-- self.action  = require(BATTLE_CLASS_NAME.BAForArmyTeamMoveIn).new()
			-- self.action:addCallBacker(self,self.onShowComplete)
				-- self.action:start()
			-- print(logic)
			Logger.debug("BattleTeamShowMediator:startShow %d",self.armyid)
			self.action 				= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        self.action.blackBoard 		= {}
	        setStrongHoldInfo(self.action.blackBoard)
 
	   		self.action.logicData 		= logic
			self.action.name 			= "army show"
	        self.action:addCallBacker(self,self.onShowComplete)
	        self.action:start()
		else
			self:onShowComplete()
		end 
		 
	end
 


	function BattleTeamShowMediator:showEndLogic( data )
		
		EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)
                        
		self.state 						= self.STATE_RUNNING
		-- print("--- EVT_TEAM_ENDSHOW_START data:" .. tostring(data))

		self.armyid = 0
		if(data ~= nil and tonumber(data) > 0) then
			self.armyid = data
		else
			if(BattleMainData.strongholdData ~= nil) then
				local armyData 					= BattleMainData.strongholdData:getCurrentArmyData()
				if(armyData) then
					self.armyid = armyData.id
				else
					Logger.debug("== armyData is nil")
				end

			end
		end

		-- local armyData 					= BattleMainData.strongholdData:getCurrentArmyData()
		-- Logger.debug("=== BattleTeamShowMediator:startEndShow 1")
		if(self.armyid > 0) then
			Logger.debug("=== BattleTeamShowMediator:startEndShow %d",self.armyid)	
			local needPlay = battleEndShow.hasArmyLogic(self.armyid)
			if(needPlay) then
				local logic  = battleEndShow.indexLogicByArmyID(self.armyid)
				assert(logic,"战斗退场逻辑为空")
				-- print_table("logic:",logic)
				-- self.action  = require(BATTLE_CLASS_NAME.BAForArmyTeamMoveIn).new()
				-- self.action:addCallBacker(self,self.onShowComplete)
					-- self.action:start()
				-- print(logic)
				Logger.debug("BattleTeamShowMediator:endShow %d",self.armyid)
				self.action 				= require(BATTLE_CLASS_NAME.BAForBSAction).new()
		        self.action.blackBoard 		= {}
	        	setStrongHoldInfo(self.action.blackBoard)
		   		self.action.logicData 		= logic
	 			self.action.name 			= "army end show"
		        self.action:addCallBacker(self,self.onEndShowComplete)
		        self.action:start()
		        
		        Logger.debug("== battle endshow start")
		    else

		    	self:onEndShowComplete()
		    end
	    else
	    	Logger.debug("== armyData is nil")
		end
	end

	function BattleTeamShowMediator:onEndShowComplete( ... )
		self.state 					= self.STATE_IDEL
		self.action					= nil
		EventBus.sendNotification(NotificationNames.EVT_TEAM_ENDSHOW_COMPLETE)
	end


	function BattleTeamShowMediator:onShowComplete()
		--print("StrongHoldMediator BattleTeamShowMediator:onShowComplete")
		-- local armyData 					= BattleMainData.strongholdData:getCurrentArmyData()
		Logger.debug("BattleTeamShowMediator:complete %d",self.armyid)
		BattleMainData.isMoving     = false
 		-- BattleTeamDisplayModule.printSelfState()
		self.state 					= self.STATE_IDEL
		self.action					= nil
		EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_COMPLETE)
	end

return BattleTeamShowMediator