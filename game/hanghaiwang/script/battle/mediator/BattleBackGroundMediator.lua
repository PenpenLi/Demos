

local BattleBackGroundMediator = class("BattleBackGroundMediator")
	--  游戏背景管理
		-- 功能： 加载背景图片 滚动背景 设置背景起始滚动位置
	------------------ properties ----------------------
	BattleBackGroundMediator.name 			= "BattleBackGroundMediator"
	BattleBackGroundMediator.backImg1URL	= nil	-- 第一张图片URL
	BattleBackGroundMediator.backImg2URL	= nil	-- 第二张图片URL

	BattleBackGroundMediator.backImg1		= nil	-- 第一张图片
	BattleBackGroundMediator.backImg2		= nil	-- 第二张图片


	--BattleBackGroundMediator.container          = {}	-- 容器
	BattleBackGroundMediator.baseName           = ""	-- 图片的基础名字
	BattleBackGroundMediator.moveDistence       = 0		-- 每次移动距离
	BattleBackGroundMediator.startY             = 0 	--
	BattleBackGroundMediator.IMG_PATH           = "images/battle/"				-- 图片主路径
	BattleBackGroundMediator.battleBaseLayer	= nil
	BattleBackGroundMediator.moveTime			= 2.5
	BattleBackGroundMediator.isMoving			= false
	BattleBackGroundMediator.size 				= nil

	BattleBackGroundMediator.backEffect  		= nil -- 背景特效
	------------------ functions -----------------------
	function BattleBackGroundMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_BACKGROUND_INI,
					NotificationNames.EVT_BACKGROUND_SCROLL_START,
					NotificationNames.EVT_BACKGROUND_SET_POSTION,
					NotificationNames.EVT_BACKGROUND_SCROLL_COMPLETE,
					NotificationNames.EVT_TALK_REQUEST_CHANGE_BG,
					NotificationNames.EVT_BATTLE_SHOW_BG_EFFECT, --  背景特效
					NotificationNames.EVT_REQUEST_CHANGE_BG_DIRECT, -- 直接换背景
				}
	end
	 
	function BattleBackGroundMediator:onRegest( ... )
		-- self.backImg1URL 					= {}
		-- self.backImg2URL 					= {}

		-- self.backImg1 						= {}
		-- self.backImg2 						= {}
		-- local  instance 	= require("EventBus"):instance()
		-- local  eventNames	= self.getInterests()
		-- for i,eventName in ipairs(eventNames) do
		-- 	instance.addEventListener(eventName,handleNotifications)
		-- end -- for end
		self.size 							= CCDirector:sharedDirector():getWinSize()
		self.bgRealScale 					= math.max(g_fScaleX,g_fScaleY) --self.size.height/960
		self.moveDistence					= (240 * 10- self.size.height)/3 * math.max(g_fScaleX,g_fScaleY) --* self.bgRealScale
		BattleMainData.moveDistence 		= self.moveDistence
		BattleMainData.scale 				= self.bgRealScale
 	-- 	if self.battleBaseLayer == nil then
 	-- 	 	self.battleBaseLayer 			= CCLayer:create()
		-- end
		-- local scene = CCDirector:sharedDirector():getRunningScene()
  --   	scene:addChild(self.battleBaseLayer,1000,67890)
    	--print("BattleBackGroundMediator:onRegest")
	end -- function end
	function BattleBackGroundMediator:onRemove( ... )
		self.size = nil
		Logger.debug("!!!! BattleBackGroundMediator:onRemove")
	 	--print("BattleBackGroundMediator:onRemove")

	 	-- if(self.backImg1) then
	 	-- 	self.backImg1:removeFromParentAndCleanup(true)
	 	-- 	self.backImg1 = nil
	 	-- end

	 	-- if(self.backImg2) then
	 	-- 	self.backImg2:removeFromParentAndCleanup(true)
	 	-- 	self.backImg2 = nil
	 	-- end
	 	if(self.img ~= nil) then
	 		self.img:releaseUI()
	 		self.img = nil
	 	end
	 	self:removeBackEffect()

	 -- 	self.backImg1URL 					= nil
		-- self.backImg2URL 					= nil

	end -- function end

	function BattleBackGroundMediator:getHandler()
		return self.handleNotifications
	end

	function BattleBackGroundMediator:showBackEffect( animationName )
		self:removeBackEffect()

		self.backEffect = require(BATTLE_CLASS_NAME.BattleAnimation).new()
		self.backEffect:createAnimation(animationName,true)
		BattleLayerManager.battleAnimationLayer:addChild(self.backEffect)

	end

	function BattleBackGroundMediator:removeBackEffect( ... )
		if(self.backEffect) then
			self.backEffect:releaseAnimation()
			self.backEffect = nil
		end
	end

	function BattleBackGroundMediator:startChangeBackGround( imgName  )
		--print("开始换背景:",imgName)
		-- local action1 = CCLayerSprite:layerSpriteWithName(CCString:create("images/guide/effect/zhuangchang/zhuangchang"),-1,CCString:create(""))
  --       action1:setScale(MainScene.elementScale)
  --       action1:setPosition(ccp(g_winSize.width * 0.5 - 640*MainScene.elementScale*0.5, g_winSize.height * 0.5 + 960*MainScene.elementScale*0.5))
        

		--  local function animationEnd(actionName,xmlSprite)
		 				--print("换背景特效播放完毕:",imgName)
                        -- logger:debug("enter checkDialogChanges 6")
                        -- action1:removeFromParentAndCleanup(true)
                        -- action1 = nil
                        
                        self:changeBackGround(imgName)
                        EventBus.sendNotification(NotificationNames.EVT_TALK_REQUEST_CHANGE_BG_END)
                    
        --             end

        -- local function animationFrameChanged()
        -- end

		
        -- local delegate = BTAnimationEventDelegate:create()
        -- delegate:registerLayerEndedHandler(animationEnd)
        -- delegate:registerLayerChangedHandler(animationFrameChanged)
        -- action1:setDelegate(delegate)       

 

        -- BattleLayerManager.battleAnimationLayer:addChild(action1)

	end

	-- 获取背景的URL
	function BattleBackGroundMediator:getBattleBackGroudURL( name , imgFix)
		
		if imgFix == nil then
			imgFix = "_0"
		end
		local result = BattleURLManager.BATTLE_IMG_BG_PATH .. string.sub(name,1,string.len(name)-4) .. imgFix .. string.sub(name,string.len(name)-3,string.len(name))

		  if(file_exists(result) == false) then
          	result = BattleURLManager.BATTLE_IMG_BG_PATH .. string.sub(name,1,string.len(name)-4) .. "_0.webp"
          end -- if end
          --print("get image:",result)
        return CCSprite:create(result)
	end
	
	function BattleBackGroundMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		--print("backGroudMediator handleNotifications call:",eventName,"data:",data)
		if eventName ~= nil then
			-- 初始化背景
			if eventName == NotificationNames.EVT_BACKGROUND_INI then
				----print("backGroudMediator init:",eventName)
				if data ~= nil then
					self:initBackGroundImages(data)
					if(BattleMainData.backGroundStartIndex == nil or BattleMainData.backGroundStartIndex > 3) then
					elseif(BattleMainData.strongholdId and tonumber(BattleMainData.strongholdId) > 0) then
 						BattleMainData.backGroundStartIndex = db_stronghold_util.getFightStartIndex(BattleMainData.strongholdId)
 					else
 						BattleMainData.backGroundStartIndex = 1
 					end
					-- print("backGroudMediator init index:",BattleMainData.backGroundStartIndex)
					self:refreshStartY(BattleMainData.backGroundStartIndex)
					BattleMainData.backgroundInstance = self.img
				end
			-- 滚动背景 放到出场方式里
			-- elseif eventName == NotificationNames.EVT_BACKGROUND_SCROLL_START then
			-- 	--print("backGroudMediator scroll to nextPostion")
			--  	self:startMoveImage()
				
			-- 设置背景位置
			elseif eventName == NotificationNames.EVT_BACKGROUND_SET_POSTION then
				Logger.debug("backGroudMediator set start postion:" .. tostring(data))
				self:refreshStartY(data)
			-- 特效换背景
			elseif eventName == NotificationNames.EVT_TALK_REQUEST_CHANGE_BG then
				self:startChangeBackGround(data)
			--直接换背景
			elseif eventName == NotificationNames.EVT_REQUEST_CHANGE_BG_DIRECT then
				self:changeBackGround(data)

			elseif eventName == NotificationNames.EVT_BATTLE_SHOW_BG_EFFECT then
				self:showBackEffect(data)
			end -- if end 
		end-- if end
	end -- function end
	-- 切换背景
	function BattleBackGroundMediator:changeBackGround( imageName )
		-- 删除背景
		-- if(self.backImg1) then
	 -- 		self.backImg1:removeFromParentAndCleanup(true)
	 -- 		self.backImg1 = nil
	 -- 	end

	 -- 	if(self.backImg2) then
	 -- 		self.backImg2:removeFromParentAndCleanup(true)
	 -- 		self.backImg2 = nil
	 -- 	end
	 	self:initBackGroundImages(imageName)
	  	 
	  	if(self.startY ~= 0) then
	 		self.img:scrollPyTo(-self.startY)
	 	end
        
	end
	--初始化背景图
	function BattleBackGroundMediator:initBackGroundImages( data )
	 

		self.baseName = data
		if(self.img) then
			self.img:releaseUI()
			self.img = nil
		end
		self.img = require("script/battle/ui/CarmackScrollImage.lua").new()
		BattleLayerManager.battleBackGroundLayer:addChild(self.img)
		self.img:create(self.baseName)
		BattleMainData.backgroundInstance = self.img
		-- -- 保存原来的格式
		-- local originalFormat = CCTexture2D:defaultAlphaPixelFormat()
		-- CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGB565)
			

		-- --print("BattleBackGroundMediator:handleNotifications data:",data)

		-- --如果第一张图片存在
		-- --print("----------------self:getBattleBackGroudURL ->",type(self.getBattleBackGroudURL))
		-- self.backImg1 = self:getBattleBackGroudURL(self.baseName,"_0")
		-- ----print("get image:",self.backImg1URL)

		
		-- --如果第二张图片存在
		-- self.backImg2 = self:getBattleBackGroudURL(self.baseName,"_1")
		-- ----print("get image:",self.backImg2URL)

		-- -- backImg1 = CCSprite:create(self.backImg1URL)
		-- -- backImg2 = CCSprite:create(self.backImg2URL)

		-- self.backImg1:setAnchorPoint(CCP_ZERO)
		-- self.backImg1:setPosition(ccp(0, -self.startY))
		-- -- --print("BattleBackGroundMediator:initBackGroundImages scale:",self.size.width/self.backImg1:getContentSize().width)
		-- self.backImg1:setScale(self.bgRealScale)
		-- self.backImg2:setScale(self.bgRealScale)

		
		-- BattleMainData.bgWidth	= 640 * self.bgRealScale

  --       -- BattleGridPostion.initGrid(BattleMainData.bgWidth,BattleMainData.scale)

		-- -- --print("BattleBackGroundMediator:initBackGroundImages bgWidth:",BattleMainData.bgWidth," ",BattleMainData.scale)
		
		-- self.backImg2:setPosition(0,self.backImg1:getContentSize().height * self.bgRealScale)
  --       self.backImg2:setAnchorPoint(ccp(0, 0))

  --       -- self.backImg1:addChild(self.backImg2,-1,2121)

  --       BattleLayerManager.battleBackGroundLayer:addChild(self.backImg1,0,67890)
  --       BattleLayerManager.battleBackGroundLayer:addChild(self.backImg2,0,67891)

		-- CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)			 

	end
 
	-- -- 图片移动完毕回调
	-- function BattleBackGroundMediator:onImageMoveComplete( ... )
	-- 	-- local ins = getmetatable()
	-- 	
	-- 	--print("*******************BattleBackGroundMediator:onImageMoveComplete")
	-- 	self.isMoving = false
	-- 	EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_SCROLL_COMPLETE)

	-- end

	function BattleBackGroundMediator:refreshStartY( data )
		
		Logger.debug("BattleBackGroundMediator:refreshStartY:" .. tostring(data))
		if(data == nil or data == 0) then data = 1 end 
		self.startPosition = data-1
		self.startY = self.moveDistence*self.startPosition
		Logger.debug("BattleBackGroundMediator:startY:" .. tostring(self.startY))
		-- self.backImg1:setPosition(ccp(0, -self.startY))
		self.img:scrollPyTo(-self.startY)

	end

return BattleBackGroundMediator