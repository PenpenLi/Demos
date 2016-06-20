-- 指定地点播放特效
require (BATTLE_CLASS_NAME.class)
local BAForPlayEffectAtPostion = class("BAForPlayEffectAtPostion",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForPlayEffectAtPostion.postionX 					= nil -- 动画播放位置x
	BAForPlayEffectAtPostion.postionY 					= nil -- 动画播放位置y
	BAForPlayEffectAtPostion.animationName 				= nil -- 动画名称
	BAForPlayEffectAtPostion.container 					= nil -- 动画添加到的容器
	BAForPlayEffectAtPostion.totalFrame					= nil
	BAForPlayEffectAtPostion.currentFrame 				= nil
	BAForPlayEffectAtPostion.rotation 					= nil
	BAForPlayEffectAtPostion.soundName 					= nil -- 指定声音
	BAForPlayEffectAtPostion.animationZ 				= nil
	BAForPlayEffectAtPostion.animationTag 				= nil
	------------------ functions -----------------------
	function BAForPlayEffectAtPostion:ctor( ... )
		-- ObjectTool.setProperties(self)
		self.super.ctor(self)
		self.totalFrame 	= 0
		self.currentFrame 	= 0
		self.rotation 		= 0
	end
	function BAForPlayEffectAtPostion:start(data)
 
		-- print(" === BAForPlayEffectAtPostion:",self.animationName,self.postionX,self.postionY)
		if(self.animationName ~= nil) then
			self.totalFrame = db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName) * 1/60
			self.currentFrame = 0
			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
 			if(filesExists == true) then 

 					self.animation = ObjectTool.getAnimation(self.animationName,false)
 					 
	  				-- self.animation:setScale(BATTLE_CONST.ANIMATION_SCALE)
	  				-- --print("BAForPlayEffectAtHero:start animation:3")
	  				self.animation:getAnimation():playWithIndex(0,-1,-1,0)
	  				self.animation:setPosition(ccp(self.postionX,self.postionY) )
	  				if(self.container == nil ) then
						BattleLayerManager.addNode(self.animationName,self.animation)
					else
						if(self.animationZ ~= nil and self.animationTag ~= nil) then
							self.container:addChild(self.animation,self.animationZ,self.animationTag)
						else
							self.container:addChild(self.animation)
						end
					end

	  				
	  				self.animation:setPosition(self.postionX,self.postionY)
	  				self.animation:getAnimation():playWithIndex(0,-1,-1,0)
	  				self:addToRender()
	  				
	  				if(self.soundName ~= nil and self.soundName ~= "") then
 						-- Logger.debug("-- rage bar play sound:" .. self.rageBarMusic)
 						BattleSoundMananger.removeSound(self.soundName)
 						BattleSoundMananger.playEffectSound(self.soundName,false)
 					else

	  					BattleSoundMananger.playEffectSound(self.animationName)
	  				end

	  				if(self.rotation ~= nil and self.rotation ~= 0) then
						self.animation:setRotation(self.rotation)
			 		end
	  		else
	  			Logger.debug("未发现特效:" .. self.animationName)
	  			self:complete()
 			end -- if end
 		else
 			Logger.debug("特效为空:")
 			self:complete()
 		end -- ifend
 
			
		-- end
	end -- function end
	function BAForPlayEffectAtPostion:update( dt )
		self.currentFrame = self.currentFrame + dt
 		-- self.animation:getAnimation():stop()
 		-- self.animation:getAnimation():gotoAndPause(self.current)
 		if(self.currentFrame >= self.totalFrame + 0.1) then 
 			-- print(" BAForPlayEffectAtPostion:update complete")
 			-- self.animation:getAnimation():stop()
 			 
 			 if(self.animation) then
 			 	ObjectSharePool.addObject(self.animation,self.animationName)
 			 end
 			 ObjectTool.removeObject(self.animation,false)
 			 self.animation = nil
 			 -- self.animation:getAnimation():stop()
 			 BattleSoundMananger.removeSound(self.animationName)
 			 
 			 self:complete()
 			 BattleLayerManager.checkBatchMap()
 		end
		-- db_BattleEffectAnimation_util
	end
return BAForPlayEffectAtPostion