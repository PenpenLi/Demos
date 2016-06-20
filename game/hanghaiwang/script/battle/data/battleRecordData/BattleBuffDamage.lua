

local BattleBuffDamage = class("BattleBuffDamage")

	------------------ properties ----------------------
	-- 		bufferId : int 	
	-- 		type : int		//buff效果类型
	-- 		data : int 		//buff效果数值
	--
	BattleBuffDamage.id 		= nil
	BattleBuffDamage.type   	= nil
	BattleBuffDamage.data		= nil
	BattleBuffDamage.hpDamage	= nil
	BattleBuffDamage.rageDamage	= nil
	BattleBuffDamage.hpChange	= false
	BattleBuffDamage.rageChang	= false
	BattleBuffDamage.damageTime = nil
	BattleBuffDamage.targetId	= nil 
	BattleBuffDamage.rageUp		= nil 
	------------------ functions -----------------------
	-- des:
	function BattleBuffDamage:reset( data , targetId)
		 self.id 			= data.bufferId
		 self.type 			= data.type
		 self.targetId 		= targetId
		 self.hpDamage 		= 0
		 self.rageDamage 	= 0
		  --self.data			= data.data
		  -- Logger.debug("buffer:" .. data.bufferId .. "  value:" .. data.data  .. "  type:" .. data.type)
		 if self.type == 9 then -- self.type == 1 or 
		 	 self.hpDamage = tonumber(data.data)
		 	 self.hpChange = true
		 elseif self.type == 28 or self.type == 71 then -- self.type == 2 or 
		 	 self.rageDamage = tonumber(data.data)
		 	 self.rageChang = true
		 	 if(self.type == 28) then
		 	 	self.rageUp = true
		 	 else
		 	 	self.rageUp = false
		 	 end
		 	 -- self.rageUp = false
		 else
		 	error("BattleBuffDamage:reset type is error:,",self.type)
		 end -- if end

		 self.damageTime 	= 0 -- 伤害时间

	end
	--同idbuff伤害合并
	function BattleBuffDamage:combine( data )
		if data.bufferId == self.id then
			 --self.data			= data.data
		 if data.type == 1 then
		 	 self.hpDamage = data.data
		 	 self.hpChange = true
		 elseif data.type == 2 then
		 	 self.rageDamage = data.data
		 	 self.rageChang = true
		 end -- if end
		end

		
	end
	--是否有伤害（伤害：hp，rage）
	function BattleBuffDamage:hasDamage()
		
		return self.hpChange ~= false or self.rageChang ~= false
	end
	-- 获取伤害动画名称（这个数据不在reset时初始化是怕集中的io导致崩溃）
	function BattleBuffDamage:getDamageAnimationName()
		return "buff伤害动画名称"
	end

	--des:获取动画挂点（这个数据不在reset时初始化是怕集中的io导致崩溃）
	function BattleBuffDamage:addPostionType( )
		
		return 1 -- 挂点
	end
	--buff伤害时间（回合前，中后）
	function BattleBuffDamage:buffDamamageTime(id)
		
	end
	--buff添加时间 （回合前，中后）
	function BattleBuffDamage:buffAddTime(id)
		
	end

	-- --buff删除时间 buff先删
	-- function BattleBuffDamage:buffRemoveTime(id)
	-- 	
	-- end
return BattleBuffDamage