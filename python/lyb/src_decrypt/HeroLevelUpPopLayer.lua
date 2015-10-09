HeroLevelUpPopLayer=class(LayerColor);

function HeroLevelUpPopLayer:ctor()
  self.class = HeroLevelUpPopLayer;
end

function HeroLevelUpPopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	HeroLevelUpPopLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function HeroLevelUpPopLayer:initialize(context, type, generalId, skillConfigId)
  self:initLayer();
  self.context = context;
  self.type = type;
  self.generalId = generalId;
  self.skillConfigId = skillConfigId;
  self.skeleton = self.context.skeleton;
  self.moneyEnough = false;

  local armature=self.skeleton:buildArmature("skillLevelUpPop_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local texts = {"琅琊决升级", "秘术升级", "天赋升级"};
  local text = texts[self.type];
  self.title_descb = createTextFieldWithTextData(armature:getBone("title_descb").textData,text);
  self.armature:addChild(self.title_descb);

  text = "";
  self.level_descb_1 = createTextFieldWithTextData(armature:getBone("level_descb_1").textData,text);
  self.armature:addChild(self.level_descb_1);

  text = "";
  self.level_descb_2 = createTextFieldWithTextData(armature:getBone("level_descb_2").textData,text);
  self.armature:addChild(self.level_descb_2);

  text = "";
  self.name_descb_1 = createTextFieldWithTextData(armature:getBone("name_descb_1").textData,text);
  self.armature:addChild(self.name_descb_1);

  text = "";
  self.name_descb_2 = createTextFieldWithTextData(armature:getBone("name_descb_2").textData,text);
  self.armature:addChild(self.name_descb_2);

  text = "";
  self.con_descb_1 = createTextFieldWithTextData(armature:getBone("con_descb_1").textData,text);
  self.armature:addChild(self.con_descb_1);

  text = "";
  self.con_descb_2 = createTextFieldWithTextData(armature:getBone("con_descb_2").textData,text);
  self.armature:addChild(self.con_descb_2);

  self.close_button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  self.close_button:addEventListener(Events.kStart,self.onCloseTap,self);

  self.levelUpBtn=Button.new(armature:findChildArmature("btn_1"),false);
  self.levelUpBtn.bone:initTextFieldWithString("common_small_blue_button","升级");
  self.levelUpBtn:addEventListener(Events.kStart,self.onLevelUpTap,self);

  self.levelMaxBtn=Button.new(armature:findChildArmature("btn_2"),false);
  self.levelMaxBtn.bone:initTextFieldWithString("common_small_blue_button","一键升级");
  self.levelMaxBtn:addEventListener(Events.kStart,self.onLevelMaxTap,self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
  self.armature:setPositionXY(409,162);

  self:refreshData();
end

function HeroLevelUpPopLayer:refreshData()
  local skillLevel = self.context.heroHouseProxy:getSkillLevel(self.generalId, self.skillConfigId);
  self.level_descb_1:setString("Lv " .. skillLevel);
  self.level_descb_2:setString("Lv " .. (1+skillLevel));

  local name = analysis(3 == self.type and "Kapai_Tianfu" or "Jineng_Jineng", self.skillConfigId, "name");
  self.name_descb_1:setString(name);
  self.name_descb_2:setString(name);
  self.con_descb_1:setString("升级条件 Lv " .. (1+skillLevel));

  local silver = 0;
  if 3 == self.type then
    silver = analysis("Kapai_Tianfu", 1+skillLevel, "money");
  elseif 2 == self.type then
    silver = analysis("Jineng_Shengjixiaohao", 1+skillLevel, "money2");
  elseif 1 == self.type then
    silver = analysis("Jineng_Shengjixiaohao", 1+skillLevel, "money1");
  end
  self.con_descb_2:setString(silver);
  self.moneyEnough = self.context.userCurrencyProxy:getSilver() > silver;
  self.levelIsMax = self.context.heroHouseProxy:getSkillLevel(self.generalId, self.skillConfigId) == self.context.generalListProxy:getMaxLevel();
end

function HeroLevelUpPopLayer:onCloseTap(event)
  self.parent:removeChild(self);
end

function HeroLevelUpPopLayer:onLevelUpTap(event)
  if not self.moneyEnough then
    sharedTextAnimateReward():animateStartByString("银两不足呢~");
    return;
  end
  if self.levelIsMax then
    sharedTextAnimateReward():animateStartByString("技能满级了呢~");
    return;
  end
  initializeSmallLoading();
  self:cacheData(false);
  local _sub_command;
  if 3 == self.type then
    _sub_command = 15;
  else
    _sub_command = 9;
  end
  print(self.generalId, self.skillConfigId);
  sendMessage(6,_sub_command,{GeneralId = self.generalId, ConfigId = self.skillConfigId});
  self:onCloseTap(nil);
end

function HeroLevelUpPopLayer:onLevelMaxTap(event)
  if not self.moneyEnough then
    sharedTextAnimateReward():animateStartByString("银两不足呢~");
    return;
  end
  if self.levelIsMax then
    sharedTextAnimateReward():animateStartByString("技能满级了呢~");
    return;
  end
  initializeSmallLoading();
  self:cacheData(true);
  local _sub_command;
  if 3 == self.type then
    _sub_command = 16;
  else
    _sub_command = 14;
  end
  print(self.generalId, self.skillConfigId);
  sendMessage(6,_sub_command,{GeneralId = self.generalId, ConfigId = self.skillConfigId});
  self:onCloseTap(nil);
end

function HeroLevelUpPopLayer:cacheData(isLevelUpMax)
  local heroHouseProxy = self.context.heroHouseProxy;
  heroHouseProxy.skillLevelUpGeneralIDCache = self.generalId;
  heroHouseProxy.skillLevelUpSkillIDCache = self.skillConfigId;

  local skillLevel = self.context.heroHouseProxy:getSkillLevel(self.generalId, self.skillConfigId);
  local levelMax = self.context.generalListProxy:getMaxLevel();
  local levelIncrease = 0;
  if isLevelUpMax then
    local silver = 0;
    if 3 == self.type then
      while analysisHas("Kapai_KapaiyanseduiyingID", 2+levelIncrease+skillLevel) do
        silver = analysis("Kapai_Tianfu", 1+levelIncrease+skillLevel, "money") + silver;
        if levelIncrease+skillLevel < levelMax and silver <= self.context.userCurrencyProxy:getSilver() then
          levelIncrease = 1 + levelIncrease;
        else
          break;
        end
      end
    else
      while analysisHas("Jineng_Shengjixiaohao", 1+levelIncrease+skillLevel) do
        silver = analysis("Jineng_Shengjixiaohao", 1+levelIncrease+skillLevel, "money" .. self.type) + silver;
        if levelIncrease+skillLevel < levelMax and silver <= self.context.userCurrencyProxy:getSilver() then
          levelIncrease = 1 + levelIncrease;
        else
          break;
        end
      end
    end
    heroHouseProxy.skillLevelUpIncreaseCache = levelIncrease;
  else
    heroHouseProxy.skillLevelUpIncreaseCache = 1;
  end
end