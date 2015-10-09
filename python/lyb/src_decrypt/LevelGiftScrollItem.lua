--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.BagItem";
require "core.utils.CommonUtil";

LevelGiftScrollItem=class(TouchLayer);

function LevelGiftScrollItem:ctor()
  self.class=LevelGiftScrollItem;
end

function LevelGiftScrollItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	LevelGiftScrollItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function LevelGiftScrollItem:initialize(skeleton, activityProxy, generalListProxy, parent_container, id)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;
  self.id=id;
  self.lv=analysis("Huodongbiao_Dengjilibao",self.id,"lv");
  self.gift=analysis("Huodongbiao_Dengjilibao",self.id,"gift");
  self.gift=StringUtils:stuff_string_split(self.gift);
  self.bag_count=0;
  
  
  --骨骼
  local armature=skeleton:buildArmature("level_gift_scroll_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local image=self.armature:getChildByName("common_copy_grid");
  self.image_pos=convertBone2LB(image);
  self.armature:removeChild(image);
  local image_1=self.armature:getChildByName("common_copy_grid_1");
  self.image_1_pos=convertBone2LB(image_1);
  self.armature:removeChild(image_1);
  self.image_skew_x=self.image_1_pos.x-self.image_pos.x;

  self.box=self.armature:getChildByName("common_copy_box_3_normal");
  self.box_pos=convertBone2LB(self.box);
  self.armature:removeChild(self.box);

  self.img=self.armature:getChildByName("img");
  self.img_text_data=armature:findChildArmature("img"):getBone("common_copy_blueround_button").textData;
  self.img_pos=convertBone2LB4Button(self.img);
  self.armature:removeChild(self.img);

  --common_copy_box
  local text=self.lv .. "级大礼包";
  local text_data=armature:getBone("common_copy_box_3_normal").textData;
  self.scroll_item_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.scroll_item_descb);

  local items=self:getItems();
  for k,v in pairs(items) do
    self.armature:addChild(v);
  end
end

--领取
function LevelGiftScrollItem:onFetchTap(event)
  if self.parent_container:getIsBagFull(self.bag_count) then
    return;
  end
  self.img:removeEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self);
  self.parent_container:dispatchEvent(Event.new(ActivityNotifications.LEVEL_GIFT_GET_BONUS,{Level=self.lv},self.parent_container));
end

function LevelGiftScrollItem:onItemTap(event)
  self.parent_container:popTip(event.target:getChildAt(0):getItemData().ItemId,event.target:getChildAt(0):getItemData().Count,event.globalPosition);
end

function LevelGiftScrollItem:refresh()
  local a=self.activityProxy:hasLevelGiftData(self.lv);
  self:remove();
  if self.generalListProxy:getLevel()>=self.lv then
    if a then
      self.box=self.skeleton:getCommonBoneTextureDisplay("common_copy_box_3_down");
      self.box:setPosition(self.box_pos);
      self.armature:addChild(self.box);
      self.img=self.skeleton:getCommonBoneTextureDisplay("common_yiwancheng");
      self.img:setPosition(self.img_pos);
      self.img:setPositionY(-7+self.img:getPositionY());
      self.armature:addChild(self.img);
    else
      self.box=self.skeleton:getCommonBoneTextureDisplay("common_box_3_normal");
      self.box:setPosition(self.box_pos);
      self.armature:addChild(self.box);
      self.img=CommonButton.new();
      self.img:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
      self.img:initializeText(self.img_text_data,"领取");
      self.img:setPosition(self.img_pos);
      self.img:addEventListener(DisplayEvents.kTouchTap,self.onFetchTap,self);
      self.armature:addChild(self.img);
    end
  else
    self.box=self.skeleton:getCommonBoneTextureDisplay("common_box_3_normal");
    self.box:setPosition(self.box_pos);
    self.armature:addChild(self.box);
    self.img=self.skeleton:getCommonBoneTextureDisplay("common_nulizhong");
    self.img:setPosition(self.img_pos);
    self.img:setPositionY(-7+self.img:getPositionY());
    self.armature:addChild(self.img);
  end
end

function LevelGiftScrollItem:remove()
  self.armature:removeChild(self.box);
  self.armature:removeChild(self.img);
end

function LevelGiftScrollItem:getID()
  return self.id;
end

function LevelGiftScrollItem:getLevel()
  return self.lv;
end

function LevelGiftScrollItem:getItems()
  local items={};
  for k,v in pairs(self.gift) do
    local a={};
    a.UserItemId=0;
    a.ItemId=tonumber(v[1]);
    a.Count=tonumber(v[2]);
    a.IsBanding=0;
    a.IsUsing=0;
    a.Place=0;

    if 1000000<a.ItemId then
      self.bag_count=math.ceil(a.Count/analysis("Daoju_Daojubiao",a.ItemId,"overlap"))+self.bag_count;
    end

    local b=BagItem.new();
    b:initialize(a);
    b:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    local c=self.skeleton:getCommonBoneTextureDisplay("common_grid");
    c:setPositionXY(self.image_skew_x*(-1+k)+self.image_pos.x,self.image_pos.y);
    c:addChild(b);
    c:addEventListener(DisplayEvents.kTouchTap,self.onItemTap,self);
    table.insert(items,c);
  end
  return items;
end