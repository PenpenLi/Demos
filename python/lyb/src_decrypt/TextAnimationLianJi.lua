--连击弹字，没有用
TextAnimationLianJi = class(BatchLayer);
function TextAnimationLianJi:ctor()
	self.class = TextAnimationLianJi;  
  self.lianjiNum = 1
  self.textTable = {};
end

function TextAnimationLianJi:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TextAnimationLianJi.superclass.dispose(self);
  self:removeLoopHandleTimer()
end

function TextAnimationLianJi:textAnimation(skeleton)
  self:initBatchLayer(skeleton)
  self.touchChildren = false;
  self.touchEnabled = false;
  self.skeleton = skeleton;
  local lianji = skeleton:getBoneTextureDisplay("lianji");
  self:addChild(lianji);
  local size = self:getGroupBounds().size
  self:changeAnchorPoint(size.width/2,size.height/2)
  self:setVisible(false)
end

-- function TextAnimationLianJi:refreshLianji()
--   self:removeText();
--   self:setVisible(true)
--   self:itemScaleEaseOut()
--   self:removeLoopHandleTimer()
--   local long = string.len(self.lianjiNum);
--   for i = 1, long do
--       local str = string.sub(self.lianjiNum, i, i);
--       self:addNumText(str,long-i)
--   end
--   self.lianjiNum = self.lianjiNum + 1
--   local function loopHandleFun()
--       self:removeLoopHandleTimer()
--       self.lianjiNum = 1
--       self:removeText()
--       self:setVisible(false)
--   end
--   self.loopHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopHandleFun, 2, false)
-- end

function TextAnimationLianJi:addNumText(str,num)
  local numText = self.skeleton:getBoneTextureDisplay("lianji_"..str);
  local width = numText:getContentSize().height
  numText:setPositionX(-width*0.65*(num+1))
  self:addChild(numText);
  table.insert(self.textTable, numText);
end

function TextAnimationLianJi:removeText()
  for key,numText in pairs(self.textTable) do
      self:removeChild(numText)
  end
end

function TextAnimationLianJi:itemScaleEaseOut()
  local scale1 = CCScaleTo:create(0,0);
  local scale2 = CCScaleTo:create(0.3,1);
  local scale1EaseOut = CCEaseElasticOut:create(scale2,0.3);
  local array = CCArray:create()
  array:addObject(scale1)
  array:addObject(scale1EaseOut)
  self:runAction(CCSequence:create(array));
end

function TextAnimationLianJi:removeLoopHandleTimer()
    if self.loopHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopHandle);
        self.loopHandle = nil
    end
end