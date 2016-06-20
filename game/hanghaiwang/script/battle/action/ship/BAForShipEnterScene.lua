-- 主船入场



require (BATTLE_CLASS_NAME.class)
local BAForShipEnterScene = class("BAForShipEnterScene",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
 	BAForShipEnterScene.shipUI 			= nil 	-- 船ui
 	BAForShipEnterScene.enterSceneSound = nil 	-- 入场音效
	------------------ functions -----------------------

 

	function BAForShipEnterScene:start(data)
		if(self.shipUI ~= nil) then
				local shipHeight = self.shipUI:getBodyHeight()

				if(self.shipUI.teamid == BATTLE_CONST.TEAM1) then
	 				changeY = shipHeight
	 				self.shipUI:setPositionX(g_winSize.width/2)
	 				self.shipUI:setPositionY(-1*shipHeight)
	 			else
	 				changeY = -shipHeight
	 				self.shipUI:setPositionX(g_winSize.width/2)
	 				self.shipUI:setPositionY(g_winSize.height + shipHeight)
	 				
	 			end
	 			
	 			self.shipUI.shipGun:setRotation(0)

	 			local completeCall = function ( ... )
	 			if(self.enterSceneSound ~= nil and self.enterSceneSound ~= "") then
	 				BattleSoundMananger.removeSound(self.enterSceneSound)
	 			end
	 				self:complete()
	 			end
	 			
	 			self.shipUI:getBodyHeight()
	 			self.shipUI:setVisible(true)

	 			local inOne = CCArray:create()
	 			inOne:addObject(CCMoveBy:create(31/60,ccp(0,1.01 * changeY * g_fScaleY)))
	 			inOne:addObject(CCMoveBy:create(3/60,ccp(0,6 - 0.01 * changeY * g_fScaleY)))
	 			inOne:addObject(CCMoveBy:create(1/60,ccp(0,-8)))
	 			inOne:addObject(CCDelayTime:create(3/60))
	 			inOne:addObject(CCMoveBy:create(4/60,ccp(0,6)))
	 			inOne:addObject(CCMoveBy:create(6/60,ccp(0,-4)))


	 		-- 	第 0  帧     位置  -1h			to: -1h

				-- 第 31  帧    位置  0.01h		to: 0.01h
				-- 第 34  帧    位置   6

				-- 第 35  帧    位置  -2
				-- 第 38  帧    位置  -2   

				-- 第 41  帧    位置  4
				-- 第 42  帧    位置  4   

				-- 第 48  帧    位置  0



	 			inOne:addObject(CCCallFuncN:create(completeCall))
	 			-- local callBack = CCCallBack:create(completeCall)
	 			self.shipUI:runAction(CCSequence:create(inOne))

	 			if(self.enterSceneSound ~= nil and self.enterSceneSound ~= "") then
                    BattleSoundMananger.removeSound(self.enterSceneSound)
                    BattleSoundMananger.playEffectSound(self.enterSceneSound,false)
                end

		else
			self:complete()
		end
	 	
 	end

 	-- 释放函数
	function BAForShipEnterScene:release(data)
		
		self.super.release(self)
		 
	end 



return BAForShipEnterScene