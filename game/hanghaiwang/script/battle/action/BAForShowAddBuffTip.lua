
-- 添加buff时 tip提示动画
require (BATTLE_CLASS_NAME.class)
local BAForShowAddBuffTip = class("BAForShowAddBuffTip",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShowAddBuffTip.tip 					= nil 	-- tip
	BAForShowAddBuffTip.target 					= nil 	--  buff目标
	BAForShowAddBuffTip.tipInstance 			= nil 	-- tip实例
	-- BAForShowAddBuffTip.word 					
	------------------ functions -----------------------

	function BAForShowAddBuffTip:isIgnore()
    	
    	if(self.tip) then
    		if(
    			self.tip == "attackdown.png" or 
    			self.tip == "defensedown.png" or 
                self.tip == "hitratedown.png" or

                self.tip == "attackup.png" or
                self.tip == "blockup.png" or
                self.tip == "criticalup.png" or
                self.tip == "defenseup.png" or
    			self.tip == "dodgeup.png"
    		   ) then

    			return false
    		end
    	end
    	return true
	end
 	function BAForShowAddBuffTip:start()
 		-- Logger.debug("BAForShowAddBuffTip:start 1")
		if(self.tip ~= nil and self.target ~= nil) then 

        	-- Logger.debug("BAForShowAddBuffTip:start 2 " .. tostring(self.tip) )
            -- 获取显示对象
        	self.tipInstance = WordsAnimationManager.getWord(self.tip)
        	 
        	local completeCall1 = function ( ... )
        		self:complete()
        		self:release()
        	end

        	if(self.tipInstance) then
        	    
                -- 获取挂点
                local addIndex = WordsAnimationManager.getWordAnimationAddIndex(self.tip)
        		self.actions = WordsAnimationManager.getAnimationByWord(self.tip,completeCall1,{self.tipInstance})
        		local postion = nil
                -- if(addIndex == nil) then addIndex = BATTLE_CONST.POS_MIDDLE end
                -- 设置位置
                if(addIndex == BATTLE_CONST.POS_MIDDLE or addIndex == nil) then
                    postion = self.target:globalCenterPoint()
                elseif(addIndex == BATTLE_CONST.POS_HEAD) then
                    postion = self.target:globalHeadPoint()
                else
                    postion = self.target:globalFeetPoint()
                end
                    -- 位置                                                                                                                                      
                
                self.tipInstance:setPosition(postion.x,postion.y)

                if(self.actions) then
        			-- self.actions:start()
                     self.tipInstance:runAction(self.actions)
        		else
        			self:complete()
        			self:release()
        		end
        	else
        		self:complete()
        	end
    
        else
        	self:complete()
		end
		-- self:complete()
	end



	function BAForShowAddBuffTip:release( ... )
		self.super.release(self)
		ObjectTool.removeObject(self.tipInstance)
		self.tipInstance = nil
		self.target = nil
	end
return BAForShowAddBuffTip