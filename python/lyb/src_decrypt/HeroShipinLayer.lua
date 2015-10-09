HeroShipinLayer=class(TouchLayer);

function HeroShipinLayer:ctor()
  self.class=HeroShipinLayer;
end

function HeroShipinLayer:dispose()
  self.armature:dispose();
  HeroShipinLayer.superclass.dispose(self);
end

function HeroShipinLayer:initialize(context)
  self.context = context;
  self:initLayer();
  self.items = {};
  self.xianglian_kaiqi_level = analysis("Xishuhuizong_Xishubiao",1081,"constant");
  self.jiezhi_kaiqi_level = analysis("Xishuhuizong_Xishubiao",1082,"constant");
  self.reddots = {};
  --骨骼
  local armature=self.context.skeleton:buildArmature("shipin_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local bg = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_item_bg_2");
  bg:setScaleX(435/443);
  bg:setScaleY(270/167);
  bg:setPositionXY(5,270);
  self.armature.display:addChildAt(bg,1);

  bg = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_item_bg_2");
  bg:setScaleX(435/443);
  bg:setScaleY(270/167);
  bg:setPositionXY(5,2);
  self.armature.display:addChildAt(bg,1);

  local text="";
  self.name1=createTextFieldWithTextData(armature:getBone("name1").textData,text);
  self.armature.display:addChild(self.name1);

  self.name2=createTextFieldWithTextData(armature:getBone("name2").textData,text);
  self.armature.display:addChild(self.name2);

  self.prop_descb_1=createTextFieldWithTextData(armature:getBone("prop_descb_1").textData,text);
  self.armature.display:addChild(self.prop_descb_1);

  self.prop_descb_2=createTextFieldWithTextData(armature:getBone("prop_descb_2").textData,text);
  self.armature.display:addChild(self.prop_descb_2);

  self.none_1_1=createTextFieldWithTextData(armature:getBone("none_1_1").textData,text);
  self.armature.display:addChild(self.none_1_1);

  self.none_1_2=createTextFieldWithTextData(armature:getBone("none_1_2").textData,text);
  self.armature.display:addChild(self.none_1_2);

  self.none_2_1=createTextFieldWithTextData(armature:getBone("none_2_1").textData,text);
  self.armature.display:addChild(self.none_2_1);

  self.none_2_2=createTextFieldWithTextData(armature:getBone("none_2_2").textData,text);
  self.armature.display:addChild(self.none_2_2);

  for i=1,2 do
    table.insert(self.reddots,self.armature.display:getChildByName("effect_" .. i));
  end

  for i=1,5 do
    self["prop_descb_1_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_1_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_1_" .. i]);

    self["prop_descb_2_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_2_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_2_" .. i]);
  end

  for i=1,2 do
    local button=self.armature.display:getChildByName("btn" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature.display:removeChild(button);

    button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    button:initializeText(self.armature:findChildArmature("btn" .. i):getBone("common_small_blue_button").textData,"进阶");
    --button:initializeBMText("进阶","anniutuzi");
    -- button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,self.onJinjieButtonTap,self,i);
    local layer = Layer.new();
    layer:initLayer();
    layer:setScale(0.8);
    layer:setPosition(button_pos);
    self.armature.display:addChild(layer);
    layer:addChild(button);
    self["button_" .. i .. "_1"] = button;

    local button=self.armature.display:getChildByName("red_btn_" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature.display:removeChild(button);

    button=CommonButton.new();
    button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON,nil,503);
    button:initializeText(self.armature:findChildArmature("red_btn_" .. i):getBone("common_small_red_button").textData,"洗练");
    --button:initializeBMText("升星","anniutuzi");
    -- button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,self.onXilianButtonTap,self,i);
    -- self.armature.display:addChild(button);
    layer = Layer.new();
    layer:initLayer();
    layer:setScale(0.8);
    layer:setPosition(button_pos);
    self.armature.display:addChild(layer);
    layer:addChild(button);
    self["button_" .. i .. "_2"] = button;
  end

  self.children_1 = {self.armature.display:getChildByName("common_copy_grid1"),
     self.armature.display:getChildByName("bg1"),
     self.armature.display:getChildByName("bg2"),
     self["button_1_1"],
     self["button_1_2"]};

  self.children_2 = {self.armature.display:getChildByName("common_copy_grid2"),
   self.armature.display:getChildByName("bg3"),
   self.armature.display:getChildByName("bg4"),
   self["button_2_1"],
   self["button_2_2"]};
end

function HeroShipinLayer:onXilianButtonTap(event, num)
  self.heroShipinXilianLayer = HeroShipinXilianLayer.new();
  self.heroShipinXilianLayer:initialize(self.context,self,1==num and 2 or 6);
  self.context:addChild(self.heroShipinXilianLayer);
  self.heroShipinXilianLayer:refreshData(self.data.GeneralId);
  if GameVar.tutorStage == TutorConfig.STAGE_1017 then--and not self.tutor1006 
    openTutorUI({x=894, y=170, width = 106, height = 50, alpha = 125, fullScreenTouchable = true, twinkle = true});
    self.tutorLayer = Layer.new();
    self.tutorLayer:initLayer();
    self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
    self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
    self.context.touchChildren = true;
    self.context:addChild(self.tutorLayer)

  end
