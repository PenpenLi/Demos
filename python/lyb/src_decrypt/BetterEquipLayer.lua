require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

BetterEquipLayer=class(Layer);

function BetterEquipLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BetterEquipLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function BetterEquipLayer:initialize(skeleton, itemData, context, onEquip)
  self:initLayer();
  self.skeleton=skeleton;
  self.itemData=itemData;
  self.context=context;
  self.onEquip=onEquip;
  self.const_pos=makePoint(0,25);
  
  local armature=skeleton:buildArmature("better_equip");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:setPositionXY(-self:getGroupBounds().size.width,self.const_pos.y);

  --item
  local grid=self.armature:getChildByName("common_copy_grid");
  local pos=convertBone2LB(grid);
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  self.item=BagItem.new();
  self.item:initialize(self.itemData);
  self.item:setPosition(pos);
  self.armature:addChild(self.item);

  local better_descb=createTextFieldWithTextData(armature:getBone("better_descb").textData,"得到了更好的新装备哟~");
  self:addChild(better_descb);

  --common_copy_grid
  local text_data=armature:getBone("common_copy_grid").textData;
  local text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
  local color=analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");
  local bag_item_name=createTextFieldWithQualityID(color,text_data,text);
  self:addChild(bag_item_name);

  --装备
  local equipButton=self.armature:getChildByName("common_copy_blueround_button");
  local equip_pos=convertBone2LB4Button(equipButton);
  self.armature:removeChild(equipButton);

  equipButton=CommonButton.new();
  equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"装备");
  equipButton:setPosition(equip_pos);
  equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
  self.armature:addChild(equipButton);

  local moveTo=CCMoveTo:create(0.3,self.const_pos);
  local easeOut=CCEaseIn:create(moveTo,0.3);
  self:runAction(easeOut);
end

--移除
function BetterEquipLayer:onCloseButtonTap(event)
  BetterEquipManager:pop(self);
  self.parent:removeChild(self);
end

--装备
function BetterEquipLayer:onEquipButtonTap(event)
  self.onEquip(self.context,self.itemData);
  self:onCloseButtonTap(event);
end

function BetterEquipLayer:getItemData()
  return self.itemData;
end