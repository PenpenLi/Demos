--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RankListItem=class(TouchLayer);

function RankListItem:ctor()
  self.class=RankListItem;
end

function RankListItem:dispose()
  if self.scroll_item_layer and not self.scroll_item_layer.isDisposed then
    self.scroll_item_layer:dispose();
    self.scroll_item_layer=nil;
  end
  self:removeAllEventListeners();
  self:removeChildren();
	RankListItem.superclass.dispose(self);
  self.removeArmature:dispose();
  BitmapCacher:removeUnused();
end

function RankListItem:initialize(skeleton, rankListProxy, typeID, context, onTap, parent_container, container, isAchieved)
  self:initLayer();
  self.skeleton=skeleton;
  self.achievementProxy=achievementProxy;
  self.taskProxy=taskProxy;
  self.typeID=typeID;
  self.context=context;
  self.onTap=onTap;
  self.parent_container=parent_container;
  self.container=container;
  self.isAchieved=isAchieved;
  self.const_items=6;
  self.scroll_items={};
  self.scroll_item_layer=nil;
  
  --骨骼
  local armature=CommonSkeleton:buildArmature("common_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:changeWidthAndHeight(self.container.item_size.width,self.container.item_size.height);

  local text=analysis("Paixing_Paixingbang",self.typeID,"name");
  self.itemTextField=createTextFieldWithTextData(armature:getBone("common_copy_item_bg").textData,text);
  self.itemTextField.touchEnabled=false;
  self.itemTextField.touchChildren=false;
  self:addChild(self.itemTextField);

  self.item_over=self.armature:getChildByName("common_copy_item_over");
  self.item_over.touchEnabled=false;
  self.item_over.touchChildren=false;
  self.armature:removeChild(self.item_over,false);
  self.armature:addChildAt(self.item_over,1);
  self:select(false);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function RankListItem:onSelfTap(event)
  self.onTap(self.context,self);
end

function RankListItem:onCommonLayerTap(y,event)
  local a=y+self.const_items*(-1+self.scroll_item_layer:getCurrentPage());
  if self.scroll_items[a] then
    self.scroll_items[a]:onSelfTap(event);
  end
end

function RankListItem:refresh(rankArray)
  self:getScrollItemLayer();
  self.max_page=math.ceil(table.getn(rankArray)/self.const_items);
  self.scroll_item_layer:setContainerSize(makeSize(self.max_page*self.container.scroll_item_size.width,
                                                   self.const_items*self.container.scroll_item_size.height));
  self.scroll_item_layer:setMaxPage(self.max_page);
  local layer;
  for k,v in pairs(rankArray) do
    if 0==(-1+k)%self.const_items then
      layer=Layer.new();
      layer:initLayer();
      layer:setPositionX(math.floor((-1+k)/self.const_items*self.container.scroll_item_size.width));
      self.scroll_item_layer:addContent(layer);
    end
    local item=RankListScrollItem.new();
    v.Type=self.typeID;
    item:initialize(self.skeleton,self.rankListProxy,self.parent_container,v,self.container.scroll_item_size);
    item:setPositionY((-1-(-1+k)%self.const_items+self.const_items)*self.container.scroll_item_size.height);
    layer:addChild(item);
    table.insert(self.scroll_items,item);
  end
end

function RankListItem:select(boolean)
  self.item_over:setVisible(boolean);
end

function RankListItem:getScrollItemLayer()
  if nil==self.scroll_item_layer then
    self.scroll_item_layer=GalleryViewLayer.new();
    self.scroll_item_layer:initLayer();
    self.scroll_item_layer.touchEnabled=false;
    self.scroll_item_layer.touchChildren=false;
    self.scroll_item_layer:setTouchEnabled(false);
    self.scroll_item_layer:setViewSize(makeSize(self.container.scroll_item_size.width,
                                                self.const_items*self.container.scroll_item_size.height));
    self.scroll_item_layer:setDirection(kCCScrollViewDirectionHorizontal);
    self.scroll_item_layer:setPositionXY(self.container.scroll_item_pos.x,self.container.scroll_item_pos.y-self.const_items*self.container.scroll_item_size.height);
    local function refreshButton()
      self.context:refreshButton();
    end
    self.scroll_item_layer:addFlipPageCompleteHandler(refreshButton);
  end
  return self.scroll_item_layer;
end

function RankListItem:getUserRank()
  for k,v in pairs(self.scroll_items) do
    if ConstConfig.USER_NAME==v.rankData.ParamStr1 then
      return v.rankData.Ranking;
    end
  end
  return 0;
end

function RankListItem:getTypeID()
  return self.typeID;
end