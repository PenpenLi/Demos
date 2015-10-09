require "core.display.Layer";
require "core.events.DisplayEvent";

CheckBox=class(Layer);

function CheckBox:ctor()
  self.class=CheckBox;
  self.selected = false;
end

function CheckBox:dispose()
  self.frame=nil;
  self.frameList=nil;
  self.textField=nil;
	self:removeAllEventListeners();
	CheckBox.superclass.dispose(self);
end

function CheckBox:initialize(normal, touch, skeleton_nil)
  
  self.class=CheckBox;
	self.frame={normal,touch};
	self.skeleton=skeleton_nil and skeleton_nil or CommonSkeleton;
  self.frameList={};
  

	self:addEventListener(DisplayEvents.kTouchBegin,self.onBegin,self);
	self:addEventListener(DisplayEvents.kTouchEnd,self.onEnd,self);

  
  self:initLayer();
  local d=self.skeleton:getBoneTextureDisplay(self.frame[1]);
  self.const=d:getContentSize().height;
  table.insert(self.frameList,d);
  self:addChild(self.frameList[1]);
end

function CheckBox:setTouchEnable(touchEnable)
  if touchEnable then
	  self.touchEnabled=true;
    self.touchChildren=true;
		self:addEventListener(DisplayEvents.kTouchBegin,self.onBegin,self);
		self:addEventListener(DisplayEvents.kTouchEnd,self.onEnd,self);
  else
	  self:removeAllEventListeners();
    self.touchEnabled=false;
    self.touchChildren=false;
	end 
end
function CheckBox:onBegin(event)
  if self.selected then
    self:select(false);
  else
    self:select(true);
  end

end

function CheckBox:onEnd(event)
  if self.selected then
    self.selected = false;
    self:select(false);
  else
    self.selected = true;
    self:select(true);
  end
end

function CheckBox:select(slt)
  self:removeChildAt(0,false);
	if true==slt then
    if nil==self.frameList[2] then
      table.insert(self.frameList,self.skeleton:getBoneTextureDisplay(self.frame[2]));
    end
		self:addChildAt(self.frameList[2],0);
	else
		self:addChildAt(self.frameList[1],0);
	end
end
