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

FacesPopLayer=class(Layer);

function FacesPopLayer:ctor()
  self.class=FacesPopLayer;
end

function FacesPopLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FacesPopLayer.superclass.dispose(self);
end

function FacesPopLayer:initialize(skeleton, context, onTap)
  self:initLayer();
  self.context = context;
  self.const_grid_column=13;
  self.const_grid_row=4;
  self.const_grid_count=self.const_grid_column*self.const_grid_row;
  self.const_grid_skew_x=78;--38;
  self.const_grid_skew_y=72;--40;
  self.const_pos=makePoint(27,49);--makePoint(28,78);
  
  local a=1;
  function onSche()
    local image=Image.new();
    image:load("resource/faces/" .. a .. ".png");
    image:setScale(2);
    image:setPositionXY(self:grid2Mouse(a));
    image:addEventListener(DisplayEvents.kTouchTap,onTap,context,a);
    self:addChild(image);
    a=1+a;
    if 39 == a then
      removeSchedule(nil, onSche);
    end
  end
  addSchedule(nil, onSche);

  self:setPosition(self.const_pos);
end

function FacesPopLayer:grid2Mouse(grid_number)
  grid_number=(grid_number-1)%self.const_grid_count;
  return grid_number%self.const_grid_column*self.const_grid_skew_x,math.floor((-1+self.const_grid_count-grid_number)/self.const_grid_column)*self.const_grid_skew_y;--math.floor(grid_number/self.const_grid_column)*self.const_grid_skew_y;
end

function FacesPopLayer:refreshNoneTextField()
  self.context.none_textfield:setString("");
end