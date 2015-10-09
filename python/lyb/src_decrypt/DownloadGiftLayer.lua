--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-5-2

  yanchuan.xie@happyelements.com
]]

require "main.view.activity.ui.DownloadGiftScrollItem";

DownloadGiftLayer=class(TouchLayer);

function DownloadGiftLayer:ctor()
  self.class=DownloadGiftLayer;
end

function DownloadGiftLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  DownloadGiftLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function DownloadGiftLayer:initialize(skeleton, activityProxy, generalListProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;
  self.const_scroll_item_num=4;
  self.scroll_items={};
  self.scroll_item_select=nil;
  
  --骨骼
  local armature=skeleton:buildArmature("download_gift_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  self.scroll_item_size=makeSize(705,130);
  self.scroll_item_pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();

  local text="下载就有元宝可领呢！到达等级没有下载将会无法游戏额.";
  local text_data=armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  --item
  self.scroll_item_layer=ListScrollViewLayer.new();
  self.scroll_item_layer:initLayer();
  self.scroll_item_layer:setPositionXY(self.scroll_item_pos.x,self.scroll_item_pos.y-self.const_scroll_item_num*self.scroll_item_size.height);
  self.scroll_item_layer:setViewSize(makeSize(self.scroll_item_size.width,
                                       -35+self.const_scroll_item_num*self.scroll_item_size.height));
  self.scroll_item_layer:setItemSize(self.scroll_item_size);
  self.armature:addChild(self.scroll_item_layer);
  self:refreshItemLayer();

  --self.parent_container:dispatchEvent(Event.new(ActivityNotifications.DOWNLOAD_GIFT_REQUEST_DATA,nil,self.parent_container));
  --initializeSmallLoading();
  self:refreshDownloadGift();
end

--移除
function DownloadGiftLayer:onCloseButtonTap(event)
  
end

function DownloadGiftLayer:refreshDownloadGift()
  uninitializeSmallLoading();
  for k,v in pairs(self.scroll_items) do
    v:refresh();
  end
end

function DownloadGiftLayer:refreshItemLayer()
  local a=1;
  while analysisHas("Huodongbiao_Xiazaijiangli",a) do
    local item=DownloadGiftScrollItem.new();
    item:initialize(self.skeleton,self.activityProxy,self.generalListProxy,self.parent_container,a);
    table.insert(self.scroll_items,item);
    self.scroll_item_layer:addItem(item);

    a=1+a;
  end
end