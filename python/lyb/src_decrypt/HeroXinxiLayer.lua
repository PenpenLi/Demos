HeroXinxiLayer=class(TouchLayer);

function HeroXinxiLayer:ctor()
  self.class=HeroXinxiLayer;
end

function HeroXinxiLayer:dispose()
  self.armature:dispose();
	HeroXinxiLayer.superclass.dispose(self);
end

function HeroXinxiLayer:initialize(context)
  self.context = context;
  self.bagProxy = self.context.bagProxy;
  self.equipmentInfoProxy = self.context.equipmentInfoProxy;
  self.skeleton = self.context.skeleton;
  self.items={};

  self:initLayer();
  --骨骼
  local armature=self.skeleton:buildArmature("xinxi_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local texts = {"品质","攻击","内防","生命","外防","会心","悟性"};
  for i=1,7 do
    local text=texts[i];
    local title=createTextFieldWithTextData(armature:getBone("title_" .. i).textData,text);
    self.armature.display:addChild(title);
    if 2 == i then
      self.gongji_title = title;
    end
  end

  self.descbs = {};
  for i=1,6 do
    local descb;
    if 1 == i then
      descb=createTextFieldWithTextData(armature:getBone("descb_" .. i).textData,"",true);
    else
      descb=createTextFieldWithTextData(armature:getBone("descb_" .. i).textData,"");
    end
    self.armature.display:addChild(descb);
    table.insert(self.descbs, descb);
  end

  local text="技能";
  local line=createTextFieldWithTextData(armature:getBone("line").textData,text);
  self.armature.display:addChild(line);

  text="属性";
  local line1=createTextFieldWithTextData(armature:getBone("line1").textData,text);
  self.armature.display:addChild(line1);

  local layer = Layer.new();
  layer:initLayer();
  layer:setPositionXY(322,302);
  layer:setScale(0.8);
  self.armature.display:addChild(layer);

  local button=self.armature.display:getChildByName("shengxing_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("shengxing_btn"):getBone("common_small_blue_button").textData,"提升");
  -- button:initializeBMText("升星","anniutuzi");
  -- button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onShengxingButtonTap,self);
  layer:addChild(button);

  local layer = Layer.new();
  layer:initLayer();
  layer:setPositionXY(322,229);
  layer:setScale(0.8);
  self.armature.display:addChild(layer);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("shengxing_btn"):getBone("common_small_blue_button").textData,"一键升级");
  button:addEventListener(DisplayEvents.kTouchTap,self.onYijianJinengButtonTap,self);
  layer:addChild(button);

  for i=1,4 do
    self["skill_name_" .. i]=createTextFieldWithTextData(armature:getBone("skill_name_" .. i).textData,"");
    self.armature.display:addChild(self["skill_name_" .. i]);
    self["skill_level_" .. i]=createTextFieldWithTextData(armature:getBone("skill_level_" .. i).textData,"");
    self.armature.display:addChild(self["skill_level_" .. i]);
    self["skill_silver_" .. i]=createTextFieldWithTextData(armature:getBone("skill_silver_" .. i).textData,"");
    self.armature.display:addChild(self["skill_silver_" .. i]);

    local button=self.armature.display:getChildByName("skill_btn_" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature.display:removeChild(button);

    button=CommonButton.new();
    button:initialize("skill_btn_normal","skill_btn_down",CommonButtonTouchable.BUTTON,self.skeleton);
    button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,self.onSkillButtonTap,self,i);
    self.armature.display:addChild(button);
    self["skill_button_" .. i]=button;

    local silver = self.armature.display:getChildByName("skill_silver_bg_" .. i);
    silver:setScale(0.5);
    silver:setPositionY(-22+silver:getPositionY());
    self["skill_silver_bg_" .. i]=silver;
  end

  self.stars_empty={};
  self.stars={};
  for i = 1,5 do
    local star_empty = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star_empty");
    star_empty:setScale(0.5);
    star_empty:setPositionXY( 42 * (-1 + i) + 108,305);
    self.armature.display:addChild(star_empty);
    self.stars_empty[i] = star_empty;

    local star = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
    star:setScale(0.5);
    star:setPositionXY( 42 * (-1 + i) + 108,305);
    self.armature.display:addChild(star);
    self.stars[i] = star;
  end

  self.bagItemBGs = {};
  self.bagItems = {};
  self.none_skill_texts = {};

  self.xiangxi_btn = self.armature.display:getChildByName("xiangxi_btn");
  SingleButton:create(self.xiangxi_btn);
  self.xiangxi_btn:addEventListener(DisplayEvents.kTouchTap,self.popXiangxiLayer,self);
  self.xiangxi_btn.parent:removeChild(self.xiangxi_btn,false);
  self:addChild(self.xiangxi_btn);

  self.jinjie_btn = self.armature.display:getChildByName("jinjie_btn");
  SingleButton:create(self.jinjie_btn);
  self.jinjie_btn:addEventListener(DisplayEvents.kTouchTap,self.onJinjieButtonTap,self);
  self.jinjie_btn.parent:removeChild(self.jinjie_btn,false);
  self:addChild(self.jinjie_btn);

  for i=1,5 do
    local red_dot = self.armature.display:getChildByName("effect" .. i);
    red_dot.parent:removeChild(red_dot,false);
    self:addChild(red_dot);
    self["effect" .. i] = red_dot;
    self["effect" .. i].touchEnabled = false;
  end

  local red_dot = self.armature.display:getChildByName("effect8");
  red_dot.parent:removeChild(red_dot,false);
  self:addChild(red_dot);
  self.effect8 = red_dot;
  self.effect8.touchEnabled = false;

  red_dot = self.armature.display:getChildByName("effect7");
  red_dot.parent:removeChild(red_dot,false);
  self:addChild(red_dot);
  self.effect7 = red_dot;
  self.effect7.touchEnabled = false;

  self.skill_level_tb = {};
