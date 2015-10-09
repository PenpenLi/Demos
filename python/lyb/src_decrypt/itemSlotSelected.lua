require "core.controls.page.CommonSlot";

local itemSlotSelected = nil;
local itemSlotSelectedID = nil;

StrengthenItemSlot=class(CommonSlot);

function StrengthenItemSlot:ctor()
  self.class=StrengthenItemSlot;
end

function StrengthenItemSlot:dispose()
  self:removeAllEventListeners();
  StrengthenItemSlot.superclass.dispose(self);
end

function StrengthenItemSlot:initialize(context, isHeroBag)
	self.context = context;
  self.isHeroBag = isHeroBag;
	self.skeleton = self.context.skeleton;
  self.bagItem = nil;

	self:initLayer();
  self:addChild(self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid"));
  self:addEventListener(DisplayEvents.kTouchBegin,self.onItemBegin,self);
  self:addEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
end

function StrengthenItemSlot:refresh()
  
end

function StrengthenItemSlot:onItemBegin(event)
  self.beginX = event.globalPosition.x;
end

function StrengthenItemSlot:onItemEnd(event)
  log(self.id);
  if not event then

  else
    self.endX = event.globalPosition.x;
    if not self.beginX or math.abs(self.beginX - self.endX) > 10 then
      return;
    end
  end

  if not self.bagItem then
    return;
  end

  if itemSlotSelected then
    itemSlotSelected:setSelected(false);
  end
  itemSlotSelected = self;
  itemSlotSelectedID = self.id;
  itemSlotSelected:setSelected(true);
  self.context:onBagItemTap(event, self.bagItem);
end

function StrengthenItemSlot:onItemMove(event)
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onItemMove,self);
  self:removeEventListener(DisplayEvents.kTouchOut,self.onItemOut,self);
end

function StrengthenItemSlot:onItemOut(event)
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onItemMove,self);
  self:removeEventListener(DisplayEvents.kTouchOut,self.onItemOut,self);
end

function StrengthenItemSlot:getID()
  return self.id;
end

function StrengthenItemSlot:getBagItem()
  return self.bagItem;
end

function StrengthenItemSlot:setSlotData(id)
  self.id = id;

  if self.bagItem then
    self:removeChild(self.bagItem);
    self.bagItem = nil;
  end
  self:setSelected(false);

  if self.isHeroBag and not self.leixing_img then
    self.leixing_img = self.skeleton:getCommonBoneTextureDisplay("commonImages/common_tfImg" .. self.id);
    self.leixing_img:setPositionXY(8,34);
    self:addChild(self.leixing_img);
  end
  local data = self.context.bagItemDatas4BagList[self.id];
  if data then
    data = copyTable(data);
    self.bagItem=BagItem.new();
    self.bagItem:initialize(data,false,self.context.bagProxy);
    self.bagItem:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    self:addChild(self.bagItem);
  end

  if itemSlotSelected and itemSlotSelectedID == self.id then
    self:setSelected(true);
  end
  if not self.context.bagItemSelected then
    self:onItemEnd();
  end
end

function StrengthenItemSlot:setSelected(bool)
  if bool then
    self.grid_over = self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_over");
    self.grid_over:setPositionXY(-3,-2);
    self:addChild(self.grid_over);
  else
    if self.grid_over and not self.grid_over.isDisposed then
      self:removeChild(self.grid_over);
      self.grid_over = nil;
    end
  end
end

function StrengthenItemSlot:cleanCache()
  itemSlotSelected = nil;
  itemSlotSelectedID = nil;
end