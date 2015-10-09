--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-21

	yanchuan.xie@happyelements.com
]]

require "core.display.Layer";

AdvacedProgressBar=class(Layer);

function AdvacedProgressBar:ctor()
  self.class=AdvacedProgressBar;
end

function AdvacedProgressBar:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  AdvacedProgressBar.superclass.dispose(self);
end

function AdvacedProgressBar:initialize(skeleton, name, width)
  self:initLayer();
  self.skeleton = skeleton;
  self.name = name;
  print("->",name);
  self.textures = {skeleton:getBoneTextureDisplay(name .. "_left"), nil, skeleton:getBoneTextureDisplay(name .. "_right")};
  self.left_w = self.textures[1]:getContentSize().width;
  self.width = width - self.left_w - self.textures[3]:getContentSize().width;
  if 1 > self.width then
    error("invalid width");
  end
  self:addChild(self.textures[1]);
  self:addChild(self.textures[3]);
  self:setProgress(0);
end

function AdvacedProgressBar:setProgress(value)
  local data = math.ceil(value*self.width/3);
  data = data >= self.width/3 and self.width/3 or data;print(data);
  self:removeChild(self.textures[2]);
  self.textures[2] = self.skeleton:getBoneTexture9Display(self.name .. "_center",nil,data,1);
  self.textures[2]:setPositionX(self.left_w);
  self:addChild(self.textures[2]);
  self.textures[3]:setPositionX(self.textures[2]:getContentSize().width+self.left_w);
  self.textures[1]:setVisible(0 ~= data);
  self.textures[2]:setVisible(0 ~= data);
  self.textures[3]:setVisible(0 ~= data);
end


AdvacedProgressBarDouble=class(Layer);

function AdvacedProgressBarDouble:ctor()
  self.class=AdvacedProgressBarDouble;
end

function AdvacedProgressBarDouble:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  AdvacedProgressBarDouble.superclass.dispose(self);
end

function AdvacedProgressBarDouble:initialize(skeleton, name, skeleton_s, name_s, width)
  self:initLayer();
  self.value = 0;
  self.total = 1;
  self.value_test = 0;
  self.total_test = 1;
  self.progressBar_s = AdvacedProgressBar.new();
  self.progressBar_s:initialize(skeleton_s, name_s, width);
  self:addChild(self.progressBar_s);
  self.progressBar = AdvacedProgressBar.new();
  self.progressBar:initialize(skeleton, name, width);
  self:addChild(self.progressBar);
end

function AdvacedProgressBarDouble:setProgress(value, total)
  self.value = value;
  self.total = total;
  self.progressBar:setProgress(self.value/self.total);
  self.progressBar_s:setProgress(0);
end

function AdvacedProgressBarDouble:rewind()
  self.value_test = 0;
  self.total_test = 1;
  self.progressBar:setVisible(true);
end

function AdvacedProgressBarDouble:setProgressTest(value, total)
  self.value_test = value;
  self.total_test = total;
  if self.total ~= self.total_test then
    self.progressBar:setVisible(false);
  end
  self.progressBar_s:setProgress(self.value_test/self.total_test);
end