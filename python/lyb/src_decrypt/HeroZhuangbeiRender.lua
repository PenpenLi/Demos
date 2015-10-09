HeroZhuangbeiRender=class(TouchLayer);

function HeroZhuangbeiRender:ctor()
  self.class=HeroZhuangbeiRender;
end

function HeroZhuangbeiRender:dispose()
  self.armature:dispose();
	HeroZhuangbeiRender.superclass.dispose(self);
end

function HeroZhuangbeiRender:initialize(context)
  self.context = context;
  self.skeleton = self.context.skeleton;
  self.items = {};
  self.place_config = {1,4,3,5};
  self.reddots = {};

  self:initLayer();
  --骨骼
  local armature=self.skeleton:buildArmature("zhuangbei_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  for i=1,4 do
    self.armature.display:getChildByName("silver_descb" .. i):setScale(0.7);
    local item_bg = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_item_bg_2");
    item_bg:setScaleX(432/443);
    item_bg:setScaleY(125/167);
    item_bg:setPosition(self.armature.display:getChildByName("background_" .. i):getPosition());
    item_bg:setPositionY(-127+item_bg:getPositionY());
    self.armature.display:removeChild(self.armature.display:getChildByName("background_" .. i));
    self.armature.display:addChildAt(item_bg,2);

    table.insert(self.reddots,self.armature.display:getChildByName("effect_" .. i));
  end
  self.armature.display:getChildByName("strength_all_descb"):setScale(0.7);
  self.armature.display:getChildByName("strength_all_descb"):setVisible(false);

  local text="";
  for i=1,4 do
    self["name_descb" .. i]=createTextFieldWithTextData(armature:getBone("name_descb" .. i).textData,text);
    self.armature.display:addChild(self["name_descb" .. i]);
    self["prop_descb" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb" .. i]);
    self["silver_descb" .. i]=createTextFieldWithTextData(armature:getBone("silver_descb" .. i).textData,text);
    self.armature.display:addChild(self["silver_descb" .. i]);

    local button=self.armature.display:getChildByName("btn_" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature.display:removeChild(button);

    local layer = Layer.new();
    layer:initLayer();
    button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON,nil,503);
    button:initializeText(self.armature:findChildArmature("btn_" .. i):getBone("common_small_blue_button").textData,"强化");
    -- button:initializeBMText("进阶","anniutuzi");
    -- button:setPosition(button_pos);
    layer:setScale(0.8);
    layer:setPosition(button_pos);
    layer:addChild(button);
    button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,{num = i, isStrengthen = 1});
    self.armature.display:addChild(layer);
    self["blue_btn" .. i] = button;

    local layer = Layer.new();
    layer:initLayer();
    button=CommonButton.new();
    button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON,nil,10);
    button:initializeText(self.armature:findChildArmature("btn_" .. i):getBone("common_small_blue_button").textData,"进阶");
    -- button:initializeBMText("进阶","anniutuzi");
    -- button:setScale(0.9);
    -- button:setPosition(button_pos);
    layer:setScale(0.8);
    layer:setPosition(button_pos);
    layer:addChild(button);
    button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,{num = i, isStrengthen = 0});
    self.armature.display:addChild(layer);
    self["red_btn" .. i] = button;
  end
  self["strength_all_descb"]=createTextFieldWithTextData(armature:getBone("strength_all_descb").textData,"",true);--VIP2开启全身强化功能
  self.armature.display:addChild(self["strength_all_descb"]);
  self["strength_all_descb"]:setVisible(false);

  local button=self.armature.display:getChildByName("strength_all");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("strength_all"):getBone("common_small_blue_button").textData,"全部强化");
  -- button:initializeBMText("进阶","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonAllTap,self);
  self.armature.display:addChild(button);
  self.strength_all_btn = button;

  self.strength_level_tb = {};
end

function HeroZhuangbeiRender:refreshData(generalId)
  self.data = self.context.heroHouseProxy:getGeneralData(generalId);
  local equipArr = self.context.equipmentInfoProxy:getEquipsByHeroID(generalId);
  for i=1,4 do
    -- self.armature.display:getChildByName("wenzi_" .. i):setVisible(false);
    local pos = convertBone2LB(self.armature.display:getChildByName("grid_" .. i));
    self.armature.display:removeChild(self.items[i]);
    self.items[i] = nil;
    self.items[i] = BagItem.new();
    self.items[i]:initialize(equipArr[self.place_config[i]]);
    self.items[i].touchEnabled = true;
    self.items[i].touchChildren = true;
    self.items[i]:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X+pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+pos.y);
    -- self.items[i]:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,self.items[i]);
    self.armature.display:addChild(self.items[i]);
  end

  local silver_all = 0;
  for i=1,4 do
    local equipData = equipArr[self.place_config[i]];
    print("",i,self.place_config[i]);
    for k,v in pairs(equipData) do
      print(k,v);
    end
    self["name_descb" .. i]:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",equipData.ItemId,"name") .. " Lv." .. equipData.StrengthenLevel);
    self.strength_level_tb[i] = equipData.StrengthenLevel;
    local prop_name=analysis("Zhuangbei_Zhuangbeipeizhibiao",equipData.ItemId,"attribute");
    local prop_table = StringUtils:lua_string_split(prop_name,",");
    prop_name=analysis("Shuxing_Shuju",tonumber(prop_table[1]),"name");
    local prop_value_cache = self:getPropDescb(equipData.ItemId,equipData.StrengthenLevel);
    local added = self:getPropAddedNextLevel(equipData.ItemId,equipData.StrengthenLevel);
    self["prop_descb" .. i]:setString(prop_name .. "" .. prop_value_cache);-- .. " (+" .. added .. ")"

    local silver = self:getSilverDescb(1+equipData.StrengthenLevel);
    self["silver_descb" .. i]:setString(silver);

    local job = analysis("Kapai_Kapaiku",self.context.heroHouseProxy:getGeneralData(equipData.GeneralId).ConfigId,"job");
    local jinjieData = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",equipData.ItemId);
    
    if jinjieData and 0 ~= jinjieData.target then
      if equipData.StrengthenLevel < jinjieData.levelLimit then
        if not analysisHas("Zhuangbei_Zhuangbeiqianghua",1+equipData.StrengthenLevel) then
          self["blue_btn" .. i]:setVisible(false);
          self["red_btn" .. i]:setVisible(false);
          self.armature.display:getChildByName("silver_descb" .. i):setVisible(false);
          self["silver_descb" .. i]:setVisible(false);
        else
          self["blue_btn" .. i]:setVisible(true);
          self["red_btn" .. i]:setVisible(false);
          self.armature.display:getChildByName("silver_descb" .. i):setVisible(true);
          self["silver_descb" .. i]:setVisible(true);

          silver_all = silver_all + silver;
        end
      else
        self["blue_btn" .. i]:setVisible(false);
        self["red_btn" .. i]:setVisible(true);
        self.armature.display:getChildByName("silver_descb" .. i):setVisible(false);
        self["silver_descb" .. i]:setVisible(false);
      end
    else
      if not analysisHas("Zhuangbei_Zhuangbeiqianghua",1+equipData.StrengthenLevel) then
        self["blue_btn" .. i]:setVisible(false);
        self["red_btn" .. i]:setVisible(false);
        self.armature.display:getChildByName("silver_descb" .. i):setVisible(false);
        self["silver_descb" .. i]:setVisible(false);
      else
        self["blue_btn" .. i]:setVisible(true);
        self["red_btn" .. i]:setVisible(false);
        self.armature.display:getChildByName("silver_descb" .. i):setVisible(true);
        self["silver_descb" .. i]:setVisible(true);

        silver_all = silver_all + silver;
      end
    end
  end
  -- self["strength_all_descb"]:setString(silver_all);
  if 0 == silver_all then
    -- self.armature.display:getChildByName("strength_all_descb"):setVisible(false);
    self["strength_all_descb"]:setVisible(false);
    self.strength_all_btn:setVisible(false);
  else
    -- self.armature.display:getChildByName("strength_all_descb"):setVisible(true);
    self["strength_all_descb"]:setVisible(true);
    self.strength_all_btn:setVisible(true);
  end

  self:refreshRedDot();
  if self.heroZhuangbeiJinjieRender then
    self.heroZhuangbeiJinjieRender:refreshData(generalId);
  end
