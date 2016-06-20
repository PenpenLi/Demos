
require (BATTLE_CLASS_NAME.class)
-- 船体(左右对称)
local BattleShipBodyDisplay = class("BattleShipBodyDisplay",function() return CCNode:create() end)
	BattleShipBodyDisplay.shipImgURL = nil
	BattleShipBodyDisplay.flip = nil -- 炮的基础旋转,因为有的船炮上来就有180反向旋转
	BattleShipBodyDisplay.left 	= nil
	BattleShipBodyDisplay.right = nil
	function BattleShipBodyDisplay:reset( shipImg ,flip)
		
		self.flip = flip or false

		self.shipImgURL = shipImg
		self.baseRoation = rotaion

		-- print("BattleShipBodyDisplay 1",shipImg)
		self.left = CCSprite:create(self.shipImgURL)
		self.left:setAnchorPoint(ccp(1,0.5))
		-- self.left:setPosition(-self.left:getContentSize().width/2,0)
		
		-- self.left:setAnchorPoint(ccp(1,0.5))

		-- print("BattleShipBodyDisplay 2")
		self.right = CCSprite:create(self.shipImgURL)
		self.right:setScaleX(-1)
		self.right:setAnchorPoint(ccp(0,0.5))
		self.right:setPosition(self.right:getContentSize().width,0)
		-- print("BattleShipBodyDisplay 3")
		-- self.left:setFlipX(self.flip)
		-- self.right:setFlipX(self.flip)
		if(self.flip == true) then
			self:setScaleY(-1)
		else
			self:setScaleY(1)
		end
		-- print("BattleShipBodyDisplay 4")
		self:addChild(self.left)
		self:addChild(self.right)
	end
function BattleShipBodyDisplay:getHeight( ... )
	if(self.left and self.left:getContentSize()~= nil) then
		return self.left:getContentSize().height
	end
	return 0
end
return BattleShipBodyDisplay