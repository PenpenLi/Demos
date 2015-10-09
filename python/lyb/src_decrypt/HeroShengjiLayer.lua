require "main.view.hero.heroHouse.ui.HeroHousePageView";
require "main.view.hero.heroTeam.ui.HeroTeamSlot";

HeroShengjiLayer=class(TouchLayer);

function HeroShengjiLayer:ctor()
  self.class=HeroShengjiLayer;
end

function HeroShengjiLayer:dispose()
  self.armature:dispose();
	HeroShengjiLayer.superclass.dispose(self);
end

function HeroShengjiLayer:initialize(context)
  self.context = context;
  self.skeleton = self.context.skeleton;
  self.cards = {};

  self:initLayer();
  --骨骼
  local armature=self.skeleton:buildArmature("heroShengjiUI");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local text = "";
  self.descb = createRichMultiColoredLabelWithTextData(self.armature:getBone("descb").textData,text);
  self.armature.display:addChild(self.descb);

  text = "升级";
  local title = createTextFieldWithTextData(self.armature:getBone("titleBg").textData,text);
  self.armature.display:addChild(title);

  local closeButton = Button.new(self.armature:findChildArmature("common_copy_close_button"), false);
  closeButton:addEventListener(Events.kStart, self.closeUI, self);

  local shengjiBtn = Button.new(self.armature:findChildArmature("shengjiBtn"), false);
  local function recruitButton(armature)
    local tf = armature:initTextFieldWithString("common_small_blue_button","进阶");
  end
  shengjiBtn:buildLabel(recruitButton);
  --shengjiBtn.bone:initTextFieldWithString("common_small_blue_button","升级");
  shengjiBtn:addEventListener(Events.kStart, self.onShengjiTap, self);

  local _count = 1;
  while 7 > _count do
    self.armature.display:getChildByName("jinjie_jiahao_img_" .. _count):addEventListener(DisplayEvents.kTouchBegin,self.onCardImgTap,self,_count);
    _count = 1 + _count;
  end

  self.context.armature.display:getChildByName("renderGroup"):setVisible(false);
  self.context.armature.display:getChildByName("common_copy_close_button"):setVisible(false);
end

function HeroShengjiLayer:onCardTap(items, heroHouseSlot)
  
end

function HeroShengjiLayer:closeUI(event)
  self.parent:removeChild(self);
  self.context.heroShengjiLayer = nil;
  self.context:refreshLevelAndExpByCancel();

  self.context.armature.display:getChildByName("renderGroup"):setVisible(true);
  self.context.armature.display:getChildByName("common_copy_close_button"):setVisible(true);
end

function HeroShengjiLayer:onShengjiTap(event)
  local cache = self.context.heroHouseProxy.shengjiTargetArrayCache;
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
end

function HeroShengjiLayer:cacheData()
  local data = {};
  for k,v in pairs(self.cards) do
    if v then
      table.insert(data, v.items.GeneralId);
    end
  end

  local exp = 0;
  for k,v in pairs(self.cards) do
    if self.cards[k] then
      exp = exp + analysis("Kapai_Kapaiku", self.cards[k].items.ConfigId, "eatexp");
    end
  end

  local _general_level = self.context.heroHouseProxy:getGeneralData(self.generalId).Level;
  local _general_exp = self.context.heroHouseProxy:getExpByGeneralID(self.generalId);
  local _level = _general_level;
  _general_exp = _general_exp + exp;
  while analysisHas("Kapai_Kapaishengjijingyan", 1 + _general_level) do
    local _needExp = analysis("Kapai_Kapaishengjijingyan", 1 + _general_level, "exp");
    if 0 <= _general_exp - _needExp then
      _level = 1 + _level;
      _general_exp = _general_exp - _needExp;
    end
    _general_level = 1 + _general_level;
  end
  
  self.context.heroHouseProxy.shengjiGeneralIDCache = self.generalId;
  self.context.heroHouseProxy.shengjiTargetArrayCache = data;
  self.context.heroHouseProxy.shengjiLevelCache = _level;
  self.context.heroHouseProxy.shengjiExpCache = _general_exp;
  self.context.heroHouseProxy.shengjiTotalExpCache = exp;
end

function HeroShengjiLayer:refreshCacheDescribe()
  self.descb:setString("<content><font color='#4E300A'>提供经验   </font><font color='#00FFFF'>" .. self.context.heroHouseProxy.shengjiTotalExpCache .. "</font><br/><font color='#4E300A'>可升级至   </font><font color='#FFFFFF'>Lv " .. self.context.heroHouseProxy.shengjiLevelCache .. "</font></content>");
  self.context:refreshGeneralLevelAndExpByLevelUp(self.context.heroHouseProxy.shengjiLevelCache, self.context.heroHouseProxy.shengjiExpCache);
end

function HeroShengjiLayer:onCardImgTap(event, num)
  print("right");
  local function callbackFunc(chooseItems)
    print("callbackFunc",chooseItems[1].GeneralId);
    self:createHeroTeamSlot(chooseItems[1].GeneralId,num);
    self:cacheData();
    self:refreshCacheDescribe();
  end

  local data4Shengji = self.context.heroHouseProxy:getDatas4Shengji(self.generalId);
  for k,v in pairs(self.cards) do
    if v then
      for k_,v_ in pairs(data4Shengji) do
        if v.items.GeneralId == v_.GeneralId then
          table.remove(data4Shengji, k_);
          break;
        end
      end
    end
  end
  local heroChooseLayer = HeroChooseLayer.new();
  heroChooseLayer:initialize(self.context, callbackFunc);
  heroChooseLayer:refreshPageViewData(data4Shengji);
  self.parent:addChild(heroChooseLayer);
end

function HeroShengjiLayer:callbackFunc(itemData)
  print("callbackFunc->",itemData.GeneralId,self.generalId);
  if self.generalId == itemData.GeneralId then
    return;
  end
  for k,v in pairs(self.cards) do
    print(v.items.GeneralId);
    if itemData.GeneralId == v.items.GeneralId then
      self.armature.display:removeChild(v);
      self.cards[k]=nil;
      break;
    end
  end
  self:cacheData();
  self:refreshCacheDescribe();
end

function HeroShengjiLayer:refreshData(generalId)
  self.generalId = generalId;
  self:removeHeroTeamSlots();
  --self:createHeroTeamSlot(self.generalId, 1);
end

function HeroShengjiLayer:createHeroTeamSlot(generalId, num)
  local heroTeamSlot = HeroTeamSlot:create();
  heroTeamSlot:initialize(nil,self,self.callbackFunc);
  heroTeamSlot:setSlotData(self.context.heroHouseProxy:getGeneralData(generalId));
  local card_pos = self.armature.display:getChildByName("jinjie_jiahao_img_" .. num):getPosition();
  heroTeamSlot:setPositionXY(-5 + card_pos.x, 10 + card_pos.y);
  self.armature.display:addChild(heroTeamSlot);

  self.cards[num] = heroTeamSlot;
end

function HeroShengjiLayer:removeHeroTeamSlots()
  for k,v in pairs(self.cards) do
    if v then
      self.armature.display:removeChild(v);
      self.cards[k]=nil;
    end
  end
end