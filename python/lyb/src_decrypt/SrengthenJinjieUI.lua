SrengthenJinjieUI=class(Layer);

function SrengthenJinjieUI:ctor()
  self.class=SrengthenJinjieUI;
end

function SrengthenJinjieUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SrengthenJinjieUI.superclass.dispose(self);
  self.armature:dispose();
end

function SrengthenJinjieUI:initialize(context)
	self.context = context;
  self.skeleton = self.context.skeleton;
	self:initLayer();
  self.bagItemsLayer = nil;
  
  local armature=self.skeleton:buildArmature("jinjie_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  self.contentLayer = Layer.new();
  self.contentLayer:initLayer();
  self:addChild(self.contentLayer);

  local jinjie_bg_1 = self.armature.display:getChildByName("jinjie_bg_1");
  jinjie_bg_1.parent:removeChild(jinjie_bg_1,false);
  self.contentLayer:addChild(jinjie_bg_1);
  local jinjie_bg_2 = self.armature.display:getChildByName("jinjie_bg_2");
  jinjie_bg_2.parent:removeChild(jinjie_bg_2,false);
  self.contentLayer:addChild(jinjie_bg_2);
  local name_bg_1 = self.armature.display:getChildByName("name_bg_1");
  name_bg_1.parent:removeChild(name_bg_1,false);
  self.contentLayer:addChild(name_bg_1);
  local name_bg_2 = self.armature.display:getChildByName("name_bg_2");
  name_bg_2.parent:removeChild(name_bg_2,false);
  self.contentLayer:addChild(name_bg_2);
  local arrow_1 = self.armature.display:getChildByName("arrow_1");
  arrow_1.parent:removeChild(arrow_1,false);
  self.contentLayer:addChild(arrow_1);

  self.descb=createTextFieldWithTextData(self.armature:getBone("descb").textData,"此装备品质等级已满哦 ~",true);
  self.armature.display:addChild(self.descb);

  self.center_descb_1=createTextFieldWithTextData(self.armature:getBone("center_descb_1").textData,"需求",true);
  self.contentLayer:addChild(self.center_descb_1);
  self.center_descb_2=createTextFieldWithTextData(self.armature:getBone("center_descb_2").textData,"",true);
  self.contentLayer:addChild(self.center_descb_2);

  self.name_bg_1=createTextFieldWithTextData(self.armature:getBone("name_bg_1").textData,"");
  self.contentLayer:addChild(self.name_bg_1);
  self.left_descb_1=createTextFieldWithTextData(self.armature:getBone("left_descb_1").textData,"");
  self.contentLayer:addChild(self.left_descb_1);
  self.left_descb_2=createTextFieldWithTextData(self.armature:getBone("left_descb_2").textData,"");
  self.contentLayer:addChild(self.left_descb_2);
  self.left_descb_3=createTextFieldWithTextData(self.armature:getBone("left_descb_3").textData,"");
  self.contentLayer:addChild(self.left_descb_3);
  self.left_descb_4=createTextFieldWithTextData(self.armature:getBone("left_descb_4").textData,"");
  self.contentLayer:addChild(self.left_descb_4);
  self.left_descb_5=createTextFieldWithTextData(self.armature:getBone("left_descb_5").textData,"");
  self.contentLayer:addChild(self.left_descb_5);

  self.name_bg_2=createTextFieldWithTextData(self.armature:getBone("name_bg_2").textData,"");
  self.contentLayer:addChild(self.name_bg_2);
  self.right_descb_1=createTextFieldWithTextData(self.armature:getBone("right_descb_1").textData,"");
  self.contentLayer:addChild(self.right_descb_1);
  self.right_descb_2=createTextFieldWithTextData(self.armature:getBone("right_descb_2").textData,"");
  self.contentLayer:addChild(self.right_descb_2);
  self.right_descb_3=createTextFieldWithTextData(self.armature:getBone("right_descb_3").textData,"");
  self.contentLayer:addChild(self.right_descb_3);
  self.right_descb_4=createTextFieldWithTextData(self.armature:getBone("right_descb_4").textData,"");
  self.contentLayer:addChild(self.right_descb_4);
  self.right_descb_5=createTextFieldWithTextData(self.armature:getBone("right_descb_5").textData,"");
  self.contentLayer:addChild(self.right_descb_5);

  self.bottom_descb_1=createTextFieldWithTextData(self.armature:getBone("bottom_descb_1").textData,"材料:");
  self.contentLayer:addChild(self.bottom_descb_1);
  self.bottom_descb_2=createTextFieldWithTextData(self.armature:getBone("bottom_descb_2").textData,"");
  self.contentLayer:addChild(self.bottom_descb_2);

  --common_small_blue_button0
  local common_small_blue_button0=self.armature.display:getChildByName("btn_1");
  local common_small_blue_button0_pos=convertBone2LB4Button(common_small_blue_button0);
  self.armature.display:removeChild(common_small_blue_button0);

  local common_small_blue_button0=CommonButton.new();
  common_small_blue_button0:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- common_small_blue_button0:initializeText(self.armature:findChildArmature("common_small_blue_button0"):getBone("common_small_blue_button").textData,"强 化");
  common_small_blue_button0:initializeBMText("打 造","anniutuzi");
  common_small_blue_button0:setPosition(common_small_blue_button0_pos);
  common_small_blue_button0:addEventListener(DisplayEvents.kTouchTap,self.onJiejieTap,self);
  self.contentLayer:addChild(common_small_blue_button0);
  self.strengthenButton=common_small_blue_button0;

  self.silver_img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
  self.silver_img:setScale(0.8);
  self.silver_img:setPositionXY(800,135);
  self.contentLayer:addChild(self.silver_img);
end

function SrengthenJinjieUI:refresh(bagItem)
  if bagItem then
    self.contentLayer:setVisible(true);
  else
    self.contentLayer:setVisible(false);
    return;
  end

  if self.bagItemSelected then
    self.contentLayer:removeChild(self.bagItemSelected);
    self.bagItemSelected = nil;
  end
  if self.bagItemJinjie then
    self.contentLayer:removeChild(self.bagItemJinjie);
    self.bagItemJinjie = nil;
  end
  self.bagItemSelected = bagItem:clone();
  self.bagItemSelected:setBackgroundVisible(true);
  self.bagItemSelected:setPositionXY(632,495);
  self.bagItemSelected.touchEnabled = true;
  self.bagItemSelected.touchChildren = true;
  self.bagItemSelected:addEventListener(DisplayEvents.kTouchTap,self.context.popEquipDetail,self.context,self.bagItemSelected);
  self.contentLayer:addChild(self.bagItemSelected);
  local data_1 = self.bagItemSelected:getItemData();
  local data_2 = copyTable(data_1);
  local wuxing = analysis("Kapai_Kapaiku",self.context.heroHouseProxy:getGeneralData(data_2.GeneralId).ConfigId,"wuXing");
  print("wuxing->",wuxing,"ItemId->",data_2.ItemId);
  local jijie_data = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","wuxing",wuxing,"equipmentId",data_2.ItemId);
  if not jijie_data then
    sharedTextAnimateReward():animateStartByString("wuxing->"..wuxing.." ItemId->" .. data_2.ItemId .. " 找秋雨，没有对应装备进阶数据");
    sharedTextAnimateReward():animateStartByString("wuxing->"..wuxing.." ItemId->" .. data_2.ItemId .. " 找秋雨，没有对应装备进阶数据");
    sharedTextAnimateReward():animateStartByString("wuxing->"..wuxing.." ItemId->" .. data_2.ItemId .. " 找秋雨，没有对应装备进阶数据");
    sharedTextAnimateReward():animateStartByString("wuxing->"..wuxing.." ItemId->" .. data_2.ItemId .. " 找秋雨，没有对应装备进阶数据");
    sharedTextAnimateReward():animateStartByString("wuxing->"..wuxing.." ItemId->" .. data_2.ItemId .. " 找秋雨，没有对应装备进阶数据");
  end
  if 0 ~= jijie_data.target then
    self.contentLayer:setVisible(true);
    self.descb:setVisible(false);
  else
    self.contentLayer:setVisible(false);
    self.descb:setVisible(true);
    return;
  end
  
  data_2.ItemId = analysis("Zhuangbei_Zhuangbeijinjiebiao",jijie_data.target,"equipmentId");
  self.bagItemJinjie = BagItem.new();
  self.bagItemJinjie:initialize(data_2);
  self.bagItemJinjie:setBackgroundVisible(true);
  self.bagItemJinjie:setPositionXY(966,495);
  self.bagItemJinjie.touchEnabled = true;
  self.bagItemJinjie.touchChildren = true;
  -- self.bagItemJinjie:addEventListener(DisplayEvents.kTouchTap,self.context.popEquipDetail,self.context,self.bagItemJinjie);
  self.contentLayer:addChild(self.bagItemJinjie);

  self.context.equipmentInfoProxy.jinjie_general_id_cache = data_1.GeneralId;
  self.context.equipmentInfoProxy.jinjie_item_id_cache = data_1.ItemId;
  self.context.equipmentInfoProxy.jinjie_target_item_id_cache = data_2.ItemId;

  self.center_descb_2:setString("强化等级:" .. jijie_data.require);
  self.Level_is_enough = data_1.StrengthenLevel >= jijie_data.require;
  if self.Level_is_enough then
    self.center_descb_1:setColor(ccc3(255,255,255));
    self.center_descb_2:setColor(ccc3(255,255,255));
  else
    self.center_descb_1:setColor(ccc3(255,0,0));
    self.center_descb_2:setColor(ccc3(255,0,0));
  end
  self.name_bg_1:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemSelected:getItemID(),"name"));
  self.name_bg_2:setString(analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemJinjie:getItemID(),"name"));

  local left_excel_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",data_1.ItemId);
  local left_add = left_excel_data.Additional1;
  for i=1,5 do
    self["left_descb_" .. i]:setString("");
  end
  if "" ~= left_add then
    left_add = StringUtils:stuff_string_split(left_add);
    for k,v in pairs(left_add) do
      -- local grade_str = getColorStringByDaojuGrade(1+k);
      local name_str = analysis("Shuxing_Shuju",tonumber(v[1]),"name");
      local value_str = v[2];--grade_str .. ":" .. 
      self["left_descb_" .. k]:setString(name_str .. "+" .. value_str);
    end
  end

  local right_excel_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",data_2.ItemId);
  local right_add = right_excel_data.Additional1;
  for i=1,5 do
    self["right_descb_" .. i]:setString("");
  end
  if "" ~= right_add then
    right_add = StringUtils:stuff_string_split(right_add);
    for k,v in pairs(right_add) do
      -- local grade_str = getColorStringByDaojuGrade(1+k);
      local name_str = analysis("Shuxing_Shuju",tonumber(v[1]),"name");
      local value_str = v[2];--grade_str .. ":" .. 
      self["right_descb_" .. k]:setString(name_str .. "+" .. value_str);
    end
  end

  local silver_need = tonumber(StringUtils:lua_string_split(jijie_data.money,",")[2]);
  print(jijie_data.money);
  self.bottom_descb_2:setString("消耗         : " .. silver_need);
  self.silver_is_enough = self.context.userCurrencyProxy:getSilver()>=silver_need;
  self.contentLayer:removeChild(self.bagItemsLayer);
  self.bagItemsLayer = Layer.new();
  self.bagItemsLayer:initLayer();
  self.bagItemsLayer:setPositionXY(0,182);
  self.contentLayer:addChild(self.bagItemsLayer);
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
      
      -- local textField=TextField.new(CCLabelTTF:create(bagCount .. "/" .. v[2],FontConstConfig.OUR_FONT,20));
      -- local sizeText=textField:getContentSize();
      -- textField:setColor(CommonUtils:ccc3FromUInt(bagCount >= tonumber(v[2]) and 16710121 or 16711680));
      -- textField.touchEnable = false;
      -- textField.touchChildren = false;
      -- textField:setPositionXY(-20+bagItemSize.width-sizeText.width,0);

      -- local textFieldContentSize = textField:getContentSize();
      -- local bg = self.skeleton:getBoneTexture9DisplayBySize("xiaozi_bg",nil,makeSize(10+textFieldContentSize.width,textFieldContentSize.height));
      -- bg.touchEnable = false;
      -- bg.touchChildren = false;
      -- bg:setPositionXY(-15+bagItemSize.width-bg:getContentSize().width,0);
      -- bagItem:addChild(bg);

      -- bagItem:addChild(textField);
    end
  else
    self.stuff_is_enough = false;
  end
  self.bagItemsLayer:setPositionX(660);---self.bagItemsLayer:getGroupBounds().size.width/2+780);
end

function SrengthenJinjieUI:onBagItemTap(event, bagItem)
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
  self.parent.parent:addChild(tipBg);
  layer:initialize(self.context.bagProxy:getSkeleton(),bagItem,true,DetailLayerType.KUAI_SU_SUO_YIN,closeTip);
  local size=self.parent:getContentSize();
  local popupSize=layer.armature.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  self.parent.parent:addChild(layer);
end

function SrengthenJinjieUI:onJiejieTap(event)
  if self.context.strengthenProxy.Dazao_Bool then
    return;
  end
  self:checkTutor()
  if not self.Level_is_enough then
    sharedTextAnimateReward():animateStartByString("强化等级不足哦 ~");
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
  local data = self.bagItemSelected:getItemData();
  sendMessage(10,3,{GeneralId = data.GeneralId, ItemId = data.ItemId});
  self.context.strengthenProxy.Dazao_Bool = true;
end

function SrengthenJinjieUI:checkTutor()
  if GameVar.tutorStage == TutorConfig.STAGE_2010 then
    
    openTutorUI({x=1138, y=624, width = 78, height = 75, alpha = 125});    

  end
end