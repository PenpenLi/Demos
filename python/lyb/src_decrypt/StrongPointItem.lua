
StrongPointItem=class(Layer);

function StrongPointItem:ctor()
  self.class=StrongPointItem;
end
function StrongPointItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();

end
function StrongPointItem:initialize(context, slotContext, data, strongPointId, xPos, yPos)
  self.context = context;
  self.slotContext = slotContext;
  local frame_bg = Image.new();

  self.frame_bg = frame_bg;
  self.strongPointId = strongPointId;
  self.xPos = xPos;
  self.yPos = yPos;
  self:initLayer();

  local strongPointPo = analysis("Juqing_Guanka",strongPointId)
  self.strongPointPo = strongPointPo;

  frame_bg:loadByArtID(387)
  local size = frame_bg:getContentSize()
  self:setContentSize(makeSize(size.width, size.height))
  self:addChild(frame_bg)

  local strongPointData = self.context.storyLineProxy.strongPointArray["key_"..strongPointId];
  if strongPointData then

    if strongPointData.State == 1 then
      local iconImage = Image.new();
      iconImage:loadByArtID(self.strongPointPo.artId);
      self:addChild(iconImage)
    elseif strongPointData.State == 2 then

    elseif strongPointData.State == 3 or strongPointData.State == 4 then
      local iconImage = Image.new();
      iconImage:loadByArtID(self.strongPointPo.artId);
   
      self:addChild(iconImage)
    end 

    if self.strongPointPo.type == 3 then
      local bossImage = Image.new()
      bossImage:loadByArtID(14) 
      bossImage:setPositionXY(8,8)
      self:addChild(bossImage)
    elseif self.strongPointPo.type == 2 then
      local jingYingImage = Image.new()
      jingYingImage:loadByArtID(1582) 
      jingYingImage:setPositionXY(17,6)
      self:addChild(jingYingImage)
    end

    local starGroup = self:getStarGroup(strongPointId)
    if starGroup then
      starGroup:setPositionXY(-6,-60)
      self:addChild(starGroup)
    end

    self:addEventListener(DisplayEvents.kTouchBegin, self.onTouchBegin, self); 
  else
    -- print("strongPointData is nil, self.strongPointPo.id", self.strongPointPo.id)
  end
  self:setPositionXY(xPos, yPos)
  self:setAnchorPoint(makePoint(0.5, 0.5));
  self:setTiliTip(true)
end

-- 根据星级获得显示对象
function StrongPointItem:getStarGroup(strongPointId)
  
  local strongpointCount = self.context.storyLineProxy:getStrongPointStarCount(strongPointId)
  -- log("strongPointId========"..strongPointId)
  -- log("strongpointCount========"..strongpointCount)
  if strongpointCount == 0 then
    return nil
  end

  local starLayer = Layer.new()
  starLayer:initLayer()
  starLayer:setContentSize(CCSizeMake(100,30))
  local skeleton = self.context.storyLineProxy:getSkeleton();

  for i=1,strongpointCount do
    local allstarImage = skeleton:getBoneTextureDisplay("allstarImage");
    starLayer:addChild(allstarImage);

    local posisitonX
    if strongpointCount == 1 then
      posisitonX = 100 / 3
    else
      posisitonX = (100 - 33 * strongpointCount) / strongpointCount + (i-1) * 33
    end   

    allstarImage:setPositionXY(posisitonX,0)
  end
  return starLayer;
end

function StrongPointItem:setTiliTip(boo)
  if not self.mozhi_bg then
    self.mozhi_bg = Image.new();
    self.mozhi_bg:loadByArtID(721);
    self.mozhi_bg:setPositionXY(-25, -24)
    -- self.mozhi_bg:setPositionXY(self.xPos- 15, self.yPos-24)
    self.mozhi_bg.touchEnabled = false;
    self:addChild(self.mozhi_bg)
  end

  self.mozhi_bg:setVisible(boo)

  if not self.storyLineNameTxt then
    local strontPointName = self.strongPointPo.scenarioName
    self.storyLineNameTxt=TextField.new(CCLabelTTF:create(strontPointName,GameConfig.DEFAULT_FONT_NAME, 26,CCSizeMake(160, 35), kCCTextAlignmentCenter));
    self.storyLineNameTxt.touchEnabled = false;
    self.storyLineNameTxt:setPositionXY(-30, -23)
    -- self.storyLineNameTxt:setPositionXY(self.xPos- 30, self.yPos -23)
    self:addChild(self.storyLineNameTxt)
  end
  self.storyLineNameTxt:setVisible(boo)
end
function StrongPointItem:onTouchBegin(event)
  self:setScale(0.88)
  self.beginPos = event.globalPosition;
  self:addEventListener(DisplayEvents.kTouchEnd, self.onTouchEnd, self); 
end
function StrongPointItem:onTouchEnd(event)
    self:setScale(1)
    self:removeEventListener(DisplayEvents.kTouchEnd, self.onTouchEnd); 

    if math.abs(event.globalPosition.x - self.beginPos.x) > 20 or math.abs(event.globalPosition.y - self.beginPos.y) > 20 then return end;

    local strongPointData = self.context.storyLineProxy.strongPointArray["key_"..self.strongPointId];
    if strongPointData then
      if strongPointData.State == GameConfig.STRONG_POINT_STATE_1 then
        local bool = self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_39)
        if bool == false then
          sharedTextAnimateReward():animateStartByString("开启扫荡功能后才可以打之前的关卡");
          return;
        end
        self.context:onStrongPointCallBack(self.strongPointId);
        if GameData.isMusicOn then
          MusicUtils:playEffect(7,false)
        end
      elseif strongPointData.State == GameConfig.STRONG_POINT_STATE_3 or  strongPointData.State == GameConfig.STRONG_POINT_STATE_4 then
         print("self.context.userProxy.mainGeneralLevel", self.context.userProxy:getLevel(), self.strongPointPo.jinruLv)
         if self.context.userProxy:getLevel() < self.strongPointPo.jinruLv then
            sharedTextAnimateReward():animateStartByString("主角到达" .. self.strongPointPo.jinruLv .. "级才可进入"); 
         else
            self.context:onStrongPointCallBack(self.strongPointId);
            if GameData.isMusicOn then
             MusicUtils:playEffect(7,false)
            end
         end
      elseif strongPointData.State == GameConfig.STRONG_POINT_STATE_2 then
        sharedTextAnimateReward():animateStartByString("关卡尚未开启");
      end
    else
      sharedTextAnimateReward():animateStartByString("关卡尚未开启");
    end
end

function StrongPointItem:setSelect(boo)
    if not self.selectEffect then
      self.selectEffect = cartoonPlayer("849", 48, 48, 0, nil);
      self:addChild(self.selectEffect)
      self.frame_bg:addChild(self.selectEffect)

    end
    self.selectEffect:setVisible(boo)
    self:setTiliTip(boo)
end

function StrongPointItem:setPassEffect(boo)
    -- if not self.passEffect then
    --   self.passEffect = cartoonPlayer("848", 48, 48, 0, nil);
    --   self:addChild(self.passEffect)
    --   self.frame_bg:addChild(self.passEffect)

    -- end
    -- self.passEffect:setVisible(boo)
end
