HeroJinjieLayer=class(TouchLayer);

function HeroJinjieLayer:ctor()
  self.class=HeroJinjieLayer;
end

function HeroJinjieLayer:dispose()
  self.armature:dispose();
  HeroJinjieLayer.superclass.dispose(self);
end

function HeroJinjieLayer:initialize(context, generalId)
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

  text="品       质";
  self.descb=createTextFieldWithTextData(armature:getBone("title_1").textData,text);
  self.armature.display:addChild(self.descb);

  text="攻       击";
  self.title_1=createTextFieldWithTextData(armature:getBone("title_2").textData,text);
  self.armature.display:addChild(self.title_1);

  text="外       防";
  self.title_2=createTextFieldWithTextData(armature:getBone("title_3").textData,text);
  self.armature.display:addChild(self.title_2);

  text="内       防";
  self.title_3=createTextFieldWithTextData(armature:getBone("title_4").textData,text);
  self.armature.display:addChild(self.title_3);

  text="生       命";
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

  text="进阶材料";
  self.cailiao_descb=createTextFieldWithTextData(armature:getBone("cailiao_descb").textData,text);
  self.armature.display:addChild(self.cailiao_descb);

  text="";
  self.level_descb=createRichMultiColoredLabelWithTextData(armature:getBone("level_need_descb").textData,text);
  self.armature.display:addChild(self.level_descb);

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
  button:initializeBMText("进阶","anniutuzi");
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
  self.armature.display:getChildByName("shengxing_title"):setVisible(false);
end

function HeroJinjieLayer:closeUI(event)
  self.context.pageView:setMoveEnabled(true);
  self.context.heroXinxiRender.heroJinjieLayer = nil;
  self.parent:removeChild(self);
  if GameVar.tutorStage == TutorConfig.STAGE_1004 then
    print("GameVar.tutorStage == TutorConfig.STAGE_1004")
    openTutorUI({x=1104, y=620, width = 80, height = 80, alpha = 125});

  end

end

function HeroJinjieLayer:onShengxing(event)
  if self.context.heroHouseProxy.Jinjie_Bool then
    return;
  end
  if self.isMax then
    sharedTextAnimateReward():animateStartByString("已经最高品质了呢~");
    return;
  end
  if not self.isCountEnough then
    sharedTextAnimateReward():animateStartByString("进阶道具不足了呢~");
    return;
  end
  if not self.isSilverEnough then
    sharedTextAnimateReward():animateStartByString("银两不足了呢~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  if not self.isLevelEnough then
    sharedTextAnimateReward():animateStartByString("等级不足了呢~");
    return;
  end
  if GameVar.tutorStage == TutorConfig.STAGE_1004 then
    openTutorUI({x=1106, y=607, width = 78, height = 74, alpha = 125});--, showPerson = true
    sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100407, BooleanValue = 0})
  end
  
  sendMessage(6,10,{GeneralId=self.generalId});
  self.context.heroHouseProxy.Jinjie_Bool = true;

  if not analysisHas("Kapai_KapaiyanseduiyingID",1 + self.datas.Grade) then
    self:closeUI();
  end
end

