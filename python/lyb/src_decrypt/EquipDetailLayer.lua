require "main.view.bag.ui.bagPopup.EquipStar";
require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "core.controls.ListScrollViewLayer";
require "core.utils.CommonUtil";
require "main.view.strengthen.ui.strengthenPopup.StrengthenFormula";
require "core.display.LayerPopable";

EquipDetailLayer=class(LayerKeyBackable);

function EquipDetailLayer:dispose()
  if self.grid_over and self.grid_over.parent then
    self.grid_over.parent:removeChild(self.grid_over);
  end
  self:removeAllEventListeners();
  self:removeChildren();
  EquipDetailLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function EquipDetailLayer:getItemData()
  return self.itemData;
end

BagItemType = {
  bagItem = "bagItem",
  equipeItem = "equipeItem",
  putOffEquipeItem = "putOffEquipeItem",
  openEquipe = "openEquipe",
  OnHeroPro = "OnHeroPro"
};


--intialize UI
function EquipDetailLayer:initialize(skeleton, tapItem, showButton, lookUpEquipmentData, itemType, callBack)
  self:initLayer();
  self.equipmentInfo=self:retrieveProxy(EquipmentInfoProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.callBack = callBack;

  local armature_name;
  self.isSmall = false;
  -- if 0 == analysis("Zhuangbei_Zhuangbeipeizhibiao",tapItem:getItemData().ItemId,"Additional1") then
  --   armature_name = "equip_detail_ui_small";
  --   self.isSmall = true;
  -- else
    armature_name = "equip_detail_ui";
  -- end

  local armature=skeleton:buildArmature(armature_name);
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  local armature_d=armature.display;

  local equip_pos2 = nil;
  local putOffEquipButton = nil;
  putOffEquipButton=armature_d:getChildByName("common_blue_button2");
  equip_pos2=convertBone2LB4Button(putOffEquipButton);--equipButton:getPosition();
  armature_d:removeChild(putOffEquipButton);  
  -- equip_pos.x = 5.5;
  -- putOffEquipButton:setPosition(equip_pos);
  -- putOffEquipButton:setVisible(false);
  local openEquipButton = nil;
  local equipButton = nil;
  local equip_pos = nil;
  if itemType == BagItemType.equipeItem then
     --装备
    equipButton=armature_d:getChildByName("common_blue_button");
    equip_pos=convertBone2LB4Button(equipButton);--equipButton:getPosition();
    armature_d:removeChild(equipButton);
  elseif itemType == BagItemType.putOffEquipeItem then
    openEquipButton=armature_d:getChildByName("common_blue_button");
    equip_pos=convertBone2LB4Button(openEquipButton);--equipButton:getPosition();
    armature_d:removeChild(openEquipButton);  
    -- equip_pos.x = 188;  
    -- openEquipButton:setPosition(equip_pos);
    -- putOffEquipButton:setVisible(true);
  elseif itemType == BagItemType.OnHeroPro then
    openEquipButton=armature_d:getChildByName("common_blue_button");
    equip_pos=convertBone2LB4Button(openEquipButton);--equipButton:getPosition();
    armature_d:removeChild(openEquipButton);  
  else
    --出售
    sellButton=armature_d:getChildByName("common_blue_button");
    sell_pos=convertBone2LB4Button(sellButton);--equipButton:getPosition();
    armature_d:removeChild(sellButton);
  end;

  self:addChild(armature_d);
  self.bag_item=tapItem;
  self.item=self.bag_item:clone();
  self.itemData=self.item:getItemData();

  --查看玩家
  self.lookUpEquipmentData=lookUpEquipmentData;
  local equipData = self.equipmentInfo:getEquipInfoByHeroIDAndItemID(self.itemData.GeneralId,self.itemData.ItemId);
  self.starLevel = 1;
  self.zhanli = 0;
  self.strengthenLevel = 0;
  self.propertyArray = {};
  self.extraPropertyArray = {};
  if self.lookUpEquipmentData then
    self.starLevel = self.lookUpEquipmentData.StarLevel;
    self.zhanli = self.lookUpEquipmentData.Zhanli;
    self.strengthenLevel = self.lookUpEquipmentData.StrengthenLevel;
    self.propertyArray = self.lookUpEquipmentData.PropertyArray;
    self.extraPropertyArray = lookUpEquipmentData.ExtraPropertyArray;
  elseif equipData then
    self.starLevel = equipData.StarLevel;
    self.zhanli = 0;
    self.strengthenLevel = equipData.StrengthenLevel;
    self.propertyArray = equipData.PropertyArray;
    self.extraPropertyArray = equipData.ExtraPropertyArray;
  elseif self.itemData.StrengthenLevel then
    self.strengthenLevel = self.itemData.StrengthenLevel;
  end

  local function getSellSilver()
    local strengthenLevel = self.strengthenLevel;
    local silver = 0;
    -- while 0 < strengthenLevel do
    --   silver = analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLevel,"minShoereturn") + silver;
    --   strengthenLevel = -1 + strengthenLevel;
    -- end
    silver = analysis("Zhuangbei_Zhuangbeiqianghua",strengthenLevel,"minShoereturn") + silver;
    silver = math.floor(silver*analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"level")/40) + analysis("Daoju_Daojubiao",self.itemData.ItemId,"price");
    return 1000000>silver and silver or (math.floor(silver/10000) .. "万");
  end

  --item
  local grid=armature_d:getChildByName("common_grid");
  local pos=convertBone2LB(grid);--grid:getPosition();
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  if itemType == BagItemType.equipeItem or itemType == BagItemType.putOffEquipeItem or BagItemType.openEquipe then
    pos.x = pos.x;
    pos.y = pos.y;
  end;
  self.item:setPosition(pos);
  self:addChild(self.item);
  
  --bag_item_name
  local text_data=armature:getBone("bag_item_name").textData;
  local name=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
  local quality=analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"quality");
  -- local level=self.strengthenLevel;
  -- if 0==level then
  --   level="";
  -- else
  --   level="+" .. level;
  -- end
  local level="";
  local text='<content><font color="' .. getColorByQuality(quality,true) .. '">' .. name .. '</font><font color="#FFFFFF"> ' .. level .. '</font></content>';
  local bag_item_name=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self:addChild(bag_item_name);

  if 0 < self.strengthenLevel then
    text_data=armature:getBone("bag_strengthen_level").textData;
    text="+" .. self.strengthenLevel;
    local bag_strengthen_level=createTextFieldWithTextData(text_data,text);
    bag_strengthen_level:setPositionX(20 + bag_item_name:getContentSize().width);
    self:addChild(bag_strengthen_level);
  end

  --bag_item_equiped_descb
  --if 1==self.item:getItemData().IsUsing then
    -- text_data=armature:getBone("bag_item_equiped_descb").textData;
    -- local bag_item_equiped_descb=createTextFieldWithTextData(text_data,"[已装备]");
    -- self:addChild(bag_item_equiped_descb);
  --end
  
  --bag_item_mark
  text_data=armature:getBone("bag_item_mark").textData;

  local prop_name = "";
  local prop_value = 0;
  local prop_id = 0;
  local excel_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"attribute");
  if "" == excel_data then
    for k,v in pairs(self.propertyArray) do
      if 0 ~= v.Type then
        prop_name=analysis("Shuxing_Shuju",tonumber(v.Type),"name");
        prop_id = v.Type;
        break;
      end
    end
  else
    excel_data = StringUtils:lua_string_split(excel_data,",");
    prop_name=analysis("Shuxing_Shuju",tonumber(excel_data[1]),"name");
    prop_id = tonumber(excel_data[1]);
  end

  self.strengthenValue = self.equipmentInfo:getEquipPropValueAllPlayer({GeneralId = self.itemData.GeneralId, ItemId = self.itemData.ItemId, StrengthenLevel = self.strengthenLevel, PropertyArray = self.propertyArray},prop_id);
  local bag_item_mark=createTextFieldWithTextData(text_data,prop_name .. ": " .. self.strengthenValue);
  self:addChild(bag_item_mark);
  if 2 == math.floor(self.itemData.ItemId/1000000) or 6 == math.floor(self.itemData.ItemId/1000000) then
    bag_item_mark:setVisible(false);
  end
  
  text_data=armature:getBone("bag_item_prop_increase_descb").textData;
  self.bag_item_prop_increase_descb=createTextFieldWithTextData(text_data,"");
  self:addChild(self.bag_item_prop_increase_descb);
  -- local _prop_increase = getPropDescb();
  -- if 0 < _prop_increase then
  --   --bag_item_prop_increase_descb
  --   text_data=armature:getBone("bag_item_prop_increase_descb").textData;
  --   local bag_item_prop_increase_descb=createTextFieldWithTextData(text_data,_prop_increase);
  --   self:addChild(bag_item_prop_increase_descb);
  -- else
  --   armature_d:getChildByName("common_image_increase"):setVisible(false);
  -- end
  armature_d:getChildByName("common_image_increase"):setVisible(false);
  armature_d:getChildByName("common_image_decrease"):setVisible(false);
  
  self:addPropScroll(self.item,armature);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
  --text=text .. "，出售可得" .. getSellSilver() .. "银两";
  local bag_item_specification=createTextFieldWithTextData(text_data,"说明：" .. text);
  self:addChild(bag_item_specification);

  if showButton then
    if itemType == BagItemType.equipeItem then
        --装备
        text="装备";
        equipButton=CommonButton.new();
        equipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --equipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
        equipButton:initializeBMText(text,"anniutuzi");
        equipButton:setPosition(equip_pos);
        equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
        self:addChild(equipButton);
    elseif itemType == BagItemType.putOffEquipeItem then
        putOffEquipButton=CommonButton.new();
        putOffEquipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --putOffEquipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"卸下");
        putOffEquipButton:initializeBMText("卸下","anniutuzi");
        equip_pos.x = 40;
        putOffEquipButton:setPosition(equip_pos);
        putOffEquipButton:addEventListener(DisplayEvents.kTouchTap,self.onPutOnEquipButtonTap,self);
        self:addChild(putOffEquipButton);      

        equipButton=CommonButton.new();
        equipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --equipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"更换");
        equipButton:initializeBMText("替换","anniutuzi");
        equip_pos.x = 206;
        equipButton:setPosition(equip_pos);
        equipButton:addEventListener(DisplayEvents.kTouchTap,self.onOpenEquipButtonTap,self);
        self:addChild(equipButton);
    elseif itemType == BagItemType.OnHeroPro then
        -- local openFunctionProxy = Facade:getInstance():retrieveProxy(OpenFunctionProxy.name);
        -- local qianghua = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_23);
        -- local dazao = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_45);
        -- if qianghua and dazao then
        --   self:addBTN({{"强化",self.onQianghuaButtonTap,makePoint(40,equip_pos.y)},{"打造",self.onDazaoButtonTap,makePoint(206,equip_pos.y)}});
        -- elseif qianghua then
        --   self:addBTN({{"强化",self.onQianghuaButtonTap,makePoint(equip_pos.x,equip_pos.y)}});
        -- elseif dazao then
        --   self:addBTN({{"打造",self.onDazaoButtonTap,makePoint(equip_pos.x,equip_pos.y)}});
        -- end


        -- putOffEquipButton=CommonButton.new();
        -- putOffEquipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        -- --putOffEquipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"卸下");
        -- putOffEquipButton:initializeBMText("强化","anniutuzi");
        -- equip_pos.x = 40;
        -- putOffEquipButton:setPosition(equip_pos);
        -- putOffEquipButton:addEventListener(DisplayEvents.kTouchTap,self.onQianghuaButtonTap,self);
        -- self:addChild(putOffEquipButton);

        -- equipButton=CommonButton.new();
        -- equipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        -- --equipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"更换");
        -- equipButton:initializeBMText("打造","anniutuzi");
        -- equip_pos.x = 206;
        -- equipButton:setPosition(equip_pos);
        -- equipButton:addEventListener(DisplayEvents.kTouchTap,self.onDazaoButtonTap,self);
        -- self:addChild(equipButton);
    else
      if 0<self.item:getSellNum() and 0==self.item:getItemData().IsUsing then
        --出售
        text="出售";
        sellButton=CommonButton.new();
        sellButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --sellButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
        sellButton:initializeBMText(text,"anniutuzi");
        sellButton:setPosition(sell_pos);
        sellButton:addEventListener(DisplayEvents.kTouchTap,self.onSellButtonTap,self);
        self:addChild(sellButton);
      
        -- --装备
        -- text=1==self.itemData.IsUsing and "卸下" or "装备";
        -- equipButton=CommonButton.new();
        -- equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
        -- equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,text);
        -- equipButton:setPosition(equip_pos);
        -- equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
        -- self:addChild(equipButton);
      else
        -- --装备
        -- text=1==self.itemData.IsUsing and "卸下" or "装备";
        -- equipButton=CommonButton.new();
        -- equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
        -- equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,text);
        -- equipButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),equip_pos.y);
        -- equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
        -- self:addChild(equipButton);
      end
    end;

  end
  
  self.grid_over=skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_over");
  local size=self.bag_item:getChildAt(0):getContentSize();
  local over_size=self.grid_over:getContentSize();
  self.grid_over:setPositionXY((size.width-over_size.width)/2,(size.height-over_size.height)/2);
  self.bag_item.grid_over_layer:addChild(self.grid_over);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
	
	-- if nil~= showButton and not showButton then 
	-- 	self:removeChild(equipButton);
	-- 	equipButton = nil;
	-- 	self:removeChild(sellButton);
	-- 	sellButton = nil;
	-- 	item:removeChild(self.grid_over);
	-- 	self.grid_over = nil;
	-- 	-- armature_d:removeChild(armature_d:getChildByName("common_image_separator_1"));
	-- end	
