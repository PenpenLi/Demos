

-- 移动动画
-- 这个类的出现实数无奈,此时感慨数据驱动真是好啊,cocos2dx的动画部分还是很有营养的
require (BATTLE_CLASS_NAME.class)
local BAForPlayAndMoveAnimation = class("BAForPlayAndMoveAnimation",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
	BAForPlayAndMoveAnimation.animationName 		= nil -- 动画名称
	BAForPlayAndMoveAnimation.xChange				= nil -- x该变量
	BAForPlayAndMoveAnimation.yChange				= nil -- y改变量
	BAForPlayAndMoveAnimation.totalTime 			= nil -- 总时间
	BAForPlayAndMoveAnimation.container 			= nil -- 容器
	BAForPlayAndMoveAnimation.rotation 				= nil

	BAForPlayAndMoveAnimation.xStart				= nil
	BAForPlayAndMoveAnimation.yStart				= nil

	BAForPlayAndMoveAnimation.costTime 				= nil -- 耗费时间 
	BAForPlayAndMoveAnimation.animation 			= nil -- 动画实例
	BAForPlayAndMoveAnimation.soundName 			= nil -- 声音

 	------------------ functions -----------------------
 	
 
 	function BAForPlayAndMoveAnimation:start( ... )
 		assert(self.totalTime)
 		assert(self.costTime)
 		assert(self.animationName)
 		
 		assert(self.xStart)
 		assert(self.yStart)

 		
 		if(self.container == nil ) then
			self.container = BattleLayerManager.battleAnimationLayer
		end

 		-- 检测是否是可以移动
 		local notMove = false
		if self.xChange == nil then
			self.xChange = 0
		end

		if self.yChange == nil then
			self.yChange = 0
		end
		if self.xChange == 0 and yChange == 0 then
			notMove						  = true
		end

		if(notMove~= true) then
			self.costTime = 0

			self:getAnimation()
			self:addToRender()
		else
			-- self:release()
			self:complete()
		end
 	end
 	function BAForPlayAndMoveAnimation:update( dt )

 		local movePercent 									= dt/self.totalTime
		--保留1位小数
		local dx 											= math.ceil(self.xChange * movePercent * 10)/10
		local dy 											= math.ceil(self.yChange * movePercent * 10)/10
		-- --print("BaseActionForMoveTo:update:",dx,",",dy)
		self.costTime 										= self.costTime + dt -- 总消耗时间可以用来做差值，简单起见 做了匀速 所以暂时不需要了

		--如果没移动完成
		if self.costTime  < self.totalTime then
			local currentPostion = self.animation:getPosition()
			local ani = tolua.cast(self.animation,"CCNode")
			ani:setPositionX(ani:getPositionX() + dx)
			ani:setPositionY(ani:getPositionY() + dy)
		-- 移动完成
		else
	
			self:complete()
			self:release()
		end


 	end
 	
 	function BAForPlayAndMoveAnimation:release( ... )
 		self.super.release(self)
 		if(self.animation) then
 			local ani = tolua.cast(self.animation,"CCNode")
 			-- local arm = tolua.cast(self.animation,"CCArmature")
 			-- if(arm) then
 			-- 	local armAni = arm:getAnimation()
 			-- 	if(armAni) then armAni:stop() end
 			-- end
 			if(ani:getParent()) then
 				ani:removeFromParentAndCleanup(true)
 			end
 			self.animation 	= nil
 			

 		end
 		self.container = nil
 		self.animationName 	= nil
 		self.totalTime 	  	= nil
 		self.cost			= nil 			
 	end

 	-- 生成动画
 	function BAForPlayAndMoveAnimation:getAnimation()
 			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
 			if(filesExists == true) then 

 					self.animation = ObjectTool.getAnimation(self.animationName,false)
	  				self.animation:getAnimation():playWithIndex(0,0,0,1)
 

	  				self.container:addChild(self.animation)
	  				self.animation:setPosition(self.xStart,self.yStart)
	  				-- BattleSoundMananger.playEffectSound(self.animationName)
 					if(self.soundName ~= nil and self.soundName ~= "") then
 						-- Logger.debug("-- rage bar play sound:" .. self.rageBarMusic)
 						BattleSoundMananger.removeSound(self.soundName)
 						BattleSoundMananger.playEffectSound(self.soundName,false)
 					else

	  					BattleSoundMananger.playEffectSound(self.animationName)
	  				end

  			else
  				--如果不存在,那么我们就创建一个空的
  				self.animation = CCSprite:create()
				self.container:addChild(self.animation)
  				self.animation:setPosition(self.xStart,self.yStart)
				-- url 								= BattleURLManager.getAttackEffectURL(self.animationName)
				-- ----print("BAForPlayEffectAtHero:start animationURL:",url)
				-- self.animation = CCLayerSprite:layerSpriteWithName(url, -1,CCString:create(""));
	   --          --self.animation:retain()
	   --          self.animation:setAnchorPoint(ccp(0.5, 0.5));
	            
	   --          -- self.animation:setPosition(postion.x,postion.y);
	   --          self.animation:setPosition(self.xStart,self.yStart);
	             
				-- self.container:addChild(self.animation)
 
			end
			
			local damageActionArray = CCArray:create()
         	 damageActionArray:addObject(CCFadeIn:create(self.totalTime * 0.2))
         	 damageActionArray:addObject(CCDelayTime:create(self.totalTime *0.3))
         	 damageActionArray:addObject(CCFadeOut:create(self.totalTime *0.45))
         	 -- damageActionArray:addObject(CCCallFuncN:create(removeSelf))

         	 local ani = tolua.cast(self.animation,"CCNode")
         	 ani:runAction(CCSequence:create(damageActionArray))

			if(self.rotation ~= nil and self.rotation ~= 0) then
				self.animation:setRotation(self.rotation)
			end
 	end

 return BAForPlayAndMoveAnimation