end
function HeroShipinLayer:onTutorTap(event)
  print("function HeroShipinXilianLayer:onTutorTap(event)")
  if GameVar.tutorStage == TutorConfig.STAGE_1017 then--and not self.tutor1006 
     if not self.tempTutorStep then
      self.tempTutorStep = 1;
     end
     if self.tempTutorStep == 1 then
       openTutorUI({x=912, y=457, width = 106, height = 50, alpha = 125, fullScreenTouchable = true, twinkle = true});
     elseif self.tempTutorStep == 2 then
       self.context:removeChild(self.tutorLayer)
       sendServerTutorMsg({})
       closeTutorUI();
     end
     self.tempTutorStep = self.tempTutorStep + 1;
  end
end
function HeroShipinLayer:onJinjieButtonTap(event, num)
  self.heroShipinJinjieLayer = HeroShipinJinjieLayer.new();
  self.heroShipinJinjieLayer:initialize(self.context,self,1==num and 2 or 6);
  self.context:addChild(self.heroShipinJinjieLayer);
  self.heroShipinJinjieLayer:refreshData(self.data.GeneralId);
end

function HeroShipinLayer:refreshData(generalId)
  local data_p = self.data;
  self.data = self.context.heroHouseProxy:getGeneralData(generalId);
  local equipArr = self.context.equipmentInfoProxy:getEquipsByHeroID(generalId);
  local job = analysis("Kapai_Kapaiku",self.data.ConfigId,"job");

  for k,v in pairs(self.items) do
    v.parent:removeChild(v);
  end
  self.items = {};

  self.prop_descb_1_1:setString("");
  self.prop_descb_1_2:setString("");
  self.prop_descb_1_3:setString("");
  self.prop_descb_1_4:setString("");
  self.prop_descb_1_5:setString("");

  if self.xianglian_kaiqi_level > self.data.Level then
    self.name1:setString("");
    self.prop_descb_1:setString("");

    self.none_1_1:setString("Lv." .. self.xianglian_kaiqi_level .. " 解锁");
    self.none_1_2:setString("解锁后为白色品质，拥有1条随机属性");

    for k,v in pairs(self.children_1) do
      v:setVisible(false);
    end
  else
    for k,v in pairs(self.children_1) do
      v:setVisible(true);
    end

    local pos = convertBone2LB(self.armature.display:getChildByName("common_copy_grid1"));
    self.armature.display:removeChild(self.items[1]);
    self.items[1] = nil;
    self.items[1] = BagItem.new();
    self.items[1]:initialize(equipArr[2]);
    self.items[1].touchEnabled = true;
    self.items[1].touchChildren = true;
    self.items[1]:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X+pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+pos.y);
    -- self.items[1]:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,self.items[1]);
    self.armature.display:addChild(self.items[1]);

    self.name1:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",equipArr[2].ItemId,"name"));

    local jinjieData = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",equipArr[2].ItemId);
    if jinjieData and 0 ~= jinjieData.target then
      self.prop_descb_1:setString("英雄达到" .. jinjieData.levelLimit .. "级");
      self["button_1_1"]:setVisible(self.data.Level >= jinjieData.levelLimit);
    else
      self.prop_descb_1:setString("进阶已满");
      self["button_1_1"]:setVisible(false);
    end

    local descbs = {{self["prop_descb_1_3"]},
                    {self["prop_descb_1_2"],self["prop_descb_1_4"]},
                    {self["prop_descb_1_2"],self["prop_descb_1_3"],self["prop_descb_1_4"]},
                    {self["prop_descb_1_1"],self["prop_descb_1_2"],self["prop_descb_1_3"],self["prop_descb_1_4"]},
                    {self["prop_descb_1_1"],self["prop_descb_1_2"],self["prop_descb_1_3"],self["prop_descb_1_4"],self["prop_descb_1_5"]}};
    local count = 0;
    for k,v in pairs(equipArr[2].PropertyArray) do
      if 0 == v.Type then
        break;
      end
      count = 1 + count;
    end
    descbs = descbs[count];
    for k,v in pairs(equipArr[2].PropertyArray) do
      if 0 == v.Type then
        break;
      end
      local value = math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(equipArr[2].GeneralId, equipArr[2].ItemId, v.Type));
      descbs[k]:setString(analysis("Shuxing_Shuju",v.Type,"name") .. " +" .. value);
    end

    self.none_1_1:setString("");
    self.none_1_2:setString("");
  end

  self.prop_descb_2_1:setString("");
  self.prop_descb_2_2:setString("");
  self.prop_descb_2_3:setString("");
  self.prop_descb_2_4:setString("");
  self.prop_descb_2_5:setString("");

  if self.jiezhi_kaiqi_level > self.data.Level then
    self.name2:setString("");
    self.prop_descb_2:setString("");

    self.none_2_1:setString("Lv." .. self.jiezhi_kaiqi_level .. " 解锁");
    self.none_2_2:setString("解锁后为白色品质，拥有1条随机属性");

    for k,v in pairs(self.children_2) do
      v:setVisible(false);
    end
  else
    for k,v in pairs(self.children_2) do
      v:setVisible(true);
    end

    local pos = convertBone2LB(self.armature.display:getChildByName("common_copy_grid2"));
    self.armature.display:removeChild(self.items[2]);
    self.items[2] = nil;
    self.items[2] = BagItem.new();
    self.items[2]:initialize(equipArr[6]);
    self.items[2].touchEnabled = true;
    self.items[2].touchChildren = true;
    self.items[2]:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X+pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+pos.y);
    -- self.items[2]:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,self.items[2]);
    self.armature.display:addChild(self.items[2]);

    self.name2:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",equipArr[6].ItemId,"name"));

    local jinjieData = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",equipArr[6].ItemId);
    if jinjieData and 0 ~= jinjieData.target then
      self.prop_descb_2:setString("英雄达到" .. jinjieData.levelLimit .. "级");
      self["button_2_1"]:setVisible(self.data.Level >= jinjieData.levelLimit);
    else
      self.prop_descb_2:setString("进阶已满");
      self["button_2_1"]:setVisible(false);
    end

    local descbs = {{self["prop_descb_2_3"]},
                    {self["prop_descb_2_2"],self["prop_descb_2_4"]},
                    {self["prop_descb_2_2"],self["prop_descb_2_3"],self["prop_descb_2_4"]},
                    {self["prop_descb_2_1"],self["prop_descb_2_2"],self["prop_descb_2_3"],self["prop_descb_2_4"]},
                    {self["prop_descb_2_1"],self["prop_descb_2_2"],self["prop_descb_2_3"],self["prop_descb_2_4"],self["prop_descb_2_5"]}};
    local count = 0;
    for k,v in pairs(equipArr[6].PropertyArray) do
      if 0 == v.Type then
        break;
      end
      count = 1 + count;
    end
    descbs = descbs[count];
    for k,v in pairs(equipArr[6].PropertyArray) do
      if 0 == v.Type then
        break;
      end
      local value = math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(equipArr[6].GeneralId, equipArr[6].ItemId, v.Type));
      descbs[k]:setString(analysis("Shuxing_Shuju",v.Type,"name") .. " +" .. value);
    end

    self.none_2_1:setString("");
    self.none_2_2:setString("");
  end

  self:refreshRedDot();
  if self.heroShipinJinjieLayer then
    self.heroShipinJinjieLayer:refreshData(self.data.GeneralId);
  end
  if self.heroShipinXilianLayer then
    self.heroShipinXilianLayer:refreshData(self.data.GeneralId);
  end
  if self.context.heroShipinXilianChenggongLayer then
    -- self.context.heroShipinXilianChenggongLayer:refreshData(self.data.GeneralId);
  end
