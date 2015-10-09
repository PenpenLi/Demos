require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.controls.AdvacedProgressBar";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";
require "core.display.ClippingNodeMask";
require "main.view.hero.heroPro.ui.HeroShipinRender";
require "main.view.hero.heroPro.ui.HeroYuanfenRender";
require "main.view.bag.ui.bagPopup.EquipDetailLayer";
require "main.view.hero.heroPro.ui.HeroChooseLayer";
require "main.view.hero.heroPro.ui.HeroJinjieLayer";
require "main.view.hero.heroPro.ui.HeroShengjiLayer";
require "main.view.hero.heroPro.ui.HeroXinxiLayer";
require "main.view.hero.heroPro.ui.HeroZhuangbeiRender";
require "main.view.hero.heroPro.ui.HeroXiangxiLayer";
require "main.view.hero.heroPro.ui.HeroChangeEquipeRender";
require "main.view.hero.heroPro.ui.heroProPageView.HeroProPageView";
require "core.display.BitmapTextField";
require "main.config.HeroPropConstConfig";
require "main.view.hero.heroPro.ui.HeroProScaleSlot";
require "main.view.hero.heroPro.ui.HeroRoundPortrait";
require "main.view.hero.heroPro.ui.HeroDetailLayer";
require "main.view.hero.heroPro.ui.HeroShengxingLayer";
require "main.view.hero.heroPro.ui.HeroShengjiBag";
require "main.view.hero.heroPro.ui.HeroSkillDetailLayer";

HeroProPopup=class(LayerPopableDirect);

function HeroProPopup:ctor(items)
  self.class=HeroProPopup;
  self.equipTb = {};
  self.dataFromHeroHouse = items;
end

function HeroProPopup:dispose()
  if self.scaleSlot then
    self.onLayerCallBack();
  end
  if self.heroShengjiBag and self.heroShengjiBag.parent then
    self.heroShengjiBag.parent:removeChild(self.heroShengjiBag);
    self.heroShengjiBag = nil;
  end
  MusicUtils:stopEffect4Card();
  HeroProPopup.superclass.dispose(self);
end

function HeroProPopup:onDataInit()
  TimeCUtil:getTime("onDataInit")
  -- local proxyRetriever=ProxyRetriever.new();
  -- self.strengthenProxy=proxyRetriever:retrieveProxy(StrengthenProxy.name);--获取数据
  self.skeleton = getSkeletonByName("hero_ui");
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
  self.heroHouseProxy.Jinengshengji_Bool = nil;
  self.selectedTAB = 1;

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_PRO, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroPro_ui");
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);

  self.heroHouseProxy:cleanGeneralExpAndHunli();
  TimeCUtil:getTime("onDataInit")
end

--初始化数据
function HeroProPopup:initialize()

end

function HeroProPopup:onBegin(event)
  print("HeroProPopuponBegin");
  self.maskImg:addEventListener(DisplayEvents.kTouchMove, self.onMove, self);
  self.maskImg:addEventListener(DisplayEvents.kTouchEnd, self.onEnd, self);
end

function HeroProPopup:onMove(event)
  print("onMove");
  self.maskImg:removeEventListener(DisplayEvents.kTouchMove, self.onMove, self);
  self.maskImg:removeEventListener(DisplayEvents.kTouchEnd, self.onEnd, self);
end

function HeroProPopup:popScaleSlot(event)
  print("onEnd");

  function play()
    self.armature.display:getChildByName("name_bg"):setVisible(false);
    if self.pLabelFont then
      self.pLabelFont:setVisible(false);
    end
    if self.nameTextField then
      self.nameTextField:setVisible(false);
    end
    self.pageView:setVisible(false);
    -- local _count = 0;
    -- while 5 > _count do
    --   _count = 1 + _count;
    --   self.stars_empty[_count]:setVisible(false);
    --   self.stars[_count]:setVisible(false);
    -- end
  end

  function back()
    self.armature.display:getChildByName("name_bg"):setVisible(true);
    if self.pLabelFont then
      self.pLabelFont:setVisible(true);
    end
    if self.nameTextField then
      self.nameTextField:setVisible(true);
    end
    self.pageView:setVisible(true);
    self:refreshStar(self.selectedData.StarLevel,self.heroHouseProxy:getIsMainGeneral(self.selectedData.GeneralId) and 5 or analysis("Kapai_Kapaiku",self.selectedData.ConfigId,"star"));
  end

  function onLayerCallBack(event)
    if self.bg_layer then
      self.bg_layer.parent:removeChild(self.bg_layer);
      self.bg_layer = nil;
    end
    if self.img_bg then
      self.img_bg.parent:removeChild(self.img_bg);
      self.img_bg = nil;
    end
    if self.scaleSlot then
      self.scaleSlot.parent:removeChild(self.scaleSlot);
      self.scaleSlot = nil;
    end
    back();
  end

  self.onLayerCallBack = onLayerCallBack;
  self.bg_layer = LayerColorBackGround:getTransBackGround();
  self.bg_layer:addEventListener(DisplayEvents.kTouchTap, onLayerCallBack);
  self.parent.parent:addChild(self.bg_layer);

  self.img_bg = Image.new();
  self.img_bg:loadByArtID(StaticArtsConfig.BACKGROUD_HERO_PRO);
  self.img_bg.touchEnabled = false;
  self.parent.parent:addChild(self.img_bg);

  self.scaleSlot = HeroProScaleSlot.new();
  self.scaleSlot:initialize(self.skeleton, self.selectedData, makePoint(330,342));
  self.scaleSlot:addEventListener(DisplayEvents.kTouchTap, onLayerCallBack);
  self.parent.parent:addChild(self.scaleSlot);
  self.scaleSlot:play();
  play();
end