end

function HeroZhuangbeiRender:refreshBySilver()
  if self.heroZhuangbeiJinjieRender then
    self.heroZhuangbeiJinjieRender:refreshBySilver();
  end
end

function HeroZhuangbeiRender:refreshStrengthenAll()
  local equipArr = self.context.equipmentInfoProxy:getEquipsByHeroID(self.data.GeneralId);
  for i=1,4 do
    local equipData = equipArr[self.place_config[i]];
    if self.strength_level_tb[i] and self.strength_level_tb[i] < equipData.StrengthenLevel then
      self:refreshStrengthen(equipData.ItemId);
    end
  end
end

function HeroZhuangbeiRender:refreshStrengthen(itemId)
  for k,v in pairs(self.items) do
    if itemId == v.userItem.ItemId then
      local effect;
      local function onCall()
        if effect.parent then
          effect.parent:removeChild(effect);
        end
      end
      effect = cartoonPlayer(1693,45+self.items[k]:getPositionX(), 50+self.items[k]:getPositionY(), 1, onCall);
      self:addChild(effect);
      break;
    end
  end
end

function HeroZhuangbeiRender:onBagItemTap(event, bagItem)
  -- local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  local num = analysis("Zhuangbei_Zhuangbeipeizhibiao",bagItem:getItemData().ItemId,"place");
  -- data.Sign_BetterEquip[num] = 1;
  -- self.armature.display:getChildByName("effect" .. num):setVisible(false);

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
  -- local size=self.parent:getContentSize();
  -- local popupSize=layer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
  -- layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  layer:setPositionXY(270,20);
  self.parent.parent:addChild(layer);

  self.context.pageView:setMoveEnabled(false);
