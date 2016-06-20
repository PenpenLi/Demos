

-- 显示主船技能名称
require (BATTLE_CLASS_NAME.class)
local BAForShowShipSkillName = class("BAForShowShipSkillName",require(BATTLE_CLASS_NAME.BaseAction))
 	BAForShowShipSkillName.skillNameImageName = nil
 	BAForShowShipSkillName.posX = nil
 	BAForShowShipSkillName.posY = nil
 	function BAForShowShipSkillName:start()
 		-- print("BAForShowShipSkillName",1)
 		if(self.skillNameImageName ~= nil) then
 			-- print("BAForShowShipSkillName",2,self.skillNameImageName)
 			self.img = CCSprite:create(self.skillNameImageName)
 			self.img:setPosition(ccp(self.posX,self.posY))
 			BattleLayerManager.battleNumberLayer:addChild(self.img)

 			local onActionComplete = function ( ... )
 				-- print("BAForShowShipSkillName",3)
				self:complete()
				-- self:release()
			end

 			 local defenderActionArray = CCArray:create()
	        defenderActionArray:addObject(CCDelayTime:create(1.5))
	        defenderActionArray:addObject(CCCallFuncN:create(onActionComplete))
	        self.img:runAction(CCSequence:create(defenderActionArray))
 		else
 			self:complete()
 		end
 	end

		-- 释放函数
	function BAForShowShipSkillName:release(data)
		
		ObjectTool.removeObject(self.img)
		self.super.release(self)
		self.img = nil
	end 

return BAForShowShipSkillName