function HeroProPopup:onPrePop()
  TimeCUtil:getTime("onPrePop")
  -- local image = Image.new();
  -- image:loadByArtID(875);
  -- image:setScale(2);
  -- self:addChildAt(image,0);

  --setButtonGroupVisible(false);
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  self:setContentSize(makeSize(1280,720));  

  --self.zhanLiCon = self.armature.display:getChildByName("zhanLiCon");
  -- self.pgCon = self.armature.display:getChildByName("pgCon");

  local zhanli = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanLi");
  zhanli:setPositionXY(181,60);
  zhanli:setScale(0.8);
  self.armature.display:addChild(zhanli);
  self.zhanLi = CartoonNum.new();
  self.zhanLi:initLayer();
  self.zhanLi:setData(0,"common_number",40);--server
  self.zhanLi:setPositionXY(331,61);
  self.zhanLi:setScale(0.8);
  self.armature.display:addChild(self.zhanLi);  

  local text="";
  self.exp_descb=createTextFieldWithTextData(self.armature:getBone("level_descb").textData,text,true);
  self.armature.display:addChild(self.exp_descb);

  self.heroHeaderCon = self.armature.display:getChildByName("heroHeaderCon");
  self.titleBg = self.armature.display:getChildByName("renderGroup"):getChildByName("titleBg");   

  self.titleTF = BitmapTextField.new("","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(843,607);
  self:addChild(self.titleTF);

  self.tabBtn1 = generateButton(self.armature:findChildArmature("renderGroup"),"tabBtn1","common_channel_button","息\n信",self.click,self,134,nil,true,makePoint(26,50),nil,CommonButtonTouchable.CUSTOM);
  self.tabBtn2 = generateButton(self.armature:findChildArmature("renderGroup"),"tabBtn2","common_channel_button","备\n装",self.click,self,134,nil,true,makePoint(26,50),nil,CommonButtonTouchable.CUSTOM);
  self.tabBtn3 = generateButton(self.armature:findChildArmature("renderGroup"),"tabBtn3","common_channel_button","品\n饰",self.click,self,134,nil,true,makePoint(26,50),nil,CommonButtonTouchable.CUSTOM);
  self.tabBtn4 = generateButton(self.armature:findChildArmature("renderGroup"),"tabBtn4","common_channel_button","分\n缘",self.click,self,134,nil,true,makePoint(26,50),nil,CommonButtonTouchable.CUSTOM);
  self.tabBTNs = {self.tabBtn1,self.tabBtn2,self.tabBtn3,self.tabBtn4};
  self.tabBtnPoss = {self.tabBtn1:getPosition(),self.tabBtn2:getPosition(),self.tabBtn3:getPosition(),self.tabBtn4:getPosition()};
  -- self.tabBtn1:select(false);
  -- self.tabBtn2:select(false);
  -- self.tabBtn3:select(false);
  -- self.tabBtn4:select(false);

  -- local function_open = {self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_17),
  --                        self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_20)};

  self.redDotsTabBTN = {};
  for i=1,4 do
    local redDot = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
    redDot.name = "effect";
    redDot:setPositionXY(65,125);
    redDot:setVisible(false);
    self.tabBTNs[i]:addChild(redDot);
    table.insert(self.redDotsTabBTN,redDot);
  end

  -- self.zhuanImg = self.armature.display:getChildByName("zhuan_img");
  -- SingleButton:create(self.zhuanImg);
  -- self.zhuanImg:addEventListener(DisplayEvents.kTouchTap,self.popZhuanLayer,self);

  self.level_descb = CartoonNum.new();
  self.level_descb:initLayer();
  self.level_descb:setData(0,"common_number",40);
  self.level_descb:setScale(0.7);
  self.level_descb:setPositionXY(119,27);
  self.armature.display:addChild(self.level_descb);

  -- self.stars_empty={};
  -- self.stars={};
  -- for i = 1,5 do
  --   local star_empty = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star_empty");
  --   star_empty:setScale(0.8);
  --   star_empty:setPositionXY( -75 * (-1 + i) + 490,65);
  --   self.armature.display:addChild(star_empty);
  --   self.stars_empty[i] = star_empty;

  --   local star = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
  --   star:setScale(0.8);
  --   star:setPositionXY( -75 * (-1 + i) + 490,65);
  --   self.armature.display:addChild(star);
  --   self.stars[i] = star;
  -- end

  local button=self.armature.display:getChildByName("level_up_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  self.armature.display:addChild(layer);
  layer:setScale(0.86);

  self.level_up_btn=CommonButton.new();
  self.level_up_btn:initialize("commonButtons/common_small_red_button_down",nil,CommonButtonTouchable.BUTTON);
  self.level_up_btn:initializeText(self.armature:findChildArmature("level_up_btn"):getBone("common_small_red_button").textData,"升级");
  --self.level_up_btn:initializeBMText("进阶","anniutuzi");
  self.level_up_btn:setPosition(button_pos);
  self.level_up_btn:addEventListener(DisplayEvents.kTouchTap,self.onLevelupTap,self);
  layer:addChild(self.level_up_btn);

  TimeCUtil:getTime("onPrePop")

  local red_dot = self.armature.display:getChildByName("effect1");
  red_dot.parent:removeChild(red_dot,false);
  self.armature.display:addChild(red_dot);
  self.effect1 = red_dot;
  self.effect1.touchEnabled = false;
end

function HeroProPopup:onUIInit()
  TimeCUtil:getTime("onUIInit")
  local generalArray = self.heroHouseProxy:getGeneralArray();TimeCUtil:getTime("onUIInit1")
  local general_ids = {};
  for k,v in pairs(generalArray) do
    table.insert(general_ids, v.GeneralId);
  end
  self.pageView = HeroProPageView.new(CCPageView:create());
  self.pageView:initialize(self, general_ids);
  self.pageView:setPositionXY(0,-720);
  self.pageView:setMoveEnabled(false);
  local function new_func()

  end
  self.pageView.setMoveEnabled = new_func;
  self.armature.display:addChildAt(self.pageView,1);TimeCUtil:getTime("onUIInit2")
  for k,v in pairs(general_ids) do
    if not self.dataFromHeroHouse.GeneralId then
      self.pageView:setCurrentPage(1);
      break;
    end
    if self.dataFromHeroHouse.GeneralId == v then
      self.pageView:setCurrentPage(k);
      break;
    end
  end
TimeCUtil:getTime("onUIInit3")
  local layer = LayerColor.new();
  layer:initLayer();
  layer:setContentSize(makeSize(600,500));
  layer:setOpacity(0);
  layer:setPositionXY(50,100);
  self.armature.display:addChildAt(layer,3);
  layer:addEventListener(DisplayEvents.kTouchBegin,self.onItemBegin,self);
  layer:addEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
TimeCUtil:getTime("onUIInit4")
  if self.dataFromHeroHouse.TAB_ID then
    self:click({target={name="tabBtn" .. self.dataFromHeroHouse.TAB_ID}});
  else
    self:click({target={name="tabBtn1"}});
  end
  TimeCUtil:getTime("onUIInit5")
  self:dispatchEvent(Event.new(HeroHouseNotifications.HEROHOUSE_CLOSE,nil,self));TimeCUtil:getTime("onUIInit6")
  TimeCUtil:getTime("onUIInit")

  self.askBtn = self.armature.display:getChildByName("ask");
  SingleButton:create(self.askBtn);
  self.askBtn:addEventListener(DisplayEvents.kTouchTap,self.onShowTip, self);

  local max_img = self.armature.display:getChildByName("max_img");
  max_img:setScale(0.6);
  max_img:setPositionXY(90,30);
end

function HeroProPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",20,"txt");
  TipsUtil:showTips(self.askBtn,text,600,nil,50);
end

function HeroProPopup:onItemBegin(event)
  log("onItemBegin->");
  self.beginX = event.globalPosition.x;
end

function HeroProPopup:onItemEnd(event)
  -- log(self.id);
  self.endX = event.globalPosition.x;
  if self.beginX then
    local v = self.beginX - self.endX;
    local currentPage = self.pageView:getCurrentPage();
    if math.abs(v) < 10 then
      self:popScaleSlot();
    elseif 0 < v then
      if currentPage < self.pageView.maxPageNum then
        self.pageView:setCurrentPage(currentPage + 1);
      end
    elseif 0 > v then
      if currentPage > 1 then
        self.pageView:setCurrentPage(currentPage - 1);
      end
    end
    self.beginX = nil;
  end
end

function HeroProPopup:onRequestedData()

end

function HeroProPopup:onPreUIClose()
  --setButtonGroupVisible(true);
  -- self.armature.display:getChildByName("heroHeaderCon"):removeChild(self.pageView);
end

function HeroProPopup:onUIClose()
  self:dispatchEvent(Event.new("closeNotice",nil,self));
end

function HeroProPopup:refreshCurrentData()
  self:setData(self.selectedData);
end

function HeroProPopup:setData(data)
  local data_p = self.selectedData;
  self:refreshTabBTN(data);
  if not data then data = self.heroHouseProxy:getGeneralData(self.selectedData.GeneralId); end;
  print("&&&&&&&&&&&&&&&&&&&&setData&&&&&&&&&&&&&&&&&&&&",data.GeneralId,data.ConfigId);
  self.selectedData = data;

  -- local zhanli_p = tonumber(self.zhanLi.num);

  -- self:refreshButton();
  self:refreshPanel();
  self:refreshInfo();
  self:refreshRedDot();

  self:refreshZhanli(data_p);
  -- local zhanli = math.floor(self.heroHouseProxy:getZongZhanli(self.selectedData.GeneralId));
  -- self.zhanLi:setData(zhanli,"common_number",40);
  -- if data_p and self.selectedData and data_p.GeneralId == self.selectedData.GeneralId then
  --   if zhanli_p < zhanli then
  --     sharedTextAnimateReward():animateStartByString("战力似乎更强了 +" .. (zhanli - zhanli_p));
  --   end
  -- end
end

function HeroProPopup:refreshZhanli(data_p)
  local zhanli_p = tonumber(self.zhanLi.num);
  local zhanli = math.floor(self.heroHouseProxy:getZongZhanli(self.selectedData.GeneralId));
  self.zhanLi:setData(zhanli,"common_number",40);
  if data_p and self.selectedData and data_p.GeneralId == self.selectedData.GeneralId then
    if zhanli_p < zhanli then
      sharedTextAnimateReward():animateStartByString("战力似乎更强了 +" .. (zhanli - zhanli_p));
    end
  end
end

function HeroProPopup:refreshInfo()
  print("///////??????????????????????refreshInfo");
  local _count = 0;
  if self.pLabelFont then
    self.armature.display:removeChild(self.pLabelFont);
    self.pLabelFont = nil;
  end
  if self.nameTextField then
    self.armature.display:removeChild(self.nameTextField);
    self.nameTextField = nil;
  end

  local isMainGeneral = self.heroHouseProxy:getIsMainGeneral(self.selectedData.GeneralId);
  --name
  local name;
  local str = "";
  if isMainGeneral then
    name = self.userProxy:getUserName();
    self.nameTextField=createAutosizeMultiColoredLabelWithTextData(self.armature:getBone("name_bg").textData,name);
    --TextField.new(CCLabelTTF:create(str,FontConstConfig.OUR_FONT,32));
    local size = self.nameTextField:getContentSize();
    self.nameTextField:setPositionXY(65,610 - size.height);
    self.armature.display:addChild(self.nameTextField);
  else
    name = analysis("Kapai_Kapaiku",self.selectedData.ConfigId,"name");
    _count = -1;
    while (-1-string.len(name)) < _count do
      str = str .. string.sub(name, -2 + _count, _count) .. "\n";
      log("->" .. _count .. " " .. (-2 + _count) .. " " .. string.sub(name, -2 + _count, _count));
      _count = -3 + _count;
    end

    self.pLabelFont=BitmapTextField.new(str,"yingxiongmingzi");
    local size = self.pLabelFont:getContentSize();
    self.pLabelFont:setPositionXY(60,610 - size.height);
    self.armature.display:addChild(self.pLabelFont);
  end
  
  --level
  -- self.expTF:setString("Lv " .. self.selectedData.Level);
  --exp
  -- self:refreshGeneralExp();
  local wuxing = analysis("Kapai_Kapaiku",self.selectedData.ConfigId,"job");
  if self.wuxing == wuxing then

  else
    if self.wuxingImg then
      self.armature.display:removeChild(self.wuxingImg);
      self.wuxingImg = nil;
    end
    self.wuxing = wuxing;
    self.wuxingImg = self.skeleton:getCommonBoneTextureDisplay("commonImages/common_shuxing_" .. self.wuxing);
    SingleButton:create(self.wuxingImg);
    self.wuxingImg:setScale(0.5);
    self.wuxingImg:setPositionXY(82,655);
    self.wuxingImg:addEventListener(DisplayEvents.kTouchTap,self.popWuxingLayer,self);
    self.armature.display:addChild(self.wuxingImg);
  end
  -- self.zhuanImg:setVisible(not self.heroHouseProxy:getIsMainGeneral(self.selectedData.GeneralId));
  
  local star = analysis("Kapai_Kapaiku",self.selectedData.ConfigId,"star");
  self:refreshStar(self.selectedData.StarLevel,star);
  -- if not self.wuxingtexiao then
    -- self.wuxingtexiao = cartoonPlayer(1573,350,330,0,nil,2,nil,true);
    -- self:addChild(self.wuxingtexiao);
  -- end
  -- self.wuxingtexiao:setVisible(5==star);

  self.titleTF:setString(self:getTitleString(self.selectedTAB));
  self:refreshGeneralExpAndHunli();

  self.level_up_btn:setVisible(not isMainGeneral);
end

function HeroProPopup:refreshTabBTN(data)
  if not data or data and self.selectedData and data.GeneralId == self.selectedData.GeneralId then
    return;
  end
  -- if 1 == data.IsMainGeneral then
  --   self.tabBtn2:setVisible(false);
  --   self.tabBtn3:setPosition(self.tabBtnPoss[2]);
  --   self.tabBtn4:setPosition(self.tabBtnPoss[3]);
  -- else
  --   self.tabBtn2:setVisible(true);
  --   self.tabBtn3:setPosition(self.tabBtnPoss[3]);
  --   self.tabBtn4:setPosition(self.tabBtnPoss[4]);
  -- end
  -- if self.tabBtn2:getIsSelected() and 1 == data.IsMainGeneral then
  --   self:click({target={name="tabBtn1"}});
  -- end
end

function HeroProPopup:refreshRedDot()
  local data = self.heroHouseProxy:getHongdianData(self.selectedData.GeneralId);
  -- if data.BetterEquip then
  --   self.redDotsTabBTN[1]:setVisible(true);
  -- else
  --   self.redDotsTabBTN[1]:setVisible(false);
  -- end
  -- if (data.Levelable and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_16))
  --    or (data.Gradeable and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_15))
  --    or (data.StarLevelable and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_19))
  --    then
  -- -- if data.Levelable or data.Gradeable or data.StarLevelable then
  --   self.redDotsTabBTN[2]:setVisible(true);
  -- else
  --   self.redDotsTabBTN[2]:setVisible(false);
  -- end
  -- if (data.Skillable and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_17)) then
  --   self.redDotsTabBTN[2]:setVisible(true);
  -- else
  --   self.redDotsTabBTN[2]:setVisible(false);
  -- end
  self.effect1:setVisible(data.Levelable);
  if data.Gradeable or data.StarLevelable or data.Skillable then
    self.redDotsTabBTN[1]:setVisible(true);
  else
    self.redDotsTabBTN[1]:setVisible(false);
  end
  if (data.BetterJinjieEquip and (1 == data.BetterJinjieEquip[1] or 1 == data.BetterJinjieEquip[3] or 1 == data.BetterJinjieEquip[4] or 1 == data.BetterJinjieEquip[5]))
  or (data.BetterEquip and (1 == data.BetterEquip[1] or 1 == data.BetterEquip[3] or 1 == data.BetterEquip[4] or 1 == data.BetterEquip[5])) then
    self.redDotsTabBTN[2]:setVisible(true);
  else
    self.redDotsTabBTN[2]:setVisible(false);
  end
  if data.BetterJinjieEquip and (1 == data.BetterJinjieEquip[2] or 1 == data.BetterJinjieEquip[6]) then
    self.redDotsTabBTN[3]:setVisible(true);
  else
    self.redDotsTabBTN[3]:setVisible(false);
  end
  if data.Yuanfenable then
    self.redDotsTabBTN[4]:setVisible(true);
  else
    self.redDotsTabBTN[4]:setVisible(false);
  end
  print("==============================->",data.GeneralId);
  print(data.Gradeable,data.StarLevelable);
  print(data.BetterJinjieEquip);
  print(data.BetterJinjieEquip);
  print(data.Yuanfenable);