end

function HeroZhuangbeiRender:getPropDescb(itemID, level)
  local tb_data = analysisWithCache("Zhuangbei_Zhuangbeipeizhibiao",itemID,"attribute");
  local propID = 0;
  if "" ~= tb_data then
    tb_data = StringUtils:lua_string_split(tb_data,",");
    propID = tonumber(tb_data[1]);
  else
    local data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndItemID(self.data.GeneralId, itemID);
    for k,v in pairs(data.PropertyArray) do
      if 0 ~= v.Type then
        propID = v.Type;
        break;
      end
    end
  end
  return math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(self.data.GeneralId, itemID, propID, level));
end

function HeroZhuangbeiRender:getPropAddedNextLevel(itemID, level)
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

function HeroZhuangbeiRender:getSilverDescb(nextLevel)
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",nextLevel) then
    -- return math.floor(analysis("Zhuangbei_Zhuangbeiqianghua",nextLevel,"cost")*analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemSelected:getItemID(),"level")/40);
    return analysis("Zhuangbei_Zhuangbeiqianghua",nextLevel,"cost");
  end
  return 0;
end

function HeroZhuangbeiRender:refreshRedDot()
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  for k,v in pairs(self.reddots) do
    print(".......refreshRedDot.........",k,self.place_config[k],data.BetterJinjieEquip and data.BetterJinjieEquip[self.place_config[k]],data.BetterEquip and data.BetterEquip[self.place_config[k]]);
    v:setVisible((data.BetterJinjieEquip and 1 == data.BetterJinjieEquip[self.place_config[k]]) or (data.BetterEquip and 1 == data.BetterEquip[self.place_config[k]]));
  end
end

-- function HeroZhuangbeiRender:onBagItemTap(event, bagItem)
--   local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
--   local num = analysis("Zhuangbei_Zhuangbeipeizhibiao",bagItem:getItemData().ItemId,"place");
--   -- data.Sign_BetterEquip[num] = 1;
--   -- self.armature.display:getChildByName("effect" .. num):setVisible(false);

--   local tipBg=LayerColorBackGround:getOpacityBackGround();
--   local layer=EquipDetailLayer.new();
--   local function closeTip(event)
--     tipBg.parent:removeChild(tipBg);
--     layer.parent:removeChild(layer);

--     self.context.pageView:setMoveEnabled(true);
--   end
--   tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
--   tipBg:addEventListener(DisplayEvents.kTouchBegin,closeTip);
--   self.parent.parent:addChild(tipBg);
--   layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,nil,BagItemType.OnHeroPro,closeTip);
--   local size=self.parent:getContentSize();
--   local popupSize=layer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
--   layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
--   self.parent.parent:addChild(layer);

