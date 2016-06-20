
-- 卡牌上怒怒气豆(图片) 怒气小于4时用
local BattleHeroRageImageBar = class("BattleHeroRageImageBar",function () return CCSpriteBatchNode:create(BATTLE_CONST.RAGE_DOT_IMG) end)
 
	------------------ properties ----------------------
	BattleHeroRageImageBar.icons 		= nil
	BattleHeroRageImageBar.isBig		= nil
	BattleHeroRageImageBar.isSuper 		= nil
	BattleHeroRageImageBar.isOutline 	= nil
	BattleHeroRageImageBar.iconNumber 	= 4

	-- BattleHeroRageImageBar.smallPositions 	= {0.0518,0.163,0.274,0.385}
	-- BattleHeroRageImageBar.bigPositions   	= {0,0.13,0.26,0.39}
	-- BattleHeroRageImageBar.superPositions 	= {0.085,0.185,0.285,0.385}
	-- BattleHeroRageImageBar.x4Positions	 	= {0.085,0.185,0.285,0.385} --{0.205,0.305,0.405,0.505}

 	BattleHeroRageImageBar.x4Blanks 	= nil

	BattleHeroRageImageBar.smallPositions 	= BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_X_POS 
	-- BattleHeroRageImageBar.smallPositions 	= {0.0518,0.163,0.274,0.385} 
	BattleHeroRageImageBar.bigPositions   	= BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_X_POS--{-0.348,-0.227,-0.126,-0.025}
	BattleHeroRageImageBar.superPositions 	= BATTLE_CONST.UI_X3_CARD_RAGE_DOT_X_POS
	BattleHeroRageImageBar.x4Positions	 	= BATTLE_CONST.UI_X4_CARD_RAGE_DOT_X_POS --{0.205,0.305,0.405,0.505}
	------------------ functions -----------------------
	function BattleHeroRageImageBar:ctor( ... )
		self.icons = {}
		self.x4Blanks = {}
		self:setAnchorPoint(CCP_ZERO)
	end
	function BattleHeroRageImageBar:reset( isBig, size , isSuper , isOutline)
		
		self:removeIcons()
		self.isBig 						= isBig or false
		self.isSuper 					= isSuper or false
		self.isOutline 					= isOutline or false
		
		local iconName
		if(self.isOutline) then
			iconName 					= BATTLE_CONST.RAGE_DOT_IMG_4X
		elseif(self.isSuper) then
			iconName 					= BATTLE_CONST.RAGE_DOT_IMG_SUPER
		elseif(self.isBig) then
			iconName 					= BATTLE_CONST.RAGE_DOT_IMG_BIG
		else
			iconName 					= BATTLE_CONST.RAGE_DOT_IMG
		end

		local text = CCTextureCache:sharedTextureCache():addImage(iconName)
		self:setTexture(text)
		--注册,以便释放
		BattleNodeFactory.regeistTextureURL(iconName)
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		for i=1,self.iconNumber do
	 			local icon				= CCSprite:create(iconName)
	 			-- icon:setVisible(false)
	 			icon:setCascadeOpacityEnabled(true)
	      		icon:setCascadeColorEnabled(true)

	 			table.insert(self.icons,icon)

	 			self:addChild(icon)
	 			-- icon:setAnchorPoint(ccp(0.5,0))
	 			-- print("==== isOutline",self.isOutline)
	 			node = tolua.cast(icon,"CCNode")
	 			if(self.isOutline) then

	 				

	 				node:setPosition( size.width * self.x4Positions[i],size.height * BATTLE_CONST.UI_X4_RAGE_DOT_Y_POS)
	 				
					-- blank:setFrameByName("over_four_4x_blank.png")
					-- local frameName     = "over_four_4x_blank.png"

					-- local cache 	 	= CCSpriteFrameCache:sharedSpriteFrameCache()
					-- cache:addSpriteFramesWithFile(BATTLE_CONST.RAGE_OVER_FOUR_4x_PLIST, BATTLE_CONST.RAGE_OVER_FOUR_4x_TEXTURE)
			 	-- 		--注册,以便释放
					-- BattleNodeFactory.registFrameList(BATTLE_CONST.RAGE_OVER_FOUR_4x_TEXTURE)

					-- local frameData  	= cache:spriteFrameByName(frameName)
					-- if(frameData ~= nil) then
					-- 	local blank = CCSprite:create()
			 	-- 	    blank:setDisplayFrame(frameData)
			 	-- 	    table.insert(self.x4Blanks,blank)
					-- 	self:addChild(blank)
					-- 	blank:setPosition(size.width * self.x4Positions[i],size.height * BATTLE_CONST.UI_X4_RAGE_DOT_Y_POS)
						

			 	-- 	else
			 	-- 		 Logger.debug("BattleHeroRageImageBar can not find :" .. frameName)
					-- end

					
	 				-- node:setPosition( size.width/2 + ( i - 1) * 33,-55)
	 			elseif(self.isSuper) then
	 				node:setPosition(size.width * self.superPositions[i],size.height * BATTLE_CONST.UI_X3_CARD_RAGE_DOT_Y_POS)
	 			elseif(self.isBig) then
					-- node:setPosition(15 * (i - 1),1)
					node:setPosition(size.width * self.bigPositions[i],size.height * BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_Y_POS)
					
				else
					
					-- node:setPosition(node:getContentSize().width/2.6 + 21 * (i - 1),node:getContentSize().height/2 + 2)
					-- node:setPosition(size.width * self.smallPositions[i],-25)
					node:setPosition(size.width * self.smallPositions[i],size.height * BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_Y_POS)
					
				end
 		end
	end	

	function BattleHeroRageImageBar:setValue( value )
		-- value = self.iconNumber
		for i=1,self.iconNumber do
		        local icon        = self.icons[i]
		        if(i <= value) then
		          icon:setVisible(true)
		          -- icon:setPosition(14 * (i - 1),0)
		          -- print("icon:setVisible true")
		        else
		        	 -- print("icon:setVisible false")
		          icon:setVisible(false)
		        end
      	end
	end
	
	function BattleHeroRageImageBar:removeIcons( ... )
		for k,icon in pairs(self.icons) do
			icon:removeFromParentAndCleanup(true)
		end
		for k,icon in pairs(self.x4Blanks) do
			icon:removeFromParentAndCleanup(true)
		end

		self.icons = {}
		self.x4Blanks = {}
	end
	function BattleHeroRageImageBar:releaseUI( ... )
		self:removeIcons()
		self:removeFromParentAndCleanup(true)
	end
return BattleHeroRageImageBar