end

function HeroProPopup:refreshRedDotGeneral()
  self:refreshRedDot();
  if self.heroXinxiRender then
    self.heroXinxiRender:refreshRedDot();
  end
  if self.heroZhuangbeiRender then
    self.heroZhuangbeiRender:refreshRedDot();
  end
  if self.heroShipinLayer then
    self.heroShipinLayer:refreshRedDot();
  end
  if self.heroYuanfenRender then
    self.heroYuanfenRender:refreshRedDot();
  end
end

function HeroProPopup:refreshPanel()
  if self.heroXinxiRender and self.heroXinxiRender:isVisible() then
    self.heroXinxiRender:refreshData(self.selectedData.GeneralId);
  end
  if self.heroZhuangbeiRender and self.heroZhuangbeiRender:isVisible() then
    self.heroZhuangbeiRender:refreshData(self.selectedData.GeneralId);
  end
  if self.heroShipinLayer and self.heroShipinLayer:isVisible() then
    self.heroShipinLayer:refreshData(self.selectedData.GeneralId);
  end
  if self.heroYuanfenRender and self.heroYuanfenRender:isVisible() then
    self.heroYuanfenRender:refreshData(self.selectedData.GeneralId);
  end
  if self.heroShengjiLayer and self.heroShengjiLayer:isVisible() then
    self.heroShengjiLayer:refreshData(self.selectedData.GeneralId);
  end
  if self.heroJinjieLayer and self.heroJinjieLayer:isVisible() then
    self.heroJinjieLayer:refreshData(self.selectedData.GeneralId);
  end
