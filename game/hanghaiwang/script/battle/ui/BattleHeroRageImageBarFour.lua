
-- 卡牌上怒怒气豆(图片) 怒气大于4时
local BattleHeroRageImageBarFour = class("BattleHeroRageImageBarFour",function () return CCSpriteBatchNode:create(BATTLE_CONST.RAGE_OVER_FOUR_TEXTURE) end)
 
	------------------ properties ----------------------
	BattleHeroRageImageBarFour.xSp			= nil
	BattleHeroRageImageBarFour.dotSps		= nil
	BattleHeroRageImageBarFour.bigDotSp		= nil
	BattleHeroRageImageBarFour.numbersSp	= nil
	BattleHeroRageImageBarFour.icons		= nil
	BattleHeroRageImageBarFour.isBig		= nil
	BattleHeroRageImageBarFour.isSuper		= nil
	BattleHeroRageImageBarFour.numberPreName = nil
	
	-- BattleHeroRageImageBarFour.smallPositions  		= {0.047,0.158,0.269,0.38}
	BattleHeroRageImageBarFour.smallPositions  		= BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_X_POS


	BattleHeroRageImageBarFour.bigPosition  		= BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_X_POS
	BattleHeroRageImageBarFour.bigBigDotPosition 	= 0.546
	BattleHeroRageImageBarFour.bigXPosition			= 0.642
	BattleHeroRageImageBarFour.bigNumPosition		= 0.678



	BattleHeroRageImageBarFour.superPosition  		= BATTLE_CONST.UI_X3_CARD_RAGE_DOT_X_POS
	BattleHeroRageImageBarFour.superBigDotPosition 	= 0.526
	BattleHeroRageImageBarFour.superXPosition		= 0.61
	BattleHeroRageImageBarFour.superNumPosition		= 0.648


	BattleHeroRageImageBarFour.x4Position  			= BATTLE_CONST.UI_X4_CARD_RAGE_DOT_X_POS
	BattleHeroRageImageBarFour.x4BigDotPosition 	= 0.526
	BattleHeroRageImageBarFour.x4XPosition			= 0.61
	BattleHeroRageImageBarFour.x4NumPosition		= 0.648


	------------------ functions -----------------------
	function BattleHeroRageImageBarFour:ctor( ... )
		self.dotSps = {}
		self:setAnchorPoint(CCP_ZERO)
		self.isBig = false
	end
	function BattleHeroRageImageBarFour:reset( isBig ,size ,isSuper,isOutline)
		
		self:removeAll()

		self.isBig 			= isBig or false
		self.isSuper 		= isSuper or false
		self.isOutline 		= isOutline or false
		
		local plist,littleDot,littleDot,bigDot,x,textureName
		-- local px,py
		local locations 	= nil
		local bigDotPosition  = nil
		local xPosition  = nil
		local numPosition  = nil
		local yPosition = 0
		local yFix = 0
		if(self.isOutline) then
				plist 		= BATTLE_CONST.RAGE_OVER_FOUR_4x_PLIST
				textureName = BATTLE_CONST.RAGE_OVER_FOUR_4x_TEXTURE
				littleDot 	= BATTLE_CONST.RAGE_OVER_FOUR_LITTLE_DOT_4x
				bigDot 		= BATTLE_CONST.RAGE_OVER_FOUR_BIG_DOT_4x
				x 			= BATTLE_CONST.RAGE_OVER_FOUR_X_4x
				self.numberPreName 	= BATTLE_CONST.RAGE_OVER_FOUR_NUM_PRE_4x
				-- px 			= 4
				-- py 			= 10
				locations   = self.x4Position

				bigDotPosition = BATTLE_CONST.UI_X4_CARD_RAGE_BDOT_POS
				xPosition = BATTLE_CONST.UI_X4_CARD_RAGE_XIMG_POS
				numPosition = BATTLE_CONST.UI_X4_CARD_RAGE_NUMIMG_POS

				yPosition = size.height * BATTLE_CONST.UI_X4_RAGE_DOT_Y_POS
				-- yFix 	  = 5
		elseif(self.isSuper == true) then

				plist 		= BATTLE_CONST.RAGE_OVER_FOUR_SUPER_PLIST
				textureName = BATTLE_CONST.RAGE_OVER_FOUR_SUPER_TEXTURE
				littleDot 	= BATTLE_CONST.RAGE_OVER_FOUR_LITTLE_DOT_SUPER
				bigDot 		= BATTLE_CONST.RAGE_OVER_FOUR_BIG_DOT_SUPER
				x 			= BATTLE_CONST.RAGE_OVER_FOUR_X_SUPER
				self.numberPreName 	= BATTLE_CONST.RAGE_OVER_FOUR_NUM_PRE_SUPER
				-- px 			= 4
				-- py 			= 10
				locations   = self.superPosition

				bigDotPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_BDOT_POS
				xPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_XIMG_POS
				numPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_NUMIMG_POS

				yPosition = size.height * BATTLE_CONST.UI_X3_CARD_RAGE_DOT_Y_POS

		elseif(self.isBig == true) then

				plist 		= BATTLE_CONST.RAGE_OVER_FOUR_BIG_PLIST
				textureName = BATTLE_CONST.RAGE_OVER_FOUR_BIG_TEXTURE
				littleDot 	= BATTLE_CONST.RAGE_OVER_FOUR_LITTLE_DOT_BIG
				bigDot 		= BATTLE_CONST.RAGE_OVER_FOUR_BIG_DOT_BIG
				x 			= BATTLE_CONST.RAGE_OVER_FOUR_X_BIG
				self.numberPreName 	= BATTLE_CONST.RAGE_OVER_FOUR_NUM_PRE_BIG
				-- px 			= 4
				-- py 			= 10
				locations   = self.bigPosition

				bigDotPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_BDOT_POS
				xPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_XIMG_POS
				numPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_NUMIMG_POS

				yPosition = size.height * BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_Y_POS
		else
				plist 		= BATTLE_CONST.RAGE_OVER_FOUR_PLIST
				textureName = BATTLE_CONST.RAGE_OVER_FOUR_TEXTURE
				littleDot 	= BATTLE_CONST.RAGE_OVER_FOUR_LITTLE_DOT
				bigDot 		= BATTLE_CONST.RAGE_OVER_FOUR_BIG_DOT
				x 			= BATTLE_CONST.RAGE_OVER_FOUR_X
				self.numberPreName 	= BATTLE_CONST.RAGE_OVER_FOUR_NUM_PRE
				-- px 			= 0
				-- py 			= 0
				locations   = self.smallPositions

				bigDotPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_BDOT_POS
				xPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_XIMG_POS
				numPosition = BATTLE_CONST.UI_SMALL_CARD_RAGE_NUMIMG_POS
				yPosition = size.height * BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_Y_POS
				yFix = -3
		end
 		-- self:setTexture(textureName)
		local text = CCTextureCache:sharedTextureCache():addImage(textureName)
		self:setTexture(text)

		--注册plist,以便释放
		BattleNodeFactory.registFrameList(plist)
		-- 加载plist及其资源
		local plistCache = CCSpriteFrameCache:sharedSpriteFrameCache()
  		plistCache:addSpriteFramesWithFile(plist)

  		-- local yy    = 1
  		-- local size = nil
		--
		 -- local size = {}
		-- size.width = 22
		-- size.height = 22
		for i=0,3 do
	 			local icon				= require("script/battle/ui/BattleFrameSprite").new()
	 			-- icon:setCascadeOpacityEnabled(true)
	    --   		icon:setCascadeColorEnabled(true)
	      		icon:reset(littleDot)
	 			table.insert(self.dotSps,icon)

	 			self:addChild(icon)
	 			-- icon:setAnchorPoint(CCP_ZERO)

	 			node = tolua.cast(icon,"CCNode")
	 			-- if(size == nil )  then
	 			-- 	size = icon:getContentSize()

	 			-- end
	 			-- yy = size.height/2 + 2
				-- node:setPosition( size.width * 0.55 + size.width * (i) * 1.4 + 1 + px,yy + py)
				node:setPosition( size.width * locations[i + 1],yPosition)
 		end

 		self.bigDotSp	= require("script/battle/ui/BattleFrameSprite").new()
 		self.bigDotSp:reset(bigDot)
 		self:addChild(self.bigDotSp)
	 	-- self.bigDotSp:setAnchorPoint(CCP_ZERO)
	 	self.bigDotSp:setPosition(size.width * bigDotPosition[1],size.height * bigDotPosition[2])

	 	self.xSp	 	= require("script/battle/ui/BattleFrameSprite").new()
 		self.xSp:reset(x)
 		self:addChild(self.xSp)
	 	-- self.xSp:setAnchorPoint(CCP_ZERO)
	 	self.xSp:setPosition(size.width * xPosition[1],size.height * xPosition[2])
	 	-- self.xSp:setPosition(size.width * xPosition,yPosition)


	 	--------------- 回合
	     local className = "script/battle/ui/BattleVisualSpriteFrameContaner"
	     
	     self.numbersSp = require(className).new()
	     self.numbersSp:iniWithSimple(self,self.numberPreName)
     	 -- self.numbersSp:setPosition(size.width * numPosition,yPosition * 1.5 + yFix)
     	 self.numbersSp:setString( tostring(5) )
     	 self.numbersSp:setPosition(size.width * numPosition[1] - self.numbersSp.size.width/2 ,size.height * numPosition[2] - self.numbersSp.size.height/2 + yFix)
	 	-- print("---- size.height:",size.height)
     	 -- self.numbersSp:setString("0/30")


		-- self.numbersSp	= require("script/battle/ui/BattleFrameSprite").new() 
		-- self.numbersSp:setFrameByName(self.numberPreName .. 4 .. ".png")
		-- self:addChild(self.numbersSp)
	 -- 	-- self.numbersSp:setAnchorPoint(CCP_ZERO)
	 -- 	self.numbersSp:setPosition(size.width * numPosition,0)

	end	

	function BattleHeroRageImageBarFour:removeAll( ... )
		-- 这里不释放plist资源,退出战斗模块时会统一释放
		-- 还有就是因为当前ui不知道别的地方是否还用到这个plist涉及的资源
		for k,v in pairs(self.dotSps) do
			 v:removeFromParentAndCleanup(true)
		end
		self.dotSps = {}

		if(self.numbersSp) then
			self.numbersSp:removeFromParentAndCleanup(true)
			self.numbersSp = nil
		end

		if(self.xSp) then
			self.xSp:removeFromParentAndCleanup(true)
			self.xSp = nil
		end

		if(self.bigDotSp) then
			self.bigDotSp:removeFromParentAndCleanup(true)
			self.bigDotSp = nil
		end

	end
	function BattleHeroRageImageBarFour:setValue( value )
 		if(self.numbersSp) then
 			-- self.numbersSp:setFrameByName(self.numberPreName .. value .. ".png")
 			self.numbersSp:setString( tostring(value) )
 		end
	end

	function BattleHeroRageImageBarFour:releaseUI( ... )
		self:removeAll()
		self:removeFromParentAndCleanup(true)
	end
return BattleHeroRageImageBarFour