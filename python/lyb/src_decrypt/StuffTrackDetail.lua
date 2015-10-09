--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-25

	yanchuan.xie@happyelements.com
]]

require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "main.view.bag.ui.bagPopup.BagItem";

StuffTrackDetail=class(Layer);

function StuffTrackDetail:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StuffTrackDetail.superclass.dispose(self);
  self.removeArmature:dispose()
end

function StuffTrackDetail:getItemData()
  return self.itemData;
end

--intialize UI
function StuffTrackDetail:initialize(skeleton, itemID, track, context, onTrack)
  self:initLayer();
  
  local armature=skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  local armature_d=armature.display;
  
  --出售
  local sellButton=armature_d:getChildByName("common_copy_blueround_button_1");
  local sell_pos=convertBone2LB4Button(sellButton);--equipButton:getPosition();
  armature_d:removeChild(sellButton);

  --使用
  local equipButton=armature_d:getChildByName("common_copy_blueround_button");
  local equip_pos=convertBone2LB4Button(equipButton);--equipButton:getPosition();
  armature_d:removeChild(equipButton);
  
  local layerColorBackGround=LayerColorBackGround:getBackGround();
  layerColorBackGround:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  layerColorBackGround:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  self:addChild(layerColorBackGround);

  local size=layerColorBackGround:getContentSize();
  local armature_d_size=armature_d:getGroupBounds().size;
  armature_d:setPositionXY(math.floor(size.width/2-armature_d_size.width/2),math.floor(size.height/2-armature_d_size.height/2));
  self:addChild(armature_d);
  self.item=BagItem.new();
  self.item:initialize({UserItemId=0,ItemId=itemID,Count=1,IsBanding=0,IsUsing=0,Place=0});
  self.itemData=self.item:getItemData();
  self.itemID=itemID;
  self.context=context;
  self.onTrack=onTrack;
  
  --item
  local grid=armature_d:getChildByName("common_copy_grid");
  local pos=convertBone2LB(grid);--;grid:getPosition();
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  self.item:setPosition(pos);
  armature_d:addChild(self.item);
  
  
  --bag_item_name
  local text_data=armature:getBone("bag_item_name").textData;
  local text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
  local color=analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");
  local bag_item_name=createTextFieldWithQualityID(color,text_data,text);
  armature_d:addChild(bag_item_name);
  
  --bag_item_category_name
  text_data=armature:getBone("bag_item_category_name").textData;
  local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
  armature_d:addChild(bag_item_category_name);
  
  --bag_item_category_descb
  text_data=armature:getBone("bag_item_category_descb").textData;
  text=analysis("Daoju_Daojufenlei",self.item:getCategoryID(),"function");
  local bag_item_category_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_item_category_descb);
  
  --bag_item_overlay
  text_data=armature:getBone("bag_item_overlay").textData;
  local bag_item_overlay=createTextFieldWithTextData(text_data,"叠加");
  armature_d:addChild(bag_item_overlay);
  
  --bag_item_overlay_descrb
  text_data=armature:getBone("bag_item_overlay_descrb").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"overlap");
  if 0==text then
    text="不可叠加";
  end
  local bag_item_overlay_descrb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_item_overlay_descrb);
  
  --bag_item_output
  text_data=armature:getBone("bag_item_output").textData;
  local bag_item_output=createTextFieldWithTextData(text_data,"产出");
  armature_d:addChild(bag_item_output);
  
  --bag_item_output_descb
  text_data=armature:getBone("bag_item_output_descb").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"origin");
  local bag_item_output_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_item_output_descb);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
  local bag_item_specification=createTextFieldWithTextData(text_data,"说明：" .. text);
  armature_d:addChild(bag_item_specification);
  
  if track then
    equipButton=CommonButton.new();
    equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"追踪");
    equipButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),equip_pos.y);
    equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
    armature_d:addChild(equipButton);
  end
end

--移除
function StuffTrackDetail:onSelfTap(event)
  self.parent:removeChild(self);
end

function StuffTrackDetail:onEquipButtonTap(event)
  self.onTrack(self.context,self.itemID);
end