end

function EquipDetailLayer:addBTN(tb)
  if 1 == table.getn(tb) then
    local text=tb[1][1];
    local button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON,nil,nil,true);
    --button:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
    button:initializeBMText(text,"anniutuzi");
    button:setPosition(tb[1][3]);
    button:addEventListener(DisplayEvents.kTouchTap,tb[1][2],self);
    self:addChild(button);
  elseif 2 == table.getn(tb) then
    local text=tb[1][1];
    local button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON,nil,nil,true);
    --button:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
    button:initializeBMText(text,"anniutuzi");
    button:setPosition(tb[1][3]);
    button:addEventListener(DisplayEvents.kTouchTap,tb[1][2],self);
    self:addChild(button);

    text=tb[2][1];
    button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON,nil,nil,true);
    --button:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
    button:initializeBMText(text,"anniutuzi");
    button:setPosition(tb[2][3]);
    button:addEventListener(DisplayEvents.kTouchTap,tb[2][2],self);
    self:addChild(button);
  end
end

--prop_scroll
function EquipDetailLayer:addPropScroll(tapItem, armature)
  --if 0 == self.strengthenLevel then return; end
  if 2 == math.floor(self.itemData.ItemId/1000000) or 6 == math.floor(self.itemData.ItemId/1000000) then
    
  else
    return;
  end

  -- local propArray={};
  -- for k,v in pairs(propArray) do
  --   print(k,v);
  -- end
  -- local props=table.getn(propArray);
  -- local count = 0;
  -- local excel_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"Additional1");
  -- if "" ~= excel_data then
  --   excel_data = StringUtils:stuff_string_split(excel_data);
  --   for k,v in pairs(excel_data) do
  --     table.insert(propArray, {ID = 0, PropertyKey = tonumber(v[1]), PropertyValue = tonumber(v[2])});
  --   end
  -- end

  -- while 4 > count do
  --   count = 1 + count;
  --   local id = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"Additional" .. count);
  --   if 0 == id then
  --     break;
  --   end
  --   table.insert(propArray, {ID = 0, PropertyKey = id, PropertyValue = analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"amount" .. count)});
  -- end
  -- for k,v in pairs(self.extraPropertyArray) do
  --   print("&&&&&&&&&&->");
  --   table.insert(propArray, v);
  -- end

  -- for k,v in pairs(propArray) do
  --   print("-+++",k,v.PropertyKey,v.PropertyValue);
  -- end

  
  --附加
  local prop_add_green_data=armature:getBone("bag_item_prop_add_green").textData;
  local prop_add_yellow_data=armature:getBone("bag_item_prop_add_yellow").textData;
  
  local prop_scroll=ListScrollViewLayer.new();
	prop_scroll:initLayer();

	prop_scroll:setPositionXY(prop_add_green_data.x,prop_add_green_data.y);
	prop_scroll:setViewSize(makeSize(prop_add_green_data.width,prop_add_green_data.height));
  prop_scroll:setContentSize(makeSize(prop_add_green_data.width,prop_add_green_data.height));
	prop_scroll:setItemSize(makeSize(prop_add_yellow_data.width,prop_add_yellow_data.height));
  
  prop_add_yellow_data.x=0;
  prop_add_yellow_data.y=0;

  -- local propArrayCopy={};
  -- for k,v in pairs(propArray) do
  --   local aa=0;
  --   for k_,v_ in pairs(propArrayCopy) do
  --     if v.Type==v_.Type then
  --       aa=1;
  --       v_.Value=v_.Value+v.Value;
  --       break;
  --     end
  --   end
  --   if 0==aa then
  --     if 0<v.Type and 0<v.Value then
  --       table.insert(propArrayCopy,copyTable(v));
  --     end
  --   end
  -- end
  -- local total_table = analysisTotalTable("Zhuangbei_Zhuangbeiqianghua");
  -- local level_table = {};
  -- count = 1;
  -- while total_table["key" .. count] do
  --   if table.getn(level_table) < total_table["key" .. count].jiHuo then
  --     table.insert(level_table, count);
  --   end
  --   count = 1 + count;
  -- end

  -- local a=0;
  -- local active_count = -1+analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");--analysis("Zhuangbei_Zhuangbeiqianghua",self.strengthenLevel,"jiHuo");
  -- while table.getn(propArray)>a do
  --   a=a+1;
  --   -- local level=level_table[a] and level_table[a] or level_table[table.getn(level_table)];
  --   -- local text="强化" .. level .. "级: " .. analysis("Shuxing_Shuju",propArray[a].PropertyKey,"name");
  --   --getColorStringByDaojuGrade(1+a) .. 
  --   local text=analysis("Shuxing_Shuju",propArray[a].PropertyKey,"name");
  --   if active_count < a then
  --     prop_add_yellow_data.color=13421772;
  --   else
  --     prop_add_yellow_data.color=65280;
  --   end

  --   local textField=createTextFieldWithTextData(prop_add_yellow_data,text .. " +" .. propArray[a].PropertyValue);
  --   textField.touchEnabled=false;
  --   prop_scroll:addItem(textField);
  -- end

  for k,v in pairs(self.propertyArray) do
    local text=analysis("Shuxing_Shuju",v.Type,"name");
    -- if active_count < a then
      -- prop_add_yellow_data.color=13421772;
    -- else
      -- prop_add_yellow_data.color=65280;
    -- end
    prop_add_yellow_data.color = 16765440;
    local textField=createTextFieldWithTextData(prop_add_yellow_data,text .. " +" .. v.Value);
    textField.touchEnabled=false;
    prop_scroll:addItem(textField);
  end


	
  --bug
	self:addChild(prop_scroll);