--   self.context.pageView:setMoveEnabled(false);
--   layer:setPositionX(-200+layer:getPositionX());
-- end

function HeroZhuangbeiRender:onButtonTap(event, data)
  if not getGongnengkaiqiWithTishi(FunctionConfig.FUNCTION_ID_14) then
    return;
  end
  if 0 == data.isStrengthen then
    self.heroZhuangbeiJinjieRender = HeroZhuangbeiJinjieRender.new();
    self.heroZhuangbeiJinjieRender:initialize(self.context,self,self.place_config[data.num]);
    self.context:addChild(self.heroZhuangbeiJinjieRender);
    self.heroZhuangbeiJinjieRender:refreshData(self.data.GeneralId);
    return;
  end
  if self.context.strengthenProxy.Qianghua_Bool then
    return;
  end
  -- if GameVar.tutorStage == TutorConfig.STAGE_1009 then--and not self.tutor1006 
  --   sendServerTutorMsg({BooleanValue = 0})
  --   openTutorUI({x=978, y=26, width = 130, height = 46, alpha = 125, twinkle = true, fullScreenTouchable = true});

  --   self.tutorLayer = Layer.new();
  --   self.tutorLayer:initLayer();
  --   self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
  --   self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
  --   self.context:addChild(self.tutorLayer)

  -- end
  local equipData = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.place_config[data.num]);
  local data_general = self.context.heroHouseProxy:getGeneralData(equipData.GeneralId);
  if equipData.StrengthenLevel >= data_general.Level then
    sharedTextAnimateReward():animateStartByString("强化等级不能超过英雄等级哦 ~");
    return;
  end
  if self:getSilverDescb(1+equipData.StrengthenLevel) > self.context.userCurrencyProxy:getSilver() then
    sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  sendMessage(10,2,{GeneralId=self.data.GeneralId,ItemId=equipData.ItemId,BooleanValue=0});
  self.context.strengthenProxy.Qianghua_Bool = true;

end

