

-- 卡牌上怒怒气豆(图片) 怒气小于4时用
local Battle4XRageBackImages = class("Battle4XRageBackImages",function () return CCBatchNode:create() end)

function Battle4XRageBackImages:reset(size)
	self.x4Blanks 	= {}
			local cache 	 	= CCSpriteFrameCache:sharedSpriteFrameCache()
 			--注册,以便释放
			cache:addSpriteFramesWithFile(BATTLE_CONST.RAGE_OVER_FOUR_4x_PLIST, BATTLE_CONST.RAGE_OVER_FOUR_4x_TEXTURE)
			local x4Positions = BATTLE_CONST.UI_X4_CARD_RAGE_DOT_X_POS 
		for i=1,4 do
				-- blank:setFrameByName("over_four_4x_blank.png")
				local frameName     = "over_four_4x_blank.png"
				local frameData  	= cache:spriteFrameByName(frameName)
				if(frameData ~= nil) then
					local blank = CCSprite:create()
		 		    blank:setDisplayFrame(frameData)
		 		    table.insert(self.x4Blanks,blank)
					self:addChild(blank)
					blank:setPosition(size.width *  x4Positions[i],size.height * BATTLE_CONST.UI_X4_RAGE_DOT_Y_POS)
		 		else
		 			 Logger.debug("BattleHeroRageImageBar can not find :" .. frameName)
				end

				 
 		end
end

function Battle4XRageBackImages:releaseUI( ... )
		self:removeFromParentAndCleanup(true)
		self.x4Blanks = {}
end
return Battle4XRageBackImages