end

function HeroXinxiLayer:refreshStar(star, star_max)
  for i=1,5 do
    self.stars_empty[i]:setVisible(i<=star_max);
    self.stars[i]:setVisible(i<=star);
  end
end

function HeroXinxiLayer:popXiangxiLayer(event)
  self.context:popXiangxi()
end

function HeroXinxiLayer:onJinjieButtonTap(event)
  if not self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_15) then
    sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    return;
  end

  if not analysisHas("Kapai_KapaiyanseduiyingID",1 + self.data.Grade) then
    sharedTextAnimateReward():animateStartByString("已经满阶了哦~");
    return;
  end

  -- if GameData.isMusicOn then
  --   MusicUtils:playEffect(10,false)
  -- end
  if GameVar.tutorStage == TutorConfig.STAGE_1004 then
    openTutorUI({x=877, y=100, width = 190, height = 60, alpha = 125});--, showPerson = true
  end
  self.heroJinjieLayer = HeroJinjieLayer.new();
  self.heroJinjieLayer:initialize(self.context, self.data.GeneralId);
  self.parent:addChild(self.heroJinjieLayer);
end

function HeroXinxiLayer:onShengxingButtonTap(event)
  -- local cons = analysis("Xishuhuizong_Xishubiao",1075,"constant");
  -- if cons > self.data.Level then
  --   sharedTextAnimateReward():animateStartByString((1 == self.data.IsMainGeneral and "主角" or "英雄") .. "需要达到" .. cons .. "级才可升星哦 ~");
  --   return;
  -- end

  if not self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_19) then
    sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    return;
  end

  local starLevel = self.data.StarLevel;
  local starMax = analysis("Kapai_Kapaiku",self.data.ConfigId,"star");
  local isMax = starLevel >= starMax;
  if isMax then
    sharedTextAnimateReward():animateStartByString("已经最高星级了呢~");
    return;
  end

  -- if GameData.isMusicOn then
  --   MusicUtils:playEffect(10,false)
  -- end

  self.heroShengxingLayer = HeroShengxingLayer.new();
  self.heroShengxingLayer:initialize(self.context, self.data.GeneralId);
  self.parent:addChild(self.heroShengxingLayer);

  if GameVar.tutorStage == TutorConfig.STAGE_1008 then
    openTutorUI({x=879, y=100, width = 192, height = 60, alpha = 125});
    -- openTutorUI({x=-200, y=-200, width = 2, height = 2, alpha = 125, fullScreenTouchable = true});
  end

end

