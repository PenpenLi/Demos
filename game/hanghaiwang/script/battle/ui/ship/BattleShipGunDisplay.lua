
-- 船炮
-- 船炮动画的旋转角度只有0和180
-- 枪炮旋转请务必调整BattleShipGunDisplay对象,而不是调整动画
require (BATTLE_CLASS_NAME.class)
local BattleShipGunDisplay = class("BattleShipGunDisplay",function() return CCNode:create() end)
	

	BattleShipGunDisplay.flip = nil -- 炮的基础旋转,因为有的船炮上来就有180反向旋转
	BattleShipGunDisplay.gunAnimation = nil  
	BattleShipGunDisplay.gunAnimationName = nil  
	BattleShipGunDisplay.callBacker = nil
	BattleShipGunDisplay.fireEffLinkNode = nil -- 远程挂点
	function BattleShipGunDisplay:reset( gunAnimationName , flip , py)
		
		self.flip = flip or false
		self.gunAnimationName = gunAnimationName
		self.teamid = teamid

	

		-- print("== BattleShipGunDisplay",gunAnimationName,self.flip)
		
		ObjectTool.removeObject(self.gunAnimation)
		self.gunAnimation = nil
		self.gunAnimation = ObjectTool.getAnimation(gunAnimationName,false)
		assert(self.gunAnimation,"未发现炮口动画:" .. tostring(gunAnimationName))
		if(self.gunAnimation) then
			self:addChild(self.gunAnimation)
			self.fireEffLinkNode = CCNode:create()--CCSprite:create("images/battle/icon/rageSkillBarMask.png")
			self:addChild(self.fireEffLinkNode)
			-- self.gunAnimation:addChild(self.fireEffLinkNode)
			self.fireEffLinkNode:setPositionY(py)
		end


		
		if(self.flip == true) then
			self:setScaleY(-1)
		else
			self:setScaleY(1)
		end
		self:resetState()
		self:resetCallBacker()
	end
	-- 获取该炮炮弹挂点(全局坐标)
	function BattleShipGunDisplay:getGunLinkEffPos( ... )
		if(self.fireEffLinkNode and self.gunAnimation) then
			local xx = self.fireEffLinkNode:convertToWorldSpace(ccp(0,0))
			-- print("--BattleShipGunDisplay:getGunLinkEffPos:",xx.x,xx.y)
			return xx
			-- return ccp(self:getPositionX() + self.fireEffLinkNode:getPositionX(),self:getPositionY() + self.fireEffLinkNode:getPositionY())
			-- print("-- BattleShipGunDisplay:getGunLinkEffPos:",self.fireEffLinkNode:getPositionY())
			-- return self.gunAnimation:convertToWorldSpace(ccp(self.fireEffLinkNode:getPositionX() ,
			-- return self.fireEffLinkNode:convertToWorldSpace(ccp(self.fireEffLinkNode:getPositionX() ,
 															  -- self.fireEffLinkNode:getPositionY() ))
		end
		return ccp(0,0)
	end


	function BattleShipGunDisplay:resetCallBacker( ... )
		
		if(self.callBacker == nil) then
			self.callBacker = require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
		else
			self.callBacker:clearAll()
		end

	end
	-- 重置炮口的原始位置
	function BattleShipGunDisplay:resetState()
		self:setRotation(0)
		if(self.gunAnimation ~= nil) then
			self.gunAnimation:getAnimation():gotoAndPause(1)
			-- self.gunAnimation:setFlipX(self.flip)
		end
	end
	function BattleShipGunDisplay:playAnimation( animationName,callback )
		
		if (animationName) then
			local animation = tolua.cast(self.gunAnimation,"CCArmature")

			local fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if(MovementEventType == EVT_COMPLETE) then
					if(callback ~= nil and ObjectTool.isOnStage(self.gunAnimation) == true) then
						callback()
					end
				end
			end
			print("-- BattleShipGunDisplay:playAnimation:",animationName)
			self.gunAnimation:getAnimation():play(animationName)												
			-- self.gunAnimation:getAnimation():play(animationName,-1, -1,false)
			self.gunAnimation:getAnimation():setMovementEventCallFunc(fnMovementCall)
			-- self.gunAnimation:getAnimation():gotoAndPlay(1)
			-- animation:getAnimation():gotoAndPlay(1)
		end

	end
	function BattleShipGunDisplay:playFireAnimation(callback)
		if(ObjectTool.isOnStage(self.gunAnimation) == true) then
			self.gunAnimation:getAnimation():gotoAndPlay(1)
			local fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if(MovementEventType == EVT_COMPLETE) then
					if(callback ~= nil and ObjectTool.isOnStage(self.gunAnimation) == true) then
						callback()
					end
				end
			end
			self.gunAnimation:getAnimation():setMovementEventCallFunc(fnMovementCall)

		else
			print("== animation is not on sence")
			if(callback ~= nil) then
				callback()
			end
		end
	end

	function BattleShipGunDisplay:releaseUI( ... )
		ObjectTool.removeObject(self.gunAnimation)
		self.gunAnimation = nil
	end


return BattleShipGunDisplay