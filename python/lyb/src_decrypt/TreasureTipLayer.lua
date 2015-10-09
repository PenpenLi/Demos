

require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

TreasureTipLayer=class(Layer);

function TreasureTipLayer:dispose()
  if self.grid_over.parent then
    self.grid_over.parent:removeChild(self.grid_over);
  end
  self:removeAllEventListeners();
  self:removeChildren();
	TreasureTipLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function TreasureTipLayer:getItemData()
  return self.itemData;
end

--intialize UI
function TreasureTipLayer:initialize(skeleton, tapItem, item, effectProxy)
  self:initLayer();
  
  local armature=skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  local armature_d=armature.display;
  self.effectProxy = effectProxy
  
  --出售
  local sellButton=armature_d:getChildByName("common_copy_blueround_button_1");
  local sell_pos=convertBone2LB4Button(sellButton);--equipButton:getPosition();
  armature_d:removeChild(sellButton);

  --使用
  local equipButton=armature_d:getChildByName("common_copy_blueround_button");
  local equip_pos=convertBone2LB4Button(equipButton);--equipButton:getPosition();
  armature_d:removeChild(equipButton);
  
  
  self:addChild(armature_d);
  self.item=tapItem;
  self.itemData=tapItem:getItemData();
  self.isPetEgg=BagConstConfig.USE_ID_11==self.item:getUseID();
  self.isSynthetic=self.item:getSyntheticable();
  --[[local bs="";
  if tapItem:isUsable() then
    if self.isPetEgg then
      bs="孵化";
    elseif self.isSynthetic then
      bs="合成";
    else
      bs="使用";
    end
  end]]

  if self.isSynthetic then
    self.syntheticItemID=analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
    self.min=analysis("Daoju_Hecheng",self.syntheticItemID,"need");
    self.min=StringUtils:stuff_string_split(self.min);
    self.min=self.min[1];
  end
  
  --item
  local grid=armature_d:getChildByName("common_copy_grid");
  local pos=convertBone2LB(grid);--;grid:getPosition();
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  self.item:setPosition(pos);
  self:addChild(self.item);
  
  
  --bag_item_name
  local text_data=armature:getBone("bag_item_name").textData;
  local text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
  local color=analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");
  local bag_item_name=createTextFieldWithQualityID(color,text_data,text);
  self:addChild(bag_item_name);
  
  --bag_item_category_name
  text_data=armature:getBone("bag_item_category_name").textData;
  local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
  self:addChild(bag_item_category_name);
  
  --bag_item_category_descb
  text_data=armature:getBone("bag_item_category_descb").textData;
  text=analysis("Daoju_Daojufenlei",self.item:getCategoryID(),"function");
  local bag_item_category_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_category_descb);
  
  --bag_item_overlay
  text_data=armature:getBone("bag_item_overlay").textData;
  local bag_item_overlay=createTextFieldWithTextData(text_data,"叠加");
  self:addChild(bag_item_overlay);
  
  --bag_item_overlay_descrb
  text_data=armature:getBone("bag_item_overlay_descrb").textData;
  text=item:getItemData().Count .. "/" .. analysis("Daoju_Daojubiao",self.itemData.ItemId,"overlap");
  if 0==text then
    text="不可叠加";
  end
  local bag_item_overlay_descrb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_overlay_descrb);
  
  --bag_item_output
  text_data=armature:getBone("bag_item_output").textData;
  local bag_item_output=createTextFieldWithTextData(text_data,"产出");
  self:addChild(bag_item_output);
  
  --bag_item_output_descb
  text_data=armature:getBone("bag_item_output_descb").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"origin");
  local bag_item_output_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_output_descb);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
  local bag_item_specification=createTextFieldWithTextData(text_data,"说明：" .. text);
  self:addChild(bag_item_specification);

  sellButton=CommonButton.new();
  sellButton:initialize("common_greenroundbutton_normal","common_greenroundbutton_down",CommonButtonTouchable.BUTTON);
  sellButton:setPosition(sell_pos);
  
  self:addChild(sellButton);

  if tapItem:isTreasure() then
      sellButton:initializeText(armature:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,"点化");
      sellButton:addEventListener(DisplayEvents.kTouchTap,self.onDhButtonTap,self);
  else
      sellButton:initializeText(armature:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,"出售");
      sellButton:addEventListener(DisplayEvents.kTouchTap,self.onSellButtonTap,self);
  end

  equipButton=CommonButton.new();
  equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"使用");
  --if tapItem:isTreasure() then
  equipButton:setPosition(equip_pos);
  --else
      --equipButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),equip_pos.y);
  --end
  equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
  self:addChild(equipButton);
  
  self.grid_over=skeleton:getCommonBoneTextureDisplay("common_grid_over");
  local size=item:getChildAt(0):getContentSize();
  local over_size=self.grid_over:getContentSize();
  self.grid_over:setPositionXY((size.width-over_size.width)/2,(size.height-over_size.height)/2);
  item:addChild(self.grid_over);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

