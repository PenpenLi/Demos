-- 游戏阵型
local BattleFormationMediator = class("BattleFormationMediator")
 
	------------------ properties ----------------------
	
	BattleFormationMediator.name 				            = "BattleFormationMediator"
	BattleFormationMediator.dragTarget			        	= nil -- 拖拽目标
	BattleFormationMediator.dxy 				            = nil
	BattleFormationMediator.formationChanged 				= nil
	BattleFormationMediator.openSlots						= nil -- 当前阵型开放的位置
	BattleFormationMediator.onRequest 						= nil
	BattleFormationMediator.onPopUpState					= false -- 当前是弹出窗口状态(规避多点穿透bug用)
	BattleFormationMediator.benchOffAction 					= nil --替补下场动作
	-- BattleFormationMediator.onMoving 						= false
	-- BattleFormationMediator.onPopUpState					= nil
	-- BattleFormationMediator.revivePlay						= nil
	-- BattleFormationMediator.runList 						= nil
	------------------ functions -----------------------
	function BattleFormationMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					-- NotificationNames.EVT_FORMATION_GET ,-- 初始化

					-- 开始配置阵型
 					NotificationNames.EVT_FORMATION_START_CONFIG, 
 					-- 复活完毕
 					-- NotificationNames.EVT_REVIVE_HERO_COMPLETE,
 					NotificationNames.EVT_REVIVED_SUCCESS,
 					NotificationNames.EVT_REVIVED_FAILED
				}
	end
	function BattleFormationMediator:onRegest( ... )
		-- 注册回调
		self.onRequest 	= false
		-- self.onMoving 	= false
		self.onPopUpState = false
		--print("BattleFormationMediator onRegest")
		-- self.revivePlay 			= false
		-- self.runList				= {}
		-- EventBus.addEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete,self)
	end -- function end

	function BattleFormationMediator:onRemove( ... )
		self.dragTarget = nil
		self.openSlots = nil
		self.onRegest = false
		self.onPopUpState = false
		Logger.debug("!!!! BattleFormationMediator:onRemove")

		if(self.benchOffAction) then
			self.benchOffAction:release()
			self.benchOffAction = nil
		end

		-- self.onMoving =  false
		-- EventBus.removeEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete)
 		-- self.onPopUpState = false
	end -- function end

	function BattleFormationMediator:getHandler()
		return self.handleNotifications
	end

	function BattleFormationMediator:insertFunction(f)
		table.insert(self.runList,f)
	end

	function BattleFormationMediator:runNextFunction()
		
	end

	function BattleFormationMediator:isRunListComplete()
		

	end


	 
	function BattleFormationMediator:onBenchOffComplete( )
		if(self.benchOffAction) then
			self.benchOffAction:release()
			self.benchOffAction = nil
		end
		self:startConfigFormation()
	end

	-- -- 还原阵上的替补
	-- function BattleFormationMediator:revertBench( ... )
	-- 	-- 目前小时没有任何特效,直接删除,比较暴力
	-- 	-- 如果需要特效,那么先找出我方阵上需要还原的位置,然后替换成对应的显示即可
	-- 	Logger.debug("== revertBench 1")
	-- 	-- 重置上阵数据(上一场可能会有替补上场)
	-- 	if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info) then
	-- 		Logger.debug("== revertBench 2")
			
	-- 		local hasBenchActive = BattleMainData.fightRecord.team1Info.benchActiveNum > 0
	-- 		if(hasBenchActive == true) then
	-- 			Logger.debug("== revertBench 3")
	-- 			-- 获取所有非替补死亡人物
	-- 			local deathPlayers 	= BattleMainData.fightRecord.team1Info:getRawPlaysDeadList()
	-- 			local displays  	= {}
	-- 			if(self.benchOffAction) then self.benchOffAction:release() end

	-- 			self.benchOffAction    	= require(BATTLE_CLASS_NAME.BSSpawn).new()

	-- 			-- 生成已死亡人物显示
	-- 			for k,targetData in pairs(deathPlayers or {}) do
	-- 				-- local display 							= require("script/battle/ui/BattlPlayerDisplay").new()
	-- 				-- display:reset(targetData:getCardDisplayData())
	-- 				-- display:setParent(BattleLayerManager.battlePlayerLayer)
	-- 				-- table.insert(displays,display)
					
	-- 				Logger.debug("== revertBench 4")
	-- 				-- 替补渐隐 + 特效 + 人物渐现
	-- 				-- local fadeOut = nil
	-- 				-- benchOffAction:add(fadeOut)
	-- 				-- 替换
	-- 				BattleTeamDisplayModule.activeNewPlayer(targetData:getCardDisplayData(),targetData.positionIndex,BATTLE_CONST.TEAM1)
	-- 				local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(targetData.positionIndex)
	-- 				-- -- 置为ghost
	-- 				display:ghostState()
	-- 				-- -- alpha设置为0
	-- 				display:setOpacity(0)

	-- 				local position 				= display:globalCenterPoint()
	-- 				local playEffect 			= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
	-- 				playEffect.postionX 		= position.x
	-- 				playEffect.postionY 		= position.y
	-- 				playEffect.animationName 	= BATTLE_CONST.BSE_EFFECT2
	-- 				self.benchOffAction:add(playEffect)

	-- 				local fadeIn 	= require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
	-- 				fadeIn.targets 	= {display}
	-- 				fadeIn.time    	= 1
	-- 				self.benchOffAction:add(fadeIn)
	-- 			end

	-- 			self.benchOffAction:addCallBacker(self,self.onBenchOffComplete)
	-- 			self.benchOffAction:start() 


	-- 		-- 如果木有
	-- 		else 
	-- 		   Logger.debug("== revertBench none")
	-- 		   -- 设置ghost state
	-- 		   BattleTeamDisplayModule.removeSelfTeam()
	--            BattleTeamDisplayModule.createSelfTeamDisplayData(BattleMainData.selfTeamDisplayData)
	--            local deadPositions = BattleMainData.fightRecord.team1Info:getDeadList()
	--            for k,index in pairs(deadPositions or {}) do
	--              local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(index)
	--              if(display) then
	--                 display:ghostState()
	--              end
	--            end
	--            self:startConfigFormation()
	-- 		end
			
			
	-- 		-- 替补渐隐 + 特效 + 人物渐现


	-- 		BattleMainData.fightRecord.team1Info:resetToRawFomation()

	-- 		-- 将死亡人物添加到
	-- 		-- 获取最终替补上阵数据
	-- 		-- local benchOnFormation = BattleMainData.fightRecord:getBenchOnFormation()
	-- 		-- for pos,id in pairs(benchOnFormation or {}) do
	-- 		-- 	-- print("== revertBench revert pos:%d , id:%d",pos,id)
	-- 		-- 	local targetData = BattleMainData.fightRecord:getTargetData(tonumber(id))
	-- 		-- 	-- 替补上场位置替换为最初上阵人物
	-- 		-- 	target = BattleMainData.fightRecord:indexDataByIndexAndTeamid(pos,targetData.teamId)
	-- 		-- 	BattleTeamDisplayModule.activeNewPlayer(target:getCardDisplayData(),pos,target.teamId)
	-- 		-- 	target:linkDisplay()
	-- 		-- 	target:refreshDisplayState()
	-- 		-- end
	-- 	else
	-- 		 self:startConfigFormation()
	-- 	end
	-- end

	function BattleFormationMediator:enableCardRevived( ... )
		-- 鼠标响应 
		self:disableCardRevived()
		-- local onMouseEvent = function (eventType, postions)


		BattleTouchMananger.enableTouch()
		-- 检测鼠标当前拖拽的牌
		for k,card in pairs(BattleTeamDisplayModule.selfDisplayListByPostion or {}) do

					local onMouseEvent = function (eventType, x,y)
						print("card touch")
						return self:onCardTouchEvent(eventType,{x,y},card)	
					end
					BattleTouchMananger.addTouchListener(card,onMouseEvent,1)
		end
		
		-- BattleLayerManager.battleBaseLayer:setTouchEnabled(true)
		-- BattleLayerManager.battleBaseLayer:registerScriptTouchHandler(onMouseEvent,false,g_tbTouchPriority.battleLayer - 1,true)
		-- BattleLayerManager.battleBaseLayer:setTouchMode(kCCTouchesOneByOne)
		-- BattleLayerManager.battleBaseLayer:setTouchPriority(g_tbTouchPriority.battleLayer - 1)
	end

	function BattleFormationMediator:disableCardRevived( ... )
		-- BattleLayerManager.battleBaseLayer:setTouchEnabled(false)
	end
	function BattleFormationMediator:startConfigFormation( ... )
		 -- 开始战斗回调
			local doBattleClick = function() 
												if(self.onPopUpState) then
													return 
												end
												-- 如果是正在复活
											if(self.onRequest) then
											 	return 
											end
											if(self.dragTarget) then
												self.dragTarget:toRawPosition()
											end
											BattleLayerManager.battleBaseLayer:unregisterScriptTouchHandler()
												-- --print("doBattleClick:",self.view)
												
												self.view.doBattleButton:unregisterScriptTapHandler()
												self.view:releaseSelf()
												self.view = nil
												EventBus.sendNotification(NotificationNames.EVT_FORMATION_COMPLETE_CONFIG)
								 				
								 				-- 替补关闭复活
											EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_DISABLE_REVIVE)
								  end
		 	self.view.doBattleButton:registerScriptTapHandler(doBattleClick)
			self:enableCardRevived()
	end
	function BattleFormationMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		--print("BattleFormationMediator handleNotifications call:",eventName,"data:",data)
		if eventName ~= nil then
			-- 初始化阵型配置
			if eventName == NotificationNames.EVT_FORMATION_START_CONFIG then
				self.onRequest 	= false
				self.onPopUpState = false
				self.openSlots = FormationUtil.currentOpendPositions()
				if(self.view) then
	    			self.view:releaseSelf()
	 			end
	 			-- 如果需要阵型配置
				local needConfigFormation = BattleMainData.needConfigFormation()
				if(needConfigFormation) then

					-- 替补开启复活
					EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_ENABLE_REVIVE)
					
					-- 配置阵型底部ui
					self.view = require(BATTLE_CLASS_NAME.BattleFormationUI).new()
					self.view:init(BattleTeamDisplayModule.selfDisplayListByPostion,
								   BattleLayerManager.battleBackGroundLayer)
	    			self:startConfigFormation()


	   --  			 BattleTouchMananger.enableTouch()
	  	-- BattleTouchMananger.addTouchListener(self.container,function ( ... )
	  	-- 	self.container:setVisible(not self.container:isVisible())
	  	-- end,1)
	    			
					-- self:revertBench()
    			else
    					-- 替补关闭复活
						EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_DISABLE_REVIVE)

	 					EventBus.sendNotification(NotificationNames.EVT_FORMATION_COMPLETE_CONFIG)
	 									  
    			end
    			-- 开启复活状态
 				-- BattlPlayerDisplay:canReviveState

    		-- 复活成功
    		elseif eventName == NotificationNames.EVT_REVIVED_SUCCESS then
    			self.onRequest = false
    			-- 隐藏开始战斗按钮

             	-- 复活状态
             	-- self.revivePlay  =  true
             	-- 复活特效
             	-- 恢复正常状态
             	

             	 -- 复活翅膀动画
             	-- local onRevivedComplete = function ( ... )
             		BattleTeamDisplayModule.removeGhostHero(data.data.hid)
             	-- end

             	local animation = ObjectTool.getOnceAnimation(BATTLE_CONST.EFFECT_REVIVED_COMPLETE)
				
	 
			    animation:setPosition(data:globalCenterPoint())
 
		 		local container = BattleLayerManager.battleAnimationLayer
		 		container:addChild(animation)

 				self:enableCardRevived()
            -- 如果复活失败
            elseif eventName == NotificationNames.EVT_REVIVED_FAILED then
            	self.onRequest = false   
            end
 
		end-- if end
	end -- function end

	function BattleFormationMediator:onRevivedComplete()
		
	end

	function BattleFormationMediator:onCardTouchEvent(eventType, postions,card)
		Logger.debug("onCardTouchEvent:" .. eventType)
		if(self.onPopUpState == true) then
			return false
		end
		 -- 开始拖拽
		if eventType == "began" then
			if(self.dragTarget) then
				self.dragTarget:toRawPosition()
			end

			if(card) then
					Logger.debug("onCardTouchEvent:1")
					self.dragTarget  	= card
	             	self.dragTarget:toZOder(100)
	           		local location 		= card.container:convertToNodeSpace(ccp(postions[1],postions[2])) 
	             	self.dxy 		 	= location
	             	return true
			end
			return false

		elseif eventType == "moved" then
			self.onMoving = true
	    
	        if(nil~=self.dragTarget) then
	            -- local location = m_playerCardLayer :convertToNodeSpace(ccp(x, y))
	            local location = ccp(postions[1] - self.dxy.x,postions[2] - self.dxy.y)
	            -- self.dxy.x -
	            self.dragTarget.container:setPosition(location)
	        end
	        
	    else
	    	self.onMoving = false
	  
	        if(nil~=self.dragTarget) then
	            self:dropCard(self.dragTarget,postions[1],postions[2])
	            self.dragTarget = nil
	        end
	    end

	end
	 

	-- 释放卡牌
	function BattleFormationMediator:dropCard( dropCard , postionX , positionY )
		-- --print("dropCard:",postionX , positionY)
		-- 遍历所有开放的位置
		-- for k,card in pairs(BattleTeamDisplayModule.selfDisplayListByPostion or {}) do
		for k,card in pairs(self.view.unders or {}) do
			

				-- local cx = card.container:getPositionX() - card.cardBackSize.width/2
			 -- 	local cy = card.container:getPositionY() - card.cardBackSize.height/2
			 
			 	local node = tolua.cast(card,"CCNode")
			 	
			 	local size = node:getContentSize()
			 	local postion = ccp(node:getPositionX(),node:getPositionY())
			 	-- print("size:",size.width,size.height)
			 	local cx = postion.x - size.width/2
			 	local cy = postion.y - size.height/2 
			 	-- local cx = card.container:getPositionX() - card.cardBackSize.width/2
			 	-- local cy = card.container:getPositionY() - card.cardBackSize.height/2 
						     -- 如果卡牌在其他人物身上
	             if(
	             	
	             	postionX >= cx and
	                positionY >= cy and
	                postionX <= cx + size.width and
	                positionY <= cy + size.height
	                
	                ) then
	             	   local postionIndex = card:getTag()
	             	   assert(postionIndex)
	             	   -- Logger.debug("== postionIndex:" .. postionIndex)

	             	   local heroCard = BattleTeamDisplayModule.getSelfTeamHeroByPostion(postionIndex)
	             	   -- assert(heroCard)
	             	   -- 如果扔到别的卡片上
	             	   if(heroCard) then
	             	   	 	local heroData = BattleMainData.fightRecord
	             	   		 -- 如果是扔到别的卡牌上
				             if(dropCard ~= heroCard) then
				             	Logger.debug("dropCard" .. ":" .. "switchCard")
			             		BattleTeamDisplayModule.switchCard(heroCard,dropCard)
			             		BattleTouchMananger.updateTargets({heroCard,dropCard})
			             		-- Logger.debug("== switchCard" .. postionIndex)
				             	return
				             else
				             	Logger.debug("dropCard" .. ":" .. "hit on self")
				             -- 如果是单击了自己
				             	-- 检查复活
				             	-- 如果是死亡英雄
				             	-- print("dropCard on self,isDead->",heroCard.isDead)
				             	 -- Logger.debug("==dropCard on self,isDead->:" .. tostring(heroCard.isDead))
				             	if(heroCard.isDead) then
				             		local cast = BattleMainData.preGetRevivedCost()
				             		-- Logger.debug("will cast:%d,have silver:%d",cast,UserModel.getSilverNumber())
				             		if(cast <= UserModel.getSilverNumber()) then
				             			function doReviveCard(sender, eventType ) -- 确认按钮事件
											if (eventType == TOUCH_EVENT_ENDED) then
										 		self.onPopUpState = false
											    self.onRequest 	= true
											    -- 请求复活
											    BattleDataProxy.requestRevive(heroCard.data.hid,heroCard)
											    
											    LayerManager.removeLayout() -- 关闭提示框
											end
										end -- function end

										function cancleReviveCard()
											self.onPopUpState = false
											self.onRequest 	= false
										end
										self.onPopUpState = true
										-- Logger.debug("show revive window:%d,%d",cast,UserModel.getSilverNumber())
		            					ObjectTool.showTipWindow( BattleMainData.getRevivedInfo(),doReviveCard,cancleReviveCard)
		            					self:setRawPostion(dropCard)
		            					return 
				             		else
				             			function removeWindow(sender, eventType ) -- 确认按钮事件
											if (eventType == TOUCH_EVENT_ENDED) then
												 LayerManager.removeLayout() -- 关闭提示框
												 self.onPopUpState = false
											end
										end
										self:setRawPostion(dropCard)
										 -- BattleLayerManager.battleBaseLayer:setVisible(false)
										-- Logger.debug("silver not enougth window:%d,%d",cast,UserModel.getSilverNumber())
				             			-- ObjectTool.showTipWindow( "银币不足，无法复活",removeWindow)
				             			self.onPopUpState = true
				             			ObjectTool.showTipWindow( BATTLE_CONST.LABEL_3 ,removeWindow)
				             			return
				             		end
				             	else
					             	Logger.debug("dropCard" .. ":" .. "hit on self is not dead")
            					end
				             end -- if end
				        -- 如果是扔到空白位置上
				       else
				       		--print("dropCard:",size," index:",postionIndex)
							BattleTeamDisplayModule.setCardPostion(dropCard,postionIndex,ccp(postion.x,postion.y))
	             	   		BattleTouchMananger.updateTargets({dropCard})
	             	   		return 
	             	   end

	             	-- self:switchCard(card,dropCard)
	            else
	            	--print("out range")	
	         	end -- if end

			
		end -- for end
		self:setRawPostion(dropCard)
 
	end

	function BattleFormationMediator:setRawPostion( dropCard )
		if dropCard ~= nil then
			dropCard.container:setPosition(dropCard.rawPositon.x,dropCard.rawPositon.y)
			dropCard:toZOder(dropCard.data.positionIndex)
		end
	end
	 
	return BattleFormationMediator