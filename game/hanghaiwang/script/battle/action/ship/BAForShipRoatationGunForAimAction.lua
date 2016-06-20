


-- 旋转炮台完成瞄准动作
require (BATTLE_CLASS_NAME.class)
local BAForShipRoatationGunForAimAction = class("BAForShipRoatationGunForAimAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShipRoatationGunForAimAction.gunUI 			= nil 	-- 炮ui
	BAForShipRoatationGunForAimAction.rotationTo 		= nil 	-- 炮旋转到角度
	BAForShipRoatationGunForAimAction.soundName 		= nil 	--  
 
	------------------ functions -----------------------

 

	function BAForShipRoatationGunForAimAction:start(data)
	 
		-- if(self.gunUI~= nil and ObjectTool.isOnStage(self.gunUI) == true and self.rotationTo ~= nil ) then
		if(self.gunUI~= nil and ObjectTool.isOnStage(self.gunUI) == true and self.rotationTo) then


			local inone1 = CCArray:create()
			-- 左摇,右摆,定位
           inone1:addObject( CCRotateTo:create(0.45, 15))
           inone1:addObject( CCRotateTo:create(0.45, -15))
           inone1:addObject( CCRotateTo:create(0.5, self.rotationTo))
           local completeCall = function ( ... )
           		-- self.gunUI:playFireAnimation()
           		self:complete()
           end
           cb = CCCallFuncN:create(completeCall)
           inone1:addObject(cb)
           local re = CCSequence:create(inone1)
           self.gunUI:runAction(re)

            print(" --- BAForShipRoatationGunForAimAction:",self.soundName)
			if(self.soundName ~= nil and self.soundName ~= "") then
				BattleSoundMananger.removeSound(self.soundName)
				BattleSoundMananger.playEffectSound(self.soundName,false)
			end

        else
			self:complete()
		end
 	end

 	-- 释放函数
	function BAForShipRoatationGunForAimAction:release(data)

		if(self.soundName ~= nil and self.soundName ~= "") then
			BattleSoundMananger.removeSound(self.soundName)
		end

		ObjectTool.removeObject(self.animation)
		self.super.release(self)
		 
		self.animationName 				= nil
		self.heroUI 					= nil
	end 



return BAForShipRoatationGunForAimAction