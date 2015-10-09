HeroProScaleSlot=class(Layer);

function HeroProScaleSlot:ctor()
  self.class=HeroProScaleSlot;
end

function HeroProScaleSlot:dispose()
log("zhangke--------HeroProScaleSlot:dispose")
  self.card:stopAllActions();
  
  self:removeChildren();
  HeroProScaleSlot.superclass.dispose(self);
end

function HeroProScaleSlot:initialize(skeleton, datas, pos)
  self.skeleton = skeleton;
	self.datas = datas;
  self.pos = pos;
  self.scaleFactor = 0.55;
  self.makeSize = makeSize(648,1018);----makeSize(516,814);
  self.offset_x = -30;
  self.offset_y = -20;
	self:initLayer();

  local isMainGeneral = 1 == self.datas.IsMainGeneral;

  self.card = DisplayNode:create();
  self.card:setContentSize(self.makeSize);
  self.card:setScale(self.scaleFactor);
  self.card:setAnchorPoint(makePoint(0.5, 0.5));
  self.card:setPosition(pos);
  self:addChild(self.card);

  local card = Image.new();
  card:loadByArtID(tonumber(analysis("Kapai_Kapaiku",self.datas.ConfigId,"art1d")));
  card:setPositionXY(28+self.offset_x,20+self.offset_y);
  card.touchEnabled=false;
  card.touchChildren=false;
  self.card:addChildAt(card,0);

  local simpleGrade = getSimpleGrade(self.datas.Grade);
  local poss = {{15,121},{634,121},{15,970},{15,13}};
  for i = 1,4 do
    local frame = CommonSkeleton:getBoneTexture9Display("hero_frame/common_big_card_color_bg_" .. simpleGrade .. "_" .. (2 == i and 1 or i));
    frame:setPositionXY(poss[i][1]+self.offset_x,poss[i][2]+self.offset_y);
    self.card:addChild(frame);
    self["color_frame_" .. i] = frame;
  end

  frame = CommonSkeleton:getBoneTexture9Display("hero_frame/common_big_card_color_" .. self.datas.Grade);
  if frame then
    frame:setPositionXY(36+self.offset_x,33+self.offset_y);
    self.card:addChild(frame);
    self.wenzi_frame = frame
  end

  local hero_frame_top = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_hero_frame_top");
  hero_frame_top:setPositionXY(0+self.offset_x,974+self.offset_y);
  self.card:addChild(hero_frame_top);

  local hero_frame_left = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_hero_frame_left");
  hero_frame_left:setPositionXY(662+self.offset_x,119+self.offset_y);
  self.card:addChild(hero_frame_left);

  local hero_frame_right = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_hero_frame_right");
  hero_frame_right:setPositionXY(13+self.offset_x,119+self.offset_y);
  self.card:addChild(hero_frame_right);

  local hero_frame_bottom = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_hero_frame_bottom");
  hero_frame_bottom:setPositionXY(-6+self.offset_x,2+self.offset_y);
  self.card:addChild(hero_frame_bottom);

  -- local hero_frame_pattern = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_hero_frame_pattern");
  -- hero_frame_pattern:setPositionXY(314,306);
  -- self.card:addChild(hero_frame_pattern);

  local star = analysis("Kapai_Kapaiku", self.datas.ConfigId, "star");
  local hero_star = self.datas.StarLevel and self.datas.StarLevel or star;
  self.stars = {};
  while 0 < star do
    star = -1 + star;

    local star_empty = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star_empty");
    star_empty:setPositionXY(-80 * star + 575+self.offset_x, 32+self.offset_y);
    self.card:addChild(star_empty);

    if -1 + hero_star >= star then
      local star_img = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
      star_img:setPositionXY(-80 * star + 576+self.offset_x, 33+self.offset_y);
      self.card:addChild(star_img);
      table.insert(self.stars, star_img);
    end
  end
  
  local name;
  if isMainGeneral then
    -- name = "主角";
    name = Facade:getInstance():retrieveProxy(UserProxy.name):getUserName();
    name = "<content><font color='#FFF5CB'>" .. name .. "</font></content>"
    self.nameTextField=createAutosizeMultiColoredLabelWithTextData({x=0,y=0,size=28,width=30,height=300,alignment=kCCTextAlignmentLeft},name);
    --TextField.new(CCLabelTTF:create(str,FontConstConfig.OUR_FONT,32));
    local size = self.nameTextField:getContentSize();
    self.nameTextField:setPositionXY(15+self.offset_x,470 - size.height+self.offset_y);
    self.card:addChild(self.nameTextField);
  else
    name = analysis("Kapai_Kapaiku",self.datas.ConfigId,"name");
    local str = "";
    _count = -1;
    while (-1-string.len(name)) < _count do
      str = str .. string.sub(name, -2 + _count, _count) .. "\n";
      log("->" .. _count .. " " .. (-2 + _count) .. " " .. string.sub(name, -2 + _count, _count));
      _count = -3 + _count;
    end

    local pLabelFont=BitmapTextField.new(str,"yingxiongmingzi");
    local size = pLabelFont:getContentSize();
    pLabelFont:setPositionXY(40+self.offset_x,770 - size.height+self.offset_y);
    pLabelFont:setScale(1.6);
    self.card:addChild(pLabelFont);
  end

  local wuxing = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_" .. (isMainGeneral and analysis("Zhujiao_Zhujiaozhiye",self.datas.ConfigId,"wuXing") or analysis("Kapai_Kapaiku",self.datas.ConfigId,"job")));
  wuxing:setScale(0.8);
  wuxing:setPositionXY(30+self.offset_x,900+self.offset_y);
  self.card:addChild(wuxing);
