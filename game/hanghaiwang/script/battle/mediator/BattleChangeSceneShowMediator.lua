


-- 游戏阵型
local BattleChangeSceneShowMediator = class("BattleChangeSceneShowMediator")


------------------ properties ----------------------

BattleChangeSceneShowMediator.name = "BattleChangeSceneShowMediator"

------------------ functions -----------------------
	function BattleChangeSceneShowMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_CHANGE_SCENE_START,
					NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_START,
					NotificationNames.EVT_SINGLE_BATTLE_TOPSHOW_CHANGE_SCENE_START,
					NotificationNames.EVT_CHANGE_SCENE_RESUME,
					NotificationNames.EVT_SINGLE_CHANGE_SCENE_RESUME
					-- NotificationNames.EVT_CHANGE_SCENE_READY,
					-- NotificationNames.EVT_CHANGE_SCENE_COMPLETE
				}
	end
	 
	function BattleChangeSceneShowMediator:onRegest( ... )
 
	end -- function end
	function BattleChangeSceneShowMediator:onRemove( ... )
 

	end -- function end

	function BattleChangeSceneShowMediator:getHandler()
		return self.handleNotifications
	end
	function BattleChangeSceneShowMediator:handleNotifications(eventName,data)
		 Logger.debug("== handleNotifications " .. tostring(eventName) .. " evt:" .. tostring(NotificationNames.EVT_CHANGE_SCENE_START))
		-- 开始转场特效
		if eventName == NotificationNames.EVT_CHANGE_SCENE_START then
			-- Logger.debug("== EVT_CHANGE_SCENE_START")
			-- 如果需要转场特效
			if(BattleMainData.useSceneChangeEffect) then

				-- print("=== mask start")
				self.action 				= require(BATTLE_CLASS_NAME.BAForChangeSceneMoveInEffect).new()

				-- 当遮罩覆盖的时候我们开始显示背景
				local onMasking = function ( ... )
					  -- 创建战斗场景层
			          BattleLayerManager.createLayers()
					  -- 初始化背景
	                  EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())
	                  -- 停住动画
	                  self.action:stop()
	                  -- 发送事件
	                  EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_PAUSE)
	                  -- print("=== mask isPaused")

				end
 
				
				
				self.action.onMasking 		= onMasking
				self.action:addCallBacker(self,self.onMaskAnimationComplete)
				self.action.container 		= CCDirector:sharedDirector():getRunningScene()
				self.action.zOder 			= 99999


				-- self.action:renderScreen()
				

				self.action:start()
			else
				-- 创建战斗场景层
	            BattleLayerManager.createLayers()
				EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())
				BattleDataProxy.requestEnterLevel()
			end
		elseif eventName == NotificationNames.EVT_SINGLE_CHANGE_SCENE_RESUME then
				if(self.action and self.action.resume and self.action.isPaused and self.action:isPaused() == true) then
			 		self.action:resume()
			 		-- print("=== mask direct resume")
			 	else
			 		-- print("=== mask direct stop")
			 		self:onSingleBattleMaskAnimationComplete()
			 	end

		elseif eventName == NotificationNames.EVT_CHANGE_SCENE_RESUME then
			-- print("=== mask direct",self.action , self.action:isPaused())
			 	if(self.action and self.action.resume and self.action.isPaused and self.action:isPaused() == true) then
			 		self.action:resume()
			 		-- print("=== mask direct resume")
			 	else
			 		-- print("=== mask direct stop")
			 		self:onMaskAnimationComplete()
			 	end


		elseif eventName == NotificationNames.EVT_SINGLE_BATTLE_TOPSHOW_CHANGE_SCENE_START then
			-- Logger.debug("==== 1")
			self.action 				= require(BATTLE_CLASS_NAME.BAForChangeSceneMoveInEffect).new()
			-- if(BattleMainData.useSceneChangeEffect) then
				local onMasking = function ( ... )
					 	-- 创建战斗场景层
					 self.action:resume()
					 ObjectTool.removeObject(mouseLayer)
	            	 BattleLayerManager.createLayers()
					 self:showTopShow()
				end
				
				self.action.onMasking 		= onMasking
				self.action:addCallBacker(self,self.onSingleBattleMaskAnimationComplete)
				self.action.container 		= CCDirector:sharedDirector():getRunningScene()
				self.action.zOder 			= 99999
 

				self.action:start()
 
			-- else
			-- 	-- 创建战斗场景层
	  --       	BattleLayerManager.createLayers()

			-- 	self:showTopShow()
			-- 	self:onSingleBattleMaskAnimationComplete()
			-- end

		elseif eventName == NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_START then

			-- Logger.debug("==== EVT_SINGLE_BATTLE_CHANGE_SCENE_START")
			-- if(BattleMainData.useSceneChangeEffect) then
				-- Logger.debug("==== EVT_SINGLE_BATTLE_CHANGE_SCENE_START1")
				-- Logger.debug("==== 2")
				-- local mouseLayer = CCLayer:create()
					-- 当遮罩覆盖的时候我们开始显示背景
				Logger.debug("==== EVT_SINGLE_BATTLE_CHANGE_SCENE_START")
				self.action 				= require(BATTLE_CLASS_NAME.BAForChangeSceneMoveInEffect).new()
				local onMasking = function ( ... )
						Logger.debug("==== EVT_SINGLE_BATTLE_CHANGE_SCENE_START1")
					 	-- 创建战斗场景层
					 	-- Logger.debug("==== EVT_SINGLE_BATTLE_CHANGE_SCENE_START3")
					 -- ObjectTool.removeObject(mouseLayer)
	            	 BattleLayerManager.createLayers()
	            	 if(self.action) then
	            	 	-- self.action:resume()
	            	 	 -- 停住动画
	                  self.action:stop()
	                  -- 发送事件
	                  EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_PAUSE)

	            	 end
					 self:showSingleBattle()
				end
 
				
				
				self.action.onMasking 		= onMasking
				self.action:addCallBacker(self,self.onSingleBattleMaskAnimationComplete)
				self.action.container 		= CCDirector:sharedDirector():getRunningScene()
				self.action.zOder 			= 99999


				-- self.action:renderScreen()
				

				self.action:start()


				-- local onMouseEvent = function (eventType, x,y)
				-- 	-- Logger.debug("=== onMouseEvent:".. eventType .. " " .. tostring(x) .. " " .. tostring(y))
				-- 	return true	
				
				-- end 

 
				-- mouseLayer:setTouchEnabled(true);

				-- mouseLayer:setTouchPriority(-129);

				-- mouseLayer:setTouchMode(kCCTouchesOneByOne);

				-- -- mouseLayer:registerWithTouchDispatcher();

				-- -- mouseLayer:setTouchEnabled(true)
				-- mouseLayer:registerScriptTouchHandler(onMouseEvent,false,-129,true)
				-- -- mouseLayer:setTouchPriority(g_tbTouchPriority.battleLayer + 9999)
				-- CCDirector:sharedDirector():getRunningScene():addChild(mouseLayer,9999)
			-- else
			-- 	-- 创建战斗场景层
	  --       	BattleLayerManager.createLayers()

			-- 	self:showSingleBattle()
			-- 	self:onSingleBattleMaskAnimationComplete()
			-- end
		end
		 
	end

	function BattleChangeSceneShowMediator:showTopShow( ... )
		-- 初始化背景
			EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())
			EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_SET_POSTION,BattleMainData.topShowBackGroundStartIndex)
			
			--刷新ui数据
			BattleMainData.refreshBattleTeamDisplayData()
 			
            --初始化ui
          EventBus.sendNotification(NotificationNames.EVT_UI_INI)

          
          -- 播放背景音乐
          BattleMainData.playBackGroundMusic()

          -- 开启显示名字
          EventBus.sendNotification(NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME)

	end

	function BattleChangeSceneShowMediator:showSingleBattle( ... )
			-- Logger.debug("==== 4",BattleMainData.getBackGroudName())
          
			-- 初始化背景
			EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())
			
			--刷新ui数据
			BattleMainData.refreshBattleTeamDisplayData()
 

          -- 创建队伍人员显示
          	BattleTeamDisplayModule.createHeroDisplayToMainData()

      	  -- 链接战斗数据的display
          BattleMainData.linkAndRefreshHeroesDisplay()


            --初始化ui
          EventBus.sendNotification(NotificationNames.EVT_UI_INI)

          
          -- 播放背景音乐
          BattleMainData.playBackGroundMusic()

          -- 开启显示名字
          EventBus.sendNotification(NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME)
          
	end

	function BattleChangeSceneShowMediator:onSingleBattleMaskAnimationComplete( ... )
		Logger.debug("== onMaskAnimationComplete1")

		-- 请求进入
        EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_COMPLETE)
	end


	function BattleChangeSceneShowMediator:onMaskAnimationComplete( ... )
		Logger.debug("== onMaskAnimationComplete")
		-- 请求进入
        -- BattleDataProxy.requestEnterLevel()
        BattleTeamDisplayModule.visibleAll()


  --       local scene = CCDirector:sharedDirector():getRunningScene()
  --       local node = ObjectTool.getAnimation("meffect_cx",true)
		-- -- local node = UIHelper.createArmatureNode({
		-- -- 	filePath = "images/battle/skillEffect/meffect_cx.ExportJson",
		-- -- 	animationName = "meffect_cx",
		-- -- 	loop = 1,
		-- -- })
		-- -- local  myNode = CCNode:create()
		-- local popLayer = OneTouchGroup:create() 
		-- local  myNode = Layout:create()
		-- popLayer:addWidget(myNode)
		-- local myNode1 = CCLayer:create()
		-- myNode:addNode(myNode1)

		-- scene:addChild(popLayer,99999999)
		-- myNode1:addChild(node)
		-- node:setPosition(ccp(200,600))



		--  local node1 = ObjectTool.getAnimation("meffect_cx",true)
		-- node1:setPosition(ccp(500,600))

		-- -- BattleLayerManager.addNode("meffect_cx",node1)
		-- BattleLayerManager.battleAnimationLayer:addChild(node1)

        -- EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_START)
        EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_COMPLETE)

	end


return BattleChangeSceneShowMediator