end

function HeroShipinLayer:refreshRedDot()
  local data = self.context.heroHouseProxy:getHongdianData(self.data.GeneralId);
  if data.BetterJinjieEquip then
    self.reddots[1]:setVisible(1 == data.BetterJinjieEquip[2]);
    self.reddots[2]:setVisible(1 == data.BetterJinjieEquip[6]);
  else
    self.reddots[1]:setVisible(false);
    self.reddots[2]:setVisible(false);
  end
end

function HeroShipinLayer:refreshBySilver()
  if self.heroShipinJinjieLayer then
    self.heroShipinJinjieLayer:refreshData(self.data.GeneralId);
  end
  if self.heroShipinXilianLayer then
    self.heroShipinXilianLayer:refreshData(self.data.GeneralId);
  end
end

function HeroShipinLayer:onBagItemTap(event, bagItem)
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

function HeroShipinLayer:refreshJinjie()
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








HeroShipinJinjieLayer=class(TouchLayer);

function HeroShipinJinjieLayer:ctor()
  self.class=HeroShipinJinjieLayer;
end

function HeroShipinJinjieLayer:dispose()
  self.armature:dispose();
  HeroShipinJinjieLayer.superclass.dispose(self);
  if self.context.parent then
    self.context.pageView:setMoveEnabled(true);
  end
end

