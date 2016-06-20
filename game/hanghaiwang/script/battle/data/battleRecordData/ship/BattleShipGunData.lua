

local BattleShipGunData = class("BattleShipGunData")
	
	BattleShipGunData.id 				= nil
	BattleShipGunData.level 			= nil
	BattleShipGunData.skillid 			= nil
	BattleShipGunData.gunAnimationName  = nil
	function BattleShipGunData:reset( data )
		if(data) then
			assert(data.bid,"主船数据没有bid")
			assert(data.attackSkill,"主船数据没有attackSkill")

			self.id 		= data.bid
			self.level 		= data.level
			self.skillid 	= data.attackSkill
			-- 其实炮体是根据技能确定的
			self.gunAnimationName 	= "ship_skill_01"
		end

	end



return BattleShipGunData

-- ship	Object (@f741d19)	
-- 	arrGunBar	[] (@fa2ae71)	
-- 		[0]	Object (@f741cd1)	
-- 			attackSkill	218 [0xda]	
-- 			bid	1	
-- 			level	3	
-- 		length	1	
-- 	sid	2	
-- 	tid	1	