SrengthenUI=class(Layer);

function SrengthenUI:ctor()
  self.class=SrengthenUI;
end

function SrengthenUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SrengthenUI.superclass.dispose(self);
  self.armature:dispose();
end

function SrengthenUI:initialize(context)
	self.context = context;
  self.skeleton = self.context.skeleton;
	self:initLayer();
  self.bagItemSelected = nil;
  
  local armature=self.skeleton:buildArmature("strengthen_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  self.contentLayer = Layer.new();
  self.contentLayer:initLayer();
  self:addChild(self.contentLayer);

  local circle_bg = self.armature.display:getChildByName("circle_bg");
  circle_bg.parent:removeChild(circle_bg,false);
  self.contentLayer:addChild(circle_bg);
  local name_bg = self.armature.display:getChildByName("name_bg");
  name_bg.parent:removeChild(name_bg,false);
  self.contentLayer:addChild(name_bg);
  local arrow_1 = self.armature.display:getChildByName("arrow_1");
  arrow_1.parent:removeChild(arrow_1,false);
  self.contentLayer:addChild(arrow_1);
  local arrow_2 = self.armature.display:getChildByName("arrow_2");
  arrow_2.parent:removeChild(arrow_2,false);
  self.contentLayer:addChild(arrow_2);

  self.descb=createTextFieldWithTextData(self.armature:getBone("descb").textData,"此装备强化等级已满哦 ~",true);
  self.armature.display:addChild(self.descb);

  self.name_bg=createTextFieldWithTextData(self.armature:getBone("name_bg").textData,"");
  self.contentLayer:addChild(self.name_bg);

  self.level_descb=createTextFieldWithTextData(self.armature:getBone("level_descb").textData,"");
  self.contentLayer:addChild(self.level_descb);

  self.level_s_descb=createTextFieldWithTextData(self.armature:getBone("level_s_descb").textData,"");
  self.contentLayer:addChild(self.level_s_descb);

  self.prop_descb=createTextFieldWithTextData(self.armature:getBone("prop_descb").textData,"");
  self.contentLayer:addChild(self.prop_descb);

  self.prop_s_descb=createTextFieldWithTextData(self.armature:getBone("prop_s_descb").textData,"");
  self.contentLayer:addChild(self.prop_s_descb);

  self.silver_descb=createTextFieldWithTextData(self.armature:getBone("silver_descb").textData,"");
  self.contentLayer:addChild(self.silver_descb); 

  local vip_need = 0;
  local vip_data = analysis("Huiyuan_Huiyuantequan",2);
  for i = 1, 15 do
    if 0 < vip_data["vip" .. i] then
      vip_need = i;
      break;
    end
  end
  self.prop_descb0=createTextFieldWithTextData(self.armature:getBone("prop_descb0").textData,"VIP" .. vip_need .. "开启");
  self.contentLayer:addChild(self.prop_descb0);

  --common_small_blue_button
  local common_small_blue_button=self.armature.display:getChildByName("btn_2");
  local common_small_blue_button_pos=convertBone2LB4Button(common_small_blue_button);
  self.armature.display:removeChild(common_small_blue_button);

  local common_small_blue_button=CommonButton.new();
  common_small_blue_button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- common_small_blue_button:initializeText(self.armature:findChildArmature("common_small_blue_button"):getBone("common_small_blue_button").textData,"一键强化");
  common_small_blue_button:initializeBMText("全身强化","anniutuzi");
  common_small_blue_button:setPosition(common_small_blue_button_pos);
  common_small_blue_button:addEventListener(DisplayEvents.kTouchTap,self.onStrengthenToTopTap,self);
  self.contentLayer:addChild(common_small_blue_button);
  self.strengthenToTopButton=common_small_blue_button;

  --common_small_blue_button0
  local common_small_blue_button0=self.armature.display:getChildByName("btn_1");
  local common_small_blue_button0_pos=convertBone2LB4Button(common_small_blue_button0);
  self.armature.display:removeChild(common_small_blue_button0);

  local common_small_blue_button0=CommonButton.new();
  common_small_blue_button0:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- common_small_blue_button0:initializeText(self.armature:findChildArmature("common_small_blue_button0"):getBone("common_small_blue_button").textData,"强 化");
  common_small_blue_button0:initializeBMText("强 化","anniutuzi");
  common_small_blue_button0:setPosition(common_small_blue_button0_pos);
  common_small_blue_button0:addEventListener(DisplayEvents.kTouchTap,self.onStrengthenTap,self);
  self.contentLayer:addChild(common_small_blue_button0);
  self.strengthenButton=common_small_blue_button0;

  self.silver_img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
  self.silver_img:setScale(0.8);
  self.silver_img:setPositionXY(800,168);
  self.contentLayer:addChild(self.silver_img);
end

function SrengthenUI:onStrengthenTap(event)
  if self.bagItemSelected then
    -- self:dispatchEvent(Event.new("onStrengthen",self.bagItemSelected:getUserItemID(),self));
    if self.context.strengthenProxy.Qianghua_Bool then
      return;
    end
    self:checkTutor();
    local data = self.bagItemSelected:getItemData();
    local data_general = self.context.heroHouseProxy:getGeneralData(data.GeneralId);
    if data.StrengthenLevel >= data_general.Level then
      sharedTextAnimateReward():animateStartByString("强化等级不能超过" .. (1==data_general.IsMainGeneral and "主角" or "英雄") .. "等级哦 ~");
      return;
    end
    if not self.silver_is_enough then

      sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
      Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
      return;
    end
    -- initializeSmallLoading();
    sendMessage(10,2,{GeneralId=data.GeneralId,ItemId=data.ItemId,BooleanValue=0});
    self.context.strengthenProxy.Qianghua_Bool = true;
  end
end

function SrengthenUI:checkTutor()
    if GameVar.tutorStage == TutorConfig.STAGE_1020 then
      if not self.levelUpCount then
        self.levelUpCount = 1;
      else
        self.levelUpCount = self.levelUpCount + 1;
      end
      if self.levelUpCount < 3 then
        openTutorUI({x=627, y=88, width = 190, height = 60, alpha = 125});--, showPerson = true
      else
        openTutorUI({x=-200, y=-200, width = 2, height = 2, alpha = 125, fullScreenTouchable = true});--, showPerson = true
      end
      sendServerTutorMsg({BooleanValue = 0})
    end
end
function SrengthenUI:onStrengthenToTopTap(event)
  if self.context.strengthenProxy.Qianghua_Bool then
    return;
  end
  local vipLevel = self.context.userProxy:getVipLevel();
  local vip_need = 0;
  local vip_data = analysis("Huiyuan_Huiyuantequan",2);
  for i = 1, 15 do
    if 0 < vip_data["vip" .. i] then
      vip_need = i;
      break;
    end
  end
  
  if vipLevel < vip_need then
    sharedTextAnimateReward():animateStartByString("VIP" .. vip_need .. "可以开启全身强化功能哦 ~");
    return;
  end

  local sign_1;
  local sign_2;
  local general_data;
  for i = 1, 6 do
    local data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.bagItemSelected:getItemData().GeneralId,i);
    local data_general = self.context.heroHouseProxy:getGeneralData(data.GeneralId);
    general_data = data_general;
    -- if data.StrengthenLevel >= data_general.Level then
    --   sharedTextAnimateReward():animateStartByString("强化等级不能超过" .. (1==data_general.IsMainGeneral and "主角" or "英雄") .. "等级哦 ~");
    --   return;
    -- end
    -- if not self.silver_is_enough then
    --   sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
    --   return;
    -- end
    local silver = self:getSilverDescb(1+data.StrengthenLevel);
    local silver_is_enough = self.context.userCurrencyProxy:getSilver() >= silver;

    local level_enough = data.StrengthenLevel < data_general.Level;

    if not silver_is_enough then
      sign_1 = true;
    end
    if not level_enough then
      sign_2 = true;
    end

    if level_enough and silver_is_enough then
      initializeSmallLoading();
      sendMessage(10,2,{GeneralId=data.GeneralId,ItemId=data.ItemId,BooleanValue=1});
      self.context.strengthenProxy.Qianghua_Bool = true;
      return;
    end
  end
  if sign_1 then
    sharedTextAnimateReward():animateStartByString("银两不足了哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
  elseif sign_2 then
    sharedTextAnimateReward():animateStartByString("强化等级不能超过" .. (1==general_data.IsMainGeneral and "主角" or "英雄") .. "等级哦 ~");
  end
  if self.bagItemSelected then
    -- -- self:dispatchEvent(Event.new("onStrengthenMax",self.bagItemSelected:getUserItemID(),self));
    -- local data = self.bagItemSelected:getItemData();
  end
end

function SrengthenUI:refresh(bagItem)
  if bagItem then
    self.contentLayer:setVisible(true);
  else
    self.contentLayer:setVisible(false);
    return;
  end
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",1+bagItem:getItemData().StrengthenLevel) then
    self.contentLayer:setVisible(true);
    self.descb:setVisible(false);
  else
    self.contentLayer:setVisible(false);
    self.descb:setVisible(true);
    return;
  end
  if self.bagItemSelected then
    self.contentLayer:removeChild(self.bagItemSelected);
    self.bagItemSelected = nil;
  end
  local data = copyTable(bagItem:getItemData());
  self.bagItemSelected = BagItem.new();
  self.bagItemSelected:initialize(data);
  self.bagItemSelected:setFrameVisible(false);
  self.bagItemSelected:setPositionXY(799,395);
  self.bagItemSelected.touchEnabled = true;
  self.bagItemSelected.touchChildren = true;
  self.bagItemSelected:addEventListener(DisplayEvents.kTouchTap,self.context.popEquipDetail,self.context,self.bagItemSelected);
  self.contentLayer:addChild(self.bagItemSelected);
  self.name_bg:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemSelected:getItemID(),"name"));

  self.level_descb:setString("强化等级 : " .. data.StrengthenLevel);
  self.level_s_descb:setString((1+data.StrengthenLevel) .. " (+1)");

  local prop_name=analysis("Zhuangbei_Zhuangbeipeizhibiao",data.ItemId,"attribute");
  local prop_table = StringUtils:lua_string_split(prop_name,",");
  prop_name=analysis("Shuxing_Shuju",tonumber(prop_table[1]),"name");
  self.prop_name_cache = prop_name;
  self.prop_value_cache = self:getPropDescb(data.ItemId,data.StrengthenLevel);
  
  self.prop_descb:setString(self.prop_name_cache .. " : " .. self.prop_value_cache);
  local added = self:getPropAddedNextLevel(data.ItemId,data.StrengthenLevel);
  self.prop_s_descb:setString((self.prop_value_cache+added) .. " (+" .. added .. ")");
  local silver = self:getSilverDescb(1+data.StrengthenLevel);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver() >= silver;
  self.silver_descb:setString("消耗         : " .. silver);
