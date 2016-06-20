


local BattleHeroHPBarUI = class("BattleHeroHPBarUI")
 
	------------------ properties ----------------------
	BattleHeroHPBarUI.bg 					= nil -- 背景
	BattleHeroHPBarUI.progress 				= nil -- 进度条
	BattleHeroHPBarUI.width 				= nil  -- hp条
	BattleHeroHPBarUI.total 				= nil -- 总血量
	BattleHeroHPBarUI.isBigCard 			= nil -- 是否是大卡
	BattleHeroHPBarUI.isSuperCard 			= nil -- 是否是超级大卡
	BattleHeroHPBarUI.isOutLine 			= nil -- 是否是无边框

	BattleHeroHPBarUI.smallPostion 			= BATTLE_CONST.UI_X1_HP_BAR_X
	-- BattleHeroHPBarUI.smallPostion 			= {-0.406,-0.497}
	BattleHeroHPBarUI.bigPostion 			= BATTLE_CONST.UI_X2_HP_BAR_X
	BattleHeroHPBarUI.superPostion 			= BATTLE_CONST.UI_X3_HP_BAR_X
	BattleHeroHPBarUI.x4Postion 			= BATTLE_CONST.UI_X4_HP_BAR_X
	------------------ functions -----------------------
	function BattleHeroHPBarUI:ctor(isBigCard,isSuperCard)

		

	end
	
	function BattleHeroHPBarUI:release()
		if(self.bg ) then
          self.bg:removeFromParentAndCleanup(true)
          self.bg = nil
      end

      if(self.progress ) then
          self.progress:removeFromParentAndCleanup(true)
          self.progress = nil
      end

       	self.disposed 	= true
		-- self:removeFromRender()					-- 执行
		-- self.calllerBacker:clearAll()
		-- self.blockBoard	= nil

	end
	function BattleHeroHPBarUI:setVisible( value )
		if(value == nil) then value = false end
		if(self.bg) then
			self.bg:setVisible(value)
		end
	end

	function BattleHeroHPBarUI:setParent( target ,size ,isBigCard,isSuperCard,isOutLine)
		

		self.isSuperCard 				= isSuperCard
    	self.isBigCard 					= isBigCard
 		self.isOutLine					= isOutLine
 		-- self.isSuperCard 				= true
 		-- self.isBigCard 					= false

		-- Logger.debug("hp bar is isBigCard:" .. tostring(isBigCard))
		-- Logger.debug("hp bar is isSuperCard:" .. tostring(isSuperCard))

		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		local bgName = nil
		local progressName = nil
		if(isSuperCard == true) then

			bgName = BATTLE_CONST.HP_BAR_BACK_SUPER
			progressName = BATTLE_CONST.HP_BAR_PROGRESS_SUPER
    		
    		cache:addSpriteFramesWithFile(BATTLE_CONST.HP_BAR_SUPER_PATH, BATTLE_CONST.HP_BAR_SUPER_TEXTURE_PATH)
 			--注册,以便释放
			BattleNodeFactory.registFrameList(BATTLE_CONST.HP_BAR_SUPER_PATH)

		elseif(isBigCard == true) then

			bgName = BATTLE_CONST.HP_BAR_BACK_BIG
			progressName = BATTLE_CONST.HP_BAR_PROGRESS_BIG
    		
    		cache:addSpriteFramesWithFile(BATTLE_CONST.HP_BAR_BIG_PATH, BATTLE_CONST.HP_BAR_BIG_TEXTURE_PATH)
 			--注册,以便释放
			BattleNodeFactory.registFrameList(BATTLE_CONST.HP_BAR_BIG_PATH)
		
		-- if(isBigCard == nil or isBigCard == false) then
		-- 如果是无边框
		elseif(isOutLine == true) then

			bgName = BATTLE_CONST.HP_BAR_BACK_4X
			progressName = BATTLE_CONST.HP_BAR_PROGRESS_4X
    		
    		cache:addSpriteFramesWithFile(BATTLE_CONST.HP_BAR_4X_PATH, BATTLE_CONST.HP_BAR_4X_TEXTURE_PATH)
 			--注册,以便释放
			BattleNodeFactory.registFrameList(BATTLE_CONST.HP_BAR_4X_PATH)
		else	
			bgName = BATTLE_CONST.HP_BAR_BACK_SMALL
			progressName = BATTLE_CONST.HP_BAR_PROGRESS_SMALL

    		
    		cache:addSpriteFramesWithFile(BATTLE_CONST.HP_BAR_PATH, BATTLE_CONST.HP_BAR_TEXTURE_PATH)
    		--注册,以便释放
			BattleNodeFactory.registFrameList(BATTLE_CONST.HP_BAR_PATH)
    	-- else
    		

    	end


    	

		self.bg 						= CCSprite:create()


		-- Logger.debug("hp bar is big:" .. tostring(self.isBigCard))
	
		-- if(self.isBig) then
		-- 	bgName = BATTLE_CONST.HP_BAR_BACK_SMALL
		-- 	progressName = BATTLE_CONST.HP_BAR_PROGRESS_SMALL
		-- else
		-- 	bgName = BATTLE_CONST.HP_BAR_BACK_BIG
		-- 	progressName = BATTLE_CONST.HP_BAR_PROGRESS_BIG
		-- end
		assert(cache:spriteFrameByName(progressName),progressName .. " is not found")
		self.bg:setDisplayFrame(cache:spriteFrameByName(bgName))
		self.bg:setCascadeOpacityEnabled(true)
        self.bg:setCascadeColorEnabled(true)
        
		local frame  					= cache:spriteFrameByName(progressName)
		assert(frame,progressName .. " is not found")
		self.progress 					= CCSprite:create()
		self.progress:setDisplayFrame(frame)
		self.progress:setCascadeOpacityEnabled(true)
        self.progress:setCascadeColorEnabled(true)
		
		self.rawWidth 					= frame:getRect().size.width
		self.rawHeight 					= frame:getRect().size.height
		self.rawX 						= frame:getRect().origin.x
		self.rawY 						= frame:getRect().origin.y
		-- --print("bar rawWidth:",self.rawWidth," rawHeight:",self.rawHeight)
		if(self.width == nil or self.width == 0) then 
			self.width 					= 94
		end


		

		-- target:addChild(self.bg,9998)
		-- target:addChild(self.progress,9999)
		target:addChild(self.bg,4,3)
		target:addChild(self.progress,5,4)
	    local centX = nil
	    -- if(self.isBig == true) then
	    -- 	centX = size.width/2 - self.progress:getContentSize().width/2
	    -- else
	    	centX =  -math.floor(size.width/2 - self.progress:getContentSize().width/2)
	    	-- Logger.debug(" self.progress:getContentSize().width:" .. size.width/2 .. "," .. self.progress:getContentSize().width .. " center:" .. centX)
	    -- end
	    -- target:getContentSize().width/2 - self.progress:getContentSize().width/2
		-- local centX = self.progress:getContentSize().width/2
		local postion = nil
		if(self.isSuperCard) then
			postion = self.superPostion
		elseif(self.isBigCard) then
			postion = self.bigPostion
		elseif(self.isOutLine) then
 			postion = self.x4Postion
		else
			postion = self.smallPostion
		end

		 -- self.bg:setAnchorPoint(ccp(0,0.5))
		 -- self.bg:setPosition(centX,0)
		 -- self.bg:setPosition(-self.progress:getContentSize().width/2,-size.height * .56)
		 self.bg:setPosition(size.width * postion[1],size.height * postion[2])
		 -- self.bg:setPosition(size.width * postion[1],size.height * postion[2] + 4)
		 -- self.progress:getTexture():getContentSize()
		 self.progress:setAnchorPoint(ccp(0,0.5))
		 -- self.progress:setPosition(centX,0)
		 -- Logger.debug("target:getContentSize().height:" .. size.height)]
		 local fixX = self.bg:getContentSize().width - self.progress:getContentSize().width
		 self.progress:setPosition(size.width * (postion[1]) - self.progress:getContentSize().width/2 ,size.height * postion[2])
		 -- self.progress:setPosition(fixX/2 + size.width * postion[1],size.height * postion[2] + 4)
		 -- self.progress:setPosition(-self.progress:getContentSize().width/2,-size.height * .56)
		 -- self.progress:setPosition(centX,target:getContentSize().height * .06)
		 -- self.progress:setPosition(0,-target:getContentSize().height * 0.56)
		 ---self.progress:getContentSize().width/2
		 -- self:setPercent(0.1)
	end

	function BattleHeroHPBarUI:setValue(current,total)
		if(total == nil or current == nil) then
		 	error("BattleHeroHPBarUI:setValue currnet:",currnet," total:",total)
		end
		-- assert(current)
		-- assert(total)
		local percent = current/total
		if(percent > 1) then percent = 1 end
		if(percent < 0) then percent = 0 end
		self:setPercent(percent)
		-- self.progress:setTextureRect(CCRectMake(self.rawX,self.rawY,self.rawWidth * percent,self.rawHeight)
	end
	function BattleHeroHPBarUI:setPercent( percent )
 
		-- local textureSize = self.progress:getTexture():getContentSize()
		if(self.progress) then
			self.progress:setTextureRect(CCRectMake(self.rawX,self.rawY,self.rawWidth * percent,self.rawHeight))
		end
	end
	
return BattleHeroHPBarUI

 -- CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("")