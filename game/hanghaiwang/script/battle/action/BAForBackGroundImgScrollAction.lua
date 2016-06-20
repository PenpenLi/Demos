


-- 背景滚动
require (BATTLE_CLASS_NAME.class)
local BAForBackGroundImgScrollAction = class("BAForBackGroundImgScrollAction",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
	BAForBackGroundImgScrollAction.direction		= BATTLE_CONST.DIR_UP
	BAForBackGroundImgScrollAction.moveTime			= nil--BATTLE_CONST.HERO_MOVE_COST_TIME
	BAForBackGroundImgScrollAction.moveDistence		= nil--0 --- todo 距离 * scaleY
	BAForBackGroundImgScrollAction.targets			= nil
	BAForBackGroundImgScrollAction.costTime 		= nil
	BAForBackGroundImgScrollAction.delay 			= nil
	------------------ functions -----------------------
	function BAForBackGroundImgScrollAction:start( ... )
			if(self.targets and self.moveDistence > 0) then	

					self.costTime = 0
					self.delay 	  = 0
					self.dis 	  = self.direction * self.moveDistence
					self:addToRender()
			else
				self:complete()
			end
			
	end

	function BAForBackGroundImgScrollAction:update( dt )
		-- Logger.debug("BAForBackGroundImgScrollAction moveTime:" .. self.moveTime )
		 if(self.delay > 0) then 
		 	-- Logger.debug("BAForBackGroundImgScrollAction delay:" .. self.delay )
		 	self.delay = self.delay - 1 
		 	return
		 end 
		 self.costTime = self.costTime + dt
		 if(self.costTime < self.moveTime) then
		 	local dy = dt/self.moveTime * self.dis
		 	-- --print("== update:",self.costTime,self.moveTime,dy)
		 	self.targets:scrollPy(dy)
		 else
		 	-- self.targets:scrollPyTo(self.direction * self.moveDistence)
		 	self:complete()
		 end
	end
 
	function BAForBackGroundImgScrollAction:release( ... )
		self.super.release(self)
		if(self.targets) then
			self.targets = nil
		end
	end

return BAForBackGroundImgScrollAction