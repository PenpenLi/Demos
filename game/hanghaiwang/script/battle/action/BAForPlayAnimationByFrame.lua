
-- 在英雄身上添加特效(播完不删除)
-- 目前专用在转场特效heimo
require (BATTLE_CLASS_NAME.class)
local BAForPlayAnimationByFrame = class("BAForPlayAnimationByFrame",require(BATTLE_CLASS_NAME.BaseAction))
 
	 
		------------------ properties ----------------------
		BAForPlayAnimationByFrame.animationName 		= nil
		BAForPlayAnimationByFrame.container 			= nil
		BAForPlayAnimationByFrame.evtFrameCallBack 		= nil
		BAForPlayAnimationByFrame.completeCallBack 		= nil

		BAForPlayAnimationByFrame.animation 			= nil
		BAForPlayAnimationByFrame.zOder 				= nil
		BAForPlayAnimationByFrame.totalFrame 			= 61
		BAForPlayAnimationByFrame.keyFrame 				= 30
		BAForPlayAnimationByFrame.count 				= nil
		BAForPlayAnimationByFrame.paused 				= nil
		------------------ functions -----------------------
		function BAForPlayAnimationByFrame:start( ... )
			if(self.animationName and self.container and self.completeCallBack) then
				 -- Logger.debug("BAForPlayAnimationByFrame start scale:".. g_fScaleX)
				 self.animation = ObjectTool.getAnimation(self.animationName,false)
				 self.animation:setPosition(g_winSize.width/2,g_winSize.height/2)
				 -- self.animation:setScale(2)
				 if(self.zOder) then
				 	self.container:addChild(self.animation,self.zOder,self.zOder)
				 else
					self.container:addChild(self.animation)
				 end
				 self.totalFrame = 61 -- db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)
				 self.count 	 = 1
				 self.paused 	 = false
				 self.animation:getAnimation():pause()

				 -- if(self.evtFrameCallBack ~= nil) then
				 -- 	self.animation:getAnimation():setFrameEventCallFunc(self.evtFrameCallBack)
				 -- end
				 self:addToRender()
			else
				Logger.debug("BAForPlayAnimationByFrame toComplete")
				self:complete()
			end
		end
		
		function BAForPlayAnimationByFrame:update( dt )
			
			if(self.paused ~= true) then
				self.count = self.count + 1
				-- Logger.debug("BAForPlayAnimationByFrame update to:" .. self.count)
				self.animation:getAnimation():gotoAndPause(self.count)
				if(self.count == self.keyFrame) then
					-- self:stop()
					if(self.evtFrameCallBack) then
						self.evtFrameCallBack()
						self.evtFrameCallBack = nil
					end
				end
				if(self.count >= self.totalFrame) then
					self:complete()
					ObjectTool.removeObject(self.animation,false)

					if(self.animation) then
		 			 	ObjectSharePool.addObject(self.animation,self.animationName)
		 			end
					
					self.animation = nil
					
					if(self.completeCallBack ~= nil) then
						self.completeCallBack()
						self.completeCallBack = nil
					end
				end
			end
		end

		function BAForPlayAnimationByFrame:stop( ... )
			self.paused = true
		end

		function BAForPlayAnimationByFrame:resume( ... )
			self.paused = false
		end

		function BAForPlayAnimationByFrame:isPaused( ... )
			return self.paused == true
		end

		function BAForPlayAnimationByFrame:release( ... )
			self.super.release(self)
			ObjectTool.removeObject(self.animation)
			if(self.animation) then
		 		ObjectSharePool.addObject(self.animation,self.animationName)
		 	end

			self.animation 			= nil
			self.animationName 		= nil
			self.container 			= nil
			self.evtFrameCallBack 	= nil
			self.completeCallBack 	= nil
		end


 return BAForPlayAnimationByFrame