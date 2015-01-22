require 'zoo.gamePlay.propInteractions.BaseInteraction'
require 'zoo.itemView.PropsView'

-- 用于锤子道具
HammerInteraction = class(BaseInteraction)
function HammerInteraction:ctor(boardView, controller)
    self.waitingState = BaseInteractionState.new('waitingState')
    self:setCurrentState(self.waitingState)
end

function HammerInteraction:handleTouchBegin(x, y)
    print('HammerInteraction:handleTouchBegin()')
    local touchPos = self.boardView:TouchAt(x, y)

    if not touchPos then
        return 
    end

    if not self.boardView.gameBoardLogic:isItemInTile(touchPos.x, touchPos.y) then
        return
    end

    if self.currentState == self.waitingState then
        if self.boardView.gameBoardLogic:canUseHammer(touchPos.x, touchPos.y) then
            self.itemPos = touchPos
            self:handleComplete()
        else
            PropsView:playHammerDisableAnimation(self.boardView, IntCoord:create(touchPos.x, touchPos.y))
        end
    end
end

function HammerInteraction:handleTouchMove(x, y)

end

function HammerInteraction:handleTouchEnd(x, y)

end

function HammerInteraction:onEnter()
    print('>>> enter HammerInteraction')
end

function HammerInteraction:onExit()
    print('--- exit  HammerInteraction')
end

function HammerInteraction:handleComplete()
    print('HammerInteraction:handleComplete()')
    if self.controller then
        self.controller:onInteractionComplete({itemPos = self.itemPos})
    end
    self:onEnter()
end