function HeroZhuangbeiRender:onButtonAllTap(event)
  if not getGongnengkaiqiWithTishi(FunctionConfig.FUNCTION_ID_14) then
    return;
  end

  -- if GameVar.tutorStage == TutorConfig.STAGE_1009 then--and not self.tutor1006 
  --   openTutorUI({x=1106, y=620, width = 78, height = 75, alpha = 125});
  -- end
  if self.context.strengthenProxy.Qianghua_Bool then
    return;
  end
  local vipLevel = self.context.userProxy:getVipLevel();
  local vip_need = 0;
  local vip_data = analysis("Huiyuan_Huiyuantequan",2);
  for i = 0, 15 do
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
  local places = {1,4,3,5};
  for k,v in pairs(places) do
    local data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,v);
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

    local level_enough = data.StrengthenLevel < general_data.Level;

    if not silver_is_enough then
      sign_1 = true;
    end
    if not level_enough then
      sign_2 = true;
    end

    if level_enough and silver_is_enough and self["blue_btn" .. k]:isVisible() then
      -- initializeSmallLoading();
      sendMessage(10,2,{GeneralId=data.GeneralId,ItemId=data.ItemId,BooleanValue=1});
      self.context.strengthenProxy.Qianghua_ALL_Bool = true;
      return;
    end
  end
  if sign_1 then
    sharedTextAnimateReward():animateStartByString("银两不足了哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  elseif sign_2 then
    sharedTextAnimateReward():animateStartByString("强化等级不能超过英雄等级哦 ~");
    return;
  end
  sharedTextAnimateReward():animateStartByString("没有可以强化的装备哦 ~");
  if self.bagItemSelected then
    -- -- self:dispatchEvent(Event.new("onStrengthenMax",self.bagItemSelected:getUserItemID(),self));
    -- local data = self.bagItemSelected:getItemData();
  end

end

function HeroZhuangbeiRender:refreshJinjie()
  local place = self.context.strengthenProxy.Equip_Dazao_ItemID_Cache;
  if place then
    place = math.floor(place/1000000);
    for k,v in pairs(self.items) do
      if place == math.floor(v.userItem.ItemId/1000000) then
        local effect;
        local function onCall()
          if effect.parent then
            effect.parent:removeChild(effect);
          end
        end
        effect = cartoonPlayer(24,45+self.items[k]:getPositionX(), 50+self.items[k]:getPositionY(), 1, onCall);
        self:addChild(effect);
        break;
      end
    end
  end
end


HeroZhuangbeiJinjieRender=class(TouchLayer);

function HeroZhuangbeiJinjieRender:ctor()
  self.class=HeroZhuangbeiJinjieRender;
end

function HeroZhuangbeiJinjieRender:dispose()
  self.armature:dispose();
  HeroZhuangbeiJinjieRender.superclass.dispose(self);
  if self.context.parent then
    self.context.pageView:setMoveEnabled(true);
  end
end

function HeroZhuangbeiJinjieRender:initialize(context, container, num)
  self.context = context;
  self.container = container;
  self.num = num;
  self.skeleton = self.context.skeleton;
  self:initLayer();

  self.bg = LayerColorBackGround:getTransBackGround();
  self.bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
  self.context:addChild(self.bg);

  --骨骼
  local armature=self.skeleton:buildArmature("zhuangbei_jinjie_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:setPositionXY(370,50);
  self:addChild(self.armature.display);

  local text="";
  self.grid_1=createTextFieldWithTextData(armature:getBone("grid_1").textData,text,true);
  self.armature.display:addChild(self.grid_1);

  self.grid_2=createTextFieldWithTextData(armature:getBone("grid_2").textData,text,true);
  self.armature.display:addChild(self.grid_2);

  self.zhuangbei_cailiao_title_bg=createTextFieldWithTextData(armature:getBone("zhuangbei_cailiao_title_bg").textData,"消耗材料:");
  self.armature.display:addChild(self.zhuangbei_cailiao_title_bg);

  self.huafei=createTextFieldWithTextData(armature:getBone("huafei").textData,"花费银两:");
  self.armature.display:addChild(self.huafei);

  self.huafei_descb=createTextFieldWithTextData(armature:getBone("huafei_descb").textData,text);
  self.armature.display:addChild(self.huafei_descb);

  self.tail_descb=createTextFieldWithTextData(armature:getBone("tail_descb").textData,"");--进阶后,当前等级清零,但是会保留强化属性");
  self.armature.display:addChild(self.tail_descb);

  --查找家族
  local button=self.armature.display:getChildByName("btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- button:initializeText(self.armature:findChildArmature("btn"):getBone("common_blue_button").textData,"进阶");
  button:initializeBMText("进阶","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onJinjieButtonTap,self);
  self.armature.display:addChildAt(button,1);

  self.armature.display:getChildByName("huafei_descb"):setScale(0.8);
  self.titleTF = BitmapTextField.new("装备进阶","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(185,545);
  self.armature.display:addChild(self.titleTF);

  self.context.pageView:setMoveEnabled(false);
end

function HeroZhuangbeiJinjieRender:onClose(event)
  if self.bg.parent then
    self.bg.parent:removeChild(self.bg);
  end
  self.parent:removeChild(self);
  self.container.heroZhuangbeiJinjieRender = nil;
end

function HeroZhuangbeiJinjieRender:onJinjieButtonTap(event)
  if self.context.strengthenProxy.Dazao_Bool then
    return;
  end
  if not self.silver_is_enough then
    sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  if not self.stuff_is_enough then
    sharedTextAnimateReward():animateStartByString("材料不足哦 ~");
    return;
  end

  -- initializeSmallLoading();
  local equip_data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.num);
  sendMessage(10,3,{GeneralId = equip_data.GeneralId, ItemId = equip_data.ItemId});
  self.context.strengthenProxy.Dazao_Bool = true;
  self.context.strengthenProxy.Equip_Dazao_ItemID_Cache = equip_data.ItemId;

  self.context.equipmentInfoProxy.jinjie_general_id_cache = self.data_1.GeneralId;
  self.context.equipmentInfoProxy.jinjie_item_id_cache = self.data_1.ItemId;
  self.context.equipmentInfoProxy.jinjie_target_item_id_cache = self.data_2.ItemId;
  
  self:onClose();
end

function HeroZhuangbeiJinjieRender:refreshData(generalId)
  self.data = self.context.heroHouseProxy:getGeneralData(generalId);
  local data_1 = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.num);
  local data_2 = copyTable(data_1);
  local job = analysis("Kapai_Kapaiku",self.data.ConfigId,"job");
  local jijie_data = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",data_1.ItemId);
  if not jijie_data or 0 == jijie_data.target then
    self:onClose();
    return;
  end
  data_2.ItemId = analysis("Zhuangbei_Zhuangbeijinjiebiao",jijie_data.target,"equipmentId");
  self.data_1 = data_1;
  self.data_2 = data_2;

  if self.left_bagItem then
    self.armature.display:removeChild(self.left_bagItem);
    self.left_bagItem = nil;
  end
  if self.right_bagItem then
    self.armature.display:removeChild(self.right_bagItem);
    self.right_bagItem = nil;
  end
  if self.bagItemsLayer then
    self.armature.display:removeChild(self.bagItemsLayer);
    self.bagItemsLayer = nil;
  end

  self.left_bagItem = BagItem.new();
  self.left_bagItem:initialize(data_1);
  -- self.left_bagItem:setBackgroundVisible(true);
  self.left_bagItem:setPositionXY(101,411);
  self.armature.display:addChild(self.left_bagItem);

  self.right_bagItem = BagItem.new();
  self.right_bagItem:initialize(data_2);
  -- self.right_bagItem:setBackgroundVisible(true);
  self.right_bagItem:setPositionXY(331,411);
  self.armature.display:addChild(self.right_bagItem);

  self.grid_1:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",data_1.ItemId,"name") .. "\n强化等级上限:" .. jijie_data.levelLimit);
  local jijie_data_2 = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","wuxing",wuxing,"equipmentId",data_2.ItemId);
  self.grid_2:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",data_2.ItemId,"name") .. "\n强化等级上限:" .. jijie_data_2.levelLimit);

  local silver_need = tonumber(StringUtils:lua_string_split(jijie_data.money,",")[2]);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=silver_need;
  self.huafei_descb:setString(silver_need);

  self.bagItemsLayer = Layer.new();
  self.bagItemsLayer:initLayer();
  self.bagItemsLayer:setPositionXY(0,180);
  self.armature.display:addChild(self.bagItemsLayer);
  self.stuff_is_enough = true;
  local costs = jijie_data.cost;
  if costs and "" ~= costs then
    costs = StringUtils:stuff_string_split(costs);
    local costs_tmp = {};
    for k,v in pairs(costs) do
      if 0 ~= tonumber(v[2]) then
        table.insert(costs_tmp,v);
      end
    end
    costs = costs_tmp;
    for k,v in pairs(costs) do
      local bagCount = self.context.bagProxy:getItemNum(tonumber(v[1]));

      local bagItem = BagItem.new();
      bagItem:initialize({ItemId = tonumber(v[1]),Count = 1});
      bagItem:setBackgroundVisible(true);
      bagItem.touchEnable = true;
      bagItem.touchChildren = true;
      bagItem:setPositionX((-1+k)*(3 < table.getn(costs) and 118 or 125));
      bagItem.bagHasCount = bagCount;
      bagItem.totalNeedCount = tonumber(v[2]);
      bagItem:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,bagItem);

      self.bagItemsLayer:addChild(bagItem);

      local bagItemSize = bagItem:getGroupBounds().size;

      self.stuff_is_enough = self.stuff_is_enough and bagCount >= tonumber(v[2]);
      bagItem:setTextString(bagCount .. "/" .. v[2],CommonUtils:ccc3FromUInt(bagCount >= tonumber(v[2]) and 16710121 or 16711680));
    end
  else
    self.stuff_is_enough = false;
  end
  self.bagItemsLayer:setPositionX(-self.bagItemsLayer:getGroupBounds().size.width/2+250);
end

function HeroZhuangbeiJinjieRender:onBagItemTap(event, bagItem)
  popItemDetailLayer(bagItem,self.context.parent);
  -- local tipBg=LayerColorBackGround:getOpacityBackGround();
  -- local layer=DetailLayer.new();
  -- local function closeTip(event)
  --   if tipBg.parent then
  --     tipBg.parent:removeChild(tipBg);
  --   end
  --   if layer.parent then
  --     layer.parent:removeChild(layer);
  --   end
  -- end
  -- tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  -- tipBg:addEventListener(DisplayEvents.kTouchTap,closeTip);
  -- self.context.parent:addChild(tipBg);
  -- layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  -- local size=self.context:getContentSize();
  -- local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  -- layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  -- self.context.parent:addChild(layer);
end

function HeroZhuangbeiJinjieRender:refreshBySilver()
  local data_1 = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.num);
  local data_2 = copyTable(data_1);
  local job = analysis("Kapai_Kapaiku",self.data.ConfigId,"job");
  local jijie_data = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",data_1.ItemId);

  local silver_need = tonumber(StringUtils:lua_string_split(jijie_data.money,",")[2]);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=silver_need;
end


























function HeroZhuangbeiRender:refreshExp(exp, total)
  self.exp_descb:setString("经验: " .. exp .. " / " .. total);
  self.progressBar_shengji:setProgress(exp/total);
end

function HeroZhuangbeiRender:refreshHunli(exp, total)
  self.hunliExp = exp
  self.totalHunliExp = total
  self.hunli_descb:setString("魂石: " .. exp .. " / " .. total);
  self.progressBar_jinjie:setProgress(exp/total);
end

function HeroZhuangbeiRender:onShengjiBTN(event)
  if not self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_16) then
    sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    return;
  end
  -- local data4Shengji = self.context.heroHouseProxy:getDatas4Shengji(self.data.GeneralId);
  -- local num = 0;
  -- for k,v in pairs(data4Shengji) do
  --   if not v.Holder then
  --     num = 1 + num;
  --   end
  -- end
  -- if 0 == num then
  --   sharedTextAnimateReward():animateStartByString("没有可用于升级的卡牌哦~");
  --   return;
  -- end
  -- local heroChooseLayer = HeroChooseLayer.new();
  -- heroChooseLayer:initialize(self.context, self.data.GeneralId, HeroChooseLayerType.SHENGJI);
  -- heroChooseLayer:refreshPageViewData(data4Shengji);
  -- self.parent:addChild(heroChooseLayer);
  -- if 1 == self.data.IsMainGeneral then
  --   sharedTextAnimateReward():animateStartByString("功能未开启~");
  --   return;
  -- end
  if not analysisHas(self.context:getExcelName(self.data.GeneralId), 1 + self.data.Level) then
    sharedTextAnimateReward():animateStartByString("已经满级了哦~");
    return;
  end

  local bagDatas = self.context.bagProxy:getData();
  local datas;
  if 1==self.data.IsMainGeneral then
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
-- datas = {{ItemId = 1012001,Count = 10},{ItemId = 1012002,Count = 10},{ItemId = 1012003,Count = 10},{ItemId = 1012004,Count = 10},};
  if 0 == table.getn(datas) then
    sharedTextAnimateReward():animateStartByString("没有可用于升级的道具哦~");
    return;
  end

  if GameData.isMusicOn then
    MusicUtils:playEffect(10,false)
  end

  local bag = HeroShengjiBag.new();
  bag:initialize(self.context,self.data.GeneralId,datas);
  self.context:addChild(bag);

  self.context.heroHouseProxy.shengjiGeneralIDCache = self.data.GeneralId;
