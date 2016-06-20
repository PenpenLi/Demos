-- 总伤害动画
require (BATTLE_CLASS_NAME.class)
local BAForShowTotalHurtAnimation = class("BAForShowTotalHurtAnimation",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShowTotalHurtAnimation.value 			= nil -- 伤害值
	-- BAForShowTotalHurtAnimation.animation 		= nil -- 动画
	------------------ functions -----------------------
 	function BAForShowTotalHurtAnimation:start()
 		if(self.value ~= nil) then
 			Logger.debug("BAForShowTotalHurtAnimation value:".. tostring(self.value))
 			local numSp = ObjectTool.getRedNumber(self.value,false)

 		
 			-- 获取动画
 			local animation = ObjectTool.getAnimation(
 													   BATTLE_CONST.TOTAL_HURT_ANIMATION_NAME,
 													   false,
 													   nil
 													  )
 				-- 结束回调
 			local completeCall  = function ( sender, MovementEventType )
 				if (MovementEventType == EVT_COMPLETE) then
 					-- 删除动画
 					ObjectTool.removeObject(animation,false)
 					if(self.animation) then
				 		ObjectSharePool.addObject(self.animation,BATTLE_CONST.TOTAL_HURT_ANIMATION_NAME)
				 	end
 					self:complete()
 				end
 			end
 			

 			if(animation== nil) then
 				self:complete()
 				return
 			end

 			animation:getAnimation():setMovementEventCallFunc(completeCall)
 			
 			-- 获取数字骨骼
 			local bone = animation:getBone("total_hurt_num_0")
 			if(bone) then
 				-- -- 生成数字
 				
 				
 				
 				-- 替换骨骼
 				-- local node = tolua.cast(numSp.container,"CCNode")
 				numSp.container:setAnchorPoint(CCP_ZERO)
 				bone:addDisplay(numSp.container,0)
 			-- else
 			-- 	self:complete()
 			else
 				error("total bone \"total_hurt_num_0\" is not find ")
 			-- 	return
 			end
 		

 			-- 添加到屏幕中央
 			BattleLayerManager.battleAnimationLayer:addChild(animation)
 			animation:setPosition(g_winSize.width/2,g_winSize.height/2)
 			-- self:complete()
 		else
 			self:complete()
 		end
 		
		
	end



return BAForShowTotalHurtAnimation