function HeroShipinJinjieLayer:initialize(context, container, num)
  self.context = context;
  self.container = container;
  self.num = num;
  self:initLayer();

  self.bg = LayerColorBackGround:getTransBackGround();
  self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
  self.context:addChild(self.bg);

  --骨骼
  local armature=self.context.skeleton:buildArmature("shipin_jinjie_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature.display:setPositionXY(375,10);
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

  for i=1,5 do
    self["prop_descb_1_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_1_" .. i).textData,text,true);
    self.armature.display:addChild(self["prop_descb_1_" .. i]);

    self["prop_descb_2_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_2_" .. i).textData,text,true);
    self.armature.display:addChild(self["prop_descb_2_" .. i]);
  end

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
  self.titleTF = BitmapTextField.new("饰品进阶","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(185,597);
  self.armature.display:addChild(self.titleTF);

  self.context.pageView:setMoveEnabled(false);
end

function HeroShipinJinjieLayer:onClose(event)
  if self.bg.parent then
    self.bg.parent:removeChild(self.bg);
  end
  self.parent:removeChild(self);
  self.container.heroShipinJinjieLayer = nil;
end

function HeroShipinJinjieLayer:refreshData(generalID)
  self.data = self.context.heroHouseProxy:getGeneralData(generalID);
  local data_1 = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.num);
  local data_2 = copyTable(data_1);
  local job = analysis("Kapai_Kapaiku",self.data.ConfigId,"job");
  local jijie_data = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",data_1.ItemId);
  if not jijie_data or 0 == jijie_data.target or jijie_data.levelLimit > self.data.Level then
    self:onClose();
    return;
  end
  data_2.ItemId = analysis("Zhuangbei_Zhuangbeijinjiebiao",jijie_data.target,"equipmentId");
  self.data_1 = data_1;
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
  self.left_bagItem:setPositionXY(101,481);
  self.armature.display:addChild(self.left_bagItem);

  self.right_bagItem = BagItem.new();
  self.right_bagItem:initialize(data_2);
  -- self.right_bagItem:setBackgroundVisible(true);
  self.right_bagItem:setPositionXY(331,481);
  self.armature.display:addChild(self.right_bagItem);

  self.grid_1:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",data_1.ItemId,"name"));
  local jijie_data_2 = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","job",job,"equipmentId",data_2.ItemId);
  self.grid_2:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",data_2.ItemId,"name"));

  local silver_need = tonumber(StringUtils:lua_string_split(jijie_data.money,",")[2]);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=silver_need;
  self.huafei_descb:setString(silver_need);

  self.bagItemsLayer = Layer.new();
  self.bagItemsLayer:initLayer();
  self.bagItemsLayer:setPositionXY(0,147);
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
  self.bagItemsLayer:setPositionX(-self.bagItemsLayer:getGroupBounds().size.width/2+272);

  for i=1,5 do
    self["prop_descb_1_" .. i]:setString("");
    self["prop_descb_2_" .. i]:setString("");
  end
  local count = 0;
  if data_1.PropertyArray then
    for k,v in pairs(data_1.PropertyArray) do
      count = 1 + count;
      if 0 == v.Type then
        break;
      end
      local s = analysis("Shuxing_Shuju",v.Type,"name") .. v.Value;
      self["prop_descb_1_" .. k]:setString(s);
      self["prop_descb_2_" .. k]:setString(s);
    end
    if 0 < count then
      self["prop_descb_2_" .. (1 + count)]:setString("?????");
    end
  end

  self.context.equipmentInfoProxy.jinjie_general_id_cache = data_1.GeneralId;
  self.context.equipmentInfoProxy.jinjie_item_id_cache = data_1.ItemId;
  self.context.equipmentInfoProxy.jinjie_target_item_id_cache = data_2.ItemId;
end

function HeroShipinJinjieLayer:onJinjieButtonTap(event)
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
  print(self.data.GeneralId,self.data_1.ItemId);
  sendMessage(10,3,{GeneralId = self.data.GeneralId, ItemId = self.data_1.ItemId});
  self.context.strengthenProxy.Dazao_Bool = true;
  self.context.strengthenProxy.Equip_Dazao_ItemID_Cache = self.data_1.ItemId;
end

function HeroShipinJinjieLayer:onBagItemTap(event, bagItem)
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










HeroShipinXilianLayer=class(TouchLayer);

function HeroShipinXilianLayer:ctor()
  self.class=HeroShipinXilianLayer;
end

function HeroShipinXilianLayer:dispose()
  self.armature:dispose();
  HeroShipinXilianLayer.superclass.dispose(self);
  if self.context.parent then
    self.context.pageView:setMoveEnabled(true);
  end
end

