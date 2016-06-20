-- 主船退场

require (BATTLE_CLASS_NAME.class)
local BAForShipQuitScene = class("BAForShipQuitScene",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
 	BAForShipQuitScene.shipUI 			= nil 	-- 船ui
	------------------ functions -----------------------

 

	function BAForShipQuitScene:start(data)
		if(self.shipUI ~= nil) then
				local shipHeight = self.shipUI:getBodyHeight()

				if(self.shipUI.teamid == BATTLE_CONST.TEAM1) then
	 				
	 				changeY = -shipHeight
	 				
	 				self.shipUI:setPositionX(g_winSize.width/2)
	 				self.shipUI:setPositionY(0)
	 			else
	 				changeY = shipHeight

	 				self.shipUI:setPositionX(g_winSize.width/2)
	 				self.shipUI:setPositionY(g_winSize.height)
	 				
	 			end
	 			
	 			local completeCall = function ( ... )
	 				self:complete()
	 			end
	 			
	 			self.shipUI:getBodyHeight()

	 			local inOne = CCArray:create()
	 			inOne:addObject(CCMoveBy:create(20/60,ccp(0,changeY * g_fScaleY)))
	 			 
	 			inOne:addObject(CCCallFuncN:create(completeCall))
	 			-- local callBack = CCCallBack:create(completeCall)
	 			self.shipUI:runAction(CCSequence:create(inOne))
		else
			self:complete()
		end
 
 	end

 	-- 释放函数
	function BAForShipQuitScene:release(data)
		
		-- ObjectTool.removeObject(self.shipUI)
		self.super.release(self)
		 
	end 



return BAForShipQuitScene