function HeroXinxiLayer:refreshData(generalId)
  local data_p = self.data;
  self.data = self.context.heroHouseProxy:getGeneralData(generalId);

  self:refreshDataByJinjie();
  self:refreshEffect4Shengxing();

  self:refreshSkill();

  if self.heroSkillDetailLayer and self.heroSkillDetailLayer:isVisible() then
    self.heroSkillDetailLayer:refreshData();
  end
end

function HeroXinxiLayer:refreshEffect4Shengxing()
  local tb_data = analysis("Kapai_Kapaiku",self.data.ConfigId);
  local star = tb_data.star;
  self.data = self.context.heroHouseProxy:getGeneralData(self.data.GeneralId);
  self:refreshStar(self.data.StarLevel,star);
  if self.heroShengxingLayer and self.heroShengxingLayer:isVisible() then
    self.heroShengxingLayer:refreshData(self.data.GeneralId);
  end
end

function HeroXinxiLayer:refreshDataByJinjie()
  self.data = self.context.heroHouseProxy:getGeneralData(self.data.GeneralId);
  self:refreshXinxiText();
  if self.heroJinjieLayer and self.heroJinjieLayer:isVisible() then
    self.heroJinjieLayer:refreshData(self.data.GeneralId);
  end
  local tb_data = analysis("Kapai_Kapaiku",self.data.ConfigId);
  local colors = {"color1","color2","color3","color4"};
  for i=1,4 do
    if false == self["skill_name_" .. i]:isVisible() then
      if tb_data[colors[i]] and self.data.Grade >= tb_data[colors[i]] then
        self:refreshOneSkill(i);
      end
    end
  end
end

function HeroXinxiLayer:refreshXinxiText()
  local str = getHeroColorStringByGrade(self.data.Grade);
  if self.descbs[1] then
    self.descbs[1].parent:removeChild(self.descbs[1]);
    self.armature:getBone("descb_1").textData.color = getColorByQuality(getSimpleGrade(self.data.Grade));
    self.descbs[1]=createTextFieldWithTextData(self.armature:getBone("descb_1").textData,str,true);
    self.armature.display:addChild(self.descbs[1]);
  end
  self.descbs[2]:setString(math.ceil(self.context.heroHouseProxy:getZongPropValue(self.data.GeneralId,0 == analysis("Kapai_Kapaiku",self.data.ConfigId,"attackWai") and HeroPropConstConfig.NEI_GONG_JI or HeroPropConstConfig.GONG_JI)));
  self.descbs[3]:setString(math.ceil(self.context.heroHouseProxy:getZongPropValue(self.data.GeneralId,HeroPropConstConfig.NEI_FANG_YU)));
  self.descbs[4]:setString(math.ceil(self.context.heroHouseProxy:getZongPropValue(self.data.GeneralId,HeroPropConstConfig.SHENG_MING)));
  self.descbs[5]:setString(math.ceil(self.context.heroHouseProxy:getZongPropValue(self.data.GeneralId,HeroPropConstConfig.FANG_YU)));
  self.descbs[6]:setString(math.ceil(self.context.heroHouseProxy:getZongPropValue(self.data.GeneralId,HeroPropConstConfig.HUI_XIN)));
  self.gongji_title:setString(0 == analysis("Kapai_Kapaiku",self.data.ConfigId,"attackWai") and "内攻" or "外攻");
end

function HeroXinxiLayer:refreshBySilver()
  self:refreshSkill();
  
  if self.heroShengxingLayer and self.heroShengxingLayer:isVisible() then
    self.heroShengxingLayer:refreshData(self.data.GeneralId);
  end

  if self.heroJinjieLayer and self.heroJinjieLayer:isVisible() then
    self.heroJinjieLayer:refreshData(self.data.GeneralId);
  end
end

function HeroXinxiLayer:onSkillTap(event, data)
  self.heroSkillDetailLayer = HeroSkillDetailLayer.new();
  self.heroSkillDetailLayer:initialize(self.context, self.data.GeneralId, data[1], data[2], self.none_skill_texts[data[2]]);
  self.context:addChild(self.heroSkillDetailLayer);
  self.heroSkillDetailLayer:refreshData();

  if GameVar.tutorStage == TutorConfig.STAGE_1009 and GameVar.tutorSmallStep == 3 then
    self.tutorLayer = Layer.new();
    self.tutorLayer:initLayer();
    self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
    self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
    self.context:addChild(self.tutorLayer)
    openTutorUI({x=1132, y=327, width = 75, height = 120, fullScreenTouchable = true, alpha = 125, hideTutorHand = true, blackBg = true});
  end
