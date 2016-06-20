require "zoo.panel.component.levelTarget.LevelTargetItem"

HalloweenTargetItem =  class(LevelTargetItem)

function HalloweenTargetItem:setTargetNumber(itemId, itemNum, animate, globalPosition )
    if not self.sprite.refCocosObj then return end
    if itemNum ~= nil then
        -- 防止数字回滚
        -- 前提：反正该模式下，数字是单向增加的
        if itemNum >= self.itemNum then
            self.itemNum = itemNum
        end

        if animate and globalPosition and self.icon then
            local cloned = self.icon:clone(true)
            -- local targetPos = self:convertToNodeSpace(globalPosition)
            local targetPos = self.sprite:getParent():convertToNodeSpace(globalPosition)
            local position = cloned:getPosition()
            local tx, ty = position.x, position.y
            local function onIconScaleFinished()
                cloned:removeFromParentAndCleanup(true)
                self.animNode = nil
            end 
            local function onIconMoveFinished()         
                self.label:setString(tostring(self.itemNum or 0))
                self.context:playLeafAnimation(true)
                self.context:playLeafAnimation(false)
                self:shakeObject()
                local sequence = CCSpawn:createWithTwoActions(CCScaleTo:create(0.3, 2), CCFadeOut:create(0.3))
                cloned:setOpacity(255)
                cloned:runAction(CCSequence:createWithTwoActions(sequence, CCCallFunc:create(onIconScaleFinished)))
            end 
            local moveTo = CCEaseSineInOut:create(CCMoveTo:create(0.5, ccp(tx, ty)))
            local array = CCArray:create()
            
            array:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(0.5, 1), CCSpawn:createWithTwoActions(moveTo, CCFadeTo:create(0.5, 150))))
            array:addObject(CCCallFunc:create(onIconMoveFinished))
            cloned:setPosition(targetPos)
            cloned:setScale(1.5)
            cloned:runAction(CCSequence:create(array))
            self.animNode = cloned
        else
            self.label:setString(tostring(itemNum or 0))
        end
    end
end
