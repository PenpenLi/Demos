
-- 战斗内信息ui
local BattleInfoUIMediator = class("BattleInfoUIMediator")
 BattleInfoUIMediator.name 			= "BattleInfoUIMediator"
 
	------------------ properties ----------------------
	-- 跳过战斗
	BattleInfoUIMediator.skipBattle 					= nil
	BattleInfoUIMediator.speedUp						= nil
	BattleInfoUIMediator.autoFight 						= nil -- 托管

	BattleInfoUIMediator.infoView						= nil
	BattleInfoUIMediator.upItemAnimation				= nil -- 物品更新动画
	------------------ functions -----------------------
	function BattleInfoUIMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					-- NotificationNames.EVT_REFRESH_SH_RESULT,  		-- 初始化
					NotificationNames.EVT_UI_INI,			 		-- 初始

					NotificationNames.EVT_UI_SHOW_SPEED_BT,	  		-- 加速
					NotificationNames.EVT_UI_SHOW_SKIP_BT,	  		-- 显示调过按钮
					NotificationNames.EVT_UI_SHOW_AUTO_FIGHT,		-- 显示托管按钮

					NotificationNames.EVT_UI_REFRESH_ROUND,	 		-- 更新回合数据
					-- NotificationNames.EVT_UI_REFRESH_MONEY,	  		-- 更新钱
					-- NotificationNames.EVT_UI_REFRESH_SOUL,	  		-- 更新魂玉
					-- NotificationNames.EVT_UI_REFRESH_RESOURCE,	  	-- 更新资源
					NotificationNames.EVT_UI_REMOVE_SKIP_BT	,		-- 删除调过战斗按钮
					NotificationNames.EVT_UI_REMOVE_SPEED_BT,		-- 删除加速按钮
					NotificationNames.EVT_UI_REFRESH_CHEST_DATA,	-- 箱子数据刷新(累加,有动画)
					-- NotificationNames.EVT_UI_SET_HERO_PART_TO,		-- 设置当前英雄碎片数量(直接设定,无动画)
					NotificationNames.EVT_UI_SET_ITEM_TO			-- 设置当前获得物品数量(直接设定,无动画)
				}
	end -- function end

	function BattleInfoUIMediator:onRegest( ... )

	end -- function end

	function BattleInfoUIMediator:onRemove( ... )
		Logger.debug("!!!! BattleInfoUIMediator:onRemove")
		-- local  instance 	= require("EventBus"):instance()
		-- local  eventNames	= self.getInterests()
		-- for i,eventName in ipairs(eventNames) do
		-- 	instance.removeEventListener(eventName,handleNotifications)
		-- end -- for end
	   if(self.skipBattle) then
	   		self.skipBattle:unregisterScriptTapHandler()
	   end
	   if(self.autoFight and self.autoFight.button) then
	   		self.autoFight.button:unregisterScriptTapHandler()
	   end

	   if(self.speedUp) then
	   		self.speedUp:unregisterScriptTapHandler()
	   end
		self.skipBattle = nil
		self.speedUp = nil
		self.autoFight = nil
		self.infoView = nil


	end -- function end

	function BattleInfoUIMediator:getHandler()
		return self.handleNotifications
	end


	function BattleInfoUIMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		--print("StrongHoldMediator handleNotifications call:",eventName,"data:",data)

		if eventName ~= nil then
			
			-- 显示加速按钮
			if 	   eventName == NotificationNames.EVT_UI_SHOW_SPEED_BT then
					assert(self.menu,"BattleInfoUIMediator menu== nil")
					self:getSpeedButton(BattleMainData.getTimeSpeed())
			-- 回合
			elseif eventName == NotificationNames.EVT_UI_REFRESH_ROUND then
				    if(self.infoView) then
				    	self.infoView:refreshRoundInfo(data)
				    end
	 
			-- -- 直接设置英雄碎片
			-- elseif eventName == NotificationNames.EVT_UI_SET_HERO_PART_TO then
			-- 		if(self.infoView) then
			-- 	    	self.infoView:setHeroPartNum(data)
			-- 	    end 
			-- 直接设置获得物品
			elseif eventName == NotificationNames.EVT_UI_SET_ITEM_TO then
						Logger.debug("==EVT_UI_SET_ITEM_TO:" .. tostring(data))
						if(self.infoView) then
					    	self.infoView:setItemNum(data)
					    end 
				    
			-- 刷新箱子数据
			elseif eventName == NotificationNames.EVT_UI_REFRESH_CHEST_DATA then
				 	local chestData = data
				 	local targetUI = nil
				 	Logger.debug("=== chest handle event",chestData.num)
				 	-- 如果是物品
				 	-- if(chestData:isItem() == true) then
				 		if(self.infoView) then
					 		-- print("=== chest handle event add num:%d",chestData.num)
					    	-- self.infoView:addItemNum(chestData.num)
					    	Logger.debug("== addItemNum:" .. tostring(chestData.num))
					    	self.infoView:addItemNum(1)
					    	targetUI = self.infoView.itemNum
					    	if(self.upItemAnimation ~= nil) then
					    		ObjectTool.removeObject(self.upItemAnimation)
					    	end
					    	self.upItemAnimation = ObjectTool.getAnimation(BATTLE_CONST.BATTLE_DROP_ITEM_INCOME)


						    	-- 第二个动画完成回调
				  			local fnMovementCall = function ( sender, MovementEventType )
					  			-- 删除第二个动画
						  			if (MovementEventType == EVT_COMPLETE) then 
											ObjectTool.removeObject(self.upItemAnimation)
											self.upItemAnimation = nil
									end

					  		end -- f end
					  		self.upItemAnimation:getAnimation():setMovementEventCallFunc(fnMovementCall)

							self.upItemAnimation:getAnimation():playWithIndex(0,-1,-1,0)
							-- BattleLayerManager.addNode(BATTLE_CONST.BATTLE_DROP_ITEM_INCOME,self.upItemAnimation)
							BattleLayerManager.battleUILayer:addChild(self.upItemAnimation)
							self.upItemAnimation:setPosition(chestData:getToPosition())
				    	end
				 	-- -- 如果是英雄碎片
				 	-- elseif(chestData:isHeroPart() == true) then
				 	
				 	-- 	if(self.infoView) then
					 -- 		-- print("=== chest handle event add num:%d",chestData.num)
					 --    	self.infoView:addHeroPartNum(chestData.num)
					 --    	targetUI = self.infoView.heroPartNum
				  --   	end
				 	-- end

				 	-- if(self.infoView) then
				 	-- 	-- print("=== chest handle event add num:%d",chestData.num)
				  --   	-- self.infoView:addResourceInfo(chestData.num)
				  --   	local actionArray = CCArray:create()
				  --   	targetUI:setScale(1)
				  --   	actionArray:addObject(CCScaleTo:create(0.1,1.5))
			   --          actionArray:addObject(CCScaleTo:create(0.05,1))
			   --          -- actionsArray:addObject(CCDelayTime:create(0.3)) -- 1
			   --          -- actionsArray:addObject(CCScaleTo:create(0.08,0.01))--0.08
				  --   	targetUI:runAction(CCSequence:create(actionArray))
				  --   end


		    -- elseif eventName == NotificationNames.EVT_UI_REFRESH_SOUL then
				  --   if(self.infoView) then
				  --   	self.infoView:addItemNum(data)
				  --   end 
		    -- elseif eventName == NotificationNames.EVT_UI_REFRESH_RESOURCE then
				  --   if(self.infoView) then
				  --   	self.infoView:addHeroPartNum(data)
				  --   end 
 
			-- 显示自动战斗
			elseif eventName == NotificationNames.EVT_UI_SHOW_AUTO_FIGHT then
					self:generateAutoFight()				     
			-- 显示跳过战斗
			elseif eventName == NotificationNames.EVT_UI_SHOW_SKIP_BT then
					assert(self.menu,"BattleInfoUIMediator menu== nil")
					--print("EVT_UI_SHOW_SKIP_BT")
					-- 初始化调过战斗按钮
					if(self.skipBattle) then
						self.skipBattle:removeFromParentAndCleanup(true)
						self.skipBattle = nil
					end

					if(BattleMainData.showSkipBattleButton == true) then
						local IMG_PATH = "images/battle/"
						-- self.skipBattle 		= CCMenuItemImage:create(IMG_PATH .. "icon/icon_skip_n.png",IMG_PATH .. "icon/icon_skip_h.png")
						
						BattleNodeFactory.regeistTextureURL(IMG_PATH .. "icon/icon_skip_n.png")
						BattleNodeFactory.regeistTextureURL(IMG_PATH .. "icon/icon_skip_h.png")

						local size 				= CCDirector:sharedDirector():getWinSize()
						assert(size)
						local skipClick = function ( ... )
							-- 2016.1.8 增加按钮点击声音
							AudioHelper.playCommonEffect() 
							if(BattleMainData.canJumpBattle == true) then
								EventBus.sendNotification(NotificationNames.EVT_BATTLE_SKIP_RECORD)
							else
								ShowNotice.showShellInfo(BattleMainData.jumpRefuseTip)
							end		  							 
						end

						self.skipBattle = CCMenuItemImage:create(IMG_PATH .. "icon/icon_skip_n.png",IMG_PATH .. "icon/icon_skip_h.png")
						self.skipBattle:registerScriptTapHandler(skipClick)
						self.skipBattle:setAnchorPoint(ccp(1,0))
						
						-- 如果是精英副本,调过战斗按钮需要偏移
						-- if(BattleMainData.isEliteCopy) then
							 
						-- 	self.skipBattle:setPosition(size.width*1,70)
							 
						-- else

						self.skipBattle:setPosition(size.width*1,0)
						-- end
						self.menu:addChild(self.skipBattle)
					end
			-- 删除跳过战斗按钮
			elseif eventName == NotificationNames.EVT_UI_REMOVE_SKIP_BT then
					if(self.skipBattle) then
						self.skipBattle:removeFromParentAndCleanup(true)
						self.skipBattle = nil
					end
			-- 删除加速按钮
			elseif eventName == NotificationNames.EVT_UI_REMOVE_SPEED_BT then
					if(self.speedUp) then
						self.speedUp:removeFromParentAndCleanup(true)
						self.speedUp = nil
					end
					
			
			elseif eventName == NotificationNames.EVT_UI_INI then
				-- 按钮群
				if(self.menu == nil) then
					self.menu = CCMenu:create()
				    self.menu:setAnchorPoint(CCP_ZERO)
				    self.menu:setPosition(0,0)
				    BattleLayerManager.battleUILayer:addChild(self.menu,0,1299)
			   		self.menu:setTouchPriority(g_tbTouchPriority.battleMenu)
				end

				if(self.infoView == nil) then
				    self.infoView	= require(BATTLE_CLASS_NAME.BattleInfoUI).new()
				    self.infoView:create()
				else
					self.infoView:reset()
				end
				

			-- elseif eventName == NotificationNames.EVT_REFRESH_SH_RESULT then
			end
		end
	end -- function end
	function BattleInfoUIMediator:generateAutoFight()

		local isAutoFight = BattleMainData.isAutoFightNow()

		self:removeAutoFight()

		local up,down = nil

		-- 如果是自动战斗那么我们现实取消
		if(isAutoFight == true) then
			up = BATTLE_CONST.CANCLE_AUTO_FIGHT_UP
			down = BATTLE_CONST.CANCLE_AUTO_FIGHT_DOWN
		else
			up = BATTLE_CONST.AUTO_FIGHT_UP
			down = BATTLE_CONST.AUTO_FIGHT_DOWN
		end
	   self.autoFight = CCMenuItemImage:create(up,down)
	   -- self.autoFight:registerScriptTapHandler(autoFightClick)
	   self.autoFight:setAnchorPoint(CCP_ZERO)
	   self.menu:addChild(self.autoFight)

	   BattleNodeFactory.regeistTextureURL(BATTLE_CONST.AUTO_FIGHT_UP)
	   BattleNodeFactory.regeistTextureURL(BATTLE_CONST.AUTO_FIGHT_DOWN)

	   -- self.autoFight:create(BATTLE_CONST.AUTO_FIGHT_UP,BATTLE_CONST.AUTO_FIGHT_UP,self.menu,"")
	   -- print("===== button width ",self.autoFight.button:getContentSize().width/2)
	 
	   -- self.autoFight:setAnchorPoint(CCP_ZERO)
	   if(self.speedUp) then
	   		self.autoFight:setPosition(self.speedUp:getContentSize().width * 1.1 ,0)
	   else
	   		 self.autoFight:setPosition(300,0)
	   end
	  


	   local autoFightClick = function ( ... )
	   											-- 2016.1.8 增加按钮点击声音
												AudioHelper.playCommonEffect() 
											    if(self.autoFight) then
											    	BattleMainData:autoFightNextState()
											  		self:generateAutoFight()
											    	--print("-------autoFightClick")
											    end
											    -- self.autoFight:setString(BattleMainData.getAutoFightText())
												EventBus.sendNotification(NotificationNames.EVT_BATTLE_AUTO_FIGHT)		  							 
								end -- function end

	   self.autoFight:registerScriptTapHandler(autoFightClick)


	end

	function BattleInfoUIMediator:removeAutoFight( ... )
		if(self.autoFight) then
			self.autoFight:unregisterScriptTapHandler()
		end
		ObjectTool.removeObject(self.autoFight)
		self.autoFight = nil
	end
	function BattleInfoUIMediator:getSpeedButton( speed )
		if(self.speedUp) then
			self.speedUp:removeFromParentAndCleanup(true)
			self.speedUp = nil
		end

		local IMG_PATH = "images/battle/"
		local upSkinName 
		local downSkinName
		local timeScale = 1
		if(speed == 1) then

			upSkinName =  IMG_PATH .. "btn/btn_speed1_n.png"
			downSkinName = IMG_PATH .. "btn/btn_speed1_d.png"
			timeScale = BATTLE_CONST.SPEED_1
		elseif(speed == 2 ) then
			upSkinName =  IMG_PATH .. "btn/btn_speed2_n.png"
			downSkinName = IMG_PATH .. "btn/btn_speed2_d.png"
			timeScale = BATTLE_CONST.SPEED_2

		else
			upSkinName =  IMG_PATH .. "btn/btn_speed3_n.png"
			downSkinName = IMG_PATH .. "btn/btn_speed3_d.png"
			timeScale = BATTLE_CONST.SPEED_3
		end
		local speedUpClick  = function ( ... )
			self:speedUpClick()
		end
		self.speedUp = CCMenuItemImage:create(upSkinName,downSkinName)

		BattleNodeFactory.regeistTextureURL(upSkinName)
		BattleNodeFactory.regeistTextureURL(downSkinName)
					
	    self.speedUp:setAnchorPoint(CCP_ZERO)
	    self.speedUp:setPosition(0,0)
	    self.menu:addChild(self.speedUp)
	    self.speedUp:registerScriptTapHandler(speedUpClick)
	    self.speedUp:setScale(MainScene.elementScale)

	     -- CCDirector:sharedDirector():getScheduler():setTimeScale(speed)
	     CCDirector:sharedDirector():getScheduler():setTimeScale(timeScale)

 
	end

	 
	function BattleInfoUIMediator:speedUpClick()
		-- 打点记录  用户操作 2016-01-05，zhangqi, 从封测分支合并来
		UserModel.recordUsrOperationByCondition("BattleSpeedUpButtonClick", 1)

		-- 2016.1.8 增加按钮点击声音
		AudioHelper.playCommonEffect() 

		local maxSpeed = db_vip_util.speedUpMax()
 		local nextSpeed = 1

 		if(BattleMainData.canSpeepUpNext() == false) then
			BattleMainData.resetTimeSpeed()
	    	nextSpeed = 1
	    	local tipContent = ""
	    	if(maxSpeed == 1) then
	    		tipContent = BATTLE_CONST.LABEL_5
	    	else
	    		tipContent = BATTLE_CONST.LABEL_6
	    		self:getSpeedButton(nextSpeed)
	    	end

	    	 
        	ShowNotice.showShellInfo(tipContent)
	    	CCDirector:sharedDirector():getScheduler():setTimeScale(1)
		else
	    	nextSpeed = BattleMainData.nextTimeSpeed()
	    	if(nextSpeed == 1) then
	    		CCDirector:sharedDirector():getScheduler():setTimeScale(BATTLE_CONST.SPEED_1)
	    	elseif(nextSpeed == 2) then
	    		CCDirector:sharedDirector():getScheduler():setTimeScale(BATTLE_CONST.SPEED_2)
	    	else
	    		CCDirector:sharedDirector():getScheduler():setTimeScale(BATTLE_CONST.SPEED_3)
	    	end
	    	self:getSpeedButton(nextSpeed)
	    end

	    BattleMainData.cacheBattleSpeedUp()
	   
	   
	end

return BattleInfoUIMediator