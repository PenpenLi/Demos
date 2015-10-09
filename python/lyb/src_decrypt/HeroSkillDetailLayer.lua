HeroSkillDetailLayer=class(TouchLayer);

function HeroSkillDetailLayer:ctor()
  self.class=HeroSkillDetailLayer;
end

function HeroSkillDetailLayer:dispose()
  if self.bg.parent then
	 self.bg.parent:removeChild(self.bg);
   self.context.pageView:setMoveEnabled(true);
  end
  self.armature:dispose();
	HeroSkillDetailLayer.superclass.dispose(self);
end

function HeroSkillDetailLayer:initialize(context, generalID, skillID, type, is_not_jihuo)
	self.context = context;
	self.generalID = generalID;
	self.skillID = skillID;
	self.type = type;
  self.is_not_jihuo = is_not_jihuo;
	self.skeleton = self.context.skeleton;
  self.miaoshu_imgs = {};
  self.skill_type_img = nil;

	self:initLayer();

	self.bg = LayerColorBackGround:getOpacityBackGround();
	self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
	self.context:addChild(self.bg);
  --骨骼
  local armature=self.skeleton:buildArmature("skill_detail_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:setPositionXY(250,167);
  self:addChild(self.armature.display);

  local skill_data = analysis("Jineng_Jineng",self.skillID);
  local pos = self.armature.display:getChildByName("common_copy_grid"):getPosition();

  local img = Image.new();
  img:loadByArtID(skill_data.tpid);
  img:setPositionXY(8+pos.x,-98+pos.y);
  self.armature.display:addChild(img);

  local text=skill_data.name;
  local skill_name=createTextFieldWithTextData(armature:getBone("skill_name").textData,text);
  self.armature.display:addChild(skill_name);

  text="技能说明:";
  local skill_title_descb=createTextFieldWithTextData(armature:getBone("skill_title_descb").textData,text);
  self.armature.display:addChild(skill_title_descb);

  text="";
  local skill_descb=createTextFieldWithTextData(armature:getBone("skill_descb").textData,text);
  self.armature.display:addChild(skill_descb);
  self.skill_descb = skill_descb;

  -- text="升级条件:";
  -- local skill_upgrade=createTextFieldWithTextData(armature:getBone("skill_upgrade").textData,text);
  -- self.armature.display:addChild(skill_upgrade);
  -- self.skill_upgrade = skill_upgrade;

  self.armature.display:getChildByName("skill_silverl_need"):setScale(0.8);
  self.armature.display:getChildByName("skill_silverl_need"):setVisible(false);
  self.armature.display:getChildByName("common_image_separator_2"):setVisible(false);

  self.skill_level=createTextFieldWithTextData(armature:getBone("skill_level").textData,"");
  self.armature.display:addChild(self.skill_level);

  self.skill_cd=createTextFieldWithTextData(armature:getBone("skill_cd").textData,"");
  self.armature.display:addChild(self.skill_cd);

  -- self.skill_level_need=createTextFieldWithTextData(armature:getBone("skill_level_need").textData,"");
  -- self.armature.display:addChild(self.skill_level_need);

  -- self.skill_silverl_need=createTextFieldWithTextData(armature:getBone("skill_silverl_need").textData,"");
  -- self.armature.display:addChild(self.skill_silverl_need);

  local button=self.armature.display:getChildByName("common_blue_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  -- button=CommonButton.new();
  -- button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- button:initializeText(self.armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"升 级");
  -- -- button:initializeBMText("升星","anniutuzi");
  -- button:setPosition(button_pos);
  -- button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
  -- self.armature.display:addChild(button);
  -- self.button = button;

  self.context.pageView:setMoveEnabled(false);
end

function HeroSkillDetailLayer:refreshData()
	local generalData = self.context.heroHouseProxy:getGeneralData(self.generalID);
	local skillLevel = self.context.heroHouseProxy:getSkillLevel(self.generalID, self.skillID);
	local levelIsMax = skillLevel >= self.context.generalListProxy:getMaxLevel();
  if levelIsMax then
    -- self.skill_upgrade:setVisible(false);
    -- self.skill_level_need:setVisible(false);
    -- self.armature.display:getChildByName("skill_silverl_need"):setVisible(false);
    self.armature.display:getChildByName("yimanji_img"):setVisible(true);
    -- self.button:setVisible(false);
    -- return;
  else
    -- self.skill_upgrade:setVisible(true);
    -- self.skill_level_need:setVisible(true);
    -- self.armature.display:getChildByName("skill_silverl_need"):setVisible(true);
    self.armature.display:getChildByName("yimanji_img"):setVisible(false);
    -- self.button:setVisible(true); 

    local money_str = {"money1","money3","money2","money2"};
    local silver = self.levelIsMax and 0 or analysis("Jineng_Shengjixiaohao", 1+skillLevel, money_str[self.type]);
    self.moneyEnough = self.context.userCurrencyProxy:getSilver() >= silver;

    local lv_str = {"ZhuDong","WuXing","BeiDong","BeiDong"};
    local lv = self.levelIsMax and 999 or analysis("Jineng_Jinengdengjikongzhi", 1+skillLevel, lv_str[self.type]);
    self.level_need = lv;
    self.level_enough = self.level_need <= generalData.Level;
  end

	self.skill_level:setString("Lv." .. skillLevel .. (self.is_not_jihuo and " (未激活)" or ""));

  local s = "";
  local skill_data = analysis("Jineng_Jineng",self.skillID);
  if 2 == skill_data.typyP then
    s = "冷却: " .. skill_data.CD/1000 .. "秒";
  elseif 3 == skill_data.typyP then
    s = "怒气: " .. skill_data.xiaoHao .. "点";
  end
  self.skill_cd:setString(s);
  if self.skill_type_img then
    self.skill_type_img.parent:removeChild(self.skill_type_img);
    self.skill_type_img = nil;
  end
  self.skill_type_img = self.skeleton:getBoneTextureDisplay("skill_type_" .. skill_data.typyP);
  if self.skill_type_img then
    self.skill_type_img:setPositionXY(13,453);
    self.armature.display:addChild(self.skill_type_img);
  end

  for k,v in pairs(self.miaoshu_imgs) do
    v.parent:removeChild(v);
  end
  self.miaoshu_imgs = {};
  local miaoshus = skill_data.typePic;
  if miaoshus and "" ~= miaoshus then
    miaoshus = StringUtils:lua_string_split(miaoshus,",");
    for k,v in pairs(miaoshus) do
      local miaoshu_img = self.skeleton:getBoneTextureDisplay("skill_miaoshu_" .. v);
      if miaoshu_img then
        miaoshu_img:setPositionXY(300,440-(-1+k)*40);
        self.armature.display:addChild(miaoshu_img);
        table.insert(self.miaoshu_imgs, miaoshu_img);
      end
    end
  end

	-- self.skill_level_need:setString("Lv. " .. self.level_need);
  -- self.skill_level_need:setColor(self.level_enough and CommonUtils:ccc3FromUInt(16774615) or CommonUtils:ccc3FromUInt(16711680));
  -- self.skill_silverl_need:setString(self.levelIsMax and 0 or silver);
  -- self.skill_silverl_need:setColor(self.moneyEnough and CommonUtils:ccc3FromUInt(16774615) or CommonUtils:ccc3FromUInt(16711680));

  local skill_ids = {};
  local skill_xiaoguo_ids = {};
  local function getSkillID(skill_id)
    table.insert(skill_ids,skill_id);
    local effect = analysis("Jineng_Jineng",skill_id,"effect");
    if effect and "" == effect then
      return;
    end
    effect = StringUtils:lua_string_split(effect,",");
    for k,v in pairs(effect) do
      table.insert(skill_xiaoguo_ids,tonumber(v));
      local xiaoguo_data = analysis("Jineng_Jinengxiaoguo",tonumber(v));
      local actSkillTime = xiaoguo_data.actSkillTime;
      if actSkillTime and "" ~= actSkillTime then
        actSkillTime = StringUtils:lua_string_split(actSkillTime,",");
        for k_,v_ in pairs(actSkillTime) do
          getSkillID(tonumber(v_));
        end
      end
      local actSkill = xiaoguo_data.actSkill;
      if actSkill and "" ~= actSkill then
        actSkill = StringUtils:lua_string_split(actSkill,",");
        for k_,v_ in pairs(actSkill) do
          getSkillID(tonumber(v_));
        end
      end
      local pasSkill = xiaoguo_data.pasSkill;
      if pasSkill and "" ~= pasSkill then
        pasSkill = StringUtils:lua_string_split(pasSkill,",");
        for k_,v_ in pairs(pasSkill) do
          getSkillID(tonumber(v_));
        end
      end
    end
  end

  local xiaoguo_ids = {};
  local function getXiaoguoID(xiaoguo_id)
    table.insert(xiaoguo_ids,xiaoguo_id);
    local xiaoguo_data = analysis("Jineng_Jinengxiaoguo",xiaoguo_id);
    local actEffect = xiaoguo_data.actEffect;
    if actEffect and "" ~= actEffect then
      print(xiaoguo_id);
      actEffect = StringUtils:lua_string_split(actEffect,",");
      for k_,v_ in pairs(actEffect) do
        getXiaoguoID(tonumber(v_));
      end
    end
    local pasEffect = xiaoguo_data.pasEffect;
    if pasEffect and "" ~= pasEffect then
      pasEffect = StringUtils:lua_string_split(pasEffect,",");
      for k_,v_ in pairs(pasEffect) do
        getXiaoguoID(tonumber(v_));
      end
    end
  end

  getSkillID(self.skillID);
  for k,v in pairs(skill_xiaoguo_ids) do
    getXiaoguoID(v);
  end

  local text = "";
  for k,v in pairs(xiaoguo_ids) do
    local xiaoguo_data = analysis("Jineng_Jinengxiaoguo",v);
    local s = xiaoguo_data.describe;print(v);
    local a1 = (xiaoguo_data.chuShiJiaChen+xiaoguo_data.jiaChenZenJia*(-1+skillLevel))/1000;
    local a2 = xiaoguo_data.chuShiFuJiaGongJi+xiaoguo_data.chengZhangFuJiaGongJi*(-1+skillLevel);
    if 0 == a1 then

    else
      a2 = a1 * a2 / 100;
    end
    s = string.gsub(s,"@1",a1);
    s = string.gsub(s,"@2",math.floor(a2));
    text = text .. s;
  end
  self.skill_descb:setString(text);
end

function HeroSkillDetailLayer:onClose(event)
	self.parent:removeChild(self);
  self.context.heroXinxiRender.heroSkillDetailLayer = nil;
end

function HeroSkillDetailLayer:onButtonTap(event)
	-- if not self.level_enough then
	--   sharedTextAnimateReward():animateStartByString("英雄等级不足哟~");
	--    return;
	-- end
	-- if not self.moneyEnough then
	--     sharedTextAnimateReward():animateStartByString("银两不足哦~");
	--     Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
	--     self:onClose();
 --      return;
 --  end
 --  MusicUtils:playEffect(10,false);
 --  self:onLevelUpTap();


end

function HeroSkillDetailLayer:onLevelUpTap(event)
  if self.context.heroHouseProxy.Jinengshengji_Bool then
    return;
  end
  -- initializeSmallLoading();
  self:cacheData();
  local _sub_command;
  -- if 3 == self.type then
  --   _sub_command = 19;
  -- elseif 2 == self.type then
  --   _sub_command = 15;
  -- else
    _sub_command = 9;
  -- end
  print(self.generalID, self.skillID);
  -- initializeSmallLoading();
  sendMessage(6,_sub_command,{GeneralId = self.generalID, ConfigId = self.skillID});
  self.context.heroHouseProxy.Jinengshengji_Bool = true;
end

function HeroSkillDetailLayer:cacheData()
  local heroHouseProxy = self.context.heroHouseProxy;
  heroHouseProxy.skillLevelUpGeneralIDCache = self.generalID;
  heroHouseProxy.skillLevelUpSkillIDCache = self.skillID;
  heroHouseProxy.skillLevelUpIncreaseCache = 1;
end