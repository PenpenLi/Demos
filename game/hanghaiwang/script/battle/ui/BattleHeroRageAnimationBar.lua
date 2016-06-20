


-- 卡牌上怒怒气豆(动画) 怒气等于4时用(ios)
local BattleHeroRageAnimationBar = class("BattleHeroRageAnimationBar",function () return CCBatchNode:create() end)
 
	------------------ properties ----------------------
	BattleHeroRageAnimationBar.animationslist 	= nil 
	BattleHeroRageAnimationBar.isBig			= nil
	BattleHeroRageAnimationBar.isSuper			= nil
	-- BattleHeroRageAnimationBar.smallPostion 	= {0.0445,0.155,0.267,0.378}
	BattleHeroRageAnimationBar.smallPostion 	= BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_X_POS
	BattleHeroRageAnimationBar.bigPostion 		= BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_X_POS
	BattleHeroRageAnimationBar.superPostion 	= BATTLE_CONST.UI_X3_CARD_RAGE_DOT_X_POS
	BattleHeroRageAnimationBar.x4Postion 		= BATTLE_CONST.UI_X4_CARD_RAGE_DOT_X_POS

	-- BattleHeroRageAnimationBar.smallPostion 	= {0.0518,0.163,0.274,0.385}
	-- BattleHeroRageAnimationBar.bigPostion 		= {0,0.13,0.26,0.39}
	-- BattleHeroRageAnimationBar.superPostion 	= {0.085,0.185,0.285,0.385}
	-- BattleHeroRageAnimationBar.x4Postion 		= {0.085,0.185,0.285,0.385}

	BattleHeroRageAnimationBar.psize 			= nil
	------------------ functions -----------------------
	function BattleHeroRageAnimationBar:ctor( ... )
		self.animationslist = {}
		self:setAnchorPoint(CCP_ZERO)
	end
	function BattleHeroRageAnimationBar:reset( isBig ,size ,isSuper,isOutline)
		self:removeAll()
		self.isBig 			 		= isBig or false
		self.isSuper 				= isSuper or false
		self.isOutline 				= isOutline or false

		local shineAnimation
		if(self.isOutline) then
			shineAnimation 			= BATTLE_CONST.RAGE_SHINE_ANI_OUTLINE
		elseif(self.isSuper) then
			shineAnimation 			= BATTLE_CONST.RAGE_SHINE_ANI_SUPER
		elseif(self.isBig) then
			shineAnimation 			= BATTLE_CONST.RAGE_SHINE_ANI_BIG
		else
			shineAnimation 			= BATTLE_CONST.RAGE_SHINE_ANI
		end

		-- 检测怒气动画是否存在
		local hasAnimation,imageURL,plistURL,url = ObjectTool.checkAnimation(shineAnimation)
		if(hasAnimation) then
			  for i=1,4 do
			  	  animation = ObjectTool.getAnimation(shineAnimation,true)
				 
		          animation:getAnimation():playWithIndex(0,-1,-1,1)
		          self:addChild(animation)
		          -- animation:setAnchorPoint(CCP_ZERO)
		          if(self.isOutline) then
		          	animation:setPosition(size.width * self.x4Postion[i],size.height * BATTLE_CONST.UI_X4_RAGE_DOT_Y_POS)
		          elseif(self.isSuper) then
		          	animation:setPosition(size.width * self.superPostion[i],size.height * BATTLE_CONST.UI_X3_CARD_RAGE_DOT_Y_POS)
		          elseif(self.isBig) then
		          	-- animation:setPosition(2+ (i-1) * 14,3)
		          	animation:setPosition(size.width * self.bigPostion[i],size.height * BATTLE_CONST.UI_BIG_CARD_RAGE_DOT_Y_POS)
		          else
		          	-- animation:setPosition(size.width * self.smallPostion[i],-25)
		          	animation:setPosition(size.width * self.smallPostion[i],size.height * BATTLE_CONST.UI_SMALL_CARD_RAGE_DOT_Y_POS)
		          end
		          -- Logger.debug("BattleHeroRageAnimationBar:" .. (22/2.6 + 21 * (i - 1)) .. "," .. (25/2 + 2))
		          table.insert(self.animationslist,animation)
		       end -- for end
        end
	end

	function BattleHeroRageAnimationBar:setValue( value )
		
	end


	function BattleHeroRageAnimationBar:removeAll( ... )
		for k,v in pairs(self.animationslist) do
			v:removeFromParentAndCleanup(true)
		end
		self.animationslist = {}
	end
	function BattleHeroRageAnimationBar:releaseUI( ... )
		self:removeAll()
		self:removeFromParentAndCleanup(true)
	end
return BattleHeroRageAnimationBar