function HeroShipinXilianLayer:initialize(context, container, num)
  self.context = context;
  self.container = container;
  self.num = num;
  self:initLayer();
  self.yiquxiao_nums = {};

  self.bg = LayerColorBackGround:getTransBackGround();
  self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
  self.bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.context:addChild(self.bg);

  --骨骼
  local armature=self.context.skeleton:buildArmature("shipin_xilian_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local text="";
  self.shipin_xilian_shuxing_layer=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("title_1").textData,"可能出现的属性");
  self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self.shipin_xilian_shuxing_layer);
  self.shipin_xilian_shuxing_layer.touchChildren = false;
  self.shipin_xilian_shuxing_layer.touchEnabled = false;

  for i=1,10 do
    self["item_bg_" .. i]=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("item_bg_" .. i).textData,text);
    self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self["item_bg_" .. i]);
    self["item_bg_" .. i].touchEnabled = false;

    self["item_bg_" .. i .. "_shangxian"]=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("item_bg_" .. i .. "_shangxian").textData,text);
    self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self["item_bg_" .. i .. "_shangxian"]);
    self["item_bg_" .. i .. "_shangxian"].touchEnabled = false;
  end

  self.grid=createTextFieldWithTextData(armature:getBone("grid").textData,text,true);
  self.armature.display:addChild(self.grid);

  local button=self.armature.display:getChildByName("detail_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("detail_btn"):getBone("common_small_blue_button").textData,"属性预览");
  -- button:initializeBMText("进阶","anniutuzi");
  button:addEventListener(DisplayEvents.kTouchTap,self.onShuxingButtonTap,self);
  layer:setScale(0.8);
  layer:setPosition(button_pos);
  layer:addChild(button);
  self.armature.display:addChild(layer);

  local button=self.armature.display:getChildByName("btn_xilian");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("btn_xilian"):getBone("common_small_blue_button").textData,"洗练");
  -- button:initializeBMText("进阶","anniutuzi");
  button:addEventListener(DisplayEvents.kTouchTap,self.onXilianButtonTap,self);
  layer:setScale(1);
  layer:setPosition(button_pos);
  layer:addChild(button);
  self.armature.display:addChild(layer);

  self.zhuangbei_cailiao_bg2=createTextFieldWithTextData(armature:getBone("zhuangbei_cailiao_bg2").textData,"消耗:",true);
  self.armature.display:addChild(self.zhuangbei_cailiao_bg2);

  -- self.huafei=createTextFieldWithTextData(armature:getBone("huafei").textData,"花费银两:");
  -- self.armature.display:addChild(self.huafei);

  self.huafei_descb=createTextFieldWithTextData(armature:getBone("huafei_descb").textData,text,true);
  self.armature.display:addChild(self.huafei_descb);

  self.huafei_gold_descb=createTextFieldWithTextData(armature:getBone("huafei_gold_descb").textData,text,true);
  self.armature.display:addChild(self.huafei_gold_descb);

  local button=self.armature.display:getChildByName("btn_1");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  for i=1,5 do
    self["prop_descb_1_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_1_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_1_" .. i]);
    self["prop_descb_1_" .. i].touchEnabled = false;

    self["prop_descb_2_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_2_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_2_" .. i]);
    self["prop_descb_2_" .. i].touchEnabled = false;

    local layer = Layer.new();
    layer:initLayer();
    button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    button:initializeText(self.armature:findChildArmature("btn_1"):getBone("common_small_blue_button").textData,"");
    -- button:initializeBMText("进阶","anniutuzi");
    button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,i);
    layer:setScale(0.8);
    layer:setPositionXY(10 + button_pos.x,-(-1+i)*51+button_pos.y+3);
    layer:addChild(button);
    self.armature.display:addChild(layer);
    self["button" .. i]=button;
  end

  self.titleTF = BitmapTextField.new("饰品洗练","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(677,525);
  self.armature.display:addChild(self.titleTF);

  self:onShuxingButtonTap();
  self.context.pageView:setMoveEnabled(false);

  self.armature.display:getChildByName("huafei_descb"):setScale(0.8);
  self.armature.display:getChildByName("huafei_gold_descb"):setScale(0.8);

  self:onShuxingButtonTap(nil);
end

function HeroShipinXilianLayer:onClose(event)
  if self.bg.parent then
    self.bg.parent:removeChild(self.bg);
  end
  self.parent:removeChild(self);
  self.container.heroShipinXilianLayer = nil;
end

function HeroShipinXilianLayer:refreshData(generalID)
  self.data = self.context.heroHouseProxy:getGeneralData(generalID);
  self.equip_data  = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.data.GeneralId,self.num);

  if self.left_bagItem then
    self.armature.display:removeChild(self.left_bagItem);
    self.left_bagItem = nil;
  end

  self.left_bagItem = BagItem.new();
  self.left_bagItem:initialize(self.equip_data);
  -- self.left_bagItem:setBackgroundVisible(true);
  self.left_bagItem:setPositionXY(467,389);
  self.armature.display:addChild(self.left_bagItem);

  self.grid:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",self.equip_data.ItemId,"name"));

  self:refreshSilverNeed();

  for i=1,5 do
    self["prop_descb_1_" .. i]:setString("");
    self["prop_descb_2_" .. i]:setString("");
    self["button" .. i]:setVisible(false);
  end
  local count = 0;
  for k,v in pairs(self.equip_data.PropertyArray) do
    count = 1 + count;
    if 0 == v.Type then
      break;
    end
    local value = math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(self.data.GeneralId, self.equip_data.ItemId, v.Type));
    local s = analysis("Shuxing_Shuju",v.Type,"name") .. " +" .. value;
    self["prop_descb_1_" .. k]:setString(s);
    self["button" .. k]:setVisible(true);
    local bool = false;
    for k_,v_ in pairs(self.yiquxiao_nums) do
      if k == v_ then bool = true; end
    end
    self["button" .. k]:setString(bool and "取消" or "锁定");
    self["prop_descb_2_" .. k]:setString(bool and "(已锁定)" or "");
  end
  self.num_total = count;

  self:refreshShuxingData();
