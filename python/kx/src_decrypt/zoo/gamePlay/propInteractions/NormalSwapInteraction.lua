require 'zoo.gamePlay.propInteractions.BaseInteraction'
require 'zoo.itemView.PropsView'

NormalSwapInteraction = class(BaseInteraction)
function NormalSwapInteraction:ctor()
    self.item1Pos = nil
    self.item2Pos = nil
    self.firstWaitingState = BaseInteractionState.new('firstWaitingState')
    self.firstTouchedState = BaseInteractionState.new('firstTouchedState')
    self.secondWaitingState = BaseInteractionState.new('secondWaitingState')
    self.secondTouchedState = BaseInteractionState.new('secondTouchedState')
    self:setCurrentState(self.firstWaitingState) -- init
end

function NormalSwapInteraction:handleTouchBegin(x, y)

    local touchPos = self.boardView:TouchAt(x, y)
    if not touchPos then return end

    if not self.boardView.gameBoardLogic:isItemInTile(touchPos.x, touchPos.y) then
        return
    end

    if not self.boardView.gameBoardLogic:isItemCanMoved(touchPos.x, touchPos.y) then
        return
    end

    if self.currentState == self.firstWaitingState then
        self.item1Pos = touchPos
        self:setCurrentState(self.firstTouchedState)
        self.boardView:focusOnItem(touchPos)
    elseif self.currentState == self.secondWaitingState then
        if not BaseInteraction.isEqualPos(touchPos, self.item1Pos) then -- 点击不同一个格子
            -- 可以交换
            if 0 < self.boardView.gameBoardLogic:canBeSwaped(self.item1Pos.x, self.item1Pos.y, touchPos.x, touchPos.y) then

                self.item2Pos = touchPos
                self:setCurrentState(self.secondTouchedState)
                self:handleComplete()
            else -- 不能交换
                self.item1Pos = touchPos
                self:setCurrentState(self.firstTouchedState)
                self.boardView:focusOnItem(touchPos)
            end
        else
            self.item1Pos = touchPos
            self:setCurrentState(self.firstTouchedState)
            self.boardView:focusOnItem(touchPos)
        end
    else 
        -- error
        assert(false, 'NormalSwapInteraction state error')
    end
end


-- 用于普通交换 & 强制交换
function NormalSwapInteraction:handleTouchMove(x, y)
    local touchPos = self.boardView:TouchAt(x, y)
    if not touchPos then 
        return  
    end

    if not self.item1Pos then
        return 
    end

    -- 不是棋盘上
    if not self.boardView.gameBoardLogic:isItemInTile(touchPos.x, touchPos.y) then
        return
    end

     -- 仍在同一个格子内
    if BaseInteraction.isEqualPos(touchPos, self.item1Pos) then
        return 
    end

    if self.currentState == self.firstTouchedState then
    
        if 0 < self.boardView.gameBoardLogic:canBeSwaped(self.item1Pos.x, self.item1Pos.y, touchPos.x, touchPos.y) then
            self.item2Pos = touchPos
            self:handleComplete()
        end
    end
end

function NormalSwapInteraction:handleTouchEnd(x, y)
    local touchPos = self.boardView:TouchAt(x, y)
    if not touchPos then 
        return  
    end

    if self.currentState == self.firstTouchedState then
        if BaseInteraction.isEqualPos(self.item1Pos, touchPos) then
            self.item1Pos = touchPos
            print(touchPos.x, touchPos.y)
        end
        self:setCurrentState(self.secondWaitingState)
    end
end

function NormalSwapInteraction:onEnter()
    print('>>> enter NormalSwapInteraction')
    self.item1Pos = nil
    self.item2Pos = nil
    self:setCurrentState(self.firstWaitingState)
end

function NormalSwapInteraction:onExit()
    print('--- exit  NormalSwapInteraction')
end

function NormalSwapInteraction:handleComplete()
    if self.controller then
        self.controller:onInteractionComplete({item1Pos = self.item1Pos, item2Pos = self.item2Pos})
    end
    self:onEnter()
end