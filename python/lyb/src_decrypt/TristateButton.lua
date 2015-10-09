--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-17

	yanchuan.xie@happyelements.com
]]

require "core.display.DisplayNode";
require "core.events.DisplayEvent";
require "core.utils.CommonUtil";

TristateButton=class(DisplayNode);

function TristateButton:ctor()
  self.class=TristateButton;
end

function TristateButton:dispose()
	self:removeAllEventListeners();
	TristateButton.superclass.dispose(self);
  for k1,v1 in pairs(self.frameList) do
      v1:dispose()
  end
  self.frame=nil;
  self.frameList=nil;
  self.textField=nil;
end

function TristateButton:initialize(normal, touch, disable, touchable, skeleton_nil)
  
  self.class=TristateButton;
	self.frame={normal,touch, disable};
	self.skeleton=skeleton_nil and skeleton_nil or CommonSkeleton;
  self.frameList={};
  
	if CommonButtonTouchable.BUTTON==touchable then
		self:addEventListener(DisplayEvents.kTouchBegin,self.onNormal,self);
		self:addEventListener(DisplayEvents.kTouchEnd,self.onTouch,self);
  elseif CommonButtonTouchable.DISABLE==touchable then
    self.touchEnabled=false;
    self.touchChildren=false;
	end
  
  self.sprite=CommonSkeleton:getBoneTexture("common_button_bg");
  self.sprite:setAnchorPoint(CCPointMake(0,0));
  table.insert(self.frameList,self.skeleton:getBoneTextureDisplay(self.frame[1]));
  table.insert(self.frameList,self.skeleton:getBoneTextureDisplay(self.frame[2]));
  table.insert(self.frameList,self.skeleton:getBoneTextureDisplay(self.frame[3]));
  self:addChild(self.frameList[1]);
end

function TristateButton:initializeText(text_data, text_string)
  if nil~=text_string then
    if self:contains(self.textField) then
       self:removeChild(self.textField,true);
    end
    self.textField=createTextFieldWithTextData(text_data,text_string);
    self:addChild(self.textField);
  end
end

function TristateButton:onNormal(event)
  self:select(1);
end

function TristateButton:onTouch(event)
  self:select(2);
end

function TristateButton:onDisable(event)
  self:select(3);
end

function TristateButton:select(slt)
  self:removeChildAt(0,false);
	if 2==slt then
		self:addChildAt(self.frameList[2],0);
  elseif 3==slt then 
		self:addChildAt(self.frameList[3],0);
	else
		self:addChildAt(self.frameList[1],0);
	end
end