end

function HeroProPopup:refreshStrengthen(generalId, itemId, strengthenLevel, param1, param2)
  -- if 0 ~= param1 or 0 ~= param2 then
  --   local size = self:getContentSize();
  --   local effect;
  --   local function onCall()
  --     if effect.parent then
  --       effect.parent:removeChild(effect);
  --     end
  --   end
  --   effect = cartoonPlayer(1661,size.width/2, size.height/2, nil, onCall);
  --   self:addChild(effect);

  --   local count = param1 + 2 * param2;
  --   count = 10 < count and 10 or count;
  --   if 0 < count then
  --     local effect;
  --     local function onCall()
  --       if effect.parent then
  --         effect.parent:removeChild(effect);
  --       end
  --     end
  --     effect = cartoonPlayer(1755 + (-1 + count),size.width/2, size.height/2, nil, onCall);
  --     self:addChild(effect);
  --   end
  -- else
  --   local size = self:getContentSize();
  --   local effect;
  --   local function onCall()
  --     if effect.parent then
  --       effect.parent:removeChild(effect);
  --     end
  --   end
  --   effect = cartoonPlayer(1662,size.width/2, size.height/2, nil, onCall);
  --   self:addChild(effect);
  -- end
  self:refreshPanel();
  self:refreshZhanli(self.selectedData);
  if self.heroZhuangbeiRender and self.heroZhuangbeiRender:isVisible() then
    self.heroZhuangbeiRender:refreshStrengthen(itemId);
  end
