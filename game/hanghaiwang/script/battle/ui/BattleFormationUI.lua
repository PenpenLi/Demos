
-- 战斗配置阵型ui

local BattleFormationUI = class("BattleFormationUI")
 	--,function() return CCSprite:create() end
	------------------ properties ----------------------
	BattleFormationUI.unders 					= nil
	
	------------------ functions -----------------------
	function BattleFormationUI:ctor( ... )
 		
 	end

 	function BattleFormationUI:init( cards ,container)
 		self.unders = {}
 		for k,card in pairs(cards or {}) do
 			-- 获取开启格子
 			require("script/module/formation/FormationUtil")
 			local openSlots = FormationUtil.currentOpendPositions()
 			assert(openSlots,"当前阵型阵型数据错误")

 			for k,open_pos in pairs(openSlots) do
 				 -- 初始化板子
	 			local cardBack = self:getCardBack(open_pos)
	 			
	 			-- 分配闪烁action

	 			-- 
	 			table.insert(self.unders,cardBack)
	 			container:addChild(cardBack)
	 			
	 			local shineAction = CCArray:create()
	            shineAction:addObject(CCFadeOut:create(0.5))
	            shineAction:addObject(CCFadeIn:create(0.5))
	            cardBack:runAction(CCRepeatForever:create(CCSequence:create(shineAction)))
 			end
 			

 		end
 		
 		-- for k,card in pairs(BattleTeamDisplayModule.selfDisplayListByPostion) do
 			
 	
 		
 		-- 开始战斗按钮
 		self.size 			= CCDirector:sharedDirector():getWinSize()
 		self.doBattleButton = CCMenuItemImage:create("images/battle/btn/btn_start_n.png","images/battle/btn/btn_start_d.png")
		self.doBattleButton:setAnchorPoint(CCP_HALF)
		self.doBattleButton:setPosition(self.size.width/2,self.size.height/2)
		
		-- self.doBattleButton:setScale(MainScene.elementScale)
		-- self.doBattleButton:setVisible(false)
    
 		-- 初始化按钮
 		self.menu = CCMenu:create()
		self.menu:setAnchorPoint(CCP_ZERO)
		self.menu:setPosition(0,0)
		-- menu:addChild(battleSpeedButton1)
		-- menu:addChild(battleSpeedButton2)
		-- menu:addChild(battleSpeedButton3)
		self.menu:addChild(self.doBattleButton)
		if(BattleLayerManager.battleUILayer) then
			BattleLayerManager.battleUILayer:addChild(self.menu,0,1299)
		end
		self.menu:setTouchPriority(g_tbTouchPriority.battleMenu)
 	end

 	function BattleFormationUI:getCardBack( postion )
	 	local heroBgSprite = CCSprite:create("images/battle/card/card_bg.png");
	    heroBgSprite:setAnchorPoint(CCP_HALF)
	    local pos = BattleGridPostion.getPlayerPointByIndex(postion)
	    heroBgSprite:setTag(postion)
	    heroBgSprite:setPosition(pos.x ,pos.y)
	    return heroBgSprite
 	end

 	function BattleFormationUI:releaseSelf( ... )
 		--print("BattleFormationUI:release self:",self)
 		for k,sprite in pairs(self.unders or {}) do
 			if(sprite:getParent()) then
 				sprite:removeFromParentAndCleanup(true)
 			end
 		end
 		self.unders = {}

 		if(self.menu) then
 			if(self.menu:getParent()) then
 				self.menu:removeFromParentAndCleanup(true)
 			end
 		end
 		self.menu = nil
 		self.doBattleButton = nil
 	end
return BattleFormationUI