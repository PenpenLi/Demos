
require (BATTLE_CLASS_NAME.class)
local BAForReactionAnimationAction = class("BAForReactionAnimationAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForReactionAnimationAction.target 			= nil
	BAForReactionAnimationAction.reactionBitmapPath = nil
	BAForReactionAnimationAction.action 			= nil
	BAForReactionAnimationAction.container 			= nil
	------------------ functions -----------------------
	function BAForReactionAnimationAction:start( ... )
		--print("BAForReactionAnimationAction:start: target:",self.target,"  bitmap:",self.reactionBitmapPath)
		if(self.target and self.reactionBitmapPath) then
			
			local size 				= self.target.cardRectange
			-- 获取图片
			self.container 			=  WordsAnimationManager.getWord(self.reactionBitmapPath)
			if(self.container) then

				local completeCall  = function ( ... )
		     		self:onActionComplete()
		     	end
		     	-- 动画位置
		     	local postion = nil
		     	-- print("-- BAForReactionAnimationAction:",self.reactionBitmapPath)
		     	-- 获取动画
				self.action =  WordsAnimationManager.getAnimationByWord(self.reactionBitmapPath,completeCall)
				-- 获取动画添加锚点(决定动画添加位置)
				local addIndex = WordsAnimationManager.getWordAnimationAddIndex(self.reactionBitmapPath)
				-- local addIndex = WordsAnimationManager.getWordAnimationAddIndex(self.title)
                 
                -- 获取全局位置
                if(self.target) then
                    if(addIndex == BATTLE_CONST.POS_MIDDLE or addIndex == nil) then
                        postion = self.target:globalCenterPoint()
                        -- print("-- BAForReactionAnimationAction: at POS_MIDDLE")
                    elseif(addIndex == BATTLE_CONST.POS_HEAD) then
                        postion = self.target:globalHeadPoint()
                         -- print("-- BAForReactionAnimationAction: at POS_HEAD")
                    else
                    	-- print("-- BAForReactionAnimationAction: at POS_FEET")
                        postion = self.target:globalFeetPoint()
                    end
                    -- self.container:setAnchorPoint(ccp(0.5, 0.5))
                    self.container:setPosition(postion.x,postion.y)
                end
                
                -- 开始执行action
				if(self.action) then
					self.container:runAction(self.action)
				else
					self:complete()
				end
			else
				self:complete()
			end
			
		else
			self:complete()
		end
 
	end -- function end

 
 	function BAForReactionAnimationAction:onActionComplete( ... )
 		-- if(self.container) then 
 		-- 	if(self.container and self.container:getParent()) then 
 		-- 		self.container:removeFromParentAndCleanup(true)
 		-- 	end
 		-- 	self.container = nil
 		-- end
 		self:complete()
 		self:release()
 	end

 	function BAForReactionAnimationAction:release( ... )
		     		
 		if(self.disposed ~= true) then
 			
 			if(self.action) then
 				-- self.action:release()
 				self.action = nil
 			end


	 		ObjectTool.removeObject(self.container)
	 		self.container = nil 
	 		self.reactionPath 	= nil
	 		self.target 		= nil

	 		self.disposed 	= true
			self:removeFromRender()					-- 执行
			self.calllerBacker:clearAll()
			self.blockBoard	= nil
		end

 	end

return BAForReactionAnimationAction