end

function EquipDetailLayer:onImgItemTouchBegin(event)
  print(event);
end

--移除
function EquipDetailLayer:onCloseButtonTap(event)
  self.parent:removeItemTap();
end

function EquipDetailLayer:onPutOnEquipButtonTap(event)
  self:dispatchEvent(Event.new("PutOnEquip",data,self));
end;

function EquipDetailLayer:onOpenEquipButtonTap(event)
  self:dispatchEvent(Event.new("OpenEquip",data,self));  
end;


--装备
function EquipDetailLayer:onEquipButtonTap(event)
  -- print("lalalalllllllllllllllllllllllllllllllllllllllllll");
  -- print("装备",self.parent.userProxy:getUserID(),self.itemData.UserItemId);
  
  
  self:dispatchEvent(Event.new("onEquip",data,self));

  -- local occupation=analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"occupation");
  -- local lv=analysis("Zhuangbei_Zhuangbeipeizhibiao",self.itemData.ItemId,"lv");
  -- if occupation==self.parent.userProxy:getCareer() or 5==occupation then

  --   if lv<=self.parent.generalListProxy:getLevel() then
  --     local data={GeneralId=self.parent.userProxy:getUserID(),
  --             UserEquipmentId=self.itemData.UserItemId,
  --             Place=0,
  --             BooleanValue=1==self.itemData.IsUsing and 0 or 1};
  --     if self.parent.bagProxy:getBagIsFull(self.parent.itemUseQueueProxy) and 0==data.BooleanValue then
  --       sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
  --     else
  --       self.parent:dispatchEvent(Event.new("avatarEquipOnOff",data,self.parent));
  --     end
  --   else
  --     --[[local a=CommonPopup.new();
  --     a:initialize("等级不够喔!",nil,nil,nil,nil,nil,true);
  --     self.parent:addChild(a);]]
  --     sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_13));
  --   end

  -- else
  --     --[[local a=CommonPopup.new();
  --     a:initialize("职业不符哦!",nil,nil,nil,nil,nil,true);
  --     self.parent:addChild(a);]]
  --     sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_14));
  -- end
  
  -- self:onCloseButtonTap(event);