end

function HeroProScaleSlot:play()
  local winSize = CCDirector:sharedDirector():getWinSize();
  log(">>>>>>>>>>>>>>>>>>>"..winSize.width.." "..winSize.height);
  local factor;
  if self.makeSize.height / self.makeSize.width < winSize.width / winSize.height then
    factor = winSize.height / self.makeSize.width;
  else
    factor = winSize.width / self.makeSize.height;
  end
  factor = 0.9 * factor;
  local actions = CCArray:create();
  actions:addObject(CCEaseSineOut:create(CCMoveTo:create(0.3, ccp(winSize.width / 2, winSize.height / 2))));
  actions:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, factor, factor)));
  actions:addObject(CCEaseSineOut:create(CCRotateTo:create(0.3, -90)));
  self.card:runAction(CCSpawn:create(actions));
end

function HeroProScaleSlot:getCard()
    return self.card;
end

function HeroProScaleSlot:refreshStar(hero_star)
  for k,v in pairs(self.stars) do
    v.parent:removeChild(v);
  end
  self.stars = {};

  local star = analysis("Kapai_Kapaiku", self.datas.ConfigId, "star");
  while 0 < star do
    star = -1 + star;

    if -1 + hero_star >= star then
      local star_img = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
      star_img:setPositionXY(-80 * star + 576+self.offset_x, 33+self.offset_y);
      self.card:addChild(star_img);
      table.insert(self.stars, star_img);
    end
  end
end

function HeroProScaleSlot:refreshGrade(grade)
  -- local color_frame_idx = self.card:getChildIndex(self.color_frame_1);
  for i = 1,4 do
    self.card:removeChild(self["color_frame_" .. i]);
    self.color_frame = nil;
  end

  if self.wenzi_frame then
    self.card:removeChild(self.wenzi_frame);
    self.wenzi_frame = nil;
  end

  local simpleGrade = getSimpleGrade(grade);
  local poss = {{15,121},{634,121},{15,970},{15,13}};
  for i = 1,4 do
    local frame = CommonSkeleton:getBoneTexture9Display("hero_frame/common_big_card_color_bg_" .. simpleGrade .. "_" .. (2 == i and 1 or i));
    frame:setPositionXY(poss[i][1]+self.offset_x,poss[i][2]+self.offset_y);
    self.card:addChildAt(frame,1);
    self["color_frame_" .. i] = frame;
  end

  frame = CommonSkeleton:getBoneTexture9Display("hero_frame/common_big_card_color_" .. grade);
  if frame then
    frame:setPositionXY(36+self.offset_x,33+self.offset_y);
    self.card:addChildAt(frame,5);
    self.wenzi_frame = frame;
  end
end