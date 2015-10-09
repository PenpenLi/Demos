HeroRoundPortrait=class(TouchLayer);

function HeroRoundPortrait:ctor()
  self.class=HeroRoundPortrait;
end

function HeroRoundPortrait:dispose()
	HeroRoundPortrait.superclass.dispose(self);
end

function HeroRoundPortrait:initialize(data, show_name)
  self.data = data;if not self.data.StarLevel then self.data.StarLevel = 1; end
  self.show_name = show_name;
  self:initLayer();
  local isMainGeneral = 1 == self.data.IsMainGeneral;
  local userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
  
  local bg = CommonSkeleton:getCommonBoneTextureDisplay("commonImages/common_round_grid_" .. getSimpleGrade(self.data.Grade));
  self:addChild(bg);
  self:setContentSize(bg:getContentSize());

  -- local clipper = ClippingNodeMask.new(CommonSkeleton:getCommonBoneTextureDisplay("commonImages/common_round_mask"));
  -- clipper:setAlphaThreshold(0.0);
  -- clipper:setPositionXY(21,11)
  -- self:addChild(clipper);

  local img = Image.new();
  -- if isMainGeneral then
  --   img:loadByArtID(analysis("Zhujiao_Zhujiaozhiye",userProxy:getCareer(),"art3"));
  -- else
    img:loadByArtID(analysis("Kapai_Kapaiku",self.data.ConfigId,"art3"));
  -- end
  img:setPositionXY(13,13);
  self:addChild(img);

  local wuxing = CommonSkeleton:getCommonBoneTextureDisplay("commonImages/common_shuxing_" .. (isMainGeneral and analysis("Zhujiao_Zhujiaozhiye",userProxy:getCareer(),"wuXing") or analysis("Kapai_Kapaiku",self.data.ConfigId,"job")));
  wuxing:setScale(0.25);
  wuxing:setPositionXY(-3,80);
  self:addChild(wuxing);
  self.wuxing = wuxing

  local star = analysis("Kapai_Kapaiku", self.data.ConfigId, "star");
  local hero_star = self.data.StarLevel;
  local star_layer = Layer.new();
  star_layer:initLayer();
  self:addChild(star_layer);
  for i=1,star do
    local star_empty = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star_empty");
    star_empty:setScale(0.3);
    star_empty:setPositionXY(-25 * ( -1 + i ) + 25 * ( -1 + star ), 0);
    star_layer:addChild(star_empty);

    if i <= hero_star then
      local star_img = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
      star_img:setScale(0.3);
      star_img:setPositionXY(-25 * ( -1 + i ) + 25 * ( -1 + star ) + 1, 0);
      star_layer:addChild(star_img);
    end
  end
  local size = star_layer:getGroupBounds().size;
  star_layer:setPositionX(58-size.width/2);

  local grade_str = self:getGradeS(self.data.Grade);
  if "" ~= grade_str then
    local grade_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_small_name_bg");
    grade_bg:setPositionXY(73,77);
    self:addChild(grade_bg);

    local textField=TextField.new(CCLabelTTF:create(grade_str, GameConfig.DEFAULT_FONT_NAME, 26));
    textField:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(getSimpleGrade(self.data.Grade))));
    self:addChild(textField);
    textField:setPositionXY(80,75);
  end

  local level_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_circle_bg");
  level_bg:setPositionXY(81,22);
  self:addChild(level_bg);

  local textField=TextField.new(CCLabelTTF:create(self.data.Level, GameConfig.DEFAULT_FONT_NAME, 26));
  self:addChild(textField);
  local textField_size = textField:getContentSize();
  textField:setPositionXY(-textField_size.width/2+97,-textField_size.height/2+38);

  if self.show_name then
    local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanduimingzi_bg");
    self:addChild(bg);
    size = bg:getContentSize();
    bg:setPositionXY(58-size.width/2,-27);
    self.heroNameBG = bg;

    local textField=TextField.new(CCLabelTTF:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),GameConfig.DEFAULT_FONT_NAME, 22));
    textField:setColor(CommonUtils:ccc3FromUInt(3149312));
    self:addChild(textField);
    size = textField:getContentSize();
    textField:setPositionXY(58-size.width/2,-30);
    self.heroName = textField
  end
end

function HeroRoundPortrait:getGradeS(grade)
  local ss = {"","","+1","","+1","+2","","+1","+2","+3",""};
  return ss[grade];
end

