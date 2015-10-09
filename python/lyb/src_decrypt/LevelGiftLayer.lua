--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-5-2

  yanchuan.xie@happyelements.com
]]

require "main.view.activity.ui.LevelGiftScrollItem";

LevelGiftLayer=class(TouchLayer);

function LevelGiftLayer:ctor()
  self.class=LevelGiftLayer;
end

function LevelGiftLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  LevelGiftLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function LevelGiftLayer:initialize(skeleton, activityProxy, generalListProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;
  self.const_scroll_item_num=4.2;
  self.scroll_items={};
  self.scroll_item_select=nil;
  
  --骨骼
  local armature=skeleton:buildArmature("level_gift_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  -- self.armature:removeChildAt(1);
  self:addChild(self.armature);


  self.scroll_item_size=makeSize(705,130);
  self.scroll_item_pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();

  self.parent_container:dispatchEvent(Event.new(ActivityNotifications.LEVEL_GIFT_REQUEST_DATA,nil,self.parent_container));
  initializeSmallLoading();
end

function LevelGiftLayer:initializeScrollItemLayer()
  if not self.scroll_item_layer then
    --item
    self.scroll_item_layer=ListScrollViewLayer.new();
    self.scroll_item_layer:initLayer();
    self.scroll_item_layer:setPositionXY(self.scroll_item_pos.x,self.scroll_item_pos.y-self.const_scroll_item_num*self.scroll_item_size.height);
    self.scroll_item_layer:setViewSize(makeSize(self.scroll_item_size.width,
                                       self.const_scroll_item_num*self.scroll_item_size.height));
    self.scroll_item_layer:setItemSize(self.scroll_item_size);
    self.armature:addChild(self.scroll_item_layer);
    self:refreshItemLayer();
  end
end

--移除
function LevelGiftLayer:onCloseButtonTap(event)
  
end

function LevelGiftLayer:refreshLevelGift()
  uninitializeSmallLoading();
  self:initializeScrollItemLayer();
  for k,v in pairs(self.scroll_items) do
    v:refresh();
  end
end

function LevelGiftLayer:refreshLevelGift4Fetched(level)
  for k,v in pairs(self.scroll_items) do
    if level==v:getLevel() then
      self.scroll_item_layer:removeItemAt(-1+k,true);
      table.remove(self.scroll_items,k);
      break;
    end
  end
end

function LevelGiftLayer:refreshItemLayer()
  local a=1;
  while analysisHas("Huodongbiao_Dengjilibao",a) do
    local lv=analysis("Huodongbiao_Dengjilibao",a,"lv");
    if not self.activityProxy:hasLevelGiftData(lv) then
      local item=LevelGiftScrollItem.new();
      item:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self.parent_container,a);
      table.insert(self.scroll_items,item);
      self.scroll_item_layer:addItem(item);
    end

    a=1+a;
  end
end