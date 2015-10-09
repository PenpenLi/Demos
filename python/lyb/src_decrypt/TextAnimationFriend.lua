--没有用
TextAnimationFriend = class(BatchLayer);
function TextAnimationFriend:ctor()
	self.class = TextAnimationFriend;  
  self.textTable = {};
end

function TextAnimationFriend:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TextAnimationFriend.superclass.dispose(self);
  self:removeLoopHandleTimer()
end

function TextAnimationFriend:textAnimation(skeleton,fightUI)
  self:initBatchLayer(skeleton)
  self.touchChildren = false;
  self.touchEnabled = false;
  self.skeleton = skeleton;
  local size = self:getGroupBounds().size
  self:changeAnchorPoint(size.width/2,size.height/2)
  self.daojishiTime = BattleConfig.Friend_Time/1000
  self:refreshLianji(fightUI)
  self:setScale(0.8)
end

function TextAnimationFriend:refreshLianji(fightUI)
  local function loopHandleFun()
      self:removeText();
      local long = string.len(self.daojishiTime);
      for i = 1, long do
          local str = string.sub(self.daojishiTime, i, i);
          self:addNumText(str,long-i)
      end
      self.daojishiTime = self.daojishiTime - 1
      if self.daojishiTime < 0 then
          self:removeText();
          self:removeLoopHandleTimer()
          fightUI:removeFriendDaojishi()
      end
  end
  loopHandleFun()
  self.loopHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopHandleFun, 1, false)
end

function TextAnimationFriend:addNumText(str,num)
  local numText = self.skeleton:getBoneTextureDisplay("lianji_"..str);
  local width = numText:getContentSize().height
  numText:setPositionX(-width*0.65*(num+1))
  self:addChild(numText);
  table.insert(self.textTable, numText);
end

function TextAnimationFriend:removeText()
  for key,numText in pairs(self.textTable) do
      self:removeChild(numText)
  end
end

function TextAnimationFriend:removeLoopHandleTimer()
    if self.loopHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopHandle);
        self.loopHandle = nil
    end
end