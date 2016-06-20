



local BattleInfoUI = class("BattleInfoUI")
 
	------------------ properties ----------------------
	-- 掉落物品
	BattleInfoUI.itemIcon					= nil
	BattleInfoUI.itemNum					= nil
	BattleInfoUI.itemBG						= nil

	-- -- 英雄碎片
	-- BattleInfoUI.heroPartIcon				= nil
	-- BattleInfoUI.heroPartNum				= nil

	-- -- 钱信息
	-- BattleInfoUI.moneyIcon					= nil
	-- BattleInfoUI.moneyNum					= nil

	-- 回合数信息
	BattleInfoUI.roundIcon					= nil
	BattleInfoUI.roundNum					= nil

	--容器
	BattleInfoUI.battleUperLayer			= nil

	-- -- 总贝里数
	-- BattleInfoUI.money 						= nil

	-- 总魂
	BattleInfoUI.totalItemNum 						= nil

	-- 总资源
	BattleInfoUI.totalHeroPartNum 					= nil

 
	------------------ functions -----------------------
	function BattleInfoUI:setString(target,value)
		if(target and value ~= nil) then
			target:setString(value)
		end
	end
	-- 刷新回合数据
	function BattleInfoUI:refreshRoundInfo(value)
		if(self.roundNum and value ~= nil) then
			if(BattleMainData.maxRound ~= nil) then
				
				if(self.roundNum:getVisible() == false) then 
					self.roundNum:setVisible(true)
				end

				self.roundNum:setString( value .. "/" .. BattleMainData.maxRound)
			else
				self.roundNum:setVisible(false)
				-- self.roundNum:setString( value .. "/" .. BATTLE_CONST.MAX_ROUND)
			end
		end
	end

 
 

	-- 刷新 数据
	function BattleInfoUI:addItemNum(value)
		if(value ~= nil) then
			self.totalItemNum = self.totalItemNum + tonumber(value)
			self.itemNum:setString(self.totalItemNum)
			-- self.heroPartNum:setString(self.battletotalItemNumLabel,self.totalItemNum)
		end
	end

	-- 刷新 数据
	function BattleInfoUI:setItemNum(value)
		if(value ~= nil and self.totalItemNum ~= value) then
			self.totalItemNum = tonumber(value)
			self.itemNum:setString(self.totalItemNum)
			-- self.heroPartNum:setString(self.battletotalItemNumLabel,self.totalItemNum)
		end
	end


	-- function BattleInfoUI:setHeroPartNum( data )
	-- 	if(value ~= nil and self.totalHeroPartNum ~= value) then
	-- 		self.totalHeroPartNum =  tonumber(value)
	-- 		self.heroPartNum:setString(self.money)
	-- 	end
	-- end

	-- -- 刷新 数据
	-- function BattleInfoUI:addHeroPartNum(value)
	-- 	if(value ~= nil) then
	-- 		self.totalHeroPartNum = self.totalHeroPartNum + tonumber(value)
	-- 		self.heroPartNum:setString(self.totalHeroPartNum)
			
	-- 	end
	-- end

	-- 重置显示
	function BattleInfoUI:reset()
		self.totalItemNum = 0
		self.totalHeroPartNum = 0

		self:refreshRoundInfo(0)
		
		self:setString(self.heroPartNum,self.totalItemNum)
		self:setString(self.itemNum,self.totalHeroPartNum)
		-- self:setString(self.moneyNum,self.money)
	end

	function BattleInfoUI:create()

		self.totalItemNum 				= 0
		self.totalHeroPartNum 			= 0

		local IMG_PATH =  "images/battle/"
		-- 这里可以节省drawcall -.- 不过木有性能瓶颈,暂时不弄了
	 	-- self.battleUperLayer 	= CCBatchNode:create()
	 	-- self.battleUperLayer 	= CCSprite:create()
	 	self.battleUperLayer 	= CCSpriteBatchNode:create(IMG_PATH.. "icon/" .."battleUI.png")
	 	local size 				= CCDirector:sharedDirector():getWinSize()
	 	local startX 			= size.width*0.02
    	local intervalX 		= size.width*0.07
    	local labelX 			= size.width*0.05
    	
    	BattleLayerManager.battleUILayer:addChild(self.battleUperLayer)

	     --------------- 回合
	     local className = "script/battle/ui/BattleVisualSpriteFrameContaner"
	     
	     self.roundNum = require(className).new()
	     self.roundNum:ini(self.battleUperLayer,IMG_PATH.. "icon/" .."battleUI.png",IMG_PATH .. "icon/" .."battleUI.plist","battleUI_yellow_")
     	 self.roundNum:setPosition(size.width*0.82,size.height*0.957)
     	 self.roundNum:setString("0")
     	 -- self.roundNum:setVisible(false)
     	  
     	local frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battleUI_turn.png")
 		assert(frameData,"spriteFrame不存在:battleUI_turn.png")
 		self.roundIcon =  CCSprite:create()
		self.roundIcon:setDisplayFrame(frameData)
		self.roundIcon:setCascadeOpacityEnabled(true)
	  	self.battleUperLayer:addChild(self.roundIcon)
	  	self.roundIcon:setAnchorPoint(CCP_ZERO)
	  	self.roundIcon:setPosition(size.width*0.71,size.height*0.957)


	  	------------------------------------------------------------
	 --  	frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battleUI_card.png")
 	-- 	assert(frameData,"spriteFrame不存在:battleUI_card.png")
 	-- 	self.heroPartIcon =  CCSprite:create()
		-- self.heroPartIcon:setDisplayFrame(frameData)
		-- self.heroPartIcon:setCascadeOpacityEnabled(true)
	 --  	self.battleUperLayer:addChild(self.heroPartIcon)
	 --  	self.heroPartIcon:setAnchorPoint(CCP_ZERO)
	 --  	self.heroPartIcon:setPosition(startX,size.height*0.962)

	 --  	self.heroPartNum = require(className).new()
  --    	self.heroPartNum:ini(self.battleUperLayer,IMG_PATH.. "icon/" .."battleUI.png",IMG_PATH .. "icon/" .."battleUI.plist","battleUI_white_")
 	--  	self.heroPartNum:setPosition(self.heroPartIcon:getPositionX() + 42 * g_fScaleX ,size.height*0.968)
 	--  	self.heroPartNum:setString("0")

 	 	------------------------------------------------------------
	 --  	frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battleUI_beili.png")
 	-- 	assert(frameData,"spriteFrame不存在:battleUI_beili.png")
 	-- 	self.moneyIcon =  CCSprite:create()
 	-- 	self.moneyIcon:setAnchorPoint(CCP_ZERO)
		-- self.moneyIcon:setDisplayFrame(frameData)
		-- self.moneyIcon:setCascadeOpacityEnabled(true)
	 --  	self.battleUperLayer:addChild(self.moneyIcon)
	 --  	self.moneyIcon:setPosition(self.heroPartIcon:getPositionX() + self.heroPartIcon:getContentSize().width + 20 * g_fScaleX,size.height*0.962)

	 --  	self.moneyNum = require(className).new()
  --    	self.moneyNum:ini(self.battleUperLayer,IMG_PATH.. "icon/" .."battleUI.png",IMG_PATH .. "icon/" .."battleUI.plist","battleUI_white_")
 	--  	self.moneyNum:setPosition(self.moneyIcon:getPositionX() + 45 * g_fScaleX ,size.height*0.968)
 	--  	self.moneyNum:setString("0")

 	 	------------------------------------------------------------



		frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battleUI_chest_bg.png")
 		assert(frameData,"spriteFrame不存在:battleUI_chest_bg.png")
 		self.itemBG =  CCSprite:create()
 		self.itemBG:setAnchorPoint(CCP_ZERO)
		self.itemBG:setDisplayFrame(frameData)
		self.itemBG:setCascadeOpacityEnabled(true)
	  	self.battleUperLayer:addChild(self.itemBG)
	  	self.itemBG:setPosition(4 * g_fScaleX, size.height*0.945)

	  	frameData  	= CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battleUI_chest.png")
 		assert(frameData,"spriteFrame不存在:battleUI_stone.png")
 		self.itemIcon =  CCSprite:create()
 		self.itemIcon:setAnchorPoint(CCP_ZERO)
		self.itemIcon:setDisplayFrame(frameData)
		self.itemIcon:setCascadeOpacityEnabled(true)
	  	self.battleUperLayer:addChild(self.itemIcon)
	  	self.itemIcon:setPosition(7 * g_fScaleX,  size.height*0.953)





	  	self.itemNum = require(className).new()
     	self.itemNum:ini(self.battleUperLayer,IMG_PATH.. "icon/" .."battleUI.png",IMG_PATH .. "icon/" .."battleUI.plist","battleUI_white_")
 	 	self.itemNum:setPosition(86 * g_fScaleX, size.height*0.963)
 	 	self.itemNum:setString("0")


	end
return BattleInfoUI
