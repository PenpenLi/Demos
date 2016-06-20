


-- 远程弹道特效: 按轨迹 播放特效
 
local BAForRemoteSpell = class("BAForRemoteSpell",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
 	BAForRemoteSpell.damageData 						= nil -- 伤害信息

	BAForRemoteSpell.startX								= 0
 	BAForRemoteSpell.startY								= 0
 	BAForRemoteSpell.endX 								= 0
 	BAForRemoteSpell.endY 								= 0

 	BAForRemoteSpell.animationName	 					= nil
 	BAForRemoteSpell.needRotation 						= true

 	BAForRemoteSpell.particleName 						= nil -- 弹道粒子
 	BAForRemoteSpell.particle 							= nil -- 粒子实例
 	

 	BAForRemoteSpell.dx 								= 0
	BAForRemoteSpell.dy 								= 0

	BAForRemoteSpell.frameCost							= BATTLE_CONST.FRAME_TIME * 1000

	
	BAForRemoteSpell.container 							= nil -- 动画添加到的容器
	BAForRemoteSpell.costTime 							= 0
	BAForRemoteSpell.current 							= 0
	BAForRemoteSpell.overTarget 						= true -- 是否穿透目标继续前进
	BAForRemoteSpell.postionx 							= 0
	BAForRemoteSpell.postiony 							= 0
	BAForRemoteSpell.frameDelay							= 0
	BAForRemoteSpell.soundName							= nil -- 指定音效
	-- BAForRemoteSpell.
 	-- BAForRemoteSpell.skill 
	------------------ functions -----------------------
	function BAForRemoteSpell:release()
		-- print("-- BAForRemoteSpell:release self.animation",self.animation)
		if(self.particle) then
			self.particle:stopSystem()
		end
		local removeResult = ObjectTool.removeObject(self.particle)
		ObjectTool.removeObject(self.animation)
		-- print("-- BAForRemoteSpell:release",removeResult)
		self.super.release(self)
		self.particle = nil
	end
	function BAForRemoteSpell:start(data)
		-- print("-- BAForRemoteSpell:start")
		-- if(self.container == nil ) then
		-- 	self.container = BattleLayerManager.battleRemoteSpellLayer
		-- end
		-- 如果穿透目标,那么我们需要从新计算弹道运行时间
		-- Logger.debug("BAForRemoteSpell:overTarget " .. tostring(self.overTarget))
		if(self.overTarget == true) then
			self.frameDelay = 0
			-- Logger.debug("BAForRemoteSpell:overTarget 1")
			local dx 		= self.endX - self.startX
			local dy 		= self.endY - self.startY
			local dis 		= math.sqrt(dx * dx + dy * dy)

 

			local flag = true
			local nextx = self.endX
			local nexty = self.endY
			local overrscreen = 1 -- 结束的时候再移动一次,所以初始值为1
			while(flag) 
			do 
				if(nextx < 0 or nextx > g_winSize.width or nexty < 0 or nexty > g_winSize.height) then
					flag = false
				else
					overrscreen = overrscreen + 1
					nextx = nextx + self.speedX
					nexty = nexty + self.speedY
				end
			end -- while end
			local xMove 			= self.speedX * overrscreen
			local yMove 			= self.speedY * overrscreen
			local remainMove 		= math.sqrt(xMove * xMove + yMove * yMove)
			local remainCost 		= remainMove/dis
			self.costTime 			= self.costTime * (1 + remainCost) 
		end
		self.postionx = self.startX
		self.postiony = self.startY
		-- 已知弹道起点 S(sx,sy) 终点 E(ex,ey)
		-- 已知特效方向为 A(ax,ay) ->(0,1)
		-- 求弹道旋转角度

			-- 1.弹道方向向量: D = E - S = (ex - sx,ey - sy)
			-- 2.点乘:	    A * D =  ax * dx + ay * dy = |A| * |D| * cos
			-- 3.叉乘:        A x D = ax * dy - ay * dx
			-- 4.叉乘结果大于0则表示在顺时针方向
		local rotation = 0
		-- 如果特效需要旋转 或者 有粒子特效 那么需要计算偏转(粒子需要偏转)
		if(self.needRotation or self.particleName ~= nil) then
			 local dx = self.endX - self.startX
			 local dy = self.endY - self.startY
			 local ax = 0
			 local ay = 1
			 local dot = ax * dx + ay * dy 
			 local product = ax * dy - ay * dx
			 local dLength = math.sqrt(dx * dx + dy * dy)
			 local aLength = 1
			 local cos = dot/dLength
			 rotation = math.deg(math.acos(cos))
			 if(product > 0 ) then rotation = 360 - rotation end
		end
		 
		-- 增加10像素补差
		-- self.costTime 								= self.costTime + math.ceil(10/BATTLE_CONST.SPELL_SPEED) *  BATTLE_CONST.FRAME_TIME
		self.current 								= 0
		--print("remote animationName:",self.animationName,self.current ,self.costTime)
		--print("remote info:", self.startX,self.startY,self.endX,self.endY)
		if(self.animationName ~= nil) then

			-- self.animationName = "bullet_17"
			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
			-- local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation("bullet_17")
 			if(filesExists == true) then 
 					-- Logger.debug("-- play animation:" .. tostring(self.animationName))
 					self.animation = ObjectTool.getAnimation(self.animationName,true)
	  				 

	  				if(self.soundName ~= nil and self.soundName ~= "") then
 						-- Logger.debug("-- rage bar play sound:" .. self.rageBarMusic)
 						BattleSoundMananger.removeSound(self.soundName)
 						BattleSoundMananger.playEffectSound(self.soundName,false)
 					else

	  					BattleSoundMananger.playEffectSound(self.animationName)
	  				end
 
	  				-- self.animation:getAnimation():playWithIndex(0,0,-1,1)
 			else
 					self.animation = CCSprite:create()
 			end
 			self.current = 0
	 

		    self.animation:setPosition(self.startX,self.startY);
		    if(self.needRotation) then
		   		self.animation:setRotation(rotation)
		   	end
		   	
		   	self.animation:setAnchorPoint(ccp(0.5, 0.5));
	       	-- BattleLayerManager.addNode(self.animationName,self.animation)
	       	self.animation:setPosition(self.startX,self.startY);
	       	-- self.animation:setVisible(false)
	       	BattleLayerManager.battleRemoteSpellLayer:addChild(self.animation)
		   	-- self.particleName = "honglizi_22"
	       	if(self.particleName ~= nil) then

		       	self.particle 	  =  ObjectTool.getParticle(self.particleName)
		       	if(self.particle) then
					self.particle:setPosition(self.startX,self.startY)
					self.particle:setAnchorPoint(ccp(0.5, 0.5))
					-- BattleLayerManager.addNode(self.particleName,self.particle,1)
					BattleLayerManager.battleRemoteSpellLayer:addChild(self.particle)

					
					-- self.particle:setRotation(rotation)
				else
					ObjectTool.removeObject(self.particle)
					self.particle = nil
				end

	        end     
	        -- self.animation:setPosition(postion.x,postion.y);
	        -- self.container:addChild(self.animation)
	        
	        -- self.animation:getAnimation():playWithIndex(0,0,-1,1)
	    	self:addToRender()
	   		
	    else
	    	self:complete()
		end-- if end

		

	end -- function end
	function BAForRemoteSpell:update( dt )
		if(tolua.isnull(self.animation)) then
			self:removeFromRender()
			self.animation = nil
			-- print("--- BAForRemoteSpell error:",self.animationName)
			self:release()
			return 
		end

		if(self.frameDelay > 0) then
			self.frameDelay= self.frameDelay - 1
			if(self.frameDelay <= 0) then
				-- self.animation:setVisible(true)
			end
			return 
		end

		self.current = self.current + dt
		-- local percent = dt/self.costTime
		-- if percent >= 1 then percent = 1 end

		-- self.animation:setPosition(self.animation:getPositionX()+ self.dx * percent,self.animation:getPositionY()  + self.dy * percent);
		-- self.animation:setPosition(self.animation:getPositionX()+ dt * self.speedX,self.animation:getPositionY()  + dt * self.speedY);
		-- self.animation:setPosition(self.animation:getPositionX()+ dt * self.speedX,self.animation:getPositionY()  + dt * self.speedY);
		self.postionx = self.postionx + dt * self.speedX
		self.postiony = self.postiony + dt * self.speedY
		
		if(self.particle) then
			self.particle:setPosition(self.postionx,self.postiony)
		end
		self.animation:setPosition(self.postionx,self.postiony);

		-- --print("BAForRemoteSpell:update ",self.current," costTime:",self.costTime," dt:",dt)
		-- --print("BAForRemoteSpell:update x ->",self.animation:getPositionX()," y ->",self.animation:getPositionY())
		-- --print("BAForRemoteSpell:toX ->",self.endX ," toY ->",self.endY)
		if (self.current >= self.costTime) then
			-- print("--- BAForRemoteSpell complete:",self.animationName)
			-- self.animation:setPosition(self.startX + dx * percent,self.startY  + dy * percent);
			-- self.particle:setPosition(self.endX,self.endY);
			ObjectTool.removeObject(self.particle)
			self.particle = nil
			self.animation:setPosition(self.endX,self.endY);
			 -- if(self.animation:getParent()) then
		 	-- 	self.animation:removeFromParentAndCleanup(true)
		 	--  end
		 	ObjectTool.removeObject(self.animation,false)
		 	if(self.animation) then
		 		ObjectSharePool.addObject(self.animation,self.animationName)
		 	end
		 	BattleSoundMananger.removeSound(self.animationName)
		 	self.animation = nil
		 	-- self.animation:setDelegate(nil)
		 	self:complete()
		 end
	end

	function BAForRemoteSpell:getHitTime()
		local dx 		= self.endX - self.startX
		local dy 		= self.endY - self.startY
		local dis 		= math.sqrt(dx * dx + dy * dy)

		self.costTime 	= dis/BATTLE_CONST.SPELL_SPEED--math.ceil()-- *  BATTLE_CONST.FRAME_TIME
		self.speedX 		= dx/self.costTime
		self.speedY 		= dy/self.costTime
		-- print("BAForRemoteSpell:getHitTime :",self.costTime," dis:",dis)
		return self.costTime
	end
	-- function BAForSpellAttack:excuteDamage()
 
	-- end

return BAForRemoteSpell