end

function HeroXinxiLayer:onTutorTap(event)

  if not self.tutorSkillStep then
    self.tutorSkillStep = 1;
  end
  if self.tutorSkillStep == 1 then
    self.context:removeChild(self.heroSkillDetailLayer);
    self.heroSkillDetailLayer = nil;
    openTutorUI({x=1000-11, y=250+3, width = 102, height = 48, alpha = 125, hideTutorHand = true, twinkle = true, fullScreenTouchable = true});
  else
    self.context:removeChild(self.tutorLayer)
    sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100902, BooleanValue = 0})
    openTutorUI({x=1134, y=327, width = 76, height = 112, alpha = 125});
  end
  self.tutorSkillStep = self.tutorSkillStep + 1;

end

function HeroXinxiLayer:refreshOneSkill(i)
  local tb_data = analysis("Kapai_Kapaiku",self.data.ConfigId);
  local skills = {"one","two","skill","skill2"};
  local colors = {"color1","color2","color3","color4"};
  local poss = {makePoint(25,142),makePoint(241,142),makePoint(25,39),makePoint(241,39)};
  local bagItemSize = makeSize(90,90);
  local skill_data = nil;
  if tb_data[skills[i]] and 0 ~= tb_data[skills[i]] then
    skill_data = analysis("Jineng_Jineng",tb_data[skills[i]]);
  end

  self.armature.display:removeChild(self.bagItemBGs[i]);
  self.bagItemBGs[i] = nil;
  self.armature.display:removeChild(self.bagItems[i]);
  self.bagItems[i] = nil;
  self.armature.display:removeChild(self.none_skill_texts[i]);
  self.none_skill_texts[i] = nil;

  if skill_data then
    local bagItemBG = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
    bagItemBG:setPositionXY(-6+poss[i].x,-7+poss[i].y);
    bagItemBG:setScale(0.76);
    self.armature.display:addChild(bagItemBG);
    self.bagItemBGs[i]=bagItemBG;

    self.bagItems[i] = Image.new();
    self.bagItems[i]:loadByArtID(skill_data.tpid);
    self.bagItems[i]:setPosition(poss[i]);
    self.bagItems[i]:setScale(0.76);
    self.bagItems[i]:addEventListener(DisplayEvents.kTouchTap,self.onSkillTap,self,{tb_data[skills[i]],i});
    self.armature.display:addChild(self.bagItems[i]);

    self.skill_level_tb[i] = nil;
    if tb_data[colors[i]] and self.data.Grade < tb_data[colors[i]] then
      local bg = CommonSkeleton:getBoneTexture9DisplayBySize("commonImages/common_item_num_bg",nil,bagItemSize);
      bg:setPositionXY(0,0);
      self.bagItems[i]:addChild(bg);

      local textField=TextField.new(CCLabelTTF:create(getHeroColorStringByGrade(tb_data[colors[i]]) .. "\n解 锁",FontConstConfig.OUR_FONT,20));
      local sizeText=textField:getContentSize();
      textField:setColor(CommonUtils:ccc3FromUInt(5511945));
      textField:setPositionXY(95+poss[i].x,5+poss[i].y);
      self.armature.display:addChild(textField);
      self.none_skill_texts[i] = textField;

      self["skill_name_" .. i]:setVisible(false);
      self["skill_level_" .. i]:setVisible(false);
      self["skill_silver_" .. i]:setVisible(false);
      self["skill_button_" .. i]:setVisible(false);
      self["skill_silver_bg_" .. i]:setVisible(false);
      self.armature.display:getChildByName("skill_name_" .. i):setVisible(false);
      self.armature.display:getChildByName("skill_level_" .. i):setVisible(false);
      self.armature.display:getChildByName("skill_silver_" .. i):setVisible(false);

      self["gradeEnough_" .. i] = nil;
      self["moneyEnough_" .. i] = nil;
      self["level_enough_" .. i] = nil;
    else
      self["gradeEnough_" .. i] = true;
      -- local lv_str = {"ZhuDong","WuXing","BeiDong","BeiDong"};
      local money_str = {"money1","money2","money3","money4"};
      local skillLevel = self.context.heroHouseProxy:getSkillLevel(self.data.GeneralId, tb_data[skills[i]]);
      local levelIsMax = skillLevel >= self.context.generalListProxy:getMaxLevel();
      self.skill_level_tb[i] = skillLevel;
      local silver = levelIsMax and 0 or analysis("Jineng_Shengjixiaohao", 1+skillLevel, money_str[i]);  
      self["moneyEnough_" .. i] = self.context.userCurrencyProxy:getSilver() >= silver;
      local lv = levelIsMax and 999 or 1+skillLevel;--analysis("Jineng_Jinengdengjikongzhi", 1+skillLevel, lv_str[i]);
      self.level_need = lv;
      self["level_enough_" .. i] = self.level_need <= self.data.Level;

      self["skill_name_" .. i]:setString(skill_data.name);
      self["skill_level_" .. i]:setString("Lv." .. skillLevel);
      self["skill_silver_" .. i]:setString(silver);
      self["skill_silver_" .. i]:setColor(self["moneyEnough_" .. i] and CommonUtils:ccc3FromUInt(5511945) or CommonUtils:ccc3FromUInt(16711680));

      self["skill_name_" .. i]:setVisible(true);
      self["skill_level_" .. i]:setVisible(true);
      self["skill_silver_" .. i]:setVisible(true);
      self["skill_button_" .. i]:setVisible(true);
      self["skill_silver_bg_" .. i]:setVisible(true);
      self.armature.display:getChildByName("skill_name_" .. i):setVisible(true);
      self.armature.display:getChildByName("skill_level_" .. i):setVisible(true);
      self.armature.display:getChildByName("skill_silver_" .. i):setVisible(true);
    end
  end
