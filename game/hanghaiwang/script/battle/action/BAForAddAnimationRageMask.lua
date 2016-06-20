


-- 添加怒气遮罩
require (BATTLE_CLASS_NAME.class)
local BAForAddAnimationRageMask = class("BAForAddAnimationRageMask",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	-- BAForAddAnimationRageMask.animation 		= nil
	BAForAddAnimationRageMask.rageMaskName 		= nil
	------------------ functions -----------------------
 	function BAForAddAnimationRageMask:start()

 		if(
			BattleLayerManager.battlePlayerLayer and 
			BattleLayerManager.battlePlayerLayer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG)
		  ) then
			 
			BattleLayerManager.battlePlayerLayer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
		end
		
		if(self.rageMaskName) then



			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.rageMaskName)
 			if(filesExists == true) then 

 					local animation = ObjectTool.getAnimation(self.rageMaskName,false)
 					local postion = BattleGridPostion.getCenterScreenPostion()
	  				-- self.animation:setScale(BATTLE_CONST.ANIMATION_SCALE)
	  				-- --print("BAForPlayEffectAtHero:start animation:3")
	  				
	  				animation:setScaleX(g_fScaleX)
	  				animation:setScaleY(g_fScaleY)
	  				
					BattleLayerManager.battlePlayerLayer:addChild(animation,200,BATTLE_CONST.RAGE_MASK_TAG)
					animation:getAnimation():playWithIndex(0,0,-1,1)
	  				animation:setPosition(postion.x,postion.y)
	  			 
	  				 
	  		else
	  			Logger.debug("未发现特效:" .. self.rageMaskName)
	  			-- self:complete()
 			end -- if end



			-- local postion = BattleGridPostion.getCenterScreenPostion()
			-- if(self.animation) then
			-- 	self.animation:release()
			-- 	self.animation = nil
			-- end

			-- self.animation = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
			-- self.animation.container = BattleLayerManager.battlePlayerLayer
			-- self.animation.postionX = postion.x
			-- self.animation.postionY = postion.y

			-- self.animation.animationTag = BATTLE_CONST.RAGE_MASK_TAG
			-- self.animation.animationZ = 0

			-- self.animation.animationName = self.rageMaskName
			-- self.animation:addCallBacker(self,self.onEffectComplete)
			-- self.animation:start()
 
		-- else
			
		end

		self:complete()
	end


	function BAForAddAnimationRageMask:onEffectComplete( ... )
		self:complete()
		self:release()
	end
	function BAForAddAnimationRageMask:release( ... )
		self.super.release(self)

		if(self.animation) then
				self.animation:release()
				self.animation = nil
		end
	end
return BAForAddAnimationRageMask