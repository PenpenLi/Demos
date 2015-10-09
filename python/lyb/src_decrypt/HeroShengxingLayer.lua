require "main.view.hero.heroHouse.ui.HeroHousePageView";
require "main.view.hero.heroTeam.ui.HeroTeamSlot";

HeroShengxingLayer=class(TouchLayer);

function HeroShengxingLayer:ctor()
  self.class=HeroShengxingLayer;
end

function HeroShengxingLayer:dispose()
  self.armature:dispose();
	HeroShengxingLayer.superclass.dispose(self);
end

function HeroShengxingLayer:initialize(context, generalId)
  self.context = context;
  self.generalId = generalId;
  self.skeleton = self.context.skeleton;
  self.datas = self.context.heroHouseProxy:getGeneralData(self.generalId);
  self.context.pageView:setMoveEnabled(false);
  self:initLayer();
  self.bagItemLayer = nil;

  -- local image = Image.new();
  -- image:loadByArtID(875);
  -- image:setScale(2);
  -- self:addChildAt(image,0);

  --骨骼
  local armature=self.skeleton:buildArmature("shengxing_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  self.slot = HeroProScaleSlot.new();
  self.slot:initialize(self.skeleton,self.datas,makePoint(357,387));
  self.slot:getCard().touchEnabled = true;
  self.slot:getCard().touchChildren = true;
  self.slot:setScale(0.912);
  self:addChild(self.slot);

  local closeButton =self.armature.display:getChildByName("common_copy_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  local text="";
  -- self.next_star_descb=createTextFieldWithTextData(armature:getBone("next_star_descb").textData,text);
  -- self.armature.display:addChild(self.next_star_descb);

  text="悟       性";
  self.descb=createTextFieldWithTextData(armature:getBone("title_1").textData,text);
  self.armature.display:addChild(self.descb);

  text="攻击资质";
  self.title_1=createTextFieldWithTextData(armature:getBone("title_2").textData,text);
  self.armature.display:addChild(self.title_1);

  text="外防资质";
  self.title_2=createTextFieldWithTextData(armature:getBone("title_3").textData,text);
  self.armature.display:addChild(self.title_2);

  text="内防资质";
  self.title_3=createTextFieldWithTextData(armature:getBone("title_4").textData,text);
  self.armature.display:addChild(self.title_3);

  text="生命资质";
  self.title_4=createTextFieldWithTextData(armature:getBone("title_5").textData,text);
  self.armature.display:addChild(self.title_4);

  text="";
  self.descb_1_1=createTextFieldWithTextData(armature:getBone("descb_1_1").textData,text);
  self.armature.display:addChild(self.descb_1_1);

  text="";
  self.descb_2_1=createTextFieldWithTextData(armature:getBone("descb_2_1").textData,text);
  self.armature.display:addChild(self.descb_2_1);

  text="";
  self.descb_3_1=createTextFieldWithTextData(armature:getBone("descb_3_1").textData,text);
  self.armature.display:addChild(self.descb_3_1);

  text="";
  self.descb_4_1=createTextFieldWithTextData(armature:getBone("descb_4_1").textData,text);
  self.armature.display:addChild(self.descb_4_1);

  text="";
  self.descb_5_1=createTextFieldWithTextData(armature:getBone("descb_5_1").textData,text);
  self.armature.display:addChild(self.descb_5_1);

  text="";
  self.descb_1_2=createTextFieldWithTextData(armature:getBone("descb_1_2").textData,text);
  self.armature.display:addChild(self.descb_1_2);

  text="";
  self.descb_2_2=createTextFieldWithTextData(armature:getBone("descb_2_2").textData,text);
  self.armature.display:addChild(self.descb_2_2);

  text="";
  self.descb_3_2=createTextFieldWithTextData(armature:getBone("descb_3_2").textData,text);
  self.armature.display:addChild(self.descb_3_2);

  text="";
  self.descb_4_2=createTextFieldWithTextData(armature:getBone("descb_4_2").textData,text);
  self.armature.display:addChild(self.descb_4_2);

  text="";
  self.descb_5_2=createTextFieldWithTextData(armature:getBone("descb_5_2").textData,text);
  self.armature.display:addChild(self.descb_5_2);

  text="提升材料";
  self.cailiao_descb=createTextFieldWithTextData(armature:getBone("cailiao_descb").textData,text);
  self.armature.display:addChild(self.cailiao_descb);

  text="<content><font color='#FDF46A'>消       耗</font></content>";
  self.silver_descb=createRichMultiColoredLabelWithTextData(armature:getBone("silver_descb").textData,text);
  self.armature.display:addChild(self.silver_descb);

  text="";
  self.silver=createRichMultiColoredLabelWithTextData(armature:getBone("silver").textData,text);
  self.armature.display:addChild(self.silver);

  -- self.armature.display:getChildByName("next_star_descb"):setScale(0.8);
  local button=self.armature.display:getChildByName("common_small_blue_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("提升","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onShengxing,self);
  self.armature.display:addChild(button);

  self:refreshData();
  -- AddUIBackGround(self,875);

  local uiBackImage = Image.new()
  uiBackImage:loadByArtID(875);
  uiBackImage:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChildAt(uiBackImage,0);

  self.armature.display:getChildByName("silver"):setScale(0.8);
  self.armature.display:getChildByName("jinjie_title"):setVisible(false);
end

function HeroShengxingLayer:closeUI(event)

  self.context.pageView:setMoveEnabled(true);
  self.context.heroXinxiRender.heroShengxingLayer = nil;
  self.parent:removeChild(self);
end

function HeroShengxingLayer:onShengxing(event)
  if self.context.heroHouseProxy.Shengxing_Bool then
    return;
  end
  if self.isMax then
    sharedTextAnimateReward():animateStartByString("已经最高星级了呢~");
    return;
  end
  if not self.isCountEnough then
    sharedTextAnimateReward():animateStartByString("提升道具不足了呢~");
    return;
  end
  if not self.isSilverEnough then
    sharedTextAnimateReward():animateStartByString("银两不足了呢~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  
  sendMessage(6,17,{GeneralId=self.generalId});
  self.context.heroHouseProxy.Shengxing_Bool = true;
  if GameData.isMusicOn then
    --MusicUtils:playEffect(10,false)
  end

  if GameVar.tutorStage == TutorConfig.STAGE_1008 then
    GameVar.tutorEndSendMsg = true;
    sendServerTutorMsg({})
    closeTutorUI();
  end

  local starLevel = self.datas.StarLevel;
  local starMax = analysis("Kapai_Kapaiku",self.datas.ConfigId,"star");
  if starLevel >= -1 + starMax then
    self:closeUI();
  end
end

function HeroShengxingLayer:refreshBySilver()
  local starLevel = self.datas.StarLevel;
  local table_data = analysis("Kapai_Kapaiku",self.datas.ConfigId);
  
  local silver = self.context.userCurrencyProxy:getSilver();
  local silver_need = StringUtils:stuff_string_split(table_data.starCost);
  silver_need = tonumber(silver_need[1 + starLevel][2]);
  self.isSilverEnough = silver >= silver_need;
  self.silver:setString("<content><font color='#" .. (self.isSilverEnough and "00FF00" or "FF0000") .. "'>" .. silver_need .."</font></content>");
end

function HeroShengxingLayer:refreshData()
  self.datas = self.context.heroHouseProxy:getGeneralData(self.generalId);
  local starLevel = self.datas.StarLevel;
  local table_data = analysis("Kapai_Kapaiku",self.datas.ConfigId);
  local starMax = table_data.star;
  local wuxing = table_data.wuXing;
  print("HeroShengxingLayer:refreshData",self.datas.ConfigId,starLevel,starMax);
  local isMax = starLevel >= starMax;
  self.isMax = isMax;
  if isMax then
    self:closeUI();
    return;
  end

  -- self.next_star_descb:setString("下一星级   " .. (1 + starLevel));

  self.armature.display:removeChild(self.bagItemLayer);
  self.bagItemLayer = Layer.new();
  self.bagItemLayer:initLayer();
  self.armature.display:addChild(self.bagItemLayer);
  self.bagItems = {};

  local items = {};
  local starExp = StringUtils:lua_string_split(table_data.soul,",")[1];
  local expNeed = StringUtils:stuff_string_split(table_data.starRequest);
  expNeed = tonumber(expNeed[1 + starLevel][2]);
  table.insert(items,{tonumber(starExp),expNeed});

  local commonNeed = 0;
  local commonGet = 0;
  if table_data.commonRequest and "" ~= table_data.commonRequest then
    commonNeed = StringUtils:stuff_string_split(table_data.commonRequest);
    commonNeed = tonumber(commonNeed[1 + starLevel][2]);
    table.insert(items,{table_data.commonItem,commonNeed});
  end
  
  self.isCountEnough = true;
  for k,v in pairs(items) do
    local count = tonumber(v[2]);
    local bagCount = self.context.bagProxy:getItemNum(tonumber(v[1]));
    self.isCountEnough = self.isCountEnough and count <= bagCount;

    local bagItem = BagItem.new();
    bagItem:initialize({UserItemId=0,ItemId=tonumber(v[1]),Count=1,IsUsing=0,Place=0});
    bagItem.touchEnabled=true;
    bagItem.touchChildren=true;
    bagItem:setBackgroundVisible(true);
    bagItem:setPositionXY((-1+k)*(4<=table.getn(items) and 105 or 120),0);
    bagItem:setScale(0.8);
    self.bagItemLayer:addChild(bagItem);
    bagItem:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,bagItem);

    bagItem.bagHasCount = bagCount;
    bagItem.totalNeedCount = count;
    
    table.insert(self.bagItems,bagItem);
    -- bagItem:setTextString((bagCount .. "/" .. count),count <= bagCount and ccc3(255,255,255) or ccc3(255,0,0));
    local bagItemSize = bagItem:getGroupBounds().size;

    local textField=TextField.new(CCLabelTTF:create(bagCount .. "/" .. count,FontConstConfig.OUR_FONT,20));
    local sizeText=textField:getContentSize();
    textField:setColor(CommonUtils:ccc3FromUInt(bagCount >= count and 16710121 or 16711680));
    textField.touchEnable = false;
    textField.touchChildren = false;
    textField:setPositionXY(5+(bagItemSize.width-sizeText.width)/2,-32);
    -- local textFieldContentSize = textField:getContentSize();
    -- local bg = self.skeleton:getBoneTexture9DisplayBySize("xiaozi_bg",nil,makeSize(10+textFieldContentSize.width,textFieldContentSize.height));
    -- bg.touchEnable = false;
    -- bg.touchChildren = false;
    -- bg:setPositionXY(-15+bagItemSize.width-bg:getContentSize().width,0);
    -- bagItem:addChild(bg);

    bagItem:addChild(textField);
  end

  local size = self.bagItemLayer:getGroupBounds().size;
  self.bagItemLayer:setPositionXY(839-150,197);

  self.title_1:setString(0 == analysis("Kapai_Kapaiku",self.datas.ConfigId,"attackWai") and "内攻资质" or "外攻资质");
  self.descb_1_1:setString(starLevel .. "星");
  self.descb_2_1:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,0 == analysis("Kapai_Kapaiku",self.datas.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI));
  self.descb_3_1:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.FANG_YU));
  self.descb_4_1:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.NEI_FANG_YU));
  self.descb_5_1:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.SHENG_MING));

  self.descb_1_2:setString(1+starLevel .. "星");
  self.datas.StarLevel = 1 + self.datas.StarLevel;
  self.descb_2_2:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,0 == analysis("Kapai_Kapaiku",self.datas.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI));
  self.descb_3_2:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.FANG_YU));
  self.descb_4_2:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.NEI_FANG_YU));
  self.descb_5_2:setString(self.context.heroHouseProxy:getChengzhangzhi(self.datas.StarLevel,HeroPropConstConfig.SHENG_MING));
  self.datas.StarLevel = -1 + self.datas.StarLevel;

  local silver = self.context.userCurrencyProxy:getSilver();
  local silver_need = StringUtils:stuff_string_split(table_data.starCost);
  silver_need = tonumber(silver_need[1 + starLevel][2]);
  self.isSilverEnough = silver >= silver_need;
  self.silver:setString("<content><font color='#" .. (self.isSilverEnough and "00FF00" or "FF0000") .. "'>" .. silver_need .."</font></content>");

  self.slot:refreshStar(starLevel);