end
function HeroXinxiLayer:refreshSkill()
  for i=1,4 do
    self:refreshOneSkill(i);
  end
  self:refreshRedDot();
end

function HeroXinxiLayer:refreshDataBySkillLevelUp(generalID, skillID)
  if self.data.GeneralId ~= generalID then
    return;
  end
  local tb_data = analysis("Kapai_Kapaiku",self.data.ConfigId);
  local skills = {"one","two","skill","skill2"};
  local colors = {"color1","color2","color3","color4"};
  for i=1,4 do
    local skill_data = nil;
    if 0 == skillID or (tb_data[skills[i]] and skillID == tb_data[skills[i]]) then
      skill_data = analysis("Jineng_Jineng",tb_data[skills[i]]);
      local money_str = {"money1","money2","money3","money4"};
      local skillLevel = self.context.heroHouseProxy:getSkillLevel(self.data.GeneralId, tb_data[skills[i]]);
      local levelIsMax = skillLevel >= self.context.generalListProxy:getMaxLevel();

      local silver = levelIsMax and 0 or analysis("Jineng_Shengjixiaohao", 1+skillLevel, money_str[i]);  
      self["moneyEnough_" .. i] = self.context.userCurrencyProxy:getSilver() >= silver;
      local lv = levelIsMax and 999 or 1+skillLevel;--analysis("Jineng_Jinengdengjikongzhi", 1+skillLevel, lv_str[i]);
      self.level_need = lv;
      self["level_enough_" .. i] = self.level_need <= self.data.Level;

      self["skill_level_" .. i]:setString("Lv." .. skillLevel);
      self["skill_silver_" .. i]:setString(silver);
      self["skill_silver_" .. i]:setColor(self["moneyEnough_" .. i] and CommonUtils:ccc3FromUInt(5511945) or CommonUtils:ccc3FromUInt(16711680));
      
      if not self.none_skill_texts[i] and 0 ~= skillID or (self.skill_level_tb[i] and self.skill_level_tb[i] < skillLevel) then
        local effect;
        local function onCall()
          if effect.parent then
            effect.parent:removeChild(effect);
          end
        end
        effect = cartoonPlayer(1694,33+self.bagItems[i]:getPositionX(), 53+self.bagItems[i]:getPositionY(), 1, onCall);
        self:addChild(effect);
      end

      self.skill_level_tb[i] = skillLevel;
    end
  end
