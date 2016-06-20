
require (BATTLE_CLASS_NAME.class)
-- 显示转场特效
local BAForShowChangeSceneEffect = class("BAForShowChangeSceneEffect",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
 		BAForShowChangeSceneEffect.screen   = nil
 		BAForShowChangeSceneEffect.deep 	= 10002
 		BAForShowChangeSceneEffect.rendered 	= nil
	------------------ functions -----------------------
		function BAForShowChangeSceneEffect:start( ... )
			if(self.rendered ~= true) then
				self:renderScreen()
			end
			
			
			local onMaskMoveComplete = function ( ... )
 
    				self:complete()
    				self:release()
    		end

			local actionArray = CCArray:create()
			local scene = CCDirector:sharedDirector():getRunningScene()
			local gWinSize = CCDirector:sharedDirector():getWinSize()
			local ccsize = CCSizeMake(gWinSize.width/gWinSize.width * 0.2,gWinSize.height/gWinSize.width * 0.25)

			
			
			actionArray:addObject(CCSplitRows:create(1.5,20))
			actionArray:addObject(CCCallFuncN:create(onMaskMoveComplete))
			self.screen:runAction(CCSequence:create(actionArray))


		end

 		function BAForShowChangeSceneEffect:renderScreen( ... )
	 		local scene = CCDirector:sharedDirector():getRunningScene()
	 		local gWinSize = CCDirector:sharedDirector():getWinSize()
	 		self.screen = CCRenderTexture:create(gWinSize.width,gWinSize.height,kCCTexture2DPixelFormat_RGBA8888)

	 		self.screen:getSprite():setAnchorPoint( CCP_HALF )
			self.screen:setPosition( ccp(gWinSize.width/2, gWinSize.height/2) )
			self.screen:setAnchorPoint( CCP_HALF )

	 		self.screen:begin()
	 		scene:visit()
	 		self.screen:endToLua()

	 		self.screen:setPosition(gWinSize.width/2, gWinSize.height/2)
		
			self.rendered = true
			scene:addChild(self.screen,self.deep)

		 end

		 function BAForShowChangeSceneEffect:release( ... )
		 	self.super.release(self)
		 	if(self.screen) then
		 		self.screen:removeFromParentAndCleanup(true)
		 		self.screen = nil
		 	end
		 end

return BAForShowChangeSceneEffect