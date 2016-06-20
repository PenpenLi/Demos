

local BattleShipPropertyData = class("BattleShipPropertyData")
	BattleShipPropertyData.shipid 		  	  = nil
	BattleShipPropertyData.MAGIC_ATK 		  = nil
	BattleShipPropertyData.MAGIC_DEF 		  = nil
	BattleShipPropertyData.HP 		  		  = nil
	BattleShipPropertyData.PHY_ATK	 		  = nil
	BattleShipPropertyData.PHY_DEF	 		  = nil
	-- <affix id="1" displayName="生命" sigleName="生命" type="1"/>
 --  <affix id="2" displayName="物攻" sigleName="物攻" type="1"/>
 --  <affix id="3" displayName="魔攻" sigleName="魔攻" type="1"/>
 --  <affix id="4" displayName="物防" sigleName="物防" type="1"/>
 --  <affix id="5" displayName="魔防" sigleName="魔防" type="1"/>

	function BattleShipPropertyData:reset(data)
		-- self.teamid = teamid
		if(data) then
			self.shipid 		= data.sid
			assert(data.sid,"主船数据没有sid")
			-- self.attr  			= data.addAttr
			assert(data.addAttr,"主船数据没有addAttr")
			for pName,pValue in pairs(data.addAttr or {}) do
				print("  BattleShipPropertyData:reset:",pName,pValue)
				if(type(pName) == "number" or string.len(tostring(pName)) == 1) then
					if(tostring(pName) == "1") then
						self.HP = tostring(pValue)
					elseif(tostring(pName) == "2") then
						self.PHY_ATK = tostring(pValue)
					elseif(tostring(pName) == "3") then
						self.MAGIC_ATK = tostring(pValue)
					elseif(tostring(pName) == "4") then
						self.PHY_DEF = tostring(pValue)
					elseif(tostring(pName) == "5") then
						self.MAGIC_DEF = tostring(pValue)
					end
				-- else
				-- 	self.HP = ""
				-- 	self.PHY_ATK = ""
				-- 	self.MAGIC_ATK = ""
				-- 	self.PHY_DEF = ""
				-- 	self.MAGIC_DEF = ""
				end
			end
		end

	end

	return BattleShipPropertyData