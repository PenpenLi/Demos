

-- ship	Object (@f741d19)	
-- 	arrGunBar	[] (@fa2ae71)	
-- 		[0]	Object (@f741cd1)	
-- 			attackSkill	218 [0xda]	
-- 			bid	1	
-- 			level	3	
-- 		length	1	
-- 	sid	2	
-- 	tid	1	
local BattleShipData = class("BattleShipData")
	BattleShipData.shipid 		  	  = nil
	BattleShipData.shipTempleteid 	  = nil
	BattleShipData.shipBodyImage  	  = nil
	BattleShipData.gunsData 		  = nil
	BattleShipData.gunidMap 		  = nil
	BattleShipData.shipDispay 		  = nil
	BattleShipData.teamid	 		  = nil
	BattleShipData.shipProperty 	  = nil
	BattleShipData.infoIcon 	 	  = nil -- 主船信息中主船的icon的url
	function BattleShipData:reset( data , teamid)
		self.teamid = teamid
		if(data) then
			self.shipid 		= data.sid
			self.shipTempleteid = data.tid
			self.infoIcon 		= db_ship_util.getBattleInfoShipImg(self.shipTempleteid)
			
			assert(data.sid,"主船数据没有sid")
			assert(data.tid,"主船数据没有tid")
			self.shipBodyImage 	= "ship_body_0.png"
			self.gunsData = {}
			for i,v in pairs(data.arrGunBar or {}) do
				local gunData = require(BATTLE_CLASS_NAME.BattleShipGunData).new()
				gunData:reset(v)
				table.insert(self.gunsData,gunData)
				-- self.gunsData[gunData.id] = gunData
			end

			self.shipProperty = require(BATTLE_CLASS_NAME.BattleShipPropertyData).new()
			self.shipProperty:reset(data)
		end



	end

	-- function BattleShipData:createShipDisplay()
	-- 	if(self.shipDispay == nil) then
	-- 		self.shipDispay  = require(BATTLE_CLASS_NAME.BattleShipDisplay).new()
	-- 	    BattleLayerManager.battlePlayerLayer:addChild(self.shipDispay)
	-- 	    local filp = self.teamid == BATTLE_CONST.TEAM2
	-- 	    -- self.shipDispay:reset(BattleURLManager.getShipBody(self.shipBodyImage),"ship_skill_01",false)
	-- 	    self.shipDispay:reset(BattleURLManager.getShipBody(self.shipBodyImage),"cannon1",filp,self.teamid)
	-- 	    -- self.shipDispay:reset(BattleURLManager.getShipBody(self.shipBodyImage),self.gunsData[1],filp,self.teamid)
	-- 	    self.shipDispay:setVisble(false)
	-- 	    -- 入场会控制位置信息
		    
	-- 	    -- ship1:setPosition(g_winSize.width/2,-140)
	-- 	end
	-- end

	function BattleShipData:indexGunBySkillid( id )
		if(self.gunsData) then
			return self.gunsData[id]
		end
	end

return BattleShipData