

-- 震屏
require (BATTLE_CLASS_NAME.class)
local BAForShakeScreen = class("BAForShakeScreen",require(BATTLE_CLASS_NAME.BaseAction))
	 
		------------------ properties ----------------------
		BAForShakeScreen.total 			= nil

		BAForShakeScreen.count			= nil
		BAForShakeScreen.sizeHeight 	= nil
		BAForShakeScreen.root 			= nil
		BAForShakeScreen.minY 			= nil
		BAForShakeScreen.range 			= nil
		BAForShakeScreen.timeMode 		= nil
		------------------ functions -----------------------
		function BAForShakeScreen:ctor()
			self.minY 	= 1
			self.range 	= 3
			self.timeMode = true
			self.super.ctor(self)
		end
		function BAForShakeScreen:start(data)
			assert(self.total)
			 -- print("-- shake start",self.total)
			if(self.root == nil) then
				self.root 			= BattleLayerManager.battleBaseLayer	
			end
			 
			if(self.total ~= nil and self.total > 0 ) then
					self.count 			= 0
					self:addToRender()
					
					self.sizeHeight 	= CCDirector:sharedDirector():getWinSize().height
			else
					-- print("-- shake over")
					self:complete()
			end -- if end
		end -- function end

		function BAForShakeScreen:update( dt )
			-- 如果是时间模式
			if(self.timeMode == true) then
				self.count = self.count + dt
				if(self.count < self.total) then
					self:doShake()
				else
					BattleLayerManager.battleBaseLayer:setPosition(0,0)
					self:complete()
				end
			-- 逐帧模式
			else
				self.count = self.count + 1
				if(self.count < self.total) then
					self:doShake()
				else
					BattleLayerManager.battleBaseLayer:setPosition(0,0)
					self:complete()
				end
			end

		end

		function BAForShakeScreen:doShake()
	 
		    math.randomseed(os.time())
		    local shakeY = math.floor(math.random()*self.range+self.minY)*self.sizeHeight*0.003
		    
		    if(self.root:getPositionY()>=0) then
		        shakeY = -shakeY
		    end
		    
		    self.root:setPosition(0,shakeY)
		end

		function BAForShakeScreen:release( ... )
			self.super.release(self)
			self.total = 0
			BattleLayerManager.battleBaseLayer:setPosition(0,0)
			self:removeFromRender()
		end
 
return BAForShakeScreen