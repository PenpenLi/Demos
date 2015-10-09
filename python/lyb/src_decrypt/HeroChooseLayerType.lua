require "main.view.hero.heroHouse.ui.HeroHousePageView"

HeroChooseLayerType={};
HeroChooseLayerType.SHENGJI = 1;
HeroChooseLayerType.JINJIE = 2;

HeroChooseLayer=class(TouchLayer);

function HeroChooseLayer:ctor()
  self.class=HeroChooseLayer;
end

function HeroChooseLayer:dispose()
  self.armature:dispose();
  self.armature_qinghua_shengji:dispose();
	HeroChooseLayer.superclass.dispose(self);
end

function HeroChooseLayer:initialize(context, generalId, choose_type)
  self.context = context;
  self.generalId = generalId;
  self.choose_type = choose_type;
  print(self.generalId);
  self.data = self.context.heroHouseProxy:getGeneralData(self.generalId);
  self.skeleton = self.context.skeleton;
  self.needSilver = 0;

  self:initLayer();
  local size=Director:sharedDirector():getWinSize();
  self:setContentSize(makeSize(size.width,size.height));

  local heroHouseProxy = self.context.heroHouseProxy;
  self.chooseItems = {};

  local image = Image.new();
  image:loadByArtID(382);
  image:setScale(2);
  self:addChildAt(image,0);
  
  --骨骼
  local armature=self.skeleton:buildArmature("heroHouse_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  self.cardCon = self.armature.display:getChildByName("menueRender");
  self.cardCon:setVisible(false);

  self.button = self.armature.display:getChildByName("common_small_blue_button");
  self.button:setVisible(false);

  self.armature.display:getChildByName("title"):setVisible(false);

  function onLeftTap(heroId)
    local curPage = self.pageView:getCurrentPage();
    if curPage > 1 then
      self.pageView:setCurrentPage(curPage - 1);
    end;
  end
  function onRightTap(heroId)
    local curPage = self.pageView:getCurrentPage();
    local maxPage = self.pageView:getCurrentPage();
    if curPage < self.pageView.maxPageNum then
      self.pageView:setCurrentPage(curPage + 1);
    end; 
  end

  local leftBtn = SingleButton:create(self.armature.display:getChildByName("common_copy_leftArrow_button"),onLeftTap);
  local rightBtn = SingleButton:create(self.armature.display:getChildByName("common_copy_rightArrow_button"),onRightTap);

  local closeButton =self.armature.display:getChildByName("close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  self.context.pageView:setMoveEnabled(false);


  --骨骼
  local armature_qinghua_shengji=self.skeleton:buildArmature("qinghua_shengji_layer");
  armature_qinghua_shengji.animation:gotoAndPlay("f1");
  armature_qinghua_shengji:updateBonesZ();
  armature_qinghua_shengji:update();
  self.armature_qinghua_shengji=armature_qinghua_shengji;
  self:addChild(self.armature_qinghua_shengji.display);

  self.armature_qinghua_shengji.display:getChildByName("levelUpArrow"):setScale(0.6);

  local portrait = HeroRoundPortrait.new();
  portrait:initialize(self.data);
  portrait:setScale(0.8);
  portrait:setPositionX(115);
  self.armature_qinghua_shengji.display:addChild(portrait);

  local name = 1 == self.data.IsMainGeneral and "主角" or analysis("Kapai_Kapaiku",self.data.ConfigId,"name");
  local pLabelFont=BitmapTextField.new(name,"yingxiongmingzi");
  pLabelFont:setPositionXY(230,60);
  self.armature_qinghua_shengji.display:addChild(pLabelFont);

  local text="";
  self.pg_descb=createTextFieldWithTextData(armature_qinghua_shengji:getBone("pg_descb").textData,text);
  self.armature_qinghua_shengji.display:addChild(self.pg_descb);

  text="";
  self.descb=createTextFieldWithTextData(armature_qinghua_shengji:getBone("descb").textData,text);
  self.armature_qinghua_shengji.display:addChild(self.descb);

  local button=armature_qinghua_shengji.display:getChildByName("btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature_qinghua_shengji.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_red_button_normal","commonButtons/common_red_button_down",CommonButtonTouchable.BUTTON);
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
  self.armature_qinghua_shengji.display:addChild(button);

  local pg_name = "";
  if HeroChooseLayerType.SHENGJI == self.choose_type then

    text="";
    self.lvImg_1=createTextFieldWithTextData(armature_qinghua_shengji:getBone("lvImg_1").textData,text);
    self.armature_qinghua_shengji.display:addChild(self.lvImg_1);
    
    text="";
    self.lvImg_2=createTextFieldWithTextData(armature_qinghua_shengji:getBone("lvImg_2").textData,text);
    self.armature_qinghua_shengji.display:addChild(self.lvImg_2);

    self.armature_qinghua_shengji.display:getChildByName("purple_left"):setVisible(false);
    self.armature_qinghua_shengji.display:getChildByName("purple_center"):setVisible(false);
    self.armature_qinghua_shengji.display:getChildByName("purple_right"):setVisible(false);

    button:initializeBMText("升级","anniutuzi");
    pg_name= "advaced_progress_bar/advaced_progress_bar_blue";

  elseif HeroChooseLayerType.JINJIE == self.choose_type then

    text="";
    self.lvImg_1=createRichMultiColoredLabelWithTextData(armature_qinghua_shengji:getBone("lvImg_1").textData,text);
    self.armature_qinghua_shengji.display:addChild(self.lvImg_1);
    
    text="";
    self.lvImg_2=createRichMultiColoredLabelWithTextData(armature_qinghua_shengji:getBone("lvImg_2").textData,text);
    self.armature_qinghua_shengji.display:addChild(self.lvImg_2);

    self.armature_qinghua_shengji.display:getChildByName("lvImg_1"):setVisible(false);
    self.armature_qinghua_shengji.display:getChildByName("lvImg_2"):setVisible(false);

    self.armature_qinghua_shengji.display:getChildByName("blue_left"):setVisible(false);
    self.armature_qinghua_shengji.display:getChildByName("blue_center"):setVisible(false);
    self.armature_qinghua_shengji.display:getChildByName("blue_right"):setVisible(false);

    button:initializeBMText("进阶","anniutuzi");
    pg_name= "advaced_progress_bar/advaced_progress_bar_purple";
  end
  self.advancedProgressBarDouble = AdvacedProgressBarDouble.new();
  self.advancedProgressBarDouble:initialize(self.skeleton, pg_name, self.skeleton, "advaced_progress_bar/advaced_progress_bar_green", 560);
  self.advancedProgressBarDouble:setPositionXY(220,38);
  self.armature_qinghua_shengji.display:addChildAt(self.advancedProgressBarDouble,3);

  if HeroChooseLayerType.SHENGJI == self.choose_type then
    local exp = 0;
    local exp_total = 0;
    if analysisHas(self.context:getExcelName(self.generalId),1+self.data.Level) then
      exp = self.context.heroHouseProxy:getExpByGeneralID(self.generalId);
      exp_total = analysis(self.context:getExcelName(self.generalId),1+self.data.Level,"exp");
    else
      local exp_max = analysis(self.context:getExcelName(self.generalId),self.data.Level,"exp");
      exp = exp_max;
      exp_total = exp_max;
    end
    self.advancedProgressBarDouble:setProgress(exp,exp_total);
    self.pg_descb:setString("经验: " .. exp .. "/" .. exp_total);

    self.lvImg_1:setString(self.data.Level);
    self.lvImg_2:setString(self.data.Level);
    self.descb:setString("消耗0银两");

  elseif HeroChooseLayerType.JINJIE == self.choose_type then

    local hunli;
    local hunli_max;
    if analysisHas("Kapai_KapaiyanseduiyingID",1+self.data.Grade) then
      hunli = self.context.heroHouseProxy:getHunliByGeneralID(self.generalId);
      hunli_max = analysis("Kapai_KapaiyanseduiyingID",1+self.data.Grade,"xuQiu");
    else
      hunli = analysis("Kapai_KapaiyanseduiyingID",self.data.Grade,"xuQiu");
      hunli_max = hunli;
    end
    self.advancedProgressBarDouble:setProgressTest(hunli,hunli_max);
    self.pg_descb:setString("魂力: " .. hunli .. "/" .. hunli_max);

    local tb = analysisByName("Kapai_Kapaiyanse","yanseId",self.data.Grade);
    local str = "";
    for k,v in pairs(tb) do
      str = v.yanse;
      break;
    end
    str = "<content><font color='" .. getColorByQuality(getSimpleGrade(self.data.Grade),true) .. "'>" .. str .. "</font></content>";

    self.lvImg_1:setString(str);
    self.lvImg_2:setString(str);
    self.lvImg_1:setPositionXY(self.lvImg_1:getPositionX(),2+self.lvImg_1:getPositionY());
    self.lvImg_2:setPositionXY(-40+self.lvImg_2:getPositionX(),2+self.lvImg_2:getPositionY());
  end
end

function HeroChooseLayer:refreshPageViewData(itemTb)
  print("+->");
  for k,v in pairs(itemTb) do
    print(k,v.GeneralId);
  end
  self.pageView = HeroHousePageView:create(self,itemTb,nil,self.onCardTap);
  self.pageView:setPositionXY(95, -390);
  self.armature.display:addChildAt(self.pageView,2);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(111,720));
  layerColor:setPositionX(0);
  self.armature.display:addChildAt(layerColor,3);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(111,720));
  layerColor:setPositionX(1169);
  self.armature.display:addChildAt(layerColor,3);