end

function HeroProPopup:refreshStrengthenAll()
  if self.heroZhuangbeiRender and self.heroZhuangbeiRender:isVisible() then
    self.heroZhuangbeiRender:refreshStrengthenAll();
  end
  self:refreshPanel();
  self:refreshZhanli(self.selectedData);
end

function HeroProPopup:refreshYuanfenShengji(generalFateArray)
  self:refreshPanel();
  self:refreshZhanli(self.selectedData);
  local effect;
  local function onCall()
    if effect.parent then
      effect.parent:removeChild(effect);
    end
  end
  effect = cartoonPlayer(1090,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1, onCall);
  self:addChild(effect);
end

function HeroProPopup:refreshJinjie()
  -- local effect;
  -- local function onCall()
  --   if effect.parent then
  --     effect.parent:removeChild(effect);
  --   end
  -- end
  -- effect = cartoonPlayer(1088,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1, onCall);
  -- self:addChild(effect);
  self:refreshPanel();
  self:refreshZhanli(self.selectedData);
  if self.heroZhuangbeiRender and self.heroZhuangbeiRender:isVisible() then
    self.heroZhuangbeiRender:refreshJinjie();
  end
  if self.heroShipinLayer and self.heroShipinLayer:isVisible() then
    self.heroShipinLayer:refreshJinjie();
  end
end

function HeroProPopup:onLevelupTap(event)
  -- if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_16) then
  --   sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
  --   return;
  -- end
  if not analysisHas(self:getExcelName(self.selectedData.GeneralId), 1 + self.selectedData.Level) then
    sharedTextAnimateReward():animateStartByString("已经满级了哦~");
    return;
  end

  local bagDatas = self.bagProxy:getData();
  local datas;
  if 1==self.selectedData.IsMainGeneral then
    datas = {[1012006] = 0};
  else
    datas = {[1012001] = 0, [1012002] = 0, [1012003] = 0, [1012004] = 0};
  end
  local tb = {};
  local function sort_func(data_a, data_b)
    return data_a.ItemId < data_b.ItemId;
  end
  for k,v in pairs(bagDatas) do
    if datas[v.ItemId] then
      datas[v.ItemId] = v.Count + datas[v.ItemId];
    end
  end
  for k,v in pairs(datas) do
      table.insert(tb, {ItemId = k, Count = v});
  end
  table.sort(tb, sort_func);
  datas = tb;

  if 0 == table.getn(datas) then
    sharedTextAnimateReward():animateStartByString("没有可用于升级的道具哦~");
    return;
  end

  self.layer_4_bag = LayerColor.new();
  self.layer_4_bag:initLayer();
  self.layer_4_bag:setContentSize(makeSize(516,814));
  self.layer_4_bag:setOpacity(0);
  self.layer_4_bag:setPositionXY(0,0);
  self.armature.display:addChildAt(self.layer_4_bag,5);

  local bag = HeroShengjiBag.new();
  bag:initialize(self,self.selectedData.GeneralId,datas);
  self.parent:addChild(bag);
  self.heroShengjiBag = bag;
  if GameVar.tutorStage == TutorConfig.STAGE_1010 and not self.tutorLevelUp then
    self.tutorLevelUp = true;
    openTutorUI({x=70, y=138, width = 102, height = 102, alpha = 125});
  end


  local function onLayerCallBack(event)
    self:removeEventListener(DisplayEvents.kTouchBegin, onLayerCallBack);
    self.parent:removeChild(bag);
    self.heroShengjiBag = nil;
  end
  self:addEventListener(DisplayEvents.kTouchBegin, onLayerCallBack);

  self.heroHouseProxy.shengjiGeneralIDCache = self.selectedData.GeneralId;