function HeroJinjieLayer:refreshData()
  self.datas = self.context.heroHouseProxy:getGeneralData(self.generalId);
  self.isMax = not analysisHas("Kapai_KapaiyanseduiyingID",1 + self.datas.Grade);
  if self.isMax then
    self:closeUI();
    return;
  end

  -- self.next_star_descb:setString("下一星级   " .. (1 + starLevel));
  local grade_tb_data = analysis("Kapai_KapaiyanseduiyingID",1 + self.datas.Grade);
  local _grade_level = self.datas.Grade;
  local _exp_need = grade_tb_data.xuQiu;

  self.armature.display:removeChild(self.bagItemLayer);
  self.bagItemLayer = Layer.new();
  self.bagItemLayer:initLayer();
  self.armature.display:addChild(self.bagItemLayer);
  self.bagItems = {};

  local items = StringUtils:stuff_string_split(_exp_need);
  local itemID = tonumber(items[1][1]);
  local count = tonumber(items[1][2]);-- - _grade_exp;
  self.isCountEnough = true;

  local bagCount = self.context.bagProxy:getItemNum(itemID);
  self.isCountEnough = self.isCountEnough and count <= bagCount;
  local bagItem = BagItem.new();
  bagItem:initialize({UserItemId=0,ItemId=itemID,Count=1,IsUsing=0,Place=0});

  bagItem.bagHasCount = bagCount;
  bagItem.totalNeedCount = count;
  
  bagItem.touchEnabled=true;
  bagItem.touchChildren=true;
  bagItem:setBackgroundVisible(true);
  bagItem:setPositionXY(0,0);
  bagItem:setScale(0.8);
  self.bagItemLayer:addChild(bagItem);
  bagItem:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,bagItem);
  table.insert(self.bagItems,bagItem);
  -- bagItem:setTextString((bagCount .. "/" .. count),count <= bagCount and ccc3(255,255,255) or ccc3(255,0,0));
  local bagItemSize = bagItem:getGroupBounds().size;

  local textField=TextField.new(CCLabelTTF:create(bagCount .. "/" .. count,FontConstConfig.OUR_FONT,20));
  local sizeText=textField:getContentSize();
  textField:setColor(CommonUtils:ccc3FromUInt(bagCount >= count and 16710121 or 16711680));
  textField.touchEnable = false;
  textField.touchChildren = false;
  textField:setPositionXY(5+bagItem:getPositionX()+(bagItemSize.width-sizeText.width)/2,-32);

  -- local textFieldContentSize = textField:getContentSize();
  -- local bg = self.skeleton:getBoneTexture9DisplayBySize("xiaozi_bg",nil,makeSize(10+textFieldContentSize.width,textFieldContentSize.height));
  -- bg.touchEnable = false;
  -- bg.touchChildren = false;
  -- bg:setPositionXY(-15+bagItemSize.width-bg:getContentSize().width,0);
  -- bagItem:addChild(bg);

  bagItem:addChild(textField);

  local size = self.bagItemLayer:getGroupBounds().size;
  self.bagItemLayer:setPositionXY(869-150,197);

  self.descb_1_1:setString(getHeroColorStringByGrade(self.datas.Grade));
  self.descb_1_1:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(getSimpleGrade(self.datas.Grade))));
  self.descb_2_1:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,0 == analysis("Kapai_Kapaiku",self.datas.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI)));
  self.descb_3_1:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.FANG_YU)));
  self.descb_4_1:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.NEI_FANG_YU)));
  self.descb_5_1:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.SHENG_MING)));

  self.descb_1_2:setString(getHeroColorStringByGrade(1+self.datas.Grade));
  self.descb_1_2:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(getSimpleGrade(1+self.datas.Grade))));
  self.datas.Grade = 1 + self.datas.Grade;
  self.descb_2_2:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,0 == analysis("Kapai_Kapaiku",self.datas.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI)));
  self.descb_3_2:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.FANG_YU)));
  self.descb_4_2:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.NEI_FANG_YU)));
  self.descb_5_2:setString(math.ceil(self.context.heroHouseProxy:getZongPropValueWithPer(self.generalId,HeroPropConstConfig.SHENG_MING)));
  self.datas.Grade = -1 + self.datas.Grade;
  
  local silver = self.context.userCurrencyProxy:getSilver();
  local silver_need = grade_tb_data.money;
  self.isSilverEnough = silver >= silver_need;
  self.silver:setString("<content><font color='#" .. (self.isSilverEnough and "00FF00" or "FF0000") .. "'>" .. silver_need .."</font></content>");
  self.slot:refreshGrade(self.datas.Grade);

  local level = self.datas.Level;
  local level_need = grade_tb_data.level;
  self.isLevelEnough = level >= level_need;
  self.level_descb:setString("<content><font color='#FFFFFF'>需要  </font><font color='#" .. (self.isLevelEnough and "00FF00" or "FF0000") .. "'>Lv." .. level_need .."</font><font color='#FFFFFF'></font></content>");
end

function HeroJinjieLayer:onBagItemTap(event, bagItem)
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
  self.context.parent:addChild(tipBg);
  layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  local size=self.context:getContentSize();
  local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  self.context.parent:addChild(layer);
end

function HeroJinjieLayer:refreshEffect4Shengxing()
  local function onCBFunc()
    self.effect_star.parent:removeChild(self.effect_star);
    self.context:setData();
  end
  local data = self.context.heroHouseProxy:getGeneralData(self.generalId);
  local starLevel = data.StarLevel;
  self.effect_star = cartoonPlayer(1099,-36*(-1+starLevel)+416.5,166.5,1,onCBFunc);
  self:addChild(self.effect_star);

  for k,v in pairs(self.bagItems) do
    local effect_item = cartoonPlayer(1098,44+self.bagItemLayer:getPositionX()+v:getPositionX(),49+self.bagItemLayer:getPositionY()+v:getPositionY(),1);
    self:addChild(effect_item);
  end
end