end

function HeroChooseLayer:onCardTap(items, heroHouseSlot)
  print(items.GeneralId);
  for k,v in pairs(self.chooseItems) do
    if items.GeneralId == v.GeneralId then
      table.remove(self.chooseItems, k);
      heroHouseSlot:refreshCardSelectImg();
      self:refreshOnChoose();
      return;
    end
  end
  table.insert(self.chooseItems, items);
  heroHouseSlot:refreshCardSelectImg();
  if not self:refreshOnChoose() then
    table.remove(self.chooseItems, table.getn(self.chooseItems));
    heroHouseSlot:refreshCardSelectImg();
  end
end

function HeroChooseLayer:closeUI(event)
  self.context.pageView:setMoveEnabled(true);
  self.parent:removeChild(self);
end

function HeroChooseLayer:onButtonTap(event)
  if HeroChooseLayerType.SHENGJI == self.choose_type then

    if self.needSilver > self.context.userCurrencyProxy:getSilver() then
      sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
      return;
    end
    local cache = self.context.heroHouseProxy.shengjiTargetArrayCache;
    if nil == cache or 0 == table.getn(cache) then
      sharedTextAnimateReward():animateStartByString("没有选择卡牌哦 ~");
      return;
    end
    local data = {};
    for k,v in pairs(cache) do
      table.insert(data, {GeneralId = v});
    end
    if 0 < table.getn(data) then
      initializeSmallLoading();
      for k,v in pairs(data) do
        print(k,v,v.GeneralId);
      end
      sendMessage(6,11,{GeneralId=self.generalId,GeneralIdArray=data});
    end

  elseif HeroChooseLayerType.JINJIE == self.choose_type then
    
    if self.needSilver > self.context.userCurrencyProxy:getSilver() then
      sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
      return;
    end
    local cache = self.context.heroHouseProxy.jinjieTargetArrayCache;
    if nil == cache or 0 == table.getn(cache) then
      sharedTextAnimateReward():animateStartByString("没有选择卡牌哦 ~");
      return;
    end
    local data = {};
    for k,v in pairs(cache) do
      table.insert(data, {GeneralId = v});
    end
    if 0 < table.getn(data) then
      initializeSmallLoading();
      for k,v in pairs(data) do
        print(k,v,v.GeneralId);
      end
      sendMessage(6,10,{GeneralId=self.generalId,GeneralIdArray=data});
    end

  end
  self:closeUI();