end

function HeroXinxiLayer:onYijianJinengButtonTap(event)
  MusicUtils:playEffect(10,false);
  if not getGongnengkaiqiWithTishi(FunctionConfig.FUNCTION_ID_17) then
    return;
  end
  if self.context.heroHouseProxy.Jinengshengji_Bool then
    return;
  end
  for i=1,4 do
    if self["level_enough_" .. i] and self["moneyEnough_" .. i] and self["gradeEnough_" .. i] then
      local heroHouseProxy = self.context.heroHouseProxy;
      heroHouseProxy.skillLevelUpGeneralIDCache = self.data.GeneralId;
      heroHouseProxy.skillLevelUpSkillIDCache = 0;
      heroHouseProxy.skillLevelUpIncreaseCache = 1;

      sendMessage(6,9,{GeneralId = self.data.GeneralId, Type = 0});
      self.context.heroHouseProxy.Jinengshengji_Bool = true;
      return;
    end
  end

  for i=1,4 do
    if not self["level_enough_" .. i] then
      sharedTextAnimateReward():animateStartByString("英雄等级不足哟~");
      return;
    end
    if not self["moneyEnough_" .. i] then
      sharedTextAnimateReward():animateStartByString("银两不足哦~");
      Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
      return;
    end
  end
end

function HeroXinxiLayer:onSkillButtonTap(event, data)

  -- if GameVar.tutorStage == TutorConfig.STAGE_1009 then
  --   sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100902, BooleanValue = 0})
  --   openTutorUI({x=1134, y=327, width = 76, height = 112, alpha = 125});
  -- end
  if not getGongnengkaiqiWithTishi(FunctionConfig.FUNCTION_ID_17) then
    return;
  end
  if self.context.heroHouseProxy.Jinengshengji_Bool then
    return;
  end
  local tb_data = analysis("Kapai_Kapaiku",self.data.ConfigId);
  local skills = {"one","two","skill","skill2"};
  local skillID = tb_data[skills[data]];
  MusicUtils:playEffect(10,false);
  if not self["level_enough_" .. data] then
    sharedTextAnimateReward():animateStartByString("英雄等级不足哟~");
    return;
  end
  if not self["moneyEnough_" .. data] then
      sharedTextAnimateReward():animateStartByString("银两不足哦~");
      Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
      return;
  end

  local heroHouseProxy = self.context.heroHouseProxy;
  heroHouseProxy.skillLevelUpGeneralIDCache = self.data.GeneralId;
  heroHouseProxy.skillLevelUpSkillIDCache = skillID;
  heroHouseProxy.skillLevelUpIncreaseCache = 1;

  sendMessage(6,9,{GeneralId = self.data.GeneralId, Type = data});
  self.context.heroHouseProxy.Jinengshengji_Bool = true;
end

function HeroXinxiLayer:refreshRedDot()
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  if data.Skillable then
    for i=1,4 do
      self["effect" .. i]:setVisible(1 == data.Skillable[i]);
    end
    self["effect5"]:setVisible(false);
  else
    for i=1,4 do
      self["effect" .. i]:setVisible(false);
    end
    self["effect5"]:setVisible(false);
  end
  
  for i=1,6 do
    -- if data.Sign_BetterEquip and 1 == data.Sign_BetterEquip[i] then
    --   self.armature.display:getChildByName("effect" .. i):setVisible(false);
    -- elseif data.BetterEquip and 1 == data.BetterEquip[i] then
    --   self.armature.display:getChildByName("effect" .. i):setVisible(true);
    -- else
      -- self.armature.display:getChildByName("effect" .. i):setVisible(false);
    -- end
  end
  self.effect7:setVisible(data.Gradeable);-- and self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_15));
  self.effect8:setVisible(data.StarLevelable);-- and self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_19));
end

