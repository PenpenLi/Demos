require "core.controls.page.CommonSlot";

BagItemSlot=class(CommonSlot);

function BagItemSlot:ctor()
  self.class=BagItemSlot;
end

function BagItemSlot:dispose()
  self:removeAllEventListeners();
  BagItemSlot.superclass.dispose(self);
end

function BagItemSlot:initialize(context, tab_num)
	self.context = context;
  self.tab_num = tab_num;
	self.skeleton = self.context.skeleton;
  self.bagItem = nil;
  table.insert(self.context.bagLayer.bagItemSlots[self.tab_num], self);

	self:initLayer();
  self:addChild(self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid"));
  self:addEventListener(DisplayEvents.kTouchBegin,self.onItemBegin,self);
  self:addEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
end

function BagItemSlot:refresh()
  
end

function BagItemSlot:onItemBegin(event)
  self.beginX = event.globalPosition.x;
end

function BagItemSlot:onItemEnd(event)
  log(self.id);
  self.endX = event.globalPosition.x;
  if self.beginX and math.abs(self.beginX - self.endX) < 10 then
    self.context.bagLayer:onTouchLayerTap(self, self.tab_num);
  end
end

function BagItemSlot:onItemOut(event)
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onItemEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onItemMove,self);
  self:removeEventListener(DisplayEvents.kTouchOut,self.onItemOut,self);
end

function BagItemSlot:getID()
  return self.id;
end

function BagItemSlot:getBagItem()
  return self.bagItem;
end

function BagItemSlot:getLock()
  return self.lock;
end

function BagItemSlot:addGridOver(grid_over)
  self:removeGridOver();
  self.grid_over = grid_over;
  self:addChild(self.grid_over);
end

function BagItemSlot:removeGridOver()
  if self.grid_over then
    self:removeChild(self.grid_over);
    self.grid_over = nil;
  end
end

function BagItemSlot:getGridOver()
  return self.grid_over;
end

function BagItemSlot:setSlotData(id)
  self.id = id;

  -- if self.context.itemUseQueueProxy:getPlaceOpenedCount() < self.id and not self.lock then
  --   self.lock = self.skeleton:getCommonBoneTextureDisplay("commonImages/common_black_lock");
  --   self.lock:setPositionXY(36,33);
  --   self:addChild(self.lock);
  -- else
  --   self:removeChild(self.lock);
  --   self.lock = nil;
  -- end

  if self.bagItem then
    self:removeChild(self.bagItem);
    self.bagItem = nil;
  end
  self:removeGridOver();
  
  local data = self.context.bagProxy:getPageViewData(self.tab_num, self.id);
  if data then
    -- print(">>>>>>>>>>>>>>>>",self.tab_num,self.id,data,data.ItemId,data.Place);
  end
  if data then
    data = copyTable(data);
    self.bagItem=BagItem.new();
    self.bagItem:initialize(data,true,self.context.bagProxy);
    self.bagItem:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    self:addChild(self.bagItem);

    for k,v in pairs(self.context.bagLayer.inBatchSellItemDatas) do
      if data.UserItemId == v.UserItemId then
        self.context.bagLayer:addGridOver(self.tab_num,self.id);
        break;
      end
    end
  end
end