require "main.view.hero.heroHouse.ui.HeroHousePageView";
require "main.view.hero.heroTeam.ui.HeroTeamSlot";

HeroShengjiBag=class(TouchLayer);

function HeroShengjiBag:ctor()
  self.class=HeroShengjiBag;
end

function HeroShengjiBag:dispose()
  removeSchedule(self, self.onSche);
  self.context.layer_4_bag.parent:removeChild(self.context.layer_4_bag);
	HeroShengjiBag.superclass.dispose(self);
  if not self.context.pageView.isDisposed then
    self.context.pageView:setMoveEnabled(true);
  end
end

function HeroShengjiBag:initialize(context, generalId, datas)
  self.context = context;
  self.generalId = generalId;
  self.datas = datas;
  self.items = {};
  self.textFields = {};
  self:initLayer();
  -- local layer = LayerColorBackGround:getOpacityBackGround();
  -- local function onLayerCallBack(event)
  --   layer.parent:removeChild(layer);
  --   self.parent:removeChild(self);
  -- end
  -- layer:addEventListener(DisplayEvents.kTouchBegin, onLayerCallBack);
  -- self.context:addChild(layer);

  local size = 1==table.getn(datas) and makeSize(170,220) or makeSize(600,205);
  local bg = CommonSkeleton:getBoneTexture9DisplayBySize("commonBackgroundScalables/common_background_1",nil,size);
  self:addChild(bg);
  self.bg = bg;
  self:refreshItems();
  self.context.pageView:setMoveEnabled(false);

  if 1==table.getn(datas) then
    self:setPositionXY(495,90);
  else
    self:setPositionXY(45,90);
  end

  local textField = TextField.new(CCLabelTTF:create("长按药水可以连续使用 (当前可升到Lv." .. self:getMaxLevel() .. ")",FontConstConfig.OUR_FONT,20));
  textField.sprite:setColor(ccc3(255,0,0));
  textField:setPositionXY(195,162);
  self:addChild(textField);
end

function HeroShengjiBag:refreshItems()
  for k,v in pairs(self.items) do
    self:removeChild(v);
  end
  for k,v in pairs(self.textFields) do
    self:removeChild(v);
  end
  self.items = {};
  self.textFields = {};
  for k,v in pairs(self.datas) do
    local bagItem = BagItem.new();
    bagItem:initialize(v);
    bagItem.touchEnabled = true;
    bagItem.touchChildren = true;
    bagItem:setBackgroundVisible(true);
    bagItem:setPositionXY(35 + 145 * (-1 + k), 55);
    if 1 == table.getn(self.datas) then
      bagItem:setPositionX(5+bagItem:getPositionX());
    end
    if 0 < v.Count then
    	
    else
    	bagItem:setImageGray(true);
    end
    bagItem:addEventListener(DisplayEvents.kTouchBegin, self.onItemTap, self, bagItem);
    bagItem:addEventListener(DisplayEvents.kTouchEnd, self.onItemEnd, self, bagItem);
    self:addChild(bagItem);
    table.insert(self.items, bagItem);

    local textField = createTextFieldWithTextData({x=-5+bagItem:getPositionX(),y=-35+bagItem:getPositionY(),width=150,height=28,lineType="single line",size=24,color=getColorByQuality(analysis("Daoju_Daojubiao",v.ItemId,"color")),alignment=kCCTextAlignmentCenter,space=0,textType="static"},analysis("Daoju_Daojubiao",v.ItemId,"name"));
    textField:setPositionX(textField:getPositionX()-textField:getGroupBounds().size.width/2+bagItem:getGroupBounds().size.width/2);
    self:addChild(textField);
    table.insert(self.textFields, textField);
  end
end
local time_tb = {};
function HeroShengjiBag:onSche()
  self.onTapTime = 1 + self.onTapTime;
  local sign = 0;
  for k,v in pairs(time_tb) do
    if self.onTapTime > v then
      sign = k;
      table.remove(time_tb,k);
    end
  end
  if (0 == sign and 0 == table.getn(time_tb) and 0 == self.onTapTime % 2) or (0 ~= sign and 0 ~= table.getn(time_tb)) then
    if self.isOnTap and self.onTapBagItem then
      self:onAddExp();
    end
  end
end

