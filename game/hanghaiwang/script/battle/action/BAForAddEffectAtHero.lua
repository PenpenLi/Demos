



-- 在英雄身上添加特效(播完不删除)

require (BATTLE_CLASS_NAME.class)
local BAForAddEffectAtHero = class("BAForAddEffectAtHero",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForAddEffectAtHero.heroUI					= nil	-- 目标(BattleObjectDisplay)
	BAForAddEffectAtHero.atPostion 				= nil   -- 人物身上的挂点
	BAForAddEffectAtHero.animation 				= nil 	-- 动画实例
	BAForAddEffectAtHero.animationName 			= nil 	-- 动画名称
 
	------------------ functions -----------------------

 

	function BAForAddEffectAtHero:start(data)
	 
		if(self.heroUI~= nil and self.heroUI:isOnStage() == true and self.animationName ~= nil  ) then
			-- todo 其他挂点,目前只做了中点
			-- local postion  							= self.heroUI:globalCenterPoint()
			-- local url 								= BattleURLManager.getAttackEffectURL(self.animationName)
			
			-- self.animation = require(BATTLE_CLASS_NAME.BattleAnimation).new()
			self.animation = ObjectTool.getAnimation(self.animationName,true)
			-- self.animation:setAnchorPoint(ccp(0.5, 0.5));
			-- self.animation:retain()
			-- self.animation:setPosition(postion.x,postion.y);
			if(self.animation) then
				self.heroUI:addExtEffectAt(self.animation,BATTLE_CONST.POS_MIDDLE)
				-- self.animation:createAnimation(self.animationName,true)
				self.animation = nil
			end
		end

		self:complete()
 	end

 	-- 释放函数
	function BAForAddEffectAtHero:release(data)
		
		ObjectTool.removeObject(self.animation)
		self.super.release(self)
		 
		self.animationName 				= nil
		self.heroUI 					= nil
	end 



return BAForAddEffectAtHero