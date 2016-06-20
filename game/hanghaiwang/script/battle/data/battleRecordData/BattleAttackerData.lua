

local BattleAttackerData = class("BattleAttackerData")
 

 -- 		defender : int 		
	-- 		reaction : int		//响应ID： 命中/闪避/格挡。。。
	-- 		fatal : bool		//是否触发暴击
	-- 		rage : int			
	-- 		arrDamage : array
	-- 		[
	-- 			{
	-- 				damageType : int
	-- 				damageValue : int
	-- 			}
	-- 		]
	-- 		enBuffer : array	
	-- 		deBuffer : array
	-- 		imBuffer : array
	-- 		buffer : array
 
 

	------------------ properties ----------------------
	BattleAttackerData.defender 	= nil --防御者id
	BattleAttackerData.reaction 	= nil --响应id 命中/闪避/格挡
	BattleAttackerData.fatal 	 	= false
	BattleAttackerData.rage			= 0
	BattleAttackerData.hp 		 	= 0
	BattleAttackerData.buffer 		= nil -- buff信息

	------------------ functions -----------------------
	function BattleAttackerData:reset( data )
		self.id 				= tonumber(data.attacker)
		self.defender			= tonumber(data.defender)
		self.reaction			= tonumber(data.reaction)
		self.fatal				= data.fatal
		self.rage				= tonumber(data.rage)
		self.hp 				= 0
		-- if data.arrDamage ~= nil then
		-- 	for i,v in pairs(data.arrDamage) do
		-- 	 self.hp = self.hp + v.damageValue
		-- 	end -- for end
		-- end -- if end

		
		-- buff信息
		self.buffer 			= require(BATTLE_CLASS_NAME.BattleBuffsInfo).new()
		self.buffer:reset(data,self.id)

	end	-- function end
	
	function BattleAttackerData:totalHPChange()
		return self.buffer.totalHpDamge
	end

	function BattleAttackerData:totalRageChange( ... )
		return self.buffer.totalRageDamage
	end


	function BattleAttackerData:combin( data )
		if data.defender == self.defender then
		
		end -- if end
	end
	
return BattleAttackerData