end

function SrengthenUI:getPropDescb(itemID, level)
  local table_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID);
  local prop = table_data.attribute;
  prop = StringUtils:lua_string_split(prop,",");
  local prop_value = tonumber(prop[2]);

  local _count = 0;
  local _prop_value_new = prop_value;
  -- while level > _count do
  --   _count = 1 + _count;
  --   _prop_value_new = analysis("Zhuangbei_Zhuangbeiqianghua",_count,"qiangN") + ( analysis("Zhuangbei_Zhuangbeiqianghua",_count,"qiangPer") / 100000 ) * prop_value + _prop_value_new;
  -- end
  local tb_data;
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",level) then
    tb_data = analysis("Zhuangbei_Zhuangbeiqianghua",level);
    _prop_value_new = tb_data.qiangN + ( tb_data.qiangPer / 100000 ) * prop_value + _prop_value_new;
  end

  return math.ceil(_prop_value_new);
end

function SrengthenUI:getPropAddedNextLevel(itemID, level)
  -- local table_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID);
  -- local prop = table_data.attribute;
  -- local prop_value = table_data.amount;
  -- local prop_name = analysis("Shuxing_Shuju",prop,"name");

  -- return math.ceil(analysis("Zhuangbei_Zhuangbeiqianghua",1+level,"qiangN") + (analysis("Zhuangbei_Zhuangbeiqianghua",1+level,"qiangPer") / 100000 ) * prop_value);
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",1 + level) then
    return self:getPropDescb(itemID, 1 + level) - self:getPropDescb(itemID, level);
  end
  return 0;
end

function SrengthenUI:getSilverDescb(nextLevel)
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",nextLevel) then
    -- return math.floor(analysis("Zhuangbei_Zhuangbeiqianghua",nextLevel,"cost")*analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemSelected:getItemID(),"level")/40);
    return analysis("Zhuangbei_Zhuangbeiqianghua",nextLevel,"cost");
  end
  return 0;
end