end

--出售
function EquipDetailLayer:onSellButtonTap(event)
  if self.equipmentInfo:hasGem(self.itemData.UserItemId) then
  	local c=CommonPopup.new();
    c:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_83),self,self.sell,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_83),nil,true,CommonPopupCloseButtonPram.DEFAULT);
    self.parent.parent.parent:addChild(c);
    return;
  elseif 3 < analysis("Daoju_Daojubiao",self.itemData.ItemId,"color") then
    local a=CommonPopup.new();
    a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_16),self,self.sell,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_16),nil,true,CommonPopupCloseButtonPram.DEFAULT);
    self.parent.parent.parent:addChild(a);
    return;
  elseif 0<self.equipmentInfo:getStrengthLevel(self.itemData.UserItemId) then --0<self.equipmentInfo:getStarLevel(self.itemData.UserItemId) or 
    local b=CommonPopup.new();
    b:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_72),self,self.sell,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_72),nil,true,CommonPopupCloseButtonPram.DEFAULT);
    self.parent.parent.parent:addChild(b);
    return;
  end
  self:sell();
end

function EquipDetailLayer:sell()
  self.parent:dispatchEvent(Event.new("bagItemSell",{UserItemId=self.itemData.UserItemId,Count=1},self.parent));
  self:onCloseButtonTap(event);
end

function EquipDetailLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end

function EquipDetailLayer:compareStrengthenValue(strengthenValue)
  local v = self.strengthenValue - strengthenValue;
  self.bag_item_prop_increase_descb:setString(math.abs(v));
  self.bag_item_prop_increase_descb:setVisible(0 ~= v);
  self.armature4dispose.display:getChildByName("common_image_increase"):setVisible(0 < v);
  self.armature4dispose.display:getChildByName("common_image_decrease"):setVisible(0 > v);
end

function EquipDetailLayer:onQianghuaButtonTap(event)
  if self.callBack then
    self.callBack();
  end
  Facade.getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_STRENGTHEN,{GeneralId=self.itemData.GeneralId,ItemId=self.itemData.ItemId,TAB=1}));
end

function EquipDetailLayer:onDazaoButtonTap(event)
  if self.callBack then
    self.callBack();
  end
  Facade.getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_STRENGTHEN,{GeneralId=self.itemData.GeneralId,ItemId=self.itemData.ItemId,TAB=2}));
end

function EquipDetailLayer:closeUI(event)
  if self.callBack then
    self.callBack();
  end
end