end

function HeroShipinXilianLayer:refreshShuxingData()
  if self.shuxing_refreshed then return; end
  self.shuxing_refreshed = true;
  local data = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.equip_data.ItemId);
  local shuxing_data = analysisTotalTable("Zhuangbei_Shuxingsuijibiao");
  local temp = {};
  for k,v in pairs(shuxing_data) do
    if data.roundID == v.zuId then
      table.insert(temp,v);
    end
  end
  shuxing_data = temp;
  for i = 1, table.getn(shuxing_data) do
    print(shuxing_data[i].Additional);
    self["item_bg_" .. i]:setString(analysis("Shuxing_Shuju",shuxing_data[i].Additional,"name"));
    self["item_bg_" .. i .. "_shangxian"]:setString("(上限" .. shuxing_data[i].amount1 .. ")");
  end
end

function HeroShipinXilianLayer:onButtonTap(event, num)
  for k,v in pairs(self.yiquxiao_nums) do
    if num == v then
      self["prop_descb_2_" .. num]:setString("");
      self["button" .. num]:setString("锁定");
      table.remove(self.yiquxiao_nums,k);
      self:refreshSilverNeed();
      return;
    end
  end
  self["prop_descb_2_" .. num]:setString("(已锁定)");
  self["button" .. num]:setString("取消");
  table.insert(self.yiquxiao_nums,num);

  self:refreshSilverNeed();
end

function HeroShipinXilianLayer:refreshSilverNeed()
  local equip_color = analysis("Daoju_Daojubiao",self.equip_data.ItemId,"color");
  local silver_need = analysisByName("Zhuangbei_Xilianxiaohao","color",equip_color);
  for k,v in pairs(silver_need) do
    silver_need = v;
  end
  silver_need = tonumber(StringUtils:lua_string_split(silver_need.cost,",")[2]);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=silver_need;
  self.huafei_descb:setString(silver_need);

  if 0 < table.getn(self.yiquxiao_nums) then
    local gold_need = analysisByName("Zhuangbei_Xilianxiaohao","color",equip_color);
    for k,v in pairs(gold_need) do
      gold_need = v;
    end
    gold_need = tonumber(StringUtils:stuff_string_split(gold_need.yuanbao)[table.getn(self.yiquxiao_nums)][2]);
    self.gold_is_enough = self.context.userCurrencyProxy:getGold()>=gold_need;
    self.huafei_gold_descb:setString(gold_need);
  else
    self.gold_is_enough = true;
    self.huafei_gold_descb:setString("0");
  end
end

function HeroShipinXilianLayer:onShuxingButtonTap(event)
  if self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):isVisible() then
    self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):setVisible(false);
    self.armature.display:setPositionX(-110);
  else
    self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):setVisible(true);
    self.armature.display:setPositionX(0);
  end
end

