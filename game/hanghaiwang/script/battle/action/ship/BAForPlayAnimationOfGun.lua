-- 播放炮管指定动画
require (BATTLE_CLASS_NAME.class)
local BAForPlayAnimationOfGun = class("BAForPlayAnimationOfGun",require(BATTLE_CLASS_NAME.BaseAction))
	
	BAForPlayAnimationOfGun.shipUI = nil
	BAForPlayAnimationOfGun.animationName = nil

	function BAForPlayAnimationOfGun:start( )
		if(self.shipUI) then
			 local completeCallBack = function ( ... )
			 	self:complete()
			 end

			 if(self.animationName) then
			 	 self.shipUI:playAnimation(self.animationName,completeCallBack)
			 else
			 
			 	 self.shipUI:playFireAnimation(completeCallBack)
			 end
		else
			self:complete()
		end
	end

return BAForPlayAnimationOfGun

