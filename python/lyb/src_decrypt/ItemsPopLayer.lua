--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.utils.CommonUtil";
require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatContentItem";
require "core.controls.CommonScrollList";
require "main.view.bag.ui.bagPopup.BagItem";

ItemsPopLayer=class(Layer);

function ItemsPopLayer:ctor()
  self.class=ItemsPopLayer;
end

function ItemsPopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ItemsPopLayer.superclass.dispose(self);
end

function ItemsPopLayer:initialize(skeleton, context, onTap, bagProxy, equipmentInfoProxy)
  self:initLayer();
  self.const_grid_column=9;
  self.const_grid_row=2;
  self.const_grid_count=self.const_grid_column*self.const_grid_row;
  self.const_grid_skew_x=112;
  self.const_grid_skew_y=115;
  self.const_item_size=makeSize(106,106);
  self.const_pos=makePoint(27,114);
  self.const_equipIDs={1100,1101,1102,1103,1104,1105,1106};
  self.const_propIDs={1209};
  self.context=context;
  self.onTap=onTap;
  self.bagProxy=bagProxy;
  self.equipmentInfoProxy=equipmentInfoProxy;
  self:setPosition(self.const_pos);
end

function ItemsPopLayer:refreshItems()
  if self.scroll_item_layer then
    self:removeChild(self.scroll_item_layer);
    self.scroll_item_layer=nil;
  end
  self.scroll_item_layer=ListScrollViewLayer.new();
  self.scroll_item_layer:initLayer();
  self.scroll_item_layer:setViewSize(makeSize(-self.const_grid_skew_x+self.const_item_size.width+self.const_grid_skew_x*self.const_grid_column,
                        1-self.const_grid_skew_y+self.const_item_size.height+self.const_grid_skew_y*self.const_grid_row));
  self.scroll_item_layer:setItemSize(makeSize(-self.const_grid_skew_x+self.const_item_size.width+self.const_grid_skew_x*self.const_grid_column,
                        self.const_grid_skew_y));
  self:addChild(self.scroll_item_layer);

  function sf(a, b)
    local aq=analysis("Daoju_Daojubiao",a.ItemId,"color");
    local bq=analysis("Daoju_Daojubiao",b.ItemId,"color");
    if aq<bq then
      return true;
    elseif aq>bq then
      return false;
    end
    -- local az=self.equipmentInfoProxy:getZhanli(a.UserItemId);
    -- local bz=self.equipmentInfoProxy:getZhanli(b.UserItemId);
    -- if az>bz then
    --   return true;
    -- elseif az<bz then
    --   return false;
    -- end
    return a.ItemId > b.ItemId;
  end
  function sf_p(a, b)
    local aq=analysis("Daoju_Daojubiao",a.ItemId,"color");
    local bq=analysis("Daoju_Daojubiao",b.ItemId,"color");
    return aq<bq;
  end
  local data=self.equipmentInfoProxy:getData();--self.bagProxy:getData();
  -- local t={};
  -- local t_p={};
  -- for k,v in pairs(data) do
  --   -- local id=math.floor(v.ItemId/1000);
  --   -- if self.const_equipIDs[1]<=id and self.const_equipIDs[7]>=id then
  --   --   local itemData={UserItemId=v.UserItemId,ItemId=v.ItemId,Count=1,IsBanding=0,IsUsing=0,Place=0};
  --   --   table.insert(t,itemData);
  --   -- elseif self.const_propIDs[1]==id then
  --   --   local itemData={UserItemId=v.UserItemId,ItemId=v.ItemId,Count=1,IsBanding=0,IsUsing=0,Place=0};
  --   --   table.insert(t_p,itemData);
  --   -- end
  --   if analysisHas("Zhuangbei_Zhuangbeipeizhibiao",v.ItemId) and 3 < analysis("Zhuangbei_Zhuangbeipeizhibiao",v.ItemId,"quality") then
  --     local itemData={UserItemId=v.UserItemId,ItemId=v.ItemId,Count=1,IsBanding=0,IsUsing=0,Place=0};
  --     table.insert(t,itemData);
  --   end
  -- end
  -- table.sort(t,sf);
  -- table.sort(t_p,sf_p);
  -- for k,v in pairs(t_p) do
  --   table.insert(t,v);
  -- end
  -- data=t;
  table.sort(data, sf);
  local layer;
  self.itemCount = table.getn(data);
  for k,v in pairs(data) do
    if 0==(-1+k)%self.const_grid_column then
      layer=Layer.new();
      layer:initLayer();
      layer:setContentSize(makeSize(-self.const_grid_skew_x+self.const_item_size.width+self.const_grid_skew_x*self.const_grid_column,
                        self.const_grid_skew_y));
      self.scroll_item_layer:addItem(layer);
    end

    local bagItem=BagItem.new();
    bagItem:initialize(v);
    bagItem:setPositionXY(5+(-1+k)%self.const_grid_column*self.const_grid_skew_x,self.const_grid_skew_y-self.const_item_size.height);
    bagItem.touchEnabled=true;
    bagItem.touchChildren=true;
    bagItem:setBackgroundVisible(true);
    local function onBegin(event)
      self.beginX = event.globalPosition.x;
    end
    local function onEnd(event)
      self.endX = event.globalPosition.x;
      if self.beginX and math.abs(self.beginX - self.endX) == 0 then
        self.onTap(self.context,event,bagItem);
      end
    end
    -- bagItem:addEventListener(DisplayEvents.kTouchBegin,onBegin);
    -- bagItem:addEventListener(DisplayEvents.kTouchEnd,onEnd);
    bagItem:addEventListener(DisplayEvents.kTouchTap,self.onTap,self.context,bagItem);
    layer:addChild(bagItem);
  end
end

function ItemsPopLayer:refreshNoneTextField()
  self.context.none_textfield:setString(0 == self.itemCount and "只有紫色及紫色以上的装备才值得分享炫耀好吗~" or "");
end