end

function HeroProPopup:PutOnEquip(event)
  -- local userItemId = event.data;
  local userItemId = self.curItemRender:getItemData().UserItemId;
  -- -- print("lalalalllllllllllllllllllllllllllllllllllllllllll=="..userItemId);
  self:dispatchEvent(Event.new("offEquip",{GeneralId = self.selectedData.GeneralId,UserEquipmentId = userItemId},self));
  if self.detailLayer then
    self:removeChild(self.detailLayer);
    self.detailLayer = nil;
  end;
end;

function HeroProPopup:OpenEquip(event)
  if self.changeEquipeRender then
    self.changeEquipeRender:setVisible(true);
    self.changeEquipeRender:setData(self.id,self.curItemRender);
  else
    self.changeEquipeRender = HeroChangeEquipeRender:create(self,self.id,self.curItemRender);
    -- self.changeEquipeRender:
    self:addChild(self.changeEquipeRender);
  end;  
  if self.detailLayer then
    self:removeChild(self.detailLayer);
    self.detailLayer = nil;
  end;
end

function HeroProPopup:onEquip(event)
  local userItemId = event.data;
  self:dispatchEvent(Event.new("onEquip",{GeneralId = self.selectedData.GeneralId,UserEquipmentId = userItemId},self));
  self.changeEquipeRender:setVisible(false);
end;

function HeroProPopup:changeClick(event)
  local name = event.target.name;
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local itemTb = heroHouseProxy.generalArray;--serverData
  local num = #itemTb;
  local index = 0;
  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  for i=1,num do
    if itemTb[i].GeneralId == self.selectedData.GeneralId then
      index = i;
      break;
    end;
  end
  if name == "common_copy_leftArrow_button" then--left
    if itemTb[index - 1] then
      self.selectedData = itemTb[index - 1];
      self:setData(self.selectedData);
    end;
  else
    if itemTb[index + 1] then
      self.selectedData = itemTb[index + 1];
      self:setData(self.selectedData);
    end;
  end;

end;

function HeroProPopup:getTitleString(num)
  local s1 = {"主角信息","主角装备","主角饰品","主角缘分"};
  local s2 = {"英雄信息","英雄装备","英雄饰品","英雄缘分"};
  if 1 == self.selectedData.IsMainGeneral then
    return s1[num];
  else
    return s2[num];
  end
end

function HeroProPopup:click(event)
  local name = event.target.name;
  if name == "tabBtn2" then
    -- if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_17) then
    --   sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    --   return;
    -- end
  end
  if name == "tabBtn4" then
    -- if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_20) then
    --   sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    --   return;
    -- end
    local datas = self.heroHouseProxy:getYuanfenData(self.selectedData.GeneralId);
    local _tb = {};
    for k,v in pairs(datas) do
      table.insert(_tb, v);
    end
    datas = _tb;
    if 0 == table.getn(datas) then
      sharedTextAnimateReward():animateStartByString("没有英雄缘分呢~");
      return;
    end
  end

  self.tabBtn1:select(false);
  self.tabBtn2:select(false);
  self.tabBtn3:select(false);
  self.tabBtn4:select(false);
  
  if self.heroXinxiRender then
    self.heroXinxiRender:setVisible(false);
  end
  if self.heroZhuangbeiRender then
    self.heroZhuangbeiRender:setVisible(false);
  end
  if self.heroShipinLayer then
    self.heroShipinLayer:setVisible(false);
  end
  if self.heroYuanfenRender then
    self.heroYuanfenRender:setVisible(false);
  end
  if name == "tabBtn1" then
    self.selectedTAB = 1;

    if not self.heroXinxiRender then
      self.heroXinxiRender = HeroXinxiLayer.new();
      self.heroXinxiRender:initialize(self);
      self.heroXinxiRender:setPositionXY(677,20);
      self:addChild(self.heroXinxiRender);
    end
    self.tabBtn1:select(true);
    self.heroXinxiRender:setVisible(true);
    self.heroXinxiRender:refreshData(self.selectedData.GeneralId);

    hecDC(3,4,7);

  elseif name == "tabBtn2" then
    self.selectedTAB = 2;
    
    if not self.heroZhuangbeiRender then
      self.heroZhuangbeiRender = HeroZhuangbeiRender.new();
      self.heroZhuangbeiRender:initialize(self);
      self.heroZhuangbeiRender:setPositionXY(677,10);
      self:addChild(self.heroZhuangbeiRender);
    end
    self.tabBtn2:select(true);
    self.heroZhuangbeiRender:setVisible(true);
    self.heroZhuangbeiRender:refreshData(self.selectedData.GeneralId);


    if GameVar.tutorStage == TutorConfig.STAGE_1009 and GameVar.tutorSmallStep == 6 then--and not self.tutor1006 
      openTutorUI({x=997-15, y=525, width = 104, height = 40, alpha = 125, twinkle = true, fullScreenTouchable = true});
      self.tutorLayer = Layer.new();
      self.tutorLayer:initLayer();
      self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
      self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
      self:addChild(self.tutorLayer)

    end
    hecDC(3,4,5);

  elseif name == "tabBtn3" then
    self.selectedTAB = 3;
    
    if not self.heroShipinLayer then
      self.heroShipinLayer = HeroShipinLayer.new();
      self.heroShipinLayer:initialize(self);
      self.heroShipinLayer:setPositionXY(680,56);
      self:addChild(self.heroShipinLayer);
    end
    self.tabBtn3:select(true);
    self.heroShipinLayer:setVisible(true);
    self.heroShipinLayer:refreshData(self.selectedData.GeneralId);
    if GameVar.tutorStage == TutorConfig.STAGE_1017 then
      openTutorUI({x=994, y=477, width = 106, height = 42, alpha = 125, showPerson = true});
    end
    hecDC(3,4,6,self.yuanfHecDC);

  elseif name == "tabBtn4" then
    self.selectedTAB = 4;
    if GameVar.tutorStage == TutorConfig.STAGE_1014 then
      openTutorUI({x=997-15, y=525, width = 104, height = 40, alpha = 125, hideTutorHand = true, fullScreenTouchable = true});
      self.tutorLayer2 = Layer.new();
      self.tutorLayer2:initLayer();
      self.tutorLayer2:setContentSize(Director:sharedDirector():getWinSize());
      self.tutorLayer2:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap2, self);
      self.parent:addChild(self.tutorLayer2)
    end

    if not self.heroYuanfenRender then
      self.heroYuanfenRender = HeroYuanfenRender.new();
      self.heroYuanfenRender:initialize(self);
      self.heroYuanfenRender:setPositionXY(680,56);
      self:addChild(self.heroYuanfenRender);
    end
    self.tabBtn4:select(true);
    self.heroYuanfenRender:setVisible(true);
    self.heroYuanfenRender:refreshData(self.selectedData.GeneralId);
    hecDC(3,4,6,self.yuanfHecDC);
  end;

  local select_btn;
  local btns = {self.tabBtn1,self.tabBtn2,self.tabBtn3};
  for k,v in pairs(btns) do
    if v:getIsSelected() then
      select_btn = v;
    else
      self.armature:findChildArmature("renderGroup").display:removeChild(v,false);
      self.armature:findChildArmature("renderGroup").display:addChild(v);
    end
  end
  self.armature:findChildArmature("renderGroup").display:removeChild(select_btn,false);
  self.armature:findChildArmature("renderGroup").display:addChild(select_btn);

  self.titleTF:setString(self:getTitleString(self.selectedTAB));
