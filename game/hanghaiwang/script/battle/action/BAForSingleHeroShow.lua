

require (BATTLE_CLASS_NAME.class)
-- 英雄所在位置播放特效,英雄出现
local BAForSingleHeroShow = class("BAForSingleHeroShow",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForSingleHeroShow.targetUI			= nil -- 目标
	BAForSingleHeroShow.animationName		= nil -- 特效名称
	BAForSingleHeroShow.shake				= nil
	BAForSingleHeroShow.shakeTime			= 0.4
	BAForSingleHeroShow.animation 			= nil -- 动画实例
	BAForSingleHeroShow.delay 				= nil
	------------------ functions -----------------------
	function BAForSingleHeroShow:start( ... )

		  if(self.targetUI and self.animationName) then
		  	if(type(self.animationName) == "string") then

				self.animation =  require("script/battle/action/BAForPlayEffectAtHero").new()
				self.animation.heroUI = self.targetUI
				self.animation.atPostion = BATTLE_CONST.POS_MIDDLE
				self.animation.animationName = self.animationName
				self.animation.delay = self.delay
				-- self.animation.downTarget = true
			 	-- self.animation:addCallBacker(self,self.onAnimationComplete)
			 	self.animation:start()
			 	self.totalTime								   = BATTLE_CONST.FRAME_TIME * db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)		-- todo load from db
	 			if(self.totalTime > 10) then
	 				Logger.debug("==== BAForSingleHeroShow time out range:" .. self.totalTime)
	 				self.totalTime = 10
	 			elseif(self.totalTime <= 0) then
	 				self.totalTime = 0.1
	 			end

	 			if(self.delay == nil or tonumber(self.delay) <= 0) then
	 				self.delay = 1
	 			end
	 			 self.targetUI:setVisible(false)
				 -- self.targetUI:setOpacity(0)
				 local setVisible = function ( ... )
				 	self.targetUI:setVisible(true)
				 end

				 local actionArray = CCArray:create()
		     	 actionArray:addObject(CCDelayTime:create(self.totalTime * 0.5 + self.delay * BATTLE_CONST.FRAME_TIME))
		     	 actionArray:addObject(CCCallFunc:create(setVisible))
		     	 actionArray:addObject(CCFadeIn:create(self.totalTime * 1.5))
		     	 local fadeInComplete = function ( ... )
		     	 	self:onAnimationComplete()
		     	 end
		     	 actionArray:addObject(CCCallFunc:create(fadeInComplete))
		     	 self.targetUI.boneBinder:runAction(CCSequence:create(actionArray))

		     	 -- self:onAnimationComplete()


	         -- 如果是1个特效拆分成多个特效(顺序播放)
	         elseif(type(self.animationName) == "table")  then
	         	Logger.debug("show with table")
	         	self.animation =  require("script/battle/action/BAForAnimationsQueue").new()
				self.animation.heroUI = self.targetUI
				self.animation.atPostion = BATTLE_CONST.POS_MIDDLE
				self.animation:setList(self.animationName)
				-- self.animation.downTarget = true
			 	self.animation:addCallBacker(self,self.onAnimationComplete)
			 	self.animation:start()


 
 
	         else
	         	 self:complete()
	         	 return
	         end

	        

	         if(self.shake == true) then
	         		local shakeScreen = require("script/battle/action/BAForShakeScreen").new()
				 	shakeScreen.total = self.shakeTime
				 	shakeScreen:start()
	         end

         else
         	 self:complete()
         end
	end

	function BAForSingleHeroShow:onAnimationComplete( ... )

		-- if(self.targetUI) then
		-- 	 local onShowComplete = function ( ... )
		-- 	 	self:complete()
		-- 	 	self:release()
		-- 	 end
		-- 	 self.targetUI:setVisible(true)
		-- 	 self.targetUI:setOpacity(0)
		-- 	 local actionArray = CCArray:create()
	 --     	 actionArray:addObject(CCFadeIn:create(self.totalTime))
	 --     	 actionArray:addObject(CCCallFunc:create(onShowComplete))
	 --     	 self.targetUI.boneBinder:runAction(CCSequence:create(actionArray))
	 --    else
	    	self:complete()
			self:release()
	    -- end
		 
	end

	function BAForSingleHeroShow:release( ... )
		self.super.release(self)
		self.targetUI = nil

		if(self.animation) then
			self.animation:release()
			self.animation = nil
		end
	end


return BAForSingleHeroShow