function HeroShipinXilianLayer:onXilianButtonTap(event)
  if self.context.strengthenProxy.Xi_Lian then
    return;
  end
  if nil ~= self.gold_is_enough and not self.gold_is_enough then
    sharedTextAnimateReward():animateStartByString("元宝不足哦 ~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
    return;
  elseif not self.silver_is_enough then
    sharedTextAnimateReward():animateStartByString("银两不足了呢~");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  local data = {};
  for k,v in pairs(self.yiquxiao_nums) do
    table.insert(data,{ID=self.equip_data.PropertyArray[v].Type});
  end
  if table.getn(data) < self.num_total then
    initializeSmallLoading();
    sendMessage(10,4,{GeneralId = self.data.GeneralId, ItemId = self.equip_data.ItemId, IDArray = data});
    self.context.strengthenProxy.Xi_Lian = true;
  else
    sharedTextAnimateReward():animateStartByString("没有可洗练的属性哦 ~");
  end
end



HeroShipinXilianChenggongLayer=class(TouchLayer);

function HeroShipinXilianChenggongLayer:ctor()
  self.class=HeroShipinXilianChenggongLayer;
end

function HeroShipinXilianChenggongLayer:dispose()
  self.armature:dispose();
  HeroShipinXilianChenggongLayer.superclass.dispose(self);

  if not self.context.isDisposed then
    self.context.pageView:setMoveEnabled(true);
  end
end

function HeroShipinXilianChenggongLayer:initialize(context, chenggong_data)
  self.context = context;
  self.chenggong_data = chenggong_data;
  self:initLayer();

  self.bg = LayerColorBackGround:getTransBackGround();
  -- self.bg:addEventListener(DisplayEvents.kTouchTap,self.onClose,self);
  self.bg:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.context:addChild(self.bg);

  --骨骼
  local armature=self.context.skeleton:buildArmature("shipin_xilian_chenggong_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self:addChild(self.armature.display);

  local text="";
  self.shipin_xilian_shuxing_layer=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("title_1").textData,"可能出现的属性");
  self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self.shipin_xilian_shuxing_layer);
  self.shipin_xilian_shuxing_layer.touchChildren = false;
  self.shipin_xilian_shuxing_layer.touchEnabled = false;

  for i=1,10 do
    self["item_bg_" .. i]=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("item_bg_" .. i).textData,text);
    self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self["item_bg_" .. i]);
    self["item_bg_" .. i].touchEnabled = false;

    self["item_bg_" .. i .. "_shangxian"]=createTextFieldWithTextData(armature:findChildArmature("shipin_xilian_shuxing_layer"):getBone("item_bg_" .. i .. "_shangxian").textData,text);
    self.armature:findChildArmature("shipin_xilian_shuxing_layer").display:addChild(self["item_bg_" .. i .. "_shangxian"]);
    self["item_bg_" .. i .. "_shangxian"].touchEnabled = false;
  end

  self.grid=createTextFieldWithTextData(armature:getBone("grid").textData,text,true);
  self.armature.display:addChild(self.grid);

  local button=self.armature.display:getChildByName("detail_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("detail_btn"):getBone("common_small_blue_button").textData,"属性预览");
  -- button:initializeBMText("进阶","anniutuzi");
  button:addEventListener(DisplayEvents.kTouchTap,self.onShuxingButtonTap,self);
  layer:setScale(0.8);
  layer:setPosition(button_pos);
  layer:addChild(button);
  self.armature.display:addChild(layer);

  local button=self.armature.display:getChildByName("btn_xilian");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("btn_xilian"):getBone("common_small_blue_button").textData,"保留");
  -- button:initializeBMText("进阶","anniutuzi");
  button:addEventListener(DisplayEvents.kTouchTap,self.onBaoliuButtonTap,self);
  layer:setScale(1);
  layer:setPosition(button_pos);
  layer:addChild(button);
  self.armature.display:addChild(layer);

  local button=self.armature.display:getChildByName("btn_xilian_quxiao");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(self.armature:findChildArmature("btn_xilian_quxiao"):getBone("common_small_blue_button").textData,"放弃");
  -- button:initializeBMText("进阶","anniutuzi");
  button:addEventListener(DisplayEvents.kTouchTap,self.onFangqiButtonTap,self);
  layer:setScale(1);
  layer:setPosition(button_pos);
  layer:addChild(button);
  self.armature.display:addChild(layer);

  self.zhuangbei_cailiao_bg2=createTextFieldWithTextData(armature:getBone("zhuangbei_cailiao_bg2").textData,"是否要保留以上洗练属性?");
  self.armature.display:addChild(self.zhuangbei_cailiao_bg2);

  for i=1,5 do
    self["prop_descb_1_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_1_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_1_" .. i]);
    self["prop_descb_1_" .. i].touchEnabled = false;

    self["prop_descb_2_" .. i]=createTextFieldWithTextData(armature:getBone("prop_descb_2_" .. i).textData,text);
    self.armature.display:addChild(self["prop_descb_2_" .. i]);
    self["prop_descb_2_" .. i].touchEnabled = false;
  end

  self.titleTF = BitmapTextField.new("饰品洗练","anniutuzi");--选择好友助战
  self.titleTF:setPositionXY(677,525);
  self.armature.display:addChild(self.titleTF);

  self:onShuxingButtonTap();
  self.context.heroShipinLayer.heroShipinXilianLayer:setVisible(false);
  self.context.heroShipinLayer.heroShipinXilianLayer.bg:setVisible(false);
  self.context.pageView:setMoveEnabled(false);

  self:refreshData(self.chenggong_data.GeneralId);
  self:onShuxingButtonTap(nil);
end

function HeroShipinXilianChenggongLayer:onClose(event)
  if self.bg.parent then
    self.bg.parent:removeChild(self.bg);
  end
  self.parent:removeChild(self);
  self.context.heroShipinXilianChenggongLayer = nil;
  self.context.heroShipinLayer.heroShipinXilianLayer:setVisible(true);
  self.context.heroShipinLayer.heroShipinXilianLayer.bg:setVisible(true);
end

