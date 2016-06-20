-- 船的显示类
require (BATTLE_CLASS_NAME.class)
local BattleShipDisplay = class("BattleShipDisplay",function() return CCSprite:create() end)


	BattleShipDisplay.shipBody = nil -- 船体
	BattleShipDisplay.shipGun = nil -- 船炮
	BattleShipDisplay.actionRunner = nil  
	BattleShipDisplay.fireLinkNode = nil -- 开火的挂点
	function BattleShipDisplay:reset( shipBodyImg,shipGunName ,flip ,teamid)
		
		self.teamid = teamid
		-- print("ship 1")
		self.shipBody = require(BATTLE_CLASS_NAME.BattleShipBodyDisplay).new()
		self.shipGun = require(BATTLE_CLASS_NAME.BattleShipGunDisplay).new()
		-- print("ship 2")
		self:addChild(self.shipBody)
		self:addChild(self.shipGun)

		-- print("ship 3",shipBodyImg)
		self.shipBody:reset(shipBodyImg,flip)
		-- print("ship 4",shipGunImg)


		-- [todo] 偏移量问题
		-- todo 从db中读取炮台挂点
		local px = 110
		-- if(self.teamid == BATTLE_CONST.TEAM2) then
		-- if(flip) then
		-- 	px= -1*px
		-- end
		self.shipGun:reset(shipGunName,flip,px)

		
		
		-- if(self.actionRunner == nil) then
		-- 	self.actionRunner				= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		-- end
	end

	function BattleShipDisplay:getGunLinkEffPos( ... )
		if(self.shipGun) then
			-- print("-- BattleShipDisplay:getGunLinkEffPos:",self:getPositionX(),self:getPositionY())
			local gp = self.shipGun:getGunLinkEffPos()
			print("-- BattleShipDisplay:getGunLinkEffPos:",self:getPositionX(),self:getPositionY(),gp.x,gp.y)

		
		

			return self.shipGun:getGunLinkEffPos()--self.shipGun:getGunLinkEffPos()
		end
	end

	function BattleShipDisplay:getBodyHeight( ... )
		if(self.shipBody and self.shipBody:getHeight() ~= nil) then
			print("== BattleShipDisplay:getBodyHeight:",self.shipBody:getHeight() )
			return self.shipBody:getHeight()
		end
		return 0
	end
	 
	function BattleShipDisplay:playAnimation( animationName,completeCall)
		if(self.shipGun) then
			print("-- BattleShipDisplay:playAnimation:",animationName)
			self.shipGun:playAnimation( animationName,completeCall )
		else
			if(completeCall~= nil) then
				completeCall()
				completeCall = nil
			end
		end
	end

	-- 船炮旋转瞄准
	function BattleShipDisplay:playFireAnimation(completeCall)
		if(self.shipGun) then
			self.shipGun:playFireAnimation(completeCall)
		end
	end

	function BattleShipDisplay:globalCenterPoint()

		return self:getGunLinkEffPos()
	end

	function BattleShipDisplay:isIdle()
		return true
	end



return BattleShipDisplay
