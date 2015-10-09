

PersonItem=class(Layer);

function PersonItem:ctor()
  self.class=PersonItem;
  self.text = nil;
  self.textBg = nil;
  self.blackLayer = nil;
end

function PersonItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PersonItem.superclass.dispose(self);
end

function PersonItem:initializeUI(step, context)
  self.context = context;
  self:initLayer();
  -- local mainSize = Director:sharedDirector():getWinSize();

  -- self:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
  self.touchEnabled = false;
  self.touchChildren = false;
  -- self:setOpacity(125);
  -- self:addEventListener(DisplayEvents.kTouchTap, self.onClickBlack, self);
  self:setData(step);
end

function PersonItem:setData(step)

  local xinshouPO = analysis("Xinshouyindao_Xinshou",step)
  local art1;
  local scaleSize;
  if xinshouPO.heroID == 1291 then
    art1 = 1291;
    scaleSize = 1;
  else
    art1 = analysis("Kapai_Kapaiku", xinshouPO.heroID, "art1");
    scaleSize = 0.4;
  end


  self.imageBg = getImageByArtId(art1);
  self.imageBg:setScaleX(-scaleSize)
  self.imageBg:setScaleY(scaleSize)
  self:addChild(self.imageBg);


  self.textBg = getImageByArtId(136);
  self.textBg:setPositionXY(xinshouPO.X + 176, xinshouPO.Y + 19);
  self:addChild(self.textBg);


  if self.text then
    self.text:setString(xinshouPO.Dialogue);
  else
    self.text = MultiColoredLabel.new(xinshouPO.Dialogue, FontConstConfig.OUR_FONT, 26,  CCSizeMake(320, 120), kCCTextAlignmentLeft);
  end
  self:addChild(self.imageBg);

  if self.text then
    self.text:setPositionXY(xinshouPO.X + 207, xinshouPO.Y + 77);
    self:addChild(self.text)
  end

  self.imageBg:setPositionXY(xinshouPO.X + self.imageBg:getContentSize().width*scaleSize, xinshouPO.Y);


  if GameData.isMusicOn then
    -- local preStep = step - 1;
    -- if analysisHas("Xinshouyindao_Xinshou",preStep) then
    --   local preXinShouPo = analysis("Xinshouyindao_Xinshou",preStep)
    --   if preXinShouPo.Music ~= 0 then
    --    MusicUtils:stopEffect()
    --   end
    -- end
    if xinshouPO.Music ~= 0 then
      MusicUtils:playEffect(xinshouPO.Music,false);
    end
  end 
end

function PersonItem:clean()
  self:removeChildren();
end