end

function HeroProPopup:onTutorTap(event)
  if not self.tutorStep then
    self.tutorStep = 1;
    sendServerTutorMsg({BooleanValue = 0})
    openTutorUI({x=978-15, y=26+10, width = 130, height = 46, alpha = 125, twinkle = true, fullScreenTouchable = true});
  end
  if self.tutorStep == 2 then
    self:removeChild(self.tutorLayer)
    closeTutorUI();
    return;
  end
  self.tutorStep = self.tutorStep + 1;
end
function HeroProPopup:onTutorTap2(event)
    self.parent:removeChild(self.tutorLayer2)
    sendServerTutorMsg({})
    closeTutorUI();
end
function HeroProPopup:popupChooseLayer()
  local function callBackFunc(chooseItems)

  end
  local heroChooseLayer = HeroChooseLayer.new();
  heroChooseLayer:initialize(callBackFunc);
  self:addChild(heroChooseLayer);
end

function HeroProPopup:jinjieClick(event)
  if self.heroJinjieLayer then
    self:removeChild(self.heroJinjieLayer);
    self.heroJinjieLayer = nil;
  end
  self.heroJinjieLayer = HeroJinjieLayer.new();
  self.heroJinjieLayer:initialize(self);
  self.heroJinjieLayer:refreshData(self.selectedData.GeneralId);
  self.heroJinjieLayer:setPositionXY(600,-10);
  self:addChild(self.heroJinjieLayer);
end

function HeroProPopup:shengjiClick(event)
  if self.heroShengjiLayer then
    self:removeChild(self.heroShengjiLayer);
    self.heroShengjiLayer = nil;
  end
  self.heroShengjiLayer = HeroShengjiLayer.new();
  self.heroShengjiLayer:initialize(self);
  self.heroShengjiLayer:refreshData(self.selectedData.GeneralId);
  self.heroShengjiLayer:setPositionXY(600,-10);
  self:addChild(self.heroShengjiLayer);
end

function HeroProPopup:refreshDataBySkillLevelUp(generalID, skillID)
  -- if self.heroShipinLayer then
  --   self.heroShipinLayer:refreshDataBySkillLevelUp();
  -- end
  -- self:refreshPanel();
  if self.heroXinxiRender and self.heroXinxiRender:isVisible() then
    self.heroXinxiRender:refreshDataBySkillLevelUp(generalID, skillID);
  end
  self:refreshZhanli(self.selectedData);
  -- local effect;
  -- local function onCall()
  --   if effect.parent then
  --     effect.parent:removeChild(effect);
  --   end
  -- end
  -- effect = cartoonPlayer(1090,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1, onCall);
  -- self.parent:addChild(effect);
end

function HeroProPopup:refreshDataByShengxing()
  -- if self.heroZhuangbeiRender then
  --   self.heroZhuangbeiRender:refreshData(self.selectedData.GeneralId);
  -- end
end

function HeroProPopup:popXiangxi()
  local xiangxi = HeroXiangxiLayer.new();
  xiangxi:initialize(self,self.selectedData.GeneralId);
  self:addChild(xiangxi);
end

function HeroProPopup:refreshGeneralExpAndHunli()
  --exp
  if analysisHas(self:getExcelName(self.selectedData.GeneralId),1+self.selectedData.Level) then
    local exp = self.heroHouseProxy:getExpByGeneralID(self.selectedData.GeneralId);
    local exp_max = analysis(self:getExcelName(self.selectedData.GeneralId),1+self.selectedData.Level,"exp");
    self.exp_descb:setString(exp .. "/" .. exp_max);
    self.armature.display:getChildByName("progress_fg"):setScaleX(exp/exp_max>1 and 1 or exp/exp_max);
  else
    local exp = analysis(self:getExcelName(self.selectedData.GeneralId),self.selectedData.Level,"exp");
    self.exp_descb:setString(exp .. "/" .. exp);
    self.armature.display:getChildByName("progress_fg"):setScaleX(exp/exp);
  end

  self.level_descb:setData(self.selectedData.Level,"common_number",40);
  if self.selectedData.Level < analysis("Xishuhuizong_Xishubiao",1093,"constant") then
    self.armature.display:getChildByName("max_img"):setVisible(false);
  else
    self.armature.display:getChildByName("max_img"):setVisible(true);
  end
