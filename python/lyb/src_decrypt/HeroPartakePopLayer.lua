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
require "main.view.hero.heroPro.ui.HeroRoundPortrait";

HeroPartakePopLayer=class(Layer);

function HeroPartakePopLayer:ctor()
  self.class=HeroPartakePopLayer;
end

function HeroPartakePopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HeroPartakePopLayer.superclass.dispose(self);
end

function HeroPartakePopLayer:initialize(skeleton, context, onTap, heroHouseProxy)
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
  self.heroHouseProxy=heroHouseProxy;
  self:setPosition(self.const_pos);
end

function HeroPartakePopLayer:refreshItems()
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

  local data = self.heroHouseProxy:getGeneralArray();
  local temp = {};
  for k,v in pairs(data) do
  	if 0 == v.IsMainGeneral and 2 < v.StarLevel then
  		table.insert(temp, v);
  	end
  end
  data = temp;
  self.heroPartakeCount = table.getn(data);
  for k,v in pairs(data) do
    if 1 == v.IsMainGeneral then
      table.remove(data, k);
      break;
    end
  end
  local function sortFunc(data_a, data_b)
    local itemsData1 = analysis("Kapai_Kapaiku", data_a.ConfigId)--卡牌库
    local itemsData2 = analysis("Kapai_Kapaiku", data_b.ConfigId)--卡牌库
    if data_a.IsMainGeneral > data_b.IsMainGeneral then
      return true;
    elseif data_a.IsMainGeneral < data_b.IsMainGeneral then
      return false;
    end
    if itemsData1.star > itemsData2.star then
        return true;
    elseif itemsData1.star < itemsData2.star then
        return false;
    end
    if data_a.Grade > data_b.Grade then
        return true;
    elseif data_a.Grade < data_b.Grade then
        return false;
    end
    return data_a.ConfigId > data_b.ConfigId;
  end
  table.sort(data,sortFunc);
  local layer;
  for k,v in pairs(data) do
    if 0==(-1+k)%self.const_grid_column then
      layer=Layer.new();
      layer:initLayer();
      layer:setContentSize(makeSize(-self.const_grid_skew_x+self.const_item_size.width+self.const_grid_skew_x*self.const_grid_column,
                        self.const_grid_skew_y));
      self.scroll_item_layer:addItem(layer);
    end

    -- local img = Image.new();
    -- img:loadByArtID(analysis("Kapai_Kapaiku",v.ConfigId,"art"));
    -- img:setScaleX(108/142);
    -- img:setScaleY(108/174);
    -- img:setPositionX((-1+k)%self.const_grid_column*113);
    -- img:addEventListener(DisplayEvents.kTouchTap,self.onTap,self.context,v);
    -- layer:addChild(img);

    local function onBegin(event)
      self.beginX = event.globalPosition.x;
    end
    local function onEnd(event)
      self.endX = event.globalPosition.x;
      if self.beginX and math.abs(self.beginX - self.endX) < 5 then
        self.onTap(self.context,event,v);
      end
    end

    local portrait = HeroRoundPortrait.new();
    portrait:initialize(v,true);
    portrait:setScale(0.8);
    portrait:setPositionXY((-1+k)%self.const_grid_column*113,13);
    portrait:addEventListener(DisplayEvents.kTouchBegin,onBegin);
    portrait:addEventListener(DisplayEvents.kTouchEnd,onEnd);
    layer:addChild(portrait);
  end
end

function HeroPartakePopLayer:refreshNoneTextField()
  self.context.none_textfield:setString(0 == self.heroPartakeCount and "只有三星以上的英雄才可以分享嘞~" or "");
end