function HeroShengjiBag:onAddExp()
  local data = self.onTapBagItem:getItemData();
  if 0 >= data.Count then
    --bagItem:removeEventListener(DisplayEvents.kTouchTap, self.onItemTap, self);
    sharedTextAnimateReward():animateStartByString("道具数量不足呢~");
    self:onItemEnd();
    return;
  end

  local excelName = self.context:getExcelName(self.generalId);
  local generalData = self.context.heroHouseProxy:getGeneralData(self.generalId);

  local _general_exp = self.context.heroHouseProxy:getExpByGeneralID(self.generalId);
  local _level = generalData.Level;

  if not analysisHas(excelName, 1 + _level) or (analysis("Xishuhuizong_Xishubiao",1093,"constant") <= _level) then
    sharedTextAnimateReward():animateStartByString("已经满级了哦~");
    self:onItemEnd();
    return;
  end
  if self.context.userProxy:getLevel() < 1 + _level and generalData.Experience == analysis(excelName, 1 + _level, "exp") then
    sharedTextAnimateReward():animateStartByString("英雄等级不能超过主角等级呢~");
    self:onItemEnd();
    return;
  end

  local exp = analysis("Daoju_Daojubiao",data.ItemId,"parameter1");
  exp = exp * ( 100000 + analysisWithCache("Huiyuan_Huiyuantequan",28,"vip" .. self.context.userProxy:getVipLevel()) ) / 100000;
  exp = math.floor(exp);
  self.onTapItemCount = 1 + self.onTapItemCount;
  self.onTapItemCount2 = exp + self.onTapItemCount2;

  while 0 < exp do
    local _needExp = analysis(excelName, 1 + _level, "exp"); 
    if _general_exp + exp > _needExp then
      if self.context.userProxy:getLevel() < 1 + _level then
        _general_exp = _needExp;
        exp = 0;
        break;
      end
      if not analysisHas(excelName, 1 + _level) or (analysis("Xishuhuizong_Xishubiao",1093,"constant") <= _level) then
        _level = 1 + _level;
        _general_exp = 0;
        exp = 0;
        break;
      end

      _level = 1 + _level;
      exp = exp + _general_exp - _needExp;
      _general_exp = 0;
    else
      _general_exp = _general_exp + exp;
      exp = 0;
      break;
    end
  end

  if generalData.Level ~= _level then
    local effect;
    local function onCall()
      if effect.parent then
        effect.parent:removeChild(effect);
      end
    end
    effect = cartoonPlayer(1691,self.bg:getContentSize().width/2,490, 1, onCall);
    self:addChildAt(effect,0);
  end

  generalData.Level = _level;
  generalData.Experience = _general_exp;

  -- local _needExp = analysis(self.context:getExcelName(self.generalId), 1 + _level, "exp");
  -- if 0 <= _general_exp - _needExp then
  --   _level = 1 + _level;
  --   _general_exp = _general_exp - _needExp;

  --   if self.context.userProxy:getLevel() < _level and 0 == generalData.IsMainGeneral then
  --     sharedTextAnimateReward():animateStartByString("英雄等级不能超过主角等级呢~");
  --     return;
  --   else
  --     -- sharedTextAnimateReward():animateStartByString("英雄升级成功~");
  --     local effect;
  --     local function onCall()
  --       if effect.parent then
  --         effect.parent:removeChild(effect);
  --       end
  --     end
  --     effect = cartoonPlayer(1691,self.bg:getContentSize().width/2,490, 1, onCall);
  --     self:addChildAt(effect,0);

  --     generalData.Level = _level;
  --     generalData.Experience = _general_exp;
  --   end
  -- else
  --   generalData.Experience = _general_exp;
  -- end

  data.Count = -1 + data.Count;
  local bag_count_string = data.Count;
  if 1 == tonumber(bag_count_string) then
    bag_count_string = " ";
  end
  self.onTapBagItem:setTextString(bag_count_string);
  
  if 0 >= data.Count then
    self.onTapBagItem:setImageGray(true);
  end

  self.context:refreshExpBag();  

  if GameVar.tutorStage == TutorConfig.STAGE_1010 then
    sendServerTutorMsg({});
    closeTutorUI();
    
    self:onItemEnd(event, self.onTapBagItem);
  end
end

function HeroShengjiBag:onItemTap(event, bagItem)
  MusicUtils:playEffect(2001,false)
  if self.context.heroHouseProxy.Shengji_Bool then
    return;
  end
  time_tb = {39,33,20};

  self.isOnTap = true;
  self.onTapTime = 0;
  self.onTapItemCount = 0;
  self.onTapItemCount2 = 0;
  self.onTapBagItem = bagItem;
  self.onTapEvent = event;
  removeSchedule(self, self.onSche);
  addSchedule(self, self.onSche);

  self:onAddExp();
end

function HeroShengjiBag:onItemEnd(event, bagItem)
  if not self.onTapBagItem or self.onTapItemCount and 0 == self.onTapItemCount then
    self.isOnTap = nil;
    self.onTapTime = nil;
    self.onTapItemCount = 0;
    self.onTapItemCount2 = 0;
    self.onTapBagItem = nil;
    self.onTapEvent = nil;
    removeSchedule(self, self.onSche);
    return;
  end
  self.context.heroHouseProxy.isIn6_11 = 1;
  print("HeroShengjiBag:onItemEnd",self.onTapBagItem:getItemData().ItemId,self.onTapItemCount,self.onTapItemCount2);
  sendMessage(6,11,{GeneralId=self.generalId,ItemId=self.onTapBagItem:getItemData().ItemId,Count=self.onTapItemCount,Count2=self.onTapItemCount2});
  self.context.heroHouseProxy.Shengji_Bool = true;

  self.isOnTap = nil;
  self.onTapTime = nil;
  self.onTapItemCount = 0;
  self.onTapItemCount2 = 0;
  self.onTapBagItem = nil;
  self.onTapEvent = nil;
  removeSchedule(self, self.onSche);
end

function HeroShengjiBag:getMaxLevel()
  local generalData = self.context.heroHouseProxy:getGeneralData(self.generalId);
  local _general_level = generalData.Level;
  local _general_exp = self.context.heroHouseProxy:getExpByGeneralID(self.generalId);
  local userLevel = self.context.userProxy:getLevel();
  local exp_supply = 0;
  for k,v in pairs(self.datas) do
    exp_supply = analysis("Daoju_Daojubiao",v.ItemId,"parameter1") * v.Count + exp_supply;
  end
  exp_supply = _general_exp + exp_supply;
  while analysisHas("Kapai_Kapaishengjijingyan",1 + _general_level) and (1 + _general_level) <= userLevel do
    local exp = analysis("Kapai_Kapaishengjijingyan",1 + _general_level,"exp");
    exp_supply = exp_supply - exp;
    if exp_supply >= 0 then
      _general_level = 1 + _general_level;
    else
      break;
    end
  end
  return _general_level;
end