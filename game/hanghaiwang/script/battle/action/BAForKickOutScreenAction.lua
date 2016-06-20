-- 踢出屏幕
require (BATTLE_CLASS_NAME.class)
local BAForKickOutScreenAction = class("BAForKickOutScreenAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForKickOutScreenAction.targetData 			= nil -- 目标数据
	BAForKickOutScreenAction.dx 					= nil
	BAForKickOutScreenAction.dy 					= nil 
	-- BAForKickOutScreenAction.scale
	BAForKickOutScreenAction.total					= nil
	BAForKickOutScreenAction.current 				= nil
	BAForKickOutScreenAction.toPostion 				= nil
	-- BAForKickOutScreenAction.scaleTo				= nil
	------------------ functions -----------------------
	function BAForKickOutScreenAction:start()
		-- print("-- BAForKickOutScreenAction:start1")
		if(self.targetData ~= nil and self.targetData.displayData ~= nil) then
			local yto = 0
			local feetPostion = self.targetData.displayData:globalFeetPoint()
			-- self.targetData.displayData:setColor(ccc3(250,10,0))
			self.targetData.displayData:setColor(250,10,0)
			if(self.targetData.teamId == BATTLE_CONST.TEAM1) then
				

				yto = - 200 - feetPostion.y 
				-- self.toPostion = {feetPostion.x,}
			else
				yto =  CCDirector:sharedDirector():getWinSize().height - feetPostion.y + 200
				-- self.toPostion = {feetPostion.x,CCDirector:sharedDirector():getWinSize().height + 200}
			end
			local completeCall = function ( ... )
				-- print("-- BAForKickOutScreenAction:complete")
				if(self.targetData and self.targetData.displayData) then
					self.targetData.displayData:die()
					self.targetData.displayData:toRawPosition()
				end
				
				self:onComplete()
			end
			local BARotation     = require ("script/battle/action/ccActions/BARotationXBy")
			local BACall         = require ("script/battle/action/ccActions/BACall")
			local BAMoveBy       = require ("script/battle/action/ccActions/BAMoveBy")
			local BSSequence 	 = require ("script/battle/action/order/BSSequence")
			local BSSpawn    	 = require ("script/battle/action/order/BSSpawn")
			-- print("-- BAForKickOutScreenAction:start2")
			self.action = BSSequence:new({
					BSSpawn:new({ 
						BARotation:new(14,180,{self.targetData.displayData},true),
						BAMoveBy:new(14,{0,yto},{self.targetData.displayData})
					}),
					BACall:new(completeCall)
				})
			self.action:start()
		else
			self:complete()
		end
	end


	function BAForKickOutScreenAction:release(data)
		print("-- BAForKickOutScreenAction:release")
		self.super.release(self)
		if(self.action) then
			-- self.action:release()
			self.action = nil
		end

	end

	function BAForKickOutScreenAction:onComplete( )
		self:complete()
		self:release()
	end

 
return BAForKickOutScreenAction
