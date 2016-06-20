
require (BATTLE_CLASS_NAME.class)
-- 转场特效之  入场特效
-- 1.renderScreen
-- 2.播放heimu特效
local BAForChangeSceneMoveInEffect = class("BAForChangeSceneMoveInEffect",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
 		BAForChangeSceneMoveInEffect.screen   			= nil		-- screen截图
 		BAForChangeSceneMoveInEffect.deep 				= 10002	
 		BAForChangeSceneMoveInEffect.rendered 			= nil 		-- 是否应经draw过screen
 		BAForChangeSceneMoveInEffect.moveInEffectName 	= "heimu"	-- 黑幕动画名称
 		BAForChangeSceneMoveInEffect.maskAnimation		= nil 		-- 遮罩动画
 		BAForChangeSceneMoveInEffect.onMasking 			= nil 		-- 黑幕罩住全屏后的回调
 		BAForChangeSceneMoveInEffect.mouseMasking		= nil 		-- 屏蔽层

 		-- BAForChangeSceneMoveInEffect.onMaskComplete 	= nil
	------------------ functions -----------------------
		function BAForChangeSceneMoveInEffect:start( ... )
			-- if(self.rendered ~= true) then
			-- 	self:renderScreen()
			-- end
			-- self.isPaused = false
 			BattleLayerManager.createScreenMasker()

			-- if(self.screen:getParent() == nil) then
			-- 	local scene = CCDirector:sharedDirector():getRunningScene()
			-- 	scene:addChild(self.screen,self.deep)
			-- end
				
			-- 初始化
			self.maskAnimation 				= require(BATTLE_CLASS_NAME.BAForPlayAnimationByFrame).new()
			self.maskAnimation.animationName 	= self.moveInEffectName
			self.maskAnimation.container 		= CCDirector:sharedDirector():getRunningScene()
			self.maskAnimation.zOder 			= 99999


				--入场动画完成

				local fnComplete = function ( sender, MovementEventType )
								if(self.mouseMasking ~= nil) then
						  		 	self.mouseMasking:unregisterScriptTouchHandler()
						  		 	ObjectTool.removeObject(self.mouseMasking)
						  		 	self.mouseMasking = nil
						  		end

			 					self:complete()
			 					self:release()
								CCTextureCache:sharedTextureCache():removeUnusedTextures()
		  		end -- f end

		  		-- 入场动画到黑幕 我们释放屏幕截图,调用回调
		  		local fnKeyFrame = function ( ... )
		  			Logger.debug("xxx fnKeyFrame")
		  			self:stop()
		  			self.onMasking()
		  			BattleLayerManager.removeMasker()
		  		 	self:releaseScreenShoot()
		  		end
			assert(self.onMasking,"BAForChangeSceneMoveInEffect.onMaskIn is nil")
			
			self.maskAnimation.evtFrameCallBack = fnKeyFrame
			self.maskAnimation.completeCallBack = fnComplete
		 	self.maskAnimation:start()

 

		end

		function BAForChangeSceneMoveInEffect:stop( ... )
			
			-- if(ObjectTool.isOnStage(self.maskAnimation)) then
			if( self.maskAnimation) then
		  		self.maskAnimation:stop()
		  	end

		end


		function BAForChangeSceneMoveInEffect:resume( ... )
			-- if(ObjectTool.isOnStage(self.maskAnimation)) then
			if(self.maskAnimation) then
		  		self.maskAnimation:resume()
		  	end
		end

		function BAForChangeSceneMoveInEffect:isPaused( ... )
			
			-- if(ObjectTool.isOnStage(self.maskAnimation)) then
			if(self.maskAnimation) then
				return self.maskAnimation:isPaused()
			end
			return false

		end

 		function BAForChangeSceneMoveInEffect:renderScreen( ... )
 			self.rendered = true
	 		local scene = CCDirector:sharedDirector():getRunningScene()
	 		local gWinSize = CCDirector:sharedDirector():getWinSize()
	 		self.screen = CCRenderTexture:create(gWinSize.width,gWinSize.height,kCCTexture2DPixelFormat_RGBA4444)

	 		self.screen:getSprite():setAnchorPoint( CCP_HALF )
			self.screen:setPosition( ccp(gWinSize.width/2, gWinSize.height/2) )
			self.screen:setAnchorPoint( CCP_HALF )

	 		self.screen:begin()
	 		scene:visit()
	 		self.screen:endToLua()

	 		self.screen:setPosition(gWinSize.width/2, gWinSize.height/2)
		
			
			

		 end

		 function BAForChangeSceneMoveInEffect:releaseScreenShoot( ... )
		 	if(self.screen ~= nil) then
		 		ObjectTool.removeObject(self.screen)
		 		self.screen = nil
		 	end
		 end


		 function BAForChangeSceneMoveInEffect:release( ... )
 
			BattleLayerManager.removeMasker()			  		
		 	self.super.release(self)
		 	self:releaseScreenShoot()
		 	if(self.maskAnimation) then
		 		self.maskAnimation:release()
		 	end
		 	self.maskAnimation = nil
		 	-- ObjectTool.removeObject(self.maskAnimation)
		 end

return BAForChangeSceneMoveInEffect