end

function HeroChooseLayer:refreshOnChoose()
  if HeroChooseLayerType.SHENGJI == self.choose_type then
    return self:refreshShengji();
  elseif HeroChooseLayerType.JINJIE == self.choose_type then
    return self:refreshJinjie();
  end
end

function HeroChooseLayer:cacheShengjiData()
  local data = {};
  for k,v in pairs(self.chooseItems) do
    if v then
      table.insert(data, v.GeneralId);
    end
  end

  local exp = 0;
  --// 经验=int(基础经验*（1+1%*（等级-1）+（颜色-1）*5%）)
  for k,v in pairs(self.chooseItems) do
    local slot_data = self.context.heroHouseProxy:getGeneralData(v.GeneralId);
    local jichujingyan = self.context.heroHouseProxy:getExpByGeneralID(v.GeneralId);
    local slot_exp = analysis("Kapai_Kapaiku", self.chooseItems[k].ConfigId, "eatexp");
    slot_exp = math.floor(slot_exp * (1+0.01*(slot_data.Level-1)+(slot_data.Grade-1)*0.05));
    exp = exp + slot_exp;
  end
  self.needSilver = 1 == self.data.IsMainGeneral and 0 or exp * analysis("Xishuhuizong_Xishubiao",1032,"constant");

  local _general_level = self.data.Level;
  local _general_exp = self.context.heroHouseProxy:getExpByGeneralID(self.generalId);
  local _level = _general_level;
  _general_exp = _general_exp + exp;
  while analysisHas(self.context:getExcelName(self.generalId), 1 + _general_level) do
    local _needExp = analysis(self.context:getExcelName(self.generalId), 1 + _general_level, "exp");
    if 0 <= _general_exp - _needExp then
      _level = 1 + _level;
      _general_exp = _general_exp - _needExp;
    end
    _general_level = 1 + _general_level;
  end

  local mainGeneralData = self.context.heroHouseProxy:getMainGeneral();
  if mainGeneralData.GeneralId == self.generalId then

  else
    if mainGeneralData.Level < _level then
      sharedTextAnimateReward():animateStartByString("卡牌等级不能超过主角等级呢~");
      return false;
    end
  end
  
  self.context.heroHouseProxy.shengjiGeneralIDCache = self.generalId;
  self.context.heroHouseProxy.shengjiTargetArrayCache = data;
  self.context.heroHouseProxy.shengjiLevelCache = _level;
  self.context.heroHouseProxy.shengjiExpCache = _general_exp;
  self.context.heroHouseProxy.shengjiTotalExpCache = exp;
  return true;