end

function HeroProPopup:refreshGeneralLevelAndExpByLevelUp(level, exp)
  -- self.expTF:setString("Lv " .. level);

  -- if analysisHas("Kapai_Kapaishengjijingyan",1+level) then
  --   self.progressBar:setProgress(exp/analysis("Kapai_Kapaishengjijingyan",1+level,"exp"));
  -- else
  --   self.progressBar:setProgress(1);
  -- end
end

function HeroProPopup:refreshLevelAndExpByCancel()
  self.expTF:setString("Lv " .. self.selectedData.Level);
  --exp
  self:refreshGeneralExpAndHunli();
end

function HeroProPopup:refreshDataByShengji(level_not_upped)
  if level_not_upped then
    self.selectedData = self.heroHouseProxy:getGeneralData(self.selectedData.GeneralId);
    self:refreshGeneralExpAndHunli();
  else
    self:setData();
  end
end

function HeroProPopup:refreshDataByJinjie()
  uninitializeSmallLoading();
  -- local data = self.heroHouseProxy:getGeneralArray();
  -- self.pageView:update(data);
  -- for k,v in pairs(data) do
  --   if self.heroHouseProxy.jinjieGeneralIDCache == v.GeneralId then
  --     print("--------------refreshDataByJinjie",k);
  --     self.pageView:setCurrentPage(k);
  --     break;
  --   end
  -- end
  -- if self.heroJinjieLayer then
  --   self.heroJinjieLayer:refreshData(self.selectedData.GeneralId);
  -- end
  -- self:setData();
  self.selectedData = self.heroHouseProxy:getGeneralData(self.selectedData.GeneralId);
  if self.heroXinxiRender and self.heroXinxiRender:isVisible() then
    self.heroXinxiRender:refreshDataByJinjie();
  end
  self:refreshZhanli(self.selectedData);

  local effect;
  local function onCall()
    if effect.parent then
      effect.parent:removeChild(effect);
    end
  end
  effect = cartoonPlayer(1089,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1, onCall);
  self.parent:addChild(effect);
end

function HeroProPopup:getExcelName(generalId)
  local data = self.heroHouseProxy:getGeneralData(generalId);
  if 1 == data.IsMainGeneral then
    return "Zhujiao_Zhujiaoshengji";
  else
    return "Kapai_Kapaishengjijingyan";
  end
end

function HeroProPopup:popZhuanLayer()
  local layer = HeroDetailLayer.new();
  layer:initializeZhuanDetail(self,self.selectedData.ConfigId);
  self:addChild(layer);
end

function HeroProPopup:popWuxingLayer()
  local layer = HeroDetailLayer.new();
  layer:initializeWuxingDetail(self,analysis("Kapai_Kapaiku",self.selectedData.ConfigId,"job"));
  self:addChild(layer);
end

function HeroProPopup:popJinengLayer(event, data)
  local layer = HeroDetailLayer.new();
  layer:initializeJinengDetail(self,data[1],data[2],data[3],data[4]);
  self:addChild(layer);
end

function HeroProPopup:refreshStar(star, star_max)
  -- for i=1,5 do
  --   self.stars_empty[i]:setVisible(i<=star_max);
  --   self.stars[i]:setVisible(i<=star);
  -- end
end

function HeroProPopup:refreshEffect4Shengxing()
  -- if self.heroXinxiRender.heroShengxingLayer then
  --   self.heroXinxiRender.heroShengxingLayer:refreshEffect4Shengxing();
  -- else
  --   self:setData();
  -- end
  if self.heroXinxiRender and self.heroXinxiRender:isVisible() then
    self.heroXinxiRender:refreshEffect4Shengxing();
  end
  self:refreshZhanli(self.selectedData);

  local effect;
  local function onCall()
    if effect.parent then
      effect.parent:removeChild(effect);
    end
  end
  effect = cartoonPlayer(1663,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1, onCall);
  self.parent:addChild(effect);
end

function HeroProPopup:refreshBySilver()
  if self.heroXinxiRender and self.heroXinxiRender:isVisible() then
    self.heroXinxiRender:refreshBySilver();
  end
  if self.heroXinxiRender.heroShengxingLayer then
    self.heroXinxiRender.heroShengxingLayer:refreshBySilver();
  end
  if self.heroShipinLayer and self.heroShipinLayer:isVisible() then
    self.heroShipinLayer:refreshBySilver();
  end
  if self.heroZhuangbeiRender and self.heroZhuangbeiRender:isVisible() then
    self.heroZhuangbeiRender:refreshBySilver();
  end
  if self.heroYuanfenRender and self.heroYuanfenRender:isVisible() then
    if self.heroYuanfenRender.heroYuanfenShengjiRender then
      self.heroYuanfenRender.heroYuanfenShengjiRender:refreshBySilver();
    end
  end
end

function HeroProPopup:refreshXilianchenggong(chenggong_data)
  if self.strengthenProxy.Dazao_Bool then
    self.equipmentInfoProxy:refreshShipinXinlianChenggong(chenggong_data);
    return;
  end
  local heroShipinXilianChenggongLayer = HeroShipinXilianChenggongLayer.new();
  heroShipinXilianChenggongLayer:initialize(self,chenggong_data);
  self:addChild(heroShipinXilianChenggongLayer);
  self.heroShipinXilianChenggongLayer = heroShipinXilianChenggongLayer;
end

function HeroProPopup:refreshOnShipinXilianBaoliu()
  self:refreshPanel();
end

function HeroProPopup:refreshExpBag()
  self:refreshGeneralExpAndHunli();
end