end

function HeroZhuangbeiRender:onJinjieBTN(event)
  if not self.context.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_15) then
    sharedTextAnimateReward():animateStartByString("功能尚未开启哦 ~");
    return;
  end
  -- local data4Jinjie = self.context.heroHouseProxy:getDatas4Jinjie(self.data.GeneralId);
  -- local num = 0;
  -- for k,v in pairs(data4Jinjie) do
  --   if not v.Holder then
  --     num = 1 + num;
  --   end
  -- end
  -- if 0 == num then
  --   sharedTextAnimateReward():animateStartByString("没有可用于进阶的卡牌哦~");
  --   return;
  -- end
  -- local heroChooseLayer = HeroChooseLayer.new();
  -- heroChooseLayer:initialize(self.context, self.data.GeneralId, HeroChooseLayerType.JINJIE);
  -- heroChooseLayer:refreshPageViewData(data4Jinjie);
  -- self.parent:addChild(heroChooseLayer);
  -- local bag = HeroShengjiBag.new();
  -- bag:initialize(self.context,self.data.GeneralId,{});
  -- self.context:addChild(bag);
  -- if 1 == self.data.IsMainGeneral then
  --   sharedTextAnimateReward():animateStartByString("功能未开启~");
  --   return;
  -- end
  if not analysisHas("Kapai_KapaiyanseduiyingID",1 + self.data.Grade) then
    sharedTextAnimateReward():animateStartByString("已经满阶了哦~");
    return;
  end
  local _grade_level = self.data.Grade;
  local _grade_exp = self.context.heroHouseProxy:getHunliByGeneralID(self.data.GeneralId);
  local _star_level = analysis("Kapai_Kapaiku",self.data.ConfigId,"star");
  local xuQiu;
  if 1 == _star_level then
    xuQiu = "xuQiu";
  else
    xuQiu = "xuQiu" .. _star_level;
  end
  local _exp_need = analysis("Kapai_KapaiyanseduiyingID",1 + self.data.Grade,xuQiu);
  print("--->>>",_grade_exp,_exp_need,self.data.Grade,_star_level);

  local function onTrack()
    local linghunshi = StringUtils:lua_string_split(analysis("Kapai_Kapaiku",self.data.ConfigId,"soul"),",");

    print("self.hunliExp, self.totalHunliExp", self.hunliExp, self.totalHunliExp)

    self.context:dispatchEvent(Event.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,{itemId=tonumber(linghunshi[1]), count = self.hunliExp, totalCount = self.totalHunliExp},self));
  end

  local function onCancle()
    self.context.pageView:setMoveEnabled(true);
  end

  if _grade_exp < _exp_need then
    --sharedTextAnimateReward():animateStartByString("魂力不足哦~");
    -- local popup = CommonPopup.new();
    -- popup:initialize("魂石不足呢,要去获取吗?",nil,onTrack,nil,onCancle,nil,nil,nil,nil,nil,CommonPopupCloseButtonPram.CANCLE);
    -- self.context.parent:addChild(popup);
    -- self.context.pageView:setMoveEnabled(false);

    onTrack();
    return;
  end

  local silver_need = analysis("Kapai_KapaiyanseduiyingID",1 + self.data.Grade,"money");
  local function onConfirm()
    self.context.pageView:setMoveEnabled(true);
    if self.context.userCurrencyProxy:getSilver() < silver_need then
      sharedTextAnimateReward():animateStartByString("银两不足哦~");
      -- self.context:dispatchEvent(Event.new("tutorToSilver",nil,self));
      return;
    end
    initializeSmallLoading();
    self.context.heroHouseProxy.jinjieGeneralIDCache = self.data.GeneralId;
    sendMessage(6,10,{GeneralId=self.data.GeneralId});
    if GameVar.tutorStage == TutorConfig.STAGE_1004 then
      openTutorUI({x=1109, y=619, width = 80, height = 80, alpha = 125});
    end
  end

  local function onCancel()
    self.context.pageView:setMoveEnabled(true);
  end

  local popup=CommonPopup.new();
  popup:initialize("确定花费" .. silver_need .. "银两进阶吗?",nil,onConfirm,nil,onCancel,nil,nil,nil,nil,nil,CommonPopupCloseButtonPram.CANCLE);
  self.context:addChild(popup);

  if GameVar.tutorStage == TutorConfig.STAGE_1004 then
      openTutorUI({x=667, y=212, width = 168, height = 63, alpha = 125});
  end
  if GameData.isMusicOn then
    MusicUtils:playEffect(10,false)
  end
  self.context.pageView:setMoveEnabled(false);
end

function HeroZhuangbeiRender:onShengxingBTN(event)
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

  if GameData.isMusicOn then
    MusicUtils:playEffect(10,false)
  end

  self.heroShengxingLayer = HeroShengxingLayer.new();
  self.heroShengxingLayer:initialize(self.context, self.data.GeneralId);
  self.parent:addChild(self.heroShengxingLayer);
end