function HeroXinxiLayer:onBagItemTap(event, bagItem)
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  local num = analysis("Zhuangbei_Zhuangbeipeizhibiao",bagItem:getItemData().ItemId,"place");
  -- data.Sign_BetterEquip[num] = 1;
  self.armature.display:getChildByName("effect" .. num):setVisible(false);

  local tipBg=LayerColorBackGround:getOpacityBackGround();
  local layer=EquipDetailLayer.new();
  local function closeTip(event)
    tipBg.parent:removeChild(tipBg);
    layer.parent:removeChild(layer);

    self.context.pageView:setMoveEnabled(true);
  end
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchBegin,closeTip);
  self.parent.parent:addChild(tipBg);
  layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,nil,BagItemType.OnHeroPro,closeTip);
  local size=self.parent:getContentSize();
  local popupSize=layer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  self.parent.parent:addChild(layer);

  self.context.pageView:setMoveEnabled(false);
end

function HeroXinxiLayer:refreshEquip()
  -- if true then return;end
  -- local equipArr = self.context.selectedData.UsingEquipmentArray;
  -- local equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  local equipArr = self.context.equipmentInfoProxy:getEquipsByHeroID(self.context.selectedData.GeneralId);
  for i=1,6 do
    -- self.armature.display:getChildByName("wenzi_" .. i):setVisible(false);
    local pos = convertBone2LB(self.armature.display:getChildByName("grid_" .. i));
    self.armature.display:removeChild(self.items[i]);
    self.items[i] = nil;
    self.items[i] = BagItem.new();
    self.items[i]:initialize(equipArr[i]);
    self.items[i].touchEnabled = true;
    self.items[i].touchChildren = true;
    self.items[i]:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X+pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+pos.y);
    self.items[i]:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,self.items[i]);
    self.armature.display:addChildAt(self.items[i],30);
    -- local userItemId;
    -- local itemId;
    -- for k,v in pairs(equipArr) do
    --   userItemId = nil
    --   itemId = nil;
    --   local itemIdByUser = self.bagProxy:getItemData(v.UserEquipmentId).ItemId;
    --   local typeId = tonumber(string.sub(""..itemIdByUser,1,1));
    --   if typeId == i then
    --     userItemId = v.UserEquipmentId;
    --     itemId = itemIdByUser;
    --     break;
    --   end
    -- end
    -- if userItemId then
    --   if self.items[i] and self.items[i]:getUserItemID() == userItemId then
       
    --   else
    --     local pos = convertBone2LB(self.armature.display:getChildByName("grid_" .. i));
    --     self.armature.display:removeChild(self.items[i]);
    --     self.items[i] = nil;
    --     self.items[i] = BagItem.new();
    --     self.items[i]:initialize({UserItemId=userItemId,ItemId=itemId,Count=1,IsUsing=1,Place=0});
    --     self.items[i]:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X+pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+pos.y);
    --     self.armature.display:addChildAt(self.items[i],30);
    --   end
    -- else
    --   if self.items[i] then
    --     self.armature.display:removeChild(self.items[i]);
    --     self.items[i] = nil;
    --   end
    -- end
  end
end

function HeroXinxiLayer:onBTNTap(event)
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  for k,v in pairs(data.Sign_BetterEquip) do
    data.Sign_BetterEquip[k] = 1;
  end
  self:refreshRedDot();

  local usingEquipmentArray = self.data.UsingEquipmentArray;
  local tb = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0};
  for k,v in pairs(usingEquipmentArray) do
    local itemDataByUser = self.bagProxy:getItemData(v.UserEquipmentId);
    local typeId = tonumber(string.sub(""..itemDataByUser.ItemId,1,1));
    tb[typeId] = itemDataByUser;
  end
  local data = {};
  local hasNoEquip = true;
  for k,v in pairs(tb) do
    local datas = self.bagProxy:getEquipDataNotUsedByPlace(k);
    hasNoEquip = hasNoEquip and 0 == table.getn(datas);
    if 0 < table.getn(datas) then
      local equip = 0 == v and datas[1] or v;
      local bool = false;
      for k_,v_ in pairs(datas) do
        --print(equip.ItemId,v_.ItemId,self.context.equipmentInfoProxy:getZhanli(v_.UserItemId),self.context.equipmentInfoProxy:getZhanli(equip.UserItemId));
        if --analysis("Daoju_Daojubiao",v_.ItemId,"color") >
           --analysis("Daoju_Daojubiao",equip.ItemId,"color") then
           self.context.equipmentInfoProxy:getZhanli(v_.UserItemId) >
           self.context.equipmentInfoProxy:getZhanli(equip.UserItemId) then
           equip = v_;
           bool = true;
        end
      end
      if bool or 0 == v then
        table.insert(data,{ID = equip.UserItemId});--equip.UserItemId);
      end
    end
  end
  if 0 < table.getn(data) then
    initializeSmallLoading();
    sendMessage(6,18,{GeneralId=self.data.GeneralId,IDArray=data});
  elseif hasNoEquip then
  	sharedTextAnimateReward():animateStartByString("当前没有可穿戴的装备哦~");
  else
    sharedTextAnimateReward():animateStartByString("没有找到更好的装备呢~");
  end