--移除
function TreasureTipLayer:onCloseButtonTap(event)
  if self.parent then
    self.parent:removeItemTap();
  end
end

--使用
function TreasureTipLayer:onEquipButtonTap(event)
    if self.parent.bagProxy:getBagIsFull(self.parent.itemUseQueueProxy) then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
        return
    end
    local parameter3=analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
    local idTable = analysisByName("Juqing_Guanka","storyId",parameter3)
    local strongPointId = self:getScenarioId(idTable);
    local guideTable = {type = "TreasureTipLayer", eventValue = strongPointId, strongPointId = strongPointId, userItemId = self.itemData.UserItemId, eventType = GameConfig.TASK_EVENT_TYPE_1, Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=1,CurrencyType=0};
    self.parent:dispatchEvent(Event.new("Auto_Guide_Event", guideTable, self));
end

function TreasureTipLayer:getScenarioId(idTable)
    local tempTable = {}
    for k1,v1 in pairs(idTable) do
        if v1.scenariotype == 1 or v1.scenariotype == 5 or v1.scenariotype == 8 then
            table.insert(tempTable,v1)
        end
    end
    local len = #tempTable;
    local tempRandom = math.random(len)
    tempRandom = math.random(len)
    tempRandom = math.random(len)
    local strongPointId = tempTable[tempRandom].id
    if not self.parent.bagProxy:getStrongPointIdByUserItemID(self.itemData.UserItemId) then
        self.parent.bagProxy:setStrongPointIdByUserItemID(self.itemData.UserItemId,strongPointId)
        return strongPointId,userItemId;
    else
        return self.parent.bagProxy:getStrongPointIdByUserItemID(self.itemData.UserItemId)
    end
    
end

function TreasureTipLayer:onDhButtonTap(event)
    if self.parent.bagProxy:getBagIsFull(self.parent.itemUseQueueProxy) then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
        return
    end
    local textTable = {}
    textTable[1] = "确定";
    textTable[2] = "取消";
    local tips=CommonPopup.new();
    local contant = analysis("Xishuhuizong_Xishubiao",134,"constant");
    tips:initialize("是否花费"..contant.."元宝将这张藏宝图点化为高级藏宝图？",self,self.functionPanel,contant,nil,nil,nil,textTable);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(tips);
end

function TreasureTipLayer:functionPanel(needMoney)
    if needMoney then
        if needMoney > self.parent.userCurrencyProxy:getGold() then
            self.parent:dispatchEvent(Event.new("vip_recharge",nil,self));
            local rewardString = StringUtils:getString4Popup(PopupMessageConstConfig.ID_32);
            sharedTextAnimateReward():animateStartByString(rewardString);
            return
        end
    end
    local data={Place=self.itemData.Place};
    sendMessage(9,12,data);
    self:onCloseButtonTap(event);
end

--出售
function TreasureTipLayer:onSellButtonTap(event)
  if 3<analysis("Daoju_Daojubiao",self.itemData.ItemId,"color") then
    self:sell();
    return;
  end
  local a=CommonPopup.new();
  a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_16),self,self.sell,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_16));
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(a);
end

function TreasureTipLayer:onSynthetic()
  local data={Place=self.itemData.Place};
  self.parent:dispatchEvent(Event.new("bagPropSynthetic",data,self.parent));
end

function TreasureTipLayer:sell()
  if 1==self.item:getItemData().Count then
    self:sellConfirm({Count=1});
    self:onCloseButtonTap();
  else
    local batchUseUI=BatchUseUI.new();
    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=self.item:getItemData().Count},{"出售","取消"},self.sellConfirm,nil,2);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(batchUseUI);
  end
end

function TreasureTipLayer:sellConfirm(data)
  self.parent:dispatchEvent(Event.new("bagItemSell",{UserItemId=self.itemData.UserItemId,Count=data.Count},self.parent));
  self:onCloseButtonTap(event);
end

function TreasureTipLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end