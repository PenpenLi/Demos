-- 英雄buff数据
local BattleObjectBuffData = class("BattleObjectBuffData")
 
	------------------ properties ----------------------
	BattleObjectBuffData.buffList 					= nil -- 英雄buff列表


	------------------ functions -----------------------
	function BattleObjectBuffData:ctor( )
		self.buffList							= {}
	end
	function BattleObjectBuffData:add( buffid )

		if(self.buffList[buffid]== nil) then
			self.buffList[buffid] 					= self:getNewBuffObj()
		end

		self.buffList[buffid].count 				= self.buffList[buffid].count + 1
		--print("BattleObjectBuffData add buff:",buffid," count:",self.buffList[buffid].count)
	end
	function BattleObjectBuffData:hasBuff( buffid )

		return self.buffList[buffid] ~= nil 
	end

	function BattleObjectBuffData:getBuffCount( id )
		local buff  				 = self.buffList[id]
		if(buff) then
			return buff.count
		end -- if end
	end

	function BattleObjectBuffData:getBuff( id )
		return self.buffList[id]
	end
	function BattleObjectBuffData:remove( buffid )

		-- 如果计数达到删除条件
		if(self.buffList and self.buffList[buffid]) then

			if(self.buffList[buffid].count <= 1) then
				self.buffList[buffid]					= nil
			else
				self.buffList[buffid].count				= self.buffList[buffid].count - 1
			end
		else
			--print("BattleObjectBuffData:remove:",buffid,
				  -- " self.buffList:",self.buffList,
				  -- " self.buffList[buffid]:",self.buffList[buffid]," is nill")
		end

	end

	function BattleObjectBuffData:getNewBuffObj( buffid )

		local obj 									= {}
		obj.id 										= buffid
		obj.count 									= 0
		return obj
	end

	-- function BattleObjectBuffData:init( )
 
	-- end

return BattleObjectBuffData