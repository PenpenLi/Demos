

-- 敌方移动到
require (BATTLE_CLASS_NAME.class)
local BAForMoveArmyFromFarAction = class("BAForMoveArmyFromFarAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	BAForMoveArmyFromFarAction.direction		= BATTLE_CONST.DIR_UP
	BAForMoveArmyFromFarAction.moveTime			= 2.5
	BAForMoveArmyFromFarAction.moveDistence		= 0

	BAForMoveArmyFromFarAction.costTime 		= nil
	BAForMoveArmyFromFarAction.delay 			= nil

	------------------ functions -----------------------
	function BAForMoveArmyFromFarAction:start( ... )
			if(self.moveDistence > 0) then
				self.delay = 0

				-- local call = function ( ... )
				-- 				self:onActinComplete()
				-- 			 end
				for k,v in pairs(BattleTeamDisplayModule.armyDisplayListByPostion) do
					v:moveBy(0,-self.direction * self.moveDistence)
				end
 
				-- end
				self:addToRender()
			else
				self:complet()
			end

	end

	function BAForMoveArmyFromFarAction:update( dt )
		 if(self.delay > 0) then 
		 	self.delay = self.delay - 1 
		 	 -- Logger.debug("BAForMoveArmyFromFarAction:delay:"..self.delay) 
		 	return
		 end 
		 -- Logger.debug("BAForMoveArmyFromFarAction:moveTime:"..self.moveTime) 
		 self.costTime = self.costTime + dt
		 if(self.costTime < self.moveTime) then
		 	local dy = dt/self.moveTime * self.direction * self.moveDistence
		 	
		 	for k,v in pairs(BattleTeamDisplayModule.armyDisplayListByPostion) do
					v:moveBy(0,dy)
			end
		 else
		 	-- self.targets:scrollPyTo(self.direction * self.moveDistence)
		 	self:complete()
		 end
	end


	function BAForMoveArmyFromFarAction:onActinComplete( ... )
		self:complete()
	end
return BAForMoveArmyFromFarAction