function HeroShipinXilianChenggongLayer:refreshData(generalID)
  self.data = self.context.heroHouseProxy:getGeneralData(generalID);
  self.equip_data  = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndItemID(self.data.GeneralId,self.chenggong_data.ItemId);
  self:refreshShuxingData();

  local prop_temp = {};
  for k,v in pairs(self.equip_data.PropertyArray) do
    local bool = false;
    for k_,v_ in pairs(self.chenggong_data.PropertyArray) do
      if v.Type == v_.Type then
        bool = true;
        table.remove(self.chenggong_data.PropertyArray,k_);
        table.insert(prop_temp,v_);
        break;
      end
    end
    if bool then

    else
      table.insert(prop_temp,0);
    end
  end
  for k,v in pairs(prop_temp) do
    if 0 == v then
      for k_,v_ in pairs(self.chenggong_data.PropertyArray) do
        table.remove(self.chenggong_data.PropertyArray,k_);
        prop_temp[k] = v_;
        break;
      end
    end
  end
  self.chenggong_data.PropertyArray = prop_temp;

  if self.left_bagItem then
    self.armature.display:removeChild(self.left_bagItem);
    self.left_bagItem = nil;
  end

  self.left_bagItem = BagItem.new();
  self.left_bagItem:initialize(self.equip_data);
  -- self.left_bagItem:setBackgroundVisible(true);
  self.left_bagItem:setPositionXY(467,389);
  self.armature.display:addChild(self.left_bagItem);

  self.grid:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",self.equip_data.ItemId,"name"));

  for i=1,5 do
    self["prop_descb_1_" .. i]:setString("");
    self["prop_descb_2_" .. i]:setString("");
    self.armature.display:getChildByName("arrow_" .. i):setVisible(false);
  end
  local count = 0;
  local suoding_nums = self.context.heroShipinLayer.heroShipinXilianLayer.yiquxiao_nums;
  local temp = {};
  for k,v in pairs(suoding_nums) do
    temp[v] = v;
  end
  suoding_nums = temp;
  if self.equip_data.PropertyArray then
    for k,v in pairs(self.equip_data.PropertyArray) do
      count = 1 + count;
      if 0 == v.Type then
        break;
      end
      local value = math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(self.data.GeneralId, self.equip_data.ItemId, v.Type));
      local name = analysis("Shuxing_Shuju",v.Type,"name");
      local s = name .. " +" .. value;
      self["prop_descb_1_" .. k]:setString(s);

      
      name = analysis("Shuxing_Shuju",self.chenggong_data.PropertyArray[k].Type,"name");
      local temp = self.equip_data.PropertyArray;
      self.equip_data.PropertyArray = self.chenggong_data.PropertyArray;
      local value = math.ceil(self.context.equipmentInfoProxy:getEquipPropValue(self.data.GeneralId, self.equip_data.ItemId, self.equip_data.PropertyArray[k].Type));
      self.equip_data.PropertyArray = temp;
      s = name .. " +" .. value;--self.chenggong_data.PropertyArray[k].Value;

      self["prop_descb_2_" .. k]:setString(suoding_nums[k] and "(已锁定)" or s);
      self["prop_descb_2_" .. k]:setColor(self.prop_array["k" .. self.chenggong_data.PropertyArray[k].Type] > value and ccc3(34,9,1) or ccc3(0,255,0));
      
      -- for k_,v_ in pairs(self.chenggong_data.PropertyArray) do
      --   if v.Type == v_.Type then
      --     if suoding_nums[v_.Type] then
      --       self["prop_descb_2_" .. k]:setString("(已锁定)");
      --     else
      --       self["prop_descb_2_" .. k]:setString(name .. v_.Value);
      --     end
      --   end
      -- end
      
      self.armature.display:getChildByName("arrow_" .. k):setVisible(true);
    end
  end
end

function HeroShipinXilianChenggongLayer:refreshShuxingData()
  if self.shuxing_refreshed then return; end
  self.shuxing_refreshed = true;
  self.prop_array = {};
  local data = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.equip_data.ItemId);
  local shuxing_data = analysisTotalTable("Zhuangbei_Shuxingsuijibiao");
  local temp = {};
  for k,v in pairs(shuxing_data) do
    if data.roundID == v.zuId then
      table.insert(temp,v);
    end
  end
  shuxing_data = temp;
  for i = 1, table.getn(shuxing_data) do
    print(shuxing_data[i].Additional);
    self["item_bg_" .. i]:setString(analysis("Shuxing_Shuju",shuxing_data[i].Additional,"name"));
    self["item_bg_" .. i .. "_shangxian"]:setString("(上限" .. shuxing_data[i].amount1 .. ")");
    self.prop_array["k" .. shuxing_data[i].Additional] = shuxing_data[i].amount1;
  end
end

function HeroShipinXilianChenggongLayer:onShuxingButtonTap(event)
  if self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):isVisible() then
    self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):setVisible(false);
    self.armature.display:setPositionX(-110);
  else
    self.armature.display:getChildByName("shipin_xilian_shuxing_layer"):setVisible(true);
    self.armature.display:setPositionX(0);
  end
end

function HeroShipinXilianChenggongLayer:onFangqiButtonTap(event)
  sendMessage(10,5,{GeneralId = self.chenggong_data.GeneralId, ItemId = self.equip_data.ItemId, BooleanValue = 0});
  self:onClose();
end

function HeroShipinXilianChenggongLayer:onBaoliuButtonTap(event)
  sendMessage(10,5,{GeneralId = self.chenggong_data.GeneralId, ItemId = self.equip_data.ItemId, BooleanValue = 1});
  self:onBaoliuButtonTapConfirm();
  self.context:refreshZhanli(self.context.selectedData);
end

function HeroShipinXilianChenggongLayer:onBaoliuButtonTapConfirm()
  self.context.equipmentInfoProxy:refreshShipinXinlianChenggong(self.chenggong_data);
  self.context:refreshOnShipinXilianBaoliu();
  self:onClose();
end