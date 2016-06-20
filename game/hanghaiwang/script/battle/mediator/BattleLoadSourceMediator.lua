

local BattleLoadSourceMediator = class("BattleLoadSourceMediator")
 BattleLoadSourceMediator.name 			= "BattleLoadSourceMediator"

 
	------------------ properties ----------------------
	BattleLoadSourceMediator.loader 		= nil
	BattleLoadSourceMediator.analyser 		= nil
	------------------ functions -----------------------
	function BattleLoadSourceMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_LOAD_START_PRELOAD_START,
					 
				}
	end
	 
	function BattleLoadSourceMediator:getHandler()
		return self.handleNotifications
	end

	function BattleLoadSourceMediator:onRegest( ... )
		if(self.analyser == nil) then
			self.analyser = require(BATTLE_CLASS_NAME.BattleRecordSourcAnalyser).new()
		end
	end

	function BattleLoadSourceMediator:onRemove( ... )
	end
	function BattleLoadSourceMediator:handleNotifications(eventName,data)

		if eventName ~= nil then
			-- 初始化背景
			if eventName == NotificationNames.EVT_LOAD_START_PRELOAD_START then
				self.analyser:reset(data)
				-- self.analyser:printMap()
				self:loadDirectly()
				EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE)
			end
		end
	end

	function BattleLoadSourceMediator:loadDirectly( ... )

		-- local startTime =  os.clock()
	 						 
	
			originalFormat = CCTexture2D:defaultAlphaPixelFormat()
	        CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)

	     	-- print("=== start preload")
	        for k,v in pairs(self.analyser.allMap) do
	        	-- ObjectTool.getAnimation(k,)
	        	-- print("---- load",k)
	        	local animation = ObjectTool.getAnimation(k,false)
	        	if(animation) then
	        		-- print("=== preloadSource:",k)
	        		ObjectSharePool.addObject(animation,k)
	        	-- else
	        		-- print("=== preloadSource error:",k)
	        	end
	    --     	local result,imageURL,plistURL,url = ObjectTool.checkAnimation()
	    --     	if(result) then
	    --     		-- local hasAnimation,imageURL,plistURL,url = checkAnimation(animationName)
		   --           BattleNodeFactory.registArmature(url,imageURL,plistURL)
					-- -- local url = BattleURLManager.BATTLE_EFFECT .. k .. "0.pvr.ccz"
					-- -- CCTextureCache:sharedTextureCache():addImage(imageURL)
	    --     	end
				
			end

			Logger.debug("=== preloadSourceComplete")
			CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
		-- local endTime =  os.clock()
		-- print("*************** loadDirectly cost:",endTime - startTime)
		-- EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE)
		
	end
	function BattleLoadSourceMediator:loadByAysnc( ... )
		
				originalFormat = CCTexture2D:defaultAlphaPixelFormat()
             	CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
				
				self.loader = ImageAysncLoader:create()
				for k,v in pairs(self.analyser.allMap) do
					local url = BattleURLManager.BATTLE_EFFECT .. k .. "0.png"
					self.loader:push(url)
				end
				self.loader:registerCompleteCallBack(function( ... )
					Logger.debug("=== preloadSourceComplete")
					CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
					EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE)
				end)
				self.loader:start()

	end
 return BattleLoadSourceMediator

