
TianXiangItem=class(Layer);

function TianXiangItem:ctor()
  self.class=TianXiangItem;
  self.state = 0;
end
function TianXiangItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();

end
function TianXiangItem:initialize(context, slotContext, tianxiangId, xPos, yPos)
  self.context = context;
  self.slotContext = slotContext;

  self.tianxiangId = tianxiangId;
  self.xPos = xPos;
  self.yPos = yPos;
  self:initLayer();

  local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",tianxiangId)
  self.tianxiangPo = tianxiangPo;

  self:setData()

  self:setPositionXY(xPos, yPos)
  self:setAnchorPoint(makePoint(0.5, 0.5));

end
function TianXiangItem:setData()

  if not self.property_txt then
    local shuXing = analysis("Shuxing_Shuju",self.tianxiangPo.attributeid, "name")
    shuXing = shuXing .. "+" .. self.tianxiangPo.attributeUp;

    self.property_txt=TextField.new(CCLabelTTF:create(shuXing,FontConstConfig.OUR_FONT,22,CCSizeMake(200, 30), kCCTextAlignmentCenter));
    self.property_txt:setPositionXY(self.xPos-50, self.yPos-20);
    self.property_txt.touchEnabled = false;
    self.slotContext:addChild(self.property_txt);
  end

  if self.frame_bg then
    self:removeChild(self.frame_bg)
  end
  self.frame_bg = Image.new();

  if self.effect then
    self:removeChild(self.effect)
    self.effect = nil;
  end

  local len = #self.context.userProxy.tianXiangIds;

  if Utils:contain(self.context.userProxy.tianXiangIds, self.tianxiangId) then
    self.state = 2;
  elseif (len == 0 and self.tianxiangId == 10001) then
    self.state = 1;
  else
    self.state = 0;
  end

  if self.state == 0 then
    if self.context.userProxy:checkIsNextTianXiang(self.tianxiangId) then
      self.state = 1;
    end
  end

  if self.state == 2 then
    self.frame_bg:loadByArtID(1087)
  else
    self.frame_bg:loadByArtID(1134)
    if self.state == 1 then
      self.effect = cartoonPlayer("1170", 45, 55, 0);
      self:addChild(self.effect);
      self.frame_bg:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self); 
    end
  end
  local size = self.frame_bg:getContentSize()
  self:setContentSize(makeSize(size.width, size.height))
  self:addChild(self.frame_bg)


end

function TianXiangItem:onTouchBegin(event)
  print("onTouchBegin")
  self:setScale(0.95)
  self.beginPos = event.globalPosition;
  self.frame_bg:addEventListener(DisplayEvents.kTouchEnd, self.onTouchEnd, self); 
end
function TianXiangItem:onTouchEnd(event)
  self:setScale(1)
  self.frame_bg:removeEventListener(DisplayEvents.kTouchEnd, self.onTouchEnd); 

  local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",self.tianxiangId)
  if tianxiangPo.vigourPoint > self.context.userCurrencyProxy.storyLineStar then
    sharedTextAnimateReward():animateStartByString("亲~星数不够！");
  elseif tianxiangPo.money > self.context.userCurrencyProxy.silver then
    sharedTextAnimateReward():animateStartByString("亲~银两不够！");
    self.context:dispatchEvent(Event.new("ON_QIAN_ZHUANG",nil,self));
  else
    local function callBack()
      self:removeChild(self.tempEffect);

      local extensionTable = {}
      extensionTable["tianxiangdianID"] = self.tianxiangId
      hecDC(3,28,2,extensionTable)

      sendMessage(3, 45, {ID = self.tianxiangId})

      local shuXing = analysis("Shuxing_Shuju",tianxiangPo.attributeid, "name")
      shuXing = shuXing .. "+" .. tianxiangPo.attributeUp;
      sharedTextAnimateReward():animateStartByString("所有英雄".. shuXing);

      self.context.userProxy.zodiacIdForMsg = self.tianxiangId;
      self:checkIsLast()
    end
    self.tempEffect = cartoonPlayer("1133", 45, 55, 1, callBack);
    self:addChild(self.tempEffect)
    self.frame_bg:removeEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin); 
    print("self.tianxiangId, ", self.tianxiangId)
  end

end
function TianXiangItem:checkIsLast()

  print("\n\n\ncheckIsLast")

  -- local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",self.tianxiangId)
  -- local tianxiangPos = analysisByName("Zhujiao_Tianxiangshouhudian", "group", tianxiangPo.group);

  -- print("+++++self.context.userProxy.zodiacId ", self.context.userProxy.zodiacId)
  -- table.insert(self.context.userProxy.tianXiangIds, self.tianxiangId);
  -- self.context.userProxy.zodiacId = self.tianxiangId;
  -- print("-----self.context.userProxy.zodiacId ", self.context.userProxy.zodiacId)


  -- local isLast = true;
  -- for k, v in pairs(tianxiangPos) do
  --     if v.id <= self.tianxiangId then

  --     else
  --       isLast = false;
  --     end
  -- end
  -- if isLast and analysisHas("Zhujiao_Tianxiangshouhudian",tianxiangPo.id2) then
  --   table.insert(self.context.userProxy.tianXiangZuIds, tianxiangPo.group + 1);
  --   self.context:refreshData(true)
  -- else
  --   self.context:refreshData(false)
  -- end



  if GameVar.tutorStage == TutorConfig.STAGE_1023 then
    if not self.context.tutorCount then
      self.context.tutorCount = 1;
    end
    if self.context.tutorCount == 1 then
      sendServerTutorMsg({BooleanValue = 0})
      openTutorUI({x=363 + GameData.uiOffsetX + 45, y=383, width = 70, height = 70});
    elseif self.context.tutorCount == 2 then
      openTutorUI({x=474 + GameData.uiOffsetX + 45, y=134, width = 70, height = 70});
    elseif self.context.tutorCount == 3 then
      sendServerTutorMsg({})
      closeTutorUI();
    end
  end


  if self.context.tutorCount then
    self.context.tutorCount = self.context.tutorCount + 1;
  end

end