end

function HeroShengxingLayer:onBagItemTap(event, bagItem)
  local tipBg=LayerColorBackGround:getOpacityBackGround();
  local layer=DetailLayer.new();
  local function closeTip(event)
    if tipBg.parent then
      tipBg.parent:removeChild(tipBg);
    end
    if layer.parent then
      layer.parent:removeChild(layer);
    end
  end
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchTap,closeTip);
  self:addChild(tipBg);
  layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  local size=self.context:getContentSize();
  local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  self:addChild(layer);
end

function HeroShengxingLayer:refreshEffect4Shengxing()
  if self.effect_star and self.effect_star.parent then
    self.effect_star.parent:removeChild(self.effect_star);
    self.effect_star = nil;
  end
  local function onCBFunc()
    if self.effect_star and self.effect_star.parent then
      self.effect_star.parent:removeChild(self.effect_star);
      self.effect_star = nil;
      self.context:setData();
    end
  end
  local data = self.context.heroHouseProxy:getGeneralData(self.generalId);
  local starLevel = data.StarLevel;
  self.effect_star = cartoonPlayer(1099,-41.5*(-1+starLevel)+459,133,1,onCBFunc);
  self:addChild(self.effect_star);

  for k,v in pairs(self.bagItems) do
    local effect_item = cartoonPlayer(1098,44+self.bagItemLayer:getPositionX()+v:getPositionX(),49+self.bagItemLayer:getPositionY()+v:getPositionY(),1);
    self:addChild(effect_item);
  end
end