--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-25

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.EquipStar";
require "core.events.DisplayEvent";
--require "core.controls.CommonButton";
require "core.controls.ListScrollViewLayer";
require "core.utils.CommonUtil";

EquipTip=class(Layer);

function EquipTip:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	EquipTip.superclass.dispose(self);
  self.armature:dispose()
  BitmapCacher:removeUnused();
end

function EquipTip:getItemData()
  return self.itemData;
end

--intialize UI
function EquipTip:initialize(skeleton, userProxy, generalListProxy)
  self:initLayer();
  self.userProxy = userProxy;
  self.generalListProxy=generalListProxy;
  
  local armature=skeleton:buildArmature("equip_detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d=armature_d
  
  self:addChild(armature_d);
   

  local closeButton=armature_d:getChildByName("common_blue_button");
  local buttonPos=convertBone2LB4Button(closeButton);--equipButton:getPosition();
  armature_d:removeChild(closeButton);  

  armature_d:removeChild(armature_d:getChildByName("common_blue_button2"));

  closeButton=CommonButton.new();
  closeButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --sellButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,text);
  closeButton:initializeBMText("购买","anniutuzi");
  closeButton:setPosition(buttonPos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self.closeButton = closeButton
  self:addChild(closeButton);

  armature_d:removeChild(armature_d:getChildByName("common_image_increase"));
  armature_d:removeChild(armature_d:getChildByName("common_image_decrease"));
  --item
  local grid=armature_d:getChildByName("common_grid");
  self.imagePos=convertBone2LB(grid);--;grid:getPosition();
  self.imagePos.x = self.imagePos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  self.imagePos.y = self.imagePos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  --名字
  self.bag_item_nametext_data=armature:getBone("bag_item_name").textData;
  --属性
  local prop_add_green_data=armature:getBone("bag_item_prop_add_green").textData;
  self.bisic_prop1 = createTextFieldWithTextData(prop_add_green_data,"");
  self:addChild(self.bisic_prop1);
  
  
  local prop_add_yellow_data=armature:getBone("bag_item_prop_add_yellow").textData;
  self.bisic_prop2 = createTextFieldWithTextData(prop_add_yellow_data,"");
  self:addChild(self.bisic_prop2);
  
  --self:addPropScroll(skeleton,equipmentInfo,tapItem,armature);
  
  --bag_item_specification
  separator=armature_d:getChildByName("common_image_separator_2")
  separator:setPositionXY(separator:getPosition().x,separator:getPosition().y+30)
  self:addChild(separator);

  text_data=armature:getBone("bag_item_specification").textData;
  self.bag_item_specification=createTextFieldWithTextData(text_data,"说明：");
  self.bag_item_specification:setPositionXY(self.bag_item_specification:getPosition().x,self.bag_item_specification:getPosition().y+30)
  self:addChild(self.bag_item_specification);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  
  local panel_size =  armature_d:getGroupBounds(false).size--skeleton:getBoneTextureDisplay("strongPointInfo_bg"):getContentSize();
  self.sprite:setContentSize(CCSizeMake(panel_size.width, panel_size.height));
end

function EquipTip:setEquipTip(item,callBack,showButton,count)
  if count==nil then
    count=1
  end
  self.item=item
  self.callBack=callBack
  local itemId=self.item.userItem.ItemId
  local itemPo = analysis("Daoju_Daojubiao", itemId);
  if self.bag_item_name and self:contains(self.bag_item_name) then
     self:removeChild(self.bag_item_name)
  end 
  
  local equipPo = analysis("Zhuangbei_Zhuangbeibiao", itemId);
  self.bag_item_name=createTextFieldWithQualityID(equipPo.quality, self.bag_item_nametext_data, itemPo.name);
  local quality=analysis("Zhuangbei_Zhuangbeipeizhibiao",itemId,"quality");
  self.bag_item_name:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(quality)));
  self:addChild(self.bag_item_name);

  --bag_item_equiped_descb
  if 1==self.item:getItemData().IsUsing then
    text_data=self.armature:getBone("bag_item_equiped_descb").textData;
    local bag_item_equiped_descb=createTextFieldWithTextData(text_data,"【已装备】");
    self:addChild(bag_item_equiped_descb);
  end
  
  --bag_item_mark

  text_data=self.armature:getBone("bag_item_mark").textData;
  local prop_name=analysis("Zhuangbei_Zhuangbeipeizhibiao",itemId,"attribute");
  prop_name=analysis("Shuxing_Shuju",prop_name,"name");
  local prop_value=analysis("Zhuangbei_Zhuangbeipeizhibiao",itemId,"amount");
  if not self.bag_item_mark then
    self.bag_item_mark=createTextFieldWithTextData(text_data,prop_name .. ": " .. prop_value);
    self:addChild(self.bag_item_mark);
  else
    self.bag_item_mark:setString(prop_name .. ": " .. prop_value);
  end


  -- --说明
  self.bag_item_specification:setString("说明：" .. itemPo["function"]);
  
  local artId = analysis("Daoju_Daojubiao", itemId, "art")
  local artPo = artData[artId]

 
  local grid=self.armature_d:getChildByName("common_grid");
  local pos=convertBone2LB(grid);--grid:getPosition();
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  if self.item_copy then
    self:removeChild(self.item_copy)
  end
  self.item_copy=self.item:clone()
  self.item_copy:setPosition(pos);
  self:addChild(self.item_copy);

  if showButton then
    self.closeButton:setVisible(true)
  else
    self.closeButton:setVisible(false)
    self.touchLayer = TouchLayer.new();
    self.touchLayer:initLayer();
    self:addChildAt(self.touchLayer, 0)

    local xPos = self:getPositionX();
    local yPos = self:getPositionY();
    print("xPos, yPos", xPos, yPos)
    self.touchLayer:setPositionXY(-xPos,-yPos)

    local mainSize = Director:sharedDirector():getWinSize();
    self.touchLayer.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
    self.touchLayer:addEventListener(DisplayEvents.kTouchTap,self.onTouchLayerTap,self);
  end

end
function EquipTip:onTouchLayerTap(event)
  self:dispatchEvent(Event.new("REMOVE_EQUIP_TIP", nil, self))
end

--移除
function EquipTip:onCloseButtonTap(event)
 self.callBack()
end

function EquipTip:closeUI(event)
  self:onTouchLayerTap(event);
end