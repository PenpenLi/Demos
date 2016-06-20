-- 飞击动作


require (BATTLE_CLASS_NAME.class)
local BAForFlyAttack = class("BAForFlyAttack",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
 
	BAForFlyAttack.damageGenerater 					= nil -- 伤害生成		BAForDamageGenerater
	------------------ functions -----------------------
	function BAForFlyAttack:start(data)
		self:generateDamageInfo()
		self.damageGenerater:excute()
		self:complete()
		self:shake()
		self.damageGenerater = nil

	end
	function BAForFlyAttack:shake()
		local shake = require(BATTLE_CLASS_NAME.BAForShakeScreen).new()
		shake.total = 0.4
		shake:start()
	end
	function BAForFlyAttack:generateDamageInfo( ... )
		-- 遍历被伤害的人
			-- 生成伤害信息
			 local count = 1
			 self.damageGenerater 						= require(BATTLE_CLASS_NAME.BattleDamageGenerater).new() -- todo
			 for k,v in pairs(self.blackBoard.underAttackers or {}) do
				--print("BAForFlyAttack:generateDamageInfo:",count,v.hp)
				count = count + 1
				
				self.damageGenerater.blackBoard 			= self.blackBoard
 
				self.damageGenerater:pushData(v)
			 end
			 self.damageGenerater:init(1)
	end
return BAForFlyAttack