



-- 显示数字(可以额外增加title图片同时显示)
require (BATTLE_CLASS_NAME.class)
local BAForShowNumberAnimation = class("BAForShowNumberAnimation",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	BAForShowNumberAnimation.value 						= nil -- 伤害
    BAForShowNumberAnimation.heroUI                     = nil -- 目标
    BAForShowNumberAnimation.color                      = "red" -- 颜色
    BAForShowNumberAnimation.title                      = nil -- 文字图片
    BAForShowNumberAnimation.showSign                   = false -- 是否显示数字的符号
    BAForShowNumberAnimation.isFatal                    = false -- 是否是暴击
    BAForShowNumberAnimation.numberLabel                = nil
    BAForShowNumberAnimation.showZero                   = nil
    -- BAForShowNumberAnimation.targets                    = nil
    BAForShowNumberAnimation.isMulityTime               = nil
    BAForShowNumberAnimation.isLastMulityTime           = nil
    BAForShowNumberAnimation.targetInstanceName               = nil
    BAForShowNumberAnimation.isRunning                 = nil
	------------------ functions -----------------------
	

function BAForShowNumberAnimation:start()
    -- --print("BAForShowNumberAnimation:value",self.value," heroUI:",self.heroUI)
 		--掉血为0不显示
        if(self.isRunning == true) then
            return 
        end
        
        if((self.value == 0 and not self.showZero) or self.value == nil)then
            self:complete()
        else
           
            self.isRunning = true
            if(self.heroUI) then
                self.targetInstanceName = self.heroUI:instanceName()
            else
                self.targetInstanceName = 1
            end

            local actions = nil
            if(self.value ~= 0 or self.showZero) then

                -- local isFatal = false
                if(self.showSign == nil) then self.showSign = false end
                -- 生成数值
                if(self.color == nil or self.color == BATTLE_CONST.NUMBER_RED) then
                    self.numberLabel = WordsAnimationManager.getRedNumber(self.value)
                elseif(self.color == BATTLE_CONST.NUMBER_GREEN) then
                    self.numberLabel = WordsAnimationManager.getGreenNumber(self.value,true)
                else

                    -- isFatal = true
                    self.numberLabel = WordsAnimationManager.getCriticalNumber(self.value)
                    -- -- 暴击
                    -- if(labelImg) then
                    --     labelImg:setPositionY(labelImg:getContentSize().height)
                    -- end
                end
            
               

                -- 文字
                -- local labelImg = nil
                -- self.title = "poison.png"
                local wordHeight = 0
                if(self.title ~= nil and self.title ~= "") then
                    self.labelImg,wordHeight = WordsAnimationManager.getWord(self.title)
                end

                -- action 结束回调
                local completeCall1 = function( ... )
                        -- Logger.debug("数字动画完毕")
                        if(self.disposed ~= true) then
                             self:complete()
                          
                        end
                       
                        self:release()  
                end
                -- 获取位置
                local postion = nil
                
                -- 文字动画
                local wordAnimation = nil
                -- 文字动画在人物身上的挂点
                local addIndex = nil

                -- 如果带文字的动画,那么我们需要按照设定参数获取位置
                if(self.labelImg) then
                    local addIndex = WordsAnimationManager.getWordAnimationAddIndex(self.title)
                    -- wordAnimation,addIndex = WordsAnimationManager.getAnimationByWord(self.title,completeCall1)
                    if(self.heroUI) then
                        if(addIndex == BATTLE_CONST.POS_MIDDLE or addIndex == nil) then
                            postion = self.heroUI:globalCenterPoint()
                        elseif(addIndex == BATTLE_CONST.POS_HEAD) then
                            postion = self.heroUI:globalHeadPoint()
                        else
                            postion = self.heroUI:globalFeetPoint()
                        end
                    -- else
                    --      postion = ccp(g_winSize.width * math.random() , g_winSize.height * math.random())
                    end
                else
                    if(self.heroUI ~= nil) then
                        -- todo
                        if(self.isFatal ~= true) then
                            postion = self.heroUI:globalHeartPoint()
                            -- postion = self.heroUI:globalFeetPoint()
                        else
                            
                            -- 如果是多段 且不是最后一次
                            if(self.isMulityTime == true and self.isLastMulityTime ~= true) then
                                postion = self.heroUI:globalHeartPoint()
                          
                            else
                                -- print("----- isFatal2")
                                postion = self.heroUI:globalHeadPoint()
                            end
                        end
                    end
                end

                -- 如果没有点,则随机生成
                if(postion == nil) then
                    postion = ccp(g_winSize.width * math.random() , g_winSize.height * math.random())
                end
 
                self.numberLabel:setPosition(postion.x,postion.y)

                if(self.labelImg ~= nil) then
                    -- local rect = self.labelImg:getRect()
                    -- local height = self.labelImg:getMaxY() - self.labelImg:getMinY()

                     
                    if(wordHeight ~= nil and wordHeight > 0) then
                        self.labelImg:setPosition(postion.x,postion.y + wordHeight * g_fScaleY + g_fScaleY * 7)
                    else
                        self.labelImg:setPosition(postion.x,postion.y + self.numberLabel:getContentSize().height * g_fScaleY + g_fScaleY * 7)
                    end
                    local actions1 = WordsAnimationManager.getAnimationByWord(self.title)
                    self.actions = WordsAnimationManager.getAnimationByWord(self.title,completeCall1)
                    -- self.actions:start()
                    -- self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RED ,completeCall1)
                    -- self.actions1 = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RED)
                    self.numberLabel:runAction(self.actions )
                    self.labelImg:runAction(actions1)
                    -- self.numberLabel:refresh()
                else

                    -- 如果是多段 
                    if(self.isMulityTime and self.isLastMulityTime ~= true) then
                         
                         if(self.color == BATTLE_CONST.NUMBER_RED) then
                            self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_MULITY ,completeCall1)
                         else
                            -- print("----- isFatal NUM_ANI_CRTICAL_MULITY")
                            self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_CRTICAL_MULITY ,completeCall1)
                         end
                     -- 如果是多段 且 多段最后一击
                    -- elseif(self.isMulityTime and self.isLastMulityTime and not isFatal) then
                    elseif(self.isMulityTime and self.isLastMulityTime) then
                         
                         if(self.color == BATTLE_CONST.NUMBER_RED) then
                            self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RED ,completeCall1)
                         else
                            -- print("----- isFatal isLastMulityTime")
                            self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_CRTICAL ,completeCall1)
                         end
                    elseif(self.color == nil or self.color == BATTLE_CONST.NUMBER_RED) then
                        -- Logger.debug("----1.1")
                        self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RED ,completeCall1)
                   
                    elseif(self.color == BATTLE_CONST.NUMBER_GREEN) then
                        -- Logger.debug("----1.2")
                        self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_GREEN ,completeCall1)
                    
                    else
                        -- Logger.debug("----1.3")
                          -- print("----- isFatal NUM_ANI_CRTICAL")
                        self.actions = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_CRTICAL ,completeCall1)
                    end

                    WordsAnimationManager.regestNumberLabel(self,self.targetInstanceName)
                    -- Logger.debug("----1.4")
                    -- self.actions:start()
                    self.numberLabel:runAction(self.actions )
                end
                
            end
        end -- if end
        
       -- self:complete()
      
end

function BAForShowNumberAnimation:release( ... )
    self.super.release(self)
     -- for k,child in pairs(self.targets or {}) do
     --    if(child.__ctype ~= 2) then 
     --         ObjectTool.removeObject(child)
     --    else
     --         child:release()
     --    end
     -- end
     if(self.labelImg) then
        ObjectTool.removeObject(self.labelImg)
     end

     if(self.numberLabel) then
        ObjectTool.removeObject(self.numberLabel)
     end

     self.targets = {}
     WordsAnimationManager.removeNumberLabel(self.targetInstanceName)
end

function BAForShowNumberAnimation:removeSelf(node)
    if(node:getParent()) then
        node:removeFromParentAndCleanup(true)
    end
end
return BAForShowNumberAnimation

 