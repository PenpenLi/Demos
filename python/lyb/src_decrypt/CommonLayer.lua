--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-2-26

  yanchuan.xie@happyelements.com
]]

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";

CommonLayer=class(LayerColor);

function CommonLayer:ctor()
  self.class=CommonLayer;
end

function CommonLayer:dispose()
  self.context = nil;
  self.scroll = nil;
  self:removeAllEventListeners();
  self:removeChildren();
  CommonLayer.superclass.dispose(self);
end

function CommonLayer:initialize(width, height, context, begin, tap, scroll)
  self:initLayer();
  self:changeWidthAndHeight(width,height);
  self:setColor(CommonUtils:ccc3FromUInt(0));
  self:setOpacity(0);
  self:addEventListener(DisplayEvents.kTouchBegin,self.onTouchLayerBegin,self);
  
  self.const_begin_out=15;
  self.const_touch=2500;
  self.width=width;
  self.out=0;
  self.beginPos_x=0;
  self.beginPos_y=0;
  self.context=context;
  self.begin=begin;
  self.tap=tap;
  self.scroll=scroll;
end

function CommonLayer:onSche()
  self.out=1+self.out;
  if self.const_begin_out<self.out then
    if self.begin then
      self.begin(self.context,self.beginPos_x,self.beginPos_y);
    end
    self:removeEventListener(DisplayEvents.kTouchEnd,self.onTouchLayerEnd,self);
    self:removeEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
    removeSchedule(self,self.onSche);
  end
end

function CommonLayer:onTouchLayerBegin(event)
  self:addEventListener(DisplayEvents.kTouchEnd,self.onTouchLayerEnd,self);
  self:addEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
  addSchedule(self,self.onSche);
  self.out=0;
  self.beginPos_x,self.beginPos_y=event.globalPosition.x,event.globalPosition.y;
end

function CommonLayer:onTouchLayerEnd(event)
  local a=event.globalPosition.x-self.beginPos_x;
  local b=a*a+(event.globalPosition.y-self.beginPos_y)*(event.globalPosition.y-self.beginPos_y);
  if a>0 then
    if a>self.width/4 then
      if self.scroll then
        self.scroll(self.context,-1);
      end
    elseif b<self.const_touch then
      if self.tap then
        self.tap(self.context,event.globalPosition.x,event.globalPosition.y);
      end
    end
  elseif a<0 then
    if a<-self.width/4 then
      if self.scroll then
        self.scroll(self.context,1);
      end
    elseif b<self.const_touch then
      if self.tap then
        self.tap(self.context,event.globalPosition.x,event.globalPosition.y);
      end
    end
  else
    if event.globalPosition.y==self.beginPos_y and self.tap then
      self.tap(self.context,event.globalPosition.x,event.globalPosition.y);
    end
  end
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onTouchLayerEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
  removeSchedule(self,self.onSche);
end

function CommonLayer:onTouchLayerMove(event)
  local a=event.globalPosition.x-self.beginPos_x;
  local b=a*a+(event.globalPosition.y-self.beginPos_y)*(event.globalPosition.y-self.beginPos_y);
  if b<self.const_touch then
    return;
  end
  self:removeEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
  removeSchedule(self,self.onSche);
end