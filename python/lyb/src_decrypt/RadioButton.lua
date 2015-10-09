require "core.display.Layer";
require "core.events.DisplayEvent";

RadioButton=class(Layer);

function RadioButton:ctor()
  self.class=RadioButton;
  self.selected = false;
end

function RadioButton:dispose()
  self.frame=nil;
  self.frameList=nil;
  self.textField=nil;
	self:removeAllEventListeners();
	RadioButton.superclass.dispose(self);
end

function RadioButton:initialize(normal, touch, skeleton_nil)
  
  self.class=RadioButton;
	self.frame={normal,touch};
	self.skeleton=skeleton_nil and skeleton_nil or CommonSkeleton;
  self.frameList={};
  

	-- self:addEventListener(DisplayEvents.kTouchBegin,self.onBegin,self);
	-- self:addEventListener(DisplayEvents.kTouchEnd,self.onEnd,self);
  self:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
  
  self:initLayer();
  local d=self.skeleton:getBoneTextureDisplay(self.frame[1]);
  self.const=d:getContentSize().height;
  table.insert(self.frameList,d);
  self:addChild(self.frameList[1]);
end

function RadioButton:setTouchEnable(touchEnable)
  if touchEnable then
	  self.touchEnabled=true;
    self.touchChildren=true;
    self:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
		-- self:addEventListener(DisplayEvents.kTouchBegin,self.onBegin,self);
		-- self:addEventListener(DisplayEvents.kTouchEnd,self.onEnd,self);
  -- else
	  self:removeAllEventListeners();
    self.touchEnabled=false;
    self.touchChildren=false;
	end 
end

-- function RadioButton:onBegin(event)
--   if self.selected then
--     self:select(false);
--   else
--     self:select(true);
--   end
-- end

function RadioButton:onTap(event)
  self:select(not self.selected);
end

-- function RadioButton:onEnd(event)
--   if self.selected then
--     self.selected = false;
--     self:select(false);
--   else
--     self.selected = true;
--     self:select(true);
--   end
-- end

-- function RadioButton:onEnd(event)
--   self:select(not self.selected);
-- end

function RadioButton:select(slt)
  self.selected = slt;
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