end

function HeroChooseLayer:refreshShengji()
  if not self:cacheShengjiData() then
    return false;
  end
  local exp = 0;
  local exp_total = 0;
  if analysisHas(self.context:getExcelName(self.generalId),1+self.context.heroHouseProxy.shengjiLevelCache) then
    exp = self.context.heroHouseProxy.shengjiExpCache;
    exp_total = analysis(self.context:getExcelName(self.generalId),1+self.context.heroHouseProxy.shengjiLevelCache,"exp");
  else
    local exp_max = analysis(self.context:getExcelName(self.generalId),self.data.Level,"exp");
    exp = exp_max;
    exp_total = exp_max;
  end
  self.advancedProgressBarDouble:setProgressTest(exp,exp_total);
  self.pg_descb:setString("经验: " .. exp .. "/" .. exp_total);

  self.lvImg_2:setString(self.context.heroHouseProxy.shengjiLevelCache);
  self.descb:setString("消耗" .. self.needSilver .."银两");
  return true;
end

function HeroChooseLayer:cacheJinjieData()
  local data = {};
  for k,v in pairs(self.chooseItems) do
    if v then
      table.insert(data, v.GeneralId);
    end
  end

  local exp = 0;
  local slot_data = self.context.heroHouseProxy:getGeneralData(self.eneralId);
  for k,v in pairs(self.chooseItems) do
    local slot_exp = analysis("Kapai_KapaiyanseduiyingID", self.chooseItems[k].Grade, "cost");
    exp = exp + slot_exp;
  end
  self.needSilver = 1 == self.data.IsMainGeneral and 0 or exp * analysis("Xishuhuizong_Xishubiao",1033,"constant");

  local _grade_level = self.data.Grade;
  local _grade_exp = self.context.heroHouseProxy:getHunliByGeneralID(self.generalId);
  local _level = _grade_level;
  _grade_exp = _grade_exp + exp;
  while analysisHas("Kapai_KapaiyanseduiyingID", 1 + _grade_level) do
    local _needExp = analysis("Kapai_KapaiyanseduiyingID", 1 + _grade_level, "xuQiu");
    if 0 <= _grade_exp - _needExp then
      _level = 1 + _level;
      _grade_exp = _grade_exp - _needExp;
    end
    _grade_level = 1 + _grade_level;
  end

  self.context.heroHouseProxy.jinjieGeneralIDCache = self.generalId;
  self.context.heroHouseProxy.jinjieTargetArrayCache = data;
  self.context.heroHouseProxy.jinjieLevelCache = _level;
  self.context.heroHouseProxy.jinjieExpCache = _grade_exp;
  self.context.heroHouseProxy.jinjieTotalExpCache = exp;
end

function HeroChooseLayer:refreshJinjie()
  self:cacheJinjieData();
  local exp = 0;
  local exp_total = 0;
  if analysisHas("Kapai_KapaiyanseduiyingID",1+self.context.heroHouseProxy.jinjieLevelCache) then
    exp = self.context.heroHouseProxy.jinjieExpCache;
    exp_total = analysis("Kapai_KapaiyanseduiyingID",1+self.context.heroHouseProxy.jinjieLevelCache,"xuQiu");
  else
    local exp_max = analysis("Kapai_KapaiyanseduiyingID",self.data.Level,"xuQiu");
    exp = exp_max;
    exp_total = exp_max;
  end
  self.advancedProgressBarDouble:setProgressTest(exp,exp_total);
  self.pg_descb:setString("魂力: " .. exp .. "/" .. exp_total);

  local tb = analysisByName("Kapai_Kapaiyanse","yanseId",self.context.heroHouseProxy.jinjieLevelCache);
  local str = "";
  for k,v in pairs(tb) do
    str = v.yanse;
    break;
  end
  self.lvImg_2:setString("<content><font color='" .. getColorByQuality(getSimpleGrade(self.context.heroHouseProxy.jinjieLevelCache),true) .. "'>" .. str .. "</font></content>");
  self.descb:setString("消耗" .. self.needSilver .."银两");
  return true;
end