function HeroRoundPortrait:showName4RankList()
  local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanduimingzi_bg");
  bg:setScaleX(2.8);
  bg:setScaleY(5);
  bg:setPositionXY(30,10);
  self:addChildAt(bg,0);

  local textField=TextField.new(CCLabelTTFStroke:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),FontConstConfig.OUR_FONT,35,0,ccc3(0,0,0),CCSizeMake(0,0),"left",kCCVerticalTextAlignmentCenter));
  textField:setColor(CommonUtils:ccc3FromUInt(7150363));
  self:addChild(textField);
  textField:setPositionXY(130,63);
  self.heroName = textField

  textField=TextField.new(CCLabelTTFStroke:create("Lv." .. self.data.Level,FontConstConfig.OUR_FONT,35,0,ccc3(0,0,0),CCSizeMake(0,0),"left",kCCVerticalTextAlignmentCenter));
  textField:setColor(CommonUtils:ccc3FromUInt(7150363));
  self:addChild(textField);
  textField:setPositionXY(130,13);
end

function HeroRoundPortrait:showName4RankListDetail()
  local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanduimingzi_bg");
  bg:setScaleX(2.8);
  bg:setScaleY(5);
  bg:setPositionXY(30,10);
  self:addChildAt(bg,0);

  local textField=TextField.new(CCLabelTTFStroke:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),FontConstConfig.OUR_FONT,32,0,ccc3(0,0,0),CCSizeMake(0,0),"left",kCCVerticalTextAlignmentCenter));
  textField:setColor(CommonUtils:ccc3FromUInt(16775398));
  self:addChild(textField);
  textField:setPositionXY(125,63);
  self.heroName = textField

  textField=TextField.new(CCLabelTTFStroke:create("Lv." .. self.data.Level,FontConstConfig.OUR_FONT,32,0,ccc3(0,0,0),CCSizeMake(0,0),"left",kCCVerticalTextAlignmentCenter));
  textField:setColor(CommonUtils:ccc3FromUInt(16114609));
  self:addChild(textField);
  textField:setPositionXY(125,13);
end

function HeroRoundPortrait:showName4Langyaling()
  local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_mingzi_bg_2");
  self:addChild(bg);
  size = bg:getContentSize();
  bg:setPositionXY(58-size.width/2,-32);
  self.heroNameBG = bg;

  local textField=TextField.new(CCLabelTTF:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),GameConfig.DEFAULT_FONT_NAME, 24));
  textField:setColor(CommonUtils:ccc3FromUInt(16777215));
  self:addChild(textField);
  size = textField:getContentSize();
  textField:setPositionXY(58-size.width/2,-30);
  self.heroName = textField
end

function HeroRoundPortrait:showName4Yongbing()
  local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_mingzi_bg");
  self:addChild(bg);
  size = bg:getContentSize();
  bg:setPositionXY(58-size.width/2+10,-32+2);
  self.heroNameBG = bg;

  local textField=TextField.new(CCLabelTTF:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),GameConfig.DEFAULT_FONT_NAME, 22));
  textField:setColor(CommonUtils:ccc3FromUInt(16777215));
  self:addChild(textField);
  size = textField:getContentSize();
  textField:setPositionXY(58-size.width/2,-30);
  self.heroName = textField
end

function HeroRoundPortrait:showName4YongbingOnBangpai(context)
  local offset = 0;
  if context and context.notificationData and context.notificationData.funcType == "TenCountry" then
    offset = -15;
  else
    offset = -30;
  end

  local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_red_bg");
  bg:setScale(0.7);
  self:addChild(bg);
  size = bg:getContentSize();
  bg:setPositionXY(47-size.width*0.7/2+10,offset+105);
  
  local bg = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
  bg:setScale(0.7);
  self:addChild(bg);
  size = bg:getContentSize();
  bg:setPositionXY(9-size.width*0.7/2+10,offset+102);

  local silver = context.familyProxy:getFetchedSilverByGeneralIDOnGuyong(self.data.GeneralId);
  local textField=TextField.new(CCLabelTTF:create(silver,GameConfig.DEFAULT_FONT_NAME, 22));
  textField:setColor(CommonUtils:ccc3FromUInt(16777215));
  self:addChild(textField);
  size = textField:getContentSize();
  textField:setPositionXY(45,offset+103);
  self.data.silver_need_for_guyong = silver;
end

function HeroRoundPortrait:showName4Paiqian()
  self.heroNameBG:setVisible(false);
  self.heroName:setVisible(false);

  local textField=TextField.new(CCLabelTTF:create(isMainGeneral and userProxy:getUserName() or analysis("Kapai_Kapaiku", self.data.ConfigId, "name"),GameConfig.DEFAULT_FONT_NAME, 24));
  textField:setColor(CommonUtils:ccc3FromUInt(16777215));
  self:addChild(textField);
  size = textField:getContentSize();
  textField:setPositionXY(58-size.width/2,-33);
  self.heroName = textField
end