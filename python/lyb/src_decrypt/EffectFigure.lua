--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-10

	yanchuan.xie@happyelements.com
]]

EffectFigure=class(Layer);

function EffectFigure:ctor()
  self.class=EffectFigure;
end

function EffectFigure:dispose()
  removeSchedule(self,self.private_on_scheduler);
  removeSchedule(self,self.private_on_scheduler_s);
  self:removeAllEventListeners();
  self:removeChildren();
  EffectFigure.superclass.dispose(self);
end

--type==1 数字 
--type==2 图片数字
function EffectFigure:initialize(effectProxy, type, max, context, callFunction, hasPrefix, isStatic)
  self:initLayer();
  self.effectProxy=effectProxy;
  self.type=type;
  self.max=max;
  self.context=context;
  self.callFunction=callFunction;
	if nil~=hasPrefix then
		
	else
		hasPrefix=true;
	end
	self.hasPrefix=hasPrefix;
  self.isStatic=isStatic;
  self.isNega=0>self.max;
  self.max=math.abs(self.max);
  self.add=self.isStatic and self.max or math.ceil(self.max/30);--1;
  self.num=0;
  self.touchEnabled=false;
  self.touchChildren=false;
  self:setVisible(false);
  if 1==self.type then
    self:private_initialize_by_type_1();
  elseif 2==self.type then
    self:private_initialize_by_type_2();
  end
end

function EffectFigure:getEffectLayer()
  local a=Layer.new();
  a:initLayer();
  local s=tostring(self.num);
  local n=0;
  local t={};
  local prefix=self:getEffectLayerPrefix();
  if prefix then
    table.insert(t,prefix);
  end
  local w=0;
  while n<string.len(s) do
    n=1+n;
    local sprite=self.effectProxy:getBasicSkeleton():getBoneTextureDisplay("num_" .. (self.isNega and "sub_" or "") .. string.sub(s,n,n));
    table.insert(t,sprite);
  end
  for k,v in pairs(t) do
    v:setPositionX(w);
    w=v:getContentSize().width+w;
    a:addChild(v);
  end
  return a;
end

function EffectFigure:getEffectLayerPrefix()
  if self.hasPrefix then
    local prefix=self.effectProxy:getBasicSkeleton():getBoneTextureDisplay(self.isNega and "num_sub" or "num_plus");
    if self.isNega then
      prefix:setPositionY(0);
    else
      prefix:setPositionY(0);
    end
    return prefix;
  end
end

function EffectFigure:getTextPrefix()
  if self.hasPrefix then
    return self.isNega and "-" or "+";
  end
  return "";
end

function EffectFigure:private_initialize_by_type_1()
  self.textField=TextField.new(CCLabelTTF:create(self:getTextPrefix() .. "0",FontConstConfig.OUR_FONT,24));
  self.textField:setColor(CommonUtils:ccc3FromUInt(self.isNega and 16711680 or 65280));
  self:addChild(self.textField);
end

function EffectFigure:private_initialize_by_type_2()
  self:private_on_scheduler_by_type_2();
end

function EffectFigure:private_on_scheduler()
  local a=self.add+self.num;
  if a>self.max then
    self.num=self.max;
  else
  self.num=a;
  end
  if 1==self.type then
    self:private_on_scheduler_by_type_1();
  elseif 2==self.type then
    self:private_on_scheduler_by_type_2();
  end
  if self.max<=self.num then
    addSchedule(self,self.private_on_scheduler_s);
    removeSchedule(self,self.private_on_scheduler);
  end
end

function EffectFigure:private_on_scheduler_s()
  removeSchedule(self,self.private_on_scheduler_s);
  if self.callFunction then
    self.callFunction(self.context);
  end
end

function EffectFigure:private_on_scheduler_by_type_1()
  self.textField:setString(self:getTextPrefix() .. self.num);
end

function EffectFigure:private_on_scheduler_by_type_2()
  if self.effectLayer then
    self:removeChild(self.effectLayer);
    self.effectLayer=nil;
  end
  self.effectLayer=self:getEffectLayer();
  self:addChild(self.effectLayer);
end

function EffectFigure:start()
  addSchedule(self,self.private_on_scheduler);
  self:setVisible(true);
end