end

function HeroXinxiLayer:onBGTap(event)
  self.id = nil;
  if self.detailBG then
    self.detailBG.parent:removeChild(self.detailBG);
    self.detailBG = nil;
  end
  if self.detailLayer then
    self.detailLayer.parent:removeChild(self.detailLayer);
    self.detailLayer = nil;
  end
  self.context.pageView:setMoveEnabled(true);
end

function HeroXinxiLayer:removeChangeEquipeRender()
  self.id = nil;
  if self.changeEquipeRender then
    self.changeEquipeRender.parent:removeChild(self.changeEquipeRender);
    self.changeEquipeRender = nil;
  end
end

--武器 项链 衣服 头部 鞋子 饰品
function HeroXinxiLayer:clickEquipe(event, num)
  if true then return; end
  if not self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_14) then
    sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    return;
  end
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  data.Sign_BetterEquip[num] = 1;
  self.armature.display:getChildByName("effect" .. num):setVisible(false);

  if self.id == num then
    self:onBGTap();
  else
    self.id = num;--不同的id对应不同的位置
    if self.items[num] then--showTips
      -- if self.detailLayer then
      --   self.context:removeChild(self.detailLayer);
      --   self.detailLayer = nil;
      -- end

      self.detailBG = LayerColorBackGround:getOpacityBackGround();
      self.detailBG:addEventListener(DisplayEvents.kTouchBegin,self.onBGTap,self);
      self.context:addChild(self.detailBG);

      self.bagSkeleton = self.bagProxy:getSkeleton();
      self.detailLayer = EquipDetailLayer.new();
      self.detailLayer:initialize(self.bagSkeleton,self.items[num],true,nil,BagItemType.putOffEquipeItem);
      self.context:addChild(self.detailLayer);

      local size=self.context:getContentSize();
      local popupSize=self.detailLayer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
      self.detailLayer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));

      self.detailLayer:addEventListener("PutOnEquip", self.PutOnEquip,self);
      self.detailLayer:addEventListener("OpenEquip", self.OpenEquip,self);

      self.context.pageView:setMoveEnabled(false);

    else--showChuanZhuang

      self.changeEquipeRender = HeroChangeEquipeRender:create(self,self.id,nil);
      self.context:addChild(self.changeEquipeRender);
      self.changeEquipeRender:addEventListener("onEquip", self.onEquip,self);

    end
  end
end

function HeroXinxiLayer:PutOnEquip(event)
  -- local userItemId = event.data;
  if self.context.bagProxy:getBagIsFull() then
    sharedTextAnimateReward():animateStartByString("背包满了哦 ~");
    return;
  end
  local userItemId = self.items[self.id]:getItemData().UserItemId;
  -- -- print("lalalalllllllllllllllllllllllllllllllllllllllllll=="..userItemId);
  initializeSmallLoading(2);
  self.context:dispatchEvent(Event.new("offEquip",{GeneralId = self.context.selectedData.GeneralId,UserEquipmentId = userItemId},self));
  self:onBGTap();
end

function HeroXinxiLayer:OpenEquip(event)
  self.changeEquipeRender = HeroChangeEquipeRender:create(self,self.id,self.items[self.id]);
  self.context:addChild(self.changeEquipeRender);
  self.changeEquipeRender:addEventListener("onEquip", self.onEquip,self);
  self:onBGTap();
  self.context.pageView:setMoveEnabled(false);
end

function HeroXinxiLayer:onEquip(event)
  local userItemId = event.data;
  print("lalalalllllllllllllllllllllllllllllllllllllllllll=="..userItemId);
  self.context:dispatchEvent(Event.new("onEquip",{GeneralId = self.context.selectedData.GeneralId,UserEquipmentId = userItemId},self));
end